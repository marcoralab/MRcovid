#!/usr/bin/Rscript
## ========================================================================== ##
## Extract SNPs to be used as instruments in exposure
## ========================================================================== ##

### ===== Command Line Arguments ===== ##
args = commandArgs(trailingOnly = TRUE) # Set arguments from the command line

exposure.summary = args[1] # Exposure summary statistics
p.threshold = as.numeric(args[2])
exposure.clump = args[3]
out.file = args[4] # SPECIFY THE OUTPUT FILE

### ===== Load packages ===== ###
suppressMessages(library(tidyverse))   ## For data wrangling
library(here)
source(here("workflow", "scripts", "miscfunctions.R"), chdir = TRUE)

### ===== Read in Data ===== ###
message("\n READING IN EXPOSURE \n")
exposure.dat <- read_tsv(exposure.summary, comment = '#', guess_max = 15000000) %>%
  filter(P < p.threshold) %>%
  distinct(SNP, .keep_all = TRUE)

### ===== Clump Exposure ===== ###
message("\n CLUMPING EXPOSURE SNPS \n")

## Plink Pre-clumped
mr_exposure.dat_ld <- read_table2(exposure.clump) %>%
  filter(!is.na(CHR)) %>%
  select(CHR, F, SNP, BP, P, TOTAL, NSIG)

# Filter exposure data for clumped SNPs
exposure.dat <- exposure.dat %>% filter(SNP %in% mr_exposure.dat_ld$SNP)

# message("Distanced based clumping on lead SNP \n")
# # Distanced based clumping on lead SNP
# ls.p <- exposure.dat
# ls.mat <- ls.p %>%
#   split(., .$CHROM) %>%
#   map(., select, SNP,POS) %>%
#   map(., column_to_rownames, var = "SNP") %>%
#   map(., dist, method = "manhattan", upper = TRUE) %>%
#   map_dfr(., tidy) %>%
#   mutate(clump = case_when(distance <= 250000 ~ 1, distance > 250000 ~ 0))
#
# ls.clump <- list()
# i = 1
#
# while(!plyr::empty(ls.p)){
#   snp1 <- ls.p %>% slice(1) %>% pull(SNP)
#   message("Distance Clumping: ", snp1)
#   ls.clump[[i]] <- snp1
#
#   snprm <- ls.mat %>%
#     filter(item1 == snp1 & clump == 1) %>%
#     pull(item2)
#
#   ls.p <- ls.p %>% filter(SNP %nin% snprm) %>% filter(SNP %nin% snp1)
#   i <- i + 1
# }
#
# ls.clump <- unlist(ls.clump)
#
# exposure.dat <- exposure.dat %>%
#   mutate(LSclump = case_when(SNP %nin% ls.clump ~ FALSE,
#                            TRUE ~ TRUE)

### ===== Write Out Exposure ===== ###
message("\n Writing Out Exposure \n")

write_tsv(exposure.dat, out.file)
