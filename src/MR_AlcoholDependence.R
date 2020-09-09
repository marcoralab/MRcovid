exposures <- c('alcc', 'bmi', 'cpd', 'dep', 'diab', 'educ', 'hdl', 'insom', 'ldl', 'mdd', 'mvpa', 'evrsmk', 'sociso', 'tc', 'trig', 'dbp', 'sbp', 'pp', 'hear')

## LOAD, CSF and Neuropath
outcomes <- c('alcd')

pt <- c('5e-6', '5e-8')

method <- c('IVW', 'Weighted median', 'Weighted mode', 'MR Egger')

mr_best <- MRsummary %>% 
  filter(outcome %in% outcomes) %>% 
  filter(exposure %in% exposures) %>%
  filter(method == 'IVW') %>% 
  group_by(outcome, exposure, pt) %>% 
  filter(MR_PRESSO == ifelse(TRUE %in% MR_PRESSO, TRUE, FALSE)) %>% 
  ungroup()

mr_all <- MRsummary %>% 
  filter(outcome %in% outcomes) %>% 
  filter(exposure %in% exposures) %>%
  group_by(outcome, exposure, pt) %>% 
  filter(MR_PRESSO == ifelse(TRUE %in% MR_PRESSO, TRUE, FALSE)) %>% 
  ungroup() %>%
  generate_odds_ratios(.) %>% 
  mutate(or = round(or, 2)) %>% 
  mutate(or_lci95 = round(or_lci95, 2)) %>% 
  mutate(or_uci95 = round(or_uci95, 2)) %>% 
  mutate(effect = paste0(or, ' (', or_lci95, ', ', or_uci95, ')')) %>% 
  select(outcome, exposure, pt, method, effect, pval) %>%
  myspread(method, c(effect, pval)) %>% 
  mutate_at(vars(matches("pval")), as.numeric) %>%
  group_by(outcome, exposure) %>% 
  arrange(IVW_pval) %>% 
  slice(1) %>% 
  ungroup() %>% 
  arrange(IVW_pval) %>%
  mutate(IVW_pval = ifelse(IVW_pval > 0.0001, round(IVW_pval, 4), format(IVW_pval, digits = 2, scientific = TRUE))) %>%
  mutate(`MR Egger_pval` = ifelse(`MR Egger_pval` > 0.0001, round(`MR Egger_pval`, 4), format(`MR Egger_pval`, digits = 2, scientific = TRUE))) %>%
  mutate(`Weighted median_pval` = ifelse(`Weighted median_pval` > 0.0001, round(`Weighted median_pval`, 4), format(`Weighted median_pval`, digits = 2, scientific = TRUE))) %>%
  mutate(`Weighted mode_pval` = ifelse(`Weighted mode_pval` > 0.0001, round(`Weighted mode_pval`, 4), format(`Weighted mode_pval`, digits = 2, scientific = TRUE))) 

  
### Check
tot <- expand.grid(outcomes, exposures, pt, method) %>% 
  as.tibble() %>% 
  rename(outcome = Var1, exposure = Var2, pt = Var3, method = Var4) %>% 
  filter(method == 'IVW') %>% 
  filter(!(exposure == 'sleep' & pt == '5e-8'))

anti_join(tot, mr_best)


qobj <- qvalue_truncp(p = mr_best$pval, fdr.level = 0.05)

res_comb <- mr_best %>% 
  bind_cols(select(qvales.df, qval, significant)) %>% 
  group_by(outcome, exposure) %>% 
  arrange(pval) %>% 
  slice(1) %>% 
  ungroup() %>%
  select(outcome, exposure, pt, MR_PRESSO, nsnp, n_outliers, b, se, pval, qval, significant, violated.MRPRESSO, violated.Egger, violated.Q.Egger, violated.Q.IVW)


res_comb %>% arrange(qval) %>% 

mr_all %>% 
  left_join(select(res_comb, outcome, exposure, MR_PRESSO, nsnp, n_outliers, significant, violated.MRPRESSO, violated.Egger, violated.Q.Egger, violated.Q.IVW)) %>% write_csv(., '~/Documents/alcd_all_model.csv')

res.plot <- res_comb %>% 
  mutate(b = round(b, 2)) %>% 
  mutate(se = round(se, 2)) %>% 
  mutate(sig = ifelse(pval > 0.0001, round(pval, 4), format(pval, digits = 2, scientific = TRUE))) %>%
  mutate(sig = ifelse(qval < 0.05, paste0(sig, ' †'), sig)) %>% 
  left_join(select(traits, code, name), by = c('exposure' = 'code')) %>% 
  mutate(name = ifelse(MR_PRESSO == FALSE, name, paste0(name, '*')))

res.alcd <- res.plot %>% 
  arrange(-b) %>%
  as.data.frame()

forest_plot_1_to_many(res.alcd,b="b",se="se",
                      exponentiate=T,ao_slc=F, by = NULL,
                      TraitM="name", col1_title="Risk factor", col1_width = 1.75,
                      trans="log2", 
                      xlab="OR for LOAD per unit increase in risk factor (95% confidence interval)", 
                      addcols=c('pt', "nsnp", 'sig'), 
                      addcol_widths=c(0.5,0.75,0.75), addcol_titles=c("Pt", "No. SNPs","P-value"))
ggsave('~/Dropbox/Research/PostDoc-MSSM/2_MR/4_Output/plots/MR/forest_alcd.png', width = 8.5, height = 6, units = 'in')

