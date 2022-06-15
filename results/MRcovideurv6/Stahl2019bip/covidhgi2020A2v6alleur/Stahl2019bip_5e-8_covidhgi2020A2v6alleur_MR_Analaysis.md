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
## NA/sc/arion/projects/LOAD/harern01/projects/MRcovidNULLdata/MRcovideurv6/Stahl2019bip/Stahl2019bip_5e-8_SNPs.txtdata/MRcovideurv6/Stahl2019bip/covidhgi2020A2v6alleur/Stahl2019bip_5e-8_covidhgi2020A2v6alleur_SNPs.txtdata/MRcovideurv6/Stahl2019bip/covidhgi2020A2v6alleur/Stahl2019bip_5e-8_covidhgi2020A2v6alleur_MatchedProxys.csvdata/MRcovideurv6/Stahl2019bip/covidhgi2020A2v6alleur/Stahl2019bip_5e-8_covidhgi2020A2v6alleur_mrpresso_MRdat.csvdata/MRcovideurv6/Stahl2019bip/covidhgi2020A2v6alleur/Stahl2019bip_5e-8_covidhgi2020A2v6alleur_mrpresso_global.txtdata/MRcovideurv6/Stahl2019bip/covidhgi2020A2v6alleur/Stahl2019bip_5e-8_covidhgi2020A2v6alleur_MR_power.txtcovidhgi2020A2v6alleurStahl2019bipCOVID: A2Bipolar Disorder5e-80.00110000results/MRcovideurv6/Stahl2019bip/covidhgi2020A2v6alleur/Stahl2019bip_5e-8_covidhgi2020A2v6alleur
```



## Instrumental Variables
**SNP Inclusion:** SNPS associated with at a p-value threshold of p < 5e-8 were included in this analysis.
<br>

**LD Clumping:** For standard two sample MR it is important to ensure that the instruments for the exposure are independent. LD clumping was performed in PLINK using the EUR samples from the 1000 Genomes Project to estimate LD between SNPs, and, amongst SNPs that have an LD above a given threshold, retain only the SNP with the lowest p-value. A clumping window of 10^{4}, r2 of 0.001 and significance level of 1 was used for the index and secondary SNPs.
<br>

**Proxy SNPs:** Where SNPs were not available in the outcome GWAS, the EUR thousand genomes was queried to identify potential proxy SNPs that are in linkage disequilibrium (r2 > 0.8) of the missing SNP.
<br>

### Exposure: Bipolar Disorder
`#r exposure.blurb`
<br>

**Table 1:** Independent SNPs associated with Bipolar Disorder
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["CHROM"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["REF"],"name":[4],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[5],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[12],"type":["chr"],"align":["left"]}],"data":[{"1":"rs4619651","2":"2","3":"97416153","4":"G","5":"A","6":"0.348837","7":"-0.08409926","8":"0.0144","9":"-5.840226","10":"5.968978e-09","11":"51710","12":"Bipolar_Disorder"},{"1":"rs3732386","2":"3","3":"36871993","4":"C","5":"T","6":"0.359767","7":"0.08690220","8":"0.0138","9":"6.297261","10":"3.323992e-10","11":"51710","12":"Bipolar_Disorder"},{"1":"rs2302417","2":"3","3":"52814256","4":"T","5":"A","6":"0.524798","7":"-0.07930298","8":"0.0136","9":"-5.831102","10":"4.925043e-09","11":"51710","12":"Bipolar_Disorder"},{"1":"rs11724116","2":"4","3":"162294038","4":"C","5":"T","6":"0.166123","7":"-0.10409465","8":"0.0188","9":"-5.536949","10":"3.267007e-08","11":"51710","12":"Bipolar_Disorder"},{"1":"rs960145","2":"6","3":"166996991","4":"C","5":"A","6":"0.431041","7":"0.07360356","8":"0.0135","9":"5.452115","10":"4.634042e-08","11":"51710","12":"Bipolar_Disorder"},{"1":"rs80195870","2":"7","3":"24774468","4":"G","5":"T","6":"0.130229","7":"0.11259627","8":"0.0204","9":"5.519425","10":"3.290031e-08","11":"51710","12":"Bipolar_Disorder"},{"1":"rs13231398","2":"7","3":"110197412","4":"G","5":"C","6":"0.124409","7":"-0.12069979","8":"0.0219","9":"-5.511406","10":"3.361012e-08","11":"51710","12":"Bipolar_Disorder"},{"1":"rs73496688","2":"11","3":"79156748","4":"T","5":"A","6":"0.126543","7":"0.10870193","8":"0.0190","9":"5.721154","10":"1.047008e-08","11":"51710","12":"Bipolar_Disorder"},{"1":"rs10744560","2":"12","3":"2387099","4":"C","5":"T","6":"0.382588","7":"0.08320079","8":"0.0140","9":"5.942914","10":"2.918032e-09","11":"51710","12":"Bipolar_Disorder"},{"1":"rs12913702","2":"15","3":"85153184","4":"G","5":"A","6":"0.258802","7":"-0.08150294","8":"0.0146","9":"-5.582393","10":"2.419023e-08","11":"51710","12":"Bipolar_Disorder"},{"1":"rs884301","2":"17","3":"53367464","4":"C","5":"T","6":"0.400256","7":"0.08029806","8":"0.0138","9":"5.818700","10":"5.800962e-09","11":"51710","12":"Bipolar_Disorder"},{"1":"rs111444407","2":"19","3":"19358207","4":"C","5":"T","6":"0.134385","7":"0.11660011","8":"0.0184","9":"6.336963","10":"2.403975e-10","11":"51710","12":"Bipolar_Disorder"},{"1":"rs138321","2":"22","3":"41209304","4":"G","5":"A","6":"0.505822","7":"0.07930089","8":"0.0135","9":"5.874140","10":"4.692022e-09","11":"51710","12":"Bipolar_Disorder"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

### Outcome: COVID: A2
`#r outcome.blurb`
<br>

**Table 2:** SNPs associated with Bipolar Disorder avaliable in COVID: A2
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["CHROM"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["REF"],"name":[4],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[5],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[12],"type":["chr"],"align":["left"]}],"data":[{"1":"rs4619651","2":"2","3":"97416153","4":"G","5":"A","6":"0.3328","7":"0.01848000","8":"0.021235","9":"0.87026136","10":"0.38418","11":"1639838","12":"COVID_A2__EUR"},{"1":"rs3732386","2":"3","3":"36871993","4":"C","5":"T","6":"0.3500","7":"-0.01499200","8":"0.020218","9":"-0.74151746","10":"0.45839","11":"1639838","12":"COVID_A2__EUR"},{"1":"rs2302417","2":"3","3":"52814256","4":"T","5":"A","6":"0.4854","7":"0.03156600","8":"0.021560","9":"1.46410019","10":"0.14318","11":"1629379","12":"COVID_A2__EUR"},{"1":"rs11724116","2":"4","3":"162294038","4":"C","5":"T","6":"0.1488","7":"0.00097357","8":"0.027625","9":"0.03524235","10":"0.97189","11":"1639838","12":"COVID_A2__EUR"},{"1":"rs960145","2":"6","3":"166996991","4":"C","5":"A","6":"0.4667","7":"-0.01951300","8":"0.019351","9":"-1.00837166","10":"0.31328","11":"1638477","12":"COVID_A2__EUR"},{"1":"rs80195870","2":"7","3":"24774468","4":"G","5":"T","6":"0.1148","7":"0.00447780","8":"0.037172","9":"0.12046164","10":"0.90412","11":"1629782","12":"COVID_A2__EUR"},{"1":"rs13231398","2":"7","3":"110197412","4":"G","5":"C","6":"0.1017","7":"-0.02402500","8":"0.031187","9":"-0.77035303","10":"0.44109","11":"1639838","12":"COVID_A2__EUR"},{"1":"rs73496688","2":"11","3":"79156748","4":"T","5":"A","6":"0.1377","7":"-0.02581600","8":"0.027700","9":"-0.93198556","10":"0.35135","11":"1638880","12":"COVID_A2__EUR"},{"1":"rs10744560","2":"12","3":"2387099","4":"C","5":"T","6":"0.3280","7":"0.01469800","8":"0.023544","9":"0.62427795","10":"0.53244","11":"1629782","12":"COVID_A2__EUR"},{"1":"rs12913702","2":"15","3":"85153184","4":"G","5":"A","6":"0.2915","7":"0.00339720","8":"0.023614","9":"0.14386381","10":"0.88561","11":"1629782","12":"COVID_A2__EUR"},{"1":"rs884301","2":"17","3":"53367464","4":"C","5":"T","6":"0.3789","7":"0.01827700","8":"0.024675","9":"0.74070922","10":"0.45887","11":"1514509","12":"COVID_A2__EUR"},{"1":"rs111444407","2":"19","3":"19358207","4":"C","5":"T","6":"0.1470","7":"0.01106300","8":"0.025976","9":"0.42589313","10":"0.67018","11":"1638880","12":"COVID_A2__EUR"},{"1":"rs138321","2":"22","3":"41209304","4":"G","5":"A","6":"0.4970","7":"-0.01721400","8":"0.021632","9":"-0.79576553","10":"0.42616","11":"1629379","12":"COVID_A2__EUR"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

**Table 3:** Proxy SNPs for COVID: A2
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["proxy.outcome"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["target_snp"],"name":[2],"type":["lgl"],"align":["right"]},{"label":["proxy_snp"],"name":[3],"type":["lgl"],"align":["right"]},{"label":["ld.r2"],"name":[4],"type":["lgl"],"align":["right"]},{"label":["Dprime"],"name":[5],"type":["lgl"],"align":["right"]},{"label":["ref.proxy"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["alt.proxy"],"name":[7],"type":["lgl"],"align":["right"]},{"label":["CHROM"],"name":[8],"type":["lgl"],"align":["right"]},{"label":["POS"],"name":[9],"type":["lgl"],"align":["right"]},{"label":["ALT.proxy"],"name":[10],"type":["lgl"],"align":["right"]},{"label":["REF.proxy"],"name":[11],"type":["lgl"],"align":["right"]},{"label":["AF"],"name":[12],"type":["lgl"],"align":["right"]},{"label":["BETA"],"name":[13],"type":["lgl"],"align":["right"]},{"label":["SE"],"name":[14],"type":["lgl"],"align":["right"]},{"label":["P"],"name":[15],"type":["lgl"],"align":["right"]},{"label":["N"],"name":[16],"type":["lgl"],"align":["right"]},{"label":["ref"],"name":[17],"type":["lgl"],"align":["right"]},{"label":["alt"],"name":[18],"type":["lgl"],"align":["right"]},{"label":["ALT"],"name":[19],"type":["lgl"],"align":["right"]},{"label":["REF"],"name":[20],"type":["lgl"],"align":["right"]},{"label":["PHASE"],"name":[21],"type":["lgl"],"align":["right"]}],"data":[{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA","13":"NA","14":"NA","15":"NA","16":"NA","17":"NA","18":"NA","19":"NA","20":"NA","21":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

## Data harmonization
Harmonize the exposure and outcome datasets so that the effect of a SNP on the exposure and the effect of that SNP on the outcome correspond to the same allele. The harmonise_data function from the TwoSampleMR package can be used to perform the harmonization step, by default it try's to infer the forward strand alleles using allele frequency information.
<br>

**Table 4:** Harmonized Bipolar Disorder and COVID: A2 datasets
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["effect_allele.exposure"],"name":[2],"type":["chr"],"align":["left"]},{"label":["other_allele.exposure"],"name":[3],"type":["chr"],"align":["left"]},{"label":["effect_allele.outcome"],"name":[4],"type":["chr"],"align":["left"]},{"label":["other_allele.outcome"],"name":[5],"type":["chr"],"align":["left"]},{"label":["beta.exposure"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["beta.outcome"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["eaf.exposure"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["eaf.outcome"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["remove"],"name":[10],"type":["lgl"],"align":["right"]},{"label":["palindromic"],"name":[11],"type":["lgl"],"align":["right"]},{"label":["ambiguous"],"name":[12],"type":["lgl"],"align":["right"]},{"label":["id.outcome"],"name":[13],"type":["chr"],"align":["left"]},{"label":["chr.outcome"],"name":[14],"type":["dbl"],"align":["right"]},{"label":["pos.outcome"],"name":[15],"type":["dbl"],"align":["right"]},{"label":["se.outcome"],"name":[16],"type":["dbl"],"align":["right"]},{"label":["z.outcome"],"name":[17],"type":["dbl"],"align":["right"]},{"label":["pval.outcome"],"name":[18],"type":["dbl"],"align":["right"]},{"label":["samplesize.outcome"],"name":[19],"type":["dbl"],"align":["right"]},{"label":["outcome"],"name":[20],"type":["chr"],"align":["left"]},{"label":["mr_keep.outcome"],"name":[21],"type":["lgl"],"align":["right"]},{"label":["pval_origin.outcome"],"name":[22],"type":["chr"],"align":["left"]},{"label":["chr.exposure"],"name":[23],"type":["dbl"],"align":["right"]},{"label":["pos.exposure"],"name":[24],"type":["dbl"],"align":["right"]},{"label":["se.exposure"],"name":[25],"type":["dbl"],"align":["right"]},{"label":["z.exposure"],"name":[26],"type":["dbl"],"align":["right"]},{"label":["pval.exposure"],"name":[27],"type":["dbl"],"align":["right"]},{"label":["samplesize.exposure"],"name":[28],"type":["dbl"],"align":["right"]},{"label":["exposure"],"name":[29],"type":["chr"],"align":["left"]},{"label":["mr_keep.exposure"],"name":[30],"type":["lgl"],"align":["right"]},{"label":["pval_origin.exposure"],"name":[31],"type":["chr"],"align":["left"]},{"label":["id.exposure"],"name":[32],"type":["chr"],"align":["left"]},{"label":["action"],"name":[33],"type":["dbl"],"align":["right"]},{"label":["mr_keep"],"name":[34],"type":["lgl"],"align":["right"]},{"label":["pt"],"name":[35],"type":["dbl"],"align":["right"]},{"label":["pleitropy_keep"],"name":[36],"type":["lgl"],"align":["right"]},{"label":["mrpresso_RSSobs"],"name":[37],"type":["lgl"],"align":["right"]},{"label":["mrpresso_pval"],"name":[38],"type":["lgl"],"align":["right"]},{"label":["mrpresso_keep"],"name":[39],"type":["lgl"],"align":["right"]}],"data":[{"1":"rs10744560","2":"T","3":"C","4":"T","5":"C","6":"0.08320079","7":"0.01469800","8":"0.382588","9":"0.3280","10":"FALSE","11":"FALSE","12":"FALSE","13":"JuHlSI","14":"12","15":"2387099","16":"0.023544","17":"0.62427795","18":"0.53244","19":"1629782","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"12","24":"2387099","25":"0.0140","26":"5.942914","27":"2.918032e-09","28":"51710","29":"Stahl2019bip","30":"TRUE","31":"reported","32":"44NyLe","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs111444407","2":"T","3":"C","4":"T","5":"C","6":"0.11660011","7":"0.01106300","8":"0.134385","9":"0.1470","10":"FALSE","11":"FALSE","12":"FALSE","13":"JuHlSI","14":"19","15":"19358207","16":"0.025976","17":"0.42589313","18":"0.67018","19":"1638880","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"19","24":"19358207","25":"0.0184","26":"6.336963","27":"2.403975e-10","28":"51710","29":"Stahl2019bip","30":"TRUE","31":"reported","32":"44NyLe","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs11724116","2":"T","3":"C","4":"T","5":"C","6":"-0.10409465","7":"0.00097357","8":"0.166123","9":"0.1488","10":"FALSE","11":"FALSE","12":"FALSE","13":"JuHlSI","14":"4","15":"162294038","16":"0.027625","17":"0.03524235","18":"0.97189","19":"1639838","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"4","24":"162294038","25":"0.0188","26":"-5.536949","27":"3.267007e-08","28":"51710","29":"Stahl2019bip","30":"TRUE","31":"reported","32":"44NyLe","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs12913702","2":"A","3":"G","4":"A","5":"G","6":"-0.08150294","7":"0.00339720","8":"0.258802","9":"0.2915","10":"FALSE","11":"FALSE","12":"FALSE","13":"JuHlSI","14":"15","15":"85153184","16":"0.023614","17":"0.14386381","18":"0.88561","19":"1629782","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"15","24":"85153184","25":"0.0146","26":"-5.582393","27":"2.419023e-08","28":"51710","29":"Stahl2019bip","30":"TRUE","31":"reported","32":"44NyLe","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs13231398","2":"C","3":"G","4":"C","5":"G","6":"-0.12069979","7":"-0.02402500","8":"0.124409","9":"0.1017","10":"FALSE","11":"TRUE","12":"FALSE","13":"JuHlSI","14":"7","15":"110197412","16":"0.031187","17":"-0.77035303","18":"0.44109","19":"1639838","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"7","24":"110197412","25":"0.0219","26":"-5.511406","27":"3.361012e-08","28":"51710","29":"Stahl2019bip","30":"TRUE","31":"reported","32":"44NyLe","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs138321","2":"A","3":"G","4":"A","5":"G","6":"0.07930089","7":"-0.01721400","8":"0.505822","9":"0.4970","10":"FALSE","11":"FALSE","12":"FALSE","13":"JuHlSI","14":"22","15":"41209304","16":"0.021632","17":"-0.79576553","18":"0.42616","19":"1629379","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"22","24":"41209304","25":"0.0135","26":"5.874140","27":"4.692022e-09","28":"51710","29":"Stahl2019bip","30":"TRUE","31":"reported","32":"44NyLe","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs2302417","2":"A","3":"T","4":"A","5":"T","6":"-0.07930298","7":"-0.03156600","8":"0.524798","9":"0.5146","10":"FALSE","11":"TRUE","12":"TRUE","13":"JuHlSI","14":"3","15":"52814256","16":"0.021560","17":"1.46410019","18":"0.14318","19":"1629379","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"3","24":"52814256","25":"0.0136","26":"-5.831102","27":"4.925043e-09","28":"51710","29":"Stahl2019bip","30":"TRUE","31":"reported","32":"44NyLe","33":"2","34":"FALSE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"NA"},{"1":"rs3732386","2":"T","3":"C","4":"T","5":"C","6":"0.08690220","7":"-0.01499200","8":"0.359767","9":"0.3500","10":"FALSE","11":"FALSE","12":"FALSE","13":"JuHlSI","14":"3","15":"36871993","16":"0.020218","17":"-0.74151746","18":"0.45839","19":"1639838","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"3","24":"36871993","25":"0.0138","26":"6.297261","27":"3.323992e-10","28":"51710","29":"Stahl2019bip","30":"TRUE","31":"reported","32":"44NyLe","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs4619651","2":"A","3":"G","4":"A","5":"G","6":"-0.08409926","7":"0.01848000","8":"0.348837","9":"0.3328","10":"FALSE","11":"FALSE","12":"FALSE","13":"JuHlSI","14":"2","15":"97416153","16":"0.021235","17":"0.87026136","18":"0.38418","19":"1639838","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"2","24":"97416153","25":"0.0144","26":"-5.840226","27":"5.968978e-09","28":"51710","29":"Stahl2019bip","30":"TRUE","31":"reported","32":"44NyLe","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs73496688","2":"A","3":"T","4":"A","5":"T","6":"0.10870193","7":"-0.02581600","8":"0.126543","9":"0.1377","10":"FALSE","11":"TRUE","12":"FALSE","13":"JuHlSI","14":"11","15":"79156748","16":"0.027700","17":"-0.93198556","18":"0.35135","19":"1638880","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"11","24":"79156748","25":"0.0190","26":"5.721154","27":"1.047008e-08","28":"51710","29":"Stahl2019bip","30":"TRUE","31":"reported","32":"44NyLe","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs80195870","2":"T","3":"G","4":"T","5":"G","6":"0.11259627","7":"0.00447780","8":"0.130229","9":"0.1148","10":"FALSE","11":"FALSE","12":"FALSE","13":"JuHlSI","14":"7","15":"24774468","16":"0.037172","17":"0.12046164","18":"0.90412","19":"1629782","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"7","24":"24774468","25":"0.0204","26":"5.519425","27":"3.290031e-08","28":"51710","29":"Stahl2019bip","30":"TRUE","31":"reported","32":"44NyLe","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs884301","2":"T","3":"C","4":"T","5":"C","6":"0.08029806","7":"0.01827700","8":"0.400256","9":"0.3789","10":"FALSE","11":"FALSE","12":"FALSE","13":"JuHlSI","14":"17","15":"53367464","16":"0.024675","17":"0.74070922","18":"0.45887","19":"1514509","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"17","24":"53367464","25":"0.0138","26":"5.818700","27":"5.800962e-09","28":"51710","29":"Stahl2019bip","30":"TRUE","31":"reported","32":"44NyLe","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs960145","2":"A","3":"C","4":"A","5":"C","6":"0.07360356","7":"-0.01951300","8":"0.431041","9":"0.4667","10":"FALSE","11":"FALSE","12":"FALSE","13":"JuHlSI","14":"6","15":"166996991","16":"0.019351","17":"-1.00837166","18":"0.31328","19":"1638477","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"6","24":"166996991","25":"0.0135","26":"5.452115","27":"4.634042e-08","28":"51710","29":"Stahl2019bip","30":"TRUE","31":"reported","32":"44NyLe","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
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
{"columns":[{"label":["outliers_removed"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["pve.exposure"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["F"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["Alpha"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["NCP"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["Power"],"name":[6],"type":["dbl"],"align":["right"]}],"data":[{"1":"FALSE","2":"0.007739869","3":"33.60409","4":"0.05","5":"0.5521001","6":"0.1152514"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

The I2_GX statistic can be used to quantify the strength of the NOME violation for MR-Egger regression and should be used to evalute potential bias in the MR-Egger causal estimate, with values less then 90% indicating that causal estimated should interpreted with caution due to regression diluation.

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["outliers_removed"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["Isq_gx"],"name":[2],"type":["dbl"],"align":["right"]}],"data":[{"1":"FALSE","2":"0"},{"1":"TRUE","2":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>


## MR Results
To obtain an overall estimate of causal effect, the SNP-exposure and SNP-outcome coefficients were combined in 1) a fixed-effects meta-analysis using an inverse-variance weighted approach (IVW); 2) a Weighted Median approach; 3) Weighted Mode approach and 4) Egger Regression.


[**IVW**](https://doi.org/10.1002/gepi.21758) is equivalent to a weighted regression of the SNP-outcome coefficients on the SNP-exposure coefficients with the intercept constrained to zero. This method assumes that all variants are valid instrumental variables based on the Mendelian randomization assumptions. The causal estimate of the IVW analysis expresses the causal increase in the outcome (or log odds of the outcome for a binary outcome) per unit change in the exposure. [**Weighted median MR**](https://doi.org/10.1002/gepi.21965) allows for 50% of the instrumental variables to be invalid. [**MR-Egger regression**](https://doi.org/10.1093/ije/dyw220) allows all the instrumental variables to be subject to direct effects (i.e. horizontal pleiotropy), with the intercept representing bias in the causal estimate due to pleiotropy and the slope representing the causal estimate. [**Weighted Mode**](https://doi.org/10.1093/ije/dyx102) gives consistent estimates as the sample size increases if a plurality (or weighted plurality) of the genetic variants are valid instruments.
<br>



Table 6 presents the MR causal estimates of genetically predicted Bipolar Disorder on COVID: A2.
<br>

**Table 6** MR causaul estimates for Bipolar Disorder on COVID: A2
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["method"],"name":[5],"type":["chr"],"align":["left"]},{"label":["nsnp"],"name":[6],"type":["int"],"align":["right"]},{"label":["b"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"44NyLe","2":"JuHlSI","3":"covidhgi2020A2v6alleur","4":"Stahl2019bip","5":"Inverse variance weighted (fixed effects)","6":"12","7":"-0.04561699","8":"0.07648129","9":"0.5508771"},{"1":"44NyLe","2":"JuHlSI","3":"covidhgi2020A2v6alleur","4":"Stahl2019bip","5":"Weighted median","6":"12","7":"-0.03531842","8":"0.09961450","9":"0.7229260"},{"1":"44NyLe","2":"JuHlSI","3":"covidhgi2020A2v6alleur","4":"Stahl2019bip","5":"Weighted mode","6":"12","7":"-0.20225165","8":"0.17496425","9":"0.2721876"},{"1":"44NyLe","2":"JuHlSI","3":"covidhgi2020A2v6alleur","4":"Stahl2019bip","5":"MR Egger","6":"12","7":"0.39725425","8":"0.46963187","9":"0.4173984"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Figure 1 illustrates the SNP-specific associations with Bipolar Disorder versus the association in COVID: A2 and the corresponding MR estimates.
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/harern01/projects/MRcovid/results/MRcovideurv6/Stahl2019bip/covidhgi2020A2v6alleur/Stahl2019bip_5e-8_covidhgi2020A2v6alleur_MR_Analaysis_files/figure-html/scatter_plot-1.png" alt="Fig. 1: Scatterplot of SNP effects for the association of the Exposure on the Outcome"  />
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
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["method"],"name":[5],"type":["chr"],"align":["left"]},{"label":["Q"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["Q_df"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["Q_pval"],"name":[8],"type":["dbl"],"align":["right"]}],"data":[{"1":"44NyLe","2":"JuHlSI","3":"covidhgi2020A2v6alleur","4":"Stahl2019bip","5":"MR Egger","6":"4.306249","7":"10","8":"0.9324758"},{"1":"44NyLe","2":"JuHlSI","3":"covidhgi2020A2v6alleur","4":"Stahl2019bip","5":"Inverse variance weighted","6":"5.219760","7":"11","8":"0.9200581"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Figure 2 shows a funnel plot displaying the MR estimates of individual genetic variants against their precession. Aysmmetry in the funnel plot may arrise due to some genetic variants having unusally strong effects on the outcome, which is indicative of directional pleiotropy.
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/harern01/projects/MRcovid/results/MRcovideurv6/Stahl2019bip/covidhgi2020A2v6alleur/Stahl2019bip_5e-8_covidhgi2020A2v6alleur_MR_Analaysis_files/figure-html/funnel_plot-1.png" alt="Fig. 2: Funnel plot of the MR causal estimates against their precession"  />
<p class="caption">Fig. 2: Funnel plot of the MR causal estimates against their precession</p>
</div>
<br>

Figure 3 shows a [Radial Plots](https://github.com/WSpiller/RadialMR) can be used to visualize influential data points with large contributions to Cochran's Q Statistic that may bias causal effect estimates.




```
## [1] "No significant Outliers"
```

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/harern01/projects/MRcovid/results/MRcovideurv6/Stahl2019bip/covidhgi2020A2v6alleur/Stahl2019bip_5e-8_covidhgi2020A2v6alleur_MR_Analaysis_files/figure-html/Radial_Plot-1.png" alt="Fig. 4: Radial Plot showing influential data points using Radial IVW"  />
<p class="caption">Fig. 4: Radial Plot showing influential data points using Radial IVW</p>
</div>
<br>

The intercept of the MR-Egger Regression model captures the average pleitropic affect across all genetic variants (Table 8).
<br>

**Table 8:** MR Egger test for directional pleitropy
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["egger_intercept"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[7],"type":["dbl"],"align":["right"]}],"data":[{"1":"44NyLe","2":"JuHlSI","3":"covidhgi2020A2v6alleur","4":"Stahl2019bip","5":"-0.04093166","6":"0.04282553","7":"0.3617192"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Pleiotropy was also assesed using Mendelian Randomization Pleiotropy RESidual Sum and Outlier [(MR-PRESSO)](https://doi.org/10.1038/s41588-018-0099-7), that allows for the evlation of evaluation of horizontal pleiotropy in a standared MR model (Table 9). MR-PRESSO performs a global test for detection of horizontal pleiotropy and correction of pleiotropy via outlier removal (Table 10).
<br>

**Table 9:** MR-PRESSO Global Test for pleitropy
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["pt"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["outliers_removed"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["n_outliers"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["RSSobs"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"44NyLe","2":"JuHlSI","3":"covidhgi2020A2v6alleur","4":"Stahl2019bip","5":"5e-08","6":"FALSE","7":"0","8":"6.234224","9":"0.9229"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>


**Table 10:** MR Estimates after MR-PRESSO outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["method"],"name":[5],"type":["chr"],"align":["left"]},{"label":["nsnp"],"name":[6],"type":["int"],"align":["right"]},{"label":["b"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"44NyLe","2":"JuHlSI","3":"covidhgi2020A2v6alleur","4":"Stahl2019bip","5":"Inverse variance weighted (fixed effects)","6":"12","7":"-0.04561699","8":"0.07648129","9":"0.5508771"},{"1":"44NyLe","2":"JuHlSI","3":"covidhgi2020A2v6alleur","4":"Stahl2019bip","5":"Weighted median","6":"12","7":"-0.03531842","8":"0.09778794","9":"0.7179697"},{"1":"44NyLe","2":"JuHlSI","3":"covidhgi2020A2v6alleur","4":"Stahl2019bip","5":"Weighted mode","6":"12","7":"-0.20225165","8":"0.17296626","9":"0.2669919"},{"1":"44NyLe","2":"JuHlSI","3":"covidhgi2020A2v6alleur","4":"Stahl2019bip","5":"MR Egger","6":"12","7":"0.39725425","8":"0.46963187","9":"0.4173984"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/harern01/projects/MRcovid/results/MRcovideurv6/Stahl2019bip/covidhgi2020A2v6alleur/Stahl2019bip_5e-8_covidhgi2020A2v6alleur_MR_Analaysis_files/figure-html/scatter_plot_outlier-1.png" alt="Fig. 5: Scatterplot of SNP effects for the association of the Exposure on the Outcome after outlier removal"  />
<p class="caption">Fig. 5: Scatterplot of SNP effects for the association of the Exposure on the Outcome after outlier removal</p>
</div>
<br>

**Table 11:** Heterogenity Tests after outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["method"],"name":[5],"type":["chr"],"align":["left"]},{"label":["Q"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["Q_df"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["Q_pval"],"name":[8],"type":["dbl"],"align":["right"]}],"data":[{"1":"44NyLe","2":"JuHlSI","3":"covidhgi2020A2v6alleur","4":"Stahl2019bip","5":"MR Egger","6":"4.306249","7":"10","8":"0.9324758"},{"1":"44NyLe","2":"JuHlSI","3":"covidhgi2020A2v6alleur","4":"Stahl2019bip","5":"Inverse variance weighted","6":"5.219760","7":"11","8":"0.9200581"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

**Table 12:** MR Egger test for directional pleitropy after outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["egger_intercept"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[7],"type":["dbl"],"align":["right"]}],"data":[{"1":"44NyLe","2":"JuHlSI","3":"covidhgi2020A2v6alleur","4":"Stahl2019bip","5":"-0.04093166","6":"0.04282553","7":"0.3617192"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>
