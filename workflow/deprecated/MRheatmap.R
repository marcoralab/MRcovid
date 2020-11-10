## -------------------------------------------------------------------------------- ##
##                            Plot heatmap of MR results                            ##

## Load Packages & Function 
library(tidyverse)
library(glue)
source('scripts/miscfunctions.R', chdir = TRUE)

## Read in dataset
mr_best <-  mr_best %>% # read_csv('results/MR_ADphenome/All/MRbest.csv') %>% 
  ## Arrange traits
  mutate(outcome.name = fct_relevel(
    outcome.name, 'LOAD', 'AAOS', 'AB42', 'Ptau181', 'Tau', 'Neuritic Plaques', 
    'Neurofibrillary Tangles', 'Vascular Brain Injury', 'Hippocampal Volume')) %>% 
  mutate(exposure.name = fct_relevel(
    exposure.name, 'Alcohol Consumption', "Alcohol Consumption (23andMe)", 'AUDIT', "AUDIT (23andMe)",
    'Smoking Initiation', "Smoking Initiation (23andMe)", 'Cigarettes per Day', "Cigarettes per Day (23andMe)", 'Diastolic Blood Pressure', 
    'Systolic Blood Pressure', 'Pulse Pressure', "High-density lipoproteins", 
    "Low-density lipoproteins", "Total Cholesterol", "Triglycerides", 
    'Educational Attainment', "Educational Attainment (23andMe)", 'BMI', 'Type 2 Diabetes', 
    "Oily Fish Intake", 'Meat diet', 'Fish and Plant diet',
    "Hearing Difficulties", "Insomnia Symptoms", "Insomnia Symptoms (23andMe)", 
    "Sleep Duration", "Moderate-to-vigorous PA",
    "Depression", 'Major Depressive Disorder', "Depression (23andMe)", "Social Isolation")) %>% 
  left_join(domains, by = c("exposure" = "code")) %>% 
  left_join(domains, by = c("outcome" = "code")) %>% 
  rename(domain.exposure = domain.x, domain.outcome = domain.y) %>% 
  mutate(domain.exposure = fct_relevel(domain.exposure, "Psychosocial", "Health", "Lifestyle"),
         domain.outcome = fct_relevel(domain.outcome, "Diagnosis", "CSF", "Neuropathology", "Neuroimaging"))


## Generate Frames for plot to indicate robust associations
frames <- mr_best %>% 
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
dat.plot <- frames %>%
  mutate(q_signif = as.character(signif.num(qval))) %>%
  mutate(z = IVW_b/IVW_se) %>% 
  mutate(out = ifelse(qval < 0.1, paste0(round(IVW_b, 3), '\n', '(', round_sci(qval), ')'), " ")) %>% 
  select(exposure.name, outcome.name, domain.exposure, domain.outcome, z, q_signif, out, pass, pass_0.1) %>% 
  arrange(domain.exposure, desc(domain.outcome), outcome.name, exposure.name) %>%
  mutate(outcome.name = fct_inorder(outcome.name)) %>% 
  mutate(exposure.name = fct_inorder(exposure.name)) %>% 
  group_by(domain.exposure, domain.outcome) %>%
  mutate(outcome1 = as.integer(fct_inorder(fct_drop(outcome.name)))) %>% 
  mutate(exposure1 = as.integer(fct_inorder(fct_drop(exposure.name)))) %>% 
  ungroup()

## Plot heatmap with significance symbols 
p1 <- ggplot(dat.plot) + 
  geom_raster(aes(x = exposure.name, y = outcome.name, fill = z)) + 
  facet_grid(domain.outcome ~ domain.exposure, scales = "free", space = "free", switch = "y") + 
  geom_text(data = dat.plot, size = 4, aes(label = q_signif, x = exposure.name, y = outcome.name)) +
  scale_fill_gradient2(low="steelblue", high="firebrick", mid = "white", na.value = "grey50") + 
  # coord_equal() + 
  theme_classic() +
  geom_vline(xintercept=seq(0.5, 23.5, 1),color="white") +
  geom_hline(yintercept=seq(0.5, 11.5, 1),color="white") +
  geom_rect(data=filter(dat.plot, pass_0.1 == TRUE), size=0.5, fill=NA, colour="orange",
            aes(xmin=exposure1 - 0.5, xmax=exposure1 + 0.5, ymin=outcome1 - 0.5, ymax=outcome1 + 0.5)) + 
  geom_rect(data = filter(dat.plot, pass == TRUE), size=0.5, fill=NA, colour="red",
            aes(xmin=exposure1 - 0.5, xmax=exposure1 + 0.5, 
                ymin=outcome1 - 0.5, ymax=outcome1 + 0.5)) +
  theme(legend.position = 'right', legend.key.height = unit(2, "line"), axis.text.x = element_text(angle = 35, hjust = 0), 
        legend.title = element_blank(), legend.text = element_text(hjust = 1.5), text = element_text(size=10), 
        axis.title.x = element_blank(), axis.title.y = element_blank()) +
  scale_x_discrete(position = "top") 
p1

ggsave('results/MR_ADphenome/All/MR_heatmap.pdf', plot = p1, width = 190, height =  120, units = 'mm')
ggsave(glue('results/MR_ADphenome/All/MR_heatmap_{date}.tiff', date = Sys.Date()), 
       plot = p1, width = 220, height =  120, units = 'mm', dpi = 300)
ggsave('results/MR_ADphenome/All/MR_heatmap.png', plot = p1, width = 190, height =  120, units = 'mm')

## Plot heatmap with causal estimate and qvalue
p2 <- ggplot(dat.plot) + 
  geom_raster(aes(x = exposure.name, y = outcome.name, fill = z)) + 
  geom_text(data = dat.plot, size = 1, aes(label = out, x = exposure.name, y = outcome.name)) +
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
p2 

ggsave('results/MR_ADphenome/All/MR_heatmaplabels.png', plot = p2, width = 190, height =  120, units = 'mm')

## Poster
poster <- ggplot(dat.plot) + 
  geom_raster(aes(x = exposure.name, y = outcome.name, fill = z)) + 
  geom_text(data = dat.plot, size = 5, aes(label = out, x = exposure.name, y = outcome.name)) +
  scale_fill_gradient2(low="steelblue", high="firebrick", mid = "white", na.value = "grey50") + 
  coord_equal() + theme_classic() +
  geom_vline(xintercept=seq(0.5, 23.5, 1),color="white") +
  geom_hline(yintercept=seq(0.5, 11.5, 1),color="white") +
  geom_rect(data=filter(frames, pass_0.1 == TRUE), size=0.5, fill=NA, colour="orange",
            aes(xmin=exposure1 - 0.5, xmax=exposure1 + 0.5, ymin=outcome1 - 0.5, ymax=outcome1 + 0.5)) + 
  geom_rect(data=filter(frames, pass == TRUE), size=0.5, fill=NA, colour="red",
            aes(xmin=exposure1 - 0.5, xmax=exposure1 + 0.5, ymin=outcome1 - 0.5, ymax=outcome1 + 0.5)) + 
  theme(legend.position = 'right', legend.key.height = unit(11, "line"), axis.text.x = element_text(angle = 45, hjust = 0), 
        legend.title = element_blank(), legend.text = element_text(hjust = 1.5), text = element_text(size=24), 
        axis.title.x = element_blank(), axis.title.y = element_blank()) +
  scale_x_discrete(position = "top") 
poster 
ggsave('docs/MR_heatmap_poster.pdf', plot = poster, width = 32, height =  14, units = 'in')




