## ================================================================================ ##
##                                Misc functions                                    ##

exposures = c('Yengo2018bmi', 'Mahajan2018t2d', 'Willer2013hdl', 'Willer2013ldl',
              'Willer2013tc', 'Willer2013tg', 'Dashti2019slepdur', 'Klimentidis2018mvpa',
              'Day2018sociso', 'Evangelou2018dbp', 'Evangelou2018sbp', 'Evangelou2018pp',
              'Lee2018educ', 'Howard2018dep', 'Jansen2018insom', 'Liu2019smkint',
              'Liu2019smkcpd', 'Liu2019drnkwk', 'Kunkle2019load', 'Revez2020vit250hd',
              'Okada2014rartis', 'Nalls2019pd', 'Nicolas2018als', 'Ligthart2018crp',
              'Wood2014height', 'Betham2015lupus', 'Patsopoulos2019multscler', 'Malik2018as', 'Malik2018ais',
              'Wuttke2019egfr', 'Wuttke2019ckd', 'Nikpay2015cad', 'Shah2020heartfailure',
              'Olafsdottir2020asthma', 'Allen2020ipf', 'Linner2019risk', 'Demontis2018adhd',
              'Grove2019asd', 'Ripke2014scz', 'Stahl2019bip', 'Astel2016rbc', 'Astel2016wbc',
              'Astel2016plt', 'Mills2021afb')
outcomes = c(
  "covidhgi2020A2v5alleur", "covidhgi2020B2v5alleur", "covidhgi2020C2v5alleur",
  "covidhgi2020A2v5alleurLeaveUKBB", "covidhgi2020B2v5alleurLeaveUKBB", "covidhgi2020C2v5alleurLeaveUKBB"
)

## Sample Sizes
samplesize = tribble(~code, ~domain, ~trait, ~pmid, ~logistic, ~samplesize, ~ncase, ~ncontrol, ~prevelance,
                  "Lambert2013load", "Diagnosis", "LOAD", 0820047, TRUE, 63926, 21982, 41944, 0.31,
                  "Kunkle2019load", "Diagnosis", "Alzheimer's disease", 24162737, TRUE, 54162, 17008, 37154, 0.31,
                  "Huang2017aaos", "Diagnosis", "AAOS", 28628103, TRUE, 40255, 14406, 25849, 0.31,
                  "Deming2017ab42", "CSF", "AB42", 28247064, FALSE, 3146, NA, NA, NA,
                  "Deming2017ptau", "CSF", "Ptau181", 28247064, FALSE, 3146, NA, NA, NA,
                  "Deming2017tau", "CSF", "Tau", 28247064, FALSE, 3146, NA, NA, NA,
                  "Hilbar2017hipv", "Neuroimaging", "Hippocampal Volume", 28098162, FALSE, 26814, NA, NA, NA,
                  "Hilbar2015hipv", "Neuroimaging", "Hippocampal Volume", 25607358, FALSE, 13688, NA, NA, NA,
                  "Grasby2020surfarea", "Neuroimaging", "Cortical Surface Area", 32193296, FALSE, 33709, NA, NA, NA,
                  "Grasby2020thickness","Neuroimaging", "Cortical Thickness", 32193296, FALSE, 33709, NA, NA, NA,
                  "Beecham2014npany", "Neuropathology", "Neuritic Plaques", 25188341, TRUE, 4046, 3426, 620, 0.36,
                  "Beecham2014braak4", "Neuropathology", "Neurofibrillary Tangles", 25188341, TRUE, 4735, 2927, 1808, 0.93,
                  "Beecham2014vbiany", "Neuropathology", "Vascular Brain Injury", 25188341, TRUE, 2764, 992, 1772, 0.2,
                  "Yengo2018bmi", "Health", "BMI", 30124842, FALSE, 690495, NA, NA, NA,
                  "Locke2015bmi", "Health", "BMI, Locke", 25673413, FALSE, 339224, NA, NA, NA,
                  "Xue2018diab", "Health", "Type 2 diabetes", 30054458, TRUE, 659316, 62892, 596424, 0.085,
                  "Niarchou2020meat", "Behavioural", "Meat diet", 32066663, FALSE, 335576, NA, NA, NA,
                  "Niarchou2020fish", "Behavioural", "Fish and Plant diet", 32066663, FALSE, 335576, NA, NA, NA,
                  "Wells2019hdiff", "Health", "Hearing difficulties", 31564434, FALSE, 250389, 87056, 163333, 0.35,
                  "Willer2013hdl", "Health", "High-density lipoproteins", 24097068, FALSE, 188577, NA, NA, NA,
                  "Willer2013ldl", "Health", "Low-density lipoproteins", 24097068, FALSE, 188577, NA, NA, NA,
                  "Willer2013tc", "Health", "Total cholesterol", 24097068, FALSE, 188577, NA, NA, NA,
                  "Willer2013tg", "Health", "Triglycerides", 24097068, FALSE, 188577, NA, NA, NA,
                  "Dashti2019slepdur",  "Health", "Sleep duration", 30846698, FALSE, 446118, NA, NA, NA,
                  "Campos2020snor",  "Health", "Snoring", 32060260, FALSE, 408317, NA, NA, NA,
                  "Day2018sociso", "Neurpsychatric", "Social isolation", 29970889, FALSE, 452302, NA, NA, NA,
                  "Klimentidis2018mvpa", "Behavioural", "Moderate-to-vigorous PA", 29899525, FALSE, 377234, NA, NA, NA,
                  "Evangelou2018dbp", "Health", "Diastolic blood pressure", 30224653, FALSE, 757601, NA, NA, NA,
                  "Evangelou2018sbp", "Health", "Systolic blood pressure", 30224653, FALSE, 757601, NA, NA, NA,
                  "Evangelou2018pp", "Health", "Pulse pressure", 30224653, FALSE, 757601, NA, NA, NA,
                  "Liu2019drnkwk23andMe", "Behavioural", "Alcohol consumption", 30643251, FALSE, 941280, NA, NA, NA,
                  "Liu2019drnkwk", "Behavioural", "Alcohol consumption", 30643251, FALSE, 537349,  NA, NA, NA,
                  "Liu2019smkcpd23andMe", "Behavioural", "Cigarettes per day", 30643251, FALSE, 337334, NA, NA, NA,
                  "Liu2019smkcpd", "Behavioural", "Cigarettes per day", 30643251, FALSE, 263954, NA, NA, NA,
                  "Liu2019smkint23andMe", "Behavioural", "Smoking initiation", 30643251, TRUE, 1232091, 557337, 674754, 0.45,
                  "Liu2019smkint", "Behavioural", "Smoking initiation", 30643251, TRUE, 632802, 311628, 321174, 0.45,
                  "Liu2019smkaoi", "Behavioural", "Smoking AOI", 30643251, FALSE, 262990, NA, NA, NA,
                  "Liu2019smkces", "Behavioural", "Smoking cessation", 30643251, TRUE, 312821, 139453, 407766, 0.44,
                  "Jansen2018insomnia23andMe", "Neurpsychatric", "Insomnia symptoms", 30804565, TRUE, 1331010, 397972, 933038, 0.29,
                  "Jansen2018insom", "Neurpsychatric", "Insomnia symptoms", 30804565, TRUE, 386533, 108229, 278304, 0.28,
                  "Howard2019dep23andMe", "Neurpsychatric", "depression", 30718901, TRUE, 807553, 246363, 561190, 0.32,
                  "Howard2018dep", "Neurpsychatric", "depression", 30718901, TRUE, 322580, 113769, 208811, 0.35,
                  "SanchezRoige2019auditt23andMe", "Behavioural", "AUDIT", 30336701, FALSE, 141932, NA, NA, NA,
                  "Lee2018education23andMe", "Behavioural", "Educational attainment", 30038396, FALSE, 1131881, NA, NA, NA,
                  "Lee2018educ", "Behavioural", "Educational attainment", 30038396, FALSE, 775120, NA, NA, NA,
                  "Okbay2016educ", "Behavioural", "Education, Okbay", 27225129, FALSE, 293723, NA, NA, NA,
                  "Chauhan2019bi", "Neuropathology", "Brain infarcts", 30651383, TRUE, 21682, 3726, 17956, 0.2,
                  "Revez2020vit250hd", "Health", "25 hydroxyvitamin D", 32242144, FALSE, 417580, NA, NA, NA,
                  "Okada2014rartis", "Diagnosis", "Rheumatoid arthritis", 24390342, TRUE, 58284, 14361, 43923, 0.005,
                  "Nalls2019pd", "Diagnosis", "Parkinsons disease", 31701892, TRUE, 482730, 56306, 1417791, 0.005,
                  "Huang2017aaos", "Diagnosis", "AAOS", 28628103, TRUE, 40255, 14406, 25849, 0.31,
                  "Ligthart2018crp", "Health", "CRP", 30388399, FALSE, 204402, NA, NA, NA,
                  "Yengo2018height", "Health", "Height", 30124842, FALSE, 693529, NA, NA, NA,
                  "Wood2014height", "Health", "Height", 25282103, FALSE, 253288, NA, NA, NA,
                  "Betham2015lupus", "Diagnosis", "Lupus", 26502338, TRUE, 23210, 7219, 15991, 0.0024,
                  "Beecham2013multscler", "Diagnosis", "Multiple sclerosis", 24076602, TRUE, 38589, 14498, 24091, 0.0045,
                  "Patsopoulos2019multscler", "Diagnosis", "Multiple sclerosis", 31604244, TRUE, 115803, 47429, 68374, 0.0045,
                  "Malik2018as", "Diagnosis", "Any stroke", 29531354, TRUE, 446696, 40585, 406111, 0.055,
                  "Malik2018ais", "Diagnosis", "Ischemic stroke", 29531354, TRUE, 440328, 34217, 406111, 0.055,
                  "Wuttke2019egfr", "Health", "eGFR", 31152163, FALSE, 765286, NA, NA, NA,
                  "Wuttke2019ckd", "Diagnosis", "Chronic kidney disease", 31152163, TRUE, 659525, 53339, 606186, 0.08,
                  "Nikpay2015cad", "Diagnosis", "Coronary artery disease", 26343387, TRUE, 184305, 60801, 123504, 0.05,
                  "Shah2020heartfailure", "Diagnosis", "Heart failure", 31919418, TRUE, 977323, 47309, 930014, 0.025,
                  "Olafsdottir2020asthma", "Diagnosis", "Asthma", 31959851, TRUE, 771388, 69189, 702199, 0.09,
                  "Allen2020ipf", "Diagnosis", "Idiopathic pulmonary fibrosis", 31710517, TRUE, 11259, 2668, 8591, 0.0002,
                  "Nicolas2018als", "Diagnosis", "Amyotrophic lateral sclerosis", 29566793, TRUE, 80610, 20806, 59804, 0.005,
                  # "code", "domain", "trait", pmid, logistic, samplesize, ncase, ncontrol, prevelance,
                  "Linner2019risk", "Neurpsychatric", "Risk tolerance", 30643258, FALSE, 466571, NA, NA, NA,
                  "Demontis2018adhd", "Neurpsychatric", "ADHD", 30478444, TRUE, 53293, 19099, 34194, 0.05,
                  "Ripke2014scz", "Neurpsychatric", "Schizophrenia", 25056061, TRUE, 77096, 33640, 43456, 0.01,
                  "Ripke2014sczall", "Neurpsychatric", "Schizophrenia", 25056061, TRUE, 150064, 36989, 113075, 0.01,
                  "Stahl2019bip", "Neurpsychatric", "Bipolar disorder", 31043756, TRUE, 51710, 20352, 31358, 0.01,
                  "Grove2019asd", "Neurpsychatric", "Autism spectrum disorder", 30804558, TRUE, 46351, 18382, 27969, 0.02,
                  "Astel2016rbc", "Health", "Red blood cell count", 27863252, FALSE, 173480, NA, NA, NA,
                  "Astel2016wbc", "Health", "White blood cell count", 27863252, FALSE, 173480, NA, NA, NA,
                  "Astel2016plt", "Health", "Platelet count", 27863252, FALSE, 173480, NA, NA, NA,
                  # "Barban2016afb", "Behavioural", "Age at first birth", 27798627, FALSE, 251151, NA, NA, NA,
                  "Mills2021afb", "Behavioural", "Age at first birth", 9999, FALSE, 542901, NA, NA, NA,
                  "Mahajan2018t2d", "Diagnosis", "Diabetes", 30297969, TRUE, 898130, 74124, 824006, 0.085,
                  # Datafreez v4
                  "covidhgi2020anaA2v4", "Diagnosis", "COVID: A2", 9999, TRUE, 628238, 4336, 623902, 0.007,
                  "covidhgi2020anaA2v4eurwoukbb", "Diagnosis", "COVID: A2", 9999, TRUE, 22770, 3503, 19267, 0.15,
                  "covidhgi2020anaB1v4", "Diagnosis", "COVID: B1", 9999, TRUE, 10908, 2430, 8478,  0.22,
                  "covidhgi2020anaB2v4", "Diagnosis", "COVID: B2", 9999, TRUE, 969689, 7885, 961804,  0.008,
                  "covidhgi2020anaB2v4eur23andMe", "Diagnosis", "COVID: B2, EUR", 9999, TRUE, 1589523, 7019, 1582504, 0.004,
                  "covidhgi2020anaB2v4eur", "Diagnosis", "COVID: B2, EUR w/o 23andMe", 9999, TRUE, 908494, 6406, 902088,  0.007,
                  "covidhgi2020anaB2v4eurwoukbb", "Diagnosis", "COVID: B2, EUR w/o 23andMe, UKB", 9999, TRUE, 543388, 5641, 537747,  0.01,
                  "covidhgi2020anaC1v4", "Diagnosis", "COVID: C1", 9999, TRUE, 127879, 11085, 116794,  0.086,
                  "covidhgi2020anaC2v4", "Diagnosis", "COVID: C2", 9999, TRUE, 1388512, 17965, 1370547,  0.013,
                  "covidhgi2020anaC2v4eur23andMe", "Diagnosis", "COVID: C2, EUR", 9999, TRUE, 1393995, 24047,  1369948,  0.017,
                  "covidhgi2020anaC2v4eur", "Diagnosis", "COVID: C2, EUR w/o 23andMe", 9999, TRUE, 1299010, 14134, 1284876, 0.01,
                  "covidhgi2020anaC2v4eurwoukbb", "Diagnosis", "COVID: C2, EUR w/o 23andMe, UKB", 9999, TRUE, 927103, 12829, 914274,  0.01,
                  "covidhgi2020anaD1v4", "Diagnosis", "COVID: D1", 9999, TRUE, 38932, 3204, 35728,  0.082,
                  ## Datafreeze v5
                  "covidhgi2020A2v5alleur", "Diagnosis", "COVID: A2, EUR", 9999, TRUE, 1388208, 5042, 1383166, 0.00363,
                  "covidhgi2020B2v5alleur", "Diagnosis", "COVID: B2, EUR", 9999, TRUE, 1886753, 9668, 1877085, 0.00512,
                  "covidhgi2020C2v5alleur", "Diagnosis", "COVID: C2, EUR", 9999, TRUE, 1683587, 38878, 1644709, 0.0231,
                  "covidhgi2020A2v5alleurLeaveUKBB", "Diagnosis", "COVID: A2, EUR w/o UKB", 9999, TRUE, 1059322, 4733, 1054589, 0.00447,
                  "covidhgi2020B2v5alleurLeaveUKBB", "Diagnosis", "COVID: B2, EUR w/o UKB", 9999, TRUE, 1556506, 7998, 1548508, 0.00514,
                  "covidhgi2020C2v5alleurLeaveUKBB", "Diagnosis", "COVID: C2, EUR w/o UKB", 9999, TRUE, 1348520, 32388, 1316132, 0.0240,
                  )

ieugwas <- read_csv(here::here("data", "raw", "ieugwas_201020.csv"))

samplesize <- bind_rows(samplesize,
          ieugwas %>%
            select(code = id, domain = category, trait, pmid, samplesize = sample_size, ncase, ncontrol) %>%
            mutate(logistic = ifelse(domain == "Binary", TRUE, FALSE),
                   prevelance = ncase/samplesize)
          )

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
