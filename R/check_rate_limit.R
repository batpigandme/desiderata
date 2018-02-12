require(gh)
## rate_remaining --------------------------------------------------------------
rate_remaining <- function(){
  rate_limit <- gh::gh("/rate_limit")
  rate_limit[["rate"]][["remaining"]]
}
rate_remaining()
