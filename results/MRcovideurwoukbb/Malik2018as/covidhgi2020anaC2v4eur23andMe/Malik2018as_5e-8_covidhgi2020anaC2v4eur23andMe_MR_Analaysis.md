---
title: "Mendelian Randomization Analysis"
author: "Dr. Shea Andrews"
date: "2020-12-18"
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

### Exposure: Stroke
`#r exposure.blurb`
<br>

**Table 1:** Independent SNPs associated with Stroke
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["CHROM"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["REF"],"name":[4],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[5],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[12],"type":["chr"],"align":["left"]}],"data":[{"1":"rs11587860","2":"1","3":"156156951","4":"G","5":"C","6":"0.3545","7":"-0.0689","8":"0.0098","9":"-7.030612","10":"2.542e-12","11":"446696","12":"Stroke"},{"1":"rs2634074","2":"4","3":"111677041","4":"T","5":"A","6":"0.7885","7":"-0.0840","8":"0.0112","9":"-7.500000","10":"6.558e-14","11":"446696","12":"Stroke"},{"1":"rs11242678","2":"6","3":"1337180","4":"C","5":"T","6":"0.2551","7":"0.0643","8":"0.0105","9":"6.123810","10":"8.708e-10","11":"446696","12":"Stroke"},{"1":"rs2107595","2":"7","3":"19049388","4":"G","5":"A","6":"0.1671","7":"0.0803","8":"0.0121","9":"6.636364","10":"3.586e-11","11":"446696","12":"Stroke"},{"1":"rs1537375","2":"9","3":"22116071","4":"T","5":"C","6":"0.5021","7":"0.0519","8":"0.0091","9":"5.703300","10":"1.241e-08","11":"446696","12":"Stroke"},{"1":"rs475937","2":"11","3":"102687700","4":"A","5":"C","6":"0.8682","7":"-0.0757","8":"0.0137","9":"-5.525550","10":"2.916e-08","11":"446696","12":"Stroke"},{"1":"rs10774624","2":"12","3":"111833788","4":"G","5":"A","6":"0.5285","7":"-0.0654","8":"0.0094","9":"-6.957447","10":"4.042e-12","11":"446696","12":"Stroke"},{"1":"rs4942561","2":"13","3":"47209347","4":"G","5":"T","6":"0.7581","7":"0.0640","8":"0.0107","9":"5.981308","10":"2.048e-09","11":"446696","12":"Stroke"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

### Outcome: COVID: C2
`#r outcome.blurb`
<br>

**Table 2:** SNPs associated with Stroke avaliable in COVID: C2
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["CHROM"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["REF"],"name":[4],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[5],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[12],"type":["chr"],"align":["left"]}],"data":[{"1":"rs11587860","2":"1","3":"156156951","4":"G","5":"C","6":"0.3627","7":"-0.0227350","8":"0.011520","9":"-1.9735243","10":"0.048440","11":"1378020","12":"covid_vs._population__eur"},{"1":"rs2634074","2":"4","3":"111677041","4":"T","5":"A","6":"0.7849","7":"0.0032849","8":"0.018625","9":"0.1763705","10":"0.860000","11":"1288654","12":"covid_vs._population__eur"},{"1":"rs11242678","2":"6","3":"1337180","4":"C","5":"T","6":"0.2671","7":"0.0295010","8":"0.012288","9":"2.4007975","10":"0.016360","11":"1393031","12":"covid_vs._population__eur"},{"1":"rs2107595","2":"7","3":"19049388","4":"G","5":"A","6":"0.1733","7":"0.0091964","8":"0.014895","9":"0.6174152","10":"0.537000","11":"1374519","12":"covid_vs._population__eur"},{"1":"rs1537375","2":"9","3":"22116071","4":"T","5":"C","6":"0.4784","7":"-0.0130880","8":"0.012857","9":"-1.0179669","10":"0.308700","11":"1393695","12":"covid_vs._population__eur"},{"1":"rs475937","2":"11","3":"102687700","4":"A","5":"C","6":"0.8469","7":"0.0028782","8":"0.022555","9":"0.1276081","10":"0.898500","11":"1288954","12":"covid_vs._population__eur"},{"1":"rs10774624","2":"12","3":"111833788","4":"G","5":"A","6":"0.5368","7":"0.0329440","8":"0.011888","9":"2.7711978","10":"0.005583","11":"1099365","12":"covid_vs._population__eur"},{"1":"rs4942561","2":"13","3":"47209347","4":"G","5":"T","6":"0.7492","7":"-0.0033162","8":"0.016989","9":"-0.1951969","10":"0.845200","11":"1298710","12":"covid_vs._population__eur"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
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

**Table 4:** Harmonized Stroke and COVID: C2 datasets
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["effect_allele.exposure"],"name":[2],"type":["chr"],"align":["left"]},{"label":["other_allele.exposure"],"name":[3],"type":["chr"],"align":["left"]},{"label":["effect_allele.outcome"],"name":[4],"type":["chr"],"align":["left"]},{"label":["other_allele.outcome"],"name":[5],"type":["chr"],"align":["left"]},{"label":["beta.exposure"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["beta.outcome"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["eaf.exposure"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["eaf.outcome"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["remove"],"name":[10],"type":["lgl"],"align":["right"]},{"label":["palindromic"],"name":[11],"type":["lgl"],"align":["right"]},{"label":["ambiguous"],"name":[12],"type":["lgl"],"align":["right"]},{"label":["id.outcome"],"name":[13],"type":["chr"],"align":["left"]},{"label":["chr.outcome"],"name":[14],"type":["dbl"],"align":["right"]},{"label":["pos.outcome"],"name":[15],"type":["dbl"],"align":["right"]},{"label":["se.outcome"],"name":[16],"type":["dbl"],"align":["right"]},{"label":["z.outcome"],"name":[17],"type":["dbl"],"align":["right"]},{"label":["pval.outcome"],"name":[18],"type":["dbl"],"align":["right"]},{"label":["samplesize.outcome"],"name":[19],"type":["dbl"],"align":["right"]},{"label":["outcome"],"name":[20],"type":["chr"],"align":["left"]},{"label":["mr_keep.outcome"],"name":[21],"type":["lgl"],"align":["right"]},{"label":["pval_origin.outcome"],"name":[22],"type":["chr"],"align":["left"]},{"label":["chr.exposure"],"name":[23],"type":["dbl"],"align":["right"]},{"label":["pos.exposure"],"name":[24],"type":["dbl"],"align":["right"]},{"label":["se.exposure"],"name":[25],"type":["dbl"],"align":["right"]},{"label":["z.exposure"],"name":[26],"type":["dbl"],"align":["right"]},{"label":["pval.exposure"],"name":[27],"type":["dbl"],"align":["right"]},{"label":["samplesize.exposure"],"name":[28],"type":["dbl"],"align":["right"]},{"label":["exposure"],"name":[29],"type":["chr"],"align":["left"]},{"label":["mr_keep.exposure"],"name":[30],"type":["lgl"],"align":["right"]},{"label":["pval_origin.exposure"],"name":[31],"type":["chr"],"align":["left"]},{"label":["id.exposure"],"name":[32],"type":["chr"],"align":["left"]},{"label":["action"],"name":[33],"type":["dbl"],"align":["right"]},{"label":["mr_keep"],"name":[34],"type":["lgl"],"align":["right"]},{"label":["pt"],"name":[35],"type":["dbl"],"align":["right"]},{"label":["pleitropy_keep"],"name":[36],"type":["lgl"],"align":["right"]},{"label":["mrpresso_RSSobs"],"name":[37],"type":["dbl"],"align":["right"]},{"label":["mrpresso_pval"],"name":[38],"type":["dbl"],"align":["right"]},{"label":["mrpresso_keep"],"name":[39],"type":["lgl"],"align":["right"]}],"data":[{"1":"rs10774624","2":"A","3":"G","4":"A","5":"G","6":"-0.0654","7":"0.0329440","8":"0.5285","9":"0.5368","10":"FALSE","11":"FALSE","12":"FALSE","13":"HKSnmH","14":"12","15":"111833788","16":"0.011888","17":"2.7711978","18":"0.005583","19":"1099365","20":"covidhgi2020anaC2v4eur23andMe","21":"TRUE","22":"reported","23":"12","24":"111833788","25":"0.0094","26":"-6.957447","27":"4.042e-12","28":"446696","29":"Malik2018as","30":"TRUE","31":"reported","32":"1bdW7W","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"1.773243e-03","38":"0.0144","39":"FALSE"},{"1":"rs11242678","2":"T","3":"C","4":"T","5":"C","6":"0.0643","7":"0.0295010","8":"0.2551","9":"0.2671","10":"FALSE","11":"FALSE","12":"FALSE","13":"HKSnmH","14":"6","15":"1337180","16":"0.012288","17":"2.4007975","18":"0.016360","19":"1393031","20":"covidhgi2020anaC2v4eur23andMe","21":"TRUE","22":"reported","23":"6","24":"1337180","25":"0.0105","26":"6.123810","27":"8.708e-10","28":"446696","29":"Malik2018as","30":"TRUE","31":"reported","32":"1bdW7W","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"1.025897e-03","38":"0.1064","39":"TRUE"},{"1":"rs11587860","2":"C","3":"G","4":"C","5":"G","6":"-0.0689","7":"-0.0227350","8":"0.3545","9":"0.3627","10":"FALSE","11":"TRUE","12":"FALSE","13":"HKSnmH","14":"1","15":"156156951","16":"0.011520","17":"-1.9735243","18":"0.048440","19":"1378020","20":"covidhgi2020anaC2v4eur23andMe","21":"TRUE","22":"reported","23":"1","24":"156156951","25":"0.0098","26":"-7.030612","27":"2.542e-12","28":"446696","29":"Malik2018as","30":"TRUE","31":"reported","32":"1bdW7W","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"6.373460e-04","38":"0.3288","39":"TRUE"},{"1":"rs1537375","2":"C","3":"T","4":"C","5":"T","6":"0.0519","7":"-0.0130880","8":"0.5021","9":"0.4784","10":"FALSE","11":"FALSE","12":"FALSE","13":"HKSnmH","14":"9","15":"22116071","16":"0.012857","17":"-1.0179669","18":"0.308700","19":"1393695","20":"covidhgi2020anaC2v4eur23andMe","21":"TRUE","22":"reported","23":"9","24":"22116071","25":"0.0091","26":"5.703300","27":"1.241e-08","28":"446696","29":"Malik2018as","30":"TRUE","31":"reported","32":"1bdW7W","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"2.664543e-04","38":"1.0000","39":"TRUE"},{"1":"rs2107595","2":"A","3":"G","4":"A","5":"G","6":"0.0803","7":"0.0091964","8":"0.1671","9":"0.1733","10":"FALSE","11":"FALSE","12":"FALSE","13":"HKSnmH","14":"7","15":"19049388","16":"0.014895","17":"0.6174152","18":"0.537000","19":"1374519","20":"covidhgi2020anaC2v4eur23andMe","21":"TRUE","22":"reported","23":"7","24":"19049388","25":"0.0121","26":"6.636364","27":"3.586e-11","28":"446696","29":"Malik2018as","30":"TRUE","31":"reported","32":"1bdW7W","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"5.806638e-05","38":"1.0000","39":"TRUE"},{"1":"rs2634074","2":"A","3":"T","4":"A","5":"T","6":"-0.0840","7":"0.0032849","8":"0.7885","9":"0.7849","10":"FALSE","11":"TRUE","12":"FALSE","13":"HKSnmH","14":"4","15":"111677041","16":"0.018625","17":"0.1763705","18":"0.860000","19":"1288654","20":"covidhgi2020anaC2v4eur23andMe","21":"TRUE","22":"reported","23":"4","24":"111677041","25":"0.0112","26":"-7.500000","27":"6.558e-14","28":"446696","29":"Malik2018as","30":"TRUE","31":"reported","32":"1bdW7W","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"4.837919e-05","38":"1.0000","39":"TRUE"},{"1":"rs475937","2":"C","3":"A","4":"C","5":"A","6":"-0.0757","7":"0.0028782","8":"0.8682","9":"0.8469","10":"FALSE","11":"FALSE","12":"FALSE","13":"HKSnmH","14":"11","15":"102687700","16":"0.022555","17":"0.1276081","18":"0.898500","19":"1288954","20":"covidhgi2020anaC2v4eur23andMe","21":"TRUE","22":"reported","23":"11","24":"102687700","25":"0.0137","26":"-5.525550","27":"2.916e-08","28":"446696","29":"Malik2018as","30":"TRUE","31":"reported","32":"1bdW7W","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"3.425188e-05","38":"1.0000","39":"TRUE"},{"1":"rs4942561","2":"T","3":"G","4":"T","5":"G","6":"0.0640","7":"-0.0033162","8":"0.7581","9":"0.7492","10":"FALSE","11":"FALSE","12":"FALSE","13":"HKSnmH","14":"13","15":"47209347","16":"0.016989","17":"-0.1951969","18":"0.845200","19":"1298710","20":"covidhgi2020anaC2v4eur23andMe","21":"TRUE","22":"reported","23":"13","24":"47209347","25":"0.0107","26":"5.981308","27":"2.048e-09","28":"446696","29":"Malik2018as","30":"TRUE","31":"reported","32":"1bdW7W","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"3.587225e-05","38":"1.0000","39":"TRUE"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
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
{"columns":[{"label":["outliers_removed"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["pve.exposure"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["F"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["Alpha"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["NCP"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["Power"],"name":[6],"type":["dbl"],"align":["right"]}],"data":[{"1":"FALSE","2":"0.0007495837","3":"41.88506","4":"0.05","5":"0.4916519","6":"0.1079478"},{"1":"TRUE","2":"0.0006404168","3":"40.89283","4":"0.05","5":"10.1893671","6":"0.8910470"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

The I2_GX statistic can be used to quantify the strength of the NOME violation for MR-Egger regression and should be used to evalute potential bias in the MR-Egger causal estimate, with values less then 90% indicating that causal estimated should interpreted with caution due to regression diluation.

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["outliers_removed"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["Isq_gx"],"name":[2],"type":["dbl"],"align":["right"]}],"data":[{"1":"FALSE","2":"0.4117468"},{"1":"TRUE","2":"0.4089344"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>


##  MR Results
To obtain an overall estimate of causal effect, the SNP-exposure and SNP-outcome coefficients were combined in 1) a fixed-effects meta-analysis using an inverse-variance weighted approach (IVW); 2) a Weighted Median approach; 3) Weighted Mode approach and 4) Egger Regression.


[**IVW**](https://doi.org/10.1002/gepi.21758) is equivalent to a weighted regression of the SNP-outcome coefficients on the SNP-exposure coefficients with the intercept constrained to zero. This method assumes that all variants are valid instrumental variables based on the Mendelian randomization assumptions. The causal estimate of the IVW analysis expresses the causal increase in the outcome (or log odds of the outcome for a binary outcome) per unit change in the exposure. [**Weighted median MR**](https://doi.org/10.1002/gepi.21965) allows for 50% of the instrumental variables to be invalid. [**MR-Egger regression**](https://doi.org/10.1093/ije/dyw220) allows all the instrumental variables to be subject to direct effects (i.e. horizontal pleiotropy), with the intercept representing bias in the causal estimate due to pleiotropy and the slope representing the causal estimate. [**Weighted Mode**](https://doi.org/10.1093/ije/dyx102) gives consistent estimates as the sample size increases if a plurality (or weighted plurality) of the genetic variants are valid instruments.
<br>



Table 6 presents the MR causal estimates of genetically predicted Stroke on COVID: C2.
<br>

**Table 6** MR causaul estimates for Stroke on COVID: C2
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["nsnp"],"name":[6],"type":["int"],"align":["right"]},{"label":["b"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"1bdW7W","2":"HKSnmH","3":"covidhgi2020anaC2v4eur23andMe","4":"Malik2018as","5":"Inverse variance weighted (fixed effects)","6":"8","7":"0.034572470","8":"0.07360651","9":"0.6385743"},{"1":"1bdW7W","2":"HKSnmH","3":"covidhgi2020anaC2v4eur23andMe","4":"Malik2018as","5":"Weighted median","6":"8","7":"-0.002663733","8":"0.11258811","9":"0.9811245"},{"1":"1bdW7W","2":"HKSnmH","3":"covidhgi2020anaC2v4eur23andMe","4":"Malik2018as","5":"Weighted mode","6":"8","7":"0.036108162","8":"0.19140118","9":"0.8557186"},{"1":"1bdW7W","2":"HKSnmH","3":"covidhgi2020anaC2v4eur23andMe","4":"Malik2018as","5":"MR Egger","6":"8","7":"0.525979168","8":"0.95124551","9":"0.6002853"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Figure 1 illustrates the SNP-specific associations with Stroke versus the association in COVID: C2 and the corresponding MR estimates.
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovideurwoukbb/Malik2018as/covidhgi2020anaC2v4eur23andMe/Malik2018as_5e-8_covidhgi2020anaC2v4eur23andMe_MR_Analaysis_files/figure-html/scatter_plot-1.png" alt="Fig. 1: Scatterplot of SNP effects for the association of the Exposure on the Outcome"  />
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
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["Q"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["Q_df"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["Q_pval"],"name":[8],"type":["dbl"],"align":["right"]}],"data":[{"1":"1bdW7W","2":"HKSnmH","3":"covidhgi2020anaC2v4eur23andMe","4":"Malik2018as","5":"MR Egger","6":"17.81384","7":"6","8":"0.006714658"},{"1":"1bdW7W","2":"HKSnmH","3":"covidhgi2020anaC2v4eur23andMe","4":"Malik2018as","5":"Inverse variance weighted","6":"18.62050","7":"7","8":"0.009463051"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Figure 2 shows a funnel plot displaying the MR estimates of individual genetic variants against their precession. Aysmmetry in the funnel plot may arrise due to some genetic variants having unusally strong effects on the outcome, which is indicative of directional pleiotropy.
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovideurwoukbb/Malik2018as/covidhgi2020anaC2v4eur23andMe/Malik2018as_5e-8_covidhgi2020anaC2v4eur23andMe_MR_Analaysis_files/figure-html/funnel_plot-1.png" alt="Fig. 2: Funnel plot of the MR causal estimates against their precession"  />
<p class="caption">Fig. 2: Funnel plot of the MR causal estimates against their precession</p>
</div>
<br>

Figure 3 shows a [Radial Plots](https://github.com/WSpiller/RadialMR) can be used to visualize influential data points with large contributions to Cochran's Q Statistic that may bias causal effect estimates.



<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovideurwoukbb/Malik2018as/covidhgi2020anaC2v4eur23andMe/Malik2018as_5e-8_covidhgi2020anaC2v4eur23andMe_MR_Analaysis_files/figure-html/Radial_Plot-1.png" alt="Fig. 4: Radial Plot showing influential data points using Radial IVW"  />
<p class="caption">Fig. 4: Radial Plot showing influential data points using Radial IVW</p>
</div>
<br>

The intercept of the MR-Egger Regression model captures the average pleitropic affect across all genetic variants (Table 8).
<br>

**Table 8:** MR Egger test for directional pleitropy
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["egger_intercept"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[7],"type":["dbl"],"align":["right"]}],"data":[{"1":"1bdW7W","2":"HKSnmH","3":"covidhgi2020anaC2v4eur23andMe","4":"Malik2018as","5":"-0.03363774","6":"0.06453325","7":"0.6208663"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Pleiotropy was also assesed using Mendelian Randomization Pleiotropy RESidual Sum and Outlier [(MR-PRESSO)](https://doi.org/10.1038/s41588-018-0099-7), that allows for the evlation of evaluation of horizontal pleiotropy in a standared MR model (Table 9). MR-PRESSO performs a global test for detection of horizontal pleiotropy and correction of pleiotropy via outlier removal (Table 10).
<br>

**Table 9:** MR-PRESSO Global Test for pleitropy
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["pt"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["outliers_removed"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["n_outliers"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["RSSobs"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"1bdW7W","2":"HKSnmH","3":"covidhgi2020anaC2v4eur23andMe","4":"Malik2018as","5":"5e-08","6":"FALSE","7":"1","8":"26.34882","9":"0.0058"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>


**Table 10:** MR Estimates after MR-PRESSO outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["nsnp"],"name":[6],"type":["int"],"align":["right"]},{"label":["b"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"1bdW7W","2":"HKSnmH","3":"covidhgi2020anaC2v4eur23andMe","4":"Malik2018as","5":"Inverse variance weighted (fixed effects)","6":"7","7":"0.14015126","8":"0.08050185","9":"0.08168892"},{"1":"1bdW7W","2":"HKSnmH","3":"covidhgi2020anaC2v4eur23andMe","4":"Malik2018as","5":"Weighted median","6":"7","7":"0.09677181","8":"0.11643134","9":"0.40588940"},{"1":"1bdW7W","2":"HKSnmH","3":"covidhgi2020anaC2v4eur23andMe","4":"Malik2018as","5":"Weighted mode","6":"7","7":"0.01449265","8":"0.16797690","9":"0.93405287"},{"1":"1bdW7W","2":"HKSnmH","3":"covidhgi2020anaC2v4eur23andMe","4":"Malik2018as","5":"MR Egger","6":"7","7":"0.36257317","8":"0.69993023","9":"0.62654632"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovideurwoukbb/Malik2018as/covidhgi2020anaC2v4eur23andMe/Malik2018as_5e-8_covidhgi2020anaC2v4eur23andMe_MR_Analaysis_files/figure-html/scatter_plot_outlier-1.png" alt="Fig. 5: Scatterplot of SNP effects for the association of the Exposure on the Outcome after outlier removal"  />
<p class="caption">Fig. 5: Scatterplot of SNP effects for the association of the Exposure on the Outcome after outlier removal</p>
</div>
<br>

**Table 11:** Heterogenity Tests after outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["Q"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["Q_df"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["Q_pval"],"name":[8],"type":["dbl"],"align":["right"]}],"data":[{"1":"1bdW7W","2":"HKSnmH","3":"covidhgi2020anaC2v4eur23andMe","4":"Malik2018as","5":"MR Egger","6":"7.966248","7":"5","8":"0.1581056"},{"1":"1bdW7W","2":"HKSnmH","3":"covidhgi2020anaC2v4eur23andMe","4":"Malik2018as","5":"Inverse variance weighted","6":"8.130602","7":"6","8":"0.2286904"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

**Table 12:** MR Egger test for directional pleitropy after outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["egger_intercept"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[7],"type":["dbl"],"align":["right"]}],"data":[{"1":"1bdW7W","2":"HKSnmH","3":"covidhgi2020anaC2v4eur23andMe","4":"Malik2018as","5":"-0.01536585","6":"0.04784189","7":"0.7610652"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>