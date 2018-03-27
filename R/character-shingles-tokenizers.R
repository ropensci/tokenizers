#' Character shingle tokenizers
#'
#' The character shingle tokenizer functions like an n-gram tokenizer, except
#' the units that are shingled are characters instead of words. Options to the
#' function let you determine whether non-alphanumeric characters like
#' punctuation should be retained or discarded.
#'
#' @param x A character vector or a list of character vectors to be tokenized
#'   into character shingles. If \code{x} is a character vector, it can be of
#'   any length, and each element will be tokenized separately. If \code{x} is a
#'   list of character vectors, each element of the list should have a length of
#'   1.
#' @param n The number of characters in each shingle. This must be an integer
#'   greater than or equal to 1.
#' @param n_min This must be an integer greater than or equal to 1, and less
#'   than or equal to \code{n}.
#' @param lowercase Should the characters be made lower case?
#' @param strip_non_alphanum Should punctuation and white space be stripped?
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
#' x <- c("Now is the hour of our discontent")
#' tokenize_character_shingles(x)
#' tokenize_character_shingles(x, n = 5)
#' tokenize_character_shingles(x, n = 5, strip_non_alphanum = FALSE)
#' tokenize_character_shingles(x, n = 5, n_min = 3, strip_non_alphanum = FALSE)
#'
#' @export
#' @rdname shingle-tokenizers
tokenize_character_shingles <- function(x,
                                        n = 3L,
                                        n_min = n,
                                        lowercase = TRUE,
                                        strip_non_alphanum = TRUE,
                                        simplify = FALSE) {
  UseMethod("tokenize_character_shingles")
}

#' @export
tokenize_character_shingles.data.frame <-
  function(x,
           n = 3L,
           n_min = n,
           lowercase = TRUE,
           strip_non_alphanum = TRUE,
           simplify = FALSE) {
    x <- corpus_df_as_corpus_vector(x)
    tokenize_character_shingles(x, n, n_min, lowercase, strip_non_alphanum, simplify)
  }

#' @export
tokenize_character_shingles.default <-
  function(x,
           n = 3L,
           n_min = n,
           lowercase = TRUE,
           strip_non_alphanum = TRUE,
           simplify = FALSE) {
    check_input(x)
    named <- names(x)
    if (n < n_min || n_min <= 0)
      stop("n and n_min must be integers, and n_min must be less than ",
           "n and greater than 1.")
    chars <- tokenize_characters(x, lowercase = lowercase,
                                 strip_non_alphanum = strip_non_alphanum)
    out <-
      generate_ngrams_batch(
        chars,
        ngram_min = n_min,
        ngram_max = n,
        stopwords = "",
        ngram_delim = ""
      )
    if (!is.null(named))
      names(out) <- named
    simplify_list(out, simplify)
  }
