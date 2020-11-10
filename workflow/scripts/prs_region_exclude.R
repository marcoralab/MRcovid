suppressMessages(library(tidyverse))
suppressMessages(library(glue))

# Read in Data
clumped = snakemake@input[[1]]
out.snps = snakemake@output[[1]]

# Regions for exclusion
regions_chrm = snakemake@params[["regions_chrm"]]
regions_start = snakemake@params[["regions_start"]]
regions_stop = snakemake@params[["regions_stop"]]

message("Reading in Data \n")
dat_ld <- read_table2(clumped) %>%
  filter(!is.na(CHR)) %>%
  select(CHR, F, SNP, BP, P, TOTAL, NSIG)

if(is.null(regions_chrm)){
  message("No exclusions \n")
  out <- dat_ld %>%
    select(SNP)
} else {
  out <- dat_ld
  for(i in 1:length(regions_chrm)){
    message(glue("Excluding regions: ", regions_chrm[i], ":", regions_start[i], "-", regions_stop[i], " (n = {n})", 
                 n = filter(out, (CHR == regions_chrm[i] & between(BP, regions_start[i], regions_stop[i]) )) %>% nrow()))
    out <- filter(out, !(CHR == regions_chrm[i] & between(BP, regions_start[i], regions_stop[i]) ))
  }
  out <- select(out, SNP)
}

write_tsv(out, out.snps)