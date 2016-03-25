#' N-gram tokenizers
#'
#' These functions turn a character vector of any length (or a list of character
#' vectors, where each character vector in the list has a length of 1) into
#' n-grams. See details for an explanation of what each function does.
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
#' @return A character vector containing the n-gram tokens, or a list of
#'   character vectors containing the n-gram tokens.
#' @param x A character vector to be tokenized into n-grams. This character
#'   vector can be of any length, and each element will be tokenized separately.
#'   Or a list of character vectors, where each element has a length of 1.
#' @param n The number of words in the n-gram.
#' @param k For the skip n-gram tokenizer, the maximum skip distance between
#'   words. The function will compute all skip n-grams between \code{0} and
#'   \code{k}.
#' @param n_min For the tokenizer that computes n-grams for a range of \code{n},
#'   the minimum value of \code{n}. This must be an integer greater than or
#'   equal to 1.
#' @param lowercase Should the tokens be made lower case?
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
tokenize_ngrams <- function(x, lowercase = TRUE, n = 3) {
  words <- tokenize_words(x, lowercase = lowercase)

  if (is.character(words))
    out <- shingle_ngrams(words, n = n)
  else if (is.list(words))
    out <- lapply(words, shingle_ngrams, n = n)

  out
}

#' @export
#' @rdname ngram-tokenizers
tokenize_skip_ngrams <- function(x, lowercase = TRUE, n = 3, k = 1) {
  words <- tokenize_words(x, lowercase = lowercase)

  if (is.character(words))
    out <- skip_ngrams(words, n = n, k = k)
  else if (is.list(words))
    out <- lapply(words, skip_ngrams, n = n, k = k)

  out
}

#' @export
#' @rdname ngram-tokenizers
tokenize_range_ngrams <- function(x, n = 3, n_min = 1, lowercase = TRUE) {
  stopifnot(n_min >= 1, n >= n_min)
  n_range <- n:n_min

  words <- tokenize_words(x, lowercase = lowercase)

  if (is.list(words)) {
    out <- lapply(words, apply_range, n_range)
  } else if (is.character(words)) {
    out <- apply_range(words, n_range)
  }

  out
}

apply_range <- function(x, n_range) {
  lapply(n_range, function(n) { shingle_ngrams(x, n = n) }) %>%
    unlist(recursive = FALSE, use.names = FALSE)
}
