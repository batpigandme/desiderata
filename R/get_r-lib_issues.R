repos <- gh("/orgs/r-lib/repos", .limit = Inf)

rlib_iss_df <-
  data_frame(
    repo = repos %>% map_chr("name"),
    issue = repo %>%
      map(~ gh(repo = .x, endpoint = "/repos/r-lib/:repo/issues",
               .limit = Inf)),
    reprex_issues = repo %>%
      map(~ gh(repo = .x, endpoint = "/repos/r-lib/:repo/issues",
               labels = "reprex", .limit = Inf))
  )

str(rlib_iss_df, max.level = 1)
rep_iss <- flatten(rlib_iss_df$reprex_issues)
keeps <- tibble(reprex_issue = keep(rep_iss,is.list))

rlib_issues <- rlib_iss_df %>%
  mutate(n_open = issue %>% map_int(length)) %>%
  select(-issue) %>%
  select(-reprex_issues) %>%
  filter(n_open > 0) %>%
  arrange(desc(n_open)) %>%
  print(n = nrow(.))

