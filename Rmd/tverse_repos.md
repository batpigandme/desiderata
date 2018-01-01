---
title: "Tidyverse Repos"
author: "Mara Averick"
output:
  html_document:
    keep_md: TRUE
---



Locked and loaded.[^1]


```r
suppressPackageStartupMessages(library(tidyverse))
library(gh)
```

Where `repo` = repository name, `purrr::map()` to extract the elements `name` from list of repositories. `issue` = list column of issues for each repository (vectorize `gh()` using `~` formula syntax).


```r
repos <- gh("/orgs/tidyverse/repos", .limit = Inf)
```


```r
iss_df <-
  data_frame(
    repo = repos %>% map_chr("name"),
    issue = repo %>%
      map(~ gh(repo = .x, endpoint = "/repos/tidyverse/:repo/issues",
               .limit = Inf))
    )
str(iss_df, max.level = 1)
```

```
## Classes 'tbl_df', 'tbl' and 'data.frame':	28 obs. of  2 variables:
##  $ repo : chr  "ggplot2" "lubridate" "stringr" "dplyr" ...
##  $ issue:List of 28
```


```r
iss_df %>%
  mutate(n_open = issue %>% map_int(length)) %>%
  select(-issue) %>%
  filter(n_open > 0) %>%
  arrange(desc(n_open)) %>%
  print(n = nrow(.))
```

```
## # A tibble: 28 x 2
##    repo          n_open
##    <chr>          <int>
##  1 dplyr            143
##  2 broom            130
##  3 rlang             75
##  4 purrr             74
##  5 readr             61
##  6 ggplot2           53
##  7 magrittr          48
##  8 tibble            48
##  9 haven             37
## 10 readxl            32
## 11 modelr            30
## 12 forcats           27
## 13 lubridate         25
## 14 googledrive       20
## 15 tidyr             18
## 16 reprex            17
## 17 style             13
## 18 tidyverse.org     13
## 19 tidyverse         12
## 20 stringr           10
## 21 hms                8
## 22 glue               3
## 23 googlesheets4      2
## 24 tidytemplate       1
## 25 blob               1
## 26 ggplot2-docs       1
## 27 dbplyr             1
## 28 tidyselect         1
```


[^1]: A total rip-off of Jenny Bryan's ["Analyze GitHub stuff with R"](https://github.com/jennybc/analyze-github-stuff-with-r)
