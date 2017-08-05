#! /usr/bin/env Rscript

bookdown::render_book(input = ".", output_dir = "book", output_format = "all")

current_user <- Sys.info()[["user"]]

if (current_user == "Lukas") {
  book_dir  <- "~/Sync/public.tadaa-data.de/r-intro/book"
} else if (current_user == "tobi") {
  book_dir  <- "~/Dokumente/syncthing/public.tadaa-data.de/r-intro/book"
} else {
  book_dir <-  NA
}

if (is.na(book_dir)) {
  message("No output directory defined, leaving everything as is.")
} else {
  # Copy book
  files <- list.files("book", full.names = T)
  file.copy(files, book_dir, overwrite = TRUE, recursive = TRUE)
}

