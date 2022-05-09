setwd('/sc/arion/projects/LOAD/harern01/projects/MRcovid/')
library(tidyverse)
library(glue)
library(TwoSampleMR)
library(remotes)
library (MVMR)
library(RadialMR)
`%nin%` = Negate(`%in%`)
p.threshold <- 5e-8
std_beta = function(z, eaf, n){
  std.b = z/sqrt(2 * eaf * (1 - eaf) * (n + z^2))
  std.b
}

std_se = function(z, eaf, n){
  std.se = 1/sqrt(2 * eaf * (1 - eaf) * (n + z^2))
  std.se
}

bmi_ss.path = glue("data/formated/Yengo2018bmi/Yengo2018bmi_formated.txt.gz")
bmi_ss_clump.path = glue("data/formated/Yengo2018bmi/Yengo2018bmi.clumped")
diabetes_ss.path = glue("data/formated/Mahajan2018t2d/Mahajan2018t2d_formated.txt.gz")
covidA2_ss.path = glue("data/formated/covidhgi2020A2v6alleur/covidhgi2020A2v6alleur_formated.txt.gz")
covidB2_ss.path = glue("data/formated/covidhgi2020B2v6alleur/covidhgi2020B2v6alleur_formated.txt.gz")
covidC2_ss.path = glue("data/formated/covidhgi2020C2v6alleur/covidhgi2020C2v6alleur_formated.txt.gz")


# ========================================================================================== ## 
##                                      BMI

##  Read in BMI Exposure Files
## Filter clumped SNPs from BMI GWAS
message(glue("\n Loading: ", bmi_ss.path))
bmi_ss <- read_tsv(bmi_ss.path)
bmi <- bmi_ss %>% 
  filter(P < p.threshold )%>% 
  mutate(sb = std_beta(Z, AF, N)) %>% 
  mutate(sse = std_se(Z, AF, N)) %>% 
 format_data(., type = 'exposure',
                  snp_col = 'SNP',
                  beta_col = "sb",
                  se_col = "sse",
                  eaf_col = "AF",
                  effect_allele_col = "ALT",
                  other_allele_col = "REF",
                  pval_col = "P",
                  z_col = "Z",
                  samplesize_col = "N",
                  phenotype_col = 'TRAIT', 
                  chr_col = 'CHROM', 
                  pos_col = 'POS')  %>% 
group_split(chr.exposure, keep = TRUE) %>% 
  map(., clump_data) %>% 
  bind_rows() %>% 
  as_tibble() 

##==========Diabetes==========##
## BMI ->  Diabetes
message(glue("\n Loading: ", diabetes_ss.path))
diabetes_ss <- read_tsv(diabetes_ss.path) 
  bmi_diabetes <- diabetes_ss %>% 
  filter(SNP %in% bmi$SNP) %>% 
  format_data(., type = 'outcome',
              snp_col = 'SNP',
              beta_col = "BETA",
              se_col = "SE",
              eaf_col = "AF",
              effect_allele_col = "ALT",
              other_allele_col = "REF",
              pval_col = "P",
              z_col = "Z",
              samplesize_col = "N",
              phenotype_col = 'TRAIT', 
              chr_col = 'CHROM', 
              pos_col = 'POS')
  
bmi_diabetes.dat <- harmonise_data(bmi, bmi_diabetes)
## Radial MR
bmi_diabetes.radial <- (
  bmi_diabetes.dat %>% 
    filter(pval.outcome > 5e-8) %>% 
    filter(mr_keep == TRUE) %>% 
    dat_to_RadialMR(.)
)[[1]] 

bmi_diabetes.radial.res <- ivw_radial(bmi_diabetes.radial, weights = 3, alpha = 0.05/nrow(bmi_diabetes.radial))
plot_radial(bmi_diabetes.radial.res)


## MR
bmi_diabetes.mrdat <- bmi_diabetes.dat %>% 
  left_join(bmi_diabetes.radial.res$data, by = 'SNP') 

bmi_diabetes.res <- bmi_diabetes.mrdat %>% 
  filter(mr_keep == TRUE, Outliers == 'Variant') %>% 
  mr(., method_list = c("mr_ivw_fe", "mr_weighted_median", "mr_weighted_mode", "mr_egger_regression"))
bmi_diabetes.res <- generate_odds_ratios(bmi_diabetes.res)
write_csv(bmi_diabetes.res, file = "mr_bmi_diabetes.res.csv")

##==========CovidA2 (Critical illness)==========## 

## BMI -> CovidA2 (Critical illness) 
message(glue("\n Loading: ", covidA2_ss.path))
covidA2_ss <- read_tsv(covidA2_ss.path)  
  bmi_covidA2 <- covidA2_ss %>% 
  filter(SNP %in% bmi$SNP) %>% 
  format_data(., type = 'outcome',
              snp_col = 'SNP',
              beta_col = "BETA",
              se_col = "SE",
              eaf_col = "AF",
              effect_allele_col = "ALT",
              other_allele_col = "REF",
              pval_col = "P",
              z_col = "Z",
              samplesize_col = "N",
              phenotype_col = 'TRAIT', 
              chr_col = 'CHROM', 
              pos_col = 'POS' 
  ) %>% 
  as_tibble()

bmi_covidA2.dat <- harmonise_data(bmi,   bmi_covidA2) 

## Radial MR
bmi_covidA2.radial <- (
  bmi_covidA2.dat %>% 
    filter(pval.outcome > 5e-8) %>% 
    filter(mr_keep == TRUE) %>% 
    dat_to_RadialMR(.)
)[[1]] 

bmi_covidA2.radial.res <- ivw_radial(bmi_covidA2.radial, weights = 3, alpha = 0.05/nrow(bmi_covidA2.radial))
## MR
bmi_covidA2.mrdat <-bmi_covidA2.dat %>% 
  left_join(bmi_covidA2.radial.res$data, by = 'SNP') 


bmi_covidA2.res <- bmi_covidA2.mrdat %>% 
  filter(mr_keep == TRUE, Outliers == 'Variant') %>% 
  mr(., method_list = c("mr_ivw_fe", "mr_weighted_median", "mr_weighted_mode", "mr_egger_regression"))
bmi_covidA2.res


## BMI -> CovidB2 (Hopsital) 
message(glue("\n Loading: ", covidB2_ss.path))
covidB2_ss <- read_tsv(covidB2_ss.path) %>% 
  bmi_covidB2 <- covidB2_ss %>% 
  filter(SNP %in% bmi$SNP) %>% 
  format_data(., type = 'outcome',
              snp_col = 'SNP',
              beta_col = "BETA",
              se_col = "SE",
              eaf_col = "AF",
              effect_allele_col = "ALT",
              other_allele_col = "REF",
              pval_col = "P",
              z_col = "Z",
              samplesize_col = "N",
              phenotype_col = 'TRAIT', 
              chr_col = 'CHROM', 
              pos_col = 'POS' 
  ) %>% 
  as_tibble()

bmi_covidB2.dat <- harmonise_data(bmi, covidB2_ss) 

## Radial MR
bmi_covidB2.radial <- (
  bmi_covidB2.dat %>% 
    filter(pval.outcome > 5e-8) %>% 
    filter(mr_keep == TRUE) %>% 
    dat_to_RadialMR(.)
)[[1]] 

bmi_covidB2.radial.res <- ivw_radial(bmi_covidB2.radial, weights = 3, alpha = 0.05/nrow(bmi_covidB2.radial))
## MR
bmi_covidB2.mrdat <-bmi_covidB2.dat %>% 
  left_join(bmi_covidB2.radial.res$data, by = 'SNP') 


bmi_covidB2.res <- bmi_covidB2.mrdat %>% 
  filter(mr_keep == TRUE, Outliers == 'Variant') %>% 
  mr(., method_list = c("mr_ivw_fe", "mr_weighted_median", "mr_weighted_mode", "mr_egger_regression"))
bmi_covidB2.res


## BMI -> CovidC2 (Reported symptoms) 
message(glue("\n Loading: ", covidC2_ss.path))
covidC2_ss <- read_tsv(covidC2_ss.path) %>% 
  bmi_covidC2 <- covidC2_ss %>% 
  filter(SNP %in% bmi$SNP) %>% 
  format_data(., type = 'outcome',
              snp_col = 'SNP',
              beta_col = "BETA",
              se_col = "SE",
              eaf_col = "AF",
              effect_allele_col = "ALT",
              other_allele_col = "REF",
              pval_col = "P",
              z_col = "Z",
              samplesize_col = "N",
              phenotype_col = 'TRAIT', 
              chr_col = 'CHROM', 
              pos_col = 'POS' 
  ) %>% 
  as_tibble()

bmi_covidC2.dat <- harmonise_data(bmi, covidC2_ss) 

## Radial MR
bmi_covidC2.radial <- (
  bmi_covidC2.dat %>% 
    filter(pval.outcome > 5e-8) %>% 
    filter(mr_keep == TRUE) %>% 
    dat_to_RadialMR(.)
)[[1]] 

bmi_covidC2.radial.res <- ivw_radial(bmi_covidC2.radial, weights = 3, alpha = 0.05/nrow(bmi_covidC2.radial))
## MR
bmi_covidC2.mrdat <-bmi_covidC2.dat %>% 
  left_join(bmi_covidC2.radial.res$data, by = 'SNP') 


bmi_covidC2.res <- bmi_covidC2.mrdat %>% 
  filter(mr_keep == TRUE, Outliers == 'Variant') %>% 
  mr(., method_list = c("mr_ivw_fe", "mr_weighted_median", "mr_weighted_mode", "mr_egger_regression"))
bmi_covidC2.res


# ========================================================================================== ## 
##                                      Diabetes

diabetes_ss <- read_tsv(diabetes_ss.path) 
  diabetes <- diabetes_ss %>%
    filter(P < p.threshold )%>% 
  mutate(sb = std_beta(Z, AF, N)) %>% 
  mutate(sse = std_se(Z, AF, N)) %>% 
  format_data(., type = 'exposure',
              snp_col = 'SNP',
              beta_col = "sb",
              se_col = "sse",
              eaf_col = "AF",
              effect_allele_col = "ALT",
              other_allele_col = "REF",
              pval_col = "P",
              z_col = "Z",
              samplesize_col = "N",
              phenotype_col = 'TRAIT', 
              chr_col = 'CHROM', 
              pos_col = 'POS')  %>% 
  group_split(chr.exposure, keep = TRUE) %>% 
  map(., clump_data) %>% 
  bind_rows() %>% 
  as_tibble() 

##==========CovidA2 ==========##

# Diabetes -> CovidA2 
## harmonize
diabetes_covidC2.dat <- harmonise_data(diabetes, covidC2_ss) 

## Radial MR
diabetes_covidC2.radial <- (
  diabetes_covidC2.dat %>% 
    filter(pval.outcome > 5e-8) %>% 
    filter(mr_keep == TRUE) %>% 
    dat_to_RadialMR(.)
)[[1]] 
diabetes_covidC2.radial.res <- ivw_radial(diabetes_covidC2.radial, weights = 3, alpha = 0.05/nrow(diabetes_covidC2.radial))
## MR
diabetes_covidC2.mrdat <-diabetes_covidC2.dat %>% 
  left_join(diabetes_covidC2.radial.res$data, by = 'SNP') 
directionality_test(diabetes_covidC2.mrdat)

diabetes_covidC2.res <- diabetes_covidC2.mrdat %>% 
  filter(mr_keep == TRUE, Outliers == 'Variant') %>% 
  mr(., method_list = c("mr_ivw_fe", "mr_weighted_median", "mr_weighted_mode", "mr_egger_regression"))
generate_odds_ratios(diabetes_covidC2.res)


##==========BMI ==========##

# Diabetes -> BMI
diabetes_bmi.snps <- bmi %>% 
  filter(SNP %in% diabetes$SNP) %>% 
  mutate(TRAIT = 'BMI') %>%
  format_data(., type = 'outcome',
              snp_col = 'SNP',
              beta_col = "BETA",
              se_col = "SE",
              eaf_col = "AF",
              effect_allele_col = "ALT",
              other_allele_col = "REF",
              pval_col = "P",
              z_col = "Z",
              samplesize_col = "N",
              phenotype_col = 'TRAIT', 
              chr_col = 'CHROM', 
              pos_col = 'POS') 

diabetes_bmi.dat <- harmonise_data(diabetes, diabetes_bmi.snps) 


## Radial MR
diabetes_bmi.radial <- (
  diabetes_bmi.dat %>% 
    filter(pval.outcome > 5e-8) %>%
    filter(mr_keep == TRUE) %>%
    dat_to_RadialMR(.)
)[[1]] 

diabetes_bmi.radial.res <- ivw_radial(diabetes_bmi.radial, weights = 3, alpha = 0.05/nrow(diabetes_bmi.radial))
plot_radial(diabetes_bmi.radial.res, radial_scale = F)

## MR
diabetes_bmi.mrdat <- diabetes_bmi.dat %>% 
  left_join(diabetes_bmi.radial.res$data, by = 'SNP') 

diabetes_bmi.res <- diabetes_bmi.mrdat %>% 
  filter(mr_keep == TRUE, Outliers == 'Variant') %>% 
  mr(., method_list = c("mr_ivw_fe", "mr_weighted_median", "mr_weighted_mode", "mr_egger_regression"))
diabetes_bmi.res

diabetes_bmi.dat %>% 
  left_join(diabetes_bmi.radial.res$data, by = 'SNP') %>% 
  mr_heterogeneity(.)
directionality_test(diabetes_bmi.mrdat)



# ========================================================================================== ## 
##                                     MVMR

diabetes.outliers <- diabetes_covidC2.mrdat %>% 
  filter(Outliers == 'Outlier') %>%
  mutate(SNP = as.character(SNP)) %>%
  pull(SNP) # No outliers detected


bmi.outliers <- bmi_covidC2.mrdat %>% 
  filter(Outliers == 'Outlier') %>%
  mutate(SNP = as.character(SNP)) %>%
  pull(SNP)  # No outliers detected

filter(diabetes, SNP %in% diabetes.outliers)
filter(bmi, SNP %in% bmi.outliers)

snps <- bind_rows(bmi, diabetes) %>% 
  as_tibble() %>% 
  distinct(SNP) %>% 
  filter(SNP %nin% diabetes.outliers) %>% 
  filter(SNP %nin% bmi.outliers) %>%
  pull(SNP) 


## Select bmi + diabetes SNPs from diabetes GWAS
## Clump result dataframe
diabetes_all <- diabetes_ss %>% 
  filter(SNP %in% snps) %>% 
  format_data(., type = 'exposure',
              snp_col = 'SNP',
              beta_col = "BETA",
              se_col = "SE",
              eaf_col = "AF",
              effect_allele_col = "ALT",
              other_allele_col = "REF",
              pval_col = "P",
              z_col = "Z",
              samplesize_col = "N",
              phenotype_col = 'TRAIT', 
              chr_col = 'CHROM', 
              pos_col = 'POS') %>% 
  clump_data(.) %>% 
  as_tibble()  



## Extract clumped SNPs from BMI GWAS
bmi_all <- bmi_ss %>% 
  filter(SNP %in% diabetes_all$SNP) %>% 
  format_data(., type = 'exposure',
              snp_col = 'SNP',
              beta_col = "BETA",
              se_col = "SE",
              eaf_col = "AF",
              effect_allele_col = "ALT",
              other_allele_col = "REF",
              pval_col = "P",
              z_col = "Z",
              samplesize_col = "N",
              phenotype_col = 'TRAIT', 
              chr_col = 'CHROM', 
              pos_col = 'POS') %>% 
  as_tibble() 

## Bind GWAS togther
exposure_dat <- bind_rows(diabetes_all, bmi_all)

## harmonize exposures and outcomes
mvdat <- mv_harmonise_data(exposure_dat, covidC2_ss, harmonise_strictness = 1)
mvmr_covid <- mv_multiple(mvdat, pval_threshold = 5e-08)
mvmr_covid$result

write_tsv(mvmr_covid$result, file = "docs/20210823/MVMRresults_covidC2.tsv")
MVMRresults_covidC2$outcome <- "Reported infection"
MVMRresults_covidA2$outcome <- "Critical illness"
MVMRresults_covidB2$outcome <- "Hospitalisation"
MVMRresults_covidB2 <- MVMRresults_covidB2[order(MVMRresults_covidB2$b),]
MVMRresults <- rbind(MVMRresults_covidA2,MVMRresults_covidB2,MVMRresults_covidC2)
write_tsv(MVMRresults, file = "docs/20210823/MVMRresults.tsv")

