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
##  2 ggplot2              1
##  3 lubridate            1
##  4 stringr              1
##  5 readr                1
##  6 magrittr             1
##  7 tidyr                1
##  8 broom                1
##  9 purrr                1
## 10 haven                1
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
##  1 dplyr            146
##  2 broom            130
##  3 purrr             76
##  4 rlang             74
##  5 readr             61
##  6 ggplot2           52
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


```r
# gh(endpoint = "/repos/tidyverse/ggplot2/issues/1904/labels")
gh(endpoint = "https://api.github.com/repos/tidyverse/ggplot2/issues/2383/labels")
```

```
## [
##   {
##     "id": 415860814,
##     "url": "https://api.github.com/repos/tidyverse/ggplot2/labels/reprex",
##     "name": "reprex",
##     "color": "eb6420",
##     "default": false
##   }
## ]
```


```r
dplyr_labs <- gh(endpoint = "https://api.github.com/repos/tidyverse/dplyr/labels")

str(dplyr_labs)
```

```
## List of 12
##  $ :List of 5
##   ..$ id     : int 17708198
##   ..$ url    : chr "https://api.github.com/repos/tidyverse/dplyr/labels/bug"
##   ..$ name   : chr "bug"
##   ..$ color  : chr "e02a2a"
##   ..$ default: logi TRUE
##  $ :List of 5
##   ..$ id     : int 276202384
##   ..$ url    : chr "https://api.github.com/repos/tidyverse/dplyr/labels/data%20frame"
##   ..$ name   : chr "data frame"
##   ..$ color  : chr "eeeeee"
##   ..$ default: logi FALSE
##  $ :List of 5
##   ..$ id     : int 213548409
##   ..$ url    : chr "https://api.github.com/repos/tidyverse/dplyr/labels/database"
##   ..$ name   : chr "database"
##   ..$ color  : chr "eeeeee"
##   ..$ default: logi FALSE
##  $ :List of 5
##   ..$ id     : int 674867158
##   ..$ url    : chr "https://api.github.com/repos/tidyverse/dplyr/labels/docs"
##   ..$ name   : chr "docs"
##   ..$ color  : chr "0052cc"
##   ..$ default: logi FALSE
##  $ :List of 5
##   ..$ id     : int 86585992
##   ..$ url    : chr "https://api.github.com/repos/tidyverse/dplyr/labels/documentation"
##   ..$ name   : chr "documentation"
##   ..$ color  : chr "eeeeee"
##   ..$ default: logi FALSE
##  $ :List of 5
##   ..$ id     : int 17708200
##   ..$ url    : chr "https://api.github.com/repos/tidyverse/dplyr/labels/feature"
##   ..$ name   : chr "feature"
##   ..$ color  : chr "009800"
##   ..$ default: logi FALSE
##  $ :List of 5
##   ..$ id     : int 334471510
##   ..$ url    : chr "https://api.github.com/repos/tidyverse/dplyr/labels/generic"
##   ..$ name   : chr "generic"
##   ..$ color  : chr "eeeeee"
##   ..$ default: logi FALSE
##  $ :List of 5
##   ..$ id     : int 544019306
##   ..$ url    : chr "https://api.github.com/repos/tidyverse/dplyr/labels/nse"
##   ..$ name   : chr "nse"
##   ..$ color  : chr "eeeeee"
##   ..$ default: logi FALSE
##  $ :List of 5
##   ..$ id     : int 529648245
##   ..$ url    : chr "https://api.github.com/repos/tidyverse/dplyr/labels/performance"
##   ..$ name   : chr "performance"
##   ..$ color  : chr "fbca04"
##   ..$ default: logi FALSE
##  $ :List of 5
##   ..$ id     : int 334407164
##   ..$ url    : chr "https://api.github.com/repos/tidyverse/dplyr/labels/reprex"
##   ..$ name   : chr "reprex"
##   ..$ color  : chr "eb6420"
##   ..$ default: logi FALSE
##  $ :List of 5
##   ..$ id     : int 544019342
##   ..$ url    : chr "https://api.github.com/repos/tidyverse/dplyr/labels/vector"
##   ..$ name   : chr "vector"
##   ..$ color  : chr "eeeeee"
##   ..$ default: logi FALSE
##  $ :List of 5
##   ..$ id     : int 674867157
##   ..$ url    : chr "https://api.github.com/repos/tidyverse/dplyr/labels/wip"
##   ..$ name   : chr "wip"
##   ..$ color  : chr "eb6420"
##   ..$ default: logi FALSE
##  - attr(*, "method")= chr "GET"
##  - attr(*, "response")=List of 24
##   ..$ server                       : chr "GitHub.com"
##   ..$ date                         : chr "Tue, 02 Jan 2018 15:27:19 GMT"
##   ..$ content-type                 : chr "application/json; charset=utf-8"
##   ..$ transfer-encoding            : chr "chunked"
##   ..$ status                       : chr "200 OK"
##   ..$ x-ratelimit-limit            : chr "5000"
##   ..$ x-ratelimit-remaining        : chr "4603"
##   ..$ x-ratelimit-reset            : chr "1514907576"
##   ..$ cache-control                : chr "private, max-age=60, s-maxage=60"
##   ..$ vary                         : chr "Accept, Authorization, Cookie, X-GitHub-OTP"
##   ..$ etag                         : chr "W/\"975d3de60ab0f315adf08d5632068258\""
##   ..$ x-oauth-scopes               : chr ""
##   ..$ x-accepted-oauth-scopes      : chr "repo"
##   ..$ x-github-media-type          : chr "github.v3; format=json"
##   ..$ access-control-expose-headers: chr "ETag, Link, Retry-After, X-GitHub-OTP, X-RateLimit-Limit, X-RateLimit-Remaining, X-RateLimit-Reset, X-OAuth-Sco"| __truncated__
##   ..$ access-control-allow-origin  : chr "*"
##   ..$ content-security-policy      : chr "default-src 'none'"
##   ..$ strict-transport-security    : chr "max-age=31536000; includeSubdomains; preload"
##   ..$ x-content-type-options       : chr "nosniff"
##   ..$ x-frame-options              : chr "deny"
##   ..$ x-xss-protection             : chr "1; mode=block"
##   ..$ x-runtime-rack               : chr "0.043253"
##   ..$ content-encoding             : chr "gzip"
##   ..$ x-github-request-id          : chr "E223:0610:5A3284D:12574B8C:5A4BA4D7"
##   ..- attr(*, "class")= chr [1:2] "insensitive" "list"
##  - attr(*, ".send_headers")= Named chr [1:3] "application/vnd.github.v3+json" "https://github.com/r-lib/gh" "token 66452b382bd7eb10455de69660631e54ee80a109"
##   ..- attr(*, "names")= chr [1:3] "Accept" "User-Agent" "Authorization"
##  - attr(*, "class")= chr [1:2] "gh_response" "list"
```


[^1]: A total rip-off of Jenny Bryan's ["Analyze GitHub stuff with R"](https://github.com/jennybc/analyze-github-stuff-with-r)
