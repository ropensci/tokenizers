#' N-gram tokenizers
#'
#' These functions tokenize their inputs into different kinds of n-grams. The
#' input can be a character vector of any length, or a list of character vectors
#' where each character vector in the list has a length of 1. See details for an
#' explanation of what each function does.
#'
#' @details
#'
#' \describe{ \item{\code{tokenize_ngrams}:}{ Basic shingled n-grams. A
#' contiguous subsequence of \code{n} words. This will compute shingled n-grams
#' for every value of between \code{n_min} (which must be at least 1) and
#' \code{n}. } \item{\code{tokenize_skip_ngrams}:}{Skip n-grams. A subsequence
#' of \code{n} words which are at most a gap of \code{k} words between them. The
#' skip n-grams will be calculated for all values from \code{0} to \code{k}. } }
#'
#' These functions will strip all punctuation and normalize all whitespace to a
#' single space character.
#'
#' @param x A character vector or a list of character vectors to be tokenized
#'   into n-grams. If \code{x} is a character vector, it can be of any length,
#'   and each element will be tokenized separately. If \code{x} is a list of
#'   character vectors, each element of the list should have a length of 1.
#' @param n The number of words in the n-gram. This must be an integer greater
#'   than or equal to 1.
#' @param n_min This must be an integer greater than or equal to 1, and less
#'   than or equal to \code{n}.
#' @param k For the skip n-gram tokenizer, the maximum skip distance between
#'   words. The function will compute all skip n-grams between \code{0} and
#'   \code{k}.
#' @param lowercase Should the tokens be made lower case?
#' @param stopwords A character vector of stop words to be excluded from the
#'   n-grams.
#' @param ngram_delim The separator between words in an n-gram.
#' @param simplify \code{FALSE} by default so that a consistent value is
#'   returned regardless of length of input. If \code{TRUE}, then an input with
#'   a single element will return a character vector of tokens instead of a
#'   list.
#'
#' @return A list of character vectors containing the tokens, with one element
#'   in the list for each element that was passed as input. If \code{simplify =
#'   TRUE} and only a single element was passed as input, then the output is a
#'   character vector of tokens.
#'
#' @examples
#' song <-  paste0("How many roads must a man walk down\n",
#'                 "Before you call him a man?\n",
#'                 "How many seas must a white dove sail\n",
#'                 "Before she sleeps in the sand?\n",
#'                 "\n",
#'                 "How many times must the cannonballs fly\n",
#'                 "Before they're forever banned?\n",
#'                 "The answer, my friend, is blowin' in the wind.\n",
#'                 "The answer is blowin' in the wind.\n")
#'
#' tokenize_ngrams(song, n = 4)
#' tokenize_ngrams(song, n = 4, n_min = 1)
#' tokenize_skip_ngrams(song, n = 4, k = 2)
#' @name ngram-tokenizers

#' @export
#' @rdname ngram-tokenizers
tokenize_ngrams <- function(x,
                            lowercase = TRUE,
                            n = 3L,
                            n_min = n,
                            stopwords = character(),
                            ngram_delim = " ",
                            simplify = FALSE) {
  UseMethod("tokenize_ngrams")
}

#' @export
tokenize_ngrams.data.frame <-
  function(x,
           lowercase = TRUE,
           n = 3L,
           n_min = n,
           stopwords = character(),
           ngram_delim = " ",
           simplify = FALSE) {
    x <- corpus_df_as_corpus_vector(x)
    tokenize_ngrams(x, lowercase, n, n_min, stopwords, ngram_delim, simplify)
  }

#' @export
tokenize_ngrams.default <-
  function(x,
           lowercase = TRUE,
           n = 3L,
           n_min = n,
           stopwords = character(),
           ngram_delim = " ",
           simplify = FALSE) {
    check_input(x)
    named <- names(x)
    if (n < n_min || n_min <= 0)
      stop("n and n_min must be integers, and n_min must be less than ",
           "n and greater than 1.")
    words <- tokenize_words(x, lowercase = lowercase)
    out <-
      generate_ngrams_batch(
        words,
        ngram_min = n_min,
        ngram_max = n,
        stopwords = stopwords,
        ngram_delim = ngram_delim
      )
    if (!is.null(named))
      names(out) <- named
    simplify_list(out, simplify)
  }

# Check the skip distance between words, and return FALSE if the skip is bigger
# than k
check_width <- function(v, k) {
  v_lead <- c(v[2:length(v)], NA_integer_)
  all(v_lead - v - 1 <= k, na.rm = TRUE)
}

get_valid_skips <- function(n, k) {
  max_dist <- k * (n - 1) + (n - 1)
  total_combinations <- choose(max_dist, n - 1)
  if (total_combinations > 5e3){
    warning("Input n and k will produce a very large number of skip n-grams")
  }

  # Generate all possible combinations up to the maximum distance
  positions <- utils::combn(max_dist, n - 1, simplify = FALSE)

  # Prepend 0 to represent position of starting word. Use 0 indexed vectors
  # because these vectors go to Rcpp.
  positions <- lapply(positions, function(v) { c(0, v) })

  # Keep only the combination of positions with the correct skip between words
  keepers <- vapply(positions, check_width, logical(1), k)
  positions[keepers]
}

#' @export
#' @rdname ngram-tokenizers
tokenize_skip_ngrams <-
  function(x,
           lowercase = TRUE,
           n_min = 1,
           n = 3,
           k = 1,
           stopwords = character(),
           simplify = FALSE) {
    UseMethod("tokenize_skip_ngrams")
  }

#' @export
tokenize_skip_ngrams.data.frame <-
  function(x,
           lowercase = TRUE,
           n_min = 1,
           n = 3,
           k = 1,
           stopwords = character(),
           simplify = FALSE) {
    x <- corpus_df_as_corpus_vector(x)
    tokenize_skip_ngrams(x, lowercase, n_min, n, k, stopwords, simplify)

  }

#' @export
tokenize_skip_ngrams.default <-
  function(x,
           lowercase = TRUE,
           n_min = 1,
           n = 3,
           k = 1,
           stopwords = character(),
           simplify = FALSE) {
    check_input(x)
    named <- names(x)
    words <- tokenize_words(x, lowercase = lowercase)
    skips <- unique(unlist(
      lapply(n_min:n, get_valid_skips, k),
      recursive = FALSE,
      use.names = FALSE
    ))
    out <- skip_ngrams_vectorised(words, skips, stopwords)
    if (!is.null(named))
      names(out) <- named
    simplify_list(out, simplify)
  }
