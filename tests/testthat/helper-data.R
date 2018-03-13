paths <- list.files(".", pattern = "\\.txt$", full.names = TRUE)
docs_full <- lapply(paths, readLines, encoding = "UTF-8")
docs_l <- lapply(docs_full, paste, collapse = "\n")
# docs_l <- lapply(docs_full, enc2utf8)
docs_c <- unlist(docs_l)
names(docs_l) <- basename(paths)
names(docs_c) <- basename(paths)
docs_df <- data.frame(doc_id = names(docs_c),
                      text = unname(docs_c),
                      stringsAsFactors = FALSE)

bad_list <- list(a = paste(letters, collapse = " "), b = letters)

# Using this sample sentence only because it comes from the paper where
# skip n-grams are defined. Not my favorite sentence.
input <- "Insurgents killed in ongoing fighting."

bigrams <- c("insurgents killed", "killed in", "in ongoing", "ongoing fighting")

skip2_bigrams <- c("insurgents killed", "insurgents in", "insurgents ongoing",
                   "killed in", "killed ongoing", "killed fighting",
                   "in ongoing", "in fighting", "ongoing fighting")

trigrams <- c("insurgents killed in", "killed in ongoing", "in ongoing fighting")

skip2_trigrams <- c("insurgents killed in", "insurgents killed ongoing",
                    "insurgents killed fighting", "insurgents in ongoing",
                    "insurgents in fighting", "insurgents ongoing fighting",
                    "killed in ongoing", "killed in fighting",
                    "killed ongoing fighting", "in ongoing fighting")
