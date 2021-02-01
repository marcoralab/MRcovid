#! bin/bash

library(tidyverse)

args = commandArgs(trailingOnly = TRUE) # Set arguments from the command line
input = args[1]

dat <- read_lines(input)

vars <- dat[which(str_detect(dat, "p1"))] %>%
  str_split(., pattern = "\\s+") %>%
  magrittr::extract2(1) %>%
  str_trim()
good_snps <- dat[which(str_detect(dat, "SNPs with valid alleles"))] %>%
  str_split(., pattern = "\\s+") %>%
  magrittr::extract2(1) %>%
  magrittr::extract(1)
df <- dat[which(str_detect(dat, "p1"))+1] %>%
  str_split(., pattern = "\\s+") %>%
  magrittr::extract2(1) %>%
  str_trim() %>%
  magrittr::set_names(vars) %>%
  as.data.frame() %>%
  t() %>%
  as_tibble() %>% 
  mutate(nsnps = good_snps)

write_tsv(df, str_replace(input, ".log", ".tsv"))
