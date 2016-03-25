#' Basic tokenizers
#'
#' These functions perform basic tokenization into words, sentences, paragraphs,
#' lines, and characters. The functions can be piped into one another to create
#' at most two levels of tokenization. For instance, one might split a text into
#' paragraphs and then word tokens, or into sentences and then word tokens.
#'
#' @name basic-tokenizers
#' @param x A character vector or list of character vectors to be tokenized.
#' @param lowercase Should the tokens be made lower case? The default value
#'   varies by tokenizer; it is only \code{TRUE} by default for the tokenizers
#'   that you are likely to use last.
#' @param strip_non_alphanum Should punctuation and white space be stripped?
#' @param strip_punctuation Should punctuation be stripped?
#' @param paragraph_break A string identifying the boundary between two
#'   paragraphs.
#' @return A character vector or list of character vectors containing the
#'   tokens.
#' @importFrom stringi stri_split_boundaries stri_trans_tolower stri_trim_both
#'   stri_replace_all_charclass stri_split_fixed stri_split_lines
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
#' tokenize_words(song)
#' tokenize_sentences(song)
#' tokenize_paragraphs(song)
#' tokenize_lines(song)
#' tokenize_chars(song)
#'
#' song %>%
#'   tokenize_paragraphs() %>%
#'   tokenize_sentences()
#'
#' song %>%
#'   tokenize_sentences() %>%
#'   tokenize_words()
NULL


#' @export
#' @rdname basic-tokenizers
tokenize_chars <- function(x, lowercase = TRUE, strip_non_alphanum = TRUE) {
  if (lowercase)
    x <- stri_trans_tolower(x)
  if (strip_non_alphanum)
    x <- stri_replace_all_charclass(x, "[[:punct:][:whitespace:]]", "")
  out <- stri_split_boundaries(x, type = "character")
  if (length(out) == 1) out[[1]] else out
}

#' @export
#' @rdname basic-tokenizers
tokenize_words <- function(x, lowercase = TRUE) {
  if (lowercase) x <- stri_trans_tolower(x)
  out <- stri_split_boundaries(x, type = "word", skip_word_none = TRUE)
  if (length(out) == 1) out[[1]] else out
}

#' @export
#' @rdname basic-tokenizers
tokenize_sentences <- function(x, lowercase = FALSE, strip_punctuation = FALSE) {
  x <- stri_replace_all_charclass(x, "[[:whitespace:]]", " ")
  out <- stri_split_boundaries(x, type = "sentence", skip_word_none = FALSE)
  out <- lapply(out, stri_trim_both)
  if (lowercase)
    out <- lapply(out, stri_trans_tolower)
  if (strip_punctuation)
    out <- lapply(out, stri_replace_all_charclass, "[[:punct:]]", "")
  if (length(out) == 1) out[[1]] else out
}

#' @export
#' @rdname basic-tokenizers
tokenize_lines <- function(x) {
  out <- stri_split_lines(x, omit_empty = TRUE)
  if (length(out) == 1) out[[1]] else out
}

#' @export
#' @rdname basic-tokenizers
tokenize_paragraphs <- function(x, paragraph_break = "\n\n") {
  out <- stri_split_fixed(x, pattern = paragraph_break, omit_empty = TRUE)
  if (length(out) == 1) out[[1]] else out
}
