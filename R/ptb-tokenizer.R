#' Penn Tree Bank Tokenizer
#'
#' This function implements the Penn Treebank word tokenizer. This tokenizer
#' uses regular expressions to tokenize text similar to the tokenization used
#' in the Penn Treebank. It assumes that text has already been tokenized into
#' sentences. The tokenizer
#' \itemize{
#' \item{splits common English contractions, e.g. \verb{don't} is tokenized into
#'     \verb{do n't} and \verb{they'll} is tokenized into -> \verb{they 'll},}
#' \item{handles punctuation characters as separate tokens,}
#' \item{splits commas and single quotes off from words, when they followed by whitespace,}
#' \item{splits off periods that occur at the end of the line (sentence).}
#' }
#' @details This function is a port of the Python NLTK version of the Penn Treebank Tokenizer.
#' @param x A character vector or a list of character vectors to be tokenized
#'   into n-grams. If \code{x} is a character vector, it can be of any length,
#'   and each element will be tokenized separately. If \code{x} is a list of
#'   character vectors, where each element of the list should have a length of
#'   1.
#' @param lowercase	Should the tokens be made lower case?
#' @param simplify \code{FALSE} by default so that a consistent value is
#'   returned regardless of length of input. If \code{TRUE}, then an input with
#'   a single element will return a character vector of tokens instead of a
#'   list.
#' @return A list of character vectors containing the tokens, with one element
#'   in the list for each element that was passed as input. If \code{simplify =
#'   TRUE} and only a single element was passed as input, then the output is a
#'   character vector of tokens.
#' @references
#' \itemize{
#' \href{http://www.nltk.org/_modules/nltk/tokenize/treebank.html#TreebankWordTokenizer}{NLTK TreebankWordTokenizer}
#' \href{http://www.cis.upenn.edu/~treebank/tokenizer.sed}{Original sed script}
#' }
#' @importFrom stringi stri_c stri_replace_all_regex stri_trim_both stri_split_regex stri_opts_regex
#' @importFrom stringi stri_trans_tolower
#' @examples
#' song <- list(paste0("How many roads must a man walk down\n",
#'                     "Before you call him a man?"),
#'              paste0("How many seas must a white dove sail\n",
#'                     "Before she sleeps in the sand?\n"),
#'              paste0("How many times must the cannonballs fly\n",
#'                     "Before they're forever banned?\n"),
#'              "The answer, my friend, is blowin' in the wind.",
#'              "The answer is blowin' in the wind.")
#' tokenize_ptb(song)
#' tokenize_ptb(c("Good muffins cost $3.88\nin New York. Please buy me\ntwo of them.\nThanks.",
#'   "They'll save and invest more.",
#'   "hi, my name can't hello,"))
#' @export
#' @rdname ptb-tokenizer
tokenize_ptb <- function(x, lowercase = FALSE, simplify = FALSE) {
  check_input(x)
  named <- names(x)

  CONTRACTIONS2 <-
    c("\\b(can)(not)\\b",
      "\\b(d)('ye)\\b",
      "\\b(gon)(na)\\b",
      "\\b(got)(ta)\\b",
      "\\b(lem)(me)\\b",
      "\\b(mor)('n)\\b",
      "\\b(wan)(na) "
    )
  CONTRACTIONS3 <-
    c(" ('t)(is)\\b",
      " ('t)(was)\\b")

  CONTRACTIONS4 <-
    c("\\b(whad)(dd)(ya)\\b",
      "\\b(wha)(t)(cha)\\b")

  out <- x

  if (lowercase) {
    x <- stri_trans_tolower(x)
  }


  # Starting quotes
  out <- stri_replace_all_regex(out, '^\\"', '``')
  out <- stri_replace_all_regex(out, '(``)', '$1')
  out <- stri_replace_all_regex(out, '([ (\\[{<])"', '$1 `` ')
  # Punctuation
  out <- stri_replace_all_regex(out, '([:,])([^\\d])', ' $1 $2')
  out <- stri_replace_all_regex(out, '\\.{3}', ' ... ')
  out <- stri_replace_all_regex(out, '([,;@#$%&])', ' $1 ')
  out <- stri_replace_all_regex(out,
                                '([^\\.])(\\.)([\\]\\)}>"\\\']*)?\\s*$',
                                '$1 $2$3 ')
  out <- stri_replace_all_regex(out, '([?!])', ' $1 ')

  out <- stri_replace_all_regex(out, "([^'])' ", "$1 ' ")
  # re.sub\\(r(['"].*?['"]), r(["'].*?['"]), text\\)

  # parens, brackets, etc
  out <- stri_replace_all_regex(out, '([\\]\\[\\(\\)\\{\\}\\<\\>])', ' $1 ')
  out <- stri_replace_all_regex(out, '--', ' -- ')

  # add extra space
  out <- stri_c(" ", out, " ")

  # ending quotes
  out <- stri_replace_all_regex(out, '"', " '' ")
  out <- stri_replace_all_regex(out, "(\\S)('')", "\\1 \\2 ")
  out <- stri_replace_all_regex(out, "([^' ])('[sS]|'[mM]|'[dD]|') ",
                                "$1 $2 ")
  out <- stri_replace_all_regex(out,
                                "([^' ])('ll|'LL|'re|'RE|'ve|'VE|n't|N'T) ",
                                "$1 $2 ")

  stri_replace_all_regex(out, CONTRACTIONS2, " $1 $2 ",
                             opts_regex =
                               stri_opts_regex(case_insensitive = TRUE))
  stri_replace_all_regex(out, CONTRACTIONS3, " $1 $2 ",
                         opts_regex = stri_opts_regex(case_insensitive = TRUE))
  stri_replace_all_regex(out, CONTRACTIONS4, " $1 $2 $3 ",
                         opts_regex = stri_opts_regex(case_insensitive = TRUE))

  # return
  out <- stri_split_regex(stri_trim_both(out), '\\s+')
  if (!is.null(named)) {
    names(out) <- named
  }
  simplify_list(out, simplify)
}
