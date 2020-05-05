#! /usr/bin/env Rscript
# This build script is for local rendering only
# Mini-dependency-check for build script
build_deps <- c("cliapp", "desc", "yaml", "remotes", "fs")

for (pkg in build_deps) {
  if (!(pkg %in% installed.packages())) install.packages(pkg)
}

library(cliapp)
start_app(theme = simple_theme(dark = TRUE))

t1 <- Sys.time()
cli_h1("{format(Sys.time(), '%b. %d, %T')}")

# Check dependencies ----
cli_alert_info("Checking if project dependencies are installed...")

# Set mirror, just in case
# options(repos = c(CRAN = "https://cloud.r-project.org"))
#
# cran_pkgs <- desc::desc_get_deps("DESCRIPTION")$package
# gh_pkgs <- desc::desc_get_remotes("DESCRIPTION")
#
# for (pkg in cran_pkgs) {
#   if (!(pkg %in% installed.packages())) install.packages(pkg)
# }
#
# for (pkg in gh_pkgs) {
#   remotes::install_github(pkg, upgrade = "always", quiet = TRUE)
# }

# Save config for stuff ----
bookdown_yml <- yaml::yaml.load_file("_bookdown.yml")

out_dir   <- bookdown_yml$output_dir
debug_out <- paste0(bookdown_yml$book_filename, ".Rmd")
out_pdf   <- paste0(out_dir, "/", bookdown_yml$book_filename, ".pdf")
out_epub  <- paste0(out_dir, "/", bookdown_yml$book_filename, ".epub")

# Cleanup ----
cli_alert_info("Removing previous build output and intermediates")
# if (fs::dir_exists(out_dir))  fs::dir_delete(out_dir)
if (fs::file_exists(debug_out)) fs::file_delete(debug_out)
# if (fs::dir_exists("r-intro_files"))  fs::dir_delete("r-intro_files")

fs::file_delete(fs::dir_ls(
  regexp = "\\.aux$|\\.ind$|\\.pdf$|\\.idx$|\\.log$|\\.tex$|\\.ilg$|\\.out$|\\.toc$"
))

cli_h2("Rendering documents")
cli_div(id = "list", theme = list(ol = list("margin-left" = 1)))
cli_ol()

# Gitbook ----
cli_it("Rendering HTML site")
suppressWarnings(bookdown::render_book(
  "index.Rmd", output_format = "bookdown::gitbook", envir = new.env(), quiet = TRUE
)) -> tmp
fs::file_copy("images/tadaa_thin_t.png", file.path(out_dir, "images"), overwrite = TRUE)

# PDF ----
cli_it("Rendering PDF")
suppressWarnings(bookdown::render_book(
  "index.Rmd", output_format = "bookdown::pdf_book", envir = new.env(), quiet = TRUE
)) -> tmp

# EPUB ----
# cli_it("Rendering epub")
# suppressWarnings(bookdown::render_book(
#   "index.Rmd", output_format = "bookdown::epub_book", envir = new.env(), quiet = TRUE
# )) -> tmp

cli_end(id = "list")
cli_alert_success("Done rendering!")

t2 <- Sys.time()
difft <- round(as.numeric(difftime(t2, t1, units = 'secs')), 1)

cli_alert_success("Done! Took {difft} seconds.")
cli_h1("{format(Sys.time(), '%b. %d, %T')}")
