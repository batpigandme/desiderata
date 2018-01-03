
# load libs ---------------------------------------------------------------

suppressPackageStartupMessages(library(tidyverse))
library(gh)


# get repos ---------------------------------------------------------------

repos <- gh("/orgs/tidyverse/repos", .limit = Inf)


# repo labels -------------------------------------------------------------

labs_df <-
  data_frame(
    repo = repos %>% map_chr("name"),
    labels = repo %>%
      map(~ gh(repo = .x, endpoint = "/repos/tidyverse/:repo/labels",
               .limit = Inf))
  )


# flatten and extract label & repo names ----------------------------------

flat_labs <- flatten(labs_df$labels)
labels_df <- data_frame(
  label_name = flat_labs %>%
    map_chr("name"),
  url = flat_labs %>%
    map_chr("url")
)

# regular expression to get three groups from URL
rx <- '(\\/(?:[^\\/]*\\/){4}([^\\/]+)\\/)'
labels_df <- labels_df %>%
  mutate(repo_name = str_match(url, rx)[, 3]) %>% # take 3rd match
  select(c("repo_name", "label_name", "url"))


# one repo labels ---------------------------------------------------------
# below works, cannot yet figure out how to do it in that original call
dplyr_labs <- gh(endpoint = "/repos/tidyverse/:repo/labels", repo = "dplyr")
dplyr_lab_names <- dplyr_labs %>% map_chr("name")


