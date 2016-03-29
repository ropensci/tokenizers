simplify_list <- function(x, simplify) {
  stopifnot(is.logical(simplify))
  if (simplify & length(x) == 1) x[[1]] else x
}
