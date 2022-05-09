#!/usr/bin/Rscript
## ========================================================================== ##
## Concat Harmonized MR datasets
## ========================================================================== ##
if(any(grepl("conda", .libPaths(), fixed = TRUE))){
  message("Setting libPaths")
  df = .libPaths()
  conda_i = which(grepl("conda", df, fixed = TRUE))
  .libPaths(c(df[conda_i], df[-conda_i]))
}

library(tidyverse)
library(plyr)

input = snakemake@input[["dat"]] # Outcome Summary statistics
output = snakemake@output[["out"]]

mrpresso_MRdat <- input %>%
  map(., function(x){
    datin <- read_csv(x, col_types = list(target_snp.outcome = col_character(),
                                          proxy.outcome = col_character(),
                                          proxy_snp.outcome = col_character(),
                                          target_a1.outcome = col_character(),
                                          target_a2.outcome = col_character(),
                                          proxy_a1.outcome = col_character(),
                                          proxy_a2.outcome = col_character(),
                                          effect_allele.outcome = col_character(),
                                          mrpresso_RSSobs= col_character(),
                                          mrpresso_pval= col_character()))
  }) %>%
  bind_rows()
write_csv(mrpresso_MRdat, output)
