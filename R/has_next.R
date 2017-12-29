library(tidyverse)
library(gh)

dplyr_issues <- gh("/repos/:owner/:repo/issues", owner = "tidyverse", repo = "dplyr")
dplyr_issues_next <- gh_next(dplyr_issues)
gh:::gh_has_next(dplyr_issues_next)
dplyr_issues_three <- gh_next(dplyr_issues_next)
gh:::gh_has_next(dplyr_issues_three)
dplyr_issues_four <- gh_next(dplyr_issues_three)
gh:::gh_has_next(dplyr_issues_four)
dplyr_issues_five <- gh_next(dplyr_issues_four)
gh:::gh_has_next(dplyr_issues_five)

