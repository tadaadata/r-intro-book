# Set basic things up ----
suppressPackageStartupMessages(library(knitr))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(readr))
suppressPackageStartupMessages(library(tidyr))
suppressPackageStartupMessages(library(car))

knitr::opts_knit$set(unnamed.chunk.label = "chunk_")
knitr::opts_chunk$set(comment = "")

# Read data used throughout tutorial ----
qmsurvey        <- read_rds("data/qm_survey_ss2017.rds")
gotdeaths       <- read_csv("data/got_deaths.csv", col_types = cols())
participation   <- read_rds("data/participation.rds")
gotdeaths_books <- read_csv("data/got_character-deaths.csv", col_types = cols())

# Function to display latest commits ----

get_latest_commit <- function(count = 3) {

  date <- url <- avatar <- author_url <- msg <- NULL

  if (httr::status_code(httr::GET("https://api.github.com")) != "200") {
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

  cat("<strong>Letzte &Auml;nderungen:</strong><br />")
  glue::glue("{date}: <a href='{author_url}'><img src='{avatar}' width='15px' />
             {name}</a> committed: <code><a href='{url}'>\"{msg}\"</a></code><br />")
}
