---
title: "Mendelian Randomization Analysis"
author: "Dr. Shea Andrews"
date: "2020-10-07"
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

### Exposure: AAOS
`#r exposure.blurb`
<br>

**Table 1:** Independent SNPs associated with AAOS
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["CHROM"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["REF"],"name":[4],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[5],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[12],"type":["chr"],"align":["left"]}],"data":[{"1":"rs6431219","2":"2","3":"127862133","4":"C","5":"T","6":"0.4163","7":"0.0774","8":"0.0124","9":"6.241935","10":"3.897e-10","11":"40255","12":"AAOS"},{"1":"rs7930318","2":"11","3":"60033371","4":"C","5":"T","6":"0.5996","7":"0.0750","8":"0.0125","9":"6.000000","10":"2.245e-09","11":"40255","12":"AAOS"},{"1":"rs567075","2":"11","3":"85830157","4":"T","5":"C","6":"0.6903","7":"0.0900","8":"0.0132","9":"6.818180","10":"9.084e-12","11":"40255","12":"AAOS"},{"1":"rs62117204","2":"19","3":"45242967","4":"C","5":"T","6":"0.0601","7":"-0.1867","8":"0.0278","9":"-6.715827","10":"1.864e-11","11":"40255","12":"AAOS"},{"1":"rs76205446","2":"19","3":"45355267","4":"T","5":"A","6":"0.0143","7":"0.7096","8":"0.1234","9":"5.750405","10":"9.010e-09","11":"40255","12":"AAOS"},{"1":"rs2075650","2":"19","3":"45395619","4":"A","5":"G","6":"0.2197","7":"0.5502","8":"0.0223","9":"24.672600","10":"5.980e-134","11":"40255","12":"AAOS"},{"1":"rs141441332","2":"19","3":"45438575","4":"C","5":"A","6":"0.0110","7":"0.5383","8":"0.0632","9":"8.517405","10":"1.713e-17","11":"40255","12":"AAOS"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

### Outcome: very severe respiratory confirmed covid vs. population
`#r outcome.blurb`
<br>

**Table 2:** SNPs associated with AAOS avaliable in very severe respiratory confirmed covid vs. population
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["CHROM"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["REF"],"name":[4],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[5],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[12],"type":["chr"],"align":["left"]}],"data":[{"1":"rs6431219","2":"2","3":"127862133","4":"C","5":"T","6":"0.329700","7":"-0.0361990","8":"0.032202","9":"-1.12412273","10":"0.2610","11":"287332","12":"very_severe_respiratory_confirmed_covid_vs._population"},{"1":"rs7930318","2":"11","3":"60033371","4":"C","5":"T","6":"0.682800","7":"-0.0617670","8":"0.048916","9":"-1.26271568","10":"0.2067","11":"277276","12":"very_severe_respiratory_confirmed_covid_vs._population"},{"1":"rs567075","2":"11","3":"85830157","4":"T","5":"C","6":"0.652700","7":"0.0264690","8":"0.035004","9":"0.75617072","10":"0.4495","11":"287332","12":"very_severe_respiratory_confirmed_covid_vs._population"},{"1":"rs62117204","2":"19","3":"45242967","4":"C","5":"T","6":"0.073910","7":"0.0470950","8":"0.066409","9":"0.70916593","10":"0.4782","11":"287332","12":"very_severe_respiratory_confirmed_covid_vs._population"},{"1":"rs76205446","2":"19","3":"45355267","4":"T","5":"A","6":"0.010850","7":"-0.0626160","8":"0.239510","9":"-0.26143376","10":"0.7938","11":"248961","12":"very_severe_respiratory_confirmed_covid_vs._population"},{"1":"rs2075650","2":"19","3":"45395619","4":"A","5":"G","6":"0.165200","7":"0.0029626","8":"0.048090","9":"0.06160532","10":"0.9509","11":"287332","12":"very_severe_respiratory_confirmed_covid_vs._population"},{"1":"rs141441332","2":"19","3":"45438575","4":"C","5":"A","6":"0.004908","7":"-0.1713400","8":"0.293840","9":"-0.58310645","10":"0.5598","11":"249496","12":"very_severe_respiratory_confirmed_covid_vs._population"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

**Table 3:** Proxy SNPs for very severe respiratory confirmed covid vs. population
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["proxy.outcome"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["target_snp"],"name":[2],"type":["lgl"],"align":["right"]},{"label":["proxy_snp"],"name":[3],"type":["lgl"],"align":["right"]},{"label":["ld.r2"],"name":[4],"type":["lgl"],"align":["right"]},{"label":["Dprime"],"name":[5],"type":["lgl"],"align":["right"]},{"label":["ref.proxy"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["alt.proxy"],"name":[7],"type":["lgl"],"align":["right"]},{"label":["CHROM"],"name":[8],"type":["lgl"],"align":["right"]},{"label":["POS"],"name":[9],"type":["lgl"],"align":["right"]},{"label":["ALT.proxy"],"name":[10],"type":["lgl"],"align":["right"]},{"label":["REF.proxy"],"name":[11],"type":["lgl"],"align":["right"]},{"label":["AF"],"name":[12],"type":["lgl"],"align":["right"]},{"label":["BETA"],"name":[13],"type":["lgl"],"align":["right"]},{"label":["SE"],"name":[14],"type":["lgl"],"align":["right"]},{"label":["P"],"name":[15],"type":["lgl"],"align":["right"]},{"label":["N"],"name":[16],"type":["lgl"],"align":["right"]},{"label":["ref"],"name":[17],"type":["lgl"],"align":["right"]},{"label":["alt"],"name":[18],"type":["lgl"],"align":["right"]},{"label":["ALT"],"name":[19],"type":["lgl"],"align":["right"]},{"label":["REF"],"name":[20],"type":["lgl"],"align":["right"]},{"label":["PHASE"],"name":[21],"type":["lgl"],"align":["right"]}],"data":[{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA","13":"NA","14":"NA","15":"NA","16":"NA","17":"NA","18":"NA","19":"NA","20":"NA","21":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

## Data harmonization
Harmonize the exposure and outcome datasets so that the effect of a SNP on the exposure and the effect of that SNP on the outcome correspond to the same allele. The harmonise_data function from the TwoSampleMR package can be used to perform the harmonization step, by default it try's to infer the forward strand alleles using allele frequency information.
<br>

**Table 4:** Harmonized AAOS and very severe respiratory confirmed covid vs. population datasets
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["effect_allele.exposure"],"name":[2],"type":["chr"],"align":["left"]},{"label":["other_allele.exposure"],"name":[3],"type":["chr"],"align":["left"]},{"label":["effect_allele.outcome"],"name":[4],"type":["chr"],"align":["left"]},{"label":["other_allele.outcome"],"name":[5],"type":["chr"],"align":["left"]},{"label":["beta.exposure"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["beta.outcome"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["eaf.exposure"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["eaf.outcome"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["remove"],"name":[10],"type":["lgl"],"align":["right"]},{"label":["palindromic"],"name":[11],"type":["lgl"],"align":["right"]},{"label":["ambiguous"],"name":[12],"type":["lgl"],"align":["right"]},{"label":["id.outcome"],"name":[13],"type":["chr"],"align":["left"]},{"label":["chr.outcome"],"name":[14],"type":["dbl"],"align":["right"]},{"label":["pos.outcome"],"name":[15],"type":["dbl"],"align":["right"]},{"label":["se.outcome"],"name":[16],"type":["dbl"],"align":["right"]},{"label":["z.outcome"],"name":[17],"type":["dbl"],"align":["right"]},{"label":["pval.outcome"],"name":[18],"type":["dbl"],"align":["right"]},{"label":["samplesize.outcome"],"name":[19],"type":["dbl"],"align":["right"]},{"label":["outcome"],"name":[20],"type":["chr"],"align":["left"]},{"label":["mr_keep.outcome"],"name":[21],"type":["lgl"],"align":["right"]},{"label":["pval_origin.outcome"],"name":[22],"type":["chr"],"align":["left"]},{"label":["chr.exposure"],"name":[23],"type":["dbl"],"align":["right"]},{"label":["pos.exposure"],"name":[24],"type":["dbl"],"align":["right"]},{"label":["se.exposure"],"name":[25],"type":["dbl"],"align":["right"]},{"label":["z.exposure"],"name":[26],"type":["dbl"],"align":["right"]},{"label":["pval.exposure"],"name":[27],"type":["dbl"],"align":["right"]},{"label":["samplesize.exposure"],"name":[28],"type":["dbl"],"align":["right"]},{"label":["exposure"],"name":[29],"type":["chr"],"align":["left"]},{"label":["mr_keep.exposure"],"name":[30],"type":["lgl"],"align":["right"]},{"label":["pval_origin.exposure"],"name":[31],"type":["chr"],"align":["left"]},{"label":["id.exposure"],"name":[32],"type":["chr"],"align":["left"]},{"label":["action"],"name":[33],"type":["dbl"],"align":["right"]},{"label":["mr_keep"],"name":[34],"type":["lgl"],"align":["right"]},{"label":["pt"],"name":[35],"type":["dbl"],"align":["right"]},{"label":["pleitropy_keep"],"name":[36],"type":["lgl"],"align":["right"]},{"label":["mrpresso_RSSobs"],"name":[37],"type":["lgl"],"align":["right"]},{"label":["mrpresso_pval"],"name":[38],"type":["lgl"],"align":["right"]},{"label":["mrpresso_keep"],"name":[39],"type":["lgl"],"align":["right"]}],"data":[{"1":"rs141441332","2":"A","3":"C","4":"A","5":"C","6":"0.5383","7":"-0.1713400","8":"0.0110","9":"0.004908","10":"FALSE","11":"FALSE","12":"FALSE","13":"K6mmni","14":"19","15":"45438575","16":"0.293840","17":"-0.58310645","18":"0.5598","19":"249496","20":"covidhgi2020anaA2v3","21":"TRUE","22":"reported","23":"19","24":"45438575","25":"0.0632","26":"8.517405","27":"1.713e-17","28":"40255","29":"Huang2017aaos","30":"TRUE","31":"reported","32":"xWZic3","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs2075650","2":"G","3":"A","4":"G","5":"A","6":"0.5502","7":"0.0029626","8":"0.2197","9":"0.165200","10":"FALSE","11":"FALSE","12":"FALSE","13":"K6mmni","14":"19","15":"45395619","16":"0.048090","17":"0.06160532","18":"0.9509","19":"287332","20":"covidhgi2020anaA2v3","21":"TRUE","22":"reported","23":"19","24":"45395619","25":"0.0223","26":"24.672600","27":"5.980e-134","28":"40255","29":"Huang2017aaos","30":"TRUE","31":"reported","32":"xWZic3","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs567075","2":"C","3":"T","4":"C","5":"T","6":"0.0900","7":"0.0264690","8":"0.6903","9":"0.652700","10":"FALSE","11":"FALSE","12":"FALSE","13":"K6mmni","14":"11","15":"85830157","16":"0.035004","17":"0.75617072","18":"0.4495","19":"287332","20":"covidhgi2020anaA2v3","21":"TRUE","22":"reported","23":"11","24":"85830157","25":"0.0132","26":"6.818180","27":"9.084e-12","28":"40255","29":"Huang2017aaos","30":"TRUE","31":"reported","32":"xWZic3","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs62117204","2":"T","3":"C","4":"T","5":"C","6":"-0.1867","7":"0.0470950","8":"0.0601","9":"0.073910","10":"FALSE","11":"FALSE","12":"FALSE","13":"K6mmni","14":"19","15":"45242967","16":"0.066409","17":"0.70916593","18":"0.4782","19":"287332","20":"covidhgi2020anaA2v3","21":"TRUE","22":"reported","23":"19","24":"45242967","25":"0.0278","26":"-6.715827","27":"1.864e-11","28":"40255","29":"Huang2017aaos","30":"TRUE","31":"reported","32":"xWZic3","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs6431219","2":"T","3":"C","4":"T","5":"C","6":"0.0774","7":"-0.0361990","8":"0.4163","9":"0.329700","10":"FALSE","11":"FALSE","12":"FALSE","13":"K6mmni","14":"2","15":"127862133","16":"0.032202","17":"-1.12412273","18":"0.2610","19":"287332","20":"covidhgi2020anaA2v3","21":"TRUE","22":"reported","23":"2","24":"127862133","25":"0.0124","26":"6.241935","27":"3.897e-10","28":"40255","29":"Huang2017aaos","30":"TRUE","31":"reported","32":"xWZic3","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs76205446","2":"A","3":"T","4":"A","5":"T","6":"0.7096","7":"-0.0626160","8":"0.0143","9":"0.010850","10":"FALSE","11":"TRUE","12":"FALSE","13":"K6mmni","14":"19","15":"45355267","16":"0.239510","17":"-0.26143376","18":"0.7938","19":"248961","20":"covidhgi2020anaA2v3","21":"TRUE","22":"reported","23":"19","24":"45355267","25":"0.1234","26":"5.750405","27":"9.010e-09","28":"40255","29":"Huang2017aaos","30":"TRUE","31":"reported","32":"xWZic3","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs7930318","2":"T","3":"C","4":"T","5":"C","6":"0.0750","7":"-0.0617670","8":"0.5996","9":"0.682800","10":"FALSE","11":"FALSE","12":"FALSE","13":"K6mmni","14":"11","15":"60033371","16":"0.048916","17":"-1.26271568","18":"0.2067","19":"277276","20":"covidhgi2020anaA2v3","21":"TRUE","22":"reported","23":"11","24":"60033371","25":"0.0125","26":"6.000000","27":"2.245e-09","28":"40255","29":"Huang2017aaos","30":"TRUE","31":"reported","32":"xWZic3","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

SNPs that genome-wide significant in the outcome GWAS are likely pleitorpic and should be removed from analysis. Additionaly remove variants within the APOE locus by exclude variants 1MB either side of APOE e4 (rs429358 = 19:45411941, GRCh37.p13)
<br>


**Table 5:** SNPs that were genome-wide significant in the very severe respiratory confirmed covid vs. population GWAS
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
{"columns":[{"label":["outliers_removed"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["pve.exposure"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["F"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["Alpha"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["NCP"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["Power"],"name":[6],"type":["dbl"],"align":["right"]}],"data":[{"1":"FALSE","2":"0.04158789","3":"124.7224","4":"0.05","5":"1.404463","6":"0.2200404"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

##  MR Results
To obtain an overall estimate of causal effect, the SNP-exposure and SNP-outcome coefficients were combined in 1) a fixed-effects meta-analysis using an inverse-variance weighted approach (IVW); 2) a Weighted Median approach; 3) Weighted Mode approach and 4) Egger Regression.


[**IVW**](https://doi.org/10.1002/gepi.21758) is equivalent to a weighted regression of the SNP-outcome coefficients on the SNP-exposure coefficients with the intercept constrained to zero. This method assumes that all variants are valid instrumental variables based on the Mendelian randomization assumptions. The causal estimate of the IVW analysis expresses the causal increase in the outcome (or log odds of the outcome for a binary outcome) per unit change in the exposure. [**Weighted median MR**](https://doi.org/10.1002/gepi.21965) allows for 50% of the instrumental variables to be invalid. [**MR-Egger regression**](https://doi.org/10.1093/ije/dyw220) allows all the instrumental variables to be subject to direct effects (i.e. horizontal pleiotropy), with the intercept representing bias in the causal estimate due to pleiotropy and the slope representing the causal estimate. [**Weighted Mode**](https://doi.org/10.1093/ije/dyx102) gives consistent estimates as the sample size increases if a plurality (or weighted plurality) of the genetic variants are valid instruments.
<br>



Table 6 presents the MR causal estimates of genetically predicted AAOS on very severe respiratory confirmed covid vs. population.
<br>

**Table 6** MR causaul estimates for AAOS on very severe respiratory confirmed covid vs. population
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["nsnp"],"name":[6],"type":["int"],"align":["right"]},{"label":["b"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"xWZic3","2":"K6mmni","3":"covidhgi2020anaA2v3","4":"Huang2017aaos","5":"Inverse variance weighted (fixed effects)","6":"7","7":"-0.035161964","8":"0.07769142","9":"0.6508477"},{"1":"xWZic3","2":"K6mmni","3":"covidhgi2020anaA2v3","4":"Huang2017aaos","5":"Weighted median","6":"7","7":"-0.008850046","8":"0.08298995","9":"0.9150746"},{"1":"xWZic3","2":"K6mmni","3":"covidhgi2020anaA2v3","4":"Huang2017aaos","5":"Weighted mode","6":"7","7":"-0.002979083","8":"0.08339326","9":"0.9726618"},{"1":"xWZic3","2":"K6mmni","3":"covidhgi2020anaA2v3","4":"Huang2017aaos","5":"MR Egger","6":"7","7":"0.031510117","8":"0.10756698","9":"0.7813398"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Figure 1 illustrates the SNP-specific associations with AAOS versus the association in very severe respiratory confirmed covid vs. population and the corresponding MR estimates.
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovid/Huang2017aaos/covidhgi2020anaA2v3/Huang2017aaos_5e-8_covidhgi2020anaA2v3_MR_Analaysis_files/figure-html/scatter_plot-1.png" alt="Fig. 1: Scatterplot of SNP effects for the association of the Exposure on the Outcome"  />
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
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["Q"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["Q_df"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["Q_pval"],"name":[8],"type":["dbl"],"align":["right"]}],"data":[{"1":"xWZic3","2":"K6mmni","3":"covidhgi2020anaA2v3","4":"Huang2017aaos","5":"MR Egger","6":"3.336991","7":"5","8":"0.6481833"},{"1":"xWZic3","2":"K6mmni","3":"covidhgi2020anaA2v3","4":"Huang2017aaos","5":"Inverse variance weighted","6":"4.140136","7":"6","8":"0.6577187"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Figure 2 shows a funnel plot displaying the MR estimates of individual genetic variants against their precession. Aysmmetry in the funnel plot may arrise due to some genetic variants having unusally strong effects on the outcome, which is indicative of directional pleiotropy.
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovid/Huang2017aaos/covidhgi2020anaA2v3/Huang2017aaos_5e-8_covidhgi2020anaA2v3_MR_Analaysis_files/figure-html/funnel_plot-1.png" alt="Fig. 2: Funnel plot of the MR causal estimates against their precession"  />
<p class="caption">Fig. 2: Funnel plot of the MR causal estimates against their precession</p>
</div>
<br>

Figure 3 shows a [Radial Plots](https://github.com/WSpiller/RadialMR) can be used to visualize influential data points with large contributions to Cochran's Q Statistic that may bias causal effect estimates.




```
## [1] "No significant Outliers"
```

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovid/Huang2017aaos/covidhgi2020anaA2v3/Huang2017aaos_5e-8_covidhgi2020anaA2v3_MR_Analaysis_files/figure-html/Radial_Plot-1.png" alt="Fig. 4: Radial Plot showing influential data points using Radial IVW"  />
<p class="caption">Fig. 4: Radial Plot showing influential data points using Radial IVW</p>
</div>
<br>

The intercept of the MR-Regression model captures the average pleitropic affect across all genetic variants (Table 8).
<br>

**Table 8:** MR Egger test for directional pleitropy
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["egger_intercept"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[7],"type":["dbl"],"align":["right"]}],"data":[{"1":"xWZic3","2":"K6mmni","3":"covidhgi2020anaA2v3","4":"Huang2017aaos","5":"-0.02309463","6":"0.02576997","7":"0.4112212"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Pleiotropy was also assesed using Mendelian Randomization Pleiotropy RESidual Sum and Outlier [(MR-PRESSO)](https://doi.org/10.1038/s41588-018-0099-7), that allows for the evlation of evaluation of horizontal pleiotropy in a standared MR model (Table 9). MR-PRESSO performs a global test for detection of horizontal pleiotropy and correction of pleiotropy via outlier removal (Table 10).
<br>

**Table 9:** MR-PRESSO Global Test for pleitropy
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["pt"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["outliers_removed"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["n_outliers"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["RSSobs"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"xWZic3","2":"K6mmni","3":"covidhgi2020anaA2v3","4":"Huang2017aaos","5":"5e-08","6":"FALSE","7":"0","8":"9.044035","9":"0.4675"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>


**Table 10:** MR Estimates after MR-PRESSO outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["fctr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["fctr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["nsnp"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["b"],"name":[7],"type":["lgl"],"align":["right"]},{"label":["se"],"name":[8],"type":["lgl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["lgl"],"align":["right"]}],"data":[{"1":"xWZic3","2":"K6mmni","3":"covidhgi2020anaA2v3","4":"Huang2017aaos","5":"mrpresso","6":"NA","7":"NA","8":"NA","9":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovid/Huang2017aaos/covidhgi2020anaA2v3/Huang2017aaos_5e-8_covidhgi2020anaA2v3_MR_Analaysis_files/figure-html/scatter_plot_outlier-1.png" alt="Fig. 5: Scatterplot of SNP effects for the association of the Exposure on the Outcome after outlier removal"  />
<p class="caption">Fig. 5: Scatterplot of SNP effects for the association of the Exposure on the Outcome after outlier removal</p>
</div>
<br>

**Table 11:** Heterogenity Tests after outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["fctr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["fctr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["Q"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["Q_df"],"name":[7],"type":["lgl"],"align":["right"]},{"label":["Q_pval"],"name":[8],"type":["lgl"],"align":["right"]}],"data":[{"1":"xWZic3","2":"K6mmni","3":"covidhgi2020anaA2v3","4":"Huang2017aaos","5":"mrpresso","6":"NA","7":"NA","8":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

**Table 12:** MR Egger test for directional pleitropy after outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["fctr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["fctr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["egger_intercept"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["se"],"name":[7],"type":["lgl"],"align":["right"]},{"label":["pval"],"name":[8],"type":["lgl"],"align":["right"]}],"data":[{"1":"xWZic3","2":"K6mmni","3":"covidhgi2020anaA2v3","4":"Huang2017aaos","5":"mrpresso","6":"NA","7":"NA","8":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>
