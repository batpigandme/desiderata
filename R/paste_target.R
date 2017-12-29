library(tidyverse)
library(gh)

tverse_repos <- gh("/orgs/:org/repos", org = "tidyverse")
repo_names <- vapply(tverse_repos, "[[", "", "name")
repo_open_issues <- map_int(tverse_repos[1:length(tverse_repos)], "open_issues")
repo_issue_pages <- ceiling(repo_open_issues / 30)

full_name <- tverse_repos[[1]][["full_name"]]
target <- paste0('/repos/', full_name, '/issues')
name_issues <- gh::gh(target)



pages <- ceiling(tverse_repos[[i]][["open_issues"]] / 30)

# moar_issues <- c(the_issues, name_issues)
