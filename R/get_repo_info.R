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

rlib_repos <- gh(endpoint = "/orgs/:org/repos", org = "r-lib", limit = 50)

rlib_repo_df <- data_frame(
  repo = rlib_repos %>% map_chr("name"),
  full_name = rlib_repos %>% map_chr("full_name"),
  description = rlib_repos %>% map_chr("description"),
  html_url = rlib_repos %>% map_chr("html_url"),
  url = rlib_repos %>% map_chr("url")
)

require(tidyverse)
require(gh)
#' @param gh_response
build_repo_frame <- function(gh_response) {
  df <- data_frame(
    repo = gh_response %>% map_chr("name"),
    full_name = gh_response %>% map_chr("full_name"),
    html_url = gh_response %>% map_chr("html_url"),
    url = gh_response %>% map_chr("url")
  )
  return(df)
}

rstudio_repos <- gh(endpoint = "/orgs/:org/repos", org = "rstudio")
rstudio_repo_df <- build_repo_frame(rstudio_repos)

write_csv(tverse_repo_df, path = here::here("data", "tverse_repo_df.csv"))
write_csv(rlib_repo_df, path = here::here("data", "rlib_repo_df.csv"))
write_csv(rstudio_repo_df, path = here::here("data", "rstudio_repo_df.csv"))
