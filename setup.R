# Set basic things up ----
library(knitr)
library(dplyr)
library(readr)
library(tidyr)
# library(car)

# Dummy for renv to ensure ragg
if (requireNamespace("ragg")) "yay"

knitr::opts_chunk$set(
  cache = FALSE,
  eval = FALSE,
  # error = FALSE,
  # warning = FALSE,
  # message = FALSE,
  fig.width = 8,
  fig.asp = 1/1.618,
  fig.align = "center",
  out.width = "90%",
  comment = "#>",
  tidy = FALSE # "formatR",
  # tidy.opts = list(blank = FALSE, width.cutoff = 80)
)

# Plotting ----

# Read data used throughout tutorial ----
gotdeaths       <- read_csv(here::here("data/got_deaths.csv"), col_types = cols())
gotdeaths_books <- read_csv(here::here("data/got_character-deaths.csv"), col_types = cols())

# Function to display latest commits ----

get_latest_commit <- function(count = 3) {

  date <- url <- avatar <- author_url <- msg <- NULL

  gh_status <- httr::status_code(purrr::safely(httr::GET)(("https://api.github.com"))$result)

  if (gh_status != "200") {
    return("(No recent commits to show)")
  }

  index <- seq_len(count)

  commits <- jsonlite::fromJSON("https://api.github.com/repos/tadaadata/r-intro-book/commits")

  name       <- commits$commit$author$name[index]
  name       <- ifelse(name == "jemus42", "Lukas", name)
  name       <- ifelse(name == "MarauderPixie", "Tobi", name)
  date       <- format(lubridate::ymd_hms(commits$commit$author$date[index],
                                          tz = "Europe/Berlin", quiet = TRUE), "%F %H:%M")
  url        <- commits$html_url[index]
  avatar     <- commits$author$avatar_url[index]
  author_url <- commits$author$html_url[index]
  msg        <- commits$commit$message[index]

  tibble(
    Datum = date,
    Committer = name,
    Message = msg
  ) %>%
    kable(caption = "Letzte Änderungen", booktabs = TRUE)
}
