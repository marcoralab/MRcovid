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
## NA/sc/arion/projects/LOAD/harern01/projects/MRcovidNULLdata/MRcovideurv6/Nalls2019pd/Nalls2019pd_5e-8_SNPs.txtdata/MRcovideurv6/Nalls2019pd/covidhgi2020C2v6alleur/Nalls2019pd_5e-8_covidhgi2020C2v6alleur_SNPs.txtdata/MRcovideurv6/Nalls2019pd/covidhgi2020C2v6alleur/Nalls2019pd_5e-8_covidhgi2020C2v6alleur_MatchedProxys.csvdata/MRcovideurv6/Nalls2019pd/covidhgi2020C2v6alleur/Nalls2019pd_5e-8_covidhgi2020C2v6alleur_mrpresso_MRdat.csvdata/MRcovideurv6/Nalls2019pd/covidhgi2020C2v6alleur/Nalls2019pd_5e-8_covidhgi2020C2v6alleur_mrpresso_global.txtdata/MRcovideurv6/Nalls2019pd/covidhgi2020C2v6alleur/Nalls2019pd_5e-8_covidhgi2020C2v6alleur_MR_power.txtcovidhgi2020C2v6alleurNalls2019pdCOVID: C2Parkinsons Disease5e-80.00110000results/MRcovideurv6/Nalls2019pd/covidhgi2020C2v6alleur/Nalls2019pd_5e-8_covidhgi2020C2v6alleur
```



## Instrumental Variables
**SNP Inclusion:** SNPS associated with at a p-value threshold of p < 5e-8 were included in this analysis.
<br>

**LD Clumping:** For standard two sample MR it is important to ensure that the instruments for the exposure are independent. LD clumping was performed in PLINK using the EUR samples from the 1000 Genomes Project to estimate LD between SNPs, and, amongst SNPs that have an LD above a given threshold, retain only the SNP with the lowest p-value. A clumping window of 10^{4}, r2 of 0.001 and significance level of 1 was used for the index and secondary SNPs.
<br>

**Proxy SNPs:** Where SNPs were not available in the outcome GWAS, the EUR thousand genomes was queried to identify potential proxy SNPs that are in linkage disequilibrium (r2 > 0.8) of the missing SNP.
<br>

### Exposure: Parkinsons Disease
`#r exposure.blurb`
<br>

**Table 1:** Independent SNPs associated with Parkinsons Disease
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["CHROM"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["REF"],"name":[4],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[5],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[12],"type":["chr"],"align":["left"]}],"data":[{"1":"rs35749011","2":"1","3":"155135036","4":"G","5":"A","6":"0.0191","7":"0.7508","8":"0.0659","9":"11.393020","10":"5.022e-30","11":"482730","12":"parkinsons_disease"},{"1":"rs823106","2":"1","3":"205656453","4":"G","5":"C","6":"0.8488","7":"-0.1492","8":"0.0239","9":"-6.242678","10":"4.100e-10","11":"482730","12":"parkinsons_disease"},{"1":"rs4488803","2":"3","3":"58218352","4":"G","5":"A","6":"0.3746","7":"-0.1136","8":"0.0199","9":"-5.708543","10":"1.076e-08","11":"482730","12":"parkinsons_disease"},{"1":"rs34311866","2":"4","3":"951947","4":"T","5":"C","6":"0.1958","7":"0.2272","8":"0.0231","9":"9.835500","10":"7.974e-23","11":"482730","12":"parkinsons_disease"},{"1":"rs4698412","2":"4","3":"15737348","4":"G","5":"A","6":"0.5530","7":"0.1258","8":"0.0168","9":"7.488095","10":"7.049e-14","11":"482730","12":"parkinsons_disease"},{"1":"rs7695720","2":"4","3":"77183300","4":"A","5":"C","6":"0.2091","7":"-0.1255","8":"0.0208","9":"-6.033650","10":"1.528e-09","11":"482730","12":"parkinsons_disease"},{"1":"rs356203","2":"4","3":"90666041","4":"C","5":"T","6":"0.6169","7":"-0.2398","8":"0.0178","9":"-13.471910","10":"3.007e-41","11":"482730","12":"parkinsons_disease"},{"1":"rs75646569","2":"5","3":"60345424","4":"T","5":"G","6":"0.1117","7":"0.1916","8":"0.0266","9":"7.203010","10":"5.618e-13","11":"482730","12":"parkinsons_disease"},{"1":"rs35265698","2":"6","3":"32561334","4":"C","5":"G","6":"0.1547","7":"-0.2000","8":"0.0303","9":"-6.600660","10":"3.927e-11","11":"480593","12":"parkinsons_disease"},{"1":"rs858295","2":"7","3":"23245569","4":"A","5":"G","6":"0.3947","7":"-0.1039","8":"0.0176","9":"-5.903410","10":"3.831e-09","11":"482730","12":"parkinsons_disease"},{"1":"rs620490","2":"8","3":"16697579","4":"T","5":"G","6":"0.2762","7":"-0.1174","8":"0.0190","9":"-6.178950","10":"6.456e-10","11":"482730","12":"parkinsons_disease"},{"1":"rs144814361","2":"10","3":"121410917","4":"C","5":"T","6":"0.0174","7":"0.4411","8":"0.0680","9":"6.486765","10":"9.065e-11","11":"482730","12":"parkinsons_disease"},{"1":"rs75505347","2":"12","3":"40885549","4":"C","5":"T","6":"0.0195","7":"0.3917","8":"0.0674","9":"5.811573","10":"6.117e-09","11":"482730","12":"parkinsons_disease"},{"1":"rs10847864","2":"12","3":"123326598","4":"G","5":"T","6":"0.3625","7":"0.1274","8":"0.0179","9":"7.117318","10":"9.812e-13","11":"482730","12":"parkinsons_disease"},{"1":"rs4774417","2":"15","3":"61993702","4":"G","5":"A","6":"0.7397","7":"0.1052","8":"0.0192","9":"5.479167","10":"4.626e-08","11":"482730","12":"parkinsons_disease"},{"1":"rs12934900","2":"16","3":"30923602","4":"A","5":"T","6":"0.6571","7":"0.1215","8":"0.0184","9":"6.603260","10":"4.331e-11","11":"482730","12":"parkinsons_disease"},{"1":"rs4566208","2":"17","3":"16010920","4":"A","5":"G","6":"0.5659","7":"-0.0957","8":"0.0174","9":"-5.500000","10":"3.884e-08","11":"482730","12":"parkinsons_disease"},{"1":"rs58879558","2":"17","3":"44095467","4":"T","5":"C","6":"0.2229","7":"-0.2383","8":"0.0250","9":"-9.532000","10":"1.363e-21","11":"482730","12":"parkinsons_disease"},{"1":"rs4588066","2":"18","3":"40672964","4":"G","5":"A","6":"0.3260","7":"0.1046","8":"0.0178","9":"5.876404","10":"4.453e-09","11":"482730","12":"parkinsons_disease"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

### Outcome: COVID: C2
`#r outcome.blurb`
<br>

**Table 2:** SNPs associated with Parkinsons Disease avaliable in COVID: C2
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["CHROM"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["REF"],"name":[4],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[5],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[12],"type":["chr"],"align":["left"]}],"data":[{"1":"rs35749011","2":"1","3":"155135036","4":"G","5":"A","6":"0.01328","7":"-0.0021907","8":"0.0183880","9":"-0.1191375","10":"0.90517000","11":"2074762","12":"COVID_C2__EUR"},{"1":"rs823106","2":"1","3":"205656453","4":"G","5":"C","6":"0.85760","7":"-0.0059381","8":"0.0062631","9":"-0.9481088","10":"0.34308000","11":"2387681","12":"COVID_C2__EUR"},{"1":"rs4488803","2":"3","3":"58218352","4":"G","5":"A","6":"0.40420","7":"-0.0037486","8":"0.0044355","9":"-0.8451358","10":"0.39803000","11":"2382693","12":"COVID_C2__EUR"},{"1":"rs34311866","2":"4","3":"951947","4":"T","5":"C","6":"0.18990","7":"0.0048266","8":"0.0056763","9":"0.8503074","10":"0.39516000","11":"2393300","12":"COVID_C2__EUR"},{"1":"rs4698412","2":"4","3":"15737348","4":"G","5":"A","6":"0.55140","7":"-0.0039192","8":"0.0042863","9":"-0.9143550","10":"0.36053000","11":"2393300","12":"COVID_C2__EUR"},{"1":"rs7695720","2":"4","3":"77183300","4":"A","5":"C","6":"0.20950","7":"-0.0114460","8":"0.0052411","9":"-2.1838927","10":"0.02897600","11":"2382580","12":"COVID_C2__EUR"},{"1":"rs356203","2":"4","3":"90666041","4":"C","5":"T","6":"0.62820","7":"0.0120950","8":"0.0044256","9":"2.7329628","10":"0.00627730","11":"2322239","12":"COVID_C2__EUR"},{"1":"rs75646569","2":"5","3":"60345424","4":"T","5":"G","6":"0.10200","7":"0.0068025","8":"0.0071588","9":"0.9502291","10":"0.34200000","11":"2393659","12":"COVID_C2__EUR"},{"1":"rs35265698","2":"6","3":"32561334","4":"C","5":"G","6":"0.17350","7":"-0.0032712","8":"0.0060527","9":"-0.5404530","10":"0.58888000","11":"2145664","12":"COVID_C2__EUR"},{"1":"rs858295","2":"7","3":"23245569","4":"A","5":"G","6":"0.39180","7":"-0.0027585","8":"0.0044096","9":"-0.6255669","10":"0.53159000","11":"2393659","12":"COVID_C2__EUR"},{"1":"rs620490","2":"8","3":"16697579","4":"T","5":"G","6":"0.29080","7":"0.0022494","8":"0.0047966","9":"0.4689572","10":"0.63911000","11":"2320970","12":"COVID_C2__EUR"},{"1":"rs144814361","2":"10","3":"121410917","4":"C","5":"T","6":"0.01437","7":"0.0035977","8":"0.0183190","9":"0.1963917","10":"0.84430000","11":"2342298","12":"COVID_C2__EUR"},{"1":"rs75505347","2":"12","3":"40885549","4":"C","5":"T","6":"0.01639","7":"-0.0132710","8":"0.0169620","9":"-0.7823959","10":"0.43397000","11":"2374905","12":"COVID_C2__EUR"},{"1":"rs10847864","2":"12","3":"123326598","4":"G","5":"T","6":"0.33750","7":"-0.0010054","8":"0.0049334","9":"-0.2037945","10":"0.83852000","11":"2019693","12":"COVID_C2__EUR"},{"1":"rs4774417","2":"15","3":"61993702","4":"G","5":"A","6":"0.70450","7":"-0.0070847","8":"0.0048480","9":"-1.4613655","10":"0.14392000","11":"2383244","12":"COVID_C2__EUR"},{"1":"rs12934900","2":"16","3":"30923602","4":"A","5":"T","6":"0.63420","7":"-0.0105390","8":"0.0045221","9":"-2.3305544","10":"0.01978100","11":"2285232","12":"COVID_C2__EUR"},{"1":"rs4566208","2":"17","3":"16010920","4":"A","5":"G","6":"0.55670","7":"0.0152530","8":"0.0045141","9":"3.3789681","10":"0.00072772","11":"2298674","12":"COVID_C2__EUR"},{"1":"rs58879558","2":"17","3":"44095467","4":"T","5":"C","6":"0.21500","7":"-0.0174380","8":"0.0059660","9":"-2.9228964","10":"0.00346820","11":"2112412","12":"COVID_C2__EUR"},{"1":"rs4588066","2":"18","3":"40672964","4":"G","5":"A","6":"0.32880","7":"0.0029289","8":"0.0045807","9":"0.6394001","10":"0.52257000","11":"2393659","12":"COVID_C2__EUR"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

**Table 3:** Proxy SNPs for COVID: C2
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["proxy.outcome"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["target_snp"],"name":[2],"type":["lgl"],"align":["right"]},{"label":["proxy_snp"],"name":[3],"type":["lgl"],"align":["right"]},{"label":["ld.r2"],"name":[4],"type":["lgl"],"align":["right"]},{"label":["Dprime"],"name":[5],"type":["lgl"],"align":["right"]},{"label":["ref.proxy"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["alt.proxy"],"name":[7],"type":["lgl"],"align":["right"]},{"label":["CHROM"],"name":[8],"type":["lgl"],"align":["right"]},{"label":["POS"],"name":[9],"type":["lgl"],"align":["right"]},{"label":["ALT.proxy"],"name":[10],"type":["lgl"],"align":["right"]},{"label":["REF.proxy"],"name":[11],"type":["lgl"],"align":["right"]},{"label":["AF"],"name":[12],"type":["lgl"],"align":["right"]},{"label":["BETA"],"name":[13],"type":["lgl"],"align":["right"]},{"label":["SE"],"name":[14],"type":["lgl"],"align":["right"]},{"label":["P"],"name":[15],"type":["lgl"],"align":["right"]},{"label":["N"],"name":[16],"type":["lgl"],"align":["right"]},{"label":["ref"],"name":[17],"type":["lgl"],"align":["right"]},{"label":["alt"],"name":[18],"type":["lgl"],"align":["right"]},{"label":["ALT"],"name":[19],"type":["lgl"],"align":["right"]},{"label":["REF"],"name":[20],"type":["lgl"],"align":["right"]},{"label":["PHASE"],"name":[21],"type":["lgl"],"align":["right"]}],"data":[{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA","13":"NA","14":"NA","15":"NA","16":"NA","17":"NA","18":"NA","19":"NA","20":"NA","21":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

## Data harmonization
Harmonize the exposure and outcome datasets so that the effect of a SNP on the exposure and the effect of that SNP on the outcome correspond to the same allele. The harmonise_data function from the TwoSampleMR package can be used to perform the harmonization step, by default it try's to infer the forward strand alleles using allele frequency information.
<br>

**Table 4:** Harmonized Parkinsons Disease and COVID: C2 datasets
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["effect_allele.exposure"],"name":[2],"type":["chr"],"align":["left"]},{"label":["other_allele.exposure"],"name":[3],"type":["chr"],"align":["left"]},{"label":["effect_allele.outcome"],"name":[4],"type":["chr"],"align":["left"]},{"label":["other_allele.outcome"],"name":[5],"type":["chr"],"align":["left"]},{"label":["beta.exposure"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["beta.outcome"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["eaf.exposure"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["eaf.outcome"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["remove"],"name":[10],"type":["lgl"],"align":["right"]},{"label":["palindromic"],"name":[11],"type":["lgl"],"align":["right"]},{"label":["ambiguous"],"name":[12],"type":["lgl"],"align":["right"]},{"label":["id.outcome"],"name":[13],"type":["chr"],"align":["left"]},{"label":["chr.outcome"],"name":[14],"type":["dbl"],"align":["right"]},{"label":["pos.outcome"],"name":[15],"type":["dbl"],"align":["right"]},{"label":["se.outcome"],"name":[16],"type":["dbl"],"align":["right"]},{"label":["z.outcome"],"name":[17],"type":["dbl"],"align":["right"]},{"label":["pval.outcome"],"name":[18],"type":["dbl"],"align":["right"]},{"label":["samplesize.outcome"],"name":[19],"type":["dbl"],"align":["right"]},{"label":["outcome"],"name":[20],"type":["chr"],"align":["left"]},{"label":["mr_keep.outcome"],"name":[21],"type":["lgl"],"align":["right"]},{"label":["pval_origin.outcome"],"name":[22],"type":["chr"],"align":["left"]},{"label":["chr.exposure"],"name":[23],"type":["dbl"],"align":["right"]},{"label":["pos.exposure"],"name":[24],"type":["dbl"],"align":["right"]},{"label":["se.exposure"],"name":[25],"type":["dbl"],"align":["right"]},{"label":["z.exposure"],"name":[26],"type":["dbl"],"align":["right"]},{"label":["pval.exposure"],"name":[27],"type":["dbl"],"align":["right"]},{"label":["samplesize.exposure"],"name":[28],"type":["dbl"],"align":["right"]},{"label":["exposure"],"name":[29],"type":["chr"],"align":["left"]},{"label":["mr_keep.exposure"],"name":[30],"type":["lgl"],"align":["right"]},{"label":["pval_origin.exposure"],"name":[31],"type":["chr"],"align":["left"]},{"label":["id.exposure"],"name":[32],"type":["chr"],"align":["left"]},{"label":["action"],"name":[33],"type":["dbl"],"align":["right"]},{"label":["mr_keep"],"name":[34],"type":["lgl"],"align":["right"]},{"label":["pt"],"name":[35],"type":["dbl"],"align":["right"]},{"label":["pleitropy_keep"],"name":[36],"type":["lgl"],"align":["right"]},{"label":["mrpresso_RSSobs"],"name":[37],"type":["dbl"],"align":["right"]},{"label":["mrpresso_pval"],"name":[38],"type":["dbl"],"align":["right"]},{"label":["mrpresso_keep"],"name":[39],"type":["lgl"],"align":["right"]}],"data":[{"1":"rs10847864","2":"T","3":"G","4":"T","5":"G","6":"0.1274","7":"-0.0010054","8":"0.3625","9":"0.33750","10":"FALSE","11":"FALSE","12":"FALSE","13":"ys8L4h","14":"12","15":"123326598","16":"0.0049334","17":"-0.2037945","18":"0.83852000","19":"2019693","20":"covidhgi2020C2v6alleur","21":"TRUE","22":"reported","23":"12","24":"123326598","25":"0.0179","26":"7.117318","27":"9.812e-13","28":"482730","29":"Nalls2019pd","30":"TRUE","31":"reported","32":"PfE1Z9","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"3.833393e-07","38":"1.0000","39":"TRUE"},{"1":"rs12934900","2":"T","3":"A","4":"T","5":"A","6":"0.1215","7":"-0.0105390","8":"0.6571","9":"0.63420","10":"FALSE","11":"TRUE","12":"FALSE","13":"ys8L4h","14":"16","15":"30923602","16":"0.0045221","17":"-2.3305544","18":"0.01978100","19":"2285232","20":"covidhgi2020C2v6alleur","21":"TRUE","22":"reported","23":"16","24":"30923602","25":"0.0184","26":"6.603260","27":"4.331e-11","28":"482730","29":"Nalls2019pd","30":"TRUE","31":"reported","32":"PfE1Z9","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"1.121084e-04","38":"0.3667","39":"TRUE"},{"1":"rs144814361","2":"T","3":"C","4":"T","5":"C","6":"0.4411","7":"0.0035977","8":"0.0174","9":"0.01437","10":"FALSE","11":"FALSE","12":"FALSE","13":"ys8L4h","14":"10","15":"121410917","16":"0.0183190","17":"0.1963917","18":"0.84430000","19":"2342298","20":"covidhgi2020C2v6alleur","21":"TRUE","22":"reported","23":"10","24":"121410917","25":"0.0680","26":"6.486765","27":"9.065e-11","28":"482730","29":"Nalls2019pd","30":"TRUE","31":"reported","32":"PfE1Z9","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"2.694314e-05","38":"1.0000","39":"TRUE"},{"1":"rs34311866","2":"C","3":"T","4":"C","5":"T","6":"0.2272","7":"0.0048266","8":"0.1958","9":"0.18990","10":"FALSE","11":"FALSE","12":"FALSE","13":"ys8L4h","14":"4","15":"951947","16":"0.0056763","17":"0.8503074","18":"0.39516000","19":"2393300","20":"covidhgi2020C2v6alleur","21":"TRUE","22":"reported","23":"4","24":"951947","25":"0.0231","26":"9.835500","27":"7.974e-23","28":"482730","29":"Nalls2019pd","30":"TRUE","31":"reported","32":"PfE1Z9","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"3.748769e-05","38":"1.0000","39":"TRUE"},{"1":"rs35265698","2":"G","3":"C","4":"G","5":"C","6":"-0.2000","7":"-0.0032712","8":"0.1547","9":"0.17350","10":"FALSE","11":"TRUE","12":"FALSE","13":"ys8L4h","14":"6","15":"32561334","16":"0.0060527","17":"-0.5404530","18":"0.58888000","19":"2145664","20":"covidhgi2020C2v6alleur","21":"TRUE","22":"reported","23":"6","24":"32561334","25":"0.0303","26":"-6.600660","27":"3.927e-11","28":"480593","29":"Nalls2019pd","30":"TRUE","31":"reported","32":"PfE1Z9","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"1.745206e-05","38":"1.0000","39":"TRUE"},{"1":"rs356203","2":"T","3":"C","4":"T","5":"C","6":"-0.2398","7":"0.0120950","8":"0.6169","9":"0.62820","10":"FALSE","11":"FALSE","12":"FALSE","13":"ys8L4h","14":"4","15":"90666041","16":"0.0044256","17":"2.7329628","18":"0.00627730","19":"2322239","20":"covidhgi2020C2v6alleur","21":"TRUE","22":"reported","23":"4","24":"90666041","25":"0.0178","26":"-13.471910","27":"3.007e-41","28":"482730","29":"Nalls2019pd","30":"TRUE","31":"reported","32":"PfE1Z9","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"1.857020e-04","38":"0.0342","39":"FALSE"},{"1":"rs35749011","2":"A","3":"G","4":"A","5":"G","6":"0.7508","7":"-0.0021907","8":"0.0191","9":"0.01328","10":"FALSE","11":"FALSE","12":"FALSE","13":"ys8L4h","14":"1","15":"155135036","16":"0.0183880","17":"-0.1191375","18":"0.90517000","19":"2074762","20":"covidhgi2020C2v6alleur","21":"TRUE","22":"reported","23":"1","24":"155135036","25":"0.0659","26":"11.393020","27":"5.022e-30","28":"482730","29":"Nalls2019pd","30":"TRUE","31":"reported","32":"PfE1Z9","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"6.235156e-08","38":"1.0000","39":"TRUE"},{"1":"rs4488803","2":"A","3":"G","4":"A","5":"G","6":"-0.1136","7":"-0.0037486","8":"0.3746","9":"0.40420","10":"FALSE","11":"FALSE","12":"FALSE","13":"ys8L4h","14":"3","15":"58218352","16":"0.0044355","17":"-0.8451358","18":"0.39803000","19":"2382693","20":"covidhgi2020C2v6alleur","21":"TRUE","22":"reported","23":"3","24":"58218352","25":"0.0199","26":"-5.708543","27":"1.076e-08","28":"482730","29":"Nalls2019pd","30":"TRUE","31":"reported","32":"PfE1Z9","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"1.828189e-05","38":"1.0000","39":"TRUE"},{"1":"rs4566208","2":"G","3":"A","4":"G","5":"A","6":"-0.0957","7":"0.0152530","8":"0.5659","9":"0.55670","10":"FALSE","11":"FALSE","12":"FALSE","13":"ys8L4h","14":"17","15":"16010920","16":"0.0045141","17":"3.3789681","18":"0.00072772","19":"2298674","20":"covidhgi2020C2v6alleur","21":"TRUE","22":"reported","23":"17","24":"16010920","25":"0.0174","26":"-5.500000","27":"3.884e-08","28":"482730","29":"Nalls2019pd","30":"TRUE","31":"reported","32":"PfE1Z9","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"2.353796e-04","38":"0.0152","39":"FALSE"},{"1":"rs4588066","2":"A","3":"G","4":"A","5":"G","6":"0.1046","7":"0.0029289","8":"0.3260","9":"0.32880","10":"FALSE","11":"FALSE","12":"FALSE","13":"ys8L4h","14":"18","15":"40672964","16":"0.0045807","17":"0.6394001","18":"0.52257000","19":"2393659","20":"covidhgi2020C2v6alleur","21":"TRUE","22":"reported","23":"18","24":"40672964","25":"0.0178","26":"5.876404","27":"4.453e-09","28":"482730","29":"Nalls2019pd","30":"TRUE","31":"reported","32":"PfE1Z9","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"1.133431e-05","38":"1.0000","39":"TRUE"},{"1":"rs4698412","2":"A","3":"G","4":"A","5":"G","6":"0.1258","7":"-0.0039192","8":"0.5530","9":"0.55140","10":"FALSE","11":"FALSE","12":"FALSE","13":"ys8L4h","14":"4","15":"15737348","16":"0.0042863","17":"-0.9143550","18":"0.36053000","19":"2393300","20":"covidhgi2020C2v6alleur","21":"TRUE","22":"reported","23":"4","24":"15737348","25":"0.0168","26":"7.488095","27":"7.049e-14","28":"482730","29":"Nalls2019pd","30":"TRUE","31":"reported","32":"PfE1Z9","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"1.367330e-05","38":"1.0000","39":"TRUE"},{"1":"rs4774417","2":"A","3":"G","4":"A","5":"G","6":"0.1052","7":"-0.0070847","8":"0.7397","9":"0.70450","10":"FALSE","11":"FALSE","12":"FALSE","13":"ys8L4h","14":"15","15":"61993702","16":"0.0048480","17":"-1.4613655","18":"0.14392000","19":"2383244","20":"covidhgi2020C2v6alleur","21":"TRUE","22":"reported","23":"15","24":"61993702","25":"0.0192","26":"5.479167","27":"4.626e-08","28":"482730","29":"Nalls2019pd","30":"TRUE","31":"reported","32":"PfE1Z9","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"4.808239e-05","38":"1.0000","39":"TRUE"},{"1":"rs58879558","2":"C","3":"T","4":"C","5":"T","6":"-0.2383","7":"-0.0174380","8":"0.2229","9":"0.21500","10":"FALSE","11":"FALSE","12":"FALSE","13":"ys8L4h","14":"17","15":"44095467","16":"0.0059660","17":"-2.9228964","18":"0.00346820","19":"2112412","20":"covidhgi2020C2v6alleur","21":"TRUE","22":"reported","23":"17","24":"44095467","25":"0.0250","26":"-9.532000","27":"1.363e-21","28":"482730","29":"Nalls2019pd","30":"TRUE","31":"reported","32":"PfE1Z9","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"4.018748e-04","38":"0.0190","39":"FALSE"},{"1":"rs620490","2":"G","3":"T","4":"G","5":"T","6":"-0.1174","7":"0.0022494","8":"0.2762","9":"0.29080","10":"FALSE","11":"FALSE","12":"FALSE","13":"ys8L4h","14":"8","15":"16697579","16":"0.0047966","17":"0.4689572","18":"0.63911000","19":"2320970","20":"covidhgi2020C2v6alleur","21":"TRUE","22":"reported","23":"8","24":"16697579","25":"0.0190","26":"-6.178950","27":"6.456e-10","28":"482730","29":"Nalls2019pd","30":"TRUE","31":"reported","32":"PfE1Z9","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"3.757486e-06","38":"1.0000","39":"TRUE"},{"1":"rs75505347","2":"T","3":"C","4":"T","5":"C","6":"0.3917","7":"-0.0132710","8":"0.0195","9":"0.01639","10":"FALSE","11":"FALSE","12":"FALSE","13":"ys8L4h","14":"12","15":"40885549","16":"0.0169620","17":"-0.7823959","18":"0.43397000","19":"2374905","20":"covidhgi2020C2v6alleur","21":"TRUE","22":"reported","23":"12","24":"40885549","25":"0.0674","26":"5.811573","27":"6.117e-09","28":"482730","29":"Nalls2019pd","30":"TRUE","31":"reported","32":"PfE1Z9","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"1.535331e-04","38":"1.0000","39":"TRUE"},{"1":"rs75646569","2":"G","3":"T","4":"G","5":"T","6":"0.1916","7":"0.0068025","8":"0.1117","9":"0.10200","10":"FALSE","11":"FALSE","12":"FALSE","13":"ys8L4h","14":"5","15":"60345424","16":"0.0071588","17":"0.9502291","18":"0.34200000","19":"2393659","20":"covidhgi2020C2v6alleur","21":"TRUE","22":"reported","23":"5","24":"60345424","25":"0.0266","26":"7.203010","27":"5.618e-13","28":"482730","29":"Nalls2019pd","30":"TRUE","31":"reported","32":"PfE1Z9","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"5.988250e-05","38":"1.0000","39":"TRUE"},{"1":"rs7695720","2":"C","3":"A","4":"C","5":"A","6":"-0.1255","7":"-0.0114460","8":"0.2091","9":"0.20950","10":"FALSE","11":"FALSE","12":"FALSE","13":"ys8L4h","14":"4","15":"77183300","16":"0.0052411","17":"-2.1838927","18":"0.02897600","19":"2382580","20":"covidhgi2020C2v6alleur","21":"TRUE","22":"reported","23":"4","24":"77183300","25":"0.0208","26":"-6.033650","27":"1.528e-09","28":"482730","29":"Nalls2019pd","30":"TRUE","31":"reported","32":"PfE1Z9","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"1.501742e-04","38":"0.3895","39":"TRUE"},{"1":"rs823106","2":"C","3":"G","4":"C","5":"G","6":"-0.1492","7":"-0.0059381","8":"0.8488","9":"0.85760","10":"FALSE","11":"TRUE","12":"FALSE","13":"ys8L4h","14":"1","15":"205656453","16":"0.0062631","17":"-0.9481088","18":"0.34308000","19":"2387681","20":"covidhgi2020C2v6alleur","21":"TRUE","22":"reported","23":"1","24":"205656453","25":"0.0239","26":"-6.242678","27":"4.100e-10","28":"482730","29":"Nalls2019pd","30":"TRUE","31":"reported","32":"PfE1Z9","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"4.402501e-05","38":"1.0000","39":"TRUE"},{"1":"rs858295","2":"G","3":"A","4":"G","5":"A","6":"-0.1039","7":"-0.0027585","8":"0.3947","9":"0.39180","10":"FALSE","11":"FALSE","12":"FALSE","13":"ys8L4h","14":"7","15":"23245569","16":"0.0044096","17":"-0.6255669","18":"0.53159000","19":"2393659","20":"covidhgi2020C2v6alleur","21":"TRUE","22":"reported","23":"7","24":"23245569","25":"0.0176","26":"-5.903410","27":"3.831e-09","28":"482730","29":"Nalls2019pd","30":"TRUE","31":"reported","32":"PfE1Z9","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"1.020834e-05","38":"1.0000","39":"TRUE"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
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
{"columns":[{"label":["outliers_removed"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["pve.exposure"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["F"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["Alpha"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["NCP"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["Power"],"name":[6],"type":["dbl"],"align":["right"]}],"data":[{"1":"FALSE","2":"0.002274430","3":"57.9154","4":"0.05","5":"0.3605718","6":"0.09222303"},{"1":"TRUE","2":"0.001640613","3":"49.5779","4":"0.05","5":"0.1433124","6":"0.06657344"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

The I2_GX statistic can be used to quantify the strength of the NOME violation for MR-Egger regression and should be used to evalute potential bias in the MR-Egger causal estimate, with values less then 90% indicating that causal estimated should interpreted with caution due to regression diluation.

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["outliers_removed"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["Isq_gx"],"name":[2],"type":["dbl"],"align":["right"]}],"data":[{"1":"FALSE","2":"0.7942224"},{"1":"TRUE","2":"0.5598335"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>


## MR Results
To obtain an overall estimate of causal effect, the SNP-exposure and SNP-outcome coefficients were combined in 1) a fixed-effects meta-analysis using an inverse-variance weighted approach (IVW); 2) a Weighted Median approach; 3) Weighted Mode approach and 4) Egger Regression.


[**IVW**](https://doi.org/10.1002/gepi.21758) is equivalent to a weighted regression of the SNP-outcome coefficients on the SNP-exposure coefficients with the intercept constrained to zero. This method assumes that all variants are valid instrumental variables based on the Mendelian randomization assumptions. The causal estimate of the IVW analysis expresses the causal increase in the outcome (or log odds of the outcome for a binary outcome) per unit change in the exposure. [**Weighted median MR**](https://doi.org/10.1002/gepi.21965) allows for 50% of the instrumental variables to be invalid. [**MR-Egger regression**](https://doi.org/10.1093/ije/dyw220) allows all the instrumental variables to be subject to direct effects (i.e. horizontal pleiotropy), with the intercept representing bias in the causal estimate due to pleiotropy and the slope representing the causal estimate. [**Weighted Mode**](https://doi.org/10.1093/ije/dyx102) gives consistent estimates as the sample size increases if a plurality (or weighted plurality) of the genetic variants are valid instruments.
<br>



Table 6 presents the MR causal estimates of genetically predicted Parkinsons Disease on COVID: C2.
<br>

**Table 6** MR causaul estimates for Parkinsons Disease on COVID: C2
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["method"],"name":[5],"type":["chr"],"align":["left"]},{"label":["nsnp"],"name":[6],"type":["int"],"align":["right"]},{"label":["b"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"PfE1Z9","2":"ys8L4h","3":"covidhgi2020C2v6alleur","4":"Nalls2019pd","5":"Inverse variance weighted (fixed effects)","6":"19","7":"-0.003218473","8":"0.007588639","9":"0.6714803"},{"1":"PfE1Z9","2":"ys8L4h","3":"covidhgi2020C2v6alleur","4":"Nalls2019pd","5":"Weighted median","6":"19","7":"0.003600069","8":"0.012584405","9":"0.7748216"},{"1":"PfE1Z9","2":"ys8L4h","3":"covidhgi2020C2v6alleur","4":"Nalls2019pd","5":"Weighted mode","6":"19","7":"0.016516840","8":"0.025737307","9":"0.5291259"},{"1":"PfE1Z9","2":"ys8L4h","3":"covidhgi2020C2v6alleur","4":"Nalls2019pd","5":"MR Egger","6":"19","7":"0.014046097","8":"0.029069196","9":"0.6351214"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Figure 1 illustrates the SNP-specific associations with Parkinsons Disease versus the association in COVID: C2 and the corresponding MR estimates.
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/harern01/projects/MRcovid/results/MRcovideurv6/Nalls2019pd/covidhgi2020C2v6alleur/Nalls2019pd_5e-8_covidhgi2020C2v6alleur_MR_Analaysis_files/figure-html/scatter_plot-1.png" alt="Fig. 1: Scatterplot of SNP effects for the association of the Exposure on the Outcome"  />
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
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["method"],"name":[5],"type":["chr"],"align":["left"]},{"label":["Q"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["Q_df"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["Q_pval"],"name":[8],"type":["dbl"],"align":["right"]}],"data":[{"1":"PfE1Z9","2":"ys8L4h","3":"covidhgi2020C2v6alleur","4":"Nalls2019pd","5":"MR Egger","6":"44.55471","7":"17","8":"0.0002835701"},{"1":"PfE1Z9","2":"ys8L4h","3":"covidhgi2020C2v6alleur","4":"Nalls2019pd","5":"Inverse variance weighted","6":"45.68020","7":"18","8":"0.0003302606"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Figure 2 shows a funnel plot displaying the MR estimates of individual genetic variants against their precession. Aysmmetry in the funnel plot may arrise due to some genetic variants having unusally strong effects on the outcome, which is indicative of directional pleiotropy.
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/harern01/projects/MRcovid/results/MRcovideurv6/Nalls2019pd/covidhgi2020C2v6alleur/Nalls2019pd_5e-8_covidhgi2020C2v6alleur_MR_Analaysis_files/figure-html/funnel_plot-1.png" alt="Fig. 2: Funnel plot of the MR causal estimates against their precession"  />
<p class="caption">Fig. 2: Funnel plot of the MR causal estimates against their precession</p>
</div>
<br>

Figure 3 shows a [Radial Plots](https://github.com/WSpiller/RadialMR) can be used to visualize influential data points with large contributions to Cochran's Q Statistic that may bias causal effect estimates.



<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/harern01/projects/MRcovid/results/MRcovideurv6/Nalls2019pd/covidhgi2020C2v6alleur/Nalls2019pd_5e-8_covidhgi2020C2v6alleur_MR_Analaysis_files/figure-html/Radial_Plot-1.png" alt="Fig. 4: Radial Plot showing influential data points using Radial IVW"  />
<p class="caption">Fig. 4: Radial Plot showing influential data points using Radial IVW</p>
</div>
<br>

The intercept of the MR-Egger Regression model captures the average pleitropic affect across all genetic variants (Table 8).
<br>

**Table 8:** MR Egger test for directional pleitropy
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["egger_intercept"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[7],"type":["dbl"],"align":["right"]}],"data":[{"1":"PfE1Z9","2":"ys8L4h","3":"covidhgi2020C2v6alleur","4":"Nalls2019pd","5":"-0.003095237","6":"0.004723303","7":"0.5210368"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Pleiotropy was also assesed using Mendelian Randomization Pleiotropy RESidual Sum and Outlier [(MR-PRESSO)](https://doi.org/10.1038/s41588-018-0099-7), that allows for the evlation of evaluation of horizontal pleiotropy in a standared MR model (Table 9). MR-PRESSO performs a global test for detection of horizontal pleiotropy and correction of pleiotropy via outlier removal (Table 10).
<br>

**Table 9:** MR-PRESSO Global Test for pleitropy
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["pt"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["outliers_removed"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["n_outliers"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["RSSobs"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"PfE1Z9","2":"ys8L4h","3":"covidhgi2020C2v6alleur","4":"Nalls2019pd","5":"5e-08","6":"FALSE","7":"3","8":"52.7809","9":"3e-04"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>


**Table 10:** MR Estimates after MR-PRESSO outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["method"],"name":[5],"type":["chr"],"align":["left"]},{"label":["nsnp"],"name":[6],"type":["int"],"align":["right"]},{"label":["b"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"PfE1Z9","2":"ys8L4h","3":"covidhgi2020C2v6alleur","4":"Nalls2019pd","5":"Inverse variance weighted (fixed effects)","6":"16","7":"0.003801843","8":"0.008986058","9":"0.6722352"},{"1":"PfE1Z9","2":"ys8L4h","3":"covidhgi2020C2v6alleur","4":"Nalls2019pd","5":"Weighted median","6":"16","7":"0.011920145","8":"0.012765411","9":"0.3504150"},{"1":"PfE1Z9","2":"ys8L4h","3":"covidhgi2020C2v6alleur","4":"Nalls2019pd","5":"Weighted mode","6":"16","7":"0.018888760","8":"0.017444423","9":"0.2959984"},{"1":"PfE1Z9","2":"ys8L4h","3":"covidhgi2020C2v6alleur","4":"Nalls2019pd","5":"MR Egger","6":"16","7":"0.008552841","8":"0.023985218","9":"0.7267173"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/harern01/projects/MRcovid/results/MRcovideurv6/Nalls2019pd/covidhgi2020C2v6alleur/Nalls2019pd_5e-8_covidhgi2020C2v6alleur_MR_Analaysis_files/figure-html/scatter_plot_outlier-1.png" alt="Fig. 5: Scatterplot of SNP effects for the association of the Exposure on the Outcome after outlier removal"  />
<p class="caption">Fig. 5: Scatterplot of SNP effects for the association of the Exposure on the Outcome after outlier removal</p>
</div>
<br>

**Table 11:** Heterogenity Tests after outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["method"],"name":[5],"type":["chr"],"align":["left"]},{"label":["Q"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["Q_df"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["Q_pval"],"name":[8],"type":["dbl"],"align":["right"]}],"data":[{"1":"PfE1Z9","2":"ys8L4h","3":"covidhgi2020C2v6alleur","4":"Nalls2019pd","5":"MR Egger","6":"18.18890","7":"14","8":"0.1983123"},{"1":"PfE1Z9","2":"ys8L4h","3":"covidhgi2020C2v6alleur","4":"Nalls2019pd","5":"Inverse variance weighted","6":"18.25125","7":"15","8":"0.2496873"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

**Table 12:** MR Egger test for directional pleitropy after outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["egger_intercept"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[7],"type":["dbl"],"align":["right"]}],"data":[{"1":"PfE1Z9","2":"ys8L4h","3":"covidhgi2020C2v6alleur","4":"Nalls2019pd","5":"-0.0008035279","6":"0.003668097","7":"0.8297659"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>
