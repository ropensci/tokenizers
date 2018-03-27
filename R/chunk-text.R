#' Chunk text into smaller segments
#'
#' Given a text or vector/list of texts, break the texts into smaller segments
#' each with the same number of words. This allows you to treat a very long
#' document, such as a novel, as a set of smaller documents.
#'
#' @details Chunking the text passes it through \code{\link{tokenize_words}},
#'   which will strip punctuation and lowercase the text unless you provide
#'   arguments to pass along to that function.
#'
#' @param x A character vector or a list of character vectors to be tokenized
#'   into n-grams. If \code{x} is a character vector, it can be of any length,
#'   and each element will be chunked separately. If \code{x} is a list of
#'   character vectors, each element of the list should have a length of 1.
#' @param chunk_size The number of words in each chunk.
#' @param doc_id The document IDs as a character vector. This will be taken from
#'   the names of the \code{x} vector if available. \code{NULL} is acceptable.
#' @param ... Arguments passed on to \code{\link{tokenize_words}}.
#' @examples
#' \dontrun{
#' chunked <- chunk_text(mobydick, chunk_size = 100)
#' length(chunked)
#' chunked[1:3]
#' }
#' @export
chunk_text <- function(x, chunk_size = 100, doc_id = names(x), ...) {
  check_input(x)
  stopifnot(chunk_size > 1)
  if (is.character(x) && length(x) == 1) {
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

  if(length(words) <= chunk_size) {
    chunks <- x
  }

  chunks <- split(words, ceiling(seq_along(words)/chunk_size))

  if (!is.null(doc_id)) {
    num_chars <- stringi::stri_length(length(chunks))
    chunk_ids <- stringi::stri_pad_left(seq(length(chunks)),
                                       width = num_chars, pad = "0")
    names(chunks) <- stringi::stri_c(doc_id, chunk_ids, sep = "-")
  } else {
    names(chunks) <- NULL
  }

  out <- lapply(chunks, stringi::stri_c, collapse = " ")

  out

}
