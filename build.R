#! /usr/bin/env Rscript

#### Check dependencies ####
cat("\n\nChecking if bookdown is installed…\n")
if (!("bookdown" %in% installed.packages())) {
  install.packages("bookdown")
}

#### Save config for stuff ####
bookdown_yml <- yaml::yaml.load_file(rprojroot::find_rstudio_root_file("_bookdown.yml"))

out_dir   <- bookdown_yml$output_dir
debug_out <- paste0(bookdown_yml$book_filename, ".Rmd")

#### Clean up artifacts that cause problems ####
cat("Cleaning up potential debug files…\n")

if (file.exists(debug_out)) {
  file.remove(debug_out)
}

#### Move images/CSS dir to output ####
cat("Moving images and CSS directory to output dir\n")
status <- file.copy("css", out_dir, overwrite = T, recursive = T)
if (all(status)) {
  cat("Successfully copied CSS dir\n")
} else {
  warning("Something didn't work right!")
}
status <- file.copy("images", out_dir, overwrite = T, recursive = T)
if (all(status)) {
  cat("Successfully copied CSS dir\n")
} else {
  warning("Something didn't work right!")
}

#### Render things ####
cat("Rendering things\n")

# Build Website
cat("Rendering website…\n")
bookdown::render_book(input = ".",
                      output_format = "bookdown::gitbook",
                      clean_envir = F, quiet = TRUE)

# Build EPUB
out_epub <- paste0(out_dir, "/", bookdown_yml$book_filename, ".epub")

if (file.exists(out_epub)) {
  age <- as.numeric(difftime(Sys.time(), file.mtime(out_epub), units = "d"))
} else {
  age <- NULL
}

if (is.null(age) || age > 1) {
  cat("Rendering epub…")
  bookdown::render_book(input = ".",
                        output_format = "bookdown::epub_book",
                        clean_envir = F, quiet = TRUE)
  cat("Done rendering.\n")
}

#### Prepare to copy to output ####
cat("Checking who you are…\n")

current_user <- Sys.info()[["user"]]

cat(paste0("I hope you're really ", current_user), "\n")

if (current_user == "Lukas") {
  book_dir  <- "~/Sync/public.tadaa-data.de/r-intro/book"
} else if (current_user == "tobi") {
  book_dir  <- "~/Dokumente/syncthing/public.tadaa-data.de/r-intro/book"
} else {
  book_dir <-  NA
}

#### Copy to output ####
cat("Copying stuff…\n")

if (is.na(book_dir)) {
  warning("No output directory defined, leaving everything as is.")
} else {
  # Copy book
  files <- list.files(path = out_dir, full.names = T)
  status <- file.copy(files, book_dir, overwrite = TRUE, recursive = TRUE)
  if (all(status)) {
    cat("Worked allright\n")
  } else {
    warning("Something didn't work right!")
  }
}

#### Done ####
cat("All done!\n")
cat(format(Sys.time(), "%F, %T"), "\n")

# Cleanup, just in case
rm(bookdown_yml, out_dir, status, debug_out, current_user)
