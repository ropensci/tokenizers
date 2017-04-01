mobydick <- readr::read_file("data-raw/moby-dick.txt")
names(mobydick) <- "mobydick"
devtools::use_data(mobydick, overwrite = TRUE)
