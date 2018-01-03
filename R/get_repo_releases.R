# load libs ---------------------------------------------------------------

suppressPackageStartupMessages(library(tidyverse))
library(gh)


# get repos ---------------------------------------------------------------

repos <- gh("/orgs/tidyverse/repos", .limit = Inf)


# repo releases  ----------------------------------------------------------

releases <-
  data_frame(
    repo = repos %>% map_chr("name"),
    release = repo %>%
      map(~ gh(repo = .x, endpoint = "/repos/tidyverse/:repo/releases",
               .limit = Inf))
  )

# release names and dates -------------------------------------------------

flat_release <- flatten(releases$release)
# filter to list responses (length 17)
flat_release <- flat_release[lapply(flat_release, length) > 1]

releases_df <- data_frame(
  release_name = flat_release %>%
    map_chr("name"),
  date = flat_release %>%
    map_chr("created_at"),
  url = flat_release %>%
    map_chr("url")
)


rx <- '(\\/(?:[^\\/]*\\/){4}([^\\/]+)\\/)'
# convert date to date & get repo name
releases_df <- releases_df %>%
  mutate(date = as.Date(date)) %>%
  mutate(repo_name = str_match(url, rx)[, 3]) %>%
  select(c("repo_name", "release_name", "date", "url"))


# for one -----------------------------------------------------------------

glue_releases <- gh("/repos/tidyverse/glue/releases")
