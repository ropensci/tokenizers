simplify_list <- function(x, simplify) {
  stopifnot(is.logical(simplify))
  if (simplify & length(x) == 1) x[[1]] else x
}

check_input <- function(x) {
  check_character <- is.character(x) |
  if (is.list(x)) {
       check_list <- all(vapply(x, is.character, logical(1))) &
         all(vapply(x, length, integer(1)) == 1L)
  } else {
    check_list <- FALSE
  }
  if (!(check_character | check_list))
    stop("Input must be a character vector of any length or a list of character\n",
         "  vectors, each of which has a length of 1.")
}

remove_stopwords <- function(x, stopwords) {
  x[!x %in% stopwords]
}
