---
title: "r-lib repos"
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
repos <- gh("/orgs/r-lib/repos", .limit = Inf)
```


```r
iss_df <-
  data_frame(
    repo = repos %>% map_chr("name"),
    issue = repo %>%
      map(~ gh(repo = .x, endpoint = "/repos/r-lib/:repo/issues",
               .limit = Inf)),
    reprex_issues = repo %>%
      map(~ gh(repo = .x, endpoint = "/repos/r-lib/:repo/issues", 
               labels = "reprex", .limit = Inf))
    )
str(iss_df, max.level = 1)
```

```
## Classes 'tbl_df', 'tbl' and 'data.frame':	61 obs. of  3 variables:
##  $ repo         : chr  "evaluate" "testthat" "memoise" "httr" ...
##  $ issue        :List of 61
##  $ reprex_issues:List of 61
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
## # A tibble: 61 x 2
##    repo              n_open
##    <chr>              <int>
##  1 pkgdown               97
##  2 rlang                 93
##  3 remotes               57
##  4 usethis               52
##  5 revdepcheck           42
##  6 testthat              39
##  7 httr                  30
##  8 pkgdepends            30
##  9 pillar                23
## 10 rcmdcheck             19
## 11 R6                    17
## 12 pkgman                17
## 13 memoise               16
## 14 covr                  16
## 15 processx3             16
## 16 evaluate              15
## 17 progress              14
## 18 gh                    14
## 19 gargle                14
## 20 styler                14
## 21 debugme               13
## 22 later                 13
## 23 ansistrings           11
## 24 pkgapi                10
## 25 withr                  9
## 26 pkginstall             9
## 27 keyring                8
## 28 xml2                   7
## 29 httrmock               7
## 30 rappdirs               6
## 31 pkgbuild               6
## 32 crancache              6
## 33 fs                     6
## 34 svglite                5
## 35 crayon                 5
## 36 desc                   5
## 37 sessioninfo            5
## 38 async                  5
## 39 ghurl                  5
## 40 callr                  4
## 41 filelock               4
## 42 oldie                  4
## 43 pingr                  3
## 44 zip                    3
## 45 cli                    3
## 46 rematch2               3
## 47 clisymbols             2
## 48 liteq                  2
## 49 osname                 2
## 50 tracer                 2
## 51 pkgconfig              1
## 52 whoami                 1
## 53 installgithub.app      1
## 54 pkgload                1
## 55 prettycode             1
## 56 roxygen2md             1
## 57 conf                   1
## 58 objectable             1
## 59 xmlparsedata           1
## 60 tar                    1
## 61 showimage              1
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
## # A tibble: 61 x 2
##    repo              reprex_n
##    <chr>                <int>
##  1 evaluate                 1
##  2 testthat                 1
##  3 memoise                  1
##  4 httr                     1
##  5 pkgdown                  1
##  6 rappdirs                 1
##  7 svglite                  1
##  8 R6                       1
##  9 pkgconfig                1
## 10 pingr                    1
## 11 crayon                   1
## 12 progress                 1
## 13 covr                     1
## 14 xml2                     1
## 15 clisymbols               1
## 16 withr                    1
## 17 whoami                   1
## 18 gh                       1
## 19 desc                     1
## 20 gargle                   1
## 21 remotes                  1
## 22 installgithub.app        1
## 23 rcmdcheck                1
## 24 callr                    1
## 25 revdepcheck              1
## 26 processx3                1
## 27 debugme                  1
## 28 usethis                  1
## 29 rlang                    1
## 30 pkgload                  1
## 31 httrmock                 1
## 32 pkgbuild                 1
## 33 prettycode               1
## 34 roxygen2md               1
## 35 pkgapi                   1
## 36 liteq                    1
## 37 keyring                  1
## 38 styler                   1
## 39 ansistrings              1
## 40 later                    1
## 41 crancache                1
## 42 zip                      1
## 43 osname                   1
## 44 sessioninfo              1
## 45 cli                      1
## 46 filelock                 1
## 47 pillar                   1
## 48 conf                     1
## 49 rematch2                 1
## 50 objectable               1
## 51 xmlparsedata             1
## 52 async                    1
## 53 oldie                    1
## 54 pkgdepends               1
## 55 pkginstall               1
## 56 tracer                   1
## 57 pkgman                   1
## 58 fs                       1
## 59 tar                      1
## 60 showimage                1
## 61 ghurl                    1
```



```r
usethis_labs <- gh(endpoint = "https://api.github.com/repos/r-lib/usethis/labels")

labs_df <-  data_frame(
    label_name = usethis_labs %>% map_chr("name"),
    label_url = usethis_labs %>% map_chr("url")
    )

labs_df
```

```
## # A tibble: 9 x 2
##   label_name       label_url                                              
##   <chr>            <chr>                                                  
## 1 bug              https://api.github.com/repos/r-lib/usethis/labels/bug  
## 2 docs             https://api.github.com/repos/r-lib/usethis/labels/docs 
## 3 feature          https://api.github.com/repos/r-lib/usethis/labels/feat…
## 4 good first issue https://api.github.com/repos/r-lib/usethis/labels/good…
## 5 help wanted      https://api.github.com/repos/r-lib/usethis/labels/help…
## 6 non-package      https://api.github.com/repos/r-lib/usethis/labels/non-…
## 7 performance      https://api.github.com/repos/r-lib/usethis/labels/perf…
## 8 reprex           https://api.github.com/repos/r-lib/usethis/labels/repr…
## 9 wip              https://api.github.com/repos/r-lib/usethis/labels/wip
```


[^1]: A total rip-off of Jenny Bryan's ["Analyze GitHub stuff with R"](https://github.com/jennybc/analyze-github-stuff-with-r)
