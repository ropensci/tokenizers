#' Basic tokenizers
#'
#' These functions perform basic tokenization into words, sentences, paragraphs,
#' lines, and characters. The functions can be piped into one another to create
#' at most two levels of tokenization. For instance, one might split a text into
#' paragraphs and then word tokens, or into sentences and then word tokens.
#'
#' @name basic-tokenizers
#' @param x A character vector or a list of character vectors to be tokenized
#'   into n-grams. If \code{x} is a character vector, it can be of any length,
#'   and each element will be tokenized separately. If \code{x} is a list of
#'   character vectors, where each element of the list should have a length of
#'   1.
#' @param lowercase Should the tokens be made lower case? The default value
#'   varies by tokenizer; it is only \code{TRUE} by default for the tokenizers
#'   that you are likely to use last.
#' @param strip_non_alphanum Should punctuation and white space be stripped?
#' @param strip_punctuation Should punctuation be stripped?
#' @param paragraph_break A string identifying the boundary between two
#'   paragraphs.
#' @param stopwords A character vector of stop words to be excluded
#' @param pattern A regular expression that defines the split
#' @param simplify \code{FALSE} by default so that a consistent value is
#'   returned regardless of length of input. If \code{TRUE}, then an input with
#'   a single element will return a character vector of tokens instead of a
#'   list.
#' @return A list of character vectors containing the tokens, with one element
#'   in the list for each element that was passed as input. If `simplify = TRUE`
#'   and only a single element was passed as input, then the output is a
#'   character vector of tokens.
#' @importFrom stringi stri_split_boundaries stri_trans_tolower stri_trim_both
#'   stri_replace_all_charclass stri_split_fixed stri_split_lines
#'   stri_split_regex
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
#' tokenize_characters(song)
#' tokenize_regex("A,B,C,D,E", pattern = ",")
NULL

#' @export
#' @rdname basic-tokenizers
tokenize_characters <- function(x, lowercase = TRUE, strip_non_alphanum = TRUE,
                           simplify = FALSE) {
  check_input(x)
  named <- names(x)
  if (lowercase)
    x <- stri_trans_tolower(x)
  if (strip_non_alphanum)
    x <- stri_replace_all_charclass(x, "[[:punct:][:whitespace:]]", "")
  out <- stri_split_boundaries(x, type = "character")
  if (!is.null(named)) names(out) <- named
  simplify_list(out, simplify)
}

#' @export
#' @rdname basic-tokenizers
tokenize_words <- function(x, lowercase = TRUE, stopwords = NULL,
                           simplify = FALSE) {
  check_input(x)
  named <- names(x)
  if (lowercase) x <- stri_trans_tolower(x)
  out <- stri_split_boundaries(x, type = "word", skip_word_none = TRUE)
  if (!is.null(named)) names(out) <- named
  if (!is.null(stopwords)) out <- lapply(out, remove_stopwords, stopwords)
  simplify_list(out, simplify)
}

#' @export
#' @rdname basic-tokenizers
tokenize_sentences <- function(x, lowercase = FALSE, strip_punctuation = FALSE,
                               simplify = FALSE) {
  check_input(x)
  named <- names(x)
  x <- stri_replace_all_charclass(x, "[[:whitespace:]]", " ")
  out <- stri_split_boundaries(x, type = "sentence", skip_word_none = FALSE)
  out <- lapply(out, stri_trim_both)
  if (lowercase) out <- lapply(out, stri_trans_tolower)
  if (strip_punctuation)
    out <- lapply(out, stri_replace_all_charclass, "[[:punct:]]", "")
  if (!is.null(named)) names(out) <- named
  simplify_list(out, simplify)
}

#' @export
#' @rdname basic-tokenizers
tokenize_lines <- function(x, simplify = FALSE) {
  check_input(x)
  named <- names(x)
  out <- stri_split_lines(x, omit_empty = TRUE)
  if (!is.null(named)) names(out) <- named
  simplify_list(out, simplify)
}

#' @export
#' @rdname basic-tokenizers
tokenize_paragraphs <- function(x, paragraph_break = "\n\n", simplify = FALSE) {
  check_input(x)
  named <- names(x)
  out <- stri_split_fixed(x, pattern = paragraph_break, omit_empty = TRUE)
  out <- lapply(out, stri_replace_all_charclass, "[[:whitespace:]]", " ")
  if (!is.null(named)) names(out) <- named
  simplify_list(out, simplify)
}

#' @export
#' @rdname basic-tokenizers
tokenize_regex <- function(x, pattern = "\\s+", simplify = FALSE) {
  check_input(x)
  named <- names(x)
  out <- stri_split_regex(x, pattern = pattern, omit_empty = TRUE)
  if (!is.null(named)) names(out) <- named
  simplify_list(out, simplify)
}