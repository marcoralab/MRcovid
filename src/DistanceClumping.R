.libPaths(c(snakemake@params[["rlib"]], .libPaths()))

library(tidyverse)
library(broom)
`%nin%` = Negate(`%in%`)

# setwd("/sc/arion/projects/LOAD/shea/Projects/MR_ADPhenome")

ss.path = snakemake@input[["ss"]] # Harmonized MR data
clump.path = snakemake@input[["clump"]] # Output
out_lb = snakemake@output[["out_lb"]] # Output
out_ls = snakemake@output[["out_ls"]] # Output
pval = as.numeric(snakemake@params[["pt"]])

ss <- read_tsv(ss.path) 
clump <- read_table2(clump.path)


# clump <- read_table2("data/MR_ADbidir/Kunkle2019load/Kunkle2019load.clumped.gz")
# ss <- read_tsv("/Users/sheaandrews/Downloads/Kunkle2019load_formated.txt.gz") 
# 
# df1.clmp <- read_table2("/Users/sheaandrews/Downloads/Lee2018education23andMe.clumped.gz")
# ss <- read_tsv("/Users/sheaandrews/Downloads/Lee2018education23andMe_formated.txt.gz") 
# 
# df1.clmp <- read_table2("/Users/sheaandrews/Downloads/Willer2013ldl.clumped.gz")
# ss <- read_tsv("/Users/sheaandrews/Downloads/Willer2013ldl_formated.txt.gz") 
# 

## ---------- LD Block Distance clumping ------------------------ ##
message("LD block based Distance Clumping")

## convert SNPs in LD to tibble
## Left join summary stats onto LD SNPs 
## retain significant SNPs only in LD block
clump.snps <- filter(clump, P < pval) %>% 
  mutate(SP2 = str_replace_all(SP2, "\\(1\\)", "")) %>% 
  mutate(SP2 = strsplit(SP2, ",")) %>% 
  unnest(SP2, keep_empty = TRUE) %>%
  left_join(select(ss, SNP, POS, P), by = c("SP2" = "SNP")) %>%
  rename(P = P.x, P2 = P.y) %>% 
  filter(P2 < pval)

## Left join to retain SNPs with no LD block
## pull 3' and 5' positions of ld block
indep.snps <- filter(clump, P < pval) %>%
  select(-SP2) %>% 
  left_join(clump.snps) %>% 
  group_by(SNP) %>% 
  mutate(POS = ifelse(is.na(POS), BP, POS)) %>%
  summarise(CHROM = first(CHR), POS_3 = min(POS), POS_5 = max(POS)) %>% 
  arrange(CHROM, POS_3) %>% 
  left_join(ss, by = c("SNP", "CHROM"))

## Determin if ld blocks overlap or are less then 250kb distance 
lb.mat <- indep.snps %>% 
  mutate(SNP.2 = SNP) %>% 
  group_by(CHROM) %>%
  expand(SNP, SNP.2) %>%
  ungroup() %>%
  left_join(select(indep.snps, SNP, POS_3, POS_5), by = c("SNP" = "SNP")) %>% 
  left_join(select(indep.snps, SNP, POS_3, POS_5), by = c("SNP.2" = "SNP"), suffix = c(".1", ".2")) %>% 
  mutate(overlap = (pmin(POS_3.1, POS_5.1) <= pmax(POS_3.2, POS_5.2)) &
           (pmax(POS_3.1, POS_5.1) >= pmin(POS_3.2, POS_5.2)), 
         window = (abs(POS_5.1 - POS_3.2) < 250000 | abs(POS_5.2 - POS_3.1)  < 250000),
         clump = case_when(overlap == TRUE | window == TRUE ~ TRUE, TRUE ~ FALSE)) 

lb.p <- arrange(indep.snps, CHROM, P)
lb.clump <- list()
i = 1

while(!plyr::empty(lb.p)){
  snp1 <- lb.p %>% slice(1) %>% pull(SNP) 
  message("Distance Clumping: ", snp1)
  lb.clump[[i]] <- snp1
  
  snprm <- lb.mat %>%
    filter(SNP == snp1 & clump == TRUE) %>%
    pull(SNP.2)
  
  lb.p <- lb.p %>% filter(SNP %nin% snprm) %>% filter(SNP %nin% snp1)
  i <- i + 1
}

lb.clump <- unlist(lb.clump)


ss %>% 
  filter(SNP %in% lb.clump) %>%
  write_tsv(., out_lb)


## ----------- Lead SNP Distance clumping ------------------------ ##
message("Lead SNP based Distance Clumping")

exposure.dat <- ss %>% 
  filter(P < pval) %>%
  semi_join(clump, by = "SNP") %>% 
  arrange(., CHROM, P)

ls.p <- exposure.dat
ls.mat <- ls.p %>%
  split(., .$CHROM) %>%
  map(., select, SNP,POS) %>%
  map(., column_to_rownames, var = "SNP") %>% 
  map(., dist, method = "manhattan", upper = TRUE) %>% 
  map_dfr(., tidy) %>% 
  mutate(clump = case_when(distance <= 250000 ~ 1, distance > 250000 ~ 0)) 

ls.clump <- list()
i = 1

while(!plyr::empty(ls.p)){
  snp1 <- ls.p %>% slice(1) %>% pull(SNP) 
  message("Distance Clumping: ", snp1)
  ls.clump[[i]] <- snp1
  
  snprm <- ls.mat %>%
    filter(item1 == snp1 & clump == 1) %>%
    pull(item2)
  
  ls.p <- ls.p %>% filter(SNP %nin% snprm) %>% filter(SNP %nin% snp1)
  i <- i + 1
}

ls.clump <- unlist(ls.clump)

exposure.dat %>% 
  mutate(LSclump = case_when(SNP %nin% ls.clump ~ FALSE, 
                             TRUE ~ TRUE))
  filter(SNP %in% ls.clump) %>%
  write_tsv(., out_ls)










