#!/usr/bin/Rscript

### ===== Command Line Arguments ===== ##
args = commandArgs(trailingOnly = TRUE) # Set arguments from the command line

infile = args[1] # Exposure summary statistics
out = args[2]

### ===== Load packages ===== ###
suppressMessages(library(tidyverse))   ## For data wrangling
suppressMessages(library(RadialMR)) ## For detecting pleitropy

mrdat.raw <- read_csv(infile)

## Format data for RadialMR
## Run IVW Radial Regression 
radial.dat <- filter(mrdat.raw, mr_keep == TRUE) %>% 
  with(., format_radial(beta.exposure, beta.outcome, se.exposure, se.outcome, SNP)) 

sink(paste0(out, '.txt'), append=FALSE, split=FALSE)
radial.out <- ivw_radial(radial_dat, weights = 3, alpha = 0.05/nrow(radial_dat))
sink()

## Merge Outliers with MR Data
mrdat.out <- mrdat.raw %>%
  left_join(select(radial.out$data, SNP, Qj, Qj_Chi, Outliers), by = 'SNP') %>%
  rename(Q_statistic = Qj, Q_pval = Qj_Chi) %>% 
  mutate(Outliers = fct_recode(Outliers, 'FALSE' = 'Variant', 'TRUE' = 'Outlier'), Outliers = as.logical(Outliers)) 

## Extracting Radial regression MR estimates 
# radial.ivw <- as_tibble(radial.out$coef) %>% 
#   mutate(model = 'Effect (Mod.2nd)') %>% 
#   rename(b = Estimate, se = 'Std. Error', t.stat = 't value', p = 'Pr(>|t|)')
# radial.ivw.iterative <- as_tibble(radial.out$it.coef) %>% 
#   mutate(model = 'Iterative') %>% 
#   rename(b = Estimate, se = 'Std.Error', t.stat = 't value', p = 'Pr(>|t|)')
# radial.ivw.exact_f <- as_tibble(radial.out$fe.coef) %>% 
#   mutate(model = 'Exact (FE)') %>% 
#   rename(b = Estimate, se = 'Std.Error', t.stat = 't value', p = 'Pr(>|t|)')
# radial.ivw.exact_r <- as_tibble(radial.out$re.coef) %>% 
#   mutate(model = 'Iterative') %>% 
#   rename(b = Estimate, se = 'Std.Error', t.stat = 't value', p = 'Pr(>|t|)')

# radial.ivw %>% 
#   bind_rows(radial.ivw.iterative) %>% 
#   bind_rows(radial.ivw.exact_f) %>% 
#   select(model, b, se, t.stat, p)

## Modified Q Statistic Output
heterogenity.out <- tibble(
  id.exposure = as.character(mrdat[1,'id.exposure']),
  id.outcome = as.character(mrdat[1,'id.outcome']),
  outcome = as.character(mrdat[1,'outcome']),
  exposure = as.character(mrdat[1,'exposure']),
  pt = mrdat.raw %>% slice(1) %>% pull(pt),
  outliers_removed = FALSE, 
  n_outliers = sum(radial.out$data$Outliers == 'Outlier'),
  Q.statistic = radial.out$qstatistic,
  df = radial.out$df) %>% 
  mutate(p = pchisq(Q.statistic, df, lower.tail = FALSE))

## If Outliers detected, calculate Modified Q statistic after outlier removal
if (sum(mrdat.out$Outliers, na.rm = T) > 0){
  radial_wo_outliers.dat <- mrdat.out %>% 
    filter(mr_keep == TRUE) %>% 
    filter(Outliers == FALSE) %>% 
    with(., format_radial(beta.exposure, beta.outcome, se.exposure, se.outcome, SNP))
  
  sink(paste0(out, '.txt'), append=TRUE, split=FALSE)
  radial_wo_outliers.out <- ivw_radial(radial_wo_outliers.dat, weights = 3, alpha = 0.05/nrow(radial_wo_outliers.dat))
  sink()

  heterogenity_wo_outliers.out <- tibble(
    id.exposure = as.character(mrdat[1,'id.exposure']),
    id.outcome = as.character(mrdat[1,'id.outcome']),
    outcome = as.character(mrdat[1,'outcome']),
    exposure = as.character(mrdat[1,'exposure']),
    pt = mrdat.raw %>% slice(1) %>% pull(pt),
    outliers_removed = TRUE, 
    n_outliers = sum(radial_wo_outliers.out$data$Outliers == 'Outlier'),
    Q.statistic = radial_wo_outliers.out$qstatistic,
    df = radial_wo_outliers.out$df) %>% 
    mutate(p = pchisq(Q.statistic, df, lower.tail = FALSE))
  heterogenity.out <- heterogenity.out %>% bind_rows(heterogenity_wo_outliers.out)
}

write_tsv(mrpresso.dat, paste0(out, '_modifiedQ.txt'))
write_csv(mrdat.out, paste0(out, '_MRdat.csv'))
