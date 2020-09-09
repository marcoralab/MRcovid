## ================================================================================ ##
##                                Misc functions                                    ##

outcomes = c("Lambert2013load", "Kunkle2019load", "Huang2017aaos",
             "Deming2017ab42", "Deming2017ptau", "Deming2017tau",
             "Hilbar2017hipv", "Hilbar2015hipv", "Grasby2020surfarea", "Grasby2020thickness",
             "Beecham2014npany", "Beecham2014braak4", "Beecham2014vbiany", "Beecham2014status",
             "Chauhan2019bi")
## Exposures to include in the results
exposures = c("Yengo2018bmi", "Xue2018diab",
              "Niarchou2020meat", "Niarchou2020fish",
              "Wells2019hdiff","Willer2013hdl", "Willer2013ldl", "Willer2013tc",
              "Willer2013tg", "Dashti2019slepdur",  "Day2018sociso",
              "Klimentidis2018mvpa", "Evangelou2018dbp", "Evangelou2018sbp",
              "Evangelou2018pp", "Liu2019drnkwk23andMe", "Liu2019smkcpd23andMe", "Liu2019smkint23andMe",
              "Jansen2018insomnia23andMe", "Howard2019dep23andMe", "SanchezRoige2019auditt23andMe",
              "Lee2018education23andMe")

## Sample Sizes
samplesize = tribble(~code, ~domain, ~trait, ~pmid, ~logistic, ~samplesize, ~ncase, ~ncontrol, ~prevelance,
                  "Lambert2013load", "Diagnosis", "LOAD", 0820047, TRUE, 63926, 21982, 41944, 0.31,
                  "Kunkle2019load", "Diagnosis", "LOAD", 24162737, TRUE, 54162, 17008, 37154, 0.31,
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
                  "Xue2018diab", "Health", "Type 2 Diabetes", 30054458, TRUE, 659316, 62892, 596424, 0.085,
                  "Niarchou2020meat", "Lifestyle", "Meat diet", 32066663, FALSE, 335576, NA, NA, NA,
                  "Niarchou2020fish", "Lifestyle", "Fish and Plant diet", 32066663, FALSE, 335576, NA, NA, NA,
                  "Wells2019hdiff", "Health", "Hearing Difficulties", 31564434, FALSE, 250389, 87056, 163333, 0.35,
                  "Willer2013hdl", "Health", "High-density lipoproteins", 24097068, FALSE, 188577, NA, NA, NA,
                  "Willer2013ldl", "Health", "Low-density lipoproteins", 24097068, FALSE, 188577, NA, NA, NA,
                  "Willer2013tc", "Health", "Total Cholesterol", 24097068, FALSE, 188577, NA, NA, NA,
                  "Willer2013tg", "Health", "Triglycerides", 24097068, FALSE, 188577, NA, NA, NA,
                  "Dashti2019slepdur",  "Psychosocial", "Sleep Duration", 30846698, FALSE, 446118, NA, NA, NA,
                  "Campos2020snor",  "Psychosocial", "Snoring", 32060260, FALSE, 408317, NA, NA, NA,
                  "Day2018sociso", "Psychosocial", "Social Isolation", 29970889, FALSE, 452302, NA, NA, NA,
                  "Klimentidis2018mvpa", "Lifestyle", "Moderate-to-vigorous PA", 29899525, FALSE, 377234, NA, NA, NA,
                  "Evangelou2018dbp", "Health", "Diastolic Blood Pressure", 30224653, FALSE, 757601, NA, NA, NA,
                  "Evangelou2018sbp", "Health", "Systolic Blood Pressure", 30224653, FALSE, 757601, NA, NA, NA,
                  "Evangelou2018pp", "Health", "Pulse Pressure", 30224653, FALSE, 757601, NA, NA, NA,
                  "Liu2019drnkwk23andMe", "Lifestyle", "Alcohol Consumption", 30643251, FALSE, 941280, NA, NA, NA,
                  "Liu2019drnkwk", "Lifestyle", "Alcohol Consumption", 30643251, FALSE, 537349,  NA, NA, NA,
                  "Liu2019smkcpd23andMe", "Lifestyle", "Cigarettes per Day", 30643251, FALSE, 337334, NA, NA, NA,
                  "Liu2019smkcpd", "Lifestyle", "Cigarettes per Day", 30643251, FALSE, 263954, NA, NA, NA,
                  "Liu2019smkint23andMe", "Lifestyle", "Smoking Initiation", 30643251, TRUE, 1232091, 557337, 674754, 0.45,
                  "Liu2019smkint", "Lifestyle", "Smoking Initiation", 30643251, TRUE, 632802, 311628, 321174, 0.45,
                  "Jansen2018insomnia23andMe", "Psychosocial", "Insomnia Symptoms", 30804565, TRUE, 1331010, 397972, 933038, 0.29,
                  "Jansen2018insom", "Psychosocial", "Insomnia Symptoms", 30804565, TRUE, 386533, 108229, 278304, 0.28,
                  "Howard2019dep23andMe", "Psychosocial", "Depression", 30718901, TRUE, 807553, 246363, 561190, 0.32,
                  "Howard2018dep", "Psychosocial", "Depression", 30718901, TRUE, 322580, 113769, 208811, 0.35,
                  "SanchezRoige2019auditt23andMe", "Lifestyle", "AUDIT", 30336701, FALSE, 141932, NA, NA, NA,
                  "Lee2018education23andMe", "Psychosocial", "Educational Attainment", 30038396, FALSE, 1131881, NA, NA, NA,
                  "Lee2018educ", "Psychosocial", "Educational Attainment", 30038396, FALSE, 775120, NA, NA, NA,
                  "Chauhan2019bi", "Neuropathology", "Brain Infarcts", 30651383, TRUE, 21682, 3726, 17956, 0.2,
                  "Revez2020vit250hd", "Health", "25 hydroxyvitamin D", 32242144, FALSE, 417580, NA, NA, NA,
                  "covidhgi2020anaA2v2", "Diagnosis", "very severe respiratory confirmed covid vs. population", 9999, TRUE, 329927, 536, 329391, 0.00162,
                  "covidhgi2020anaB1v2", "Diagnosis", "hospitalized covid vs. not hospitalized covid", 9999, TRUE, 2956, 928, 2028, 0.314,
                  "covidhgi2020anaB2v2", "Diagnosis", "hospitalized covid vs. population", 9999, TRUE, 900687, 3199, 897488, 0.00355,
                  "covidhgi2020anaC1v2", "Diagnosis", "covid vs. lab/self-reported negative", 9999, TRUE, 40157, 3523, 36634, 0.0877,
                  "covidhgi2020anaC2v2", "Diagnosis", "covid vs. population", 9999, TRUE, 1079768, 6696, 1073072, 0.00620,
                  "covidhgi2020anaD1v2", "Diagnosis", "predicted covid from self-reported symptoms vs. predicted or self-reported non-covid", 9999, TRUE, 31039, 1865, 29174, 0.0601,
                  "covidhgi2020anaA2v2woUKBB", "Diagnosis", "very severe respiratory confirmed covid vs. population wo/ UKBB", 9999, TRUE, 4422, 428, 3994, 0.096,
                  "covidhgi2020anaB1v2woUKBB", "Diagnosis", "hospitalized covid vs. not hospitalized covid wo/ UKBB", 9999, TRUE,  1766, 144, 1622, 0.081,
                  "covidhgi2020anaB2v2woUKBB", "Diagnosis", "hospitalized covid vs. population wo/ UKBB", 9999, TRUE,  480156, 2415, 477741, 0.005,
                  "covidhgi2020anaC1v2woUKBB", "Diagnosis", "covid vs. lab/self-reported negative", 9999, TRUE,  33580, 2213, 31367, 0.065,
                  "covidhgi2020anaC2v2woUKBB", "Diagnosis", "covid vs. population wo/ UKBB", 9999, TRUE,  643725, 5386, 638339, 0.0083
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
