---
title: "Mendelian Randomization Analysis"
author: "Dr. Shea Andrews"
date: "2020-10-04"
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

### Exposure: Social Isolation
`#r exposure.blurb`
<br>

**Table 1:** Independent SNPs associated with Social Isolation
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["CHROM"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["REF"],"name":[4],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[5],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[12],"type":["chr"],"align":["left"]}],"data":[{"1":"rs6430286","2":"2","3":"148834364","4":"G","5":"A","6":"0.423798","7":"-0.0116104","8":"0.00207269","9":"-5.60161","10":"2.124e-08","11":"452302","12":"Social_Isolation"},{"1":"rs74338595","2":"2","3":"212749786","4":"T","5":"C","6":"0.289914","7":"-0.0131836","8":"0.00225741","9":"-5.84016","10":"5.215e-09","11":"452302","12":"Social_Isolation"},{"1":"rs4465966","2":"3","3":"82009703","4":"A","5":"G","6":"0.570762","7":"-0.0122513","8":"0.00206930","9":"-5.92049","10":"3.210e-09","11":"452302","12":"Social_Isolation"},{"1":"rs30266","2":"5","3":"103972357","4":"G","5":"A","6":"0.328420","7":"0.0122519","8":"0.00218090","9":"5.61782","10":"1.934e-08","11":"452302","12":"Social_Isolation"},{"1":"rs2069117","2":"5","3":"152244551","4":"A","5":"C","6":"0.632457","7":"0.0142595","8":"0.00212437","9":"6.71233","10":"1.915e-11","11":"452302","12":"Social_Isolation"},{"1":"rs10456089","2":"6","3":"11959836","4":"G","5":"A","6":"0.079416","7":"-0.0217495","8":"0.00378804","9":"-5.74162","10":"9.377e-09","11":"452302","12":"Social_Isolation"},{"1":"rs7770860","2":"6","3":"131186393","4":"T","5":"C","6":"0.373251","7":"0.0128998","8":"0.00211764","9":"6.09156","10":"1.118e-09","11":"452302","12":"Social_Isolation"},{"1":"rs773020","2":"9","3":"77768122","4":"G","5":"A","6":"0.899908","7":"0.0205988","8":"0.00341273","9":"6.03587","10":"1.581e-09","11":"452302","12":"Social_Isolation"},{"1":"rs10992800","2":"9","3":"96373818","4":"G","5":"A","6":"0.397116","7":"-0.0155114","8":"0.00209327","9":"-7.41016","10":"1.261e-13","11":"452302","12":"Social_Isolation"},{"1":"rs11605348","2":"11","3":"47606483","4":"G","5":"A","6":"0.350304","7":"-0.0121724","8":"0.00214695","9":"-5.66963","10":"1.431e-08","11":"452302","12":"Social_Isolation"},{"1":"rs1966836","2":"11","3":"57982229","4":"A","5":"G","6":"0.711208","7":"-0.0130414","8":"0.00226001","9":"-5.77051","10":"7.903e-09","11":"452302","12":"Social_Isolation"},{"1":"rs62085660","2":"17","3":"66097739","4":"C","5":"G","6":"0.742566","7":"-0.0142656","8":"0.00234261","9":"-6.08963","10":"1.132e-09","11":"452302","12":"Social_Isolation"},{"1":"rs613872","2":"18","3":"53210302","4":"G","5":"T","6":"0.826351","7":"0.0227670","8":"0.00270385","9":"8.42021","10":"3.758e-17","11":"452302","12":"Social_Isolation"},{"1":"rs1022688","2":"20","3":"47648856","4":"G","5":"A","6":"0.330232","7":"0.0129423","8":"0.00217785","9":"5.94267","10":"2.804e-09","11":"452302","12":"Social_Isolation"},{"1":"rs495146","2":"20","3":"48130328","4":"C","5":"T","6":"0.250050","7":"0.0129730","8":"0.00236522","9":"5.48491","10":"4.137e-08","11":"452302","12":"Social_Isolation"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

### Outcome: very severe respiratory confirmed covid vs. population
`#r outcome.blurb`
<br>

**Table 2:** SNPs associated with Social Isolation avaliable in very severe respiratory confirmed covid vs. population
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["CHROM"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["REF"],"name":[4],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[5],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[12],"type":["chr"],"align":["left"]}],"data":[{"1":"rs6430286","2":"2","3":"148834364","4":"G","5":"A","6":"0.3835","7":"0.0312700","8":"0.032296","9":"0.9682314","10":"0.3329","11":"287332","12":"very_severe_respiratory_confirmed_covid_vs._population"},{"1":"rs74338595","2":"2","3":"212749786","4":"T","5":"C","6":"0.2655","7":"-0.0060751","8":"0.057916","9":"-0.1048950","10":"0.9165","11":"249899","12":"very_severe_respiratory_confirmed_covid_vs._population"},{"1":"rs4465966","2":"3","3":"82009703","4":"A","5":"G","6":"0.5679","7":"0.0052666","8":"0.032638","9":"0.1613641","10":"0.8718","11":"287332","12":"very_severe_respiratory_confirmed_covid_vs._population"},{"1":"rs30266","2":"5","3":"103972357","4":"G","5":"A","6":"0.2959","7":"0.0112500","8":"0.035122","9":"0.3203121","10":"0.7487","11":"286929","12":"very_severe_respiratory_confirmed_covid_vs._population"},{"1":"rs2069117","2":"5","3":"152244551","4":"A","5":"C","6":"0.5897","7":"-0.0501990","8":"0.033079","9":"-1.5175489","10":"0.1291","11":"287332","12":"very_severe_respiratory_confirmed_covid_vs._population"},{"1":"rs773020","2":"9","3":"77768122","4":"G","5":"A","6":"0.9010","7":"-0.0388190","8":"0.106060","9":"-0.3660098","10":"0.7144","11":"248017","12":"very_severe_respiratory_confirmed_covid_vs._population"},{"1":"rs10992800","2":"9","3":"96373818","4":"G","5":"A","6":"0.3759","7":"0.0077940","8":"0.034514","9":"0.2258214","10":"0.8213","11":"287332","12":"very_severe_respiratory_confirmed_covid_vs._population"},{"1":"rs11605348","2":"11","3":"47606483","4":"G","5":"A","6":"0.3481","7":"-0.0397060","8":"0.034562","9":"-1.1488340","10":"0.2506","11":"287332","12":"very_severe_respiratory_confirmed_covid_vs._population"},{"1":"rs1966836","2":"11","3":"57982229","4":"A","5":"G","6":"0.7021","7":"-0.0170970","8":"0.035436","9":"-0.4824754","10":"0.6295","11":"287332","12":"very_severe_respiratory_confirmed_covid_vs._population"},{"1":"rs62085660","2":"17","3":"66097739","4":"C","5":"G","6":"0.7072","7":"-0.0291460","8":"0.057427","9":"-0.5075313","10":"0.6118","11":"249899","12":"very_severe_respiratory_confirmed_covid_vs._population"},{"1":"rs1022688","2":"20","3":"47648856","4":"G","5":"A","6":"0.2780","7":"0.0493230","8":"0.034837","9":"1.4158223","10":"0.1568","11":"287332","12":"very_severe_respiratory_confirmed_covid_vs._population"},{"1":"rs495146","2":"20","3":"48130328","4":"C","5":"T","6":"0.2353","7":"-0.0264990","8":"0.035734","9":"-0.7415627","10":"0.4583","11":"287332","12":"very_severe_respiratory_confirmed_covid_vs._population"},{"1":"rs10456089","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA"},{"1":"rs7770860","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA"},{"1":"rs613872","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

**Table 3:** Proxy SNPs for very severe respiratory confirmed covid vs. population
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["proxy.outcome"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["target_snp"],"name":[2],"type":["chr"],"align":["left"]},{"label":["proxy_snp"],"name":[3],"type":["lgl"],"align":["right"]},{"label":["ld.r2"],"name":[4],"type":["lgl"],"align":["right"]},{"label":["Dprime"],"name":[5],"type":["lgl"],"align":["right"]},{"label":["ref.proxy"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["alt.proxy"],"name":[7],"type":["lgl"],"align":["right"]},{"label":["CHROM"],"name":[8],"type":["lgl"],"align":["right"]},{"label":["POS"],"name":[9],"type":["lgl"],"align":["right"]},{"label":["ALT.proxy"],"name":[10],"type":["lgl"],"align":["right"]},{"label":["REF.proxy"],"name":[11],"type":["lgl"],"align":["right"]},{"label":["AF"],"name":[12],"type":["lgl"],"align":["right"]},{"label":["BETA"],"name":[13],"type":["lgl"],"align":["right"]},{"label":["SE"],"name":[14],"type":["lgl"],"align":["right"]},{"label":["P"],"name":[15],"type":["lgl"],"align":["right"]},{"label":["N"],"name":[16],"type":["lgl"],"align":["right"]},{"label":["ref"],"name":[17],"type":["lgl"],"align":["right"]},{"label":["alt"],"name":[18],"type":["lgl"],"align":["right"]},{"label":["ALT"],"name":[19],"type":["lgl"],"align":["right"]},{"label":["REF"],"name":[20],"type":["lgl"],"align":["right"]},{"label":["PHASE"],"name":[21],"type":["lgl"],"align":["right"]}],"data":[{"1":"NA","2":"rs10456089","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA","13":"NA","14":"NA","15":"NA","16":"NA","17":"NA","18":"NA","19":"NA","20":"NA","21":"NA"},{"1":"NA","2":"rs7770860","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA","13":"NA","14":"NA","15":"NA","16":"NA","17":"NA","18":"NA","19":"NA","20":"NA","21":"NA"},{"1":"NA","2":"rs613872","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA","13":"NA","14":"NA","15":"NA","16":"NA","17":"NA","18":"NA","19":"NA","20":"NA","21":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

## Data harmonization
Harmonize the exposure and outcome datasets so that the effect of a SNP on the exposure and the effect of that SNP on the outcome correspond to the same allele. The harmonise_data function from the TwoSampleMR package can be used to perform the harmonization step, by default it try's to infer the forward strand alleles using allele frequency information.
<br>

**Table 4:** Harmonized Social Isolation and very severe respiratory confirmed covid vs. population datasets
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["effect_allele.exposure"],"name":[2],"type":["chr"],"align":["left"]},{"label":["other_allele.exposure"],"name":[3],"type":["chr"],"align":["left"]},{"label":["effect_allele.outcome"],"name":[4],"type":["chr"],"align":["left"]},{"label":["other_allele.outcome"],"name":[5],"type":["chr"],"align":["left"]},{"label":["beta.exposure"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["beta.outcome"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["eaf.exposure"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["eaf.outcome"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["remove"],"name":[10],"type":["lgl"],"align":["right"]},{"label":["palindromic"],"name":[11],"type":["lgl"],"align":["right"]},{"label":["ambiguous"],"name":[12],"type":["lgl"],"align":["right"]},{"label":["id.outcome"],"name":[13],"type":["chr"],"align":["left"]},{"label":["chr.outcome"],"name":[14],"type":["dbl"],"align":["right"]},{"label":["pos.outcome"],"name":[15],"type":["dbl"],"align":["right"]},{"label":["se.outcome"],"name":[16],"type":["dbl"],"align":["right"]},{"label":["z.outcome"],"name":[17],"type":["dbl"],"align":["right"]},{"label":["pval.outcome"],"name":[18],"type":["dbl"],"align":["right"]},{"label":["samplesize.outcome"],"name":[19],"type":["dbl"],"align":["right"]},{"label":["outcome"],"name":[20],"type":["chr"],"align":["left"]},{"label":["mr_keep.outcome"],"name":[21],"type":["lgl"],"align":["right"]},{"label":["pval_origin.outcome"],"name":[22],"type":["chr"],"align":["left"]},{"label":["chr.exposure"],"name":[23],"type":["dbl"],"align":["right"]},{"label":["pos.exposure"],"name":[24],"type":["dbl"],"align":["right"]},{"label":["se.exposure"],"name":[25],"type":["dbl"],"align":["right"]},{"label":["z.exposure"],"name":[26],"type":["dbl"],"align":["right"]},{"label":["pval.exposure"],"name":[27],"type":["dbl"],"align":["right"]},{"label":["samplesize.exposure"],"name":[28],"type":["dbl"],"align":["right"]},{"label":["exposure"],"name":[29],"type":["chr"],"align":["left"]},{"label":["mr_keep.exposure"],"name":[30],"type":["lgl"],"align":["right"]},{"label":["pval_origin.exposure"],"name":[31],"type":["chr"],"align":["left"]},{"label":["id.exposure"],"name":[32],"type":["chr"],"align":["left"]},{"label":["action"],"name":[33],"type":["dbl"],"align":["right"]},{"label":["mr_keep"],"name":[34],"type":["lgl"],"align":["right"]},{"label":["pt"],"name":[35],"type":["dbl"],"align":["right"]},{"label":["pleitropy_keep"],"name":[36],"type":["lgl"],"align":["right"]},{"label":["mrpresso_RSSobs"],"name":[37],"type":["lgl"],"align":["right"]},{"label":["mrpresso_pval"],"name":[38],"type":["lgl"],"align":["right"]},{"label":["mrpresso_keep"],"name":[39],"type":["lgl"],"align":["right"]}],"data":[{"1":"rs1022688","2":"A","3":"G","4":"A","5":"G","6":"0.0129423","7":"0.0493230","8":"0.330232","9":"0.2780","10":"FALSE","11":"FALSE","12":"FALSE","13":"XVCaNu","14":"20","15":"47648856","16":"0.034837","17":"1.4158223","18":"0.1568","19":"287332","20":"covidhgi2020anaA2v3","21":"TRUE","22":"reported","23":"20","24":"47648856","25":"0.00217785","26":"5.94267","27":"2.804e-09","28":"452302","29":"Day2018sociso","30":"TRUE","31":"reported","32":"poWGdl","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs10992800","2":"A","3":"G","4":"A","5":"G","6":"-0.0155114","7":"0.0077940","8":"0.397116","9":"0.3759","10":"FALSE","11":"FALSE","12":"FALSE","13":"XVCaNu","14":"9","15":"96373818","16":"0.034514","17":"0.2258214","18":"0.8213","19":"287332","20":"covidhgi2020anaA2v3","21":"TRUE","22":"reported","23":"9","24":"96373818","25":"0.00209327","26":"-7.41016","27":"1.261e-13","28":"452302","29":"Day2018sociso","30":"TRUE","31":"reported","32":"poWGdl","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs11605348","2":"A","3":"G","4":"A","5":"G","6":"-0.0121724","7":"-0.0397060","8":"0.350304","9":"0.3481","10":"FALSE","11":"FALSE","12":"FALSE","13":"XVCaNu","14":"11","15":"47606483","16":"0.034562","17":"-1.1488340","18":"0.2506","19":"287332","20":"covidhgi2020anaA2v3","21":"TRUE","22":"reported","23":"11","24":"47606483","25":"0.00214695","26":"-5.66963","27":"1.431e-08","28":"452302","29":"Day2018sociso","30":"TRUE","31":"reported","32":"poWGdl","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs1966836","2":"G","3":"A","4":"G","5":"A","6":"-0.0130414","7":"-0.0170970","8":"0.711208","9":"0.7021","10":"FALSE","11":"FALSE","12":"FALSE","13":"XVCaNu","14":"11","15":"57982229","16":"0.035436","17":"-0.4824754","18":"0.6295","19":"287332","20":"covidhgi2020anaA2v3","21":"TRUE","22":"reported","23":"11","24":"57982229","25":"0.00226001","26":"-5.77051","27":"7.903e-09","28":"452302","29":"Day2018sociso","30":"TRUE","31":"reported","32":"poWGdl","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs2069117","2":"C","3":"A","4":"C","5":"A","6":"0.0142595","7":"-0.0501990","8":"0.632457","9":"0.5897","10":"FALSE","11":"FALSE","12":"FALSE","13":"XVCaNu","14":"5","15":"152244551","16":"0.033079","17":"-1.5175489","18":"0.1291","19":"287332","20":"covidhgi2020anaA2v3","21":"TRUE","22":"reported","23":"5","24":"152244551","25":"0.00212437","26":"6.71233","27":"1.915e-11","28":"452302","29":"Day2018sociso","30":"TRUE","31":"reported","32":"poWGdl","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs30266","2":"A","3":"G","4":"A","5":"G","6":"0.0122519","7":"0.0112500","8":"0.328420","9":"0.2959","10":"FALSE","11":"FALSE","12":"FALSE","13":"XVCaNu","14":"5","15":"103972357","16":"0.035122","17":"0.3203121","18":"0.7487","19":"286929","20":"covidhgi2020anaA2v3","21":"TRUE","22":"reported","23":"5","24":"103972357","25":"0.00218090","26":"5.61782","27":"1.934e-08","28":"452302","29":"Day2018sociso","30":"TRUE","31":"reported","32":"poWGdl","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs4465966","2":"G","3":"A","4":"G","5":"A","6":"-0.0122513","7":"0.0052666","8":"0.570762","9":"0.5679","10":"FALSE","11":"FALSE","12":"FALSE","13":"XVCaNu","14":"3","15":"82009703","16":"0.032638","17":"0.1613641","18":"0.8718","19":"287332","20":"covidhgi2020anaA2v3","21":"TRUE","22":"reported","23":"3","24":"82009703","25":"0.00206930","26":"-5.92049","27":"3.210e-09","28":"452302","29":"Day2018sociso","30":"TRUE","31":"reported","32":"poWGdl","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs495146","2":"T","3":"C","4":"T","5":"C","6":"0.0129730","7":"-0.0264990","8":"0.250050","9":"0.2353","10":"FALSE","11":"FALSE","12":"FALSE","13":"XVCaNu","14":"20","15":"48130328","16":"0.035734","17":"-0.7415627","18":"0.4583","19":"287332","20":"covidhgi2020anaA2v3","21":"TRUE","22":"reported","23":"20","24":"48130328","25":"0.00236522","26":"5.48491","27":"4.137e-08","28":"452302","29":"Day2018sociso","30":"TRUE","31":"reported","32":"poWGdl","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs62085660","2":"G","3":"C","4":"G","5":"C","6":"-0.0142656","7":"-0.0291460","8":"0.742566","9":"0.7072","10":"FALSE","11":"TRUE","12":"FALSE","13":"XVCaNu","14":"17","15":"66097739","16":"0.057427","17":"-0.5075313","18":"0.6118","19":"249899","20":"covidhgi2020anaA2v3","21":"TRUE","22":"reported","23":"17","24":"66097739","25":"0.00234261","26":"-6.08963","27":"1.132e-09","28":"452302","29":"Day2018sociso","30":"TRUE","31":"reported","32":"poWGdl","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs6430286","2":"A","3":"G","4":"A","5":"G","6":"-0.0116104","7":"0.0312700","8":"0.423798","9":"0.3835","10":"FALSE","11":"FALSE","12":"FALSE","13":"XVCaNu","14":"2","15":"148834364","16":"0.032296","17":"0.9682314","18":"0.3329","19":"287332","20":"covidhgi2020anaA2v3","21":"TRUE","22":"reported","23":"2","24":"148834364","25":"0.00207269","26":"-5.60161","27":"2.124e-08","28":"452302","29":"Day2018sociso","30":"TRUE","31":"reported","32":"poWGdl","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs74338595","2":"C","3":"T","4":"C","5":"T","6":"-0.0131836","7":"-0.0060751","8":"0.289914","9":"0.2655","10":"FALSE","11":"FALSE","12":"FALSE","13":"XVCaNu","14":"2","15":"212749786","16":"0.057916","17":"-0.1048950","18":"0.9165","19":"249899","20":"covidhgi2020anaA2v3","21":"TRUE","22":"reported","23":"2","24":"212749786","25":"0.00225741","26":"-5.84016","27":"5.215e-09","28":"452302","29":"Day2018sociso","30":"TRUE","31":"reported","32":"poWGdl","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs773020","2":"A","3":"G","4":"A","5":"G","6":"0.0205988","7":"-0.0388190","8":"0.899908","9":"0.9010","10":"FALSE","11":"FALSE","12":"FALSE","13":"XVCaNu","14":"9","15":"77768122","16":"0.106060","17":"-0.3660098","18":"0.7144","19":"248017","20":"covidhgi2020anaA2v3","21":"TRUE","22":"reported","23":"9","24":"77768122","25":"0.00341273","26":"6.03587","27":"1.581e-09","28":"452302","29":"Day2018sociso","30":"TRUE","31":"reported","32":"poWGdl","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
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
{"columns":[{"label":["outliers_removed"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["pve.exposure"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["F"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["Alpha"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["NCP"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["Power"],"name":[6],"type":["dbl"],"align":["right"]}],"data":[{"1":"FALSE","2":"0.0009662569","3":"36.45417","4":"0.05","5":"0.02105004","6":"0.05241482"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

##  MR Results
To obtain an overall estimate of causal effect, the SNP-exposure and SNP-outcome coefficients were combined in 1) a fixed-effects meta-analysis using an inverse-variance weighted approach (IVW); 2) a Weighted Median approach; 3) Weighted Mode approach and 4) Egger Regression.


[**IVW**](https://doi.org/10.1002/gepi.21758) is equivalent to a weighted regression of the SNP-outcome coefficients on the SNP-exposure coefficients with the intercept constrained to zero. This method assumes that all variants are valid instrumental variables based on the Mendelian randomization assumptions. The causal estimate of the IVW analysis expresses the causal increase in the outcome (or log odds of the outcome for a binary outcome) per unit change in the exposure. [**Weighted median MR**](https://doi.org/10.1002/gepi.21965) allows for 50% of the instrumental variables to be invalid. [**MR-Egger regression**](https://doi.org/10.1093/ije/dyw220) allows all the instrumental variables to be subject to direct effects (i.e. horizontal pleiotropy), with the intercept representing bias in the causal estimate due to pleiotropy and the slope representing the causal estimate. [**Weighted Mode**](https://doi.org/10.1093/ije/dyx102) gives consistent estimates as the sample size increases if a plurality (or weighted plurality) of the genetic variants are valid instruments.
<br>



Table 6 presents the MR causal estimates of genetically predicted Social Isolation on very severe respiratory confirmed covid vs. population.
<br>

**Table 6** MR causaul estimates for Social Isolation on very severe respiratory confirmed covid vs. population
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["nsnp"],"name":[6],"type":["int"],"align":["right"]},{"label":["b"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"poWGdl","2":"XVCaNu","3":"covidhgi2020anaA2v3","4":"Day2018sociso","5":"Inverse variance weighted (fixed effects)","6":"12","7":"-0.09229264","8":"0.8275534","9":"0.9112003"},{"1":"poWGdl","2":"XVCaNu","3":"covidhgi2020anaA2v3","4":"Day2018sociso","5":"Weighted median","6":"12","7":"-0.44099558","8":"1.1182854","9":"0.6933228"},{"1":"poWGdl","2":"XVCaNu","3":"covidhgi2020anaA2v3","4":"Day2018sociso","5":"Weighted mode","6":"12","7":"-0.22152694","8":"1.8629924","9":"0.9074910"},{"1":"poWGdl","2":"XVCaNu","3":"covidhgi2020anaA2v3","4":"Day2018sociso","5":"MR Egger","6":"12","7":"-5.01816818","8":"7.9903561","9":"0.5440606"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Figure 1 illustrates the SNP-specific associations with Social Isolation versus the association in very severe respiratory confirmed covid vs. population and the corresponding MR estimates.
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovid/Day2018sociso/covidhgi2020anaA2v3/Day2018sociso_5e-8_covidhgi2020anaA2v3_MR_Analaysis_files/figure-html/scatter_plot-1.png" alt="Fig. 1: Scatterplot of SNP effects for the association of the Exposure on the Outcome"  />
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
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["Q"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["Q_df"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["Q_pval"],"name":[8],"type":["dbl"],"align":["right"]}],"data":[{"1":"poWGdl","2":"XVCaNu","3":"covidhgi2020anaA2v3","4":"Day2018sociso","5":"MR Egger","6":"7.533081","7":"10","8":"0.6743407"},{"1":"poWGdl","2":"XVCaNu","3":"covidhgi2020anaA2v3","4":"Day2018sociso","5":"Inverse variance weighted","6":"7.917246","7":"11","8":"0.7206971"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Figure 2 shows a funnel plot displaying the MR estimates of individual genetic variants against their precession. Aysmmetry in the funnel plot may arrise due to some genetic variants having unusally strong effects on the outcome, which is indicative of directional pleiotropy.
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovid/Day2018sociso/covidhgi2020anaA2v3/Day2018sociso_5e-8_covidhgi2020anaA2v3_MR_Analaysis_files/figure-html/funnel_plot-1.png" alt="Fig. 2: Funnel plot of the MR causal estimates against their precession"  />
<p class="caption">Fig. 2: Funnel plot of the MR causal estimates against their precession</p>
</div>
<br>

Figure 3 shows a [Radial Plots](https://github.com/WSpiller/RadialMR) can be used to visualize influential data points with large contributions to Cochran's Q Statistic that may bias causal effect estimates.




```
## [1] "No significant Outliers"
```

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovid/Day2018sociso/covidhgi2020anaA2v3/Day2018sociso_5e-8_covidhgi2020anaA2v3_MR_Analaysis_files/figure-html/Radial_Plot-1.png" alt="Fig. 4: Radial Plot showing influential data points using Radial IVW"  />
<p class="caption">Fig. 4: Radial Plot showing influential data points using Radial IVW</p>
</div>
<br>

The intercept of the MR-Regression model captures the average pleitropic affect across all genetic variants (Table 8).
<br>

**Table 8:** MR Egger test for directional pleitropy
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["egger_intercept"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[7],"type":["dbl"],"align":["right"]}],"data":[{"1":"poWGdl","2":"XVCaNu","3":"covidhgi2020anaA2v3","4":"Day2018sociso","5":"0.06532594","6":"0.1053966","7":"0.5492439"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Pleiotropy was also assesed using Mendelian Randomization Pleiotropy RESidual Sum and Outlier [(MR-PRESSO)](https://doi.org/10.1038/s41588-018-0099-7), that allows for the evlation of evaluation of horizontal pleiotropy in a standared MR model (Table 9). MR-PRESSO performs a global test for detection of horizontal pleiotropy and correction of pleiotropy via outlier removal (Table 10).
<br>

**Table 9:** MR-PRESSO Global Test for pleitropy
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["pt"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["outliers_removed"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["n_outliers"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["RSSobs"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"poWGdl","2":"XVCaNu","3":"covidhgi2020anaA2v3","4":"Day2018sociso","5":"5e-08","6":"FALSE","7":"0","8":"9.745515","9":"0.6899"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>


**Table 10:** MR Estimates after MR-PRESSO outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["fctr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["fctr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["nsnp"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["b"],"name":[7],"type":["lgl"],"align":["right"]},{"label":["se"],"name":[8],"type":["lgl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["lgl"],"align":["right"]}],"data":[{"1":"poWGdl","2":"XVCaNu","3":"covidhgi2020anaA2v3","4":"Day2018sociso","5":"mrpresso","6":"NA","7":"NA","8":"NA","9":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovid/Day2018sociso/covidhgi2020anaA2v3/Day2018sociso_5e-8_covidhgi2020anaA2v3_MR_Analaysis_files/figure-html/scatter_plot_outlier-1.png" alt="Fig. 5: Scatterplot of SNP effects for the association of the Exposure on the Outcome after outlier removal"  />
<p class="caption">Fig. 5: Scatterplot of SNP effects for the association of the Exposure on the Outcome after outlier removal</p>
</div>
<br>

**Table 11:** Heterogenity Tests after outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["fctr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["fctr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["Q"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["Q_df"],"name":[7],"type":["lgl"],"align":["right"]},{"label":["Q_pval"],"name":[8],"type":["lgl"],"align":["right"]}],"data":[{"1":"poWGdl","2":"XVCaNu","3":"covidhgi2020anaA2v3","4":"Day2018sociso","5":"mrpresso","6":"NA","7":"NA","8":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

**Table 12:** MR Egger test for directional pleitropy after outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["fctr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["fctr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["egger_intercept"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["se"],"name":[7],"type":["lgl"],"align":["right"]},{"label":["pval"],"name":[8],"type":["lgl"],"align":["right"]}],"data":[{"1":"poWGdl","2":"XVCaNu","3":"covidhgi2020anaA2v3","4":"Day2018sociso","5":"mrpresso","6":"NA","7":"NA","8":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>
