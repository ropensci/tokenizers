library(stringr)

files <- list.files("data-raw/lucene-stopwords", full.names = TRUE)
languages <- files %>% basename() %>% str_replace("\\.txt", "") %>%
  str_replace("stopwords_", "")
stopword_lists <- lapply(files, readLines) %>%
  lapply(str_subset, pattern = regex("^[^#]"))
names(stopword_lists) <- languages
stopword_lists[["en"]]

devtools::use_data(stopword_lists, internal = TRUE, overwrite = TRUE)