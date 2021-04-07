## ================================================================================ ##
##                                Misc functions                                    ##
## negate
`%nin%` = Negate(`%in%`)

## Standardization of SNP effect and its standard error using z-statistic, allele
## frequency and sample size. Based on gsmr::std_effect.
## http://cnsgenomics.com/software/gsmr/#Tutorial
std_beta = function(z, eaf, n){
  std.b = z/sqrt(2 * eaf * (1 - eaf) * (n + z^2))
  std.b
}

std_se = function(z, eaf, n){
  std.se = 1/sqrt(2 * eaf * (1 - eaf) * (n + z^2))
  std.se
}

# Calculated F-statistics
## Burgess, Stephen, Simon G. Thompson, and CRP CHD Genetics Collaboration. 2011.
## International Journal of Epidemiology 40 (3): 755–64.
## N: Sample size of exposure
## K: N SNPs
## R: variance explained
f_stat = function(N, K, R){
  f = ((N-K-1) / K) * (R/(1-R))}

## Proportion of phenotypic variance explained by SNP
## https://doi.org/10.1371/journal.pone.0120758.s001
snp.pve <- function(eaf, beta, se, n){
  (2*eaf*(1 - eaf)*beta^2) / (2 * beta * eaf * (1-eaf) + se^2 * 2 * n * eaf * (1-eaf))
}

## if value is less then 0.001, use scientific notation
round_sci <- function(x){ifelse(x < 0.001, formatC(x, format = "e", digits = 2), round(x, 3))}

## replace pvalues with stars
signif.num <- function(x) {
  symnum(x, corr = FALSE, na = FALSE, legend = FALSE,
         cutpoints = c(0, 0.001, 0.01, 0.05, 0.1, 1),
         symbols = c("***", "**", "*", ".", " "))
}

## Function for spreading multiple columns
# https://community.rstudio.com/t/spread-with-multiple-value-columns/5378
myspread <- function(df, key, value) {
  # quote key
  keyq <- rlang::enquo(key)
  # break value vector into quotes
  valueq <- rlang::enquo(value)
  s <- rlang::quos(!!valueq)
  df %>% gather(variable, value, !!!s) %>%
    unite(temp, !!keyq, variable) %>%
    spread(temp, value)
}

## From Greenbrown package
AllEqual <- structure(function(x) {
  res <- FALSE
  x <- na.omit(as.vector(x))
  if (length(unique(x)) == 1 | length(x) == 0) res <- TRUE
  return(res)
},ex=function(){
  AllEqual(1:10)
  AllEqual(rep(0, 10))
  AllEqual(letters)
  AllEqual(rep(NA, 10))
})

passfunc <- function(ivw.p, ivw.b, mre.p, mre.b, wme.p, wme.b, wmb.p, wmb.b){
  ifelse(AllEqual(c(
    ifelse(ivw.p < 0.05, sign(ivw.b), NA),
    ifelse(mre.p < 0.05, sign(mre.b), NA),
    ifelse(wme.p < 0.05, sign(wme.b), NA),
    ifelse(wmb.p < 0.05, sign(wmb.b), NA)
  )) == TRUE,
  TRUE, FALSE)
}

# Calculates the I-squared_GX statistic
## Adapted from MendelianRandomization::mr_egger
## X: harmonized SNP dataset from TwoSampleMR
Isq_gx <- function(x){
  By = sign(x$beta.exposure)*x$beta.outcome
  Bx = abs(x$beta.exposure)
  Bxse = x$se.exposure
  Byse = x$se.outcome

  Q = sum((Bxse/Byse)^-2*(Bx/Byse-weighted.mean(Bx/Byse, w=(Bxse/Byse)^-2))^2)
  Isq = max(0, (Q-(length(Bx)-1))/Q)
  return(Isq)
}

## Becuase for some reason when the qvalue package is loaded it cant find this function...
qvalue_truncp <- function (p, fdr.level = NULL, pfdr = FALSE, lfdr.out = TRUE,
  pi0 = NULL, ...)
{
  p_in <- qvals_out <- lfdr_out <- p
  rm_na <- !is.na(p)
  p <- p[rm_na]
  if (min(p) < 0 || max(p) > 1) {
    stop("p-values not in valid range [0, 1].")
  }
  else if (!is.null(fdr.level) && (fdr.level <= 0 || fdr.level >
    1)) {
    stop("'fdr.level' must be in (0, 1].")
  }
  p <- p/max(p)
  if (is.null(pi0)) {
    pi0s <- pi0est(p, ...)
  }
  else {
    if (pi0 > 0 && pi0 <= 1) {
      pi0s = list()
      pi0s$pi0 = pi0
    }
    else {
      stop("pi0 is not (0,1]")
    }
  }
  m <- length(p)
  i <- m:1L
  o <- order(p, decreasing = TRUE)
  ro <- order(o)
  if (pfdr) {
    qvals <- pi0s$pi0 * pmin(1, cummin(p[o] * m/(i * (1 -
      (1 - p[o])^m))))[ro]
  }
  else {
    qvals <- pi0s$pi0 * pmin(1, cummin(p[o] * m/i))[ro]
  }
  qvals_out[rm_na] <- qvals
  if (lfdr.out) {
    lfdr <- lfdr(p = p, pi0 = pi0s$pi0, ...)
    lfdr_out[rm_na] <- lfdr
  }
  else {
    lfdr_out <- NULL
  }
  if (!is.null(fdr.level)) {
    retval <- list(call = match.call(), pi0 = pi0s$pi0,
      qvalues = qvals_out, pvalues = p_in, lfdr = lfdr_out,
      fdr.level = fdr.level, significant = (qvals <= fdr.level),
      pi0.lambda = pi0s$pi0.lambda, lambda = pi0s$lambda,
      pi0.smooth = pi0s$pi0.smooth)
  }
  else {
    retval <- list(call = match.call(), pi0 = pi0s$pi0,
      qvalues = qvals_out, pvalues = p_in, lfdr = lfdr_out,
      pi0.lambda = pi0s$pi0.lambda, lambda = pi0s$lambda,
      pi0.smooth = pi0s$pi0.smooth)
  }
  class(retval) <- "qvalue"
  return(retval)
}
