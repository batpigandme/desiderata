library(tidyverse)
library(gh)

tidyverse_repos <- gh(endpoint = "/orgs/:org/repos", org = "tidyverse")

tverse_repo_df <-   data_frame(
  repo = tidyverse_repos %>% map_chr("name"),
  full_name = tidyverse_repos %>% map_chr("full_name"),
  description = tidyverse_repos %>% map_chr("description"),
  html_url = tidyverse_repos %>% map_chr("html_url"),
  url = tidyverse_repos %>% map_chr("url")
)
