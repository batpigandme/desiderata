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
