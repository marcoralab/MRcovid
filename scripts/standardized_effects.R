library(tidyverse)
library(TwoSampleMR)
library(qvalue)

MRdat <- "results/MR_ADphenome/All/mrpresso_MRdat.csv" %>% 
  read_csv(., guess_max = 100000)

forbiden_exposures <- c("Liu2019drnkwk", "Walters2018alcdep", "SanchezRoige2018auditt",  "Lee2018educ")
std.MRdat <- MRdat %>% 
  filter(outcome %in% outcomes) %>% 
  filter(exposure %in% exposures) %>% 
  filter(!(outcome == 'Kunkle2019load' & exposure %in% forbiden_exposures)) %>%
  filter(!(outcome == 'Lambert2013load' & exposure %nin% forbiden_exposures)) %>% 
  filter(!(outcome == 'Hilbar2017hipv' & exposure %in% forbiden_exposures)) %>%
  filter(!(outcome == 'Hilbar2015hipv' & exposure %nin% forbiden_exposures)) %>%
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
         se.exposure = st_se.exposure)

## -------------------------------------------------------------------------------- ##
##            Rerun IVW MR analysis using standardized beta estimates 
##            Outliers retained
std.res_w_outliers <- mr(std.MRdat, method_list = c("mr_ivw_fe")) %>% 
  as_tibble(.) %>% 
  mutate(outliers_removed = FALSE, 
         exposure = as.character(exposure), 
         outcome = as.character(outcome), 
         method = as.character(method), 
         id.exposure = as.character(id.exposure),
         id.outcome = as.character(id.outcome))

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
  mutate(outliers_removed = TRUE, 
         exposure = as.character(exposure), 
         outcome = as.character(outcome), 
         method = as.character(method), 
         id.exposure = as.character(id.exposure),
         id.outcome = as.character(id.outcome))  

## -------------------------------------------------------------------------------- ##
##                      Filter results for MR-PRESSO and best PT                    ## 

std.res <- bind_rows(std.res_w_outliers, std.res_wo_outliers) %>%
  group_by(outcome, exposure) %>% 
  filter(outliers_removed == ifelse(TRUE %in% outliers_removed, TRUE, FALSE)) %>% 
  ungroup()

## Generate FDR values
qobj <- qvalue(p = std.res$pval, fdr.level = 0.1)
qvales.df <- tibble(pvalues = qobj$pvalues, lfdr = qobj$lfdr, 
                    qval = qobj$qvalues, significant = qobj$significant)

std_best <- std.res %>% 
  bind_cols(select(qvales.df, qval)) %>% 
  group_by(outcome, exposure) %>% 
  arrange(pval) %>% 
  slice(1) %>% 
  ungroup() %>% 
  select(-id.exposure, -id.outcome, -method, -outliers_removed) %>% 
  rename(std.b = b, 
         std.se = se, 
         std.pval = pval, 
         std.qval = qval) 

out.best <- right_join(std_best, mr_best, by = c("outcome", "exposure", "nsnp")) %>% 
  ## Arrange traits
  mutate(outcome.name = fct_relevel(
    outcome.name, 'LOAD', 'AAOS', 'AB42', 'Ptau181', 'Tau', 'Neuritic Plaques', 
    'Neurofibrillary Tangles', 'Vascular Brain Injury', 'Hippocampal Volume')) %>% 
  mutate(exposure.name = fct_relevel(
    exposure.name, 'Alcohol Consumption', 'Alcohol Dependence', 'AUDIT', 
    'Smoking Initiation', 'Cigarettes per Day', 'Diastolic Blood Pressure', 
    'Systolic Blood Pressure', 'Pulse Pressure', "High-density lipoproteins", 
    "Low-density lipoproteins", "Total Cholesterol", "Triglycerides", 
    'Educational Attainment', 'BMI', 'Type 2 Diabetes', "Oily Fish Intake", 
    "Hearing Problems", "Insomnia Symptoms", "Sleep Duration", "Moderate-to-vigorous PA",
    "Depressive Symptoms", 'Major Depressive Disorder', "Social Isolation"))

## -------------------------------------------------------------------------------- ##
##            Plots 

ggplot(out.best, aes(x = IVW_b, y = std.b)) + geom_point()
ggplot(out.best, aes(x = IVW_MR.pval, y = std.pval)) + geom_point() + coord_equal()
ggplot(out.best, aes(x = qval, y = std.qval)) + geom_point() + coord_equal()

out.best %>% filter(qval < 0.05)
out.best %>% filter(std.qval < 0.05)

## Generate Frames for plot to indicate robust associations
frames <- out.best %>% 
  mutate(pass_0.1 = ifelse(qval > 0.1 | qval < 0.05, FALSE,
                           ifelse(MRPRESSO.pval > 0.05 & Egger.pval > 0.05, TRUE,
                                  ifelse(Egger_MR.pval < 0.05 | WME_MR.pval < 0.05 | WMBE_MR.pval < 0.05, TRUE, FALSE)))) %>% 
  split(., 1:nrow(.)) %>% 
  map(., function(x){
    x %>% 
      mutate(pass_0.1 = ifelse(pass_0.1 == FALSE, FALSE, passfunc(IVW_MR.pval, IVW_b, 
                                                                  Egger_MR.pval, Egger_b, 
                                                                  WME_MR.pval, WME_b, 
                                                                  WMBE_MR.pval, WMBE_b)))
  }) %>% bind_rows(.) %>%
  mutate(outcome1 = as.integer(outcome.name)) %>% 
  mutate(exposure1 = as.integer(exposure.name))

## Dataframe for ploting 
dat.plot <- out.best %>%
  mutate(q_signif = as.character(signif.num(qval))) %>%
  mutate(z = IVW_b/IVW_se) %>% 
  mutate(out = ifelse(qval < 0.1, paste0(round(IVW_b, 3), '\n', '(', round_sci(qval), ')'), " ")) %>% 
  select(exposure.name, outcome.name, z, std.b, q_signif, out)

## Plot heatmap with significance symbols 
p1 <- ggplot(dat.plot) + 
  geom_raster(aes(x = exposure.name, y = outcome.name, fill = std.b)) + 
  geom_text(data = dat.plot, size = 4, aes(label = q_signif, x = exposure.name, y = outcome.name)) +
  scale_fill_gradient2(low="steelblue", high="firebrick", mid = "white", na.value = "grey50") + 
  coord_equal() + theme_classic() +
  geom_vline(xintercept=seq(0.5, 23.5, 1),color="white") +
  geom_hline(yintercept=seq(0.5, 11.5, 1),color="white") +
  geom_rect(data=filter(frames, pass_0.1 == TRUE), size=0.5, fill=NA, colour="orange",
            aes(xmin=exposure1 - 0.5, xmax=exposure1 + 0.5, ymin=outcome1 - 0.5, ymax=outcome1 + 0.5)) + 
  geom_rect(data=filter(frames, pass == TRUE), size=0.5, fill=NA, colour="red",
            aes(xmin=exposure1 - 0.5, xmax=exposure1 + 0.5, ymin=outcome1 - 0.5, ymax=outcome1 + 0.5)) + 
  theme(legend.position = 'right', legend.key.height = unit(2, "line"), axis.text.x = element_text(angle = 35, hjust = 0), 
        legend.title = element_blank(), legend.text = element_text(hjust = 1.5), text = element_text(size=10), 
        axis.title.x = element_blank(), axis.title.y = element_blank()) +
  scale_x_discrete(position = "top") 
p1





































