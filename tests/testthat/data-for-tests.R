paths <- list.files(system.file("extdata", package = "tokenizers"),
                    pattern = "\\.txt$", full.names = TRUE)
docs_full <- lapply(paths, readLines, encoding = "UTF-8")
docs_l <- lapply(docs_full, paste, collapse = "\n")
# docs_l <- lapply(docs_full, enc2utf8)
docs_c <- unlist(docs_l)
names(docs_l) <- basename(paths)
names(docs_c) <- basename(paths)

bad_list <- list(a = paste(letters, collapse = " "), b = letters)