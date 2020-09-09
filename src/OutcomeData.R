#!/usr/bin/Rscript

### ===== Command Line Arguments ===== ##
args = commandArgs(trailingOnly = TRUE) # Set arguments from the command line
exposure.summary = args[1] # Exposure summary statistics
outcome.summary = args[2] # Outcome Summary statistics
out = args[3]


### ===== Load packages ===== ###
suppressMessages(library(tidyverse))   ## For data wrangling
#suppressMessages(library(Hmisc))       ## Contains miscillaneous funtions

### ===== READ IN SNPs ===== ###
message("READING IN EXPOSURE \n")
exposure.dat <- read_tsv(exposure.summary)

message("\n READING IN OUTCOME \n")
outcome.dat.raw <- read_tsv(outcome.summary, comment = '##', guess_max = 15000000) 

### ===== EXTACT SNPS ===== ###
message("\n EXTRACTING SNP EFFECTS FROM OUTCOME GWAS  \n")
outcome.dat <- outcome.dat.raw %>%
  right_join(select(exposure.dat, SNP), by = 'SNP')


### ===== MISSING SNPS SNPS ===== ###

outcome.dat %>%
  filter(is.na(CHROM)) %>%
  select(SNP) %>%
  write_tsv(paste0(out, '_MissingSNPs.txt'), col_names = F)

message("\n EXPORTING \n")
## Write out outcomes SNPs
write_tsv(outcome.dat, paste0(out, '_SNPs.txt'))
