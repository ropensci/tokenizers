#' Word stem tokenizer
#'
#' This function turns its input into a character vector of word stems. This is
#' just a wrapper around the \code{\link[SnowballC]{wordStem}} function from the
#' SnowballC package which does the heavy lifting, but this function provides a
#' consistent interface with the rest of the tokenizers in this package. The
#' input can be a character vector of any length, or a list of character vectors
#' where each character vector in the list has a length of 1.
#'
#' @details This function will strip all white space and punctuation and make
#'   all word stems lowercase.
#' @param x A character vector or a list of character vectors to be tokenized
#'   into n-grams. If \code{x} is a character vector, it can be of any length,
#'   and each element will be tokenized separately. If \code{x} is a list of
#'   character vectors, where each element of the list should have a length of
#'   1.
#' @param language The language to use for word stemming. This must be one of
#'   the languages available in the SnowballC package. A list is provided by
#'   \code{\link[SnowballC]{getStemLanguages}}.
#' @param simplify \code{FALSE} by default so that a consistent value is
#'   returned regardless of length of input. If \code{TRUE}, then an input with
#'   a single element will return a character vector of tokens instead of a
#'   list.
#' @return A list of character vectors containing the tokens, with one element
#'   in the list for each element that was passed as input. If `simplify = TRUE`
#'   and only a single element was passed as input, then the output is a
#'   character vector of tokens.
#' @importFrom SnowballC wordStem getStemLanguages
#' @seealso \code{\link[SnowballC]{wordStem}}
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
#' tokenize_word_stems(song)
#'
#' song %>%
#'  tokenize_sentences() %>%
#'  tokenize_word_stems()
#'
#' @export
#' @rdname stem-tokenizers
tokenize_word_stems <- function(x, language = "english", simplify = FALSE) {
  language <- match.arg(language, getStemLanguages())
  words <- tokenize_words(x, lowercase = TRUE)
  out <- lapply(words, wordStem, language = language)
  if (simplify & length(out) == 1) out[[1]] else out
}