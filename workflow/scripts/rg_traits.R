library(nanny)
library(dplyr)
library(tidyr)
library(readr)
library(stringi)
library(stringr)
library(here)
source(here("workflow", "scripts", "miscfunctions.R"), chdir = TRUE)


exposures = c('Yengo2018bmi', 'Mahajan2018t2d', 'Willer2013hdl', 'Willer2013ldl',
              'Willer2013tc', 'Willer2013tg', 'Dashti2019slepdur', 'Klimentidis2018mvpa',
              'Day2018sociso', 'Evangelou2018dbp', 'Evangelou2018sbp', 'Evangelou2018pp',
              'Lee2018educ', 'Howard2018dep', 'Jansen2018insom', 'Liu2019smkint',
              'Liu2019smkcpd', 'Liu2019drnkwk', 'Kunkle2019load', 'Revez2020vit250hd',
              'Okada2014rartis', 'Nalls2019pd', 'Nicolas2018als', 'Ligthart2018crp',
              'Wood2014height', 'Betham2015lupus', 'Patsopoulos2019multscler',
              'Malik2018ais', 'Wuttke2019egfr', 'Wuttke2019ckd', 'Nikpay2015cad',
              'Shah2020heartfailure', 'Olafsdottir2020asthma', 'Allen2020ipf',
              'Linner2019risk', 'Demontis2018adhd', 'Grove2019asd', 'Ripke2014scz',
              'Stahl2019bip', 'Astel2016rbc', 'Astel2016wbc', 'Astel2016plt', "Mills2021afb",
              "covidhgi2020A2v5alleur", "covidhgi2020B2v5alleur", "covidhgi2020C2v5alleur",
              "covidhgi2020A2v5alleurLeaveUKBB", "covidhgi2020B2v5alleurLeaveUKBB", "covidhgi2020C2v5alleurLeaveUKBB")

outcomes = c("covidhgi2020A2v5alleur", "covidhgi2020B2v5alleur", "covidhgi2020C2v5alleur",
             "covidhgi2020A2v5alleurLeaveUKBB", "covidhgi2020B2v5alleurLeaveUKBB", "covidhgi2020C2v5alleurLeaveUKBB")

## generate grid of exposure outcome pairs
df <- expand_grid(g1 = exposures,
                  g2 = outcomes) %>%
  filter(g1 != g2) %>%
  left_join(select(samplesize, code, trait, samplesize), by = c("g1" = "code")) %>%
  left_join(select(samplesize, code, trait, samplesize), by = c("g2" = "code"), suffix = c("_1", "_2")) %>%
  relocate(g1, trait_1, samplesize_1, g2, trait_2, samplesize_2) %>%
  mutate(covid_g1 = str_detect(g1, "covid"),
         LeaveUKBB = str_detect(g1, "LeaveUKBB"))

## Seperate out covid exposure - outcome pairs
df.ls <- df %>% group_by(covid_g1) %>% group_split()
covid.ls <-  df.ls[[2]] %>% group_by(LeaveUKBB) %>% group_split()

## take lower triangle of covid phenotype pairs
out <- bind_rows(
   df.ls[[1]],
   covid.ls[[1]] %>% filter(!str_detect(g2, "LeaveUKBB")) %>% lower_triangular(g1, g2, samplesize_1),
   covid.ls[[2]] %>% filter(str_detect(g2, "LeaveUKBB")) %>% lower_triangular(g1, g2, samplesize_1)
 ) %>%
   select(-covid_g1, -LeaveUKBB)

write_csv(out, "data/RGcovid/traits.csv")
