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
#' contiguous subsequence of \code{n} words. }
#' \item{\code{tokenize_skip_ngrams}:}{Skip n-grams. A subsequence of \code{n}
#' words which are at most a gap of \code{k} words between them. The skip
#' n-grams will be calculated for all values from \code{0} to \code{k}. }
#' \item{\code{tokenize_range_ngrams}:}{Shingled n-grams for a range of
#' \code{n}. This will compute shingled n-grams for every value of between
#' \code{n_min} (which must be at least 1) and \code{n}.} }
#'
#' These functions will strip all punctuation and normalize all whitespace to a
#' single space character.
#'
#' @return A list of character vectors containing the tokens, with one element
#'   in the list for each element that was passed as input. If `simplify = TRUE`
#'   and only a single element was passed as input, then the output is a
#'   character vector of tokens.
#' @param x A character vector or a list of character vectors to be tokenized
#'   into n-grams. If \code{x} is a character vector, it can be of any length,
#'   and each element will be tokenized separately. If \code{x} is a list of
#'   character vectors, where each element of the list should have a length of
#'   1.
#' @param n The number of words in the n-gram.
#' @param k For the skip n-gram tokenizer, the maximum skip distance between
#'   words. The function will compute all skip n-grams between \code{0} and
#'   \code{k}.
#' @param n_min For the tokenizer that computes n-grams for a range of \code{n},
#'   the minimum value of \code{n}. This must be an integer greater than or
#'   equal to 1.
#' @param lowercase Should the tokens be made lower case?
#' @param simplify \code{FALSE} by default so that a consistent value is
#'   returned regardless of length of input. If \code{TRUE}, then an input with
#'   a single element will return a character vector of tokens instead of a
#'   list.
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
#' tokenize_ngrams(song, n = 4) %>% head(10)
#' tokenize_skip_ngrams(song, n = 4, k = 2) %>% head(10)
#' tokenize_range_ngrams(song, n = 8, n_min = 1) %>% head(5)
#' tokenize_range_ngrams(song, n = 8, n_min = 1) %>% tail(5)
#'
#' song %>%
#'   tokenize_sentences() %>%
#'   tokenize_ngrams(n = 5) %>%
#'   head(2)
#' @name ngram-tokenizers

#' @export
#' @rdname ngram-tokenizers
tokenize_ngrams <- function(x, lowercase = TRUE, n = 3, simplify = FALSE) {
  words <- tokenize_words(x, lowercase = lowercase)
  out <- lapply(words, shingle_ngrams, n = n)
  if (simplify & length(out) == 1) out[[1]] else out
}

#' @export
#' @rdname ngram-tokenizers
tokenize_skip_ngrams <- function(x, lowercase = TRUE, n = 3, k = 1,
                                 simplify = FALSE) {
  words <- tokenize_words(x, lowercase = lowercase)
  out <- lapply(words, skip_ngrams, n = n, k = k)
  if (simplify & length(out) == 1) out[[1]] else out
}

#' @export
#' @rdname ngram-tokenizers
tokenize_range_ngrams <- function(x, n = 3, n_min = 1, lowercase = TRUE,
                                  simplify = FALSE) {
  stopifnot(n_min >= 1, n >= n_min)
  n_range <- n:n_min
  words <- tokenize_words(x, lowercase = lowercase)
  out <- lapply(words, apply_range, n_range)
  if (simplify & length(out) == 1) out[[1]] else out
}

apply_range <- function(x, n_range) {
  lapply(n_range, function(n) { shingle_ngrams(x, n = n) }) %>%
    unlist(recursive = FALSE, use.names = FALSE)
}
