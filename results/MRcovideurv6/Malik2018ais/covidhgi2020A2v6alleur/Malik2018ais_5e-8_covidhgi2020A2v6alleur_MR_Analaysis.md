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
## NA/sc/arion/projects/LOAD/harern01/projects/MRcovidNULLdata/MRcovideurv6/Malik2018ais/Malik2018ais_5e-8_SNPs.txtdata/MRcovideurv6/Malik2018ais/covidhgi2020A2v6alleur/Malik2018ais_5e-8_covidhgi2020A2v6alleur_SNPs.txtdata/MRcovideurv6/Malik2018ais/covidhgi2020A2v6alleur/Malik2018ais_5e-8_covidhgi2020A2v6alleur_MatchedProxys.csvdata/MRcovideurv6/Malik2018ais/covidhgi2020A2v6alleur/Malik2018ais_5e-8_covidhgi2020A2v6alleur_mrpresso_MRdat.csvdata/MRcovideurv6/Malik2018ais/covidhgi2020A2v6alleur/Malik2018ais_5e-8_covidhgi2020A2v6alleur_mrpresso_global.txtdata/MRcovideurv6/Malik2018ais/covidhgi2020A2v6alleur/Malik2018ais_5e-8_covidhgi2020A2v6alleur_MR_power.txtcovidhgi2020A2v6alleurMalik2018aisCOVID: A2Ischemic Stroke5e-80.00110000results/MRcovideurv6/Malik2018ais/covidhgi2020A2v6alleur/Malik2018ais_5e-8_covidhgi2020A2v6alleur
```



## Instrumental Variables
**SNP Inclusion:** SNPS associated with at a p-value threshold of p < 5e-8 were included in this analysis.
<br>

**LD Clumping:** For standard two sample MR it is important to ensure that the instruments for the exposure are independent. LD clumping was performed in PLINK using the EUR samples from the 1000 Genomes Project to estimate LD between SNPs, and, amongst SNPs that have an LD above a given threshold, retain only the SNP with the lowest p-value. A clumping window of 10^{4}, r2 of 0.001 and significance level of 1 was used for the index and secondary SNPs.
<br>

**Proxy SNPs:** Where SNPs were not available in the outcome GWAS, the EUR thousand genomes was queried to identify potential proxy SNPs that are in linkage disequilibrium (r2 > 0.8) of the missing SNP.
<br>

### Exposure: Ischemic Stroke
`#r exposure.blurb`
<br>

**Table 1:** Independent SNPs associated with Ischemic Stroke
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["CHROM"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["REF"],"name":[4],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[5],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[12],"type":["chr"],"align":["left"]}],"data":[{"1":"rs2758612","2":"1","3":"156205301","4":"T","5":"C","6":"0.3547","7":"-0.0653","8":"0.0111","9":"-5.882880","10":"3.677e-09","11":"440328","12":"Ischemic_Stroke"},{"1":"rs2634074","2":"4","3":"111677041","4":"T","5":"A","6":"0.7877","7":"-0.0941","8":"0.0121","9":"-7.776860","10":"5.905e-15","11":"440328","12":"Ischemic_Stroke"},{"1":"rs34311906","2":"4","3":"113732090","4":"T","5":"C","6":"0.4024","7":"0.0649","8":"0.0113","9":"5.743360","10":"1.066e-08","11":"440328","12":"Ischemic_Stroke"},{"1":"rs2066864","2":"4","3":"155525695","4":"G","5":"A","6":"0.2452","7":"0.0634","8":"0.0115","9":"5.513043","10":"3.514e-08","11":"440328","12":"Ischemic_Stroke"},{"1":"rs11242678","2":"6","3":"1337180","4":"C","5":"T","6":"0.2550","7":"0.0723","8":"0.0114","9":"6.342105","10":"2.703e-10","11":"440328","12":"Ischemic_Stroke"},{"1":"rs2107595","2":"7","3":"19049388","4":"G","5":"A","6":"0.1673","7":"0.0882","8":"0.0132","9":"6.681818","10":"2.328e-11","11":"440328","12":"Ischemic_Stroke"},{"1":"rs635634","2":"9","3":"136155000","4":"C","5":"T","6":"0.1921","7":"0.0772","8":"0.0134","9":"5.761194","10":"9.179e-09","11":"440328","12":"Ischemic_Stroke"},{"1":"rs473238","2":"11","3":"102700360","4":"T","5":"C","6":"0.8674","7":"-0.0831","8":"0.0147","9":"-5.653060","10":"1.651e-08","11":"440328","12":"Ischemic_Stroke"},{"1":"rs3184504","2":"12","3":"111884608","4":"T","5":"C","6":"0.5278","7":"-0.0779","8":"0.0101","9":"-7.712870","10":"1.229e-14","11":"440328","12":"Ischemic_Stroke"},{"1":"rs4942561","2":"13","3":"47209347","4":"G","5":"T","6":"0.7590","7":"0.0655","8":"0.0116","9":"5.646552","10":"1.771e-08","11":"440328","12":"Ischemic_Stroke"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

### Outcome: COVID: A2
`#r outcome.blurb`
<br>

**Table 2:** SNPs associated with Ischemic Stroke avaliable in COVID: A2
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["CHROM"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["REF"],"name":[4],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[5],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[12],"type":["chr"],"align":["left"]}],"data":[{"1":"rs2634074","2":"4","3":"111677041","4":"T","5":"A","6":"0.7816","7":"0.04574200","8":"0.025548","9":"1.79043369","10":"7.3384e-02","11":"1629782","12":"COVID_A2__EUR"},{"1":"rs2066864","2":"4","3":"155525695","4":"G","5":"A","6":"0.2483","7":"0.00963230","8":"0.023137","9":"0.41631586","10":"6.7719e-01","11":"1639838","12":"COVID_A2__EUR"},{"1":"rs11242678","2":"6","3":"1337180","4":"C","5":"T","6":"0.2545","7":"0.03066300","8":"0.023022","9":"1.33189992","10":"1.8289e-01","11":"1639435","12":"COVID_A2__EUR"},{"1":"rs2107595","2":"7","3":"19049388","4":"G","5":"A","6":"0.1656","7":"-0.00094859","8":"0.029275","9":"-0.03240273","10":"9.7415e-01","11":"1629782","12":"COVID_A2__EUR"},{"1":"rs635634","2":"9","3":"136155000","4":"C","5":"T","6":"0.1948","7":"0.15270000","8":"0.026845","9":"5.68821000","10":"1.2830e-08","11":"1629782","12":"COVID_A2__EUR"},{"1":"rs473238","2":"11","3":"102700360","4":"T","5":"C","6":"0.8466","7":"-0.03532600","8":"0.031470","9":"-1.12252939","10":"2.6164e-01","11":"1628824","12":"COVID_A2__EUR"},{"1":"rs3184504","2":"12","3":"111884608","4":"T","5":"C","6":"0.5240","7":"0.05395100","8":"0.021584","9":"2.49958302","10":"1.2435e-02","11":"1628824","12":"COVID_A2__EUR"},{"1":"rs4942561","2":"13","3":"47209347","4":"G","5":"T","6":"0.7566","7":"-0.02997400","8":"0.022929","9":"-1.30725282","10":"1.9112e-01","11":"1639838","12":"COVID_A2__EUR"},{"1":"rs2758612","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA"},{"1":"rs34311906","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

**Table 3:** Proxy SNPs for COVID: A2
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["target_snp"],"name":[1],"type":["chr"],"align":["left"]},{"label":["proxy_snp"],"name":[2],"type":["chr"],"align":["left"]},{"label":["ld.r2"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["Dprime"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["PHASE"],"name":[5],"type":["chr"],"align":["left"]},{"label":["X12"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["CHROM"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["REF.proxy"],"name":[9],"type":["lgl"],"align":["right"]},{"label":["ALT.proxy"],"name":[10],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[12],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[13],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[14],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[15],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[16],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[17],"type":["chr"],"align":["left"]},{"label":["ref"],"name":[18],"type":["chr"],"align":["left"]},{"label":["ref.proxy"],"name":[19],"type":["chr"],"align":["left"]},{"label":["alt"],"name":[20],"type":["lgl"],"align":["right"]},{"label":["alt.proxy"],"name":[21],"type":["lgl"],"align":["right"]},{"label":["ALT"],"name":[22],"type":["chr"],"align":["left"]},{"label":["REF"],"name":[23],"type":["lgl"],"align":["right"]},{"label":["proxy.outcome"],"name":[24],"type":["lgl"],"align":["right"]}],"data":[{"1":"rs2758612","2":"rs2842870","3":"0.991354","4":"1","5":"CC/TT","6":"NA","7":"1","8":"156200671","9":"TRUE","10":"C","11":"0.3512","12":"-0.046001","13":"0.02038","14":"-2.257164","15":"0.023999","16":"1639838","17":"COVID_A2__EUR","18":"C","19":"C","20":"TRUE","21":"TRUE","22":"C","23":"TRUE","24":"TRUE"},{"1":"rs34311906","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA","13":"NA","14":"NA","15":"NA","16":"NA","17":"NA","18":"NA","19":"NA","20":"NA","21":"NA","22":"NA","23":"NA","24":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

## Data harmonization
Harmonize the exposure and outcome datasets so that the effect of a SNP on the exposure and the effect of that SNP on the outcome correspond to the same allele. The harmonise_data function from the TwoSampleMR package can be used to perform the harmonization step, by default it try's to infer the forward strand alleles using allele frequency information.
<br>

**Table 4:** Harmonized Ischemic Stroke and COVID: A2 datasets
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["effect_allele.exposure"],"name":[2],"type":["chr"],"align":["left"]},{"label":["other_allele.exposure"],"name":[3],"type":["chr"],"align":["left"]},{"label":["effect_allele.outcome"],"name":[4],"type":["chr"],"align":["left"]},{"label":["other_allele.outcome"],"name":[5],"type":["chr"],"align":["left"]},{"label":["beta.exposure"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["beta.outcome"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["eaf.exposure"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["eaf.outcome"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["remove"],"name":[10],"type":["lgl"],"align":["right"]},{"label":["palindromic"],"name":[11],"type":["lgl"],"align":["right"]},{"label":["ambiguous"],"name":[12],"type":["lgl"],"align":["right"]},{"label":["id.outcome"],"name":[13],"type":["chr"],"align":["left"]},{"label":["chr.outcome"],"name":[14],"type":["dbl"],"align":["right"]},{"label":["pos.outcome"],"name":[15],"type":["dbl"],"align":["right"]},{"label":["se.outcome"],"name":[16],"type":["dbl"],"align":["right"]},{"label":["z.outcome"],"name":[17],"type":["dbl"],"align":["right"]},{"label":["pval.outcome"],"name":[18],"type":["dbl"],"align":["right"]},{"label":["samplesize.outcome"],"name":[19],"type":["dbl"],"align":["right"]},{"label":["outcome"],"name":[20],"type":["chr"],"align":["left"]},{"label":["mr_keep.outcome"],"name":[21],"type":["lgl"],"align":["right"]},{"label":["pval_origin.outcome"],"name":[22],"type":["chr"],"align":["left"]},{"label":["chr.exposure"],"name":[23],"type":["dbl"],"align":["right"]},{"label":["pos.exposure"],"name":[24],"type":["dbl"],"align":["right"]},{"label":["se.exposure"],"name":[25],"type":["dbl"],"align":["right"]},{"label":["z.exposure"],"name":[26],"type":["dbl"],"align":["right"]},{"label":["pval.exposure"],"name":[27],"type":["dbl"],"align":["right"]},{"label":["samplesize.exposure"],"name":[28],"type":["dbl"],"align":["right"]},{"label":["exposure"],"name":[29],"type":["chr"],"align":["left"]},{"label":["mr_keep.exposure"],"name":[30],"type":["lgl"],"align":["right"]},{"label":["pval_origin.exposure"],"name":[31],"type":["chr"],"align":["left"]},{"label":["id.exposure"],"name":[32],"type":["chr"],"align":["left"]},{"label":["action"],"name":[33],"type":["dbl"],"align":["right"]},{"label":["mr_keep"],"name":[34],"type":["lgl"],"align":["right"]},{"label":["pt"],"name":[35],"type":["dbl"],"align":["right"]},{"label":["pleitropy_keep"],"name":[36],"type":["lgl"],"align":["right"]},{"label":["mrpresso_RSSobs"],"name":[37],"type":["dbl"],"align":["right"]},{"label":["mrpresso_pval"],"name":[38],"type":["chr"],"align":["left"]},{"label":["mrpresso_keep"],"name":[39],"type":["lgl"],"align":["right"]}],"data":[{"1":"rs11242678","2":"T","3":"C","4":"T","5":"C","6":"0.0723","7":"0.03066300","8":"0.2550","9":"0.2545","10":"FALSE","11":"FALSE","12":"FALSE","13":"XpNJpw","14":"6","15":"1337180","16":"0.023022","17":"1.33189992","18":"1.8289e-01","19":"1639435","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"6","24":"1337180","25":"0.0114","26":"6.342105","27":"2.703e-10","28":"440328","29":"Malik2018ais","30":"TRUE","31":"reported","32":"joDf7q","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"5.245891e-04","38":"1","39":"TRUE"},{"1":"rs2066864","2":"A","3":"G","4":"A","5":"G","6":"0.0634","7":"0.00963230","8":"0.2452","9":"0.2483","10":"FALSE","11":"FALSE","12":"FALSE","13":"XpNJpw","14":"4","15":"155525695","16":"0.023137","17":"0.41631586","18":"6.7719e-01","19":"1639838","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"4","24":"155525695","25":"0.0115","26":"5.513043","27":"3.514e-08","28":"440328","29":"Malik2018ais","30":"TRUE","31":"reported","32":"joDf7q","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"3.545765e-07","38":"1","39":"TRUE"},{"1":"rs2107595","2":"A","3":"G","4":"A","5":"G","6":"0.0882","7":"-0.00094859","8":"0.1673","9":"0.1656","10":"FALSE","11":"FALSE","12":"FALSE","13":"XpNJpw","14":"7","15":"19049388","16":"0.029275","17":"-0.03240273","18":"9.7415e-01","19":"1629782","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"7","24":"19049388","25":"0.0132","26":"6.681818","27":"2.328e-11","28":"440328","29":"Malik2018ais","30":"TRUE","31":"reported","32":"joDf7q","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"2.304714e-04","38":"1","39":"TRUE"},{"1":"rs2634074","2":"A","3":"T","4":"A","5":"T","6":"-0.0941","7":"0.04574200","8":"0.7877","9":"0.7816","10":"FALSE","11":"TRUE","12":"FALSE","13":"XpNJpw","14":"4","15":"111677041","16":"0.025548","17":"1.79043369","18":"7.3384e-02","19":"1629782","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"4","24":"111677041","25":"0.0121","26":"-7.776860","27":"5.905e-15","28":"440328","29":"Malik2018ais","30":"TRUE","31":"reported","32":"joDf7q","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"4.930456e-03","38":"0.0576","39":"TRUE"},{"1":"rs2758612","2":"C","3":"T","4":"C","5":"T","6":"-0.0653","7":"-0.04600100","8":"0.3547","9":"0.3512","10":"FALSE","11":"FALSE","12":"FALSE","13":"XpNJpw","14":"1","15":"156200671","16":"0.020380","17":"-2.25716389","18":"2.3999e-02","19":"1639838","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"1","24":"156205301","25":"0.0111","26":"-5.882880","27":"3.677e-09","28":"440328","29":"Malik2018ais","30":"TRUE","31":"reported","32":"joDf7q","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"1.727317e-03","38":"0.3609","39":"TRUE"},{"1":"rs3184504","2":"C","3":"T","4":"C","5":"T","6":"-0.0779","7":"0.05395100","8":"0.5278","9":"0.5240","10":"FALSE","11":"FALSE","12":"FALSE","13":"XpNJpw","14":"12","15":"111884608","16":"0.021584","17":"2.49958302","18":"1.2435e-02","19":"1628824","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"12","24":"111884608","25":"0.0101","26":"-7.712870","27":"1.229e-14","28":"440328","29":"Malik2018ais","30":"TRUE","31":"reported","32":"joDf7q","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"5.872095e-03","38":"0.0063","39":"FALSE"},{"1":"rs473238","2":"C","3":"T","4":"C","5":"T","6":"-0.0831","7":"-0.03532600","8":"0.8674","9":"0.8466","10":"FALSE","11":"FALSE","12":"FALSE","13":"XpNJpw","14":"11","15":"102700360","16":"0.031470","17":"-1.12252939","18":"2.6164e-01","19":"1628824","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"11","24":"102700360","25":"0.0147","26":"-5.653060","27":"1.651e-08","28":"440328","29":"Malik2018ais","30":"TRUE","31":"reported","32":"joDf7q","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"6.482652e-04","38":"1","39":"TRUE"},{"1":"rs4942561","2":"T","3":"G","4":"T","5":"G","6":"0.0655","7":"-0.02997400","8":"0.7590","9":"0.7566","10":"FALSE","11":"FALSE","12":"FALSE","13":"XpNJpw","14":"13","15":"47209347","16":"0.022929","17":"-1.30725282","18":"1.9112e-01","19":"1639838","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"13","24":"47209347","25":"0.0116","26":"5.646552","27":"1.771e-08","28":"440328","29":"Malik2018ais","30":"TRUE","31":"reported","32":"joDf7q","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"1.888149e-03","38":"0.5499","39":"TRUE"},{"1":"rs635634","2":"T","3":"C","4":"T","5":"C","6":"0.0772","7":"0.15270000","8":"0.1921","9":"0.1948","10":"FALSE","11":"FALSE","12":"FALSE","13":"XpNJpw","14":"9","15":"136155000","16":"0.026845","17":"5.68821000","18":"1.2830e-08","19":"1629782","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"9","24":"136155000","25":"0.0134","26":"5.761194","27":"9.179e-09","28":"440328","29":"Malik2018ais","30":"TRUE","31":"reported","32":"joDf7q","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"2.451288e-02","38":"<9e-04","39":"FALSE"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

SNPs that genome-wide significant in the outcome GWAS are likely pleitorpic and should be removed from analysis. Additionaly remove variants within the APOE locus by exclude variants 1MB either side of APOE e4 (rs429358 = 19:45411941, GRCh37.p13)
<br>


**Table 5:** SNPs that were genome-wide significant in the COVID: A2 GWAS
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
{"columns":[{"label":["outliers_removed"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["pve.exposure"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["F"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["Alpha"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["NCP"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["Power"],"name":[6],"type":["dbl"],"align":["right"]}],"data":[{"1":"FALSE","2":"0.0008338516","3":"40.82959","4":"0.05","5":"4.5081626","6":"0.564873"},{"1":"TRUE","2":"0.0006226178","3":"39.18884","4":"0.05","5":"0.7312236","6":"0.137051"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

The I2_GX statistic can be used to quantify the strength of the NOME violation for MR-Egger regression and should be used to evalute potential bias in the MR-Egger causal estimate, with values less then 90% indicating that causal estimated should interpreted with caution due to regression diluation.

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["outliers_removed"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["Isq_gx"],"name":[2],"type":["dbl"],"align":["right"]}],"data":[{"1":"FALSE","2":"0"},{"1":"TRUE","2":"0"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>


## MR Results
To obtain an overall estimate of causal effect, the SNP-exposure and SNP-outcome coefficients were combined in 1) a fixed-effects meta-analysis using an inverse-variance weighted approach (IVW); 2) a Weighted Median approach; 3) Weighted Mode approach and 4) Egger Regression.


[**IVW**](https://doi.org/10.1002/gepi.21758) is equivalent to a weighted regression of the SNP-outcome coefficients on the SNP-exposure coefficients with the intercept constrained to zero. This method assumes that all variants are valid instrumental variables based on the Mendelian randomization assumptions. The causal estimate of the IVW analysis expresses the causal increase in the outcome (or log odds of the outcome for a binary outcome) per unit change in the exposure. [**Weighted median MR**](https://doi.org/10.1002/gepi.21965) allows for 50% of the instrumental variables to be invalid. [**MR-Egger regression**](https://doi.org/10.1093/ije/dyw220) allows all the instrumental variables to be subject to direct effects (i.e. horizontal pleiotropy), with the intercept representing bias in the causal estimate due to pleiotropy and the slope representing the causal estimate. [**Weighted Mode**](https://doi.org/10.1093/ije/dyx102) gives consistent estimates as the sample size increases if a plurality (or weighted plurality) of the genetic variants are valid instruments.
<br>



Table 6 presents the MR causal estimates of genetically predicted Ischemic Stroke on COVID: A2.
<br>

**Table 6** MR causaul estimates for Ischemic Stroke on COVID: A2
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["method"],"name":[5],"type":["chr"],"align":["left"]},{"label":["nsnp"],"name":[6],"type":["int"],"align":["right"]},{"label":["b"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"joDf7q","2":"XpNJpw","3":"covidhgi2020A2v6alleur","4":"Malik2018ais","5":"Inverse variance weighted (fixed effects)","6":"9","7":"0.14335017","8":"0.1073901","9":"0.1819241"},{"1":"joDf7q","2":"XpNJpw","3":"covidhgi2020A2v6alleur","4":"Malik2018ais","5":"Weighted median","6":"9","7":"0.03192836","8":"0.1777434","9":"0.8574417"},{"1":"joDf7q","2":"XpNJpw","3":"covidhgi2020A2v6alleur","4":"Malik2018ais","5":"Weighted mode","6":"9","7":"-0.11490246","8":"0.3269715","9":"0.7343534"},{"1":"joDf7q","2":"XpNJpw","3":"covidhgi2020A2v6alleur","4":"Malik2018ais","5":"MR Egger","6":"9","7":"-1.15983894","8":"2.1152247","9":"0.6005079"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Figure 1 illustrates the SNP-specific associations with Ischemic Stroke versus the association in COVID: A2 and the corresponding MR estimates.
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/harern01/projects/MRcovid/results/MRcovideurv6/Malik2018ais/covidhgi2020A2v6alleur/Malik2018ais_5e-8_covidhgi2020A2v6alleur_MR_Analaysis_files/figure-html/scatter_plot-1.png" alt="Fig. 1: Scatterplot of SNP effects for the association of the Exposure on the Outcome"  />
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
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["method"],"name":[5],"type":["chr"],"align":["left"]},{"label":["Q"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["Q_df"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["Q_pval"],"name":[8],"type":["dbl"],"align":["right"]}],"data":[{"1":"joDf7q","2":"XpNJpw","3":"covidhgi2020A2v6alleur","4":"Malik2018ais","5":"MR Egger","6":"47.42236","7":"7","8":"4.617130e-08"},{"1":"joDf7q","2":"XpNJpw","3":"covidhgi2020A2v6alleur","4":"Malik2018ais","5":"Inverse variance weighted","6":"50.03956","7":"8","8":"4.015834e-08"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Figure 2 shows a funnel plot displaying the MR estimates of individual genetic variants against their precession. Aysmmetry in the funnel plot may arrise due to some genetic variants having unusally strong effects on the outcome, which is indicative of directional pleiotropy.
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/harern01/projects/MRcovid/results/MRcovideurv6/Malik2018ais/covidhgi2020A2v6alleur/Malik2018ais_5e-8_covidhgi2020A2v6alleur_MR_Analaysis_files/figure-html/funnel_plot-1.png" alt="Fig. 2: Funnel plot of the MR causal estimates against their precession"  />
<p class="caption">Fig. 2: Funnel plot of the MR causal estimates against their precession</p>
</div>
<br>

Figure 3 shows a [Radial Plots](https://github.com/WSpiller/RadialMR) can be used to visualize influential data points with large contributions to Cochran's Q Statistic that may bias causal effect estimates.



<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/harern01/projects/MRcovid/results/MRcovideurv6/Malik2018ais/covidhgi2020A2v6alleur/Malik2018ais_5e-8_covidhgi2020A2v6alleur_MR_Analaysis_files/figure-html/Radial_Plot-1.png" alt="Fig. 4: Radial Plot showing influential data points using Radial IVW"  />
<p class="caption">Fig. 4: Radial Plot showing influential data points using Radial IVW</p>
</div>
<br>

The intercept of the MR-Egger Regression model captures the average pleitropic affect across all genetic variants (Table 8).
<br>

**Table 8:** MR Egger test for directional pleitropy
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["egger_intercept"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[7],"type":["dbl"],"align":["right"]}],"data":[{"1":"joDf7q","2":"XpNJpw","3":"covidhgi2020A2v6alleur","4":"Malik2018ais","5":"0.09895069","6":"0.1591998","7":"0.5539321"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Pleiotropy was also assesed using Mendelian Randomization Pleiotropy RESidual Sum and Outlier [(MR-PRESSO)](https://doi.org/10.1038/s41588-018-0099-7), that allows for the evlation of evaluation of horizontal pleiotropy in a standared MR model (Table 9). MR-PRESSO performs a global test for detection of horizontal pleiotropy and correction of pleiotropy via outlier removal (Table 10).
<br>

**Table 9:** MR-PRESSO Global Test for pleitropy
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["pt"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["outliers_removed"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["n_outliers"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["RSSobs"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["chr"],"align":["left"]}],"data":[{"1":"joDf7q","2":"XpNJpw","3":"covidhgi2020A2v6alleur","4":"Malik2018ais","5":"5e-08","6":"FALSE","7":"2","8":"63.83742","9":"<1e-04"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>


**Table 10:** MR Estimates after MR-PRESSO outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["method"],"name":[5],"type":["chr"],"align":["left"]},{"label":["nsnp"],"name":[6],"type":["int"],"align":["right"]},{"label":["b"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"joDf7q","2":"XpNJpw","3":"covidhgi2020A2v6alleur","4":"Malik2018ais","5":"Inverse variance weighted (fixed effects)","6":"7","7":"0.07786301","8":"0.1236413","9":"0.5288586"},{"1":"joDf7q","2":"XpNJpw","3":"covidhgi2020A2v6alleur","4":"Malik2018ais","5":"Weighted median","6":"7","7":"0.10666917","8":"0.1820408","9":"0.5579003"},{"1":"joDf7q","2":"XpNJpw","3":"covidhgi2020A2v6alleur","4":"Malik2018ais","5":"Weighted mode","6":"7","7":"0.35237194","8":"0.4056028","9":"0.4183682"},{"1":"joDf7q","2":"XpNJpw","3":"covidhgi2020A2v6alleur","4":"Malik2018ais","5":"MR Egger","6":"7","7":"-1.24966433","8":"1.1754422","9":"0.3363438"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/harern01/projects/MRcovid/results/MRcovideurv6/Malik2018ais/covidhgi2020A2v6alleur/Malik2018ais_5e-8_covidhgi2020A2v6alleur_MR_Analaysis_files/figure-html/scatter_plot_outlier-1.png" alt="Fig. 5: Scatterplot of SNP effects for the association of the Exposure on the Outcome after outlier removal"  />
<p class="caption">Fig. 5: Scatterplot of SNP effects for the association of the Exposure on the Outcome after outlier removal</p>
</div>
<br>

**Table 11:** Heterogenity Tests after outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["method"],"name":[5],"type":["chr"],"align":["left"]},{"label":["Q"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["Q_df"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["Q_pval"],"name":[8],"type":["dbl"],"align":["right"]}],"data":[{"1":"joDf7q","2":"XpNJpw","3":"covidhgi2020A2v6alleur","4":"Malik2018ais","5":"MR Egger","6":"10.16767","7":"5","8":"0.07062149"},{"1":"joDf7q","2":"XpNJpw","3":"covidhgi2020A2v6alleur","4":"Malik2018ais","5":"Inverse variance weighted","6":"12.82117","7":"6","8":"0.04596540"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

**Table 12:** MR Egger test for directional pleitropy after outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["egger_intercept"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[7],"type":["dbl"],"align":["right"]}],"data":[{"1":"joDf7q","2":"XpNJpw","3":"covidhgi2020A2v6alleur","4":"Malik2018ais","5":"0.1000864","6":"0.08761756","7":"0.3050588"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>
