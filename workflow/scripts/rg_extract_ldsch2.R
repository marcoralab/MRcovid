#! bin/bash
library(tidyr)
library(readr)
library(dplyr)
library(plyr)
library(stringr)

if(any(grepl("conda", .libPaths(), fixed = TRUE))){
  message("Setting libPaths")
  df = .libPaths()
  conda_i = which(grepl("conda", df, fixed = TRUE))
  .libPaths(c(df[conda_i], df[-conda_i]))
}
.libPaths(c(.libPaths(), "/hpc/users/harern01/miniconda3/envs/py38/lib/R/library"))

args = commandArgs(trailingOnly = TRUE) # Set arguments from the command line
input = args[1]

dat <- read_lines(input)

vars <- dat[which(str_detect(dat, "p"))] %>%
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
  mutate(nsnps = good_snps)%>%
  mutate(p =2*pnorm(-abs(z))

write_tsv(df, str_replace(input, ".log", ".tsv"))
