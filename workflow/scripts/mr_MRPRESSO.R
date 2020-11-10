#!/usr/bin/Rscript
## ========================================================================== ##
## MR: Identify outliers using MR-PRESSO
## ========================================================================== ##

### ===== Command Line Arguments ===== ##
args = commandArgs(trailingOnly = TRUE) # Set arguments from the command line

infile = args[1] # Exposure summary statistics
out = args[2]

### ===== Load packages ===== ###
suppressMessages(library(tidyverse))   ## For data wrangling
suppressMessages(library(MRPRESSO)) ## For detecting pleitropy

### ===== READ IN DATA ===== ###
message("\n READING IN HARMONIZED MR DATA \n")
mrdat.raw <- read_csv(infile)
mrdat <- mrdat.raw %>%
  filter(mr_keep == TRUE) %>%
  filter(pleitropy_keep == TRUE)

## Data Frame of nsnps and number of iterations
df.NbD <- data.frame(n = c(10, 50, 100, 500, 1000, 1500, 2000),
                     NbDistribution = c(10000, 10000, 10000, 25000, 50000, 75000, 100000))

nsnps <- nrow(mrdat)
SignifThreshold <- 0.05
NbDistribution <- df.NbD[which.min(abs(df.NbD$n - nsnps)), 2]
## Bonfernoni correction, needs a crazy amount of nbdistributions for larger nsnps.
# SignifThreshold <- 0.05/nsnps
# NbDistribution <- (nsnps+100)/SignifThreshold

### ===== MR-PRESSO ===== ###
message("\n CALCULATING PLEITROPY \n")

set.seed(333)
mrpresso.out <- mr_presso(BetaOutcome = "beta.outcome",
                               BetaExposure = "beta.exposure",
                               SdOutcome = "se.outcome",
                               SdExposure = "se.exposure",
                               OUTLIERtest = TRUE,
                               DISTORTIONtest = TRUE,
                               data = as.data.frame(mrdat),
                               NbDistribution = NbDistribution,
                               SignifThreshold = SignifThreshold)

### ===== FORMAT DATA ===== ###
## extract RSSobs and Pvalue
if("Global Test" %in% names(mrpresso.out$`MR-PRESSO results`)){
  mrpresso.p <- mrpresso.out$`MR-PRESSO results`$`Global Test`$Pvalue
  RSSobs <- mrpresso.out$`MR-PRESSO results`$`Global Test`$RSSobs
} else {
  mrpresso.p <- mrpresso.out$`MR-PRESSO results`$Pvalue
  RSSobs <- mrpresso.out$`MR-PRESSO results`$RSSobs
}

## If Global test is significant, append outlier tests to mrdat
if("Outlier Test" %in% names(mrpresso.out$`MR-PRESSO results`)){
  outliers <- mrdat %>%
    bind_cols(mrpresso.out$`MR-PRESSO results`$`Outlier Test`) %>%
    rename(mrpresso_RSSobs = RSSobs, mrpresso_pval = Pvalue) %>%
    mutate(mrpresso_keep = as.numeric(str_replace_all(mrpresso_pval, pattern="<", repl="")) > SignifThreshold) %>%
    select(SNP, mrpresso_RSSobs, mrpresso_pval, mrpresso_keep)
  mrdat.out <- mrdat.raw %>%
    left_join(outliers, by = 'SNP')
} else {
  mrdat.out <- mrdat.raw %>%
    mutate(mrpresso_RSSobs = NA, mrpresso_pval = NA) %>%
    mutate(mrpresso_keep = ifelse(mr_keep == TRUE, TRUE, NA))
}

# Write n outliers, RSSobs and Pvalue to tibble
mrpresso.dat <- tibble(id.exposure = as.character(mrdat[1,'id.exposure']),
                       id.outcome = as.character(mrdat[1,'id.outcome']),
                       outcome = as.character(mrdat[1,'outcome']),
                       exposure = as.character(mrdat[1,'exposure']),
                       pt = mrdat.raw %>% slice(1) %>% pull(pt),
                       outliers_removed = FALSE,
                       n_outliers = sum(mrdat.out$mrpresso_keep == F, na.rm = T),
                       RSSobs = RSSobs,
                       pval = mrpresso.p)

### ===== EXPORTING ===== ###
message("\n EXPORTING REPORTS \n")
sink(paste0(out, '.txt'), append=FALSE, split=FALSE)
mrpresso.out
sink()

write_tsv(mrpresso.dat, paste0(out, '_global.txt'))
write_csv(mrdat.out, paste0(out, '_MRdat.csv'))
