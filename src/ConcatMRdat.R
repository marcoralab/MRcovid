#!/usr/bin/Rscript
library(tidyverse)

args = commandArgs(trailingOnly = TRUE) # Set arguments from the command line
output = args[1]
input = args[2:length(args)] # Outcome Summary statistics

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
