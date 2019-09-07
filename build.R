#! /usr/bin/env Rscript
library(cliapp)
start_app(theme = simple_theme(dark = TRUE))

t1 <- Sys.time()
cli_h1("{format(Sys.time(), '%b. %d, %T')}")

# Check dependencies ----
cli_alert_info("Checking if required stuff is installed...")

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
  cli_alert_success("Successfully checked dependencies!\n")
}


# Save config for stuff ----
bookdown_yml <- yaml::yaml.load_file(rprojroot::find_rstudio_root_file("_bookdown.yml"))

out_dir   <- bookdown_yml$output_dir
debug_out <- paste0(bookdown_yml$book_filename, ".Rmd")
out_pdf   <- paste0(out_dir, "/", bookdown_yml$book_filename, ".pdf")
out_epub  <- paste0(out_dir, "/", bookdown_yml$book_filename, ".epub")

# Cleanup ----
cli_alert_info("Removing previously built output")
if (fs::dir_exists("book"))  fs::dir_delete("book")
if (fs::file_exists("r-intro.Rmd")) fs::file_delete("r-intro.Rmd")
if (fs::dir_exists("r-intro_files"))  fs::dir_delete("r-intro_files")

cli_h2("Rendering documents")
cli_div(id = "list", theme = list(ol = list("margin-left" = 1)))
cli_ol()

# Gitbook ----
cli_it("Rendering HTML site")
suppressWarnings(bookdown::render_book(
  "index.Rmd", output_format = "bookdown::gitbook", envir = new.env(), quiet = TRUE
)) -> tmp
fs::file_copy("images/tadaa_thin_t.png", "book/images/", overwrite = TRUE)

# PDF ----
cli_it("Rendering PDF")
suppressWarnings(bookdown::render_book(
  "index.Rmd", output_format = "bookdown::pdf_book", envir = new.env(), quiet = TRUE
)) -> tmp

# EPUB ----
# cli_it("Rendering epub")
# bookdown::render_book(
#   "index.Rmd", output_format = "bookdown::epub_book", envir = new.env(), quiet = TRUE
# ) -> tmp

cli_end(id = "list")
cli_alert_success("Done rendering!")

t2 <- Sys.time()
difft <- round(as.numeric(difftime(t2, t1, units = 'secs')), 1)

cli_alert_success("Done! Took {difft} seconds.")
cli_h1("{format(Sys.time(), '%b. %d, %T')}")


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
