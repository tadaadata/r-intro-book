#! /usr/bin/env Rscript

t_start <- Sys.time()

#### Check dependencies ####
cat("\n\nChecking if required stuff is installed…\n")

pkgs <- c("bookdown", "svglite", "tadaatoolbox", "sjPlot", "sjmisc", "devtools",
          "haven", "readr", "dplyr", "ggplot2", "scales", "RColorBrewer", "viridis",
          "readxl", "googlesheets", "rpivotTable", "stringr", "tibble", "tidyr", "waffle",
          "praise", "babynames", "magrittr", "ggthemes", "tidyverse")

sapply(pkgs, function(pkg) {
  if (!(pkg %in% installed.packages())) {
    install.packages(pkg)
  } else {
    TRUE
  }
}, USE.NAMES = FALSE) -> status

if (all(status)) {
  cat("Successfully checked dependencies!\n")
}

#### Save config for stuff ####
bookdown_yml <- yaml::yaml.load_file(rprojroot::find_rstudio_root_file("_bookdown.yml"))

out_dir   <- bookdown_yml$output_dir
debug_out <- paste0(bookdown_yml$book_filename, ".Rmd")
out_pdf   <- paste0(out_dir, "/", bookdown_yml$book_filename, ".pdf")
out_epub  <- paste0(out_dir, "/", bookdown_yml$book_filename, ".epub")

if (!file.exists(out_dir)) {
  cat("Output directory", out_dir, "doesn't exist, creating that for you…\n")
  dir.create(out_dir)
}

#### Clean up artifacts that cause problems ####
cat("Cleaning up potential debug files…\n")

if (file.exists(debug_out)) {
  cat("Removing", debug_out, "\n")
  file.remove(debug_out)
}
if (file.exists("_bookdown_files")) {
  cat("Removing \"_bookdown_files\"…\n")
  system(command = "rm -r _bookdown_files")
}

htmls <- list.files(pattern = ".html")
if (length(htmls) != 0) {
  status <- file.remove(htmls)

  if (all(status)) {
    cat("Removed html files at root directory…\n")
  }
}
rm(htmls)

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
  cat("Successfully copied images dir\n")
} else {
  warning("Something didn't work right!")
}

#### Render things ####
cat("\nRendering things\n")

# Build Website
cat("Rendering website…\n")
bookdown::render_book(input = ".",
                      output_format = "bookdown::gitbook",
                      clean_envir = F, quiet = TRUE)

# Build EPUB
if (file.exists(out_epub)) {
  age <- as.numeric(difftime(Sys.time(), file.mtime(out_epub), units = "hours"))
} else {
  age <- NULL
}

if (is.null(age) || age > 12) {
  cat("Rendering epub…\n")
  bookdown::render_book(input = ".",
                        output_format = "bookdown::epub_book",
                        clean_envir = F, quiet = TRUE)
  cat("Converting epub to PDF…\n")
  bookdown::calibre(input = out_epub, output = out_pdf)
}
cat("Done rendering\n")

#### Prepare to copy to output ####
cat("\nChecking who you are…\n")
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
cat("\nCopying stuff…\n")

if (is.na(book_dir)) {
  warning("No output directory defined, leaving everything as is.")
} else {
  # Copy book
  files <- list.files(path = out_dir, full.names = T)
  status <- file.copy(files, book_dir, overwrite = TRUE, recursive = TRUE)
  if (all(status)) {
    cat("Worked alright\n")
  } else {
    warning("Something didn't work right!")
  }
}

#### Final Cleanup ####
if (file.exists("_bookdown_files")) {
  cat("Removing \"_bookdown_files\"…\n")
  system(command = "rm -r _bookdown_files")
}

#### Done ####
cat("\nAll done!\n")
t_finish <- Sys.time()
t_diff   <- round(as.numeric(difftime(t_finish, t_start, "s")), 0)
cat("Took about", t_diff, "seconds", "\n")
timestamp()

# Cleanup, just in case
rm(pkgs, bookdown_yml, out_dir, status, debug_out,
   current_user, t_diff, t_start, t_finish,
   out_epub, out_pdf)
