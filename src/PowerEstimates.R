## Load librarys and functions
library(tidyverse)
library(TwoSampleMR)
source('src/PowerFunctions.R', chdir = TRUE)
source('scripts/miscfunctions.R', chdir = TRUE)

infile = snakemake@input[["infile"]]
outfile = snakemake@output[["outfile"]]

## -------------------------------------------------------------------------------- ##
## Read in Harmonized datasets 

MRdat.raw <- infile %>% 
  read_csv(., guess_max = 1000)

n_outliers <- MRdat.raw %>% 
  summarise(., n_outliers = sum(!mrpresso_keep, na.rm = TRUE)) %>% 
  pull(n_outliers)

std.MRdat <- MRdat.raw %>% 
  filter(pleitropy_keep == TRUE) %>%
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
  ## Standardize continous outcomes
  mutate(st_beta.outcome = ifelse(logistic.outcome == FALSE, 
                                  std_beta(z.outcome, eaf.outcome, samplesize.outcome),
                                  beta.outcome),
         st_se.outcome = ifelse(logistic.outcome == FALSE,
                                std_se(z.outcome, eaf.outcome, samplesize.outcome),
                                se.outcome)) %>%
  ## Standardize all exposures
  mutate(st_beta.exposure = std_beta(z.exposure, eaf.exposure, samplesize.exposure),
         st_se.exposure = std_se(z.exposure, eaf.exposure, samplesize.exposure)) %>%
  mutate(beta.outcome = st_beta.outcome, 
         se.outcome = st_se.outcome, 
         beta.exposure = st_beta.exposure, 
         se.exposure = st_se.exposure)

## -------------------------------------------------------------------------------- ##
##            Rerun IVW MR analysis using standardized beta estimates 
##            Outliers retained
std.res <- mr(std.MRdat, method_list = c("mr_ivw_fe")) %>% 
  as_tibble(.) %>% 
  mutate(outliers_removed = FALSE) %>%
  left_join(select(samplesize, code, logistic), by = c('outcome' = 'code')) %>% 
  mutate(or = ifelse(logistic == TRUE, exp(b), NA)) %>%
  mutate(beta = ifelse(logistic == FALSE, b, NA))

## Join std MR results with summary data for power analysis
mrdat.power <- std.MRdat %>% 
  filter(mr_keep == TRUE) %>%
  mutate(pve.exposure = snp.pve(eaf.exposure, beta.exposure, se.exposure, samplesize.exposure)) %>% 
  summarise(exposure = first(exposure), 
            outcome = first(outcome),
            pt = first(pt),
            pve.exposure = sum(pve.exposure), 
            samplesize.exposure = max(samplesize.exposure), 
            samplesize.outcome = max(samplesize.outcome), 
            nsnps = n(), 
            k.outcome = max(ncase.outcome)/max(samplesize.outcome)) %>% 
  left_join(std.res, by = c('exposure', 'outcome', "nsnps" = 'nsnp')) %>% 
  select(-id.exposure, -id.outcome)


## -------------------------------------------------------------------------------- ##
##            Rerun IVW MR analysis using standardized beta estimates 
##            Outliers retained

if(n_outliers > 0){
  std.res_wo_outliers <- std.MRdat %>% 
    filter(mrpresso_keep == TRUE) %>% 
    mr(., method_list = c("mr_ivw_fe")) %>% 
    as_tibble(.) %>% 
    mutate(outliers_removed = TRUE) %>%
    left_join(select(samplesize, code, logistic), by = c('outcome' = 'code')) %>% 
    mutate(or = ifelse(logistic == TRUE, exp(b), NA)) %>%
    mutate(beta = ifelse(logistic == FALSE, b, NA))
  
  mrdat.power_wo_outliers <- std.MRdat %>% 
    filter(mr_keep == TRUE) %>%
    filter(mrpresso_keep == TRUE) %>%
    mutate(pve.exposure = snp.pve(eaf.exposure, beta.exposure, se.exposure, samplesize.exposure)) %>% 
    summarise(exposure = first(exposure), 
              outcome = first(outcome),
              pt = first(pt),
              pve.exposure = sum(pve.exposure), 
              samplesize.exposure = max(samplesize.exposure), 
              samplesize.outcome = max(samplesize.outcome), 
              nsnps = n(), 
              k.outcome = max(ncase.outcome)/max(samplesize.outcome)) %>% 
    left_join(std.res_wo_outliers, by = c('exposure', 'outcome', "nsnps" = 'nsnp')) %>% 
    select(-id.exposure, -id.outcome)
  
}

## -------------------------------------------------------------------------------- ##
##                        Power to detect observed effect                           ##

observed_power.df <- mrdat.power %>% 
  {if(n_outliers > 0) bind_rows(., mrdat.power_wo_outliers) else .} %>%
  split(., as.factor(1:nrow(.))) %>% 
  map_dfr(., function(dat){
    message('Processing: ', dat$exposure, ' - ', dat$outcome, ' - ', dat$pt)
    if(dat$logistic == TRUE){
      results_binary(dat)
    } else {
      results_beta_based(dat)
    }
  }) 

write_tsv(observed_power.df, outfile)































