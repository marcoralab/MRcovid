---
title: "Mendelian Randomization Analysis"
author: "Dr. Shea Andrews"
date: "2021-08-19"
output:
  html_document:
    df_print: paged
    keep_md: true
    toc: true
    number_sections: false
    toc_depth: 4
    toc_float:
      collapsed: false
      smooth_scroll: false
params:
  rwd: NA
  exposure.code: NA
  Exposure: NA
  exposure.snps: NA
  outcome.code: NA
  Outcome: NA
  outcome.snps: NA
  proxy.snps: NA
  harmonized.dat: NA
  p.threshold: NA
  r2.threshold: NA
  kb.threshold: NA
  mrpresso_global: NA
  Rlib: NA
  mrpresso_global_wo_outliers: NA
  power: NA
  out: NA
editor_options:
  chunk_output_type: console
---



```r
knitr::opts_chunk$set(echo = TRUE)
knitr::opts_knit$set(root.dir = params$rwd)

if(any(grepl("conda", .libPaths(), fixed = TRUE))){
  message("Setting libPaths")
  message(params$rwd)
  df = .libPaths()
  conda_i = which(grepl("conda", df, fixed = TRUE))
  .libPaths(c(df[conda_i], df[-conda_i]))
}
```

```
## Setting libPaths
```

```
## /sc/arion/projects/LOAD/harern01/projects/MRcovid
```

```r
.libPaths(c(.libPaths(), params$Rlib))
## Load Packages
library(tidyr)   ## For data wrangling
library(dplyr)
```

```
## Warning: package 'dplyr' was built under R version 4.0.5
```

```
## 
## Attaching package: 'dplyr'
```

```
## The following objects are masked from 'package:stats':
## 
##     filter, lag
```

```
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```r
library(readr)
```

```
## Warning: package 'readr' was built under R version 4.0.5
```

```r
library(TwoSampleMR) ## For conducting MR https://mrcieu.github.io/TwoSampleMR/
```

```
## TwoSampleMR version 0.5.6 
## [>] New: Option to use non-European LD reference panels for clumping etc
## [>] Some studies temporarily quarantined to verify effect allele
## [>] See news(package='TwoSampleMR') and https://gwas.mrcieu.ac.uk for further details
```

```r
library(RadialMR)    ## For Radial MR plots
library(ggplot2)     ## For plotting
```

```
## Warning: package 'ggplot2' was built under R version 4.0.5
```

```r
library(here)
```

```
## here() starts at /sc/arion/projects/LOAD/harern01/projects/MRcovid
```

```r
source(here("workflow", "scripts", "miscfunctions.R"), chdir = TRUE)

message(params)
```

```
## NA/sc/arion/projects/LOAD/harern01/projects/MRcovid/hpc/users/harern01/.Rlibdata/MRcovideurv6/Nicolas2018als/Nicolas2018als_5e-8_SNPs.txtdata/MRcovideurv6/Nicolas2018als/covidhgi2020B2v6alleur/Nicolas2018als_5e-8_covidhgi2020B2v6alleur_SNPs.txtdata/MRcovideurv6/Nicolas2018als/covidhgi2020B2v6alleur/Nicolas2018als_5e-8_covidhgi2020B2v6alleur_MatchedProxys.csvdata/MRcovideurv6/Nicolas2018als/covidhgi2020B2v6alleur/Nicolas2018als_5e-8_covidhgi2020B2v6alleur_mrpresso_MRdat.csvdata/MRcovideurv6/Nicolas2018als/covidhgi2020B2v6alleur/Nicolas2018als_5e-8_covidhgi2020B2v6alleur_mrpresso_global.txtdata/MRcovideurv6/Nicolas2018als/covidhgi2020B2v6alleur/Nicolas2018als_5e-8_covidhgi2020B2v6alleur_MR_power.txtcovidhgi2020B2v6alleurNicolas2018alsCOVID: B2ALS5e-80.00110000results/MRcovideurv6/Nicolas2018als/covidhgi2020B2v6alleur/Nicolas2018als_5e-8_covidhgi2020B2v6alleur
```



## Instrumental Variables
**SNP Inclusion:** SNPS associated with at a p-value threshold of p < 5e-8 were included in this analysis.
<br>

**LD Clumping:** For standard two sample MR it is important to ensure that the instruments for the exposure are independent. LD clumping was performed in PLINK using the EUR samples from the 1000 Genomes Project to estimate LD between SNPs, and, amongst SNPs that have an LD above a given threshold, retain only the SNP with the lowest p-value. A clumping window of 10^{4}, r2 of 0.001 and significance level of 1 was used for the index and secondary SNPs.
<br>

**Proxy SNPs:** Where SNPs were not available in the outcome GWAS, the EUR thousand genomes was queried to identify potential proxy SNPs that are in linkage disequilibrium (r2 > 0.8) of the missing SNP.
<br>

### Exposure: ALS
`#r exposure.blurb`
<br>

**Table 1:** Independent SNPs associated with ALS
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["CHROM"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["REF"],"name":[4],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[5],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[12],"type":["chr"],"align":["left"]}],"data":[{"1":"rs10463311","2":"5","3":"150410835","4":"C","5":"T","6":"0.7441","7":"-0.0854","8":"0.0156","9":"-5.474359","10":"3.999e-08","11":"80610","12":"ALS"},{"1":"rs3849943","2":"9","3":"27543382","4":"C","5":"T","6":"0.7518","7":"-0.1764","8":"0.0155","9":"-11.380645","10":"3.770e-30","11":"80610","12":"ALS"},{"1":"rs142321490","2":"12","3":"58676132","4":"G","5":"C","6":"0.0183","7":"0.3172","8":"0.0513","9":"6.183236","10":"6.147e-10","11":"80610","12":"ALS"},{"1":"rs74654358","2":"12","3":"64881967","4":"G","5":"A","6":"0.0473","7":"0.1976","8":"0.0337","9":"5.863501","10":"4.658e-09","11":"80610","12":"ALS"},{"1":"rs12973192","2":"19","3":"17753239","4":"C","5":"G","6":"0.3247","7":"0.1205","8":"0.0153","9":"7.875820","10":"3.916e-15","11":"80610","12":"ALS"},{"1":"rs75087725","2":"21","3":"45753117","4":"C","5":"A","6":"0.0153","7":"0.5145","8":"0.0672","9":"7.656250","10":"1.848e-14","11":"80610","12":"ALS"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

### Outcome: COVID: B2
`#r outcome.blurb`
<br>

**Table 2:** SNPs associated with ALS avaliable in COVID: B2
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["CHROM"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["REF"],"name":[4],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[5],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[12],"type":["chr"],"align":["left"]}],"data":[{"1":"rs10463311","2":"5","3":"150410835","4":"C","5":"T","6":"0.74890","7":"-0.0213860","8":"0.013699","9":"-1.5611358","10":"0.11849","11":"2509514","12":"COVID_B2__EUR"},{"1":"rs3849943","2":"9","3":"27543382","4":"C","5":"T","6":"0.77150","7":"-0.0061020","8":"0.013841","9":"-0.4408641","10":"0.65930","11":"2235103","12":"COVID_B2__EUR"},{"1":"rs142321490","2":"12","3":"58676132","4":"G","5":"C","6":"0.01918","7":"0.0234140","8":"0.054777","9":"0.4274422","10":"0.66905","11":"2358318","12":"COVID_B2__EUR"},{"1":"rs74654358","2":"12","3":"64881967","4":"G","5":"A","6":"0.04377","7":"0.0441020","8":"0.030310","9":"1.4550313","10":"0.14566","11":"2508764","12":"COVID_B2__EUR"},{"1":"rs12973192","2":"19","3":"17753239","4":"C","5":"G","6":"0.34440","7":"-0.0028118","8":"0.013475","9":"-0.2086679","10":"0.83471","11":"2498568","12":"COVID_B2__EUR"},{"1":"rs75087725","2":"21","3":"45753117","4":"C","5":"A","6":"0.01115","7":"0.0284430","8":"0.064072","9":"0.4439225","10":"0.65710","11":"2493697","12":"COVID_B2__EUR"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

**Table 3:** Proxy SNPs for COVID: B2
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["proxy.outcome"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["target_snp"],"name":[2],"type":["lgl"],"align":["right"]},{"label":["proxy_snp"],"name":[3],"type":["lgl"],"align":["right"]},{"label":["ld.r2"],"name":[4],"type":["lgl"],"align":["right"]},{"label":["Dprime"],"name":[5],"type":["lgl"],"align":["right"]},{"label":["ref.proxy"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["alt.proxy"],"name":[7],"type":["lgl"],"align":["right"]},{"label":["CHROM"],"name":[8],"type":["lgl"],"align":["right"]},{"label":["POS"],"name":[9],"type":["lgl"],"align":["right"]},{"label":["ALT.proxy"],"name":[10],"type":["lgl"],"align":["right"]},{"label":["REF.proxy"],"name":[11],"type":["lgl"],"align":["right"]},{"label":["AF"],"name":[12],"type":["lgl"],"align":["right"]},{"label":["BETA"],"name":[13],"type":["lgl"],"align":["right"]},{"label":["SE"],"name":[14],"type":["lgl"],"align":["right"]},{"label":["P"],"name":[15],"type":["lgl"],"align":["right"]},{"label":["N"],"name":[16],"type":["lgl"],"align":["right"]},{"label":["ref"],"name":[17],"type":["lgl"],"align":["right"]},{"label":["alt"],"name":[18],"type":["lgl"],"align":["right"]},{"label":["ALT"],"name":[19],"type":["lgl"],"align":["right"]},{"label":["REF"],"name":[20],"type":["lgl"],"align":["right"]},{"label":["PHASE"],"name":[21],"type":["lgl"],"align":["right"]}],"data":[{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA","13":"NA","14":"NA","15":"NA","16":"NA","17":"NA","18":"NA","19":"NA","20":"NA","21":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

## Data harmonization
Harmonize the exposure and outcome datasets so that the effect of a SNP on the exposure and the effect of that SNP on the outcome correspond to the same allele. The harmonise_data function from the TwoSampleMR package can be used to perform the harmonization step, by default it try's to infer the forward strand alleles using allele frequency information.
<br>

**Table 4:** Harmonized ALS and COVID: B2 datasets
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["effect_allele.exposure"],"name":[2],"type":["chr"],"align":["left"]},{"label":["other_allele.exposure"],"name":[3],"type":["chr"],"align":["left"]},{"label":["effect_allele.outcome"],"name":[4],"type":["chr"],"align":["left"]},{"label":["other_allele.outcome"],"name":[5],"type":["chr"],"align":["left"]},{"label":["beta.exposure"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["beta.outcome"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["eaf.exposure"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["eaf.outcome"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["remove"],"name":[10],"type":["lgl"],"align":["right"]},{"label":["palindromic"],"name":[11],"type":["lgl"],"align":["right"]},{"label":["ambiguous"],"name":[12],"type":["lgl"],"align":["right"]},{"label":["id.outcome"],"name":[13],"type":["chr"],"align":["left"]},{"label":["chr.outcome"],"name":[14],"type":["dbl"],"align":["right"]},{"label":["pos.outcome"],"name":[15],"type":["dbl"],"align":["right"]},{"label":["se.outcome"],"name":[16],"type":["dbl"],"align":["right"]},{"label":["z.outcome"],"name":[17],"type":["dbl"],"align":["right"]},{"label":["pval.outcome"],"name":[18],"type":["dbl"],"align":["right"]},{"label":["samplesize.outcome"],"name":[19],"type":["dbl"],"align":["right"]},{"label":["outcome"],"name":[20],"type":["chr"],"align":["left"]},{"label":["mr_keep.outcome"],"name":[21],"type":["lgl"],"align":["right"]},{"label":["pval_origin.outcome"],"name":[22],"type":["chr"],"align":["left"]},{"label":["chr.exposure"],"name":[23],"type":["dbl"],"align":["right"]},{"label":["pos.exposure"],"name":[24],"type":["dbl"],"align":["right"]},{"label":["se.exposure"],"name":[25],"type":["dbl"],"align":["right"]},{"label":["z.exposure"],"name":[26],"type":["dbl"],"align":["right"]},{"label":["pval.exposure"],"name":[27],"type":["dbl"],"align":["right"]},{"label":["samplesize.exposure"],"name":[28],"type":["dbl"],"align":["right"]},{"label":["exposure"],"name":[29],"type":["chr"],"align":["left"]},{"label":["mr_keep.exposure"],"name":[30],"type":["lgl"],"align":["right"]},{"label":["pval_origin.exposure"],"name":[31],"type":["chr"],"align":["left"]},{"label":["id.exposure"],"name":[32],"type":["chr"],"align":["left"]},{"label":["action"],"name":[33],"type":["dbl"],"align":["right"]},{"label":["mr_keep"],"name":[34],"type":["lgl"],"align":["right"]},{"label":["pt"],"name":[35],"type":["dbl"],"align":["right"]},{"label":["pleitropy_keep"],"name":[36],"type":["lgl"],"align":["right"]},{"label":["mrpresso_RSSobs"],"name":[37],"type":["lgl"],"align":["right"]},{"label":["mrpresso_pval"],"name":[38],"type":["lgl"],"align":["right"]},{"label":["mrpresso_keep"],"name":[39],"type":["lgl"],"align":["right"]}],"data":[{"1":"rs10463311","2":"T","3":"C","4":"T","5":"C","6":"-0.0854","7":"-0.0213860","8":"0.7441","9":"0.74890","10":"FALSE","11":"FALSE","12":"FALSE","13":"3ixF7z","14":"5","15":"150410835","16":"0.013699","17":"-1.5611358","18":"0.11849","19":"2509514","20":"covidhgi2020B2v6alleur","21":"TRUE","22":"reported","23":"5","24":"150410835","25":"0.0156","26":"-5.474359","27":"3.999e-08","28":"80610","29":"Nicolas2018als","30":"TRUE","31":"reported","32":"EEHjmi","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs12973192","2":"G","3":"C","4":"G","5":"C","6":"0.1205","7":"-0.0028118","8":"0.3247","9":"0.34440","10":"FALSE","11":"TRUE","12":"FALSE","13":"3ixF7z","14":"19","15":"17753239","16":"0.013475","17":"-0.2086679","18":"0.83471","19":"2498568","20":"covidhgi2020B2v6alleur","21":"TRUE","22":"reported","23":"19","24":"17753239","25":"0.0153","26":"7.875820","27":"3.916e-15","28":"80610","29":"Nicolas2018als","30":"TRUE","31":"reported","32":"EEHjmi","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs142321490","2":"C","3":"G","4":"C","5":"G","6":"0.3172","7":"0.0234140","8":"0.0183","9":"0.01918","10":"FALSE","11":"TRUE","12":"FALSE","13":"3ixF7z","14":"12","15":"58676132","16":"0.054777","17":"0.4274422","18":"0.66905","19":"2358318","20":"covidhgi2020B2v6alleur","21":"TRUE","22":"reported","23":"12","24":"58676132","25":"0.0513","26":"6.183236","27":"6.147e-10","28":"80610","29":"Nicolas2018als","30":"TRUE","31":"reported","32":"EEHjmi","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs3849943","2":"T","3":"C","4":"T","5":"C","6":"-0.1764","7":"-0.0061020","8":"0.7518","9":"0.77150","10":"FALSE","11":"FALSE","12":"FALSE","13":"3ixF7z","14":"9","15":"27543382","16":"0.013841","17":"-0.4408641","18":"0.65930","19":"2235103","20":"covidhgi2020B2v6alleur","21":"TRUE","22":"reported","23":"9","24":"27543382","25":"0.0155","26":"-11.380645","27":"3.770e-30","28":"80610","29":"Nicolas2018als","30":"TRUE","31":"reported","32":"EEHjmi","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs74654358","2":"A","3":"G","4":"A","5":"G","6":"0.1976","7":"0.0441020","8":"0.0473","9":"0.04377","10":"FALSE","11":"FALSE","12":"FALSE","13":"3ixF7z","14":"12","15":"64881967","16":"0.030310","17":"1.4550313","18":"0.14566","19":"2508764","20":"covidhgi2020B2v6alleur","21":"TRUE","22":"reported","23":"12","24":"64881967","25":"0.0337","26":"5.863501","27":"4.658e-09","28":"80610","29":"Nicolas2018als","30":"TRUE","31":"reported","32":"EEHjmi","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs75087725","2":"A","3":"C","4":"A","5":"C","6":"0.5145","7":"0.0284430","8":"0.0153","9":"0.01115","10":"FALSE","11":"FALSE","12":"FALSE","13":"3ixF7z","14":"21","15":"45753117","16":"0.064072","17":"0.4439225","18":"0.65710","19":"2493697","20":"covidhgi2020B2v6alleur","21":"TRUE","22":"reported","23":"21","24":"45753117","25":"0.0672","26":"7.656250","27":"1.848e-14","28":"80610","29":"Nicolas2018als","30":"TRUE","31":"reported","32":"EEHjmi","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

SNPs that genome-wide significant in the outcome GWAS are likely pleitorpic and should be removed from analysis. Additionaly remove variants within the APOE locus by exclude variants 1MB either side of APOE e4 (rs429358 = 19:45411941, GRCh37.p13)
<br>


**Table 5:** SNPs that were genome-wide significant in the COVID: B2 GWAS
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["chr.outcome"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["pos.outcome"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["pval.exposure"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["pval.outcome"],"name":[5],"type":["dbl"],"align":["right"]}],"data":[],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>


## Instrument Strength
To ensure that the first assumption of MR is not violated (Non-zero effect assumption), the genetic variants selected should be robustly associated with the exposure. Weak instruments, where the variance in the exposure explained by the the instruments is a small portion of the total variance, may result in poor precission and accuracy of the causal effect estiamte. The strength of an instrument can be evaluated using the F statistic, if F is less than 10, this is an indication of weak instrument.


```
## 
## -- Column specification --------------------------------------------------------
## cols(
##   .default = col_double(),
##   exposure = col_character(),
##   outcome = col_character(),
##   method = col_character(),
##   outliers_removed = col_logical(),
##   logistic = col_logical(),
##   beta = col_logical()
## )
## i Use `spec()` for the full column specifications.
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["outliers_removed"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["pve.exposure"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["F"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["Alpha"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["NCP"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["Power"],"name":[6],"type":["dbl"],"align":["right"]}],"data":[{"1":"FALSE","2":"0.004398966","3":"59.35608","4":"0.05","5":"3.719625","6":"0.4875532"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

The I2_GX statistic can be used to quantify the strength of the NOME violation for MR-Egger regression and should be used to evalute potential bias in the MR-Egger causal estimate, with values less then 90% indicating that causal estimated should interpreted with caution due to regression diluation.

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["outliers_removed"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["Isq_gx"],"name":[2],"type":["dbl"],"align":["right"]}],"data":[{"1":"FALSE","2":"0.8235029"},{"1":"TRUE","2":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>


## MR Results
To obtain an overall estimate of causal effect, the SNP-exposure and SNP-outcome coefficients were combined in 1) a fixed-effects meta-analysis using an inverse-variance weighted approach (IVW); 2) a Weighted Median approach; 3) Weighted Mode approach and 4) Egger Regression.


[**IVW**](https://doi.org/10.1002/gepi.21758) is equivalent to a weighted regression of the SNP-outcome coefficients on the SNP-exposure coefficients with the intercept constrained to zero. This method assumes that all variants are valid instrumental variables based on the Mendelian randomization assumptions. The causal estimate of the IVW analysis expresses the causal increase in the outcome (or log odds of the outcome for a binary outcome) per unit change in the exposure. [**Weighted median MR**](https://doi.org/10.1002/gepi.21965) allows for 50% of the instrumental variables to be invalid. [**MR-Egger regression**](https://doi.org/10.1093/ije/dyw220) allows all the instrumental variables to be subject to direct effects (i.e. horizontal pleiotropy), with the intercept representing bias in the causal estimate due to pleiotropy and the slope representing the causal estimate. [**Weighted Mode**](https://doi.org/10.1093/ije/dyx102) gives consistent estimates as the sample size increases if a plurality (or weighted plurality) of the genetic variants are valid instruments.
<br>



Table 6 presents the MR causal estimates of genetically predicted ALS on COVID: B2.
<br>

**Table 6** MR causaul estimates for ALS on COVID: B2
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["method"],"name":[5],"type":["chr"],"align":["left"]},{"label":["nsnp"],"name":[6],"type":["int"],"align":["right"]},{"label":["b"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"EEHjmi","2":"3ixF7z","3":"covidhgi2020B2v6alleur","4":"Nicolas2018als","5":"Inverse variance weighted (fixed effects)","6":"6","7":"0.06878207","8":"0.04869221","9":"0.1577767"},{"1":"EEHjmi","2":"3ixF7z","3":"covidhgi2020B2v6alleur","4":"Nicolas2018als","5":"Weighted median","6":"6","7":"0.04315355","8":"0.06100967","9":"0.4793657"},{"1":"EEHjmi","2":"3ixF7z","3":"covidhgi2020B2v6alleur","4":"Nicolas2018als","5":"Weighted mode","6":"6","7":"0.03265673","8":"0.06928681","9":"0.6572561"},{"1":"EEHjmi","2":"3ixF7z","3":"covidhgi2020B2v6alleur","4":"Nicolas2018als","5":"MR Egger","6":"6","7":"0.02640514","8":"0.11693311","9":"0.8324149"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Figure 1 illustrates the SNP-specific associations with ALS versus the association in COVID: B2 and the corresponding MR estimates.
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/harern01/projects/MRcovid/results/MRcovideurv6/Nicolas2018als/covidhgi2020B2v6alleur/Nicolas2018als_5e-8_covidhgi2020B2v6alleur_MR_Analaysis_files/figure-html/scatter_plot-1.png" alt="Fig. 1: Scatterplot of SNP effects for the association of the Exposure on the Outcome"  />
<p class="caption">Fig. 1: Scatterplot of SNP effects for the association of the Exposure on the Outcome</p>
</div>
<br>


## Pleiotropy
A Cochrans Q heterogeneity test can be used to formaly assesse for the presence of heterogenity (Table 7), with excessive heterogeneity indicating that there is a meaningful violation of at least one of the MR assumptions.
these assumptions..
<br>

**Table 7:** Heterogenity Tests
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["method"],"name":[5],"type":["chr"],"align":["left"]},{"label":["Q"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["Q_df"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["Q_pval"],"name":[8],"type":["dbl"],"align":["right"]}],"data":[{"1":"EEHjmi","2":"3ixF7z","3":"covidhgi2020B2v6alleur","4":"Nicolas2018als","5":"MR Egger","6":"3.017645","7":"4","8":"0.5548769"},{"1":"EEHjmi","2":"3ixF7z","3":"covidhgi2020B2v6alleur","4":"Nicolas2018als","5":"Inverse variance weighted","6":"3.176532","7":"5","8":"0.6727910"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Figure 2 shows a funnel plot displaying the MR estimates of individual genetic variants against their precession. Aysmmetry in the funnel plot may arrise due to some genetic variants having unusally strong effects on the outcome, which is indicative of directional pleiotropy.
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/harern01/projects/MRcovid/results/MRcovideurv6/Nicolas2018als/covidhgi2020B2v6alleur/Nicolas2018als_5e-8_covidhgi2020B2v6alleur_MR_Analaysis_files/figure-html/funnel_plot-1.png" alt="Fig. 2: Funnel plot of the MR causal estimates against their precession"  />
<p class="caption">Fig. 2: Funnel plot of the MR causal estimates against their precession</p>
</div>
<br>

Figure 3 shows a [Radial Plots](https://github.com/WSpiller/RadialMR) can be used to visualize influential data points with large contributions to Cochran's Q Statistic that may bias causal effect estimates.




```
## [1] "No significant Outliers"
```

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/harern01/projects/MRcovid/results/MRcovideurv6/Nicolas2018als/covidhgi2020B2v6alleur/Nicolas2018als_5e-8_covidhgi2020B2v6alleur_MR_Analaysis_files/figure-html/Radial_Plot-1.png" alt="Fig. 4: Radial Plot showing influential data points using Radial IVW"  />
<p class="caption">Fig. 4: Radial Plot showing influential data points using Radial IVW</p>
</div>
<br>

The intercept of the MR-Egger Regression model captures the average pleitropic affect across all genetic variants (Table 8).
<br>

**Table 8:** MR Egger test for directional pleitropy
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["egger_intercept"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[7],"type":["dbl"],"align":["right"]}],"data":[{"1":"EEHjmi","2":"3ixF7z","3":"covidhgi2020B2v6alleur","4":"Nicolas2018als","5":"0.007190734","6":"0.01803971","7":"0.7105455"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Pleiotropy was also assesed using Mendelian Randomization Pleiotropy RESidual Sum and Outlier [(MR-PRESSO)](https://doi.org/10.1038/s41588-018-0099-7), that allows for the evlation of evaluation of horizontal pleiotropy in a standared MR model (Table 9). MR-PRESSO performs a global test for detection of horizontal pleiotropy and correction of pleiotropy via outlier removal (Table 10).
<br>

**Table 9:** MR-PRESSO Global Test for pleitropy
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["pt"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["outliers_removed"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["n_outliers"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["RSSobs"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"EEHjmi","2":"3ixF7z","3":"covidhgi2020B2v6alleur","4":"Nicolas2018als","5":"5e-08","6":"FALSE","7":"0","8":"4.361575","9":"0.7051"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>


**Table 10:** MR Estimates after MR-PRESSO outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["method"],"name":[5],"type":["chr"],"align":["left"]},{"label":["nsnp"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["b"],"name":[7],"type":["lgl"],"align":["right"]},{"label":["se"],"name":[8],"type":["lgl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["lgl"],"align":["right"]}],"data":[{"1":"EEHjmi","2":"3ixF7z","3":"covidhgi2020B2v6alleur","4":"Nicolas2018als","5":"mrpresso","6":"NA","7":"NA","8":"NA","9":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/harern01/projects/MRcovid/results/MRcovideurv6/Nicolas2018als/covidhgi2020B2v6alleur/Nicolas2018als_5e-8_covidhgi2020B2v6alleur_MR_Analaysis_files/figure-html/scatter_plot_outlier-1.png" alt="Fig. 5: Scatterplot of SNP effects for the association of the Exposure on the Outcome after outlier removal"  />
<p class="caption">Fig. 5: Scatterplot of SNP effects for the association of the Exposure on the Outcome after outlier removal</p>
</div>
<br>

**Table 11:** Heterogenity Tests after outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["method"],"name":[5],"type":["chr"],"align":["left"]},{"label":["Q"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["Q_df"],"name":[7],"type":["lgl"],"align":["right"]},{"label":["Q_pval"],"name":[8],"type":["lgl"],"align":["right"]}],"data":[{"1":"EEHjmi","2":"3ixF7z","3":"covidhgi2020B2v6alleur","4":"Nicolas2018als","5":"mrpresso","6":"NA","7":"NA","8":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

**Table 12:** MR Egger test for directional pleitropy after outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["method"],"name":[5],"type":["chr"],"align":["left"]},{"label":["egger_intercept"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["se"],"name":[7],"type":["lgl"],"align":["right"]},{"label":["pval"],"name":[8],"type":["lgl"],"align":["right"]}],"data":[{"1":"EEHjmi","2":"3ixF7z","3":"covidhgi2020B2v6alleur","4":"Nicolas2018als","5":"mrpresso","6":"NA","7":"NA","8":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>
