# get_issue_labels
# scratch
require(tidyverse)
require(httr)
require(jsonlite)
require(gh)

# run authentication
source(file = here::here("R", "app_auth.R"))

# example with dplyr
dplyr_issues <- gh("/repos/:owner/:repo/issues", owner = "tidyverse", repo = "dplyr")

issue_titles <- vapply(dplyr_issues, "[[", "", "title")
issue_urls <- vapply(dplyr_issues, "[[", "", "url")
issue_titles <- map_chr(dplyr_issues[1:length(dplyr_issues)], "title")
issue_ids <- map_int(dplyr_issues[1:length(dplyr_issues)], "id")
issue_labels <- map(dplyr_issues[1:length(dplyr_issues)], "labels")
