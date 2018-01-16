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
               .limit = Inf)),
    reprex_issues = repo %>%
      map(~ gh(repo = .x, endpoint = "/repos/tidyverse/:repo/issues", 
               labels = "reprex", .limit = Inf))
    )
str(iss_df, max.level = 1)
```

```
## Classes 'tbl_df', 'tbl' and 'data.frame':	28 obs. of  3 variables:
##  $ repo         : chr  "ggplot2" "lubridate" "stringr" "dplyr" ...
##  $ issue        :List of 28
##  $ reprex_issues:List of 28
```

```r
rep_iss <- flatten(iss_df$reprex_issues)
keeps <- tibble(reprex_issue = keep(rep_iss,is.list))
```


```r
iss_df %>%
  mutate(n_open = issue %>% map_int(length)) %>%
  select(-issue) %>%
  select(-reprex_issues) %>%
  filter(n_open > 0) %>%
  arrange(desc(n_open)) %>%
  print(n = nrow(.))
```

```
## # A tibble: 28 x 2
##    repo          n_open
##    <chr>          <int>
##  1 dplyr            147
##  2 broom            131
##  3 purrr             77
##  4 rlang             69
##  5 readr             64
##  6 ggplot2           61
##  7 magrittr          48
##  8 tibble            40
##  9 readxl            32
## 10 modelr            31
## 11 forcats           27
## 12 lubridate         26
## 13 haven             23
## 14 googledrive       21
## 15 tidyr             18
## 16 reprex            18
## 17 tidyverse.org     16
## 18 stringr           15
## 19 tidyverse         14
## 20 hms                8
## 21 style              6
## 22 glue               4
## 23 googlesheets4      2
## 24 tidyselect         2
## 25 tidytemplate       1
## 26 blob               1
## 27 ggplot2-docs       1
## 28 dbplyr             1
```


```r
iss_df %>%
  mutate(reprex_n = reprex_issues %>% map_int(length)) %>%
  select(-reprex_issues) %>%
  select(-issue) %>%
  filter(reprex_n > 0) %>%
  arrange(desc(reprex_n)) %>%
  print(n = nrow(.))
```

```
## # A tibble: 28 x 2
##    repo          reprex_n
##    <chr>            <int>
##  1 dplyr                5
##  2 haven                3
##  3 ggplot2              1
##  4 lubridate            1
##  5 stringr              1
##  6 readr                1
##  7 magrittr             1
##  8 tidyr                1
##  9 broom                1
## 10 purrr                1
## 11 readxl               1
## 12 reprex               1
## 13 tibble               1
## 14 hms                  1
## 15 modelr               1
## 16 forcats              1
## 17 tidyverse            1
## 18 tidytemplate         1
## 19 blob                 1
## 20 ggplot2-docs         1
## 21 rlang                1
## 22 glue                 1
## 23 style                1
## 24 dbplyr               1
## 25 googledrive          1
## 26 googlesheets4        1
## 27 tidyselect           1
## 28 tidyverse.org        1
```


```r
# gh(endpoint = "/repos/tidyverse/ggplot2/issues/1904/labels")
gh(endpoint = "https://api.github.com/repos/tidyverse/ggplot2/issues/2383/labels")
```

```
## ""
```


```r
dplyr_labs <- gh(endpoint = "https://api.github.com/repos/tidyverse/dplyr/labels")

labs_df <-  data_frame(
    label_name = dplyr_labs %>% map_chr("name"),
    label_url = dplyr_labs %>% map_chr("url")
    )

labs_df
```

```
## # A tibble: 12 x 2
##    label_name    label_url                                                
##    <chr>         <chr>                                                    
##  1 bug           https://api.github.com/repos/tidyverse/dplyr/labels/bug  
##  2 data frame    https://api.github.com/repos/tidyverse/dplyr/labels/data…
##  3 database      https://api.github.com/repos/tidyverse/dplyr/labels/data…
##  4 docs          https://api.github.com/repos/tidyverse/dplyr/labels/docs 
##  5 documentation https://api.github.com/repos/tidyverse/dplyr/labels/docu…
##  6 feature       https://api.github.com/repos/tidyverse/dplyr/labels/feat…
##  7 generic       https://api.github.com/repos/tidyverse/dplyr/labels/gene…
##  8 nse           https://api.github.com/repos/tidyverse/dplyr/labels/nse  
##  9 performance   https://api.github.com/repos/tidyverse/dplyr/labels/perf…
## 10 reprex        https://api.github.com/repos/tidyverse/dplyr/labels/repr…
## 11 vector        https://api.github.com/repos/tidyverse/dplyr/labels/vect…
## 12 wip           https://api.github.com/repos/tidyverse/dplyr/labels/wip
```


[^1]: A total rip-off of Jenny Bryan's ["Analyze GitHub stuff with R"](https://github.com/jennybc/analyze-github-stuff-with-r)
