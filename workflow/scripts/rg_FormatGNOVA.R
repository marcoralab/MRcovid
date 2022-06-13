#! bin/bash
library(tidyr)
library(readr)
library(dplyr)
library(plyr)

args = commandArgs(trailingOnly = TRUE) # Set arguments from the command line
input = args[1]

# Remove NA values from LDSC wrangled summary stats
read_tsv(input) %>%
    drop_na() %>%
    write_tsv(gzfile(input))
