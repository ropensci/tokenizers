library(stringr)

files <- list.files("data-raw/lucene-stopwords", full.names = TRUE)
languages <- files %>% basename() %>% str_replace("\\.txt", "") %>%
  str_replace("stopwords_", "")
stopwords_lucene <- lapply(files, readLines) %>%
  lapply(str_subset, pattern = regex("^[^#]"))
names(stopword_lists) <- languages

stopwords_jockers <- readLines("data-raw/jockers-stopwords.txt", encoding = "UTF-8")

devtools::use_data(stopwords_lucene, stopwords_jockers,
                   internal = TRUE, overwrite = TRUE)
