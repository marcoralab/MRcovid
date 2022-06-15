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
## NA/sc/arion/projects/LOAD/harern01/projects/MRcovidNULLdata/MRcovideurv6/Allen2020ipf/Allen2020ipf_5e-8_SNPs.txtdata/MRcovideurv6/Allen2020ipf/covidhgi2020A2v6alleur/Allen2020ipf_5e-8_covidhgi2020A2v6alleur_SNPs.txtdata/MRcovideurv6/Allen2020ipf/covidhgi2020A2v6alleur/Allen2020ipf_5e-8_covidhgi2020A2v6alleur_MatchedProxys.csvdata/MRcovideurv6/Allen2020ipf/covidhgi2020A2v6alleur/Allen2020ipf_5e-8_covidhgi2020A2v6alleur_mrpresso_MRdat.csvdata/MRcovideurv6/Allen2020ipf/covidhgi2020A2v6alleur/Allen2020ipf_5e-8_covidhgi2020A2v6alleur_mrpresso_global.txtdata/MRcovideurv6/Allen2020ipf/covidhgi2020A2v6alleur/Allen2020ipf_5e-8_covidhgi2020A2v6alleur_MR_power.txtcovidhgi2020A2v6alleurAllen2020ipfCOVID: A2IPF5e-80.00110000results/MRcovideurv6/Allen2020ipf/covidhgi2020A2v6alleur/Allen2020ipf_5e-8_covidhgi2020A2v6alleur
```



## Instrumental Variables
**SNP Inclusion:** SNPS associated with at a p-value threshold of p < 5e-8 were included in this analysis.
<br>

**LD Clumping:** For standard two sample MR it is important to ensure that the instruments for the exposure are independent. LD clumping was performed in PLINK using the EUR samples from the 1000 Genomes Project to estimate LD between SNPs, and, amongst SNPs that have an LD above a given threshold, retain only the SNP with the lowest p-value. A clumping window of 10^{4}, r2 of 0.001 and significance level of 1 was used for the index and secondary SNPs.
<br>

**Proxy SNPs:** Where SNPs were not available in the outcome GWAS, the EUR thousand genomes was queried to identify potential proxy SNPs that are in linkage disequilibrium (r2 > 0.8) of the missing SNP.
<br>

### Exposure: IPF
`#r exposure.blurb`
<br>

**Table 1:** Independent SNPs associated with IPF
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["CHROM"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["REF"],"name":[4],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[5],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[12],"type":["chr"],"align":["left"]}],"data":[{"1":"rs78238620","2":"3","3":"44902386","4":"T","5":"A","6":"0.053459","7":"0.4593835","8":"0.07390969","9":"6.215471","10":"5.117086e-10","11":"11259","12":"Idiopathic_Pulmonary_Fibrosis"},{"1":"rs12696304","2":"3","3":"169481271","4":"C","5":"G","6":"0.278854","7":"0.2668156","8":"0.03717319","9":"7.177635","10":"7.092778e-13","11":"11259","12":"Idiopathic_Pulmonary_Fibrosis"},{"1":"rs2013701","2":"4","3":"89885086","4":"G","5":"T","6":"0.487438","7":"-0.2424697","8":"0.03330002","9":"-7.281368","10":"3.304528e-13","11":"11259","12":"Idiopathic_Pulmonary_Fibrosis"},{"1":"rs7725218","2":"5","3":"1282414","4":"G","5":"A","6":"0.323107","7":"-0.3293240","8":"0.03544862","9":"-9.290180","10":"1.540283e-20","11":"11259","12":"Idiopathic_Pulmonary_Fibrosis"},{"1":"rs2076295","2":"6","3":"7563232","4":"T","5":"G","6":"0.468835","7":"0.3799705","8":"0.03322854","9":"11.435066","10":"2.793256e-30","11":"11259","12":"Idiopathic_Pulmonary_Fibrosis"},{"1":"rs12699415","2":"7","3":"1909479","4":"A","5":"G","6":"0.580176","7":"-0.2440172","8":"0.03400225","9":"-7.176502","10":"7.151760e-13","11":"11259","12":"Idiopathic_Pulmonary_Fibrosis"},{"1":"rs2897075","2":"7","3":"99630342","4":"C","5":"T","6":"0.391410","7":"0.2585521","8":"0.03404714","9":"7.593945","10":"3.103096e-14","11":"11259","12":"Idiopathic_Pulmonary_Fibrosis"},{"1":"rs28513081","2":"8","3":"120934126","4":"A","5":"G","6":"0.427310","7":"-0.2034907","8":"0.03346963","9":"-6.079862","10":"1.202864e-09","11":"11259","12":"Idiopathic_Pulmonary_Fibrosis"},{"1":"rs35705950","2":"11","3":"1241221","4":"G","5":"T","6":"0.140904","7":"1.5773608","8":"0.05180105","9":"30.450365","10":"1.184630e-203","11":"11259","12":"Idiopathic_Pulmonary_Fibrosis"},{"1":"rs9577395","2":"13","3":"113534984","4":"C","5":"G","6":"0.207732","7":"-0.2642992","8":"0.04115030","9":"-6.422778","10":"1.338099e-10","11":"11259","12":"Idiopathic_Pulmonary_Fibrosis"},{"1":"rs59424629","2":"15","3":"40720542","4":"G","5":"T","6":"0.538260","7":"0.2678313","8":"0.03320740","9":"8.065411","10":"7.298965e-16","11":"11259","12":"Idiopathic_Pulmonary_Fibrosis"},{"1":"rs62023891","2":"15","3":"86097216","4":"G","5":"A","6":"0.300615","7":"0.2356498","8":"0.03664299","9":"6.430965","10":"1.267962e-10","11":"11259","12":"Idiopathic_Pulmonary_Fibrosis"},{"1":"rs17652520","2":"17","3":"44098967","4":"G","5":"A","6":"0.214766","7":"-0.3286135","8":"0.04066747","9":"-8.080502","10":"6.450078e-16","11":"11259","12":"Idiopathic_Pulmonary_Fibrosis"},{"1":"rs12610495","2":"19","3":"4717672","4":"A","5":"G","6":"0.305555","7":"0.2722340","8":"0.03899250","9":"6.981701","10":"2.916276e-12","11":"11259","12":"Idiopathic_Pulmonary_Fibrosis"},{"1":"rs41308092","2":"20","3":"62324391","4":"G","5":"A","6":"0.019674","7":"0.7503587","8":"0.12196998","9":"6.151995","10":"7.651443e-10","11":"11259","12":"Idiopathic_Pulmonary_Fibrosis"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

### Outcome: COVID: A2
`#r outcome.blurb`
<br>

**Table 2:** SNPs associated with IPF avaliable in COVID: A2
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["CHROM"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["REF"],"name":[4],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[5],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[12],"type":["chr"],"align":["left"]}],"data":[{"1":"rs78238620","2":"3","3":"44902386","4":"T","5":"A","6":"0.04895","7":"0.03475400","8":"0.042428","9":"0.819128877","10":"4.1271e-01","11":"1639838","12":"COVID_A2__EUR"},{"1":"rs12696304","2":"3","3":"169481271","4":"C","5":"G","6":"0.26900","7":"-0.01184600","8":"0.021656","9":"-0.547007758","10":"5.8437e-01","11":"1639838","12":"COVID_A2__EUR"},{"1":"rs2013701","2":"4","3":"89885086","4":"G","5":"T","6":"0.49640","7":"-0.02077800","8":"0.019135","9":"-1.085863601","10":"2.7754e-01","11":"1639435","12":"COVID_A2__EUR"},{"1":"rs7725218","2":"5","3":"1282414","4":"G","5":"A","6":"0.34800","7":"-0.00016365","8":"0.019834","9":"-0.008250983","10":"9.9342e-01","11":"1639838","12":"COVID_A2__EUR"},{"1":"rs2076295","2":"6","3":"7563232","4":"T","5":"G","6":"0.43830","7":"0.08015400","8":"0.021603","9":"3.710318011","10":"2.0696e-04","11":"1629782","12":"COVID_A2__EUR"},{"1":"rs12699415","2":"7","3":"1909479","4":"A","5":"G","6":"0.58690","7":"-0.04985100","8":"0.019382","9":"-2.572025591","10":"1.0112e-02","11":"1639838","12":"COVID_A2__EUR"},{"1":"rs2897075","2":"7","3":"99630342","4":"C","5":"T","6":"0.37560","7":"0.08450700","8":"0.019596","9":"4.312461727","10":"1.6153e-05","11":"1639435","12":"COVID_A2__EUR"},{"1":"rs28513081","2":"8","3":"120934126","4":"A","5":"G","6":"0.44780","7":"-0.00902270","8":"0.021736","9":"-0.415103975","10":"6.7807e-01","11":"1628824","12":"COVID_A2__EUR"},{"1":"rs35705950","2":"11","3":"1241221","4":"G","5":"T","6":"0.10820","7":"-0.17451000","8":"0.035937","9":"-4.855997996","10":"1.1981e-06","11":"1628100","12":"COVID_A2__EUR"},{"1":"rs9577395","2":"13","3":"113534984","4":"C","5":"G","6":"0.21550","7":"0.10744000","8":"0.023310","9":"4.609180609","10":"4.0470e-06","11":"1639838","12":"COVID_A2__EUR"},{"1":"rs59424629","2":"15","3":"40720542","4":"G","5":"T","6":"0.53880","7":"0.02176600","8":"0.019179","9":"1.134887116","10":"2.5642e-01","11":"1639838","12":"COVID_A2__EUR"},{"1":"rs62023891","2":"15","3":"86097216","4":"G","5":"A","6":"0.29130","7":"0.01528400","8":"0.021749","9":"0.702744954","10":"4.8222e-01","11":"1639838","12":"COVID_A2__EUR"},{"1":"rs17652520","2":"17","3":"44098967","4":"G","5":"A","6":"0.20280","7":"-0.11087000","8":"0.025624","9":"-4.326802997","10":"1.5132e-05","11":"1629782","12":"COVID_A2__EUR"},{"1":"rs12610495","2":"19","3":"4717672","4":"A","5":"G","6":"0.30470","7":"0.19079000","8":"0.023611","9":"8.080555673","10":"6.4618e-16","11":"1629058","12":"COVID_A2__EUR"},{"1":"rs41308092","2":"20","3":"62324391","4":"G","5":"A","6":"0.02463","7":"-0.00594120","8":"0.074965","9":"-0.079252985","10":"9.3683e-01","11":"1633922","12":"COVID_A2__EUR"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
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

**Table 4:** Harmonized IPF and COVID: A2 datasets
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["effect_allele.exposure"],"name":[2],"type":["chr"],"align":["left"]},{"label":["other_allele.exposure"],"name":[3],"type":["chr"],"align":["left"]},{"label":["effect_allele.outcome"],"name":[4],"type":["chr"],"align":["left"]},{"label":["other_allele.outcome"],"name":[5],"type":["chr"],"align":["left"]},{"label":["beta.exposure"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["beta.outcome"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["eaf.exposure"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["eaf.outcome"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["remove"],"name":[10],"type":["lgl"],"align":["right"]},{"label":["palindromic"],"name":[11],"type":["lgl"],"align":["right"]},{"label":["ambiguous"],"name":[12],"type":["lgl"],"align":["right"]},{"label":["id.outcome"],"name":[13],"type":["chr"],"align":["left"]},{"label":["chr.outcome"],"name":[14],"type":["dbl"],"align":["right"]},{"label":["pos.outcome"],"name":[15],"type":["dbl"],"align":["right"]},{"label":["se.outcome"],"name":[16],"type":["dbl"],"align":["right"]},{"label":["z.outcome"],"name":[17],"type":["dbl"],"align":["right"]},{"label":["pval.outcome"],"name":[18],"type":["dbl"],"align":["right"]},{"label":["samplesize.outcome"],"name":[19],"type":["dbl"],"align":["right"]},{"label":["outcome"],"name":[20],"type":["chr"],"align":["left"]},{"label":["mr_keep.outcome"],"name":[21],"type":["lgl"],"align":["right"]},{"label":["pval_origin.outcome"],"name":[22],"type":["chr"],"align":["left"]},{"label":["chr.exposure"],"name":[23],"type":["dbl"],"align":["right"]},{"label":["pos.exposure"],"name":[24],"type":["dbl"],"align":["right"]},{"label":["se.exposure"],"name":[25],"type":["dbl"],"align":["right"]},{"label":["z.exposure"],"name":[26],"type":["dbl"],"align":["right"]},{"label":["pval.exposure"],"name":[27],"type":["dbl"],"align":["right"]},{"label":["samplesize.exposure"],"name":[28],"type":["dbl"],"align":["right"]},{"label":["exposure"],"name":[29],"type":["chr"],"align":["left"]},{"label":["mr_keep.exposure"],"name":[30],"type":["lgl"],"align":["right"]},{"label":["pval_origin.exposure"],"name":[31],"type":["chr"],"align":["left"]},{"label":["id.exposure"],"name":[32],"type":["chr"],"align":["left"]},{"label":["action"],"name":[33],"type":["dbl"],"align":["right"]},{"label":["mr_keep"],"name":[34],"type":["lgl"],"align":["right"]},{"label":["pt"],"name":[35],"type":["dbl"],"align":["right"]},{"label":["pleitropy_keep"],"name":[36],"type":["lgl"],"align":["right"]},{"label":["mrpresso_RSSobs"],"name":[37],"type":["dbl"],"align":["right"]},{"label":["mrpresso_pval"],"name":[38],"type":["chr"],"align":["left"]},{"label":["mrpresso_keep"],"name":[39],"type":["lgl"],"align":["right"]}],"data":[{"1":"rs12610495","2":"G","3":"A","4":"G","5":"A","6":"0.2722340","7":"0.19079000","8":"0.305555","9":"0.30470","10":"FALSE","11":"FALSE","12":"FALSE","13":"Y8Ob9O","14":"19","15":"4717672","16":"0.023611","17":"8.080555673","18":"6.4618e-16","19":"1629058","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"19","24":"4717672","25":"0.03899250","26":"6.981701","27":"2.916276e-12","28":"11259","29":"Allen2020ipf","30":"TRUE","31":"reported","32":"ewCP4n","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"3.672826e-02","38":"<0.0015","39":"FALSE"},{"1":"rs12696304","2":"G","3":"C","4":"G","5":"C","6":"0.2668156","7":"-0.01184600","8":"0.278854","9":"0.26900","10":"FALSE","11":"TRUE","12":"FALSE","13":"Y8Ob9O","14":"3","15":"169481271","16":"0.021656","17":"-0.547007758","18":"5.8437e-01","19":"1639838","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"3","24":"169481271","25":"0.03717319","26":"7.177635","27":"7.092778e-13","28":"11259","29":"Allen2020ipf","30":"TRUE","31":"reported","32":"ewCP4n","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"3.093321e-04","38":"1","39":"TRUE"},{"1":"rs12699415","2":"G","3":"A","4":"G","5":"A","6":"-0.2440172","7":"-0.04985100","8":"0.580176","9":"0.58690","10":"FALSE","11":"FALSE","12":"FALSE","13":"Y8Ob9O","14":"7","15":"1909479","16":"0.019382","17":"-2.572025591","18":"1.0112e-02","19":"1639838","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"7","24":"1909479","25":"0.03400225","26":"-7.176502","27":"7.151760e-13","28":"11259","29":"Allen2020ipf","30":"TRUE","31":"reported","32":"ewCP4n","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"2.204594e-03","38":"0.276","39":"TRUE"},{"1":"rs17652520","2":"A","3":"G","4":"A","5":"G","6":"-0.3286135","7":"-0.11087000","8":"0.214766","9":"0.20280","10":"FALSE","11":"FALSE","12":"FALSE","13":"Y8Ob9O","14":"17","15":"44098967","16":"0.025624","17":"-4.326802997","18":"1.5132e-05","19":"1629782","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"17","24":"44098967","25":"0.04066747","26":"-8.080502","27":"6.450078e-16","28":"11259","29":"Allen2020ipf","30":"TRUE","31":"reported","32":"ewCP4n","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"1.184687e-02","38":"<0.0015","39":"FALSE"},{"1":"rs2013701","2":"T","3":"G","4":"T","5":"G","6":"-0.2424697","7":"-0.02077800","8":"0.487438","9":"0.49640","10":"FALSE","11":"FALSE","12":"FALSE","13":"Y8Ob9O","14":"4","15":"89885086","16":"0.019135","17":"-1.085863601","18":"2.7754e-01","19":"1639435","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"4","24":"89885086","25":"0.03330002","26":"-7.281368","27":"3.304528e-13","28":"11259","29":"Allen2020ipf","30":"TRUE","31":"reported","32":"ewCP4n","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"2.815423e-04","38":"1","39":"TRUE"},{"1":"rs2076295","2":"G","3":"T","4":"G","5":"T","6":"0.3799705","7":"0.08015400","8":"0.468835","9":"0.43830","10":"FALSE","11":"FALSE","12":"FALSE","13":"Y8Ob9O","14":"6","15":"7563232","16":"0.021603","17":"3.710318011","18":"2.0696e-04","19":"1629782","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"6","24":"7563232","25":"0.03322854","26":"11.435066","27":"2.793256e-30","28":"11259","29":"Allen2020ipf","30":"TRUE","31":"reported","32":"ewCP4n","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"6.190163e-03","38":"0.0015","39":"FALSE"},{"1":"rs28513081","2":"G","3":"A","4":"G","5":"A","6":"-0.2034907","7":"-0.00902270","8":"0.427310","9":"0.44780","10":"FALSE","11":"FALSE","12":"FALSE","13":"Y8Ob9O","14":"8","15":"120934126","16":"0.021736","17":"-0.415103975","18":"6.7807e-01","19":"1628824","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"8","24":"120934126","25":"0.03346963","26":"-6.079862","27":"1.202864e-09","28":"11259","29":"Allen2020ipf","30":"TRUE","31":"reported","32":"ewCP4n","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"2.743355e-05","38":"1","39":"TRUE"},{"1":"rs2897075","2":"T","3":"C","4":"T","5":"C","6":"0.2585521","7":"0.08450700","8":"0.391410","9":"0.37560","10":"FALSE","11":"FALSE","12":"FALSE","13":"Y8Ob9O","14":"7","15":"99630342","16":"0.019596","17":"4.312461727","18":"1.6153e-05","19":"1639435","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"7","24":"99630342","25":"0.03404714","26":"7.593945","27":"3.103096e-14","28":"11259","29":"Allen2020ipf","30":"TRUE","31":"reported","32":"ewCP4n","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"6.888864e-03","38":"<0.0015","39":"FALSE"},{"1":"rs35705950","2":"T","3":"G","4":"T","5":"G","6":"1.5773608","7":"-0.17451000","8":"0.140904","9":"0.10820","10":"FALSE","11":"FALSE","12":"FALSE","13":"Y8Ob9O","14":"11","15":"1241221","16":"0.035937","17":"-4.855997996","18":"1.1981e-06","19":"1628100","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"11","24":"1241221","25":"0.05180105","26":"30.450365","27":"1.000000e-200","28":"11259","29":"Allen2020ipf","30":"TRUE","31":"reported","32":"ewCP4n","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"1.430032e-01","38":"<0.0015","39":"FALSE"},{"1":"rs41308092","2":"A","3":"G","4":"A","5":"G","6":"0.7503587","7":"-0.00594120","8":"0.019674","9":"0.02463","10":"FALSE","11":"FALSE","12":"FALSE","13":"Y8Ob9O","14":"20","15":"62324391","16":"0.074965","17":"-0.079252985","18":"9.3683e-01","19":"1633922","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"20","24":"62324391","25":"0.12196998","26":"6.151995","27":"7.651443e-10","28":"11259","29":"Allen2020ipf","30":"TRUE","31":"reported","32":"ewCP4n","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"4.325264e-04","38":"1","39":"TRUE"},{"1":"rs59424629","2":"T","3":"G","4":"T","5":"G","6":"0.2678313","7":"0.02176600","8":"0.538260","9":"0.53880","10":"FALSE","11":"FALSE","12":"FALSE","13":"Y8Ob9O","14":"15","15":"40720542","16":"0.019179","17":"1.134887116","18":"2.5642e-01","19":"1639838","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"15","24":"40720542","25":"0.03320740","26":"8.065411","27":"7.298965e-16","28":"11259","29":"Allen2020ipf","30":"TRUE","31":"reported","32":"ewCP4n","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"3.045257e-04","38":"1","39":"TRUE"},{"1":"rs62023891","2":"A","3":"G","4":"A","5":"G","6":"0.2356498","7":"0.01528400","8":"0.300615","9":"0.29130","10":"FALSE","11":"FALSE","12":"FALSE","13":"Y8Ob9O","14":"15","15":"86097216","16":"0.021749","17":"0.702744954","18":"4.8222e-01","19":"1639838","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"15","24":"86097216","25":"0.03664299","26":"6.430965","27":"1.267962e-10","28":"11259","29":"Allen2020ipf","30":"TRUE","31":"reported","32":"ewCP4n","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"1.228568e-04","38":"1","39":"TRUE"},{"1":"rs7725218","2":"A","3":"G","4":"A","5":"G","6":"-0.3293240","7":"-0.00016365","8":"0.323107","9":"0.34800","10":"FALSE","11":"FALSE","12":"FALSE","13":"Y8Ob9O","14":"5","15":"1282414","16":"0.019834","17":"-0.008250983","18":"9.9342e-01","19":"1639838","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"5","24":"1282414","25":"0.03544862","26":"-9.290180","27":"1.540283e-20","28":"11259","29":"Allen2020ipf","30":"TRUE","31":"reported","32":"ewCP4n","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"4.316545e-05","38":"1","39":"TRUE"},{"1":"rs78238620","2":"A","3":"T","4":"A","5":"T","6":"0.4593835","7":"0.03475400","8":"0.053459","9":"0.04895","10":"FALSE","11":"TRUE","12":"FALSE","13":"Y8Ob9O","14":"3","15":"44902386","16":"0.042428","17":"0.819128877","18":"4.1271e-01","19":"1639838","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"3","24":"44902386","25":"0.07390969","26":"6.215471","27":"5.117086e-10","28":"11259","29":"Allen2020ipf","30":"TRUE","31":"reported","32":"ewCP4n","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"7.133199e-04","38":"1","39":"TRUE"},{"1":"rs9577395","2":"G","3":"C","4":"G","5":"C","6":"-0.2642992","7":"0.10744000","8":"0.207732","9":"0.21550","10":"FALSE","11":"TRUE","12":"FALSE","13":"Y8Ob9O","14":"13","15":"113534984","16":"0.023310","17":"4.609180609","18":"4.0470e-06","19":"1639838","20":"covidhgi2020A2v6alleur","21":"TRUE","22":"reported","23":"13","24":"113534984","25":"0.04115030","26":"-6.422778","27":"1.338099e-10","28":"11259","29":"Allen2020ipf","30":"TRUE","31":"reported","32":"ewCP4n","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"1.346767e-02","38":"<0.0015","39":"FALSE"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
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
{"columns":[{"label":["outliers_removed"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["pve.exposure"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["F"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["Alpha"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["NCP"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["Power"],"name":[6],"type":["dbl"],"align":["right"]}],"data":[{"1":"FALSE","2":"0.14289659","3":"124.96246","4":"0.05","5":"4.777657","6":"0.5893467"},{"1":"TRUE","2":"0.04140646","3":"53.98897","4":"0.05","5":"6.837047","6":"0.7437076"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

The I2_GX statistic can be used to quantify the strength of the NOME violation for MR-Egger regression and should be used to evalute potential bias in the MR-Egger causal estimate, with values less then 90% indicating that causal estimated should interpreted with caution due to regression diluation.

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["outliers_removed"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["Isq_gx"],"name":[2],"type":["dbl"],"align":["right"]}],"data":[{"1":"FALSE","2":"0.9694121"},{"1":"TRUE","2":"0.4110322"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>


## MR Results
To obtain an overall estimate of causal effect, the SNP-exposure and SNP-outcome coefficients were combined in 1) a fixed-effects meta-analysis using an inverse-variance weighted approach (IVW); 2) a Weighted Median approach; 3) Weighted Mode approach and 4) Egger Regression.


[**IVW**](https://doi.org/10.1002/gepi.21758) is equivalent to a weighted regression of the SNP-outcome coefficients on the SNP-exposure coefficients with the intercept constrained to zero. This method assumes that all variants are valid instrumental variables based on the Mendelian randomization assumptions. The causal estimate of the IVW analysis expresses the causal increase in the outcome (or log odds of the outcome for a binary outcome) per unit change in the exposure. [**Weighted median MR**](https://doi.org/10.1002/gepi.21965) allows for 50% of the instrumental variables to be invalid. [**MR-Egger regression**](https://doi.org/10.1093/ije/dyw220) allows all the instrumental variables to be subject to direct effects (i.e. horizontal pleiotropy), with the intercept representing bias in the causal estimate due to pleiotropy and the slope representing the causal estimate. [**Weighted Mode**](https://doi.org/10.1093/ije/dyx102) gives consistent estimates as the sample size increases if a plurality (or weighted plurality) of the genetic variants are valid instruments.
<br>



Table 6 presents the MR causal estimates of genetically predicted IPF on COVID: A2.
<br>

**Table 6** MR causaul estimates for IPF on COVID: A2
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["method"],"name":[5],"type":["chr"],"align":["left"]},{"label":["nsnp"],"name":[6],"type":["int"],"align":["right"]},{"label":["b"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"ewCP4n","2":"Y8Ob9O","3":"covidhgi2020A2v6alleur","4":"Allen2020ipf","5":"Inverse variance weighted (fixed effects)","6":"15","7":"0.01913746","8":"0.01543033","9":"0.214883052"},{"1":"ewCP4n","2":"Y8Ob9O","3":"covidhgi2020A2v6alleur","4":"Allen2020ipf","5":"Weighted median","6":"15","7":"-0.05041323","8":"0.03097735","9":"0.103647459"},{"1":"ewCP4n","2":"Y8Ob9O","3":"covidhgi2020A2v6alleur","4":"Allen2020ipf","5":"Weighted mode","6":"15","7":"-0.08276261","8":"0.02379751","9":"0.003694799"},{"1":"ewCP4n","2":"Y8Ob9O","3":"covidhgi2020A2v6alleur","4":"Allen2020ipf","5":"MR Egger","6":"15","7":"-0.13831670","8":"0.08141148","9":"0.113111256"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Figure 1 illustrates the SNP-specific associations with IPF versus the association in COVID: A2 and the corresponding MR estimates.
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/harern01/projects/MRcovid/results/MRcovideurv6/Allen2020ipf/covidhgi2020A2v6alleur/Allen2020ipf_5e-8_covidhgi2020A2v6alleur_MR_Analaysis_files/figure-html/scatter_plot-1.png" alt="Fig. 1: Scatterplot of SNP effects for the association of the Exposure on the Outcome"  />
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
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["method"],"name":[5],"type":["chr"],"align":["left"]},{"label":["Q"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["Q_df"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["Q_pval"],"name":[8],"type":["dbl"],"align":["right"]}],"data":[{"1":"ewCP4n","2":"Y8Ob9O","3":"covidhgi2020A2v6alleur","4":"Allen2020ipf","5":"MR Egger","6":"119.2292","7":"13","8":"2.858852e-19"},{"1":"ewCP4n","2":"Y8Ob9O","3":"covidhgi2020A2v6alleur","4":"Allen2020ipf","5":"Inverse variance weighted","6":"170.3925","7":"14","8":"5.704754e-29"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Figure 2 shows a funnel plot displaying the MR estimates of individual genetic variants against their precession. Aysmmetry in the funnel plot may arrise due to some genetic variants having unusally strong effects on the outcome, which is indicative of directional pleiotropy.
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/harern01/projects/MRcovid/results/MRcovideurv6/Allen2020ipf/covidhgi2020A2v6alleur/Allen2020ipf_5e-8_covidhgi2020A2v6alleur_MR_Analaysis_files/figure-html/funnel_plot-1.png" alt="Fig. 2: Funnel plot of the MR causal estimates against their precession"  />
<p class="caption">Fig. 2: Funnel plot of the MR causal estimates against their precession</p>
</div>
<br>

Figure 3 shows a [Radial Plots](https://github.com/WSpiller/RadialMR) can be used to visualize influential data points with large contributions to Cochran's Q Statistic that may bias causal effect estimates.



<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/harern01/projects/MRcovid/results/MRcovideurv6/Allen2020ipf/covidhgi2020A2v6alleur/Allen2020ipf_5e-8_covidhgi2020A2v6alleur_MR_Analaysis_files/figure-html/Radial_Plot-1.png" alt="Fig. 4: Radial Plot showing influential data points using Radial IVW"  />
<p class="caption">Fig. 4: Radial Plot showing influential data points using Radial IVW</p>
</div>
<br>

The intercept of the MR-Egger Regression model captures the average pleitropic affect across all genetic variants (Table 8).
<br>

**Table 8:** MR Egger test for directional pleitropy
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["egger_intercept"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[7],"type":["dbl"],"align":["right"]}],"data":[{"1":"ewCP4n","2":"Y8Ob9O","3":"covidhgi2020A2v6alleur","4":"Allen2020ipf","5":"0.07390821","6":"0.03129195","7":"0.03445346"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Pleiotropy was also assesed using Mendelian Randomization Pleiotropy RESidual Sum and Outlier [(MR-PRESSO)](https://doi.org/10.1038/s41588-018-0099-7), that allows for the evlation of evaluation of horizontal pleiotropy in a standared MR model (Table 9). MR-PRESSO performs a global test for detection of horizontal pleiotropy and correction of pleiotropy via outlier removal (Table 10).
<br>

**Table 9:** MR-PRESSO Global Test for pleitropy
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["pt"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["outliers_removed"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["n_outliers"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["RSSobs"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["chr"],"align":["left"]}],"data":[{"1":"ewCP4n","2":"Y8Ob9O","3":"covidhgi2020A2v6alleur","4":"Allen2020ipf","5":"5e-08","6":"FALSE","7":"6","8":"259.6703","9":"<1e-04"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>


**Table 10:** MR Estimates after MR-PRESSO outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["method"],"name":[5],"type":["chr"],"align":["left"]},{"label":["nsnp"],"name":[6],"type":["int"],"align":["right"]},{"label":["b"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"ewCP4n","2":"Y8Ob9O","3":"covidhgi2020A2v6alleur","4":"Allen2020ipf","5":"Inverse variance weighted (fixed effects)","6":"9","7":"0.05495660","8":"0.02707608","9":"0.04238601"},{"1":"ewCP4n","2":"Y8Ob9O","3":"covidhgi2020A2v6alleur","4":"Allen2020ipf","5":"Weighted median","6":"9","7":"0.06384659","8":"0.03727723","9":"0.08675848"},{"1":"ewCP4n","2":"Y8Ob9O","3":"covidhgi2020A2v6alleur","4":"Allen2020ipf","5":"Weighted mode","6":"9","7":"0.07750806","8":"0.05441926","9":"0.19218257"},{"1":"ewCP4n","2":"Y8Ob9O","3":"covidhgi2020A2v6alleur","4":"Allen2020ipf","5":"MR Egger","6":"9","7":"-0.04421332","8":"0.10805825","9":"0.69465020"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/harern01/projects/MRcovid/results/MRcovideurv6/Allen2020ipf/covidhgi2020A2v6alleur/Allen2020ipf_5e-8_covidhgi2020A2v6alleur_MR_Analaysis_files/figure-html/scatter_plot_outlier-1.png" alt="Fig. 5: Scatterplot of SNP effects for the association of the Exposure on the Outcome after outlier removal"  />
<p class="caption">Fig. 5: Scatterplot of SNP effects for the association of the Exposure on the Outcome after outlier removal</p>
</div>
<br>

**Table 11:** Heterogenity Tests after outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["method"],"name":[5],"type":["chr"],"align":["left"]},{"label":["Q"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["Q_df"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["Q_pval"],"name":[8],"type":["dbl"],"align":["right"]}],"data":[{"1":"ewCP4n","2":"Y8Ob9O","3":"covidhgi2020A2v6alleur","4":"Allen2020ipf","5":"MR Egger","6":"5.706682","7":"7","8":"0.5743852"},{"1":"ewCP4n","2":"Y8Ob9O","3":"covidhgi2020A2v6alleur","4":"Allen2020ipf","5":"Inverse variance weighted","6":"6.605361","7":"8","8":"0.5797461"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

**Table 12:** MR Egger test for directional pleitropy after outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["egger_intercept"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[7],"type":["dbl"],"align":["right"]}],"data":[{"1":"ewCP4n","2":"Y8Ob9O","3":"covidhgi2020A2v6alleur","4":"Allen2020ipf","5":"0.02839705","6":"0.02995511","7":"0.3747056"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>
