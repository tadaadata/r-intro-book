#! /usr/bin/env Rscript
t_start <- Sys.time()

# Check dependencies ----
cat("\n\nChecking if required stuff is installed...\n")

# Set mirror, just in case
options(repos = c(CRAN = "https://cloud.r-project.org"))

pkgs <- c("bookdown", "svglite", "tadaatoolbox", "sjPlot", "sjmisc", "devtools",
          "haven", "readr", "dplyr", "ggplot2", "scales", "RColorBrewer", "viridis",
          "readxl", "googlesheets", "rpivotTable", "stringr", "tibble", "tidyr", "waffle",
          "praise", "babynames", "magrittr", "ggthemes", "tidyverse", "hrbrthemes",
          "irr", "vcd")

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


# Save config for stuff ----
bookdown_yml <- yaml::yaml.load_file(rprojroot::find_rstudio_root_file("_bookdown.yml"))

out_dir   <- bookdown_yml$output_dir
debug_out <- paste0(bookdown_yml$book_filename, ".Rmd")
out_pdf   <- paste0(out_dir, "/", bookdown_yml$book_filename, ".pdf")
out_epub  <- paste0(out_dir, "/", bookdown_yml$book_filename, ".epub")

# if (!file.exists(out_dir)) {
#   cat("Output directory", out_dir, "doesn't exist, creating that for you...\n")
#   dir.create(out_dir)
# }

# Clean up artifacts that cause problems ----
# cat("Cleaning up potential debug files...\n")
#
# if (file.exists(debug_out)) {
#   cat("Removing", debug_out, "\n")
#   file.remove(debug_out)
# }
# if (file.exists("_bookdown_files")) {
#   cat("Removing \"_bookdown_files\"...\n")
#   unlink("_bookdown_files")
# }
# if (file.exists("assets")) {
#   cat("Removing \"assets\"...\n")
#   unlink("book/assets/")
# }

# htmls <- list.files(pattern = ".html")
# if (length(htmls) != 0) {
#   status <- file.remove(htmls)
#
#   if (all(status)) {
#     cat("Removed html files at root directory...\n")
#   }
# }
# rm(htmls)

# Move images/CSS dir to output ----
# cat("Moving images and CSS directory to output dir\n")
# status <- file.copy("css", out_dir, overwrite = T, recursive = T)
# if (all(status)) {
#   cat("Successfully copied CSS dir\n")
# } else {
#   warning("Something didn't work right!")
# }
# status <- file.copy("images", out_dir, overwrite = T, recursive = T)
# if (all(status)) {
#   cat("Successfully copied images dir\n")
# } else {
#   warning("Something didn't work right!")
# }

# Render things ----
cat("\nRendering things...\n\n")

# Build Website
cat("Rendering website...\n")
bookdown::render_book(
  input = ".", output_format = "bookdown::gitbook", quiet = TRUE, envir = new.env()
)

# Build EPUB
# if (file.exists(out_epub)) {
#   age <- as.numeric(difftime(Sys.time(), file.mtime(out_epub), units = "hours"))
# } else {
#   age <- NULL
# }

# if (is.null(age) || age > 12) {
#   cat("Rendering epub...\n")
#   bookdown::render_book(input = ".",
#                         output_format = "bookdown::epub_book",
#                         clean_envir = FALSE, quiet = quiet)
#   # cat("Converting epub to PDF...\n")
#   # bookdown::calibre(input = out_epub, output = out_pdf)
# }

cat("Rendering PDF...\n")
bookdown::render_book(input = ".", output_format = "bookdown::pdf_book",
                      quiet = FALSE, envir = new.env())

cat("Done rendering\n")

# Final Cleanup ----
# if (file.exists("_bookdown_files")) {
#   cat("Removing \"_bookdown_files\"...\n")
#   unlink("_bookdown_files", recursive = TRUE)
# }

# Done ----
cat("\nAll done!\n")
t_finish <- Sys.time()
t_diff   <- round(as.numeric(difftime(t_finish, t_start, units = "secs")), 0)
cat("Took about", t_diff, "seconds", "\n")
timestamp()


# if (requireNamespace("slackr")) {
#   library(slackr)
#   slackr_setup(config_file = "/opt/tadaadata/.slackr")
#
#   msg <- paste0(lubridate::now(tzone = "CET"),
#                 ": Built https://r-intro.tadaa-data.de/book",
#                 "\n It took about ", t_diff, " seconds.")
#   text_slackr(msg, channel = "#r-intro", username = "tadaabot", preformatted = FALSE)
#
# }
