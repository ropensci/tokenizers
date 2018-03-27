#' Penn Treebank Tokenizer
#'
#' This function implements the Penn Treebank word tokenizer.
#'
#' @details This tokenizer uses regular expressions to tokenize text similar to
#'   the tokenization used in the Penn Treebank. It assumes that text has
#'   already been split into sentences. The tokenizer does the following:
#'
#'   \itemize{ \item{splits common English contractions, e.g. \verb{don't} is
#'   tokenized into \verb{do n't} and \verb{they'll} is tokenized into ->
#'   \verb{they 'll},} \item{handles punctuation characters as separate tokens,}
#'   \item{splits commas and single quotes off from words, when they are
#'   followed by whitespace,} \item{splits off periods that occur at the end of
#'   the sentence.} }
#' @details This function is a port of the Python NLTK version of the Penn
#'   Treebank Tokenizer.
#' @param x A character vector or a list of character vectors to be tokenized
#'   into n-grams. If \code{x} is a character vector, it can be of any length,
#'   and each element will be tokenized separately. If \code{x} is a list of
#'   character vectors, each element of the list should have a length of 1.
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
#' \href{http://www.nltk.org/_modules/nltk/tokenize/treebank.html#TreebankWordTokenizer}{NLTK
#' TreebankWordTokenizer}
#' @importFrom stringi stri_c stri_replace_all_regex stri_trim_both
#'   stri_split_regex stri_opts_regex
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
#' tokenize_ptb(c("Good muffins cost $3.88\nin New York. Please buy me\ntwo of them.",
#'   "They'll save and invest more.",
#'   "Hi, I can't say hello."))
#' @export
#' @rdname ptb-tokenizer
tokenize_ptb <- function(x,
                         lowercase = FALSE,
                         simplify = FALSE) {
  UseMethod("tokenize_ptb")
}

#' @export
tokenize_ptb.data.frame <-
  function(x,
           lowercase = FALSE,
           simplify = FALSE) {
    x <- corpus_df_as_corpus_vector(x)
    tokenize_ptb(x, lowercase, simplify)
  }

#' @export
tokenize_ptb.default <-
  function(x,
           lowercase = FALSE,
           simplify = FALSE) {
    check_input(x)
    named <- names(x)

    CONTRACTIONS2 <-
      c(
        "\\b(can)(not)\\b",
        "\\b(d)('ye)\\b",
        "\\b(gon)(na)\\b",
        "\\b(got)(ta)\\b",
        "\\b(lem)(me)\\b",
        "\\b(mor)('n)\\b",
        "\\b(wan)(na) "
      )
    CONTRACTIONS3 <- c(" ('t)(is)\\b", " ('t)(was)\\b")

    CONTRACTIONS4 <- c("\\b(whad)(dd)(ya)\\b", "\\b(wha)(t)(cha)\\b")

    # Starting quotes
    x <- stri_replace_all_regex(x, '^\\"', '``')
    x <- stri_replace_all_regex(x, '(``)', '$1')
    x <- stri_replace_all_regex(x, '([ (\\[{<])"', '$1 `` ')

    # Punctuation
    x <- stri_replace_all_regex(x, '([:,])([^\\d])', ' $1 $2')
    x <- stri_replace_all_regex(x, '\\.{3}', ' ... ')
    x <- stri_replace_all_regex(x, '([,;@#$%&])', ' $1 ')
    x <- stri_replace_all_regex(x,
                                '([^\\.])(\\.)([\\]\\)}>"\\\']*)?\\s*$',
                                '$1 $2$3 ')
    x <- stri_replace_all_regex(x, '([?!])', ' $1 ')

    x <- stri_replace_all_regex(x, "([^'])' ", "$1 ' ")

    # parens, brackets, etc
    x <-
      stri_replace_all_regex(x, '([\\]\\[\\(\\)\\{\\}\\<\\>])', ' $1 ')
    x <- stri_replace_all_regex(x, '--', ' -- ')

    # add extra space
    x <- stri_c(" ", x, " ")

    # ending quotes
    x <- stri_replace_all_regex(x, '"', " '' ")
    x <- stri_replace_all_regex(x, "(\\S)('')", "\\1 \\2 ")
    x <- stri_replace_all_regex(x, "([^' ])('[sS]|'[mM]|'[dD]|') ",
                                "$1 $2 ")
    x <- stri_replace_all_regex(x,
                                "([^' ])('ll|'LL|'re|'RE|'ve|'VE|n't|N'T) ",
                                "$1 $2 ")

    x <- stri_replace_all_regex(
      x,
      CONTRACTIONS2,
      " $1 $2 ",
      opts_regex =
        stri_opts_regex(case_insensitive = TRUE),
      vectorize_all = FALSE
    )
    x <- stri_replace_all_regex(
      x,
      CONTRACTIONS3,
      " $1 $2 ",
      opts_regex = stri_opts_regex(case_insensitive = TRUE),
      vectorize_all = FALSE
    )
    x <- stri_replace_all_regex(
      x,
      CONTRACTIONS4,
      " $1 $2 $3 ",
      opts_regex = stri_opts_regex(case_insensitive = TRUE),
      vectorize_all = FALSE
    )

    # return
    x <- stri_split_regex(stri_trim_both(x), '\\s+')

    if (lowercase) {
      x <- lapply(x, stri_trans_tolower)
    }

    if (!is.null(named)) {
      names(x) <- named
    }

    simplify_list(x, simplify)

  }
