#! bin/bash

library(dplyr)
library(readr)
library(stringr)

args = commandArgs(trailingOnly = TRUE) # Set arguments from the command line
input = args[1]
g1 = args[2]
g2 = args[3]


dat <- read_table2(input) %>%
  mutate(trait1 = g1,
         trait2 = g2) %>%
  relocate(annot_name, trait1, trait2)

write_tsv(dat, str_replace(input, ".txt", ".tsv"))
