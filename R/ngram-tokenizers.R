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
#' n-grams will be calculated for all values from \code{0} to \code{k}. } }
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
