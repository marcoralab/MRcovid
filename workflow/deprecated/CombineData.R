#!/usr/bin/Rscript

library(tidyverse)

args = commandArgs(trailingOnly = TRUE) # Set arguments from the command line
derived_data = args[1]
output_data = args[2]
#outcomes = args[3]

#derived_data = '/Users/sheaandrews/Dropbox/Research/PostDoc-MSSM/2_MR/2_DerivedData/lax_clump'
#output_data = '/Users/sheaandrews/Dropbox/Research/PostDoc-MSSM/2_MR/4_Output/lax_clump'

## To pull the derived data sets from MR analysis and combine them into single dataframes
## Useful for reading into R Shiny 

## ===============================================## 
## Summary statistics for Exposure and outcome snps
## ===============================================## 
ssfiles  <- list.files(derived_data, recursive = T, pattern = '_SNPs.txt', full.names = T)
summary_stats <- ssfiles %>% 
  map(., function(x){
    dat.model <- tibble(file = x) %>% 
      mutate(file = str_replace(file, paste0(derived_data, '/'), "")) %>%
      separate(file, c('exposure', 'outcome', 'file'), sep = '/', remove = F) %>% 
      mutate(file = ifelse(is.na(file), outcome, file)) %>% 
      mutate(outcome = ifelse(grepl('SNPs', outcome), NA, outcome)) %>% 
      separate(file, c('X1', 'pt', 'X2', 'X3'), sep = '_') %>% 
      select(-X1, -X2, -X3)
    datin <- read_tsv(x, col_types = list(Effect_allele = col_character(), 
                                          Non_Effect_allele = col_character())) %>% 
      mutate(exposure = dat.model$exposure) %>% 
      mutate(outcome = dat.model$outcome) %>% 
      mutate(pt = dat.model$pt)
  }) %>% 
  bind_rows() %>% 
  select( SNP, CHR, POS, Effect_allele, Non_Effect_allele, EAF, Beta, SE, P, r2, N, exposure, outcome, pt)
write_tsv(summary_stats, gzfile(paste0(output_data, '/', '0_Summary/','MR_summary_stats.txt.gz')))

## ===============================================## 
## Proxy SNPs for Exposure associated SNPs in Outcome
## ===============================================## 
MatchedProxys <- list.files(derived_data, recursive = T, pattern = '_MatchedProxys.csv', full.names = T) %>% 
  map(., function(x){
    dat.model <- tibble(file = x) %>% 
      mutate(file = str_replace(file, paste0(derived_data, '/'), "")) %>%
      separate(file, c('exposure', 'outcome', 'file'), sep = '/', remove = F) %>% 
      mutate(file = ifelse(is.na(file), outcome, file)) %>% 
      mutate(outcome = ifelse(grepl('SNPs', outcome), NA, outcome)) %>% 
      separate(file, c('X1', 'pt', 'X2', 'X3'), sep = '_') %>% 
      select(-X1, -X2, -X3)
    datin <- read_csv(x, col_types = list(Effect_allele = col_character(), 
                                          Non_Effect_allele = col_character(),
                                          ref = col_character(), 
                                          alt = col_character(),
                                          ref.proxy = col_character(), 
                                          alt.proxy = col_character(),
                                          Effect_allele.proxy = col_character(), 
                                          Zscore = col_character(),
                                          Non_Effect_allele.proxy = col_character())) %>% 
      mutate(exposure = dat.model$exposure) %>% 
      mutate(outcome = dat.model$outcome) %>% 
      mutate(pt = dat.model$pt)
  }) %>% 
  bind_rows() %>% select(target_snp, proxy_snp, ld.r2, Dprime, PHASE, X12, CHR, POS, Effect_allele.proxy, Non_Effect_allele.proxy, EAF, Beta, SE, P, r2, N, ref, ref.proxy, alt, alt.proxy, Effect_allele, Non_Effect_allele, proxy.outcome, exposure, outcome, pt)
#write_tsv(MatchedProxys, gzfile('~/Dropbox/Research/PostDoc-MSSM/2_MR/Shiny/MR_MatchedProxys.txt.gz'))
write_tsv(MatchedProxys, gzfile(paste0(output_data, '/', '0_Summary/','MR_MatchedProxys.txt.gz')))

## ===============================================## 
## harmonized MR datasets with MR presso Results
## ===============================================## 
mrpresso_MRdat <- list.files(derived_data, recursive = T, pattern = '_mrpresso_MRdat.csv', full.names = T) %>% 
  map(., function(x){
    dat.model <- tibble(file = x) %>% 
      mutate(file = str_replace(file, paste0(derived_data, '/'), "")) %>%
      separate(file, c('exposure', 'outcome', 'file'), sep = '/', remove = F) %>% 
      mutate(file = ifelse(is.na(file), outcome, file)) %>% 
      mutate(outcome = ifelse(grepl('SNPs', outcome), NA, outcome)) %>% 
      separate(file, c('X1', 'pt', 'X2', 'X3'), sep = '_') %>% 
      select(-X1, -X2, -X3)
    datin <- read_csv(x, col_types = list(target_snp.outcome = col_character(), 
                                          proxy_snp.outcome = col_character(), 
                                          target_a1.outcome = col_character(), 
                                          target_a2.outcome = col_character(), 
                                          proxy_a1.outcome = col_character(), 
                                          proxy_a2.outcome = col_character(), 
                                          effect_allele.outcome = col_character(),
                                          mrpresso_RSSobs= col_character(), 
                                          mrpresso_pval= col_character())) %>% 
      mutate(pt = dat.model$pt)
  }) %>% 
  bind_rows()
#write_tsv(mrpresso_MRdat, gzfile('~/Dropbox/Research/PostDoc-MSSM/2_MR/Shiny/MR_mrpresso_MRdat.txt.gz'))
write_tsv(mrpresso_MRdat, gzfile(paste0(output_data, '/', '0_Summary/','MR_mrpresso_MRdat.txt.gz')))

## ===============================================## 
## MR-PRESSO Global results  
## ===============================================## 

## MR-PRESSO Global w/ Outliers Retained
mrpresso_global <- list.files(derived_data, recursive = T,  pattern = '_mrpresso_global.txt',  full.names = T) %>% 
  map(., function(x){
    dat.model <- tibble(file = x) %>% 
      mutate(file = str_replace(file, paste0(derived_data, '/'), "")) %>%
      separate(file, c('exposure', 'outcome', 'file'), sep = '/', remove = F) %>% 
      mutate(file = ifelse(is.na(file), outcome, file)) %>% 
      mutate(outcome = ifelse(grepl('SNPs', outcome), NA, outcome)) %>% 
      separate(file, c('X1', 'pt', 'X2', 'X3'), sep = '_') %>% 
      select(-X1, -X2, -X3)
    datin <- read_tsv(x, col_types = list(pval = col_character())) %>% 
      mutate(pt = dat.model$pt)
  }) %>% 
  bind_rows() %>% 
  mutate(violated = pval < 0.05) %>% 
  mutate(outliers_removed = FALSE)

## MR-PRESSO Global results w/o outliers
mrpresso_global_wo_outliers <- list.files(derived_data, recursive = T,  pattern = '_mrpresso_global_wo_outliers.txt', 
                              full.names = T) %>% 
  map(., function(x){
    dat.model <- tibble(file = x) %>% 
      mutate(file = str_replace(file, paste0(derived_data, '/'), "")) %>%
      separate(file, c('exposure', 'outcome', 'file'), sep = '/', remove = F) %>% 
      mutate(file = ifelse(is.na(file), outcome, file)) %>% 
      mutate(outcome = ifelse(grepl('SNPs', outcome), NA, outcome)) %>% 
      separate(file, c('X1', 'pt', 'X2', 'X3'), sep = '_') %>% 
      select(-X1, -X2, -X3)
    datin <- read_tsv(x, col_types = list(pval = col_character(), 
                                          RSSobs = col_character())) %>% 
      mutate(pt = dat.model$pt)
  }) %>% 
  bind_rows() %>% 
  mutate(RSSobs = as.numeric(RSSobs)) %>% 
  mutate(violated = pval < 0.05) %>% 
  mutate(outliers_removed = TRUE)

## Combine MR-PRESSO Global results 
mrpresso_global_comb <- mrpresso_global_wo_outliers %>% 
  rename(n_outliers = n.outlier) %>% 
  bind_rows(mrpresso_global)
write_tsv(mrpresso_global_comb, gzfile(paste0(output_data, '/', '0_Summary/','mrpresso_global_comb.txt.gz')))

## ===============================================## 
## MR results
## ===============================================## 

## MR results w/ outliers
MRdat_results <- list.files(output_data, recursive = T, pattern = '_MR_Results.csv', full.names = T) %>% 
  map(., function(x){
    dat.model <- tibble(file = x) %>% 
      mutate(file = str_replace(file, paste0(output_data, '/'), "")) %>%
      separate(file, c('exposure', 'outcome', 'file'), sep = '/', remove = F) %>% 
      mutate(file = ifelse(is.na(file), outcome, file)) %>% 
      mutate(outcome = ifelse(grepl('SNPs', outcome), NA, outcome)) %>% 
      separate(file, c('X1', 'pt', 'X2', 'X3', 'X4'), sep = '_') %>% 
      select(-X1, -X2, -X3, -X4)
    datin <- read_csv(x) %>% 
      mutate(pt = dat.model$pt)
  }) %>% 
  bind_rows()

## MR results - w/o outliers
MRPRESSO_results <- list.files(output_data, recursive = T, pattern = '_MRPRESSO_Results.csv', full.names = T) %>% 
  map(., function(x){
    dat.model <- tibble(file = x) %>% 
      mutate(file = str_replace(file, paste0(output_data, '/'), "")) %>%
      separate(file, c('exposure', 'outcome', 'file'), sep = '/', remove = F) %>% 
      mutate(file = ifelse(is.na(file), outcome, file)) %>% 
      mutate(outcome = ifelse(grepl('SNPs', outcome), NA, outcome)) %>% 
      separate(file, c('X1', 'pt', 'X2', 'X3', 'X4'), sep = '_') %>% 
      select(-X1, -X2, -X3, -X4)
    datin <- read_csv(x, col_types = list(nsnp = col_character(), b = col_character(), 
                                          se = col_character(), pval = col_character())) %>% 
      mutate(pt = dat.model$pt)
  }) %>% 
  bind_rows() %>% 
  filter(!is.na(b)) %>% 
  mutate(nsnp = as.numeric(nsnp), b = as.numeric(b), se = as.numeric(se), pval = as.numeric(pval))

## Combine MR results
MR_results <- MRdat_results  %>% 
  mutate(MR_PRESSO = FALSE) %>% 
  bind_rows(MRPRESSO_results) %>% 
  mutate(MR_PRESSO = ifelse(is.na(MR_PRESSO), TRUE, MR_PRESSO))
write_tsv(MR_results, gzfile(paste0(output_data, '/', '0_Summary/','MR_results.txt.gz')))

## ===============================================## 
## Heterogenity
## ===============================================## 

heterogenity <- list.files(output_data, recursive = T, pattern = '_MR_heterogenity.csv', full.names = T) %>% 
  map(., function(x){
    dat.model <- tibble(file = x) %>% 
      mutate(file = str_replace(file, paste0(output_data, '/'), "")) %>%
      separate(file, c('exposure', 'outcome', 'file'), sep = '/', remove = F) %>% 
      mutate(file = ifelse(is.na(file), outcome, file)) %>% 
      mutate(outcome = ifelse(grepl('SNPs', outcome), NA, outcome)) %>% 
      separate(file, c('X1', 'pt', 'X2', 'X3'), sep = '_') %>% 
      select(-X1, -X2, -X3)
    datin <- read_csv(x) %>% 
      mutate(pt = dat.model$pt)
  }) %>% 
  bind_rows() %>% 
  mutate(method = str_replace_all(method, c("Inverse variance weighted" = 'IVW',
                                            "MR Egger" = "Egger"))) %>% 
  select(-id.exposure, -id.outcome, -date) %>% 
  mutate(violated = Q_pval < 0.05)

het <- left_join(filter(heterogenity, method == 'Egger'), 
                 filter(heterogenity, method == 'IVW'), 
                 by = c('exposure', 'outcome', 'pt'), suffix = c('.Egger', '.IVW')) %>% 
  select(-method.Egger, -method.IVW)

## ===============================================## 
## MR-Egger Pleitropy - w/ outliers
## ===============================================## 

## w/ outliers retained
egger <- list.files(output_data, recursive = T, pattern = '_MR_egger_plei.csv', full.names = T) %>% 
  map(., function(x){
    dat.model <- tibble(file = x) %>% 
      mutate(file = str_replace(file, paste0(output_data, '/'), "")) %>%
      separate(file, c('exposure', 'outcome', 'file'), sep = '/', remove = F) %>% 
      mutate(file = ifelse(is.na(file), outcome, file)) %>% 
      mutate(outcome = ifelse(grepl('SNPs', outcome), NA, outcome)) %>% 
      separate(file, c('X1', 'pt', 'X2', 'X3', 'X4', 'X5'), sep = '_') %>% 
      select(-X1, -X2, -X3, -X4, -X5)
    datin <- read_csv(x) %>% 
      mutate(pt = dat.model$pt)
  }) %>% 
  bind_rows() %>% 
  select(exposure, outcome, pt, egger_intercept, se, pval) %>% 
  rename(egger_se = se) %>%
  mutate(violated = pval < 0.05)  %>% 
  mutate(outliers_removed = FALSE)

## w/ outliers removed
mrpresso_egger <- list.files(output_data, recursive = T, pattern = '_MRPRESSO_egger_plei.csv', full.names = T) %>% 
  map(., function(x){
    dat.model <- tibble(file = x) %>% 
      mutate(file = str_replace(file, paste0(output_data, '/'), "")) %>%
      separate(file, c('exposure', 'outcome', 'file'), sep = '/', remove = F) %>% 
      mutate(file = ifelse(is.na(file), outcome, file)) %>% 
      separate(file, c('X1', 'pt', 'X2', 'X3', 'X4', 'X5'), sep = '_') %>% 
      select(-X1, -X2, -X3, -X4, -X5)
    datin <- read_csv(x) %>% 
      mutate(pt = dat.model$pt)
  }) %>% 
  bind_rows() %>% 
  select(exposure, outcome, pt, egger_intercept, se, pval) %>% 
  rename(egger_se = se) %>%
  mutate(violated = pval < 0.05)  %>% 
  mutate(outliers_removed = TRUE)

## Combine MR-Egger Pleitropy results 
egger_comb <- egger %>% 
  bind_rows(mrpresso_egger)
write_tsv(egger_comb, gzfile(paste0(output_data, '/', '0_Summary/','egger_comb.txt.gz')))

## ===============================================## 
## Mean F statistic
mf <- list.files(output_data, recursive = T, pattern = '_mean_F.csv', full.names = T) %>% 
  map(., function(x){
    dat.model <- tibble(file = x) %>% 
      mutate(file = str_replace(file, paste0(output_data, '/'), "")) %>%
      separate(file, c('exposure', 'outcome', 'file'), sep = '/', remove = F) %>% 
      mutate(file = ifelse(is.na(file), outcome, file)) %>% 
      mutate(outcome = ifelse(grepl('SNPs', outcome), NA, outcome)) %>% 
      separate(file, c('X1', 'pt', 'X2', 'X3', 'X4'), sep = '_') %>% 
      select(-X1, -X2, -X3, -X4)
    datin <- read_csv(x) %>% 
      mutate(pt = dat.model$pt)
  }) %>% 
  bind_rows() %>% 
  select(exposure, outcome, pt, nsnps, mean_F) 


## ===============================================## 
## Combine Results together
## ===============================================## 

MRsummary <- MRdat_results  %>% 
  mutate(MR_PRESSO = FALSE) %>% 
  bind_rows(MRPRESSO_results) %>% 
  mutate(MR_PRESSO = ifelse(is.na(MR_PRESSO), TRUE, MR_PRESSO)) %>%
  select(-id.exposure, -id.outcome, -date) %>% 
  mutate(method = str_replace(method, "Inverse variance weighted \\(fixed effects\\)", 'IVW')) %>%
  left_join(select(het, outcome, exposure, pt, violated.Egger, violated.IVW),  
            by = c('outcome', 'exposure', 'pt')) %>% 
  rename(violated.Q.Egger = violated.Egger, violated.Q.IVW = violated.IVW) %>% 
  left_join(select(mrpresso_global_comb, outcome, exposure, pt, n_outliers, violated, outliers_removed), 
            by = c('outcome', 'exposure', 'pt', 'MR_PRESSO' = 'outliers_removed')) %>% 
  rename(violated.MRPRESSO = violated) %>% 
  left_join(select(egger, outcome, exposure, pt, violated), 
            by = c('outcome', 'exposure', 'pt')) %>% 
  rename(violated.Egger = violated) %>% 
  mutate(violated.Q.Egger = ifelse(method == 'IVW', violated.Q.Egger, NA)) %>% 
  mutate(violated.Q.IVW = ifelse(method == 'IVW', violated.Q.IVW, NA)) %>% 
  mutate(n_outliers = ifelse(method == 'IVW', n_outliers, NA)) %>% 
  mutate(violated.MRPRESSO = ifelse(method == 'IVW', violated.MRPRESSO, NA)) %>% 
  mutate(violated.Egger = ifelse(method == 'IVW', violated.Egger, NA)) %>% 
  select(outcome, exposure, pt, method, MR_PRESSO, nsnp, b, se, pval, n_outliers, 
         violated.MRPRESSO, violated.Egger, violated.Q.Egger, violated.Q.IVW) %>% 
  arrange(outcome, exposure, pt, method, MR_PRESSO)
  
#write_tsv(MRsummary, '~/Dropbox/Research/PostDoc-MSSM/2_MR/Shiny/MR_Results_summary.txt')
write_tsv(MRsummary, paste0(output_data, '/', '0_Summary/','MR_Results_summary.txt'))



































