library(plumber)
# plumb(file = "plumber.R")$run(host = "0.0.0.0", port = 8080)

pr(file = "flight_api.R") %>% 
  pr_run(host = "0.0.0.0", port = 8080)
