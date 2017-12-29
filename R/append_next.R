require(tidyverse)
require(gh)

get_repo_issues <- function(repo_name) {
  issue_list <- gh::gh("/repos/:owner/:repo/issues", owner = "tidyverse", repo = repo_name)
  if_else(gh:::gh_has_next(issue_list),
          issue_list <- append(issue_list, gh_next(issue_list)),
  return(issue_list))
}

dplyr_issues <- get_repo_issues("dplyr")

append_next <- function(gh_response) {
  current <- gh_response
  after <- gh::gh_next(gh_response)
  combo <- append(current, after)
  return(combo)
}

dplyr_combo <- append_next(dplyr_issues)

last_issues <- gh:::gh_last(dplyr_issues)
