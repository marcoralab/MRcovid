#!/usr/bin/Rscript
## Run MR analysis and Senstivity analysis for w/ outliers retained and removed

library(tidyverse)
library(TwoSampleMR) ## For conducting MR https://mrcieu.github.io/TwoSampleMR/

input = snakemake@input[["mrdat"]] # Harmonized MR data
output = snakemake@params[["out"]] # Output

mrdat <- read_csv(input) %>%
  filter(mr_keep == TRUE) %>%
  filter(pleitropy_keep == TRUE)

pt = mrdat %>% slice(1) %>% pull(pt)
n_outliers <- nrow(mrdat %>% filter(mr_keep == TRUE)) - nrow(mrdat %>% filter(mr_keep == TRUE) %>% filter(mrpresso_keep == TRUE))

## ================= w/ outliers ================= ##
## MR analysis
mr_res <- mr(mrdat, method_list = c("mr_ivw_fe", "mr_weighted_median", "mr_weighted_mode", "mr_egger_regression")) %>%
  as_tibble() %>%
  mutate(outliers_removed = FALSE) %>%
  mutate(n_outliers = n_outliers) %>%
  mutate(pt = pt) %>%
  select(id.exposure, id.outcome, outcome, exposure, pt, outliers_removed, method, nsnp, n_outliers, b, se, pval)

## Cochrans Q heterogeneity test
mr_heterogenity <- mr_heterogeneity(mrdat, method_list=c("mr_egger_regression", "mr_ivw")) %>%
  as_tibble() %>%
  mutate(outliers_removed = FALSE) %>%
  mutate(pt = pt) %>%
  select(id.exposure, id.outcome, outcome, exposure, pt, outliers_removed, method, Q, Q_df, Q_pval)

## MR Egger Test of Pliotropy
mr_plei <- mr_pleiotropy_test(mrdat) %>%
  as_tibble() %>%
  mutate(outliers_removed = FALSE) %>%
  mutate(pt = pt) %>%
  select(id.exposure, id.outcome, outcome, exposure, pt, outliers_removed, egger_intercept, se, pval)

## ================= w/o outliers ================= ##
if(n_outliers >= 1){
  ## Remove outliers
  mrdat_mrpresso <- filter(mrdat, mrpresso_keep == T)

  ## MR, Heterogenity, and Pleitorpy Tests
  mrpresso_res <- mr(mrdat_mrpresso, method_list = c("mr_ivw_fe", "mr_weighted_median", "mr_weighted_mode", "mr_egger_regression")) %>%
    as_tibble() %>%
    mutate(outliers_removed = TRUE) %>%
    mutate(n_outliers = n_outliers) %>%
    mutate(pt = pt) %>%
    select(id.exposure, id.outcome, outcome, exposure, pt, outliers_removed, method, nsnp, n_outliers, b, se, pval)
  mrpresso_heterogenity <- mr_heterogeneity(mrdat_mrpresso, method_list=c("mr_egger_regression", "mr_ivw")) %>%
    as_tibble() %>%
    mutate(outliers_removed = TRUE) %>%
    mutate(pt = pt) %>%
    select(id.exposure, id.outcome, outcome, exposure, pt, outliers_removed, method, Q, Q_df, Q_pval)
  mrpresso_plei <- mr_pleiotropy_test(mrdat_mrpresso) %>%
    as_tibble() %>%
    mutate(outliers_removed = TRUE) %>%
    mutate(pt = pt) %>%
    select(id.exposure, id.outcome, outcome, exposure, pt, outliers_removed, egger_intercept, se, pval)

}else{
  ## If no outliers are removed, make empty dataframes
  mrpresso_res <- data.frame(id.exposure = as.character(mrdat[1,'id.exposure']),
                             id.outcome = as.character(mrdat[1,'id.outcome']),
                             outcome = as.character(mrdat[1,'outcome']),
                             exposure = as.character(mrdat[1,'exposure']),
                             pt = pt,
                             outliers_removed = NA,
                             method = 'mrpresso',
                             nsnp = NA,
                             n_outliers = NA,
                             b = NA,
                             se = NA,
                             pval = NA)
  mrpresso_heterogenity <- data.frame(
    id.exposure = as.character(mrdat[1,'id.exposure']),
    id.outcome = as.character(mrdat[1,'id.outcome']),
    outcome = as.character(mrdat[1,'outcome']),
    exposure = as.character(mrdat[1,'exposure']),
    pt = pt,
    outliers_removed = NA,
    method = 'mrpresso',
    Q = NA,
    Q_df = NA,
    Q_pval = NA)
  mrpresso_plei <- data.frame(
    id.exposure = as.character(mrdat[1,'id.exposure']),
    id.outcome = as.character(mrdat[1,'id.outcome']),
    outcome = as.character(mrdat[1,'outcome']),
    exposure = as.character(mrdat[1,'exposure']),
    pt = pt,
    outliers_removed = NA,
    method = 'mrpresso',
    egger_intercept = NA,
    se = NA,
    pval = NA)
  }

## ================= bind results ================= ##
res_mr <- bind_rows(mr_res, mrpresso_res) %>%
  filter(!is.na(outliers_removed))
res_heterogenity <- bind_rows(mr_heterogenity, mrpresso_heterogenity) %>%
  filter(!is.na(outliers_removed))
res_plei <- bind_rows(mr_plei, mrpresso_plei) %>%
  filter(!is.na(outliers_removed))

## ================= Write Out ================= ##
res_heterogenity %>% write_tsv(paste0(output, '_MR_heterogenity.txt'))
res_plei %>% write_tsv(paste0(output, '_MR_egger_plei.txt'))
res_mr %>% write_tsv(paste0(output, '_MR_Results.txt'))
