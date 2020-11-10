library(tidyverse)
library(fastDummies)
`%nin%` = Negate(`%in%`)

## Read in ADGC pheno file
cohort.pheno.path <- snakemake@input[["pheno_file"]]
keep_out <- snakemake@output[["keep"]]
pheno_out <- snakemake@output[["pheno"]]

## Exclude samples
message('\n READ AND FILTER DATA \n')
dat <- read_tsv(cohort.pheno.path)
df <- dat %>%
  filter(!QC_omit) %>%
  filter(!ADGC_omit) %>%
  filter(!rel_omit) %>%
  filter(status %in% c(1,2)) %>%
  filter(!is.na(jointPC1)) %>%
  filter(!is.na(aaoaae2)) %>%
  filter(!is.na(apoe4dose)) %>%
  filter(cohort %nin% c('GSK')) %>%
  mutate(cohort = fct_infreq(cohort)) %>%
  dummy_cols(., select_columns = "cohort", remove_first_dummy = TRUE)

#  filter(cohort %nin% c('ACT2', 'BIOCARD', 'EAS', 'UKS', 'GSK'))

## Write out list of sample to keep
message('\n EXPORT \n')
df %>%
  select(FID, IID) %>%
  write_tsv(keep_out)

## Males Only
df %>%
  filter(sex == 1) %>%
  select(FID, IID) %>%
  write_tsv(paste0(keep_out, '_male'))

## Females Only
df %>%
  filter(sex == 2) %>%
  select(FID, IID) %>%
  write_tsv(paste0(keep_out, '_female'))

# ## Write out dataframe of phenotypes
write_tsv(df, pheno_out)

message('\n TABLE OF EXCLUDED \n')
exclusions <- summarise(dat,
          total = nrow(dat) - nrow(df),
          QC_omit = sum(QC_omit),
          ADGC_omit = sum(ADGC_omit, na.rm = T),
          rel_omit = sum(rel_omit, na.rm = T),
          status = sum(status %nin% c(1,2)),
          miss.pc = sum(is.na(jointPC1)),
          miss.aaoaae2 = sum(is.na(aaoaae2)),
          miss.apoe4dose = sum(is.na(apoe4dose)))

exclusions
