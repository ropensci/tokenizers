paths <- list.files(system.file("extdata", package = "tokenizers"),
                    pattern = "\\.txt$", full.names = TRUE)
docs_fail <- lapply(paths, readLines)
docs_l <- lapply(docs_fail, paste, collapse = "\n")
docs_c <- unlist(docs_l)
names(docs_l) <- basename(paths)
names(docs_c) <- basename(paths)

bad_list <- list(a = paste(letters, collapse = " "), b = letters)