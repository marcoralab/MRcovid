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
## NA/sc/arion/projects/LOAD/harern01/projects/MRcovidNULLdata/MRcovideurv6/Wuttke2019ckd/Wuttke2019ckd_5e-8_SNPs.txtdata/MRcovideurv6/Wuttke2019ckd/covidhgi2020A2v6alleur/Wuttke2019ckd_5e-8_covidhgi2020A2v6alleur_SNPs.txtdata/MRcovideurv6/Wuttke2019ckd/covidhgi2020A2v6alleur/Wuttke2019ckd_5e-8_covidhgi2020A2v6alleur_MatchedProxys.csvdata/MRcovideurv6/Wuttke2019ckd/covidhgi2020A2v6alleur/Wuttke2019ckd_5e-8_covidhgi2020A2v6alleur_mrpresso_MRdat.csvdata/MRcovideurv6/Wuttke2019ckd/covidhgi2020A2v6alleur/Wuttke2019ckd_5e-8_covidhgi2020A2v6alleur_mrpresso_global.txtdata/MRcovideurv6/Wuttke2019ckd/covidhgi2020A2v6alleur/Wuttke2019ckd_5e-8_covidhgi2020A2v6alleur_MR_power.txtcovidhgi2020A2v6alleurWuttke2019ckdCOVID: A2CKD5e-80.00110000results/MRcovideurv6/Wuttke2019ckd/covidhgi2020A2v6alleur/Wuttke2019ckd_5e-8_covidhgi2020A2v6alleur
```



## Instrumental Variables
**SNP Inclusion:** SNPS associated with at a p-value threshold of p < 5e-8 were included in this analysis.
<br>

**LD Clumping:** For standard two sample MR it is important to ensure that the instruments for the exposure are independent. LD clumping was performed in PLINK using the EUR samples from the 1000 Genomes Project to estimate LD between SNPs, and, amongst SNPs that have an LD above a given threshold, retain only the SNP with the lowest p-value. A clumping window of 10^{4}, r2 of 0.001 and significance level of 1 was used for the index and secondary SNPs.
<br>

**Proxy SNPs:** Where SNPs were not available in the outcome GWAS, the EUR thousand genomes was queried to identify potential proxy SNPs that are in linkage disequilibrium (r2 > 0.8) of the missing SNP.
<br>

### Exposure: CKD
`#r exposure.blurb`
<br>

**Table 1:** Independent SNPs associated with CKD
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["CHROM"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["REF"],"name":[4],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[5],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[12],"type":["chr"],"align":["left"]}],"data":[{"1":"rs2484639","2":"1","3":"243462367","4":"G","5":"A","6":"0.51","7":"-0.0774","8":"0.0092","9":"-8.413043","10":"2.950e-17","11":"438949","12":"CKD"},{"1":"rs13391258","2":"2","3":"73848933","4":"C","5":"T","6":"0.24","7":"-0.0600","8":"0.0108","9":"-5.555556","10":"2.738e-08","11":"444737","12":"CKD"},{"1":"rs2580350","2":"2","3":"121996007","4":"G","5":"A","6":"0.55","7":"0.0550","8":"0.0098","9":"5.612245","10":"1.691e-08","11":"402682","12":"CKD"},{"1":"rs187355703","2":"2","3":"176993583","4":"C","5":"G","6":"0.02","7":"0.1987","8":"0.0312","9":"6.368590","10":"1.801e-10","11":"401575","12":"CKD"},{"1":"rs62300825","2":"4","3":"77205319","4":"G","5":"A","6":"0.20","7":"-0.0949","8":"0.0116","9":"-8.181034","10":"2.629e-16","11":"444622","12":"CKD"},{"1":"rs1458038","2":"4","3":"81164723","4":"C","5":"T","6":"0.31","7":"-0.0590","8":"0.0100","9":"-5.900000","10":"4.206e-09","11":"440290","12":"CKD"},{"1":"rs700221","2":"5","3":"39357175","4":"A","5":"G","6":"0.41","7":"0.0719","8":"0.0098","9":"7.336730","10":"2.192e-13","11":"402682","12":"CKD"},{"1":"rs35716097","2":"5","3":"176806636","4":"C","5":"T","6":"0.32","7":"0.0785","8":"0.0105","9":"7.476190","10":"8.202e-14","11":"402682","12":"CKD"},{"1":"rs881858","2":"6","3":"43806609","4":"G","5":"A","6":"0.70","7":"0.0616","8":"0.0101","9":"6.099010","10":"1.189e-09","11":"439981","12":"CKD"},{"1":"rs9474801","2":"6","3":"54186999","4":"A","5":"G","6":"0.66","7":"-0.0522","8":"0.0096","9":"-5.437500","10":"4.606e-08","11":"444725","12":"CKD"},{"1":"rs12205178","2":"6","3":"160648923","4":"G","5":"A","6":"0.12","7":"0.0931","8":"0.0140","9":"6.650000","10":"3.087e-11","11":"444904","12":"CKD"},{"1":"rs11761603","2":"7","3":"1286912","4":"T","5":"C","6":"0.70","7":"0.0674","8":"0.0119","9":"5.663870","10":"1.352e-08","11":"341496","12":"CKD"},{"1":"rs10224002","2":"7","3":"151415041","4":"A","5":"G","6":"0.28","7":"0.1083","8":"0.0102","9":"10.617600","10":"2.651e-26","11":"440290","12":"CKD"},{"1":"rs4871907","2":"8","3":"23786784","4":"C","5":"A","6":"0.55","7":"-0.0628","8":"0.0097","9":"-6.474227","10":"9.909e-11","11":"402682","12":"CKD"},{"1":"rs1889937","2":"9","3":"71403106","4":"G","5":"A","6":"0.63","7":"-0.0624","8":"0.0100","9":"-6.240000","10":"5.146e-10","11":"388729","12":"CKD"},{"1":"rs7908590","2":"10","3":"952523","4":"C","5":"G","6":"0.07","7":"0.1343","8":"0.0188","9":"7.143620","10":"8.993e-13","11":"402682","12":"CKD"},{"1":"rs3925584","2":"11","3":"30760335","4":"T","5":"C","6":"0.44","7":"-0.0800","8":"0.0092","9":"-8.695650","10":"4.675e-18","11":"440210","12":"CKD"},{"1":"rs77713116","2":"11","3":"65531109","4":"C","5":"G","6":"0.35","7":"0.0752","8":"0.0116","9":"6.482760","10":"1.031e-10","11":"306905","12":"CKD"},{"1":"rs7178881","2":"15","3":"39224897","4":"C","5":"A","6":"0.41","7":"-0.0544","8":"0.0092","9":"-5.913043","10":"4.140e-09","11":"444846","12":"CKD"},{"1":"rs1049518","2":"15","3":"45653367","4":"G","5":"A","6":"0.38","7":"0.0788","8":"0.0094","9":"8.382979","10":"5.422e-17","11":"440290","12":"CKD"},{"1":"rs17730281","2":"15","3":"53907948","4":"G","5":"A","6":"0.23","7":"-0.0869","8":"0.0110","9":"-7.900000","10":"2.677e-15","11":"440290","12":"CKD"},{"1":"rs77924615","2":"16","3":"20392332","4":"G","5":"A","6":"0.20","7":"-0.2237","8":"0.0128","9":"-17.476562","10":"6.383e-69","11":"402682","12":"CKD"},{"1":"rs8096658","2":"18","3":"77156537","4":"C","5":"G","6":"0.49","7":"0.0640","8":"0.0110","9":"5.818180","10":"5.168e-09","11":"353141","12":"CKD"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

### Outcome: COVID: A2
`#r outcome.blurb`
<br>

**Table 2:** SNPs associated with CKD avaliable in COVID: A2
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["CHROM"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["REF"],"name":[4],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[5],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[12],"type":["chr"],"align":["left"]}],"data":[{"1":"rs2484639","2":"1","3":"243462367","4":"G","5":"A","6":"0.52380","7":"0.02177900","8":"0.022500","9":"0.96795556","10":"0.33306","11":"1629782","12":"COVID_A2__EUR"},{"1":"rs13391258","2":"2","3":"73848933","4":"C","5":"T","6":"0.22200","7":"0.01162600","8":"0.022853","9":"0.50872971","10":"0.61093","11":"1638880","12":"COVID_A2__EUR"},{"1":"rs2580350","2":"2","3":"121996007","4":"G","5":"A","6":"0.56010","7":"-0.00458630","8":"0.021897","9":"-0.20944878","10":"0.83410","11":"1629058","12":"COVID_A2__EUR"},{"1":"rs187355703","2":"2","3":"176993583","4":"C","5":"G","6":"0.02381","7":"-0.00422940","8":"0.069170","9":"-0.06114501","10":"0.95124","11":"1635401","12":"COVID_A2__EUR"},{"1":"rs1458038","2":"4","3":"81164723","4":"C","5":"T","6":"0.29970","7":"0.00738310","8":"0.021361","9":"0.34563457","10":"0.72961","11":"1639838","12":"COVID_A2__EUR"},{"1":"rs700221","2":"5","3":"39357175","4":"A","5":"G","6":"0.40660","7":"0.01186000","8":"0.020132","9":"0.58911186","10":"0.55579","11":"1639435","12":"COVID_A2__EUR"},{"1":"rs35716097","2":"5","3":"176806636","4":"C","5":"T","6":"0.31520","7":"0.01043300","8":"0.020823","9":"0.50103251","10":"0.61636","11":"1639838","12":"COVID_A2__EUR"},{"1":"rs881858","2":"6","3":"43806609","4":"G","5":"A","6":"0.68800","7":"0.00819860","8":"0.024820","9":"0.33032232","10":"0.74115","11":"1629782","12":"COVID_A2__EUR"},{"1":"rs9474801","2":"6","3":"54186999","4":"A","5":"G","6":"0.67210","7":"-0.03250900","8":"0.020539","9":"-1.58279371","10":"0.11347","11":"1639838","12":"COVID_A2__EUR"},{"1":"rs12205178","2":"6","3":"160648923","4":"G","5":"A","6":"0.11860","7":"0.01125300","8":"0.030925","9":"0.36388036","10":"0.71595","11":"1638880","12":"COVID_A2__EUR"},{"1":"rs11761603","2":"7","3":"1286912","4":"T","5":"C","6":"0.68370","7":"0.00571880","8":"0.023821","9":"0.24007388","10":"0.81027","11":"1629058","12":"COVID_A2__EUR"},{"1":"rs10224002","2":"7","3":"151415041","4":"A","5":"G","6":"0.28260","7":"0.00753510","8":"0.021078","9":"0.35748648","10":"0.72073","11":"1639838","12":"COVID_A2__EUR"},{"1":"rs4871907","2":"8","3":"23786784","4":"C","5":"A","6":"0.54050","7":"0.00657860","8":"0.021860","9":"0.30094236","10":"0.76346","11":"1629782","12":"COVID_A2__EUR"},{"1":"rs1889937","2":"9","3":"71403106","4":"G","5":"A","6":"0.63260","7":"0.02950600","8":"0.023761","9":"1.24178275","10":"0.21431","11":"1628100","12":"COVID_A2__EUR"},{"1":"rs7908590","2":"10","3":"952523","4":"C","5":"G","6":"0.06860","7":"0.01570500","8":"0.037272","9":"0.42136188","10":"0.67349","11":"1639838","12":"COVID_A2__EUR"},{"1":"rs3925584","2":"11","3":"30760335","4":"T","5":"C","6":"0.45940","7":"-0.00071911","8":"0.019320","9":"-0.03722101","10":"0.97031","11":"1638880","12":"COVID_A2__EUR"},{"1":"rs77713116","2":"11","3":"65531109","4":"C","5":"G","6":"0.36790","7":"0.02928900","8":"0.024918","9":"1.17541536","10":"0.23983","11":"1513551","12":"COVID_A2__EUR"},{"1":"rs7178881","2":"15","3":"39224897","4":"C","5":"A","6":"0.39520","7":"-0.00373250","8":"0.019913","9":"-0.18744037","10":"0.85131","11":"1639114","12":"COVID_A2__EUR"},{"1":"rs1049518","2":"15","3":"45653367","4":"G","5":"A","6":"0.38520","7":"0.01476800","8":"0.022078","9":"0.66890117","10":"0.50355","11":"1628421","12":"COVID_A2__EUR"},{"1":"rs17730281","2":"15","3":"53907948","4":"G","5":"A","6":"0.22590","7":"0.01040900","8":"0.023626","9":"0.44057394","10":"0.65950","11":"1639838","12":"COVID_A2__EUR"},{"1":"rs77924615","2":"16","3":"20392332","4":"G","5":"A","6":"0.19970","7":"-0.04120400","8":"0.028453","9":"-1.44814255","10":"0.14757","11":"1629782","12":"COVID_A2__EUR"},{"1":"rs8096658","2":"18","3":"77156537","4":"C","5":"G","6":"0.47610","7":"-0.01312800","8":"0.023212","9":"-0.56556953","10":"0.57169","11":"1629379","12":"COVID_A2__EUR"},{"1":"rs62300825","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

**Table 3:** Proxy SNPs for COVID: A2
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["target_snp"],"name":[1],"type":["chr"],"align":["left"]},{"label":["proxy_snp"],"name":[2],"type":["chr"],"align":["left"]},{"label":["ld.r2"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["Dprime"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["PHASE"],"name":[5],"type":["chr"],"align":["left"]},{"label":["X12"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["CHROM"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["REF.proxy"],"name":[9],"type":["lgl"],"align":["right"]},{"label":["ALT.proxy"],"name":[10],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[12],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[13],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[14],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[15],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[16],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[17],"type":["chr"],"align":["left"]},{"label":["ref"],"name":[18],"type":["chr"],"align":["left"]},{"label":["ref.proxy"],"name":[19],"type":["lgl"],"align":["right"]},{"label":["alt"],"name":[20],"type":["chr"],"align":["left"]},{"label":["alt.proxy"],"name":[21],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[22],"type":["chr"],"align":["left"]},{"label":["REF"],"name":[23],"type":["chr"],"align":["left"]},{"label":["proxy.outcome"],"name":[24],"type":["lgl"],"align":["right"]}],"data":[{"1":"rs62300825","2":"rs2869881","3":"1","4":"1","5":"AT/GC","6":"NA","7":"4","8":"77205745","9":"TRUE","10":"C","11":"0.793","12":"0.043953","13":"0.029463","14":"1.491803","15":"0.13576","16":"1514509","17":"COVID_A2__EUR","18":"A","19":"TRUE","20":"G","21":"C","22":"G","23":"A","24":"TRUE"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

## Data harmonization
Harmonize the exposure and outcome datasets so that the effect of a SNP on the exposure and the effect of that SNP on the outcome correspond to the same allele. The harmonise_data function from the TwoSampleMR package can be used to perform the harmonization step, by default it try's to infer the forward strand alleles using allele frequency information.
<br>

**Table 4:** Harmonized CKD and COVID: A2 datasets
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["effect_allele.exposure"],"name":[2],"type":["chr"],"align":["left"]},{"label":["other_allele.exposure"],"name":[3],"type":["chr"],"align":["left"]},{"label":["effect_allele.outcome"],"name":[4],"type":["chr"],"align":["left"]},{"label":["other_allele.outcome"],"name":[5],"type":["chr"],"align":["left"]},{"label":["beta.exposure"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["beta.outcome"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["eaf.exposure"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["eaf.outcome"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["remove"],"name":[10],"type":["lgl"],"align":["right"]},{"label":["palindromic"],"name":[11],"type":["lgl"],"align":["right"]},{"label":["ambiguous"],"name":[12],"type":["lgl"],"align":["right"]},{"label":["id.outcome"],"name":[13],"type":["chr"],"align":["left"]},{"label":["chr.outcome"],"name":[14],"type":["dbl"],"align":["right"]},{"label":["pos.outcome"],"name":[15],"type":["dbl"],"align":["right"]},{"label":["se.outcome"],"name":[16],"type":["dbl"],"align":["right"]},{"label":["z.outcome"],"name":[17],"type":["dbl"],"align":["right"]},{"label":["pval.outcome"],"name":[18],"type":["dbl"],"align":["right"]},{"label":["samplesize.outcome"],"name":[19],"type":["dbl"],"align":["right"]},{"label":["outcome"],"name":[20],"type":["chr"],"align":["left"]},{"label":["mr_keep.outcome"],"name":[21],"type":["lgl"],"align":["right"]},{"label":["pval_origin.outcome"],"name":[22],"type":["chr"],"align":["left"]},{"label":["chr.exposure"],"name":[23],"type":["dbl"],"align":["right"]},{"label":["pos.exposure"],"name":[24],"type":["dbl"],"align":["right"]},{"label":["se.exposure"],"name":[25],"type":["dbl"],"align":["right"]},{"label":["z.exposure"],"name":[26],"type":["dbl"],"align":["right"]},{"label":["pval.exposure"],"name":[27],"type":["dbl"],"align":["right"]},{"label":["samplesize.exposure"],"name":[28],"type":["dbl"],"align":["right"]},{"label":["exposure"],"name":[29],"type":["chr"],"align":["left"]},{"label":["mr_keep.exposure"],"name":[30],"type":["lgl"],"align":["right"]},{"label":["pval_origin.exposure"],"name":[31],"type":["chr"],"align":["left"]},{"label":["id.exposure"],"name":[32],"type":["chr"],"align":["left"]},{"label":["action"],"name":[33],"type":["dbl"],"align":["right"]},{"label":["mr_keep"],"name":[34],"type":["lgl"],"align":["right"]},{"label":["pt"],"name":[35],"type":["dbl"],"align":["right"]},{"label":["pleitropy_keep"],"name":[36],"type":["lgl"],"align":["right"]},{"label":["mrpresso_RSSobs"],"name":[37],"type":["lgl"],"align":["right"]},{"label":["mrpresso_pval"],"name":[38],"type":["lgl"],"align":["right"]},{"label":["mrpresso_keep"],"name":[39],"type":["lgl"],"align":["right"]}],"data":[{"1":"rs10224002","2":"G","3":"A","4":"G","5":"A","6":"0.1083","7":"0.00753510","8":"0.28","9":"0.28260","10":"FALSE","11":"FALSE","12":"FALSE","13":"juonjt","14":"7","15":"151415041","16":"0.021078","17":"0.35748648","18":"0.72073","19":"1639838","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"7","24":"151415041","25":"0.0102","26":"10.617600","27":"2.651e-26","28":"440290","29":"Wuttke2019ckd","30":"TRUE","31":"reported","32":"zd7f4x","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs1049518","2":"A","3":"G","4":"A","5":"G","6":"0.0788","7":"0.01476800","8":"0.38","9":"0.38520","10":"FALSE","11":"FALSE","12":"FALSE","13":"juonjt","14":"15","15":"45653367","16":"0.022078","17":"0.66890117","18":"0.50355","19":"1628421","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"15","24":"45653367","25":"0.0094","26":"8.382979","27":"5.422e-17","28":"440290","29":"Wuttke2019ckd","30":"TRUE","31":"reported","32":"zd7f4x","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs11761603","2":"C","3":"T","4":"C","5":"T","6":"0.0674","7":"0.00571880","8":"0.70","9":"0.68370","10":"FALSE","11":"FALSE","12":"FALSE","13":"juonjt","14":"7","15":"1286912","16":"0.023821","17":"0.24007388","18":"0.81027","19":"1629058","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"7","24":"1286912","25":"0.0119","26":"5.663870","27":"1.352e-08","28":"341496","29":"Wuttke2019ckd","30":"TRUE","31":"reported","32":"zd7f4x","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs12205178","2":"A","3":"G","4":"A","5":"G","6":"0.0931","7":"0.01125300","8":"0.12","9":"0.11860","10":"FALSE","11":"FALSE","12":"FALSE","13":"juonjt","14":"6","15":"160648923","16":"0.030925","17":"0.36388036","18":"0.71595","19":"1638880","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"6","24":"160648923","25":"0.0140","26":"6.650000","27":"3.087e-11","28":"444904","29":"Wuttke2019ckd","30":"TRUE","31":"reported","32":"zd7f4x","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs13391258","2":"T","3":"C","4":"T","5":"C","6":"-0.0600","7":"0.01162600","8":"0.24","9":"0.22200","10":"FALSE","11":"FALSE","12":"FALSE","13":"juonjt","14":"2","15":"73848933","16":"0.022853","17":"0.50872971","18":"0.61093","19":"1638880","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"2","24":"73848933","25":"0.0108","26":"-5.555556","27":"2.738e-08","28":"444737","29":"Wuttke2019ckd","30":"TRUE","31":"reported","32":"zd7f4x","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs1458038","2":"T","3":"C","4":"T","5":"C","6":"-0.0590","7":"0.00738310","8":"0.31","9":"0.29970","10":"FALSE","11":"FALSE","12":"FALSE","13":"juonjt","14":"4","15":"81164723","16":"0.021361","17":"0.34563457","18":"0.72961","19":"1639838","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"4","24":"81164723","25":"0.0100","26":"-5.900000","27":"4.206e-09","28":"440290","29":"Wuttke2019ckd","30":"TRUE","31":"reported","32":"zd7f4x","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs17730281","2":"A","3":"G","4":"A","5":"G","6":"-0.0869","7":"0.01040900","8":"0.23","9":"0.22590","10":"FALSE","11":"FALSE","12":"FALSE","13":"juonjt","14":"15","15":"53907948","16":"0.023626","17":"0.44057394","18":"0.65950","19":"1639838","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"15","24":"53907948","25":"0.0110","26":"-7.900000","27":"2.677e-15","28":"440290","29":"Wuttke2019ckd","30":"TRUE","31":"reported","32":"zd7f4x","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs187355703","2":"G","3":"C","4":"G","5":"C","6":"0.1987","7":"-0.00422940","8":"0.02","9":"0.02381","10":"FALSE","11":"TRUE","12":"FALSE","13":"juonjt","14":"2","15":"176993583","16":"0.069170","17":"-0.06114501","18":"0.95124","19":"1635401","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"2","24":"176993583","25":"0.0312","26":"6.368590","27":"1.801e-10","28":"401575","29":"Wuttke2019ckd","30":"TRUE","31":"reported","32":"zd7f4x","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs1889937","2":"A","3":"G","4":"A","5":"G","6":"-0.0624","7":"0.02950600","8":"0.63","9":"0.63260","10":"FALSE","11":"FALSE","12":"FALSE","13":"juonjt","14":"9","15":"71403106","16":"0.023761","17":"1.24178275","18":"0.21431","19":"1628100","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"9","24":"71403106","25":"0.0100","26":"-6.240000","27":"5.146e-10","28":"388729","29":"Wuttke2019ckd","30":"TRUE","31":"reported","32":"zd7f4x","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs2484639","2":"A","3":"G","4":"A","5":"G","6":"-0.0774","7":"0.02177900","8":"0.51","9":"0.52380","10":"FALSE","11":"FALSE","12":"FALSE","13":"juonjt","14":"1","15":"243462367","16":"0.022500","17":"0.96795556","18":"0.33306","19":"1629782","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"1","24":"243462367","25":"0.0092","26":"-8.413043","27":"2.950e-17","28":"438949","29":"Wuttke2019ckd","30":"TRUE","31":"reported","32":"zd7f4x","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs2580350","2":"A","3":"G","4":"A","5":"G","6":"0.0550","7":"-0.00458630","8":"0.55","9":"0.56010","10":"FALSE","11":"FALSE","12":"FALSE","13":"juonjt","14":"2","15":"121996007","16":"0.021897","17":"-0.20944878","18":"0.83410","19":"1629058","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"2","24":"121996007","25":"0.0098","26":"5.612245","27":"1.691e-08","28":"402682","29":"Wuttke2019ckd","30":"TRUE","31":"reported","32":"zd7f4x","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs35716097","2":"T","3":"C","4":"T","5":"C","6":"0.0785","7":"0.01043300","8":"0.32","9":"0.31520","10":"FALSE","11":"FALSE","12":"FALSE","13":"juonjt","14":"5","15":"176806636","16":"0.020823","17":"0.50103251","18":"0.61636","19":"1639838","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"5","24":"176806636","25":"0.0105","26":"7.476190","27":"8.202e-14","28":"402682","29":"Wuttke2019ckd","30":"TRUE","31":"reported","32":"zd7f4x","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs3925584","2":"C","3":"T","4":"C","5":"T","6":"-0.0800","7":"-0.00071911","8":"0.44","9":"0.45940","10":"FALSE","11":"FALSE","12":"FALSE","13":"juonjt","14":"11","15":"30760335","16":"0.019320","17":"-0.03722101","18":"0.97031","19":"1638880","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"11","24":"30760335","25":"0.0092","26":"-8.695650","27":"4.675e-18","28":"440210","29":"Wuttke2019ckd","30":"TRUE","31":"reported","32":"zd7f4x","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs4871907","2":"A","3":"C","4":"A","5":"C","6":"-0.0628","7":"0.00657860","8":"0.55","9":"0.54050","10":"FALSE","11":"FALSE","12":"FALSE","13":"juonjt","14":"8","15":"23786784","16":"0.021860","17":"0.30094236","18":"0.76346","19":"1629782","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"8","24":"23786784","25":"0.0097","26":"-6.474227","27":"9.909e-11","28":"402682","29":"Wuttke2019ckd","30":"TRUE","31":"reported","32":"zd7f4x","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs62300825","2":"A","3":"G","4":"A","5":"G","6":"-0.0949","7":"-0.04395300","8":"0.20","9":"0.20700","10":"FALSE","11":"FALSE","12":"FALSE","13":"juonjt","14":"4","15":"77205745","16":"0.029463","17":"1.49180328","18":"0.13576","19":"1514509","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"4","24":"77205319","25":"0.0116","26":"-8.181034","27":"2.629e-16","28":"444622","29":"Wuttke2019ckd","30":"TRUE","31":"reported","32":"zd7f4x","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs700221","2":"G","3":"A","4":"G","5":"A","6":"0.0719","7":"0.01186000","8":"0.41","9":"0.40660","10":"FALSE","11":"FALSE","12":"FALSE","13":"juonjt","14":"5","15":"39357175","16":"0.020132","17":"0.58911186","18":"0.55579","19":"1639435","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"5","24":"39357175","25":"0.0098","26":"7.336730","27":"2.192e-13","28":"402682","29":"Wuttke2019ckd","30":"TRUE","31":"reported","32":"zd7f4x","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs7178881","2":"A","3":"C","4":"A","5":"C","6":"-0.0544","7":"-0.00373250","8":"0.41","9":"0.39520","10":"FALSE","11":"FALSE","12":"FALSE","13":"juonjt","14":"15","15":"39224897","16":"0.019913","17":"-0.18744037","18":"0.85131","19":"1639114","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"15","24":"39224897","25":"0.0092","26":"-5.913043","27":"4.140e-09","28":"444846","29":"Wuttke2019ckd","30":"TRUE","31":"reported","32":"zd7f4x","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs77713116","2":"G","3":"C","4":"G","5":"C","6":"0.0752","7":"0.02928900","8":"0.35","9":"0.36790","10":"FALSE","11":"TRUE","12":"FALSE","13":"juonjt","14":"11","15":"65531109","16":"0.024918","17":"1.17541536","18":"0.23983","19":"1513551","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"11","24":"65531109","25":"0.0116","26":"6.482760","27":"1.031e-10","28":"306905","29":"Wuttke2019ckd","30":"TRUE","31":"reported","32":"zd7f4x","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs77924615","2":"A","3":"G","4":"A","5":"G","6":"-0.2237","7":"-0.04120400","8":"0.20","9":"0.19970","10":"FALSE","11":"FALSE","12":"FALSE","13":"juonjt","14":"16","15":"20392332","16":"0.028453","17":"-1.44814255","18":"0.14757","19":"1629782","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"16","24":"20392332","25":"0.0128","26":"-17.476562","27":"6.383e-69","28":"402682","29":"Wuttke2019ckd","30":"TRUE","31":"reported","32":"zd7f4x","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs7908590","2":"G","3":"C","4":"G","5":"C","6":"0.1343","7":"0.01570500","8":"0.07","9":"0.06860","10":"FALSE","11":"TRUE","12":"FALSE","13":"juonjt","14":"10","15":"952523","16":"0.037272","17":"0.42136188","18":"0.67349","19":"1639838","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"10","24":"952523","25":"0.0188","26":"7.143620","27":"8.993e-13","28":"402682","29":"Wuttke2019ckd","30":"TRUE","31":"reported","32":"zd7f4x","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs8096658","2":"G","3":"C","4":"G","5":"C","6":"0.0640","7":"-0.01312800","8":"0.49","9":"0.47610","10":"FALSE","11":"TRUE","12":"TRUE","13":"juonjt","14":"18","15":"77156537","16":"0.023212","17":"-0.56556953","18":"0.57169","19":"1629379","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"18","24":"77156537","25":"0.0110","26":"5.818180","27":"5.168e-09","28":"353141","29":"Wuttke2019ckd","30":"TRUE","31":"reported","32":"zd7f4x","33":"2","34":"FALSE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"NA"},{"1":"rs881858","2":"A","3":"G","4":"A","5":"G","6":"0.0616","7":"0.00819860","8":"0.70","9":"0.68800","10":"FALSE","11":"FALSE","12":"FALSE","13":"juonjt","14":"6","15":"43806609","16":"0.024820","17":"0.33032232","18":"0.74115","19":"1629782","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"6","24":"43806609","25":"0.0101","26":"6.099010","27":"1.189e-09","28":"439981","29":"Wuttke2019ckd","30":"TRUE","31":"reported","32":"zd7f4x","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs9474801","2":"G","3":"A","4":"G","5":"A","6":"-0.0522","7":"-0.03250900","8":"0.66","9":"0.67210","10":"FALSE","11":"FALSE","12":"FALSE","13":"juonjt","14":"6","15":"54186999","16":"0.020539","17":"-1.58279371","18":"0.11347","19":"1639838","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"6","24":"54186999","25":"0.0096","26":"-5.437500","27":"4.606e-08","28":"444725","29":"Wuttke2019ckd","30":"TRUE","31":"reported","32":"zd7f4x","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
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
{"columns":[{"label":["outliers_removed"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["pve.exposure"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["F"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["Alpha"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["NCP"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["Power"],"name":[6],"type":["dbl"],"align":["right"]}],"data":[{"1":"FALSE","2":"0.002072748","3":"62.26458","4":"0.05","5":"5.31533","6":"0.6351642"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

The I2_GX statistic can be used to quantify the strength of the NOME violation for MR-Egger regression and should be used to evalute potential bias in the MR-Egger causal estimate, with values less then 90% indicating that causal estimated should interpreted with caution due to regression diluation.

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["outliers_removed"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["Isq_gx"],"name":[2],"type":["dbl"],"align":["right"]}],"data":[{"1":"FALSE","2":"0.8480663"},{"1":"TRUE","2":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>


## MR Results
To obtain an overall estimate of causal effect, the SNP-exposure and SNP-outcome coefficients were combined in 1) a fixed-effects meta-analysis using an inverse-variance weighted approach (IVW); 2) a Weighted Median approach; 3) Weighted Mode approach and 4) Egger Regression.


[**IVW**](https://doi.org/10.1002/gepi.21758) is equivalent to a weighted regression of the SNP-outcome coefficients on the SNP-exposure coefficients with the intercept constrained to zero. This method assumes that all variants are valid instrumental variables based on the Mendelian randomization assumptions. The causal estimate of the IVW analysis expresses the causal increase in the outcome (or log odds of the outcome for a binary outcome) per unit change in the exposure. [**Weighted median MR**](https://doi.org/10.1002/gepi.21965) allows for 50% of the instrumental variables to be invalid. [**MR-Egger regression**](https://doi.org/10.1093/ije/dyw220) allows all the instrumental variables to be subject to direct effects (i.e. horizontal pleiotropy), with the intercept representing bias in the causal estimate due to pleiotropy and the slope representing the causal estimate. [**Weighted Mode**](https://doi.org/10.1093/ije/dyx102) gives consistent estimates as the sample size increases if a plurality (or weighted plurality) of the genetic variants are valid instruments.
<br>



Table 6 presents the MR causal estimates of genetically predicted CKD on COVID: A2.
<br>

**Table 6** MR causaul estimates for CKD on COVID: A2
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["method"],"name":[5],"type":["chr"],"align":["left"]},{"label":["nsnp"],"name":[6],"type":["int"],"align":["right"]},{"label":["b"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"zd7f4x","2":"juonjt","3":"covidhgi2020A2v6alleur","4":"Wuttke2019ckd","5":"Inverse variance weighted (fixed effects)","6":"22","7":"0.08684693","8":"0.05931026","9":"0.1431169"},{"1":"zd7f4x","2":"juonjt","3":"covidhgi2020A2v6alleur","4":"Wuttke2019ckd","5":"Weighted median","6":"22","7":"0.11924241","8":"0.08225331","9":"0.1471429"},{"1":"zd7f4x","2":"juonjt","3":"covidhgi2020A2v6alleur","4":"Wuttke2019ckd","5":"Weighted mode","6":"22","7":"0.13771201","8":"0.11137818","9":"0.2299473"},{"1":"zd7f4x","2":"juonjt","3":"covidhgi2020A2v6alleur","4":"Wuttke2019ckd","5":"MR Egger","6":"22","7":"0.20447537","8":"0.15525215","9":"0.2027124"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Figure 1 illustrates the SNP-specific associations with CKD versus the association in COVID: A2 and the corresponding MR estimates.
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/harern01/projects/MRcovid/results/MRcovideurv6/Wuttke2019ckd/covidhgi2020A2v6alleur/Wuttke2019ckd_5e-8_covidhgi2020A2v6alleur_MR_Analaysis_files/figure-html/scatter_plot-1.png" alt="Fig. 1: Scatterplot of SNP effects for the association of the Exposure on the Outcome"  />
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
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["method"],"name":[5],"type":["chr"],"align":["left"]},{"label":["Q"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["Q_df"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["Q_pval"],"name":[8],"type":["dbl"],"align":["right"]}],"data":[{"1":"zd7f4x","2":"juonjt","3":"covidhgi2020A2v6alleur","4":"Wuttke2019ckd","5":"MR Egger","6":"10.26921","7":"20","8":"0.9630236"},{"1":"zd7f4x","2":"juonjt","3":"covidhgi2020A2v6alleur","4":"Wuttke2019ckd","5":"Inverse variance weighted","6":"10.94135","7":"21","8":"0.9639167"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Figure 2 shows a funnel plot displaying the MR estimates of individual genetic variants against their precession. Aysmmetry in the funnel plot may arrise due to some genetic variants having unusally strong effects on the outcome, which is indicative of directional pleiotropy.
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/harern01/projects/MRcovid/results/MRcovideurv6/Wuttke2019ckd/covidhgi2020A2v6alleur/Wuttke2019ckd_5e-8_covidhgi2020A2v6alleur_MR_Analaysis_files/figure-html/funnel_plot-1.png" alt="Fig. 2: Funnel plot of the MR causal estimates against their precession"  />
<p class="caption">Fig. 2: Funnel plot of the MR causal estimates against their precession</p>
</div>
<br>

Figure 3 shows a [Radial Plots](https://github.com/WSpiller/RadialMR) can be used to visualize influential data points with large contributions to Cochran's Q Statistic that may bias causal effect estimates.




```
## [1] "No significant Outliers"
```

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/harern01/projects/MRcovid/results/MRcovideurv6/Wuttke2019ckd/covidhgi2020A2v6alleur/Wuttke2019ckd_5e-8_covidhgi2020A2v6alleur_MR_Analaysis_files/figure-html/Radial_Plot-1.png" alt="Fig. 4: Radial Plot showing influential data points using Radial IVW"  />
<p class="caption">Fig. 4: Radial Plot showing influential data points using Radial IVW</p>
</div>
<br>

The intercept of the MR-Egger Regression model captures the average pleitropic affect across all genetic variants (Table 8).
<br>

**Table 8:** MR Egger test for directional pleitropy
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["egger_intercept"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[7],"type":["dbl"],"align":["right"]}],"data":[{"1":"zd7f4x","2":"juonjt","3":"covidhgi2020A2v6alleur","4":"Wuttke2019ckd","5":"-0.01075339","6":"0.01311638","7":"0.4219684"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Pleiotropy was also assesed using Mendelian Randomization Pleiotropy RESidual Sum and Outlier [(MR-PRESSO)](https://doi.org/10.1038/s41588-018-0099-7), that allows for the evlation of evaluation of horizontal pleiotropy in a standared MR model (Table 9). MR-PRESSO performs a global test for detection of horizontal pleiotropy and correction of pleiotropy via outlier removal (Table 10).
<br>

**Table 9:** MR-PRESSO Global Test for pleitropy
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["pt"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["outliers_removed"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["n_outliers"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["RSSobs"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"zd7f4x","2":"juonjt","3":"covidhgi2020A2v6alleur","4":"Wuttke2019ckd","5":"5e-08","6":"FALSE","7":"0","8":"11.99952","9":"0.9667"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>


**Table 10:** MR Estimates after MR-PRESSO outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["method"],"name":[5],"type":["chr"],"align":["left"]},{"label":["nsnp"],"name":[6],"type":["int"],"align":["right"]},{"label":["b"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"zd7f4x","2":"juonjt","3":"covidhgi2020A2v6alleur","4":"Wuttke2019ckd","5":"Inverse variance weighted (fixed effects)","6":"22","7":"0.08684693","8":"0.05931026","9":"0.1431169"},{"1":"zd7f4x","2":"juonjt","3":"covidhgi2020A2v6alleur","4":"Wuttke2019ckd","5":"Weighted median","6":"22","7":"0.11924241","8":"0.08475915","9":"0.1594753"},{"1":"zd7f4x","2":"juonjt","3":"covidhgi2020A2v6alleur","4":"Wuttke2019ckd","5":"Weighted mode","6":"22","7":"0.13771201","8":"0.10001620","9":"0.1830465"},{"1":"zd7f4x","2":"juonjt","3":"covidhgi2020A2v6alleur","4":"Wuttke2019ckd","5":"MR Egger","6":"22","7":"0.20447537","8":"0.15525215","9":"0.2027124"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/harern01/projects/MRcovid/results/MRcovideurv6/Wuttke2019ckd/covidhgi2020A2v6alleur/Wuttke2019ckd_5e-8_covidhgi2020A2v6alleur_MR_Analaysis_files/figure-html/scatter_plot_outlier-1.png" alt="Fig. 5: Scatterplot of SNP effects for the association of the Exposure on the Outcome after outlier removal"  />
<p class="caption">Fig. 5: Scatterplot of SNP effects for the association of the Exposure on the Outcome after outlier removal</p>
</div>
<br>

**Table 11:** Heterogenity Tests after outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["method"],"name":[5],"type":["chr"],"align":["left"]},{"label":["Q"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["Q_df"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["Q_pval"],"name":[8],"type":["dbl"],"align":["right"]}],"data":[{"1":"zd7f4x","2":"juonjt","3":"covidhgi2020A2v6alleur","4":"Wuttke2019ckd","5":"MR Egger","6":"10.26921","7":"20","8":"0.9630236"},{"1":"zd7f4x","2":"juonjt","3":"covidhgi2020A2v6alleur","4":"Wuttke2019ckd","5":"Inverse variance weighted","6":"10.94135","7":"21","8":"0.9639167"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

**Table 12:** MR Egger test for directional pleitropy after outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["egger_intercept"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[7],"type":["dbl"],"align":["right"]}],"data":[{"1":"zd7f4x","2":"juonjt","3":"covidhgi2020A2v6alleur","4":"Wuttke2019ckd","5":"-0.01075339","6":"0.01311638","7":"0.4219684"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>
