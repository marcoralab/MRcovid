## ================================================================================ ##
##                                Formating output of results

## Packages & Functions
library(tidyverse)
library(TwoSampleMR)
library(gridExtra)
library(qvalue)
source('scripts/miscfunctions.R', chdir = TRUE)
# setwd("/Users/sheaandrews/GitCode/MR_ADPhenome")
model <- "MR_ADbidir"

## -------------------------------------------------------------------------------- ##
##  Read in R datasets
## Outcomes to include the results 

## Files
MR_results <- read_tsv(glue("results/{model}/All/MRresults.txt")) %>% 
  filter(outcome %in% outcomes) %>% 
  filter(exposure %in% exposures) 

MRdat.raw <- glue("results/{model}/All/mrpresso_MRdat.csv") %>% 
  read_csv(., guess_max = 100000) %>% 
  filter(outcome %in% outcomes) %>% 
  filter(exposure %in% exposures) 

mrpresso_global <- read_tsv(glue("results/{model}/All/global_mrpresso.txt")) %>% 
  filter(outcome %in% outcomes) %>% 
  filter(exposure %in% exposures) 

mrpresso_global_wo_outliers <- read_tsv(glue("results/{model}/All/global_mrpresso_wo_outliers.txt")) %>% 
  filter(outcome %in% outcomes) %>% 
  filter(exposure %in% exposures) 

mrpresso_global_comb <- bind_rows(mrpresso_global, mrpresso_global_wo_outliers)

egger_comb <- read_tsv(glue("results/{model}/All/pleiotropy.txt")) %>% 
  filter(outcome %in% outcomes) %>% 
  filter(exposure %in% exposures) %>% 
  rename(egger_se = se) 

power <- read_tsv(glue("results/{model}/All/power.txt")) %>% 
  filter(outcome %in% outcomes) %>% 
  filter(exposure %in% exposures) %>% 
  select(exposure, outcome, pt, outliers_removed, pve.exposure, F, Power) %>% 
  mutate(pve.exposure = round(pve.exposure*100, 2), 
         F = round(F, 2), 
         Power = round(Power, 2)) 

## -------------------------------------------------------------------------------- ##
## Table S1 - Harmonozied datasets 

MRdat <- MRdat.raw  %>% 
  ## Merge Sample Size information
  select(-samplesize.outcome, -samplesize.exposure) %>% 
  left_join(samplesize, by = c('exposure' = 'code')) %>% 
  rename(samplesize.exposure = samplesize, 
         ncase.exposure = ncase, 
         ncontrol.exposure = ncontrol, 
         logistic.exposure = logistic, 
         exposure.name = trait) %>% 
  left_join(samplesize, by = c('outcome' = 'code')) %>% 
  rename(samplesize.outcome = samplesize, 
         ncase.outcome = ncase, 
         ncontrol.outcome = ncontrol, 
         logistic.outcome = logistic, 
         outcome.name = trait) %>% 
  ## Arrange traits
  mutate(outcome.name = fct_relevel(outcome.name, 
                                    'LOAD', 'AAOS', 'AB42', 'Ptau181', 'Tau',
                                    'Neuritic Plaques', 'Neurofibrillary Tangles',
                                    'Vascular Brain Injury', 'Hippocampal Volume')) %>% 
  mutate(exposure.name = fct_relevel(exposure.name, 
                                     'Alcohol Consumption', 
                                     'AUDIT', 'Smoking Initiation', 
                                     'Cigarettes per Day', 'Diastolic Blood Pressure',
                                     'Systolic Blood Pressure', 'Pulse Pressure', 
                                     "High-density lipoproteins", 
                                     "Low-density lipoproteins", "Total Cholesterol",
                                     "Triglycerides", 'Educational Attainment', 
                                     'BMI', 'Type 2 Diabetes', "Oily Fish Intake",
                                     "Hearing Difficulties", "Insomnia Symptoms", 
                                     "Sleep Duration", "Moderate-to-vigorous PA",
                                     "Depression", 
                                     'Major Depressive Disorder', "Social Isolation"))

write_csv(MRdat, 'docs/TableS1.csv')

## -------------------------------------------------------------------------------- ##
##                              Shiny datasets                                      ## 

mrpresso_global_comb %>%
  write_tsv('shiny/mrpresso_global.txt')

MRdat %>%
  write_csv('shiny/HarmonizedMRdat.csv')

## -------------------------------------------------------------------------------- ##
##                               Merege datasets                                    ## 

MRsummary <- MR_results %>% 
  mutate(method = str_replace(method, "Inverse variance weighted \\(fixed effects\\)", 'IVW'), 
         method = str_replace(method, "MR Egger", 'Egger'), 
         method = str_replace(method, "Weighted median", 'WME'), 
         method = str_replace(method, "Weighted mode", 'WMBE')) %>%
  rename(MR.pval = pval) %>%
  ## Join MR-PRESSO Global results
  left_join(select(mrpresso_global_comb, outcome, exposure, pt, RSSobs, pval, outliers_removed), 
            by = c('outcome', 'exposure', 'pt', 'outliers_removed')) %>% 
  rename(MRPRESSO.pval = pval) %>% 
  ## Join Egger Intercept results
  left_join(select(egger_comb, outcome, exposure, pt, egger_intercept, egger_se, pval, outliers_removed), 
            by = c('outcome', 'exposure', 'pt', 'outliers_removed')) %>% 
  rename(Egger.pval = pval) %>% 
  select(outcome, exposure, pt, method, outliers_removed, nsnp, n_outliers, b, se, MR.pval, 
         RSSobs, MRPRESSO.pval, egger_intercept, egger_se, Egger.pval) %>% 
  arrange(outcome, exposure, pt, method, outliers_removed) %>% 
  ## Merge Sample Size information
  left_join(select(samplesize, code, trait), by = c('exposure' = 'code')) %>% 
  rename(exposure.name = trait) %>% 
  left_join(select(samplesize, code, trait), by = c('outcome' = 'code')) %>% 
  rename(outcome.name = trait) %>% 
  ## Arrange traits
  mutate(outcome.name = fct_relevel(
    outcome.name, 'LOAD', 'AAOS', 'AB42', 'Ptau181', 'Tau', 'Neuritic Plaques', 
    'Neurofibrillary Tangles', 'Vascular Brain Injury', 'Hippocampal Volume')) %>% 
  mutate(exposure.name = fct_relevel(
    exposure.name, 'Alcohol Consumption', 'AUDIT', 
    'Smoking Initiation', 'Cigarettes per Day', 'Diastolic Blood Pressure', 
    'Systolic Blood Pressure', 'Pulse Pressure', "High-density lipoproteins", 
    "Low-density lipoproteins", "Total Cholesterol", "Triglycerides", 
    'Educational Attainment', 'BMI', 'Type 2 Diabetes', "Oily Fish Intake", 
    "Hearing Difficulties", "Insomnia Symptoms", "Sleep Duration", "Moderate-to-vigorous PA",
    "Depression", 'Major Depressive Disorder', "Social Isolation"))

## -------------------------------------------------------------------------------- ##
##                Spread results by method and outlier removal                      ## 
##                Supplementary Table 2

## Spread by methods
mrresults.methods <- MRsummary %>% 
  mutate(b = signif(b, 2), 
         se = signif(se, 2), 
         MR.pval = signif(MR.pval, 2), 
         RSSobs = round(RSSobs, 1), 
         egger_intercept = signif(egger_intercept, 3), 
         egger_se = signif(egger_se, 2), 
         Egger.pval = signif(Egger.pval, 2)) %>%
  myspread(method, c(b, se, MR.pval)) %>% 
  mutate(IVW_Signif = as.character(signif.num(IVW_MR.pval)), 
         Egger_Signif = as.character(signif.num(Egger_MR.pval)),
         WME_Signif = as.character(signif.num(WME_MR.pval)), 
         WMBE_Signif = as.character(signif.num(WMBE_MR.pval))) 

## Spread by outlier removal MR-PRESSO
mrresults.methods_presso <- mrresults.methods %>% 
  left_join(power) %>% 
  myspread(outliers_removed, 
           c(nsnp, n_outliers, pve.exposure, F, Power, RSSobs, MRPRESSO.pval, egger_intercept, 
             egger_se, Egger.pval, IVW_b, IVW_MR.pval, IVW_se, Egger_b, Egger_MR.pval, 
             Egger_se, WME_b, WME_MR.pval, WME_se, 
             WMBE_b, WMBE_MR.pval, WMBE_se, IVW_Signif, 
             Egger_Signif, WME_Signif, WMBE_Signif)) %>% 
  arrange(pt, outcome, exposure) %>%
  arrange(outcome.name, exposure.name, pt) %>% 
  select(outcome, exposure, outcome.name, exposure.name, pt, FALSE_nsnp, FALSE_pve.exposure, FALSE_F, FALSE_n_outliers,
         FALSE_IVW_b, FALSE_IVW_se, FALSE_IVW_MR.pval, FALSE_IVW_Signif, FALSE_Power,
         FALSE_Egger_b, FALSE_Egger_se, FALSE_Egger_MR.pval, FALSE_Egger_Signif,  
         FALSE_WME_b, FALSE_WME_se, FALSE_WME_MR.pval, FALSE_WME_Signif, 
         FALSE_WMBE_b, FALSE_WMBE_se, FALSE_WMBE_MR.pval, FALSE_WMBE_Signif, 
         FALSE_RSSobs, FALSE_MRPRESSO.pval, FALSE_egger_intercept, FALSE_egger_se, FALSE_Egger.pval, 
         TRUE_IVW_b, TRUE_IVW_se, TRUE_IVW_MR.pval, TRUE_IVW_Signif, TRUE_Power,
         TRUE_Egger_b, TRUE_Egger_se, TRUE_Egger_MR.pval, TRUE_Egger_Signif, 
         TRUE_WME_b, TRUE_WME_se, TRUE_WME_MR.pval, TRUE_WME_Signif, 
         TRUE_WMBE_b, TRUE_WMBE_se, TRUE_WMBE_MR.pval, TRUE_WMBE_Signif,
         TRUE_RSSobs, TRUE_MRPRESSO.pval, TRUE_egger_intercept, TRUE_egger_se, TRUE_Egger.pval)

mrresults.methods_presso %>%
  write_csv('docs/TableS2.csv')

message('Number of tests: ', nrow(mrresults.methods_presso))
message('Number of Outcomes: ', nrow(distinct(mrresults.methods_presso, outcome.name)))
message('Number of tests: ', nrow(distinct(mrresults.methods_presso, exposure.name)))

## -------------------------------------------------------------------------------- ##
##                      Filter results for MR-PRESSO and best PT                    ## 
mr_res <- MRsummary %>% 
  filter(method == 'IVW') %>% 
  group_by(outcome, exposure, pt) %>% 
  filter(outliers_removed == ifelse(TRUE %in% outliers_removed, TRUE, FALSE)) %>% 
  ungroup()

## Generate FDR values
qobj <- qvalue(p = mr_res$MR.pval, fdr.level = 0.1)
qvales.df <- tibble(pvalues = qobj$pvalues, lfdr = qobj$lfdr, 
                    qval = qobj$qvalues, significant = qobj$significant)

mr_best <- mr_res %>% 
  bind_cols(select(qvales.df, qval)) %>% 
  group_by(outcome, exposure) %>% 
  arrange(MR.pval) %>% 
  slice(1) %>% 
  ungroup() %>% 
  select(outcome, exposure, pt, outliers_removed, qval) %>%
  left_join(mrresults.methods, by = c('outcome', 'exposure', 'pt', 'outliers_removed')) %>% 
  mutate(MRPRESSO.pval_rm = as.numeric(str_replace(MRPRESSO.pval, '<', ""))) %>% 
  mutate(pass = ifelse(qval > 0.05, FALSE,
                       ifelse(MRPRESSO.pval_rm > 0.05 & Egger.pval > 0.05, TRUE,
                              ifelse(Egger_MR.pval < 0.05 | WME_MR.pval < 0.05 | WMBE_MR.pval < 0.05, TRUE, FALSE))))  %>% 
  split(., 1:nrow(.)) %>% 
  map(., function(x){
    x %>% 
      mutate(pass = ifelse(pass == FALSE, FALSE, passfunc(IVW_MR.pval, IVW_b, 
                                                        Egger_MR.pval, Egger_b, 
                                                        WME_MR.pval, WME_b, 
                                                        WMBE_MR.pval, WMBE_b)))
  }) %>% bind_rows(.) 
write_csv(mr_best, 'results/MR_ADphenome/All/MRbest.csv')

## -------------------------------------------------------------------------------- ##
##                          Formating Results for Table 2                           ##

out.final <- mr_best %>% 
  mutate(IVW = paste0(IVW_b, '\n(',IVW_se, ')')) %>% 
  mutate(`MR-Egger` = paste0(Egger_b, '\n(', Egger_se, ')', Egger_Signif)) %>% 
  mutate(`Weighted median` = paste0(WME_b, '\n(',WME_se, ')', WME_Signif)) %>%
  mutate(`Weighted mode` = paste0(WMBE_b, '\n(',WMBE_se, ')', WMBE_Signif)) %>%
  select(outcome, exposure, outcome.name, exposure.name, pt, nsnp, n_outliers, IVW, qval, 
         `MR-Egger`, `Weighted median`, `Weighted mode`, MRPRESSO.pval, Egger.pval, pass) %>% 
  mutate(Egger.pval = round_sci(Egger.pval)) %>%
  mutate(qval = round_sci(qval)) %>%
  arrange(outcome.name, exposure.name) %>% 
  mutate(nsnp = nsnp + n_outliers) %>% 
  filter(as.numeric(qval) < 0.1) %>% 
  arrange(outcome.name, exposure.name)

write_csv(out.final, 'docs/Table_2.csv')





















