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
      map(~ gh(repo = .x, endpoint = "/repos/tidyverse/:repo/issues", labels = "reprex", .limit = Inf))
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
  filter(n_open > 0) %>%
  arrange(desc(n_open)) %>%
  print(n = nrow(.))
```

```
## # A tibble: 28 x 3
##    repo          reprex_issues     n_open
##    <chr>         <list>             <int>
##  1 dplyr         <S3: gh_response>    143
##  2 broom         <S3: gh_response>    130
##  3 rlang         <S3: gh_response>     75
##  4 purrr         <S3: gh_response>     74
##  5 readr         <S3: gh_response>     61
##  6 ggplot2       <S3: gh_response>     53
##  7 magrittr      <S3: gh_response>     48
##  8 tibble        <S3: gh_response>     48
##  9 haven         <S3: gh_response>     37
## 10 readxl        <S3: gh_response>     32
## 11 modelr        <S3: gh_response>     30
## 12 forcats       <S3: gh_response>     27
## 13 lubridate     <S3: gh_response>     25
## 14 googledrive   <S3: gh_response>     20
## 15 tidyr         <S3: gh_response>     18
## 16 reprex        <S3: gh_response>     17
## 17 style         <S3: gh_response>     13
## 18 tidyverse.org <S3: gh_response>     13
## 19 tidyverse     <S3: gh_response>     12
## 20 stringr       <S3: gh_response>     10
## 21 hms           <S3: gh_response>      8
## 22 glue          <S3: gh_response>      3
## 23 googlesheets4 <S3: gh_response>      2
## 24 tidytemplate  <S3: gh_response>      1
## 25 blob          <S3: gh_response>      1
## 26 ggplot2-docs  <S3: gh_response>      1
## 27 dbplyr        <S3: gh_response>      1
## 28 tidyselect    <S3: gh_response>      1
```


```r
# gh(endpoint = "/repos/tidyverse/ggplot2/issues/1904/labels")
gh(endpoint = "https://api.github.com/repos/tidyverse/ggplot2/issues/2383/labels")
```

```
## ""
```

```r
flat_iss <- flatten(iss_df$issue)
flat_frame <- tibble::enframe(flat_iss)
```


[^1]: A total rip-off of Jenny Bryan's ["Analyze GitHub stuff with R"](https://github.com/jennybc/analyze-github-stuff-with-r)
