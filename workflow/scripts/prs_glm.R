## ========================================================================== ##
## PRS: Run logistic regression models to estimate effect of PRS on AD
## ========================================================================== ##

# Load packages and functions
library(tidyverse)
library(broom)
zscore = function(x){(x - mean(x)) / sd(x)}

# setwd('/Users/sheaandrews/LOAD_minerva/dummy/shea/Projects/AD_PRS')

## File Paths
prs.file.path <- snakemake@input[["prs"]]
sum.file.path <- snakemake@input[["summary"]]
cohort.pheno.path <- snakemake@input[["pheno_file"]]

## params
exposure = snakemake@params[["pheno"]]
r2 <- snakemake@params[["r2"]]
window <- snakemake@params[["window"]]

# Read in summary file and extract best Pt
message('READ IN SUMMARY FILE \n')
best.prs <- read_tsv(sum.file.path) %>%
  pull(Threshold) %>%
  as.character()

# Read in Pheno file
message('READ IN PHENOTYPES \n')
pheno <- read_tsv(cohort.pheno.path, col_names = T)

# Read in all PRS file
message('READ IN PRS \n')
prs <- read_csv(prs.file.path) %>%
#  rename_at(vars(-FID, -IID), function(x) paste0('prs.pt_', x))  %>%
  mutate_at(vars(matches("prs.pt_")), zscore) %>%
  select(-prs.pc2)

# extract Pt used
pt <- select(prs, starts_with("prs")) %>% colnames(.)

## Join PRS and Phenotype data
message('Join PRS and Phenotype data \n')
dat <- left_join(prs, pheno) %>%
  select(FID:cohort, sex, status, aaoaae2, apoe4dose, jointPC1:jointPC10) %>%
  mutate(status = as.factor(status),
         sex = as.factor(sex),
         cohort = fct_infreq(cohort))

## Peform logistic regression for each Pvalue threshold
message('RUNNING REGRESSIONS \n')
res <- map(pt, function(x){
  select(dat, status, x, aaoaae2, sex, apoe4dose, cohort, jointPC1:jointPC10) %>%
    glm(status ~ ., family = 'binomial', data = .) %>%
    tidy(.) %>%
    mutate(pt = x,
           pt = case_when(
            str_detect(pt, 'prs.pt_') ~ str_replace(pt, 'prs.pt_', "") %>% as.numeric() %>% as.character(),
            str_detect(pt, 'prs.pc') ~ str_replace(pt, 'prs.', ""),
            TRUE ~ "NA"
            ),
           exposure = exposure)
}) %>%
  bind_rows() %>%
#  mutate(pt = as.numeric(pt)) %>%
  mutate(model = case_when(
          pt == '5e-08' & pt == best.prs ~ 'GWS_best',
          pt == '5e-08' ~ "GWS",
          pt == best.prs ~ 'best',
          pt == "pc1" ~ 'PCA',
          TRUE ~ "other"
        ),
         r2 = r2,
         window = window) %>%
  select(exposure, pt, model, everything())

message('EXPORT \n')
write_tsv(res, snakemake@output[["out"]])
# res %>%
#   filter(estimate, str_detect(term, 'prs.pt'))
