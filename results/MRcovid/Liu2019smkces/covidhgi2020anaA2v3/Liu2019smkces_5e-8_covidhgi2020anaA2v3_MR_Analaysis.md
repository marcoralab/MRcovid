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

### Exposure: Smoking cessation
`#r exposure.blurb`
<br>

**Table 1:** Independent SNPs associated with Smoking cessation
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["CHROM"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["REF"],"name":[4],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[5],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[12],"type":["chr"],"align":["left"]}],"data":[{"1":"rs60749569","2":"8","3":"42602668","4":"A","5":"T","6":"0.0757","7":"-0.0234","8":"0.00466","9":"-5.021459","10":"1.95e-08","11":"312821","12":"smkces"},{"1":"rs3025327","2":"9","3":"136467344","4":"G","5":"C","6":"0.0935","7":"0.0345","8":"0.00405","9":"8.518519","10":"1.96e-24","11":"312821","12":"smkces"},{"1":"rs7127006","2":"11","3":"16379226","4":"G","5":"A","6":"0.2780","7":"0.0141","8":"0.00272","9":"5.183824","10":"2.24e-08","11":"312821","12":"smkces"},{"1":"rs12911035","2":"15","3":"76606591","4":"T","5":"C","6":"0.5330","7":"0.0106","8":"0.00242","9":"4.380165","10":"3.75e-08","11":"312821","12":"smkces"},{"1":"rs518425","2":"15","3":"78883813","4":"A","5":"G","6":"0.3070","7":"-0.0159","8":"0.00270","9":"-5.888889","10":"7.57e-11","11":"312821","12":"smkces"},{"1":"rs56113850","2":"19","3":"41353107","4":"T","5":"C","6":"0.5680","7":"-0.0206","8":"0.00252","9":"-8.174603","10":"2.52e-26","11":"312821","12":"smkces"},{"1":"rs6011779","2":"20","3":"61984317","4":"C","5":"T","6":"0.7860","7":"-0.0222","8":"0.00314","9":"-7.070064","10":"2.04e-16","11":"312821","12":"smkces"},{"1":"rs9607805","2":"22","3":"41854446","4":"C","5":"T","6":"0.6940","7":"0.0138","8":"0.00276","9":"5.000000","10":"2.97e-09","11":"312821","12":"smkces"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

### Outcome: very severe respiratory confirmed covid vs. population
`#r outcome.blurb`
<br>

**Table 2:** SNPs associated with Smoking cessation avaliable in very severe respiratory confirmed covid vs. population
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["CHROM"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["REF"],"name":[4],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[5],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[12],"type":["chr"],"align":["left"]}],"data":[{"1":"rs60749569","2":"8","3":"42602668","4":"A","5":"T","6":"0.04187","7":"-0.0071488","8":"0.096032","9":"-0.07444185","10":"0.9407","11":"38565","12":"very_severe_respiratory_confirmed_covid_vs._population"},{"1":"rs3025327","2":"9","3":"136467344","4":"G","5":"C","6":"0.03552","7":"0.0268060","8":"0.055623","9":"0.48192295","10":"0.6299","11":"287332","12":"very_severe_respiratory_confirmed_covid_vs._population"},{"1":"rs7127006","2":"11","3":"16379226","4":"G","5":"A","6":"0.20730","7":"-0.0136660","8":"0.060409","9":"-0.22622457","10":"0.8210","11":"249899","12":"very_severe_respiratory_confirmed_covid_vs._population"},{"1":"rs12911035","2":"15","3":"76606591","4":"T","5":"C","6":"0.50400","7":"0.0075427","8":"0.053190","9":"0.14180673","10":"0.8872","11":"11188","12":"very_severe_respiratory_confirmed_covid_vs._population"},{"1":"rs518425","2":"15","3":"78883813","4":"A","5":"G","6":"0.32930","7":"-0.0276330","8":"0.035441","9":"-0.77969019","10":"0.4356","11":"287332","12":"very_severe_respiratory_confirmed_covid_vs._population"},{"1":"rs56113850","2":"19","3":"41353107","4":"T","5":"C","6":"0.56070","7":"-0.0306940","8":"0.051652","9":"-0.59424611","10":"0.5524","11":"249899","12":"very_severe_respiratory_confirmed_covid_vs._population"},{"1":"rs6011779","2":"20","3":"61984317","4":"C","5":"T","6":"0.74720","7":"-0.0271650","8":"0.057313","9":"-0.47397624","10":"0.6355","11":"277276","12":"very_severe_respiratory_confirmed_covid_vs._population"},{"1":"rs9607805","2":"22","3":"41854446","4":"C","5":"T","6":"0.65040","7":"-0.0020342","8":"0.054523","9":"-0.03730903","10":"0.9702","11":"277276","12":"very_severe_respiratory_confirmed_covid_vs._population"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
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

**Table 4:** Harmonized Smoking cessation and very severe respiratory confirmed covid vs. population datasets
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["effect_allele.exposure"],"name":[2],"type":["chr"],"align":["left"]},{"label":["other_allele.exposure"],"name":[3],"type":["chr"],"align":["left"]},{"label":["effect_allele.outcome"],"name":[4],"type":["chr"],"align":["left"]},{"label":["other_allele.outcome"],"name":[5],"type":["chr"],"align":["left"]},{"label":["beta.exposure"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["beta.outcome"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["eaf.exposure"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["eaf.outcome"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["remove"],"name":[10],"type":["lgl"],"align":["right"]},{"label":["palindromic"],"name":[11],"type":["lgl"],"align":["right"]},{"label":["ambiguous"],"name":[12],"type":["lgl"],"align":["right"]},{"label":["id.outcome"],"name":[13],"type":["chr"],"align":["left"]},{"label":["chr.outcome"],"name":[14],"type":["dbl"],"align":["right"]},{"label":["pos.outcome"],"name":[15],"type":["dbl"],"align":["right"]},{"label":["se.outcome"],"name":[16],"type":["dbl"],"align":["right"]},{"label":["z.outcome"],"name":[17],"type":["dbl"],"align":["right"]},{"label":["pval.outcome"],"name":[18],"type":["dbl"],"align":["right"]},{"label":["samplesize.outcome"],"name":[19],"type":["dbl"],"align":["right"]},{"label":["outcome"],"name":[20],"type":["chr"],"align":["left"]},{"label":["mr_keep.outcome"],"name":[21],"type":["lgl"],"align":["right"]},{"label":["pval_origin.outcome"],"name":[22],"type":["chr"],"align":["left"]},{"label":["chr.exposure"],"name":[23],"type":["dbl"],"align":["right"]},{"label":["pos.exposure"],"name":[24],"type":["dbl"],"align":["right"]},{"label":["se.exposure"],"name":[25],"type":["dbl"],"align":["right"]},{"label":["z.exposure"],"name":[26],"type":["dbl"],"align":["right"]},{"label":["pval.exposure"],"name":[27],"type":["dbl"],"align":["right"]},{"label":["samplesize.exposure"],"name":[28],"type":["dbl"],"align":["right"]},{"label":["exposure"],"name":[29],"type":["chr"],"align":["left"]},{"label":["mr_keep.exposure"],"name":[30],"type":["lgl"],"align":["right"]},{"label":["pval_origin.exposure"],"name":[31],"type":["chr"],"align":["left"]},{"label":["id.exposure"],"name":[32],"type":["chr"],"align":["left"]},{"label":["action"],"name":[33],"type":["dbl"],"align":["right"]},{"label":["mr_keep"],"name":[34],"type":["lgl"],"align":["right"]},{"label":["pt"],"name":[35],"type":["dbl"],"align":["right"]},{"label":["pleitropy_keep"],"name":[36],"type":["lgl"],"align":["right"]},{"label":["mrpresso_RSSobs"],"name":[37],"type":["lgl"],"align":["right"]},{"label":["mrpresso_pval"],"name":[38],"type":["lgl"],"align":["right"]},{"label":["mrpresso_keep"],"name":[39],"type":["lgl"],"align":["right"]}],"data":[{"1":"rs12911035","2":"C","3":"T","4":"C","5":"T","6":"0.0106","7":"0.0075427","8":"0.5330","9":"0.50400","10":"FALSE","11":"FALSE","12":"FALSE","13":"6PDDh3","14":"15","15":"76606591","16":"0.053190","17":"0.14180673","18":"0.8872","19":"11188","20":"covidhgi2020anaA2v3","21":"TRUE","22":"reported","23":"15","24":"76606591","25":"0.00242","26":"4.380165","27":"3.75e-08","28":"312821","29":"Liu2019smkces","30":"TRUE","31":"reported","32":"IoqwJC","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs3025327","2":"C","3":"G","4":"C","5":"G","6":"0.0345","7":"0.0268060","8":"0.0935","9":"0.03552","10":"FALSE","11":"TRUE","12":"FALSE","13":"6PDDh3","14":"9","15":"136467344","16":"0.055623","17":"0.48192295","18":"0.6299","19":"287332","20":"covidhgi2020anaA2v3","21":"TRUE","22":"reported","23":"9","24":"136467344","25":"0.00405","26":"8.518519","27":"1.96e-24","28":"312821","29":"Liu2019smkces","30":"TRUE","31":"reported","32":"IoqwJC","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs518425","2":"G","3":"A","4":"G","5":"A","6":"-0.0159","7":"-0.0276330","8":"0.3070","9":"0.32930","10":"FALSE","11":"FALSE","12":"FALSE","13":"6PDDh3","14":"15","15":"78883813","16":"0.035441","17":"-0.77969019","18":"0.4356","19":"287332","20":"covidhgi2020anaA2v3","21":"TRUE","22":"reported","23":"15","24":"78883813","25":"0.00270","26":"-5.888889","27":"7.57e-11","28":"312821","29":"Liu2019smkces","30":"TRUE","31":"reported","32":"IoqwJC","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs56113850","2":"C","3":"T","4":"C","5":"T","6":"-0.0206","7":"-0.0306940","8":"0.5680","9":"0.56070","10":"FALSE","11":"FALSE","12":"FALSE","13":"6PDDh3","14":"19","15":"41353107","16":"0.051652","17":"-0.59424611","18":"0.5524","19":"249899","20":"covidhgi2020anaA2v3","21":"TRUE","22":"reported","23":"19","24":"41353107","25":"0.00252","26":"-8.174603","27":"2.52e-26","28":"312821","29":"Liu2019smkces","30":"TRUE","31":"reported","32":"IoqwJC","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs6011779","2":"T","3":"C","4":"T","5":"C","6":"-0.0222","7":"-0.0271650","8":"0.7860","9":"0.74720","10":"FALSE","11":"FALSE","12":"FALSE","13":"6PDDh3","14":"20","15":"61984317","16":"0.057313","17":"-0.47397624","18":"0.6355","19":"277276","20":"covidhgi2020anaA2v3","21":"TRUE","22":"reported","23":"20","24":"61984317","25":"0.00314","26":"-7.070064","27":"2.04e-16","28":"312821","29":"Liu2019smkces","30":"TRUE","31":"reported","32":"IoqwJC","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs60749569","2":"T","3":"A","4":"T","5":"A","6":"-0.0234","7":"-0.0071488","8":"0.0757","9":"0.04187","10":"FALSE","11":"TRUE","12":"FALSE","13":"6PDDh3","14":"8","15":"42602668","16":"0.096032","17":"-0.07444185","18":"0.9407","19":"38565","20":"covidhgi2020anaA2v3","21":"TRUE","22":"reported","23":"8","24":"42602668","25":"0.00466","26":"-5.021459","27":"1.95e-08","28":"312821","29":"Liu2019smkces","30":"TRUE","31":"reported","32":"IoqwJC","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs7127006","2":"A","3":"G","4":"A","5":"G","6":"0.0141","7":"-0.0136660","8":"0.2780","9":"0.20730","10":"FALSE","11":"FALSE","12":"FALSE","13":"6PDDh3","14":"11","15":"16379226","16":"0.060409","17":"-0.22622457","18":"0.8210","19":"249899","20":"covidhgi2020anaA2v3","21":"TRUE","22":"reported","23":"11","24":"16379226","25":"0.00272","26":"5.183824","27":"2.24e-08","28":"312821","29":"Liu2019smkces","30":"TRUE","31":"reported","32":"IoqwJC","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs9607805","2":"T","3":"C","4":"T","5":"C","6":"0.0138","7":"-0.0020342","8":"0.6940","9":"0.65040","10":"FALSE","11":"FALSE","12":"FALSE","13":"6PDDh3","14":"22","15":"41854446","16":"0.054523","17":"-0.03730903","18":"0.9702","19":"277276","20":"covidhgi2020anaA2v3","21":"TRUE","22":"reported","23":"22","24":"41854446","25":"0.00276","26":"5.000000","27":"2.97e-09","28":"312821","29":"Liu2019smkces","30":"TRUE","31":"reported","32":"IoqwJC","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
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
{"columns":[{"label":["outliers_removed"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["pve.exposure"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["F"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["Alpha"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["NCP"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["Power"],"name":[6],"type":["dbl"],"align":["right"]}],"data":[{"1":"FALSE","2":"0.001025676","3":"40.14665","4":"0.05","5":"6.614979","6":"0.7297327"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

##  MR Results
To obtain an overall estimate of causal effect, the SNP-exposure and SNP-outcome coefficients were combined in 1) a fixed-effects meta-analysis using an inverse-variance weighted approach (IVW); 2) a Weighted Median approach; 3) Weighted Mode approach and 4) Egger Regression.


[**IVW**](https://doi.org/10.1002/gepi.21758) is equivalent to a weighted regression of the SNP-outcome coefficients on the SNP-exposure coefficients with the intercept constrained to zero. This method assumes that all variants are valid instrumental variables based on the Mendelian randomization assumptions. The causal estimate of the IVW analysis expresses the causal increase in the outcome (or log odds of the outcome for a binary outcome) per unit change in the exposure. [**Weighted median MR**](https://doi.org/10.1002/gepi.21965) allows for 50% of the instrumental variables to be invalid. [**MR-Egger regression**](https://doi.org/10.1093/ije/dyw220) allows all the instrumental variables to be subject to direct effects (i.e. horizontal pleiotropy), with the intercept representing bias in the causal estimate due to pleiotropy and the slope representing the causal estimate. [**Weighted Mode**](https://doi.org/10.1093/ije/dyx102) gives consistent estimates as the sample size increases if a plurality (or weighted plurality) of the genetic variants are valid instruments.
<br>



Table 6 presents the MR causal estimates of genetically predicted Smoking cessation on very severe respiratory confirmed covid vs. population.
<br>

**Table 6** MR causaul estimates for Smoking cessation on very severe respiratory confirmed covid vs. population
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["nsnp"],"name":[6],"type":["int"],"align":["right"]},{"label":["b"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"IoqwJC","2":"6PDDh3","3":"covidhgi2020anaA2v3","4":"Liu2019smkces","5":"Inverse variance weighted (fixed effects)","6":"8","7":"0.9467475","8":"0.9480033","9":"0.3179520"},{"1":"IoqwJC","2":"6PDDh3","3":"covidhgi2020anaA2v3","4":"Liu2019smkces","5":"Weighted median","6":"8","7":"1.0183416","8":"1.1327631","9":"0.3686585"},{"1":"IoqwJC","2":"6PDDh3","3":"covidhgi2020anaA2v3","4":"Liu2019smkces","5":"Weighted mode","6":"8","7":"1.0710661","8":"1.3068391","9":"0.4394625"},{"1":"IoqwJC","2":"6PDDh3","3":"covidhgi2020anaA2v3","4":"Liu2019smkces","5":"MR Egger","6":"8","7":"1.0596555","8":"2.7592730","9":"0.7141940"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Figure 1 illustrates the SNP-specific associations with Smoking cessation versus the association in very severe respiratory confirmed covid vs. population and the corresponding MR estimates.
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovid/Liu2019smkces/covidhgi2020anaA2v3/Liu2019smkces_5e-8_covidhgi2020anaA2v3_MR_Analaysis_files/figure-html/scatter_plot-1.png" alt="Fig. 1: Scatterplot of SNP effects for the association of the Exposure on the Outcome"  />
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
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["Q"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["Q_df"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["Q_pval"],"name":[8],"type":["dbl"],"align":["right"]}],"data":[{"1":"IoqwJC","2":"6PDDh3","3":"covidhgi2020anaA2v3","4":"Liu2019smkces","5":"MR Egger","6":"0.4969178","7":"6","8":"0.9978758"},{"1":"IoqwJC","2":"6PDDh3","3":"covidhgi2020anaA2v3","4":"Liu2019smkces","5":"Inverse variance weighted","6":"0.4988163","7":"7","8":"0.9994508"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Figure 2 shows a funnel plot displaying the MR estimates of individual genetic variants against their precession. Aysmmetry in the funnel plot may arrise due to some genetic variants having unusally strong effects on the outcome, which is indicative of directional pleiotropy.
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovid/Liu2019smkces/covidhgi2020anaA2v3/Liu2019smkces_5e-8_covidhgi2020anaA2v3_MR_Analaysis_files/figure-html/funnel_plot-1.png" alt="Fig. 2: Funnel plot of the MR causal estimates against their precession"  />
<p class="caption">Fig. 2: Funnel plot of the MR causal estimates against their precession</p>
</div>
<br>

Figure 3 shows a [Radial Plots](https://github.com/WSpiller/RadialMR) can be used to visualize influential data points with large contributions to Cochran's Q Statistic that may bias causal effect estimates.




```
## [1] "No significant Outliers"
```

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovid/Liu2019smkces/covidhgi2020anaA2v3/Liu2019smkces_5e-8_covidhgi2020anaA2v3_MR_Analaysis_files/figure-html/Radial_Plot-1.png" alt="Fig. 4: Radial Plot showing influential data points using Radial IVW"  />
<p class="caption">Fig. 4: Radial Plot showing influential data points using Radial IVW</p>
</div>
<br>

The intercept of the MR-Regression model captures the average pleitropic affect across all genetic variants (Table 8).
<br>

**Table 8:** MR Egger test for directional pleitropy
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["egger_intercept"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[7],"type":["dbl"],"align":["right"]}],"data":[{"1":"IoqwJC","2":"6PDDh3","3":"covidhgi2020anaA2v3","4":"Liu2019smkces","5":"-0.0023669","6":"0.05432181","7":"0.9666596"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Pleiotropy was also assesed using Mendelian Randomization Pleiotropy RESidual Sum and Outlier [(MR-PRESSO)](https://doi.org/10.1038/s41588-018-0099-7), that allows for the evlation of evaluation of horizontal pleiotropy in a standared MR model (Table 9). MR-PRESSO performs a global test for detection of horizontal pleiotropy and correction of pleiotropy via outlier removal (Table 10).
<br>

**Table 9:** MR-PRESSO Global Test for pleitropy
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["pt"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["outliers_removed"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["n_outliers"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["RSSobs"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"IoqwJC","2":"6PDDh3","3":"covidhgi2020anaA2v3","4":"Liu2019smkces","5":"5e-08","6":"FALSE","7":"0","8":"0.6300221","9":"0.9996"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>


**Table 10:** MR Estimates after MR-PRESSO outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["fctr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["fctr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["nsnp"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["b"],"name":[7],"type":["lgl"],"align":["right"]},{"label":["se"],"name":[8],"type":["lgl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["lgl"],"align":["right"]}],"data":[{"1":"IoqwJC","2":"6PDDh3","3":"covidhgi2020anaA2v3","4":"Liu2019smkces","5":"mrpresso","6":"NA","7":"NA","8":"NA","9":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovid/Liu2019smkces/covidhgi2020anaA2v3/Liu2019smkces_5e-8_covidhgi2020anaA2v3_MR_Analaysis_files/figure-html/scatter_plot_outlier-1.png" alt="Fig. 5: Scatterplot of SNP effects for the association of the Exposure on the Outcome after outlier removal"  />
<p class="caption">Fig. 5: Scatterplot of SNP effects for the association of the Exposure on the Outcome after outlier removal</p>
</div>
<br>

**Table 11:** Heterogenity Tests after outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["fctr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["fctr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["Q"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["Q_df"],"name":[7],"type":["lgl"],"align":["right"]},{"label":["Q_pval"],"name":[8],"type":["lgl"],"align":["right"]}],"data":[{"1":"IoqwJC","2":"6PDDh3","3":"covidhgi2020anaA2v3","4":"Liu2019smkces","5":"mrpresso","6":"NA","7":"NA","8":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

**Table 12:** MR Egger test for directional pleitropy after outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["fctr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["fctr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["egger_intercept"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["se"],"name":[7],"type":["lgl"],"align":["right"]},{"label":["pval"],"name":[8],"type":["lgl"],"align":["right"]}],"data":[{"1":"IoqwJC","2":"6PDDh3","3":"covidhgi2020anaA2v3","4":"Liu2019smkces","5":"mrpresso","6":"NA","7":"NA","8":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>
