library(tidyverse)
library(here)
library(gtools)
source(here("workflow", "scripts", "miscfunctions.R"), chdir = TRUE)
# setwd("/sc/arion/projects/LOAD/shea/Projects/MRcovid")
# rg.path = 'results/RGcovid/ldsc/all_results_ldsc_2021-01-12.tsv'

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
  mutate(p1 = str_replace(p1, "\\.sumstats.gz", ""), 
         p1 = str_replace(p1, "data/formated/ldsc/", ""), 
         p2 = str_replace(p2, "data/formated/ldsc/", ""), 
         p2 = str_replace(p2, ".sumstats.gz", "")) %>%
  filter(p1 %in% exposures) %>% 
  filter(p2 %in% outcomes) %>% 
  left_join(select(exposures_outcomes, exposures.name, outcomes.name, exposure.name, outcome.name, UKB), 
            by = c("p1" = "exposures.name", "p2" = "outcomes.name")) %>%
  group_by(UKB) %>%
  mutate(fdr = p.adjust(p, "fdr")) %>% 
  ungroup() %>% 
  mutate(lci = rg - (1.96 * se), 
         uci = rg + (1.96 * se), 
         signif = case_when(p > 0.05 ~ "NS", 
                               p < 0.05 & fdr > 0.05 ~ "Nominal", 
                               fdr < 0.05 ~ "Significant"), 
         signif = replace_na(signif, "NS"), 
         signif = fct_relevel(signif, "NS", "Nominal", "Significant"), 
         stars = stars.pval(fdr)) %>%
  arrange(UKB, p2, fdr) 

## Functions of heatmap and forest plots  
forrest_rg <- function(dat){
  ggplot(dat, aes(y = exposure.name, x = rg, colour = signif)) + 
    geom_vline(xintercept = 0, linetype = 2) + 
    facet_grid(. ~ outcome.name, scales = "free_x") + 
    geom_point() + 
    geom_linerange(aes(xmin = lci, xmax = uci)) + 
    scale_color_manual(values = c("grey75", "black", "red")) + 
    theme_bw() + 
    labs(title = "Genetic correlation", x = "rg (95%CI)") + 
    theme(legend.position = "bottom",
          legend.title = element_blank(),
          axis.title.y=element_blank(), 
          strip.background = element_blank(),
          strip.text.y = element_blank(), 
          panel.grid.minor.x  = element_blank())
  
} 

heatmap_rg <- function(dat){
  ggplot(dat) +
    geom_raster(aes(x = exposure.name, y = outcome.name, fill = rg)) +
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

## Print Forrest Plots
rg_forrest_eur.p <- rg %>% 
  filter(UKB == TRUE) %>%
  arrange(p2, rg) %>% 
  mutate(exposure.name = fct_inorder(exposure.name)) %>% 
  forrest_rg(.)
ggsave(glue(out.path, "forrest_eur_{DATE}.png"), rg_forrest_eur.p ,width = 9, height = 6, units = "in")

rg_forrest_eurLeaveUKB.p <- rg %>% 
  filter(UKB == FALSE) %>%
  arrange(p2, rg) %>% 
  mutate(exposure.name = fct_inorder(exposure.name)) %>% 
  forrest_rg(.)
ggsave(glue(out.path, "forrest_eurLeaveUKB_{DATE}.png"), rg_forrest_eurLeaveUKB.p ,width = 9, height = 6, units = "in")

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
