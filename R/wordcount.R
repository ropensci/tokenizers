#' Count words, sentences, characters
#'
#' Count words, sentences, and characters in input texts. These functions use
#' the \code{stringi} package, so they handle the counting of Unicode strings
#' (e.g., characters with diacritical marks) in a way that makes sense to people
#' counting characters.
#'
#' @param x A character vector or a list of character vectors. If \code{x} is a
#'   character vector, it can be of any length, and each element will be
#'   tokenized separately. If \code{x} is a list of character vectors, each
#'   element of the list should have a length of 1.
#' @return An integer vector containing the counted elements. If the input
#'   vector or list has names, they will be preserved.
#' @rdname word-counting
#' @examples
#' count_words(mobydick)
#' count_sentences(mobydick)
#' count_characters(mobydick)
#' @export
count_words <- function(x) {
  check_input(x)
  named <- names(x)
  out <- stringi::stri_count_words(x)
  if (!is.null(named)) names(out) <- named
  out
}

#' @export
#' @rdname word-counting
count_characters <- function(x) {
  check_input(x)
  named <- names(x)
  out <- stringi::stri_count_boundaries(x,
            opts_brkiter = stringi::stri_opts_brkiter(type = "character")
          )
  if (!is.null(named)) names(out) <- named
  out
}

#' @export
#' @rdname word-counting
count_sentences <- function(x) {
  check_input(x)
  named <- names(x)
  out <- stringi::stri_count_boundaries(x,
          opts_brkiter = stringi::stri_opts_brkiter(type = "sentence")
  )
  if (!is.null(named)) names(out) <- named
  out
}
