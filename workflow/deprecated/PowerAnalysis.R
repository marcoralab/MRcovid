## ================================================================================ ##
##                        Conduct power analysis                                    ##

## Load librarys and functions
library(tidyverse)
library(ggiraph)
library(TwoSampleMR)
source('src/PowerFunctions.R', chdir = TRUE)
source('scripts/miscfunctions.R', chdir = TRUE)

## -------------------------------------------------------------------------------- ##
## Read in Harmonized datasets 

std.MRdat <- "results/MR_ADphenome/All/mrpresso_MRdat.csv" %>% 
  read_csv(., guess_max = 100000) %>% 
  filter(outcome %in% outcomes) %>% 
  filter(exposure %in% exposures) %>% 
  select(-samplesize.outcome, 
         -samplesize.exposure) %>% 
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
  group_by(exposure, outcome, pt) %>%
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
  ungroup() %>%
  mutate(beta.outcome = st_beta.outcome, 
         se.outcome = st_se.outcome, 
         beta.exposure = st_beta.exposure, 
         se.exposure = st_se.exposure) %>% 
  ## Remove variants where pval.outcome < 5e-8
  filter(pval.outcome > 5e-8)


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
  group_by(exposure, outcome, pt) %>% 
  mutate(pve.exposure = snp.pve(eaf.exposure, beta.exposure, se.exposure, samplesize.exposure)) %>% 
  summarise(pve.exposure = sum(pve.exposure), 
            samplesize.exposure = max(samplesize.exposure), 
            samplesize.outcome = max(samplesize.outcome), nsnps = n(), 
            k.outcome = max(ncase.outcome)/max(samplesize.outcome)) %>% 
  ungroup(.) %>% 
  arrange(-pve.exposure) %>%
  left_join(std.res, by = c('exposure', 'outcome', 'nsnps' = 'nsnp')) %>% 
  select(-id.exposure, -id.outcome)
  

## -------------------------------------------------------------------------------- ##
##            Rerun IVW MR analysis using standardized beta estimates 
##            Models in which outliers are removed 
outlier_models <- std.MRdat %>% 
  filter(mr_keep == TRUE) %>%
  group_by(exposure, outcome, pt) %>% 
  summarize(n = sum(!mrpresso_keep)) %>% 
  ungroup() %>%
  filter(n > 0)

std.res_wo_outliers <- std.MRdat %>% 
  filter(mr_keep == TRUE) %>%
  filter(mrpresso_keep == TRUE) %>% 
  semi_join(outlier_models) %>% 
  mr(., method_list = c("mr_ivw_fe")) %>% 
  as_tibble(.) %>% 
  mutate(outliers_removed = TRUE) %>%
  left_join(select(samplesize, code, logistic), by = c('outcome' = 'code')) %>% 
  mutate(or = ifelse(logistic == TRUE, exp(b), NA)) %>%
  mutate(beta = ifelse(logistic == FALSE, b, NA))

## Join std MR results with summary data for power analysis
mrdat.power_wo_outliers <- std.MRdat %>% 
  filter(mr_keep == TRUE) %>%
  filter(mrpresso_keep == TRUE) %>%
  semi_join(outlier_models) %>% 
  group_by(exposure, outcome, pt) %>% 
  mutate(pve.exposure = snp.pve(eaf.exposure, beta.exposure, se.exposure, samplesize.exposure)) %>% 
  summarise(pve.exposure = sum(pve.exposure), 
            samplesize.exposure = max(samplesize.exposure), 
            samplesize.outcome = max(samplesize.outcome), nsnps = n(), 
            k.outcome = max(ncase.outcome)/max(samplesize.outcome)) %>% 
  ungroup(.) %>% 
  arrange(-pve.exposure) %>%
  left_join(std.res_wo_outliers, by = c('exposure', 'outcome', 'nsnps' = 'nsnp')) %>% 
  select(-id.exposure, -id.outcome)

## -------------------------------------------------------------------------------- ##
##                        Power to detect observed effect                           ##

observed_power.df <- mrdat.power %>% 
  bind_rows(mrdat.power_wo_outliers) %>%
  #mutate(beta = ifelse(sign(beta) == 1, beta, beta * -1)) %>% 
  #mutate(or = ifelse(or > 1, or, 1 / or)) %>%
  split(., as.factor(1:nrow(.))) %>% 
  map(., function(dat){
    message('Processing: ', dat$exposure, ' - ', dat$outcome, ' - ', dat$pt)
    if(dat$logistic == TRUE){
      results_binary(dat)
    } else {
      results_beta_based(dat)
    }
  }) %>% 
  bind_rows() %>% 
  mutate(model = paste0(exposure, ' - ', outcome, ' - ', pt)) %>%
  mutate(Beta = ifelse(!is.na(or), log(or), beta)) 

write_csv(observed_power.df, "results/MR_ADphenome/All/power.csv")

sm.obs <- arrange(observed_power.df, -Power) %>% 
  select(exposure, outcome, pt, outliers_removed, b, or, se, pval, pve.exposure, Power) %>% 
  mutate(pval = round_sci(pval)) 
# sm.obs %>% filter(is.na(Power))


ggplot(observed_power.df, aes(x = pval, y = Power, colour = logistic)) + geom_point() + 
  geom_hline(yintercept = 0.8, linetype = 2, colour = 'red') + 
  geom_vline(xintercept = 0.05, linetype = 2, colour = 'red') + 
  theme_bw()

# g1 <- ggplot(observed_power.df, aes(x = pval, y = Power, colour = logistic)) + geom_point_interactive(aes(tooltip = model), size = 2) 
# girafe(code = print(g1))

## -------------------------------------------------------------------------------- ##
##                    Find estimate that gives 80% Power
power_80.df <- mrdat.power  %>% 
  bind_rows(mrdat.power_wo_outliers) %>%  
  split(., as.factor(1:nrow(.))) %>% 
  map(., function(dat){
    if(dat$logistic == TRUE){
      message('Processing Binary: ', dat$exposure, ' - ', dat$outcome, ' - ', dat$pt)
      find_power_binary(dat, verbose = FALSE)
    } else {
      message('Processing Continous: ', dat$exposure, ' - ', dat$outcome, ' - ', dat$pt)
      find_power_cont(dat, verbose = FALSE)
    }
  }) %>% bind_rows() %>% 
  mutate(Beta = ifelse(!is.na(OR), log(OR), byx)) 

sm.80 <- arrange(power_80.df, -pve.exposure) %>% 
  select(exposure, outcome, b, or, pval, pve.exposure, byx, OR, Power) %>% 
  mutate(pval = round_sci(pval)) 
#View(sm.80)

power_80.df %>% 
  mutate(Beta = ifelse(!is.na(OR), log(OR), byx)) %>% 
  ggplot(., aes(x = b, y = Beta, colour = logistic)) + geom_point()

power_80.df %>% 
  #filter(exposure == 'Wray2018mdd', outcome == 'Hilbar2017hipv' ) %>% 
  filter(outcome == 'Kunkle2019load') %>% 
  ggplot(., aes(x = Beta, y = Power, colour = exposure)) + geom_smooth()


