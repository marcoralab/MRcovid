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
## NA/sc/arion/projects/LOAD/harern01/projects/MRcovidNULLdata/MRcovideurv6/Kunkle2019load/Kunkle2019load_5e-8_SNPs.txtdata/MRcovideurv6/Kunkle2019load/covidhgi2020C2v6alleur/Kunkle2019load_5e-8_covidhgi2020C2v6alleur_SNPs.txtdata/MRcovideurv6/Kunkle2019load/covidhgi2020C2v6alleur/Kunkle2019load_5e-8_covidhgi2020C2v6alleur_MatchedProxys.csvdata/MRcovideurv6/Kunkle2019load/covidhgi2020C2v6alleur/Kunkle2019load_5e-8_covidhgi2020C2v6alleur_mrpresso_MRdat.csvdata/MRcovideurv6/Kunkle2019load/covidhgi2020C2v6alleur/Kunkle2019load_5e-8_covidhgi2020C2v6alleur_mrpresso_global.txtdata/MRcovideurv6/Kunkle2019load/covidhgi2020C2v6alleur/Kunkle2019load_5e-8_covidhgi2020C2v6alleur_MR_power.txtcovidhgi2020C2v6alleurKunkle2019loadCOVID: C2LOAD5e-80.00110000results/MRcovideurv6/Kunkle2019load/covidhgi2020C2v6alleur/Kunkle2019load_5e-8_covidhgi2020C2v6alleur
```



## Instrumental Variables
**SNP Inclusion:** SNPS associated with at a p-value threshold of p < 5e-8 were included in this analysis.
<br>

**LD Clumping:** For standard two sample MR it is important to ensure that the instruments for the exposure are independent. LD clumping was performed in PLINK using the EUR samples from the 1000 Genomes Project to estimate LD between SNPs, and, amongst SNPs that have an LD above a given threshold, retain only the SNP with the lowest p-value. A clumping window of 10^{4}, r2 of 0.001 and significance level of 1 was used for the index and secondary SNPs.
<br>

**Proxy SNPs:** Where SNPs were not available in the outcome GWAS, the EUR thousand genomes was queried to identify potential proxy SNPs that are in linkage disequilibrium (r2 > 0.8) of the missing SNP.
<br>

### Exposure: LOAD
`#r exposure.blurb`
<br>

**Table 1:** Independent SNPs associated with LOAD
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["CHROM"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["REF"],"name":[4],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[5],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[12],"type":["chr"],"align":["left"]}],"data":[{"1":"rs679515","2":"1","3":"207750568","4":"T","5":"C","6":"0.8126","7":"-0.1508","8":"0.0183","9":"-8.240440","10":"1.555000e-16","11":"63926","12":"LOAD"},{"1":"rs6733839","2":"2","3":"127892810","4":"C","5":"T","6":"0.4067","7":"0.1693","8":"0.0154","9":"10.993506","10":"4.022000e-28","11":"63926","12":"LOAD"},{"1":"rs34665982","2":"6","3":"32560306","4":"T","5":"C","6":"0.5213","7":"-0.0967","8":"0.0166","9":"-5.825300","10":"5.798000e-09","11":"63926","12":"LOAD"},{"1":"rs114812713","2":"6","3":"41034000","4":"G","5":"C","6":"0.0301","7":"0.2980","8":"0.0431","9":"6.914153","10":"4.467000e-12","11":"63926","12":"LOAD"},{"1":"rs1385742","2":"6","3":"47595155","4":"A","5":"T","6":"0.6344","7":"-0.0876","8":"0.0157","9":"-5.579620","10":"2.232000e-08","11":"63926","12":"LOAD"},{"1":"rs11767557","2":"7","3":"143109139","4":"T","5":"C","6":"0.1968","7":"-0.1028","8":"0.0182","9":"-5.648350","10":"1.561000e-08","11":"63926","12":"LOAD"},{"1":"rs73223431","2":"8","3":"27219987","4":"C","5":"T","6":"0.3669","7":"0.0936","8":"0.0153","9":"6.117647","10":"8.342000e-10","11":"63926","12":"LOAD"},{"1":"rs867230","2":"8","3":"27468503","4":"C","5":"A","6":"0.6029","7":"0.1333","8":"0.0158","9":"8.436709","10":"3.492000e-17","11":"63926","12":"LOAD"},{"1":"rs12416487","2":"10","3":"11721057","4":"A","5":"T","6":"0.6519","7":"0.0850","8":"0.0154","9":"5.519480","10":"3.417000e-08","11":"63926","12":"LOAD"},{"1":"rs3740688","2":"11","3":"47380340","4":"G","5":"T","6":"0.5524","7":"0.0935","8":"0.0144","9":"6.493056","10":"9.702000e-11","11":"63926","12":"LOAD"},{"1":"rs1582763","2":"11","3":"60021948","4":"G","5":"A","6":"0.3729","7":"-0.1232","8":"0.0149","9":"-8.268456","10":"1.186000e-16","11":"63926","12":"LOAD"},{"1":"rs3851179","2":"11","3":"85868640","4":"T","5":"C","6":"0.6410","7":"0.1198","8":"0.0148","9":"8.094590","10":"5.809000e-16","11":"63926","12":"LOAD"},{"1":"rs11218343","2":"11","3":"121435587","4":"T","5":"C","6":"0.0401","7":"-0.2053","8":"0.0369","9":"-5.563690","10":"2.633000e-08","11":"63926","12":"LOAD"},{"1":"rs12590654","2":"14","3":"92938855","4":"G","5":"A","6":"0.3353","7":"-0.0906","8":"0.0157","9":"-5.770701","10":"8.729000e-09","11":"63926","12":"LOAD"},{"1":"rs12151021","2":"19","3":"1050874","4":"A","5":"G","6":"0.6753","7":"-0.1071","8":"0.0169","9":"-6.337280","10":"2.562000e-10","11":"63926","12":"LOAD"},{"1":"rs111358663","2":"19","3":"45196958","4":"T","5":"A","6":"0.0111","7":"-0.5369","8":"0.0795","9":"-6.753459","10":"1.436000e-11","11":"63926","12":"LOAD"},{"1":"rs4803765","2":"19","3":"45358448","4":"C","5":"T","6":"0.0243","7":"0.7165","8":"0.0610","9":"11.745902","10":"7.131000e-32","11":"63926","12":"LOAD"},{"1":"rs12972156","2":"19","3":"45387459","4":"C","5":"G","6":"0.2027","7":"0.9653","8":"0.0189","9":"51.074100","10":"2.225074e-291","11":"63926","12":"LOAD"},{"1":"rs117310449","2":"19","3":"45393516","4":"C","5":"T","6":"0.0130","7":"0.9879","8":"0.0691","9":"14.296671","10":"2.275000e-46","11":"63926","12":"LOAD"},{"1":"rs73033507","2":"19","3":"45431403","4":"C","5":"T","6":"0.0239","7":"-0.3620","8":"0.0657","9":"-5.509893","10":"3.646000e-08","11":"63926","12":"LOAD"},{"1":"rs114533385","2":"19","3":"45436753","4":"C","5":"T","6":"0.0210","7":"0.8281","8":"0.0661","9":"12.527988","10":"5.434000e-36","11":"63926","12":"LOAD"},{"1":"rs139995984","2":"19","3":"45574482","4":"G","5":"C","6":"0.0155","7":"-0.5343","8":"0.0879","9":"-6.078498","10":"1.192000e-09","11":"63926","12":"LOAD"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

### Outcome: COVID: C2
`#r outcome.blurb`
<br>

**Table 2:** SNPs associated with LOAD avaliable in COVID: C2
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["CHROM"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["REF"],"name":[4],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[5],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[12],"type":["chr"],"align":["left"]}],"data":[{"1":"rs679515","2":"1","3":"207750568","4":"T","5":"C","6":"0.80010","7":"3.3303e-03","8":"0.0055434","9":"0.60076848","10":"0.547990","11":"2388040","12":"COVID_C2__EUR"},{"1":"rs6733839","2":"2","3":"127892810","4":"C","5":"T","6":"0.38540","7":"2.3023e-03","8":"0.0044584","9":"0.51639602","10":"0.605580","11":"2393300","12":"COVID_C2__EUR"},{"1":"rs114812713","2":"6","3":"41034000","4":"G","5":"C","6":"0.02545","7":"-1.3005e-02","8":"0.0139380","9":"-0.93306070","10":"0.350810","11":"2379973","12":"COVID_C2__EUR"},{"1":"rs1385742","2":"6","3":"47595155","4":"A","5":"T","6":"0.63960","7":"4.8092e-03","8":"0.0047557","9":"1.01124966","10":"0.311900","11":"1633026","12":"COVID_C2__EUR"},{"1":"rs11767557","2":"7","3":"143109139","4":"T","5":"C","6":"0.20040","7":"-2.4248e-03","8":"0.0052768","9":"-0.45952092","10":"0.645860","11":"2392636","12":"COVID_C2__EUR"},{"1":"rs73223431","2":"8","3":"27219987","4":"C","5":"T","6":"0.35750","7":"-3.1167e-03","8":"0.0044754","9":"-0.69640703","10":"0.486170","11":"2383244","12":"COVID_C2__EUR"},{"1":"rs867230","2":"8","3":"27468503","4":"C","5":"A","6":"0.59180","7":"4.0537e-03","8":"0.0044312","9":"0.91480863","10":"0.360300","11":"2312488","12":"COVID_C2__EUR"},{"1":"rs12416487","2":"10","3":"11721057","4":"A","5":"T","6":"0.64540","7":"5.7943e-04","8":"0.0045275","9":"0.12798012","10":"0.898160","11":"2320744","12":"COVID_C2__EUR"},{"1":"rs3740688","2":"11","3":"47380340","4":"G","5":"T","6":"0.53550","7":"-2.0485e-03","8":"0.0044670","9":"-0.45858518","10":"0.646530","11":"2382286","12":"COVID_C2__EUR"},{"1":"rs1582763","2":"11","3":"60021948","4":"G","5":"A","6":"0.36430","7":"-1.4435e-03","8":"0.0044511","9":"-0.32430186","10":"0.745710","11":"2392701","12":"COVID_C2__EUR"},{"1":"rs3851179","2":"11","3":"85868640","4":"T","5":"C","6":"0.63280","7":"8.8956e-03","8":"0.0044391","9":"2.00391971","10":"0.045075","11":"2382286","12":"COVID_C2__EUR"},{"1":"rs11218343","2":"11","3":"121435587","4":"T","5":"C","6":"0.03524","7":"-2.5001e-03","8":"0.0110800","9":"-0.22564079","10":"0.821490","11":"2379699","12":"COVID_C2__EUR"},{"1":"rs12590654","2":"14","3":"92938855","4":"G","5":"A","6":"0.33220","7":"-8.1807e-03","8":"0.0046076","9":"-1.77547964","10":"0.075822","11":"2383244","12":"COVID_C2__EUR"},{"1":"rs12151021","2":"19","3":"1050874","4":"A","5":"G","6":"0.67710","7":"3.6714e-03","8":"0.0047002","9":"0.78111570","10":"0.434740","11":"2306085","12":"COVID_C2__EUR"},{"1":"rs111358663","2":"19","3":"45196958","4":"T","5":"A","6":"0.01438","7":"-5.6011e-03","8":"0.0178730","9":"-0.31338332","10":"0.753990","11":"2353365","12":"COVID_C2__EUR"},{"1":"rs12972156","2":"19","3":"45387459","4":"C","5":"G","6":"0.15160","7":"-5.6017e-05","8":"0.0062317","9":"-0.00898904","10":"0.992830","11":"2383603","12":"COVID_C2__EUR"},{"1":"rs117310449","2":"19","3":"45393516","4":"C","5":"T","6":"0.01253","7":"-3.7415e-02","8":"0.0215050","9":"-1.73982795","10":"0.081893","11":"2340510","12":"COVID_C2__EUR"},{"1":"rs73033507","2":"19","3":"45431403","4":"C","5":"T","6":"0.03474","7":"8.9221e-03","8":"0.0127740","9":"0.69845780","10":"0.484900","11":"2293812","12":"COVID_C2__EUR"},{"1":"rs114533385","2":"19","3":"45436753","4":"C","5":"T","6":"0.01029","7":"2.4411e-03","8":"0.0221070","9":"0.11042204","10":"0.912080","11":"2361653","12":"COVID_C2__EUR"},{"1":"rs34665982","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA"},{"1":"rs4803765","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA"},{"1":"rs139995984","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

**Table 3:** Proxy SNPs for COVID: C2
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["proxy.outcome"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["target_snp"],"name":[2],"type":["chr"],"align":["left"]},{"label":["proxy_snp"],"name":[3],"type":["lgl"],"align":["right"]},{"label":["ld.r2"],"name":[4],"type":["lgl"],"align":["right"]},{"label":["Dprime"],"name":[5],"type":["lgl"],"align":["right"]},{"label":["ref.proxy"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["alt.proxy"],"name":[7],"type":["lgl"],"align":["right"]},{"label":["CHROM"],"name":[8],"type":["lgl"],"align":["right"]},{"label":["POS"],"name":[9],"type":["lgl"],"align":["right"]},{"label":["ALT.proxy"],"name":[10],"type":["lgl"],"align":["right"]},{"label":["REF.proxy"],"name":[11],"type":["lgl"],"align":["right"]},{"label":["AF"],"name":[12],"type":["lgl"],"align":["right"]},{"label":["BETA"],"name":[13],"type":["lgl"],"align":["right"]},{"label":["SE"],"name":[14],"type":["lgl"],"align":["right"]},{"label":["P"],"name":[15],"type":["lgl"],"align":["right"]},{"label":["N"],"name":[16],"type":["lgl"],"align":["right"]},{"label":["ref"],"name":[17],"type":["lgl"],"align":["right"]},{"label":["alt"],"name":[18],"type":["lgl"],"align":["right"]},{"label":["ALT"],"name":[19],"type":["lgl"],"align":["right"]},{"label":["REF"],"name":[20],"type":["lgl"],"align":["right"]},{"label":["PHASE"],"name":[21],"type":["lgl"],"align":["right"]}],"data":[{"1":"NA","2":"rs34665982","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA","13":"NA","14":"NA","15":"NA","16":"NA","17":"NA","18":"NA","19":"NA","20":"NA","21":"NA"},{"1":"NA","2":"rs4803765","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA","13":"NA","14":"NA","15":"NA","16":"NA","17":"NA","18":"NA","19":"NA","20":"NA","21":"NA"},{"1":"NA","2":"rs139995984","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA","13":"NA","14":"NA","15":"NA","16":"NA","17":"NA","18":"NA","19":"NA","20":"NA","21":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

## Data harmonization
Harmonize the exposure and outcome datasets so that the effect of a SNP on the exposure and the effect of that SNP on the outcome correspond to the same allele. The harmonise_data function from the TwoSampleMR package can be used to perform the harmonization step, by default it try's to infer the forward strand alleles using allele frequency information.
<br>

**Table 4:** Harmonized LOAD and COVID: C2 datasets
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["effect_allele.exposure"],"name":[2],"type":["chr"],"align":["left"]},{"label":["other_allele.exposure"],"name":[3],"type":["chr"],"align":["left"]},{"label":["effect_allele.outcome"],"name":[4],"type":["chr"],"align":["left"]},{"label":["other_allele.outcome"],"name":[5],"type":["chr"],"align":["left"]},{"label":["beta.exposure"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["beta.outcome"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["eaf.exposure"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["eaf.outcome"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["remove"],"name":[10],"type":["lgl"],"align":["right"]},{"label":["palindromic"],"name":[11],"type":["lgl"],"align":["right"]},{"label":["ambiguous"],"name":[12],"type":["lgl"],"align":["right"]},{"label":["id.outcome"],"name":[13],"type":["chr"],"align":["left"]},{"label":["chr.outcome"],"name":[14],"type":["dbl"],"align":["right"]},{"label":["pos.outcome"],"name":[15],"type":["dbl"],"align":["right"]},{"label":["se.outcome"],"name":[16],"type":["dbl"],"align":["right"]},{"label":["z.outcome"],"name":[17],"type":["dbl"],"align":["right"]},{"label":["pval.outcome"],"name":[18],"type":["dbl"],"align":["right"]},{"label":["samplesize.outcome"],"name":[19],"type":["dbl"],"align":["right"]},{"label":["outcome"],"name":[20],"type":["chr"],"align":["left"]},{"label":["mr_keep.outcome"],"name":[21],"type":["lgl"],"align":["right"]},{"label":["pval_origin.outcome"],"name":[22],"type":["chr"],"align":["left"]},{"label":["chr.exposure"],"name":[23],"type":["dbl"],"align":["right"]},{"label":["pos.exposure"],"name":[24],"type":["dbl"],"align":["right"]},{"label":["se.exposure"],"name":[25],"type":["dbl"],"align":["right"]},{"label":["z.exposure"],"name":[26],"type":["dbl"],"align":["right"]},{"label":["pval.exposure"],"name":[27],"type":["dbl"],"align":["right"]},{"label":["samplesize.exposure"],"name":[28],"type":["dbl"],"align":["right"]},{"label":["exposure"],"name":[29],"type":["chr"],"align":["left"]},{"label":["mr_keep.exposure"],"name":[30],"type":["lgl"],"align":["right"]},{"label":["pval_origin.exposure"],"name":[31],"type":["chr"],"align":["left"]},{"label":["id.exposure"],"name":[32],"type":["chr"],"align":["left"]},{"label":["action"],"name":[33],"type":["dbl"],"align":["right"]},{"label":["mr_keep"],"name":[34],"type":["lgl"],"align":["right"]},{"label":["pt"],"name":[35],"type":["dbl"],"align":["right"]},{"label":["pleitropy_keep"],"name":[36],"type":["lgl"],"align":["right"]},{"label":["mrpresso_RSSobs"],"name":[37],"type":["lgl"],"align":["right"]},{"label":["mrpresso_pval"],"name":[38],"type":["lgl"],"align":["right"]},{"label":["mrpresso_keep"],"name":[39],"type":["lgl"],"align":["right"]}],"data":[{"1":"rs111358663","2":"A","3":"T","4":"A","5":"T","6":"-0.5369","7":"-5.6011e-03","8":"0.0111","9":"0.01438","10":"FALSE","11":"TRUE","12":"FALSE","13":"35jyQn","14":"19","15":"45196958","16":"0.0178730","17":"-0.31338332","18":"0.753990","19":"2353365","20":"covidhgi2020C2v6alleur","21":"TRUE","22":"reported","23":"19","24":"45196958","25":"0.0795","26":"-6.753459","27":"1.436e-11","28":"63926","29":"Kunkle2019load","30":"TRUE","31":"reported","32":"rZxDtI","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs11218343","2":"C","3":"T","4":"C","5":"T","6":"-0.2053","7":"-2.5001e-03","8":"0.0401","9":"0.03524","10":"FALSE","11":"FALSE","12":"FALSE","13":"35jyQn","14":"11","15":"121435587","16":"0.0110800","17":"-0.22564079","18":"0.821490","19":"2379699","20":"covidhgi2020C2v6alleur","21":"TRUE","22":"reported","23":"11","24":"121435587","25":"0.0369","26":"-5.563690","27":"2.633e-08","28":"63926","29":"Kunkle2019load","30":"TRUE","31":"reported","32":"rZxDtI","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs114533385","2":"T","3":"C","4":"T","5":"C","6":"0.8281","7":"2.4411e-03","8":"0.0210","9":"0.01029","10":"FALSE","11":"FALSE","12":"FALSE","13":"35jyQn","14":"19","15":"45436753","16":"0.0221070","17":"0.11042204","18":"0.912080","19":"2361653","20":"covidhgi2020C2v6alleur","21":"TRUE","22":"reported","23":"19","24":"45436753","25":"0.0661","26":"12.527988","27":"5.434e-36","28":"63926","29":"Kunkle2019load","30":"TRUE","31":"reported","32":"rZxDtI","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs114812713","2":"C","3":"G","4":"C","5":"G","6":"0.2980","7":"-1.3005e-02","8":"0.0301","9":"0.02545","10":"FALSE","11":"TRUE","12":"FALSE","13":"35jyQn","14":"6","15":"41034000","16":"0.0139380","17":"-0.93306070","18":"0.350810","19":"2379973","20":"covidhgi2020C2v6alleur","21":"TRUE","22":"reported","23":"6","24":"41034000","25":"0.0431","26":"6.914153","27":"4.467e-12","28":"63926","29":"Kunkle2019load","30":"TRUE","31":"reported","32":"rZxDtI","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs117310449","2":"T","3":"C","4":"T","5":"C","6":"0.9879","7":"-3.7415e-02","8":"0.0130","9":"0.01253","10":"FALSE","11":"FALSE","12":"FALSE","13":"35jyQn","14":"19","15":"45393516","16":"0.0215050","17":"-1.73982795","18":"0.081893","19":"2340510","20":"covidhgi2020C2v6alleur","21":"TRUE","22":"reported","23":"19","24":"45393516","25":"0.0691","26":"14.296671","27":"2.275e-46","28":"63926","29":"Kunkle2019load","30":"TRUE","31":"reported","32":"rZxDtI","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs11767557","2":"C","3":"T","4":"C","5":"T","6":"-0.1028","7":"-2.4248e-03","8":"0.1968","9":"0.20040","10":"FALSE","11":"FALSE","12":"FALSE","13":"35jyQn","14":"7","15":"143109139","16":"0.0052768","17":"-0.45952092","18":"0.645860","19":"2392636","20":"covidhgi2020C2v6alleur","21":"TRUE","22":"reported","23":"7","24":"143109139","25":"0.0182","26":"-5.648350","27":"1.561e-08","28":"63926","29":"Kunkle2019load","30":"TRUE","31":"reported","32":"rZxDtI","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs12151021","2":"G","3":"A","4":"G","5":"A","6":"-0.1071","7":"3.6714e-03","8":"0.6753","9":"0.67710","10":"FALSE","11":"FALSE","12":"FALSE","13":"35jyQn","14":"19","15":"1050874","16":"0.0047002","17":"0.78111570","18":"0.434740","19":"2306085","20":"covidhgi2020C2v6alleur","21":"TRUE","22":"reported","23":"19","24":"1050874","25":"0.0169","26":"-6.337280","27":"2.562e-10","28":"63926","29":"Kunkle2019load","30":"TRUE","31":"reported","32":"rZxDtI","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs12416487","2":"T","3":"A","4":"T","5":"A","6":"0.0850","7":"5.7943e-04","8":"0.6519","9":"0.64540","10":"FALSE","11":"TRUE","12":"FALSE","13":"35jyQn","14":"10","15":"11721057","16":"0.0045275","17":"0.12798012","18":"0.898160","19":"2320744","20":"covidhgi2020C2v6alleur","21":"TRUE","22":"reported","23":"10","24":"11721057","25":"0.0154","26":"5.519480","27":"3.417e-08","28":"63926","29":"Kunkle2019load","30":"TRUE","31":"reported","32":"rZxDtI","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs12590654","2":"A","3":"G","4":"A","5":"G","6":"-0.0906","7":"-8.1807e-03","8":"0.3353","9":"0.33220","10":"FALSE","11":"FALSE","12":"FALSE","13":"35jyQn","14":"14","15":"92938855","16":"0.0046076","17":"-1.77547964","18":"0.075822","19":"2383244","20":"covidhgi2020C2v6alleur","21":"TRUE","22":"reported","23":"14","24":"92938855","25":"0.0157","26":"-5.770701","27":"8.729e-09","28":"63926","29":"Kunkle2019load","30":"TRUE","31":"reported","32":"rZxDtI","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs12972156","2":"G","3":"C","4":"G","5":"C","6":"0.9653","7":"-5.6017e-05","8":"0.2027","9":"0.15160","10":"FALSE","11":"TRUE","12":"FALSE","13":"35jyQn","14":"19","15":"45387459","16":"0.0062317","17":"-0.00898904","18":"0.992830","19":"2383603","20":"covidhgi2020C2v6alleur","21":"TRUE","22":"reported","23":"19","24":"45387459","25":"0.0189","26":"51.074100","27":"1.000e-200","28":"63926","29":"Kunkle2019load","30":"TRUE","31":"reported","32":"rZxDtI","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs1385742","2":"T","3":"A","4":"T","5":"A","6":"-0.0876","7":"4.8092e-03","8":"0.6344","9":"0.63960","10":"FALSE","11":"TRUE","12":"FALSE","13":"35jyQn","14":"6","15":"47595155","16":"0.0047557","17":"1.01124966","18":"0.311900","19":"1633026","20":"covidhgi2020C2v6alleur","21":"TRUE","22":"reported","23":"6","24":"47595155","25":"0.0157","26":"-5.579620","27":"2.232e-08","28":"63926","29":"Kunkle2019load","30":"TRUE","31":"reported","32":"rZxDtI","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs1582763","2":"A","3":"G","4":"A","5":"G","6":"-0.1232","7":"-1.4435e-03","8":"0.3729","9":"0.36430","10":"FALSE","11":"FALSE","12":"FALSE","13":"35jyQn","14":"11","15":"60021948","16":"0.0044511","17":"-0.32430186","18":"0.745710","19":"2392701","20":"covidhgi2020C2v6alleur","21":"TRUE","22":"reported","23":"11","24":"60021948","25":"0.0149","26":"-8.268456","27":"1.186e-16","28":"63926","29":"Kunkle2019load","30":"TRUE","31":"reported","32":"rZxDtI","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs3740688","2":"T","3":"G","4":"T","5":"G","6":"0.0935","7":"-2.0485e-03","8":"0.5524","9":"0.53550","10":"FALSE","11":"FALSE","12":"FALSE","13":"35jyQn","14":"11","15":"47380340","16":"0.0044670","17":"-0.45858518","18":"0.646530","19":"2382286","20":"covidhgi2020C2v6alleur","21":"TRUE","22":"reported","23":"11","24":"47380340","25":"0.0144","26":"6.493056","27":"9.702e-11","28":"63926","29":"Kunkle2019load","30":"TRUE","31":"reported","32":"rZxDtI","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs3851179","2":"C","3":"T","4":"C","5":"T","6":"0.1198","7":"8.8956e-03","8":"0.6410","9":"0.63280","10":"FALSE","11":"FALSE","12":"FALSE","13":"35jyQn","14":"11","15":"85868640","16":"0.0044391","17":"2.00391971","18":"0.045075","19":"2382286","20":"covidhgi2020C2v6alleur","21":"TRUE","22":"reported","23":"11","24":"85868640","25":"0.0148","26":"8.094590","27":"5.809e-16","28":"63926","29":"Kunkle2019load","30":"TRUE","31":"reported","32":"rZxDtI","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs6733839","2":"T","3":"C","4":"T","5":"C","6":"0.1693","7":"2.3023e-03","8":"0.4067","9":"0.38540","10":"FALSE","11":"FALSE","12":"FALSE","13":"35jyQn","14":"2","15":"127892810","16":"0.0044584","17":"0.51639602","18":"0.605580","19":"2393300","20":"covidhgi2020C2v6alleur","21":"TRUE","22":"reported","23":"2","24":"127892810","25":"0.0154","26":"10.993506","27":"4.022e-28","28":"63926","29":"Kunkle2019load","30":"TRUE","31":"reported","32":"rZxDtI","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs679515","2":"C","3":"T","4":"C","5":"T","6":"-0.1508","7":"3.3303e-03","8":"0.8126","9":"0.80010","10":"FALSE","11":"FALSE","12":"FALSE","13":"35jyQn","14":"1","15":"207750568","16":"0.0055434","17":"0.60076848","18":"0.547990","19":"2388040","20":"covidhgi2020C2v6alleur","21":"TRUE","22":"reported","23":"1","24":"207750568","25":"0.0183","26":"-8.240440","27":"1.555e-16","28":"63926","29":"Kunkle2019load","30":"TRUE","31":"reported","32":"rZxDtI","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs73033507","2":"T","3":"C","4":"T","5":"C","6":"-0.3620","7":"8.9221e-03","8":"0.0239","9":"0.03474","10":"FALSE","11":"FALSE","12":"FALSE","13":"35jyQn","14":"19","15":"45431403","16":"0.0127740","17":"0.69845780","18":"0.484900","19":"2293812","20":"covidhgi2020C2v6alleur","21":"TRUE","22":"reported","23":"19","24":"45431403","25":"0.0657","26":"-5.509893","27":"3.646e-08","28":"63926","29":"Kunkle2019load","30":"TRUE","31":"reported","32":"rZxDtI","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs73223431","2":"T","3":"C","4":"T","5":"C","6":"0.0936","7":"-3.1167e-03","8":"0.3669","9":"0.35750","10":"FALSE","11":"FALSE","12":"FALSE","13":"35jyQn","14":"8","15":"27219987","16":"0.0044754","17":"-0.69640703","18":"0.486170","19":"2383244","20":"covidhgi2020C2v6alleur","21":"TRUE","22":"reported","23":"8","24":"27219987","25":"0.0153","26":"6.117647","27":"8.342e-10","28":"63926","29":"Kunkle2019load","30":"TRUE","31":"reported","32":"rZxDtI","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs867230","2":"A","3":"C","4":"A","5":"C","6":"0.1333","7":"4.0537e-03","8":"0.6029","9":"0.59180","10":"FALSE","11":"FALSE","12":"FALSE","13":"35jyQn","14":"8","15":"27468503","16":"0.0044312","17":"0.91480863","18":"0.360300","19":"2312488","20":"covidhgi2020C2v6alleur","21":"TRUE","22":"reported","23":"8","24":"27468503","25":"0.0158","26":"8.436709","27":"3.492e-17","28":"63926","29":"Kunkle2019load","30":"TRUE","31":"reported","32":"rZxDtI","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

SNPs that genome-wide significant in the outcome GWAS are likely pleitorpic and should be removed from analysis. Additionaly remove variants within the APOE locus by exclude variants 1MB either side of APOE e4 (rs429358 = 19:45411941, GRCh37.p13)
<br>


**Table 5:** SNPs that were genome-wide significant in the COVID: C2 GWAS
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
{"columns":[{"label":["outliers_removed"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["pve.exposure"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["F"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["Alpha"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["NCP"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["Power"],"name":[6],"type":["dbl"],"align":["right"]}],"data":[{"1":"FALSE","2":"0.0639256","3":"194.601","4":"0.05","5":"0.006218353","6":"0.05071262"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

The I2_GX statistic can be used to quantify the strength of the NOME violation for MR-Egger regression and should be used to evalute potential bias in the MR-Egger causal estimate, with values less then 90% indicating that causal estimated should interpreted with caution due to regression diluation.

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["outliers_removed"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["Isq_gx"],"name":[2],"type":["dbl"],"align":["right"]}],"data":[{"1":"FALSE","2":"0.989869"},{"1":"TRUE","2":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>


## MR Results
To obtain an overall estimate of causal effect, the SNP-exposure and SNP-outcome coefficients were combined in 1) a fixed-effects meta-analysis using an inverse-variance weighted approach (IVW); 2) a Weighted Median approach; 3) Weighted Mode approach and 4) Egger Regression.


[**IVW**](https://doi.org/10.1002/gepi.21758) is equivalent to a weighted regression of the SNP-outcome coefficients on the SNP-exposure coefficients with the intercept constrained to zero. This method assumes that all variants are valid instrumental variables based on the Mendelian randomization assumptions. The causal estimate of the IVW analysis expresses the causal increase in the outcome (or log odds of the outcome for a binary outcome) per unit change in the exposure. [**Weighted median MR**](https://doi.org/10.1002/gepi.21965) allows for 50% of the instrumental variables to be invalid. [**MR-Egger regression**](https://doi.org/10.1093/ije/dyw220) allows all the instrumental variables to be subject to direct effects (i.e. horizontal pleiotropy), with the intercept representing bias in the causal estimate due to pleiotropy and the slope representing the causal estimate. [**Weighted Mode**](https://doi.org/10.1093/ije/dyx102) gives consistent estimates as the sample size increases if a plurality (or weighted plurality) of the genetic variants are valid instruments.
<br>



Table 6 presents the MR causal estimates of genetically predicted LOAD on COVID: C2.
<br>

**Table 6** MR causaul estimates for LOAD on COVID: C2
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["method"],"name":[5],"type":["chr"],"align":["left"]},{"label":["nsnp"],"name":[6],"type":["int"],"align":["right"]},{"label":["b"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"rZxDtI","2":"35jyQn","3":"covidhgi2020C2v6alleur","4":"Kunkle2019load","5":"Inverse variance weighted (fixed effects)","6":"19","7":"-0.0006357931","8":"0.005167568","9":"0.9020792"},{"1":"rZxDtI","2":"35jyQn","3":"covidhgi2020C2v6alleur","4":"Kunkle2019load","5":"Weighted median","6":"19","7":"0.0001491447","8":"0.006081352","9":"0.9804339"},{"1":"rZxDtI","2":"35jyQn","3":"covidhgi2020C2v6alleur","4":"Kunkle2019load","5":"Weighted mode","6":"19","7":"0.0003861904","8":"0.006483738","9":"0.9531601"},{"1":"rZxDtI","2":"35jyQn","3":"covidhgi2020C2v6alleur","4":"Kunkle2019load","5":"MR Egger","6":"19","7":"-0.0044201497","8":"0.006817532","9":"0.5254199"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Figure 1 illustrates the SNP-specific associations with LOAD versus the association in COVID: C2 and the corresponding MR estimates.
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/harern01/projects/MRcovid/results/MRcovideurv6/Kunkle2019load/covidhgi2020C2v6alleur/Kunkle2019load_5e-8_covidhgi2020C2v6alleur_MR_Analaysis_files/figure-html/scatter_plot-1.png" alt="Fig. 1: Scatterplot of SNP effects for the association of the Exposure on the Outcome"  />
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
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["method"],"name":[5],"type":["chr"],"align":["left"]},{"label":["Q"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["Q_df"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["Q_pval"],"name":[8],"type":["dbl"],"align":["right"]}],"data":[{"1":"rZxDtI","2":"35jyQn","3":"covidhgi2020C2v6alleur","4":"Kunkle2019load","5":"MR Egger","6":"15.10074","7":"17","8":"0.5882258"},{"1":"rZxDtI","2":"35jyQn","3":"covidhgi2020C2v6alleur","4":"Kunkle2019load","5":"Inverse variance weighted","6":"15.82495","7":"18","8":"0.6047626"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Figure 2 shows a funnel plot displaying the MR estimates of individual genetic variants against their precession. Aysmmetry in the funnel plot may arrise due to some genetic variants having unusally strong effects on the outcome, which is indicative of directional pleiotropy.
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/harern01/projects/MRcovid/results/MRcovideurv6/Kunkle2019load/covidhgi2020C2v6alleur/Kunkle2019load_5e-8_covidhgi2020C2v6alleur_MR_Analaysis_files/figure-html/funnel_plot-1.png" alt="Fig. 2: Funnel plot of the MR causal estimates against their precession"  />
<p class="caption">Fig. 2: Funnel plot of the MR causal estimates against their precession</p>
</div>
<br>

Figure 3 shows a [Radial Plots](https://github.com/WSpiller/RadialMR) can be used to visualize influential data points with large contributions to Cochran's Q Statistic that may bias causal effect estimates.




```
## [1] "No significant Outliers"
```

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/harern01/projects/MRcovid/results/MRcovideurv6/Kunkle2019load/covidhgi2020C2v6alleur/Kunkle2019load_5e-8_covidhgi2020C2v6alleur_MR_Analaysis_files/figure-html/Radial_Plot-1.png" alt="Fig. 4: Radial Plot showing influential data points using Radial IVW"  />
<p class="caption">Fig. 4: Radial Plot showing influential data points using Radial IVW</p>
</div>
<br>

The intercept of the MR-Egger Regression model captures the average pleitropic affect across all genetic variants (Table 8).
<br>

**Table 8:** MR Egger test for directional pleitropy
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["egger_intercept"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[7],"type":["dbl"],"align":["right"]}],"data":[{"1":"rZxDtI","2":"35jyQn","3":"covidhgi2020C2v6alleur","4":"Kunkle2019load","5":"0.001438882","6":"0.001690796","7":"0.4065924"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Pleiotropy was also assesed using Mendelian Randomization Pleiotropy RESidual Sum and Outlier [(MR-PRESSO)](https://doi.org/10.1038/s41588-018-0099-7), that allows for the evlation of evaluation of horizontal pleiotropy in a standared MR model (Table 9). MR-PRESSO performs a global test for detection of horizontal pleiotropy and correction of pleiotropy via outlier removal (Table 10).
<br>

**Table 9:** MR-PRESSO Global Test for pleitropy
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["pt"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["outliers_removed"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["n_outliers"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["RSSobs"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"rZxDtI","2":"35jyQn","3":"covidhgi2020C2v6alleur","4":"Kunkle2019load","5":"5e-08","6":"FALSE","7":"0","8":"16.66135","9":"0.6965"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>


**Table 10:** MR Estimates after MR-PRESSO outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["method"],"name":[5],"type":["chr"],"align":["left"]},{"label":["nsnp"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["b"],"name":[7],"type":["lgl"],"align":["right"]},{"label":["se"],"name":[8],"type":["lgl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["lgl"],"align":["right"]}],"data":[{"1":"rZxDtI","2":"35jyQn","3":"covidhgi2020C2v6alleur","4":"Kunkle2019load","5":"mrpresso","6":"NA","7":"NA","8":"NA","9":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/harern01/projects/MRcovid/results/MRcovideurv6/Kunkle2019load/covidhgi2020C2v6alleur/Kunkle2019load_5e-8_covidhgi2020C2v6alleur_MR_Analaysis_files/figure-html/scatter_plot_outlier-1.png" alt="Fig. 5: Scatterplot of SNP effects for the association of the Exposure on the Outcome after outlier removal"  />
<p class="caption">Fig. 5: Scatterplot of SNP effects for the association of the Exposure on the Outcome after outlier removal</p>
</div>
<br>

**Table 11:** Heterogenity Tests after outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["method"],"name":[5],"type":["chr"],"align":["left"]},{"label":["Q"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["Q_df"],"name":[7],"type":["lgl"],"align":["right"]},{"label":["Q_pval"],"name":[8],"type":["lgl"],"align":["right"]}],"data":[{"1":"rZxDtI","2":"35jyQn","3":"covidhgi2020C2v6alleur","4":"Kunkle2019load","5":"mrpresso","6":"NA","7":"NA","8":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

**Table 12:** MR Egger test for directional pleitropy after outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["method"],"name":[5],"type":["chr"],"align":["left"]},{"label":["egger_intercept"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["se"],"name":[7],"type":["lgl"],"align":["right"]},{"label":["pval"],"name":[8],"type":["lgl"],"align":["right"]}],"data":[{"1":"rZxDtI","2":"35jyQn","3":"covidhgi2020C2v6alleur","4":"Kunkle2019load","5":"mrpresso","6":"NA","7":"NA","8":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>
