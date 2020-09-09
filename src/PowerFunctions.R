require(tidyverse)
require(inflection)

## F statistic. Burgess et al 2011
f_stat = function(N, K, R){
  f = ((N-K-1) / K) * (R/(1-R))}

## Proportion of phenotypic variance explained by SNP 
## https://doi.org/10.1371/journal.pone.0120758.s001
snp.pve <- function(eaf, beta, se, n){
  (2*eaf*(1 - eaf)*beta^2) / (2 * beta * eaf * (1-eaf) + se^2 * 2 * n * eaf * (1-eaf))
}

## -------------------------------------------------------------------------------- ##  
# Conduct power analysis for a binary outcome across a range of hypothetical effect sizes 
# to find the detectetable effect size that results in 80% power 
# Derived from Brion et al 2013
find_power_binary <- function(x, exposure, outcome, Nexposure, Noutcome, nsnps, alpha, R2xz, K, verbose){
  ## Inputs
  alpha = ifelse(missing(alpha), 0.05, alpha) # Alpha
  exposure = ifelse(missing(exposure), x$exposure, exposure) # exposure name
  outcome = ifelse(missing(outcome), x$outcome, outcome) # 
  Nexposure = ifelse(missing(Nexposure), x$samplesize.exposure, Nexposure)
  Noutcome = ifelse(missing(Noutcome), x$samplesize.outcome, Noutcome)
  nsnps = ifelse(missing(nsnps), x$nsnps, nsnps)
  R2xz = ifelse(missing(R2xz), x$pve.exposure, R2xz)
  K = ifelse(missing(K), x$k.outcome, K)
  verbose = ifelse(missing(verbose), FALSE, verbose) ## Print entire df?
  ## F-Stat
  f = f_stat(Nexposure, nsnps, R2xz)
  
  ## Power
  OR = 1
  i = 1
  power = 0
  power.ls <- list()
  while(power < 0.9 && i < 10001){
    if(i < 1000){
      if(power < 0.7){
        OR = OR + 0.01
      } else {
        OR = OR + 0.001
      }
    } else {
      if(power < 0.7){
        OR = OR + 0.1
      } else {
        OR = OR + 0.01
      }
    }

    i = i + 1
    threschi <- qchisq(1 - alpha, 1)
    b_MR <- K * ( OR/ (1 + K * (OR - 1)) -1)
    v_MR <- (K * (1-K) - b_MR^2) / (Noutcome*R2xz)
    NCP <- b_MR^2 / v_MR
    power <- 1 - pchisq(threschi, 1, NCP)
    
    if(!missing(x)){
      out <- x %>% 
        mutate('F' = f,
               Alpha = alpha, 
               OR = OR, 
               NCP = NCP, 
               Power = power)
    } else {
      out <- tibble('exposure' = exposure, 
             'outcome' = outcome, 
             "Noutcome" = Noutcome, 
             'Proportion_of_Cases' = K, 
             'Nexposure' = Nexposure, 
             'PVE' = R2xz, 
             'F' = f, 
             "Alpha" = alpha, 
             'OR' = OR,
             "NCP" = NCP, 
             "Power" = power)
    }
    #print(out); print(OR); print(i)
    power.ls[[1 + i]] <- out
  }
  if(verbose == FALSE){
    power.df <- power.ls %>% bind_rows() 
    if(nrow(power.df) == 10000){
      inflec <- with(power.df, ede(OR, Power, 0))
      power.df %>% slice(which.min(abs(inflec[3] - OR)))
    } else {
      power.df %>% slice(which.min(abs(0.8 - Power)))
    }
  } else {
    power.ls %>% bind_rows()
  }
}

## Conduct power analysis given effect size
results_binary <- function(x, exposure, outcome, Nexposure, Noutcome, nsnps, alpha, OR, R2xz, K) {
  alpha = ifelse(missing(alpha), 0.05, alpha) # Alpha
  exposure = ifelse(missing(exposure), x$exposure, exposure) # exposure name
  outcome = ifelse(missing(outcome), x$outcome, outcome) # 
  Nexposure = ifelse(missing(Nexposure), x$samplesize.exposure, Nexposure)
  Noutcome = ifelse(missing(Noutcome), x$samplesize.outcome, Noutcome)
  nsnps = ifelse(missing(nsnps), x$nsnps, nsnps)
  R2xz = ifelse(missing(R2xz), x$pve.exposure, R2xz)
  K = ifelse(missing(K), x$k.outcome, K)
  OR = ifelse(missing(OR), x$or, OR)
  
  f = f_stat(Nexposure, nsnps, R2xz)
  
  threschi <- qchisq(1 - alpha, 1) # threshold chi(1) scale
  
  b_MR <- K * ( OR/ (1 + K * (OR - 1)) -1)
  v_MR <- (K * (1-K) - b_MR^2) / (Noutcome*R2xz)
  NCP <- b_MR^2 / v_MR
  
  # 2-sided test
  power <- 1 - pchisq(threschi, 1, NCP)
  
  if(!missing(x)){
    out <- x %>% 
      mutate('F' = f,
             Alpha = alpha, 
             NCP = NCP, 
             Power = power)
  } else {
    out <- tibble('exposure' = exposure, 
                  'outcome' = outcome, 
                  "Noutcome" = Noutcome, 
                  'Proportion_of_Cases' = K, 
                  'Nexposure' = Nexposure, 
                  'PVE' = R2xz, 
                  'F' = f, 
                  "Alpha" = alpha, 
                  "NCP" = NCP, 
                  "Power" = power)
  }
  
  out 
  
}
## -------------------------------------------------------------------------------- ##
# Conduct power analysis for a continous outcome across a range of hypothetical effect sizes 
# to find the detectetable effect size that results in 80% power 
# By default it assumes that Var(Y|X) = 1
# Derived from Brion et al 2013
find_power_cont <- function(x, exposure, outcome, Nexposure, Noutcome, nsnps, alpha, varx, vary, R2xz, verbose) {
  ## Inputs
  outcome = ifelse(missing(outcome), x$outcome, outcome) # 
  Nexposure = ifelse(missing(Nexposure), x$samplesize.exposure, Nexposure)
  Noutcome = ifelse(missing(Noutcome), x$samplesize.outcome, Noutcome)
  nsnps = ifelse(missing(nsnps), x$nsnps, nsnps) 
  R2xz = ifelse(missing(R2xz), x$pve.exposure, R2xz) # Phenotypic variacne explained
  alpha = ifelse(missing(alpha), 0.05, alpha) # Alpha
  varx = ifelse(missing(varx), 1, varx) # Variance of the exposure variable
  vary = ifelse(missing(vary), 1, vary) # Variance of the outcome variable
  verbose = ifelse(missing(verbose), FALSE, verbose) ## Print entire df?
  
  ## F-Stat
  f = f_stat(Nexposure, nsnps, R2xz)
  
  ## Power
  byx = 0 
  power = 0
  power.ls <- list()
  while(power < 0.9){
    byx = byx + 0.001
    i = (byx / 0.001)
    
    threschi <- qchisq(1 - alpha, 1)
    R2yz <- byx^2 * (varx / vary) * R2xz
    NCP <- Noutcome * R2yz / (1 - R2yz)
    power <- 1 - pchisq(threschi, 1, NCP)
    
    if(!missing(x)){
      out <- x %>% 
        mutate('F' = f, 
               Alpha = alpha, 
               byx = byx, 
               NCP = NCP, 
               Power = power)
    } else {
      out <- tibble('exposure' = exposure, 
                    'outcome' = outcome, 
                    "Noutcome" = Noutcome, 
                    'Proportion_of_Cases' = K, 
                    'Nexposure' = Nexposure, 
                    'PVE' = R2xz, 
                    'F' = f, 
                    "Alpha" = alpha, 
                    'byx' = byx,
                    "NCP" = NCP, 
                    "Power" = power)
    }
    power.ls[[1 + i]] <- out
  }
  if(verbose == FALSE){
    power.ls %>% bind_rows() %>% slice(which.min(abs(0.8 - Power)))
  } else {
    power.ls %>% bind_rows()
  }
}

## Results given observed effect size
results_beta_based <- function(x, exposure, outcome, Nexposure, Noutcome, nsnps, alpha, varx, vary, R2xz, byx) {
  ## Inputs
  outcome = ifelse(missing(outcome), x$outcome, outcome) # 
  Nexposure = ifelse(missing(Nexposure), x$samplesize.exposure, Nexposure)
  Noutcome = ifelse(missing(Noutcome), x$samplesize.outcome, Noutcome)
  nsnps = ifelse(missing(nsnps), x$nsnps, nsnps) 
  R2xz = ifelse(missing(R2xz), x$pve.exposure, R2xz) # Phenotypic variacne explained
  alpha = ifelse(missing(alpha), 0.05, alpha) # Alpha
  varx = ifelse(missing(varx), 1, varx) # Variance of the exposure variable
  vary = ifelse(missing(vary), 1, vary) # Variance of the outcome variable
  byx = ifelse(missing(byx), x$beta, byx)

  ## F-stat
  f = f_stat(Nexposure, nsnps, R2xz)
  
  ## Power calc
  threschi <- qchisq(1 - alpha, 1)
  R2yz <- byx^2 * (varx / vary) * R2xz
  NCP <- Noutcome * R2yz / (1 - R2yz)
  power <- 1 - pchisq(threschi, 1, NCP)

  ## Reporting 
  if(!missing(x)){
    out <- x %>% 
      mutate('F' = f, 
             Alpha = alpha, 
             NCP = NCP, 
             Power = power)
  } else {
    out <- tibble('exposure' = exposure, 
                  'outcome' = outcome, 
                  "Noutcome" = Noutcome, 
                  'Proportion_of_Cases' = K, 
                  'Nexposure' = Nexposure, 
                  'PVE' = R2xz, 
                  'F' = f, 
                  "Alpha" = alpha, 
                  "NCP" = NCP, 
                  "Power" = power)
  }
  out
}

## -------------------------------------------------------------------------------- ##
##                                  References                                      ##

## Freeman, Guy, Benjamin J. Cowling, and C. Mary Schooling. 2013. 
## “Power and Sample Size Calculations for Mendelian Randomization Studies Using One Genetic Instrument.” 
## International Journal of Epidemiology 42 (4): 1157–63.
## https://sb452.shinyapps.io/power/

## Brion, Marie-Jo A., Konstantin Shakhbazov, and Peter M. Visscher. 2013. 
## “Calculating Statistical Power in Mendelian Randomization Studies.” 
## International Journal of Epidemiology 42 (5): 1497–1501.
## http://cnsgenomics.com/shiny/mRnd/ 

## Burgess, Stephen. 2014. 
## “Sample Size and Power Calculations in Mendelian Randomization with a Single Instrumental Variable and a Binary Outcome.” 
## International Journal of Epidemiology 43 (3): 922–29.

## Burgess, Stephen, Simon G. Thompson, and CRP CHD Genetics Collaboration. 2011. 
## Avoiding bias from weak instruments in Mendelian randomization studies
## International Journal of Epidemiology 40 (3): 755–64.

## Rerun Hilbar2015hipv with standardized effects 
## Based on gsmr::std_effect. 
## Standardization of SNP effect and its standard error using z-statistic, allele frequency and sample size
## http://cnsgenomics.com/software/gsmr/#Tutorial



