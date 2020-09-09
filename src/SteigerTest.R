.libPaths(c(snakemake@params[["rlib"]], .libPaths()))

library(tidyverse)
library(TwoSampleMR)
source('scripts/miscfunctions.R', chdir = TRUE)

## estimate r for binary or continouse exposures/outcomes
r_func <- function(x){
  x$r.exposure <- if(logistic.exposure == TRUE){
    x %>% 
      mutate(r.exposure = get_r_from_lor(.$beta.exposure, .$eaf.exposure, .$ncase.exposure, .$ncontrol.exposure, .$prevelance.exposure)) %>% pull(r.exposure)
  } else if(logistic.exposure == FALSE){
    x %>% mutate(r.exposure = get_r_from_pn(.$pval.exposure, .$samplesize.exposure)) %>% pull(r.exposure)
  }
  
  x$r.outcome <- if(logistic.outcome == TRUE){
    x %>% mutate(r.outcome = get_r_from_lor(.$beta.outcome, .$eaf.outcome, .$ncase.outcome, .$ncontrol.outcome, .$prevelance.outcome)) %>% pull(r.outcome)
  } else if(logistic.outcome == FALSE){
    x %>% mutate(r.outcome = get_r_from_pn(.$pval.outcome, .$samplesize.outcome)) %>% pull(r.outcome)
  } 
  x
}
## -------------------- TEST -------------------------##
# exposure.code = "Kunkle2019load"
# outcome.code = "Yengo2018bmi"
# p.threshold = "5e-8"
# dataout = "data/MR_ADbidir/"
# 
# harmonized.dat = glue(dataout, "{exposure.code}/{outcome.code}/{exposure.code}_{p.threshold}_{outcome.code}_mrpresso_MRdat.csv")

## -------------------- Load/Wrangle Data -------------------------##
harmonized.dat = snakemake@input[["mrdat"]] # Harmonized MR data
pt = snakemake@params[["pt"]]
outfile = snakemake@output[["outfile"]] # Output

mrdat.raw <- read_csv(harmonized.dat)
mrdat <- mrdat.raw %>%
  filter(pleitropy_keep == TRUE, mrkeep = TRUE) %>%
  select(-samplesize.outcome, -samplesize.exposure) %>%
  left_join(samplesize, by = c('exposure' = 'code')) %>% 
  rename(samplesize.exposure = samplesize, 
         ncase.exposure = ncase, 
         ncontrol.exposure = ncontrol, 
         logistic.exposure = logistic, 
         exposure.name = trait, 
         prevelance.exposure = prevelance) %>% 
  left_join(samplesize, by = c('outcome' = 'code')) %>% 
  rename(samplesize.outcome = samplesize, 
         ncase.outcome = ncase, 
         ncontrol.outcome = ncontrol, 
         logistic.outcome = logistic, 
         outcome.name = trait, 
         prevelance.outcome = prevelance) %>%
  select(-domain.y, -domain.x, -pmid.x, -pmid.y) 

logistic.exposure <- mrdat %>% slice(1) %>% pull(logistic.exposure)
logistic.outcome <- mrdat %>% slice(1) %>% pull(logistic.outcome)

mrdat <- r_func(mrdat) 

## -------------------- Directionality Test -------------------------##
steiger_outliers <- directionality_test(mrdat) %>% 
  mutate(outliers_removed = FALSE, 
         pt = pt)

steiger_out <- steiger_outliers

if(sum(!mrdat$mrpresso_keep, na.rm = TRUE) > 0){

  steiger_wo_outliers <- mrdat %>% 
    filter(mrpresso_keep == TRUE) %>%
    directionality_test(.) %>% 
    mutate(outliers_removed = TRUE, 
           pt = pt) %>% 
    bind_rows(steiger_outliers)
  steiger_out <- steiger_wo_outliers
}

## -------------------- Write -------------------------##

write_tsv(steiger_out, outfile)




























