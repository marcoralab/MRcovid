---
title: "Mendelian Randomization Analysis"
author: "Dr. Shea Andrews"
date: "2021-01-12"
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
  mrpresso_global_wo_outliers: NA
  power: NA
  out: NA
editor_options:
  chunk_output_type: console
---






## Instrumental Variables
**SNP Inclusion:** SNPS associated with at a p-value threshold of p < 5e-8 were included in this analysis.
<br>

**LD Clumping:** For standard two sample MR it is important to ensure that the instruments for the exposure are independent. LD clumping was performed in PLINK using the EUR samples from the 1000 Genomes Project to estimate LD between SNPs, and, amongst SNPs that have an LD above a given threshold, retain only the SNP with the lowest p-value. A clumping window of 10^{4}, r2 of 0.001 and significance level of 1 was used for the index and secondary SNPs.
<br>

**Proxy SNPs:** Where SNPs were not available in the outcome GWAS, the EUR thousand genomes was queried to identify potential proxy SNPs that are in linkage disequilibrium (r2 > 0.8) of the missing SNP.
<br>

### Exposure: Age at first birth
`#r exposure.blurb`
<br>

**Table 1:** Independent SNPs associated with Age at first birth
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["CHROM"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["REF"],"name":[4],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[5],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[12],"type":["chr"],"align":["left"]}],"data":[{"1":"rs10908557","2":"1","3":"153927052","4":"C","5":"G","6":"0.303383","7":"-0.01191490","8":"0.001978896","9":"-6.021","10":"1.735e-09","11":"251151","12":"AgeFirstBirth"},{"1":"rs1160544","2":"2","3":"100832218","4":"A","5":"C","6":"0.605961","7":"0.01151460","8":"0.001979474","9":"5.817","10":"6.005e-09","11":"251151","12":"AgeFirstBirth"},{"1":"rs2777888","2":"3","3":"49898000","4":"A","5":"G","6":"0.484810","7":"-0.01551740","8":"0.001973724","9":"-7.862","10":"3.790e-15","11":"251151","12":"AgeFirstBirth"},{"1":"rs6885307","2":"5","3":"45094503","4":"A","5":"C","6":"0.205840","7":"0.01255030","8":"0.001977982","9":"6.345","10":"2.229e-10","11":"251151","12":"AgeFirstBirth"},{"1":"rs2347867","2":"6","3":"152229850","4":"G","5":"A","6":"0.697619","7":"0.01196593","8":"0.001978822","9":"6.047","10":"1.473e-09","11":"251151","12":"AgeFirstBirth"},{"1":"rs4730639","2":"7","3":"114343576","4":"T","5":"A","6":"0.537400","7":"-0.01286383","8":"0.001977530","9":"-6.505","10":"7.762e-11","11":"251151","12":"AgeFirstBirth"},{"1":"rs293566","2":"20","3":"31097877","4":"T","5":"C","6":"0.415577","7":"-0.01095690","8":"0.001980280","9":"-5.533","10":"3.154e-08","11":"251151","12":"AgeFirstBirth"},{"1":"rs242997","2":"22","3":"34503059","4":"A","5":"G","6":"0.367216","7":"0.01162450","8":"0.001979315","9":"5.873","10":"4.279e-09","11":"251151","12":"AgeFirstBirth"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

### Outcome: COVID: C2, EUR w/o UKBB
`#r outcome.blurb`
<br>

**Table 2:** SNPs associated with Age at first birth avaliable in COVID: C2, EUR w/o UKBB
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["CHROM"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["REF"],"name":[4],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[5],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[12],"type":["chr"],"align":["left"]}],"data":[{"1":"rs10908557","2":"1","3":"153927052","4":"C","5":"G","6":"0.3183","7":"-0.0141640","8":"0.0097070","9":"-1.4591532","10":"0.144500","11":"1343083","12":"COVID_C2__EUR_w/o_UKBB"},{"1":"rs1160544","2":"2","3":"100832218","4":"A","5":"C","6":"0.6127","7":"0.0156020","8":"0.0091987","9":"1.6961092","10":"0.089860","11":"1348037","12":"COVID_C2__EUR_w/o_UKBB"},{"1":"rs2777888","2":"3","3":"49898000","4":"A","5":"G","6":"0.4661","7":"0.0256380","8":"0.0104200","9":"2.4604607","10":"0.013870","11":"1277946","12":"COVID_C2__EUR_w/o_UKBB"},{"1":"rs6885307","2":"5","3":"45094503","4":"A","5":"C","6":"0.2114","7":"0.0042308","8":"0.0113410","9":"0.3730535","10":"0.709100","11":"1073512","12":"COVID_C2__EUR_w/o_UKBB"},{"1":"rs2347867","2":"6","3":"152229850","4":"G","5":"A","6":"0.6472","7":"-0.0304000","8":"0.0117260","9":"-2.5925294","10":"0.009525","11":"1253717","12":"COVID_C2__EUR_w/o_UKBB"},{"1":"rs4730639","2":"7","3":"114343576","4":"T","5":"A","6":"0.5188","7":"0.0065283","8":"0.0094614","9":"0.6899930","10":"0.490200","11":"1329526","12":"COVID_C2__EUR_w/o_UKBB"},{"1":"rs293566","2":"20","3":"31097877","4":"T","5":"C","6":"0.3948","7":"0.0068122","8":"0.0098062","9":"0.6946830","10":"0.487300","11":"1267531","12":"COVID_C2__EUR_w/o_UKBB"},{"1":"rs242997","2":"22","3":"34503059","4":"A","5":"G","6":"0.3648","7":"0.0020618","8":"0.0112130","9":"0.1838759","10":"0.854100","11":"1265956","12":"COVID_C2__EUR_w/o_UKBB"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

**Table 3:** Proxy SNPs for COVID: C2, EUR w/o UKBB
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["proxy.outcome"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["target_snp"],"name":[2],"type":["lgl"],"align":["right"]},{"label":["proxy_snp"],"name":[3],"type":["lgl"],"align":["right"]},{"label":["ld.r2"],"name":[4],"type":["lgl"],"align":["right"]},{"label":["Dprime"],"name":[5],"type":["lgl"],"align":["right"]},{"label":["ref.proxy"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["alt.proxy"],"name":[7],"type":["lgl"],"align":["right"]},{"label":["CHROM"],"name":[8],"type":["lgl"],"align":["right"]},{"label":["POS"],"name":[9],"type":["lgl"],"align":["right"]},{"label":["ALT.proxy"],"name":[10],"type":["lgl"],"align":["right"]},{"label":["REF.proxy"],"name":[11],"type":["lgl"],"align":["right"]},{"label":["AF"],"name":[12],"type":["lgl"],"align":["right"]},{"label":["BETA"],"name":[13],"type":["lgl"],"align":["right"]},{"label":["SE"],"name":[14],"type":["lgl"],"align":["right"]},{"label":["P"],"name":[15],"type":["lgl"],"align":["right"]},{"label":["N"],"name":[16],"type":["lgl"],"align":["right"]},{"label":["ref"],"name":[17],"type":["lgl"],"align":["right"]},{"label":["alt"],"name":[18],"type":["lgl"],"align":["right"]},{"label":["ALT"],"name":[19],"type":["lgl"],"align":["right"]},{"label":["REF"],"name":[20],"type":["lgl"],"align":["right"]},{"label":["PHASE"],"name":[21],"type":["lgl"],"align":["right"]}],"data":[{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA","13":"NA","14":"NA","15":"NA","16":"NA","17":"NA","18":"NA","19":"NA","20":"NA","21":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

## Data harmonization
Harmonize the exposure and outcome datasets so that the effect of a SNP on the exposure and the effect of that SNP on the outcome correspond to the same allele. The harmonise_data function from the TwoSampleMR package can be used to perform the harmonization step, by default it try's to infer the forward strand alleles using allele frequency information.
<br>

**Table 4:** Harmonized Age at first birth and COVID: C2, EUR w/o UKBB datasets
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["effect_allele.exposure"],"name":[2],"type":["chr"],"align":["left"]},{"label":["other_allele.exposure"],"name":[3],"type":["chr"],"align":["left"]},{"label":["effect_allele.outcome"],"name":[4],"type":["chr"],"align":["left"]},{"label":["other_allele.outcome"],"name":[5],"type":["chr"],"align":["left"]},{"label":["beta.exposure"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["beta.outcome"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["eaf.exposure"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["eaf.outcome"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["remove"],"name":[10],"type":["lgl"],"align":["right"]},{"label":["palindromic"],"name":[11],"type":["lgl"],"align":["right"]},{"label":["ambiguous"],"name":[12],"type":["lgl"],"align":["right"]},{"label":["id.outcome"],"name":[13],"type":["chr"],"align":["left"]},{"label":["chr.outcome"],"name":[14],"type":["dbl"],"align":["right"]},{"label":["pos.outcome"],"name":[15],"type":["dbl"],"align":["right"]},{"label":["se.outcome"],"name":[16],"type":["dbl"],"align":["right"]},{"label":["z.outcome"],"name":[17],"type":["dbl"],"align":["right"]},{"label":["pval.outcome"],"name":[18],"type":["dbl"],"align":["right"]},{"label":["samplesize.outcome"],"name":[19],"type":["dbl"],"align":["right"]},{"label":["outcome"],"name":[20],"type":["chr"],"align":["left"]},{"label":["mr_keep.outcome"],"name":[21],"type":["lgl"],"align":["right"]},{"label":["pval_origin.outcome"],"name":[22],"type":["chr"],"align":["left"]},{"label":["chr.exposure"],"name":[23],"type":["dbl"],"align":["right"]},{"label":["pos.exposure"],"name":[24],"type":["dbl"],"align":["right"]},{"label":["se.exposure"],"name":[25],"type":["dbl"],"align":["right"]},{"label":["z.exposure"],"name":[26],"type":["dbl"],"align":["right"]},{"label":["pval.exposure"],"name":[27],"type":["dbl"],"align":["right"]},{"label":["samplesize.exposure"],"name":[28],"type":["dbl"],"align":["right"]},{"label":["exposure"],"name":[29],"type":["chr"],"align":["left"]},{"label":["mr_keep.exposure"],"name":[30],"type":["lgl"],"align":["right"]},{"label":["pval_origin.exposure"],"name":[31],"type":["chr"],"align":["left"]},{"label":["id.exposure"],"name":[32],"type":["chr"],"align":["left"]},{"label":["action"],"name":[33],"type":["dbl"],"align":["right"]},{"label":["mr_keep"],"name":[34],"type":["lgl"],"align":["right"]},{"label":["pt"],"name":[35],"type":["dbl"],"align":["right"]},{"label":["pleitropy_keep"],"name":[36],"type":["lgl"],"align":["right"]},{"label":["mrpresso_RSSobs"],"name":[37],"type":["dbl"],"align":["right"]},{"label":["mrpresso_pval"],"name":[38],"type":["dbl"],"align":["right"]},{"label":["mrpresso_keep"],"name":[39],"type":["lgl"],"align":["right"]}],"data":[{"1":"rs10908557","2":"G","3":"C","4":"G","5":"C","6":"-0.01191490","7":"-0.0141640","8":"0.303383","9":"0.3183","10":"FALSE","11":"TRUE","12":"FALSE","13":"P2LZ7B","14":"1","15":"153927052","16":"0.0097070","17":"-1.4591532","18":"0.144500","19":"1343083","20":"covidhgi2020C2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"1","24":"153927052","25":"0.001978896","26":"-6.021","27":"1.735e-09","28":"251151","29":"Barban2016afb","30":"TRUE","31":"reported","32":"6xTdTm","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"4.148048e-04","38":"0.3199","39":"TRUE"},{"1":"rs1160544","2":"C","3":"A","4":"C","5":"A","6":"0.01151460","7":"0.0156020","8":"0.605961","9":"0.6127","10":"FALSE","11":"FALSE","12":"FALSE","13":"P2LZ7B","14":"2","15":"100832218","16":"0.0091987","17":"1.6961092","18":"0.089860","19":"1348037","20":"covidhgi2020C2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"2","24":"100832218","25":"0.001979474","26":"5.817","27":"6.005e-09","28":"251151","29":"Barban2016afb","30":"TRUE","31":"reported","32":"6xTdTm","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"4.884000e-04","38":"0.1687","39":"TRUE"},{"1":"rs2347867","2":"A","3":"G","4":"A","5":"G","6":"0.01196593","7":"-0.0304000","8":"0.697619","9":"0.6472","10":"FALSE","11":"FALSE","12":"FALSE","13":"P2LZ7B","14":"6","15":"152229850","16":"0.0117260","17":"-2.5925294","18":"0.009525","19":"1253717","20":"covidhgi2020C2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"6","24":"152229850","25":"0.001978822","26":"6.047","27":"1.473e-09","28":"251151","29":"Barban2016afb","30":"TRUE","31":"reported","32":"6xTdTm","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"9.305355e-04","38":"0.0770","39":"TRUE"},{"1":"rs242997","2":"G","3":"A","4":"G","5":"A","6":"0.01162450","7":"0.0020618","8":"0.367216","9":"0.3648","10":"FALSE","11":"FALSE","12":"FALSE","13":"P2LZ7B","14":"22","15":"34503059","16":"0.0112130","17":"0.1838759","18":"0.854100","19":"1265956","20":"covidhgi2020C2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"22","24":"34503059","25":"0.001979315","26":"5.873","27":"4.279e-09","28":"251151","29":"Barban2016afb","30":"TRUE","31":"reported","32":"6xTdTm","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"3.253364e-05","38":"1.0000","39":"TRUE"},{"1":"rs2777888","2":"G","3":"A","4":"G","5":"A","6":"-0.01551740","7":"0.0256380","8":"0.484810","9":"0.4661","10":"FALSE","11":"FALSE","12":"FALSE","13":"P2LZ7B","14":"3","15":"49898000","16":"0.0104200","17":"2.4604607","18":"0.013870","19":"1277946","20":"covidhgi2020C2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"3","24":"49898000","25":"0.001973724","26":"-7.862","27":"3.790e-15","28":"251151","29":"Barban2016afb","30":"TRUE","31":"reported","32":"6xTdTm","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"7.760209e-04","38":"0.1351","39":"TRUE"},{"1":"rs293566","2":"C","3":"T","4":"C","5":"T","6":"-0.01095690","7":"0.0068122","8":"0.415577","9":"0.3948","10":"FALSE","11":"FALSE","12":"FALSE","13":"P2LZ7B","14":"20","15":"31097877","16":"0.0098062","17":"0.6946830","18":"0.487300","19":"1267531","20":"covidhgi2020C2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"20","24":"31097877","25":"0.001980280","26":"-5.533","27":"3.154e-08","28":"251151","29":"Barban2016afb","30":"TRUE","31":"reported","32":"6xTdTm","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"2.058872e-05","38":"1.0000","39":"TRUE"},{"1":"rs4730639","2":"A","3":"T","4":"A","5":"T","6":"-0.01286383","7":"0.0065283","8":"0.537400","9":"0.5188","10":"FALSE","11":"TRUE","12":"TRUE","13":"P2LZ7B","14":"7","15":"114343576","16":"0.0094614","17":"0.6899930","18":"0.490200","19":"1329526","20":"covidhgi2020C2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"7","24":"114343576","25":"0.001977530","26":"-6.505","27":"7.762e-11","28":"251151","29":"Barban2016afb","30":"TRUE","31":"reported","32":"6xTdTm","33":"2","34":"FALSE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"NA"},{"1":"rs6885307","2":"C","3":"A","4":"C","5":"A","6":"0.01255030","7":"0.0042308","8":"0.205840","9":"0.2114","10":"FALSE","11":"FALSE","12":"FALSE","13":"P2LZ7B","14":"5","15":"45094503","16":"0.0113410","17":"0.3730535","18":"0.709100","19":"1073512","20":"covidhgi2020C2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"5","24":"45094503","25":"0.001977982","26":"6.345","27":"2.229e-10","28":"251151","29":"Barban2016afb","30":"TRUE","31":"reported","32":"6xTdTm","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"7.315658e-05","38":"1.0000","39":"TRUE"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

SNPs that genome-wide significant in the outcome GWAS are likely pleitorpic and should be removed from analysis. Additionaly remove variants within the APOE locus by exclude variants 1MB either side of APOE e4 (rs429358 = 19:45411941, GRCh37.p13)
<br>


**Table 5:** SNPs that were genome-wide significant in the COVID: C2, EUR w/o UKBB GWAS
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["chr.outcome"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["pos.outcome"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["pval.exposure"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["pval.outcome"],"name":[5],"type":["dbl"],"align":["right"]}],"data":[],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>


## Instrument Strength
To ensure that the first assumption of MR is not violated (Non-zero effect assumption), the genetic variants selected should be robustly associated with the exposure. Weak instruments, where the variance in the exposure explained by the the instruments is a small portion of the total variance, may result in poor precission and accuracy of the causal effect estiamte. The strength of an instrument can be evaluated using the F statistic, if F is less than 10, this is an indication of weak instrument.


```
## Parsed with column specification:
## cols(
##   .default = col_double(),
##   exposure = col_character(),
##   outcome = col_character(),
##   method = col_character(),
##   outliers_removed = col_logical(),
##   logistic = col_logical(),
##   beta = col_logical()
## )
```

```
## See spec(...) for full column specifications.
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["outliers_removed"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["pve.exposure"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["F"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["Alpha"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["NCP"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["Power"],"name":[6],"type":["dbl"],"align":["right"]}],"data":[{"1":"FALSE","2":"0.001090706","3":"39.17462","4":"0.05","5":"0.7368684","6":"0.1377413"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

The I2_GX statistic can be used to quantify the strength of the NOME violation for MR-Egger regression and should be used to evalute potential bias in the MR-Egger causal estimate, with values less then 90% indicating that causal estimated should interpreted with caution due to regression diluation.

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["outliers_removed"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["Isq_gx"],"name":[2],"type":["dbl"],"align":["right"]}],"data":[{"1":"FALSE","2":"0"},{"1":"TRUE","2":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>


##  MR Results
To obtain an overall estimate of causal effect, the SNP-exposure and SNP-outcome coefficients were combined in 1) a fixed-effects meta-analysis using an inverse-variance weighted approach (IVW); 2) a Weighted Median approach; 3) Weighted Mode approach and 4) Egger Regression.


[**IVW**](https://doi.org/10.1002/gepi.21758) is equivalent to a weighted regression of the SNP-outcome coefficients on the SNP-exposure coefficients with the intercept constrained to zero. This method assumes that all variants are valid instrumental variables based on the Mendelian randomization assumptions. The causal estimate of the IVW analysis expresses the causal increase in the outcome (or log odds of the outcome for a binary outcome) per unit change in the exposure. [**Weighted median MR**](https://doi.org/10.1002/gepi.21965) allows for 50% of the instrumental variables to be invalid. [**MR-Egger regression**](https://doi.org/10.1093/ije/dyw220) allows all the instrumental variables to be subject to direct effects (i.e. horizontal pleiotropy), with the intercept representing bias in the causal estimate due to pleiotropy and the slope representing the causal estimate. [**Weighted Mode**](https://doi.org/10.1093/ije/dyx102) gives consistent estimates as the sample size increases if a plurality (or weighted plurality) of the genetic variants are valid instruments.
<br>



Table 6 presents the MR causal estimates of genetically predicted Age at first birth on COVID: C2, EUR w/o UKBB.
<br>

**Table 6** MR causaul estimates for Age at first birth on COVID: C2, EUR w/o UKBB
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["nsnp"],"name":[6],"type":["int"],"align":["right"]},{"label":["b"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"6xTdTm","2":"P2LZ7B","3":"covidhgi2020C2v5alleurLeaveUKBB","4":"Barban2016afb","5":"Inverse variance weighted (fixed effects)","6":"7","7":"-0.2599331","8":"0.3181354","9":"0.4138988"},{"1":"6xTdTm","2":"P2LZ7B","3":"covidhgi2020C2v5alleurLeaveUKBB","4":"Barban2016afb","5":"Weighted median","6":"7","7":"0.1631423","8":"0.5324219","9":"0.7592883"},{"1":"6xTdTm","2":"P2LZ7B","3":"covidhgi2020C2v5alleurLeaveUKBB","4":"Barban2016afb","5":"Weighted mode","6":"7","7":"0.5662086","8":"1.0411028","9":"0.6061440"},{"1":"6xTdTm","2":"P2LZ7B","3":"covidhgi2020C2v5alleurLeaveUKBB","4":"Barban2016afb","5":"MR Egger","6":"7","7":"-6.2973456","8":"4.5215673","9":"0.2224578"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Figure 1 illustrates the SNP-specific associations with Age at first birth versus the association in COVID: C2, EUR w/o UKBB and the corresponding MR estimates.
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovideurwoukbb/Barban2016afb/covidhgi2020C2v5alleurLeaveUKBB/Barban2016afb_5e-8_covidhgi2020C2v5alleurLeaveUKBB_MR_Analaysis_files/figure-html/scatter_plot-1.png" alt="Fig. 1: Scatterplot of SNP effects for the association of the Exposure on the Outcome"  />
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
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["Q"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["Q_df"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["Q_pval"],"name":[8],"type":["dbl"],"align":["right"]}],"data":[{"1":"6xTdTm","2":"P2LZ7B","3":"covidhgi2020C2v5alleurLeaveUKBB","4":"Barban2016afb","5":"MR Egger","6":"13.05347","7":"5","8":"0.02288285"},{"1":"6xTdTm","2":"P2LZ7B","3":"covidhgi2020C2v5alleurLeaveUKBB","4":"Barban2016afb","5":"Inverse variance weighted","6":"17.76898","7":"6","8":"0.00683622"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Figure 2 shows a funnel plot displaying the MR estimates of individual genetic variants against their precession. Aysmmetry in the funnel plot may arrise due to some genetic variants having unusally strong effects on the outcome, which is indicative of directional pleiotropy.
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovideurwoukbb/Barban2016afb/covidhgi2020C2v5alleurLeaveUKBB/Barban2016afb_5e-8_covidhgi2020C2v5alleurLeaveUKBB_MR_Analaysis_files/figure-html/funnel_plot-1.png" alt="Fig. 2: Funnel plot of the MR causal estimates against their precession"  />
<p class="caption">Fig. 2: Funnel plot of the MR causal estimates against their precession</p>
</div>
<br>

Figure 3 shows a [Radial Plots](https://github.com/WSpiller/RadialMR) can be used to visualize influential data points with large contributions to Cochran's Q Statistic that may bias causal effect estimates.




```
## [1] "No significant Outliers"
```

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovideurwoukbb/Barban2016afb/covidhgi2020C2v5alleurLeaveUKBB/Barban2016afb_5e-8_covidhgi2020C2v5alleurLeaveUKBB_MR_Analaysis_files/figure-html/Radial_Plot-1.png" alt="Fig. 4: Radial Plot showing influential data points using Radial IVW"  />
<p class="caption">Fig. 4: Radial Plot showing influential data points using Radial IVW</p>
</div>
<br>

The intercept of the MR-Egger Regression model captures the average pleitropic affect across all genetic variants (Table 8).
<br>

**Table 8:** MR Egger test for directional pleitropy
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["egger_intercept"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[7],"type":["dbl"],"align":["right"]}],"data":[{"1":"6xTdTm","2":"P2LZ7B","3":"covidhgi2020C2v5alleurLeaveUKBB","4":"Barban2016afb","5":"0.07489775","6":"0.05572912","7":"0.2367201"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Pleiotropy was also assesed using Mendelian Randomization Pleiotropy RESidual Sum and Outlier [(MR-PRESSO)](https://doi.org/10.1038/s41588-018-0099-7), that allows for the evlation of evaluation of horizontal pleiotropy in a standared MR model (Table 9). MR-PRESSO performs a global test for detection of horizontal pleiotropy and correction of pleiotropy via outlier removal (Table 10).
<br>

**Table 9:** MR-PRESSO Global Test for pleitropy
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["pt"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["outliers_removed"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["n_outliers"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["RSSobs"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"6xTdTm","2":"P2LZ7B","3":"covidhgi2020C2v5alleurLeaveUKBB","4":"Barban2016afb","5":"5e-08","6":"FALSE","7":"0","8":"25.13065","9":"0.0055"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>


**Table 10:** MR Estimates after MR-PRESSO outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["nsnp"],"name":[6],"type":["int"],"align":["right"]},{"label":["b"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"6xTdTm","2":"P2LZ7B","3":"covidhgi2020C2v5alleurLeaveUKBB","4":"Barban2016afb","5":"Inverse variance weighted (fixed effects)","6":"7","7":"-0.2599331","8":"0.3181354","9":"0.4138988"},{"1":"6xTdTm","2":"P2LZ7B","3":"covidhgi2020C2v5alleurLeaveUKBB","4":"Barban2016afb","5":"Weighted median","6":"7","7":"0.1631423","8":"0.5172627","9":"0.7524614"},{"1":"6xTdTm","2":"P2LZ7B","3":"covidhgi2020C2v5alleurLeaveUKBB","4":"Barban2016afb","5":"Weighted mode","6":"7","7":"0.5662086","8":"1.0199282","9":"0.5988658"},{"1":"6xTdTm","2":"P2LZ7B","3":"covidhgi2020C2v5alleurLeaveUKBB","4":"Barban2016afb","5":"MR Egger","6":"7","7":"-6.2973456","8":"4.5215673","9":"0.2224578"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovideurwoukbb/Barban2016afb/covidhgi2020C2v5alleurLeaveUKBB/Barban2016afb_5e-8_covidhgi2020C2v5alleurLeaveUKBB_MR_Analaysis_files/figure-html/scatter_plot_outlier-1.png" alt="Fig. 5: Scatterplot of SNP effects for the association of the Exposure on the Outcome after outlier removal"  />
<p class="caption">Fig. 5: Scatterplot of SNP effects for the association of the Exposure on the Outcome after outlier removal</p>
</div>
<br>

**Table 11:** Heterogenity Tests after outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["Q"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["Q_df"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["Q_pval"],"name":[8],"type":["dbl"],"align":["right"]}],"data":[{"1":"6xTdTm","2":"P2LZ7B","3":"covidhgi2020C2v5alleurLeaveUKBB","4":"Barban2016afb","5":"MR Egger","6":"13.05347","7":"5","8":"0.02288285"},{"1":"6xTdTm","2":"P2LZ7B","3":"covidhgi2020C2v5alleurLeaveUKBB","4":"Barban2016afb","5":"Inverse variance weighted","6":"17.76898","7":"6","8":"0.00683622"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

**Table 12:** MR Egger test for directional pleitropy after outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["egger_intercept"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[7],"type":["dbl"],"align":["right"]}],"data":[{"1":"6xTdTm","2":"P2LZ7B","3":"covidhgi2020C2v5alleurLeaveUKBB","4":"Barban2016afb","5":"0.07489775","6":"0.05572912","7":"0.2367201"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>