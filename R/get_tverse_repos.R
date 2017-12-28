# devtools::install_github("r-lib/gh")
library(tidyverse)
library(gh)

tverse_repos <- gh("/orgs/:org/repos", org = "tidyverse")
vapply(tverse_repos, "[[", "", "name")
repo_names <- vapply(tverse_repos, "[[", "", "name")

ggplot2_issues <- gh("/repos/:owner/:repo/issues", owner = "tidyverse", repo = "ggplot2")
issue_titles <- vapply(ggplot2_issues, "[[", "", "title")

ggplot2_issues2 <- gh("/repos/:owner/:repo/issues", owner = "tidyverse", repo = "ggplot2", page = 2)
issue_titles2 <- vapply(ggplot2_issues2, "[[", "", "title")

library(jsonlite)

# --------------------------- SECOND WAY
library(tidyverse)
library(httr)
library(jsonlite)
library(github)

json_parse <- function(req) {
  text <- content(req, "text", encoding = "UTF-8")
  if (identical(text, "")) warning("No output to parse.")
  fromJSON(text)
}

source(file = here::here("R", "app_auth.R"))

# create github context
ctx <- create.github.context()

# get organization repos
tidyverse_org_repos <- get.organization.repositories(org = "tidyverse", ctx = ctx)

## get list of repos from response list
tverse_repo_content <- tidyverse_org_repos[["content"]]

length(tverse_repo_content)
seq_along(tverse_repo_content)

## get all repo names
repo_names <- vector("character", length(tverse_repo_content))
  for (i in seq_along(tverse_repo_content)) {
    repo_names[[i]] <- tverse_repo_content[[i]][["name"]]
  }

repo_urls <- vector("character", length(tverse_repo_content))
for (i in seq_along(tverse_repo_content)) {
  repo_urls[[i]] <- tverse_repo_content[[i]][["url"]]
}

reqdf <- json_parse(req)
# get list of issues for dplyr
dplyr_issues <- get.repository.issues(owner = "tidyverse", repo = "dplyr", ctx = ctx)$content

readr_issues <- get.repository.issues(owner = "tidyverse", repo = "readr", ctx = ctx)
