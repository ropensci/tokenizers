#' @rdname basic-tokenizers
#' @param strip_url Should URLs (starting with \code{http(s)}) be preserved intact, or
#'   removed entirely?
#' @importFrom stringi stri_split_charclass stri_detect_regex stri_sub
#' @export
#' @examples
#' tokenize_tweets("@rOpenSci and #rstats see: https://cran.r-project.org",
#'                 strip_punct = TRUE)
#' tokenize_tweets("@rOpenSci and #rstats see: https://cran.r-project.org",
#'                 strip_punct = FALSE)
tokenize_tweets <- function(x,
                            lowercase = TRUE,
                            stopwords = NULL,
                            strip_punct = TRUE,
                            strip_url = FALSE,
                            simplify = FALSE) {
  UseMethod("tokenize_tweets")
}

#' @export
tokenize_tweets.data.frame <- function(x,
                                       lowercase = TRUE,
                                       stopwords = NULL,
                                       strip_punct = TRUE,
                                       strip_url = FALSE,
                                       simplify = FALSE) {
  x <- corpus_df_as_corpus_vector(x)
  tokenize_tweets(x, lowercase, stopwords, strip_punct, strip_url, simplify)
}

#' @export
tokenize_tweets.default <- function(x,
                                    lowercase = TRUE,
                                    stopwords = NULL,
                                    strip_punct = TRUE,
                                    strip_url = FALSE,
                                    simplify = FALSE) {
  check_input(x)
  named <- names(x)

  # split on white space
  out <- stri_split_charclass(x, "\\p{WHITE_SPACE}")

  # get document indexes to vectorize tokens
  doc_lengths <- cumsum(lengths(out))
  docindex <- c(0, doc_lengths)
  # convert the list into a vector - avoids all those mapplys
  out <- unlist(out)

  # get the index of twitter hashtags and usernames
  index_twitter <- stri_detect_regex(out, "^#[A-Za-z]+\\w*|^@\\w+")
  # get the index of http(s) URLs
  index_url <- stri_detect_regex(out, "^http")

  if (strip_url) {
    out[index_url] <- ""
  }

  if (lowercase) {
    out[!(index_twitter | index_url)] <-
      stri_trans_tolower(out[!(index_twitter | index_url)])
  }

  if (!is.null(stopwords))
    out <- sapply(out, remove_stopwords, stopwords, USE.NAMES = FALSE)

  if (strip_punct) {
    # split all except URLs, twitter hashtags, and usernames into words.
    out[!index_url & !index_twitter] <-
      stri_split_boundaries(out[!index_url & !index_twitter], type = "word")
    out[!index_url & !index_twitter] <-
      lapply(out[!index_url & !index_twitter], function(toks) {
        stri_replace_all_charclass(toks, "\\p{P}", "")
      })

    # preserve twitter characters, strip all punctuations,
    # then put back the twitter characters.
    twitter_chars <- stri_sub(out[index_twitter], 1, 1)
    out[index_twitter] <-
      stri_replace_all_charclass(out[index_twitter], "\\p{P}", "")
    out[index_twitter] <- paste0(twitter_chars, out[index_twitter])
  }
  else {
    # split all except URLs.
    out[!index_url] <-
      stri_split_boundaries(out[!index_url], type = "word")
    # rejoin the hashtags and usernames
    out[index_twitter] <-
      lapply(out[index_twitter], function(toks) {
        toks[2] <- paste0(toks[1], toks[2])
        toks[-1]
      })
  }

  # convert the vector back to a list
  out <- split(out,
               cut(
                 seq_along(out),
                 docindex,
                 include.lowest = TRUE,
                 labels = named
               ))
  # in case !strip_punct, otherwise has no effect
  out <- lapply(out, unlist)

  names(out) <- named

  # remove any blanks (from removing URLs)
  out <- lapply(out, function(toks)
    toks[toks != "" & !is.na(toks)])

  simplify_list(out, simplify)
}
