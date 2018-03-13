is_corpus_df <- function(corpus) {
  stopifnot(inherits(corpus, "data.frame"),
            ncol(corpus) >= 2,
            all(names(corpus)[1L:2L] == c("doc_id", "text")),
            is.character(corpus$doc_id),
            is.character(corpus$doc_id),
            nrow(corpus) > 0)
  TRUE # if it doesn't fail from the tests above then it fits the standard
}

corpus_df_as_corpus_vector <- function(corpus) {
  if (is_corpus_df(corpus)) {
    out <- corpus$text
    names(out) <- corpus$doc_id
  } else {
    stop("Not a corpus data.frame")
  }
  out
}
