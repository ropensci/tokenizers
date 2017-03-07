#' Chunk text into smaller segments
#'
#' Given a text or vector/list of texts, break the texts into smaller segments with the same number of words.
#'
#' @param x A character vector or a list of character vectors to be tokenized
#'   into n-grams. If \code{x} is a character vector, it can be of any length,
#'   and each element will be tokenized separately. If \code{x} is a list of
#'   character vectors, each element of the list should have a length of 1.
#' @param chunk_size The number of words in each chunk.
#' @param doc_id The document IDs as a character vector. This will be taken from the names of the \code{x} vector if available. \code{NULL} is acceptable.
#' @param ... Arguments passed on to \code{\link{tokenize_words}}.
#' @examples
#' chunked <- chunk_text(mobydick, chunk_size = 100)
#' length(chunked)
#' chunked[1:3]
#' @export
chunk_text <- function(x, chunk_size = 100, doc_id = names(x), ...) {
  check_input(x)
  stopifnot(chunk_size > 1)
  if(is.character(x) && length(x) == 1) {
    out <- chunk_individual_text(x = x, chunk_size = chunk_size,
                                 doc_id = doc_id, ...)
  } else {
    out <- lapply(seq_along(x), function(i) {
      chunk_individual_text(x = x[[i]], chunk_size = chunk_size,
                            doc_id = doc_id[[i]], ...)
    })
    out <- unlist(out, recursive = FALSE, use.names = TRUE)
  }
  out
}

chunk_individual_text <- function(x, chunk_size, doc_id, ...) {
  stopifnot(is.character(x),
            length(x) == 1)
  words <- tokenize_words(x, simplify = TRUE, ...)
  stopifnot(length(words) > chunk_size)
  chunks <- split(words, ceiling(seq_along(words)/chunk_size))
  if (!is.null(doc_id)) {
    num_chars <- stringr::str_length(length(chunks))
    chunk_ids <- stringr::str_pad(seq(length(chunks)), num_chars, pad = "0")
    names(chunks) <- stringr::str_c(doc_id, chunk_ids, sep = "-")
  } else {
    names(chunks) <- NULL
  }
  out <- lapply(chunks, stringr::str_c, collapse = " ")
  out
}
