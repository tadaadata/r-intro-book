#! /usr/bin/env Rscript

message("Cleaning up potential debug files…")

if (file.exists("r-intro.Rmd")) {
  file.remove("r-intro.Rmd")
}

print("Rendering book…")
# Build Website
bookdown::render_book(input = ".", output_dir = "book", output_format = "bookdown::gitbook")

# Build PDF
# bookdown::render_book(input = ".", output_dir = "book", output_format = "bookdown::pdf_book")

# Build EPUB
bookdown::render_book(input = ".", output_dir = "book", output_format = "bookdown::epub_book")

print("Checking who you are…")

current_user <- Sys.info()[["user"]]

print(paste0("Presumably you're ", current_user,
             ", I guess. If not, please check things."))

if (current_user == "Lukas") {
  book_dir  <- "~/Sync/public.tadaa-data.de/r-intro/book"
} else if (current_user == "tobi") {
  book_dir  <- "~/Dokumente/syncthing/public.tadaa-data.de/r-intro/book"
} else {
  book_dir <-  NA
}

print("Copying stuff…")

if (is.na(book_dir)) {
  warning("No output directory defined, leaving everything as is.")
} else {
  # Copy book
  files <- list.files("book", full.names = T)
  status <- file.copy(files, book_dir, overwrite = TRUE, recursive = TRUE)
  if (all(status)) {
    print("Successfully copied stuff!")
  } else {
    warning("Something didn't work right!")
  }
}

print("All done!")
print(Sys.time())
