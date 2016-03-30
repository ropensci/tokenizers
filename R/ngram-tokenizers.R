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
#' @return A list of character vectors containing the tokens, with one element
#'   in the list for each element that was passed as input. If `simplify = TRUE`
#'   and only a single element was passed as input, then the output is a
#'   character vector of tokens.
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
tokenize_ngrams <- function(x, lowercase = TRUE, n = 3L, n_min = n,
                            stopwords = character(), ngram_delim = " ",
                            simplify = FALSE) {
  check_input(x)
  named <- names(x)
  if (n < n_min | n_min <= 0)
    stop("n and n-gram min must be integers, and ngram_min must be less than ",
         "n and greater than 1.")
  words <- tokenize_words(x, lowercase = lowercase)
  out <- generate_ngrams_batch(words, ngram_min = n_min, ngram_max = n,
                               stopwords = stopwords, ngram_delim = ngram_delim)
  if (!is.null(named)) names(out) <- named
  simplify_list(out, simplify)
}

#' @export
#' @rdname ngram-tokenizers
tokenize_skip_ngrams <- function(x, lowercase = TRUE, n = 3, k = 1,
                                 simplify = FALSE) {
  check_input(x)
  named <- names(x)
  words <- tokenize_words(x, lowercase = lowercase)
  out <- lapply(words, skip_ngrams, n = n, k = k)
  if (!is.null(named)) names(out) <- named
  simplify_list(out, simplify)
}
