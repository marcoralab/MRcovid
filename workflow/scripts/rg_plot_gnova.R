library(tidyverse)
library(here)
library(gtools)
source(here("workflow", "scripts", "miscfunctions.R"), chdir = TRUE)
# setwd("/sc/arion/projects/LOAD/shea/Projects/MRcovid")
# rg.path = 'results/RGcovid/gnvoa/all_results_gnova_2021-01-12.tsv'
# DATE = Sys.Date()
# out.path = 'results/RGcovid/gnvoa/gnova_'

rg.path = snakemake@input[["rg"]]
DATE = snakemake@params[["date"]]
out.path = snakemake@params[["out"]]

## Munge datasets
exposures_outcomes <- expand_grid(exposures, outcomes) %>%
  magrittr::set_colnames(c("exposures.name", "outcomes.name")) %>%
  left_join(select(samplesize, code, trait, domain), by = c('exposures.name' = 'code')) %>%
  rename(exposure.name = trait, domain.exposure = domain) %>%
  left_join(select(samplesize, code, trait, domain), by = c('outcomes.name' = 'code')) %>%
  rename(outcome.name = trait, domain.outcome = domain) %>% 
  mutate(UKB = !str_detect(outcome.name, "UKB"))

rg <- read_tsv(rg.path) %>% 
  rename(p1 = trait1, p2 = trait2) %>% 
  filter(p1 %in% exposures) %>% 
  filter(p2 %in% outcomes) %>% 
  left_join(select(exposures_outcomes, exposures.name, outcomes.name, exposure.name, outcome.name, UKB), 
            by = c("p1" = "exposures.name", "p2" = "outcomes.name")) %>%
  group_by(UKB) %>%
  mutate(fdr = p.adjust(pvalue_corrected, "fdr")) %>% 
  ungroup() %>% 
  mutate(signif = case_when(pvalue_corrected > 0.05 ~ "NS", 
                            pvalue_corrected < 0.05 & fdr > 0.05 ~ "Nominal", 
                            fdr < 0.05 ~ "Significant"), 
         signif = replace_na(signif, "NS"), 
         signif = fct_relevel(signif, "NS", "Nominal", "Significant"), 
         stars = stars.pval(fdr)) %>%
  arrange(UKB, p2, fdr) 

heatmap_rg <- function(dat){
  ggplot(dat) +
    geom_raster(aes(x = exposure.name, y = outcome.name, fill = corr_corrected)) +
    geom_text(data = dat, size = 4, aes(label = stars, x = exposure.name, y = outcome.name)) +
    scale_fill_gradient2(low="steelblue", high="firebrick", mid = "white", na.value = "grey75", name = "rg", limits = c(-1,1)) +
    geom_vline(xintercept=seq(0.5, 23.5, 1),color="white") +
    geom_hline(yintercept=seq(0.5, 11.5, 1),color="white") +
    coord_equal() +
    theme_classic() +
    theme(legend.position = 'right', legend.key.height = unit(1, "line"),
          axis.text.x = element_text(angle = 35, hjust = 0),
          legend.text = element_text(hjust = 1.5), text = element_text(size=10),
          axis.title.x = element_blank(), axis.title.y = element_blank()) +
    scale_x_discrete(position = "top")
}

## Print Heatmaps 
rg_heatmap_eur.p <- rg %>% 
  filter(UKB == TRUE) %>%
  arrange(p2, exposure.name) %>% 
  mutate(exposure.name = fct_inorder(exposure.name), 
         outcome.name = fct_rev(outcome.name)) %>% 
  heatmap_rg()
ggsave(glue(out.path, "heatmap_eur_{DATE}.png"), rg_heatmap_eur.p, width = 11, height = 4, units = "in")

rg_heatmap_eurLeaveUKB.p <- rg %>% 
  filter(UKB == FALSE) %>%
  arrange(p2, exposure.name) %>% 
  mutate(exposure.name = fct_inorder(exposure.name), 
         outcome.name = fct_rev(outcome.name)) %>% 
  heatmap_rg()
ggsave(glue(out.path, "heatmap_eurLeaveUKB_{DATE}.png"), rg_heatmap_eurLeaveUKB.p, width = 11, height = 4, units = "in")
