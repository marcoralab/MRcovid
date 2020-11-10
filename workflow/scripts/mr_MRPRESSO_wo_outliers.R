#!/usr/bin/Rscript
## ========================================================================== ##
## MR: Estimate heterogenity after removing outliers using MR-PRESSO
## ========================================================================== ##

### ===== Command Line Arguments ===== ##
args = commandArgs(trailingOnly = TRUE) # Set arguments from the command line

infile = args[1] # Exposure summary statistics
out = args[2]

# infile = "data/MR_ADbidir/Grasby2020thickness/Willer2013hdl/Grasby2020thickness_5e-6_Willer2013hdl_mrpresso_MRdat.csv"
# out = "/Users/sheaandrews/Dropbox/Research/PostDoc-MSSM/2_MR/2_DerivedData/mvpa/load/mvpa_5e-6_load"

### ===== Load packages ===== ###
suppressMessages(library(tidyverse))   ## For data wrangling
suppressMessages(library(MRPRESSO)) ## For detecting pleitropy

### ===== READ IN DATA ===== ###
message("\n READING IN HARMONIZED MR DATA \n")
mrdat.raw <- read_csv(infile, col_types = list(mrpresso_pval = col_character())) %>%
  filter(mr_keep == TRUE) %>%
  filter(pleitropy_keep == TRUE)

mrdat <- filter(mrdat.raw, mrpresso_keep == TRUE)

if(nrow(mrdat) < nrow(mrdat.raw)){

  if(nrow(mrdat) > 3){
    ## Data Frame of nsnps and number of iterations
    df.NbD <- data.frame(n = c(10, 50, 100, 500, 1000, 1500, 2000),
                         NbDistribution = c(10000, 10000, 10000, 25000, 50000, 75000, 100000))

    nsnps <- nrow(mrdat)
    SignifThreshold <- 0.05
    NbDistribution <- df.NbD[which.min(abs(df.NbD$n - nsnps)), 2]

    ### ===== MR-PRESSO ===== ###
    message("\n CALCULATING PLEITROPY \n")
    set.seed(333)
    mrpresso.out <- mr_presso(BetaOutcome = "beta.outcome",
                              BetaExposure = "beta.exposure",
                              SdOutcome = "se.outcome",
                              SdExposure = "se.exposure",
                              OUTLIERtest = FALSE,
                              DISTORTIONtest = FALSE,
                              data = as.data.frame(mrdat),
                              NbDistribution = NbDistribution,
                              SignifThreshold = SignifThreshold)

    ### ===== FORMAT DATA ===== ###
    ## extract RSSobs and Pvalue
    message("\n Extracting RSSobs and Pvalue \n")

    mrpresso.p <- mrpresso.out$`MR-PRESSO results`$`Global Test`$Pvalue
    RSSobs <- mrpresso.out$`MR-PRESSO results`$`Global Test`$RSSobs


    # Write n outliers, RSSobs and Pvalue to tibble
    message("\n Writing Results \n")

    mrpresso.dat <- tibble(id.exposure = as.character(mrdat[1,'id.exposure']),
                           id.outcome = as.character(mrdat[1,'id.outcome']),
                           outcome = as.character(mrdat[1,'outcome']),
                           exposure = as.character(mrdat[1,'exposure']),
                           pt = mrdat.raw %>% slice(1) %>% pull(pt),
                           outliers_removed = TRUE,
                           n_outliers = (nrow(mrdat.raw) - nrow(mrdat)),
                           RSSobs = RSSobs,
                           pval = mrpresso.p)

  } else {
    message("\n Not enough intrumental variables \n")

    mrpresso.dat <- tibble(id.exposure = as.character(mrdat[1,'id.exposure']),
                           id.outcome = as.character(mrdat[1,'id.outcome']),
                           outcome = as.character(mrdat[1,'outcome']),
                           exposure = as.character(mrdat[1,'exposure']),
                           pt = mrdat.raw %>% slice(1) %>% pull(pt),
                           outliers_removed = TRUE,
                           n_outliers = (nrow(mrdat.raw) - nrow(mrdat)),
                           RSSobs = NA,
                           pval = NA)
  }

} else {
  message("\n NO OUTLIER VARIANTS \n")

  mrpresso.dat <- tibble(id.exposure = as.character(mrdat[1,'id.exposure']),
                         id.outcome = as.character(mrdat[1,'id.outcome']),
                         outcome = as.character(mrdat[1,'outcome']),
                         exposure = as.character(mrdat[1,'exposure']),
                         pt = mrdat.raw %>% slice(1) %>% pull(pt),
                         outliers_removed = TRUE,
                         n_outliers = (nrow(mrdat.raw) - nrow(mrdat)),
                         RSSobs = NA,
                         pval = NA)
}

write_tsv(mrpresso.dat, paste0(out, '_global_wo_outliers.txt'))
