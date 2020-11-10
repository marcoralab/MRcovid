mrresults.methods_presso <- read_csv("results/MR_ADphenome/All/MR_ADphenome_WideMRResults_2020-07-27.csv")
out.final <- read_csv('results/MR_ADphenome/All/MR_ADphenome_PublicationRes_2020-07-27.csv')
out.final_NOapoe <- read_csv('results/MR_ADphenome_wo_apoe/All/MR_ADphenome_wo_apoe_PublicationRes_2020-07-27.csv')

mr_best <-  read_csv('results/MR_ADphenome/All/MR_ADphenome_MRbest_2020-07-27.csv')
mr_best_NOapoe <- read_csv('results/MR_ADphenome_wo_apoe/All/MR_ADphenome_wo_apoe_MRbest_2020-07-27.csv')
mr_best_rev <- read_csv('results/MR_ADbidir/All/MR_ADbidir_MRbest_2020-07-27.csv')

##--------------------- Writen Report  ------------------------##

## Summary of tests
glue('We conducted a total of {n} tests. 
     We observed {q} tests that were significant at an FDR < 0.05.
     Of these {q} significant tests, {p} exposure-outcome pairs showed either no evidence of horizontal pleiotropy, 
     or in the presence of horizontal pleiotropy the additional MR sensitivity analysis was significant.
     ', 
     n = nrow(mrresults.methods_presso), 
     q = nrow(filter(out.final, qval < 0.05)), 
     p = nrow(filter(out.final, qval < 0.05 & pass == TRUE))
     ) 

## Generate Odds ratios
res_odds <- mr_best %>% 
  mutate(MRPRESSO.pval = as.numeric(str_replace(MRPRESSO.pval, '<', ""))) %>% 
  filter(qval < 0.05) %>% 
#  filter(pass == TRUE) %>%
  select(outcome, exposure, pt, outliers_removed, qval, MRPRESSO.pval, Egger.pval, exposure.name, outcome.name, b = IVW_b, se = IVW_se, pval = IVW_MR.pval, Egger_MR.pval, WME_MR.pval, WMBE_MR.pval) %>%
  generate_odds_ratios(.) %>% 
  mutate(out = ifelse(outcome %in% c('Lambert2013load', 'Kunkle2019load', 'Huang2017aaos', 'Beecham2014npany', 'Beecham2014braak4', 'Beecham2014vbiany'), 
                      paste0(round(or, 2), ' [', round(or_lci95, 2), ', ', round(or_uci95, 2), ']'),
                      paste0(round(b, 2), ' [', round(lo_ci, 2), ', ', round(up_ci, 2), ']'))) %>% 
  print(n = Inf) 

res_odds %>% 
  select(outcome, exposure, pt, outliers_removed, b, se, qval, lo_ci, up_ci, or, or_lci95, or_uci95, out) %>% 
  print(n = Inf)

mr_senseitivy <- function(x){
  senesetivy_p <- select(x, Egger_MR.pval, WME_MR.pval, WMBE_MR.pval)
  y <- which(senesetivy_p <= 0.05)
  y <- str_replace(y, "1", 'MR-Egger')
  y <- str_replace(y, "2", 'Weighted median')
  y <- str_replace(y, "3", 'Weighted mode')
  
  sensetivity_out <- if(length(y) == 0){
    paste0(" the associations were non-significant in the sensitivity analyses.")
  } else if(length(y) == 1){
    paste0("the associations were consistent in the ", y,  " sensitivity analysis.")
  } else if(length(y) == 2){
    paste0("the associations were consistent in the ", y[1], ' and ', y[2], " sensitivity analyses.")
  } else if(length(y) == 3){
    paste0("the associations were consistent in the ", y[1], ', ', y[2], ' and ', y[3], " sensitivity analyses.")
  }
  
  with(x, if(MRPRESSO.pval > 0.05 & Egger.pval > 0.05){
    "There was no evidence of heterogeneity or directional pleiotropy."
  } else if(MRPRESSO.pval < 0.05 & Egger.pval < 0.05){
    paste0("There was evidence of heterogeneity and directional pleiotropy, however, ", 
           sensetivity_out)
  } else if(MRPRESSO.pval < 0.05 & Egger.pval > 0.05){
    paste0("There was evidence of heterogeneity, but not of directional pleiotropy, however, ", 
           sensetivity_out)
  } else if(MRPRESSO.pval > 0.05 & Egger.pval < 0.05){
    paste0("There was evidence of directional pleiotropy, but not of heterogeneity, however, ", 
           sensetivity_out)
  })
}


written_res <- lapply(1:nrow(res_odds), function(x){
  exposure_out <- res_odds %>% slice(x)
  if(exposure_out$outcome == 'Lambert2013load' | exposure_out$outcome == 'Kunkle2019load'){
    with(exposure_out, paste0("Genetically predicted ", exposure.name, " was associated with significantly ", 
                              ifelse(or < 1, 'lower odds', 'increased odds'), 
                              " of Alzheimer's disease ", 
                              ifelse(outliers_removed == TRUE, 'after outlier removal ', ""), 
                              '(OR [CI]: ', out, "). ", mr_senseitivy(exposure_out)))
  } else if(exposure_out$outcome == 'Beecham2014npany'){
    with(exposure_out, paste0("Genetically predicted ", exposure.name, " was associated with significantly ", 
                              ifelse(or < 1, 'lower odds', 'increased odds'), 
                              " of Neuritic Plaques ", 
                              ifelse(outliers_removed == TRUE, 'after outlier removal ', ""), 
                              '(OR [CI]: ', out, "). ", mr_senseitivy(exposure_out)))
  } else if(exposure_out$outcome == 'Beecham2014braak4'){
    with(exposure_out, paste0("Genetically predicted ", exposure.name, " was associated with significantly ", 
                              ifelse(or < 1, 'lower odds', 'increased odds'), 
                              " of Neurofibilary Tangles ", 
                              ifelse(outliers_removed == TRUE, 'after outlier removal ', ""), 
                              '(OR [CI]: ', out, "). ", mr_senseitivy(exposure_out)))
  } else if(exposure_out$outcome == 'Beecham2014vbiany'){
    with(exposure_out, paste0("Genetically predicted ", exposure.name, " was associated with significantly ", 
                              ifelse(or < 1, 'lower odds', 'increased odds'), 
                              " of vascurlar brain injury ", 
                              ifelse(outliers_removed == TRUE, 'after outlier removal ', ""), 
                              '(OR [CI]: ', out, "). ", mr_senseitivy(exposure_out)))
  } else if(exposure_out$outcome == 'Huang2017aaos'){
    with(exposure_out, paste0("Genetically predicted ", exposure.name, " was associated with significantly ", 
                              ifelse(or < 1, 'later', 'earlier'), 
                              " Alzheimer's age of onset ", 
                              ifelse(outliers_removed == TRUE, 'after outlier removal ', ""), 
                              '(HR [CI]: ', out, "). ", mr_senseitivy(exposure_out)))
  } else if(exposure_out$outcome == 'Hilbar2017hipv' | exposure_out$outcome == 'Hilbar2015hipv'){
    with(exposure_out, paste0("Genetically predicted ", exposure.name, " was associated with significantly ", 
                              ifelse(b < 0, 'reduced', 'increased'), 
                              " hippocampal volume ", 
                              ifelse(outliers_removed == TRUE, 'after outlier removal ', ""), 
                              '(β [CI]: ', out, "). ", mr_senseitivy(exposure_out)))
  } else if(exposure_out$outcome == 'Grasby2020surfarea'){
    with(exposure_out, paste0("Genetically predicted ", exposure.name, " was associated with significantly ", 
                              ifelse(b < 0, 'reduced', 'increased'), 
                              " cortical surface area ", 
                              ifelse(outliers_removed == TRUE, 'after outlier removal ', ""), 
                              '(β [CI]: ', out, "). ", mr_senseitivy(exposure_out)))
  } else if(exposure_out$outcome == 'Grasby2020thickness'){
    with(exposure_out, paste0("Genetically predicted ", exposure.name, " was associated with significantly ", 
                              ifelse(b < 0, 'reduced', 'increased'), 
                              " cortical thickness ", 
                              ifelse(outliers_removed == TRUE, 'after outlier removal ', ""), 
                              '(β [CI]: ', out, "). ", mr_senseitivy(exposure_out)))
  } else if(exposure_out$outcome == 'Deming2017ab42'){
    with(exposure_out, paste0("Genetically predicted ", exposure.name, " was associated with significantly ", 
                              ifelse(b < 0, 'reduced', 'increased'), 
                              " Aβ42 ", 
                              ifelse(outliers_removed == TRUE, 'after outlier removal ', ""), 
                              '(β [CI]: ', out, "). ", mr_senseitivy(exposure_out)))
  } else if(exposure_out$outcome == 'Deming2017ptau'){
    with(exposure_out, paste0("Genetically predicted ", exposure.name, " was associated with significantly ", 
                              ifelse(b < 0, 'reduced', 'increased'), 
                              " Ptau181 ", 
                              ifelse(outliers_removed == TRUE, 'after outlier removal ', ""), 
                              '(β [CI]: ', out, "). ", mr_senseitivy(exposure_out)))
  } else if(exposure_out$outcome == 'Deming2017tau'){
    with(exposure_out, paste0("Genetically predicted ", exposure.name, " was associated with significantly ", 
                              ifelse(b < 0, 'reduced', 'increased'), 
                              " Deming2017tau ", 
                              ifelse(outliers_removed == TRUE, 'after outlier removal ', ""), 
                              '(β [CI]: ', out, "). ", mr_senseitivy(exposure_out)))
  }
  
}) %>% unlist()

res_odds$written <- written_res

##--------------------- Writen Report  ------------------------##

## Table 4
out.final %>% 
  filter(qval < 0.05) %>% 
  select(-outcome, -exposure, -n_outliers, -snp_r2.exposure, -snp_r2.outcome, 
         -correct_causal_direction, -steiger_pval) %>% 
  mutate(outcome.name = fct_relevel(outcome.name, "LOAD", "AAOS", "Neuritic Plaques", "Neurofibrillary Tangles", "Vascular Brain Injury", "Hippocampal Volume", "Cortical Surface Area", "Cortical Thickness")) %>% 
  arrange(outcome.name) %>% 
  print(n = Inf) %>%
  write_csv("sandbox/table4.csv")

# Join results from w/ APOE, wo/ APOE, reverse direction 
mr_best_joint <- full_join(
  mr_best %>% 
    mutate(out = glue("{b} ({se}){p}", 
                      b = IVW_b, se = IVW_se, p = gtools::stars.pval(qval)), 
           pt = as.character(pt)) %>% 
    select(exposure, outcome, pt, qval,  dir = correct_causal_direction, pass, out), 
  
  mr_best_NOapoe %>% 
    mutate(out = glue("{b} ({se}){p}", 
                      b = IVW_b, se = IVW_se, p = gtools::stars.pval(qval)), 
           pt = as.character(pt)) %>% 
    select(exposure, outcome, pt, qval, dir = correct_causal_direction, pass, out),
  
  by = c("exposure", "outcome"), 
  suffix = c(".w_apoe", ".wo_apoe")
  
) %>% 
  left_join(., 
            mr_best_rev %>%
              mutate(out = glue("{b} ({se}){p}", 
                                b = IVW_b, se = IVW_se, p = gtools::stars.pval(qval)), 
                     pt = as.character(pt)) %>% 
              select(exposure, outcome, pt, qval,  dir = correct_causal_direction, pass, out), 
            
            mr_best_rev, by = c("exposure" = "outcome", "outcome" = "exposure")
            
  ) %>% 
  rename(pt.rev = pt, dir.rev = dir, qval.rev = qval, pass.rev = pass, out.rev = out) %>%
  left_join(select(res_odds, outcome, exposure, written))

## Print results 
### w/ APOE results 
mr_best_joint %>%
  # filter(qval.wo_apoe < 0.1 | qval.w_apoe < 0.1) %>% 
  filter(qval.wo_apoe < 0.05 | qval.w_apoe < 0.05) %>% 
  arrange(qval.w_apoe) %>%
  select(-qval.wo_apoe, -qval.w_apoe, -qval.rev) %>%
  select(-dir.w_apoe, -dir.wo_apoe, -dir.rev) %>%
  print(n = Inf)

mr_best_joint %>%
  # filter(qval.wo_apoe < 0.1 | qval.w_apoe < 0.1) %>% 
  filter(qval.w_apoe < 0.05 & pass.w_apoe == TRUE) %>%
  pull(written)

### Dont pass sensitivy analysis
mr_best_joint %>%
  # filter(qval.wo_apoe < 0.1 | qval.w_apoe < 0.1) %>% 
  filter(qval.w_apoe < 0.05 & pass.w_apoe == FALSE) %>% 
  arrange(qval.w_apoe) %>%
  select(-qval.wo_apoe, -qval.w_apoe, -qval.rev) %>%
  select(-dir.w_apoe, -dir.wo_apoe, -dir.rev) %>%
  print(n = Inf)

mr_best_joint %>%
  # filter(qval.wo_apoe < 0.1 | qval.w_apoe < 0.1) %>% 
  filter(qval.w_apoe < 0.05 & pass.w_apoe == FALSE) %>%
  pull(written)

### causal estimates that become non-significant after exclusion of APOE 
mr_best_joint %>%
  filter(qval.wo_apoe > 0.05 & qval.w_apoe < 0.05) %>% 
  #filter(qval.wo_apoe < 0.05 & qval.w_apoe < 0.05 & pass.w_apoe == TRUE) %>% 
  arrange(qval.w_apoe) %>%
  select(-qval.wo_apoe, -qval.w_apoe, -qval.rev) %>%
  select(-dir.w_apoe, -dir.wo_apoe, -dir.rev) %>%
  print(n = Inf)

mr_best_joint %>%
  filter(qval.wo_apoe > 0.05 & qval.w_apoe < 0.05) %>%
  select(exposure, outcome)
  
### Bi-directional MR results
mr_best_joint %>%
  filter(qval.rev < 0.05 & qval.w_apoe < 0.05) %>% 
  #filter(qval.wo_apoe < 0.05 & qval.w_apoe < 0.05 & pass.w_apoe == TRUE) %>% 
  arrange(qval.w_apoe) %>%
  select(-qval.wo_apoe, -qval.w_apoe, -qval.rev) %>%
  select(-dir.w_apoe, -dir.wo_apoe, -dir.rev) %>%
  print(n = Inf)

mr_best_joint %>%
  filter(qval.rev < 0.05 & qval.w_apoe < 0.05) %>% 
  #filter(qval.wo_apoe < 0.05 & qval.w_apoe < 0.05 & pass.w_apoe == TRUE) %>% 
  select(exposure, outcome, out.rev, pass.rev)










































