---
title: "Mendelian Randomization Analysis"
author: "Dr. Shea Andrews"
date: "2020-11-12"
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

### Exposure: Heart Failure
`#r exposure.blurb`
<br>

**Table 1:** Independent SNPs associated with Heart Failure
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["CHROM"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["REF"],"name":[4],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[5],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[12],"type":["chr"],"align":["left"]}],"data":[{"1":"rs660240","2":"1","3":"109817838","4":"T","5":"C","6":"0.7872","7":"0.0611","8":"0.0097","9":"6.298970","10":"3.251e-10","11":"950670","12":"Heart_Failure"},{"1":"rs17042102","2":"4","3":"111668626","4":"G","5":"A","6":"0.1150","7":"0.1103","8":"0.0121","9":"9.115702","10":"5.705e-20","11":"960978","12":"Heart_Failure"},{"1":"rs11745324","2":"5","3":"137012171","4":"G","5":"A","6":"0.2277","7":"-0.0528","8":"0.0095","9":"-5.557895","10":"2.345e-08","11":"953416","12":"Heart_Failure"},{"1":"rs4135240","2":"6","3":"36647680","4":"T","5":"C","6":"0.3411","7":"-0.0486","8":"0.0084","9":"-5.785710","10":"6.838e-09","11":"953252","12":"Heart_Failure"},{"1":"rs55730499","2":"6","3":"161005610","4":"C","5":"T","6":"0.0694","7":"0.1058","8":"0.0157","9":"6.738854","10":"1.830e-11","11":"953746","12":"Heart_Failure"},{"1":"rs140570886","2":"6","3":"161013013","4":"T","5":"C","6":"0.0158","7":"0.2136","8":"0.0328","9":"6.512200","10":"7.687e-11","11":"925310","12":"Heart_Failure"},{"1":"rs1556516","2":"9","3":"22100176","4":"G","5":"C","6":"0.4845","7":"0.0622","8":"0.0078","9":"7.974359","10":"1.569e-15","11":"964027","12":"Heart_Failure"},{"1":"rs600038","2":"9","3":"136151806","4":"T","5":"C","6":"0.2091","7":"0.0569","8":"0.0096","9":"5.927080","10":"3.677e-09","11":"958809","12":"Heart_Failure"},{"1":"rs4746140","2":"10","3":"75417249","4":"G","5":"C","6":"0.1540","7":"-0.0666","8":"0.0109","9":"-6.110092","10":"1.104e-09","11":"958813","12":"Heart_Failure"},{"1":"rs17617337","2":"10","3":"121426884","4":"C","5":"T","6":"0.2208","7":"-0.0561","8":"0.0095","9":"-5.905263","10":"3.654e-09","11":"964025","12":"Heart_Failure"},{"1":"rs4766578","2":"12","3":"111904371","4":"T","5":"A","6":"0.5287","7":"-0.0433","8":"0.0079","9":"-5.481013","10":"4.899e-08","11":"956729","12":"Heart_Failure"},{"1":"rs56094641","2":"16","3":"53806453","4":"A","5":"G","6":"0.4158","7":"0.0454","8":"0.0080","9":"5.675000","10":"1.208e-08","11":"956726","12":"Heart_Failure"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

### Outcome: COVID: A2
`#r outcome.blurb`
<br>

**Table 2:** SNPs associated with Heart Failure avaliable in COVID: A2
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["CHROM"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["REF"],"name":[4],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[5],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[12],"type":["chr"],"align":["left"]}],"data":[{"1":"rs660240","2":"1","3":"109817838","4":"T","5":"C","6":"0.78700","7":"-0.0184530","8":"0.058715","9":"-0.3142808","10":"0.753300","11":"251425","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs17042102","2":"4","3":"111668626","4":"G","5":"A","6":"0.14240","7":"-0.0716740","8":"0.046764","9":"-1.5326747","10":"0.125400","11":"261481","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs11745324","2":"5","3":"137012171","4":"G","5":"A","6":"0.24090","7":"-0.0386120","8":"0.054416","9":"-0.7095707","10":"0.478000","11":"251425","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs4135240","2":"6","3":"36647680","4":"T","5":"C","6":"0.33710","7":"0.0238680","8":"0.048386","9":"0.4932832","10":"0.621800","11":"251425","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs55730499","2":"6","3":"161005610","4":"C","5":"T","6":"0.04804","7":"-0.1330500","8":"0.065284","9":"-2.0380185","10":"0.041540","11":"261481","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs140570886","2":"6","3":"161013013","4":"T","5":"C","6":"0.00924","7":"0.0321760","8":"0.239910","9":"0.1341170","10":"0.893300","11":"251022","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs1556516","2":"9","3":"22100176","4":"G","5":"C","6":"0.42940","7":"-0.0449990","8":"0.031753","9":"-1.4171574","10":"0.156400","11":"261481","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs600038","2":"9","3":"136151806","4":"T","5":"C","6":"0.22330","7":"0.1471000","8":"0.055870","9":"2.6329000","10":"0.008468","11":"251022","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs4746140","2":"10","3":"75417249","4":"G","5":"C","6":"0.17270","7":"0.0235900","8":"0.043438","9":"0.5430729","10":"0.587100","11":"261481","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs17617337","2":"10","3":"121426884","4":"C","5":"T","6":"0.21970","7":"-0.0067428","8":"0.039250","9":"-0.1717911","10":"0.863600","11":"261481","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs4766578","2":"12","3":"111904371","4":"T","5":"A","6":"0.56580","7":"0.0354920","8":"0.047637","9":"0.7450511","10":"0.456200","11":"251425","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs56094641","2":"16","3":"53806453","4":"A","5":"G","6":"0.41890","7":"-0.0388190","8":"0.031435","9":"-1.2348974","10":"0.216900","11":"261481","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
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

**Table 4:** Harmonized Heart Failure and COVID: A2 datasets
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["effect_allele.exposure"],"name":[2],"type":["chr"],"align":["left"]},{"label":["other_allele.exposure"],"name":[3],"type":["chr"],"align":["left"]},{"label":["effect_allele.outcome"],"name":[4],"type":["chr"],"align":["left"]},{"label":["other_allele.outcome"],"name":[5],"type":["chr"],"align":["left"]},{"label":["beta.exposure"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["beta.outcome"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["eaf.exposure"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["eaf.outcome"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["remove"],"name":[10],"type":["lgl"],"align":["right"]},{"label":["palindromic"],"name":[11],"type":["lgl"],"align":["right"]},{"label":["ambiguous"],"name":[12],"type":["lgl"],"align":["right"]},{"label":["id.outcome"],"name":[13],"type":["chr"],"align":["left"]},{"label":["chr.outcome"],"name":[14],"type":["dbl"],"align":["right"]},{"label":["pos.outcome"],"name":[15],"type":["dbl"],"align":["right"]},{"label":["se.outcome"],"name":[16],"type":["dbl"],"align":["right"]},{"label":["z.outcome"],"name":[17],"type":["dbl"],"align":["right"]},{"label":["pval.outcome"],"name":[18],"type":["dbl"],"align":["right"]},{"label":["samplesize.outcome"],"name":[19],"type":["dbl"],"align":["right"]},{"label":["outcome"],"name":[20],"type":["chr"],"align":["left"]},{"label":["mr_keep.outcome"],"name":[21],"type":["lgl"],"align":["right"]},{"label":["pval_origin.outcome"],"name":[22],"type":["chr"],"align":["left"]},{"label":["chr.exposure"],"name":[23],"type":["dbl"],"align":["right"]},{"label":["pos.exposure"],"name":[24],"type":["dbl"],"align":["right"]},{"label":["se.exposure"],"name":[25],"type":["dbl"],"align":["right"]},{"label":["z.exposure"],"name":[26],"type":["dbl"],"align":["right"]},{"label":["pval.exposure"],"name":[27],"type":["dbl"],"align":["right"]},{"label":["samplesize.exposure"],"name":[28],"type":["dbl"],"align":["right"]},{"label":["exposure"],"name":[29],"type":["chr"],"align":["left"]},{"label":["mr_keep.exposure"],"name":[30],"type":["lgl"],"align":["right"]},{"label":["pval_origin.exposure"],"name":[31],"type":["chr"],"align":["left"]},{"label":["id.exposure"],"name":[32],"type":["chr"],"align":["left"]},{"label":["action"],"name":[33],"type":["dbl"],"align":["right"]},{"label":["mr_keep"],"name":[34],"type":["lgl"],"align":["right"]},{"label":["pt"],"name":[35],"type":["dbl"],"align":["right"]},{"label":["pleitropy_keep"],"name":[36],"type":["lgl"],"align":["right"]},{"label":["mrpresso_RSSobs"],"name":[37],"type":["lgl"],"align":["right"]},{"label":["mrpresso_pval"],"name":[38],"type":["lgl"],"align":["right"]},{"label":["mrpresso_keep"],"name":[39],"type":["lgl"],"align":["right"]}],"data":[{"1":"rs11745324","2":"A","3":"G","4":"A","5":"G","6":"-0.0528","7":"-0.0386120","8":"0.2277","9":"0.24090","10":"FALSE","11":"FALSE","12":"FALSE","13":"smsYrp","14":"5","15":"137012171","16":"0.054416","17":"-0.7095707","18":"0.478000","19":"251425","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"5","24":"137012171","25":"0.0095","26":"-5.557895","27":"2.345e-08","28":"953416","29":"Shah2020heartfailure","30":"TRUE","31":"reported","32":"wQewuR","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs140570886","2":"C","3":"T","4":"C","5":"T","6":"0.2136","7":"0.0321760","8":"0.0158","9":"0.00924","10":"FALSE","11":"FALSE","12":"FALSE","13":"smsYrp","14":"6","15":"161013013","16":"0.239910","17":"0.1341170","18":"0.893300","19":"251022","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"6","24":"161013013","25":"0.0328","26":"6.512200","27":"7.687e-11","28":"925310","29":"Shah2020heartfailure","30":"TRUE","31":"reported","32":"wQewuR","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs1556516","2":"C","3":"G","4":"C","5":"G","6":"0.0622","7":"-0.0449990","8":"0.4845","9":"0.42940","10":"FALSE","11":"TRUE","12":"TRUE","13":"smsYrp","14":"9","15":"22100176","16":"0.031753","17":"-1.4171574","18":"0.156400","19":"261481","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"9","24":"22100176","25":"0.0078","26":"7.974359","27":"1.569e-15","28":"964027","29":"Shah2020heartfailure","30":"TRUE","31":"reported","32":"wQewuR","33":"2","34":"FALSE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"NA"},{"1":"rs17042102","2":"A","3":"G","4":"A","5":"G","6":"0.1103","7":"-0.0716740","8":"0.1150","9":"0.14240","10":"FALSE","11":"FALSE","12":"FALSE","13":"smsYrp","14":"4","15":"111668626","16":"0.046764","17":"-1.5326747","18":"0.125400","19":"261481","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"4","24":"111668626","25":"0.0121","26":"9.115702","27":"5.705e-20","28":"960978","29":"Shah2020heartfailure","30":"TRUE","31":"reported","32":"wQewuR","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs17617337","2":"T","3":"C","4":"T","5":"C","6":"-0.0561","7":"-0.0067428","8":"0.2208","9":"0.21970","10":"FALSE","11":"FALSE","12":"FALSE","13":"smsYrp","14":"10","15":"121426884","16":"0.039250","17":"-0.1717911","18":"0.863600","19":"261481","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"10","24":"121426884","25":"0.0095","26":"-5.905263","27":"3.654e-09","28":"964025","29":"Shah2020heartfailure","30":"TRUE","31":"reported","32":"wQewuR","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs4135240","2":"C","3":"T","4":"C","5":"T","6":"-0.0486","7":"0.0238680","8":"0.3411","9":"0.33710","10":"FALSE","11":"FALSE","12":"FALSE","13":"smsYrp","14":"6","15":"36647680","16":"0.048386","17":"0.4932832","18":"0.621800","19":"251425","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"6","24":"36647680","25":"0.0084","26":"-5.785710","27":"6.838e-09","28":"953252","29":"Shah2020heartfailure","30":"TRUE","31":"reported","32":"wQewuR","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs4746140","2":"C","3":"G","4":"C","5":"G","6":"-0.0666","7":"0.0235900","8":"0.1540","9":"0.17270","10":"FALSE","11":"TRUE","12":"FALSE","13":"smsYrp","14":"10","15":"75417249","16":"0.043438","17":"0.5430729","18":"0.587100","19":"261481","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"10","24":"75417249","25":"0.0109","26":"-6.110092","27":"1.104e-09","28":"958813","29":"Shah2020heartfailure","30":"TRUE","31":"reported","32":"wQewuR","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs4766578","2":"A","3":"T","4":"A","5":"T","6":"-0.0433","7":"0.0354920","8":"0.5287","9":"0.56580","10":"FALSE","11":"TRUE","12":"TRUE","13":"smsYrp","14":"12","15":"111904371","16":"0.047637","17":"0.7450511","18":"0.456200","19":"251425","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"12","24":"111904371","25":"0.0079","26":"-5.481013","27":"4.899e-08","28":"956729","29":"Shah2020heartfailure","30":"TRUE","31":"reported","32":"wQewuR","33":"2","34":"FALSE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"NA"},{"1":"rs55730499","2":"T","3":"C","4":"T","5":"C","6":"0.1058","7":"-0.1330500","8":"0.0694","9":"0.04804","10":"FALSE","11":"FALSE","12":"FALSE","13":"smsYrp","14":"6","15":"161005610","16":"0.065284","17":"-2.0380185","18":"0.041540","19":"261481","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"6","24":"161005610","25":"0.0157","26":"6.738854","27":"1.830e-11","28":"953746","29":"Shah2020heartfailure","30":"TRUE","31":"reported","32":"wQewuR","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs56094641","2":"G","3":"A","4":"G","5":"A","6":"0.0454","7":"-0.0388190","8":"0.4158","9":"0.41890","10":"FALSE","11":"FALSE","12":"FALSE","13":"smsYrp","14":"16","15":"53806453","16":"0.031435","17":"-1.2348974","18":"0.216900","19":"261481","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"16","24":"53806453","25":"0.0080","26":"5.675000","27":"1.208e-08","28":"956726","29":"Shah2020heartfailure","30":"TRUE","31":"reported","32":"wQewuR","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs600038","2":"C","3":"T","4":"C","5":"T","6":"0.0569","7":"0.1471000","8":"0.2091","9":"0.22330","10":"FALSE","11":"FALSE","12":"FALSE","13":"smsYrp","14":"9","15":"136151806","16":"0.055870","17":"2.6329000","18":"0.008468","19":"251022","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"9","24":"136151806","25":"0.0096","26":"5.927080","27":"3.677e-09","28":"958809","29":"Shah2020heartfailure","30":"TRUE","31":"reported","32":"wQewuR","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs660240","2":"C","3":"T","4":"C","5":"T","6":"0.0611","7":"-0.0184530","8":"0.7872","9":"0.78700","10":"FALSE","11":"FALSE","12":"FALSE","13":"smsYrp","14":"1","15":"109817838","16":"0.058715","17":"-0.3142808","18":"0.753300","19":"251425","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"1","24":"109817838","25":"0.0097","26":"6.298970","27":"3.251e-10","28":"950670","29":"Shah2020heartfailure","30":"TRUE","31":"reported","32":"wQewuR","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
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
{"columns":[{"label":["outliers_removed"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["pve.exposure"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["F"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["Alpha"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["NCP"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["Power"],"name":[6],"type":["dbl"],"align":["right"]}],"data":[{"1":"FALSE","2":"0.0004236844","3":"41.42473","4":"0.05","5":"1.350328","6":"0.2133544"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

##  MR Results
To obtain an overall estimate of causal effect, the SNP-exposure and SNP-outcome coefficients were combined in 1) a fixed-effects meta-analysis using an inverse-variance weighted approach (IVW); 2) a Weighted Median approach; 3) Weighted Mode approach and 4) Egger Regression.


[**IVW**](https://doi.org/10.1002/gepi.21758) is equivalent to a weighted regression of the SNP-outcome coefficients on the SNP-exposure coefficients with the intercept constrained to zero. This method assumes that all variants are valid instrumental variables based on the Mendelian randomization assumptions. The causal estimate of the IVW analysis expresses the causal increase in the outcome (or log odds of the outcome for a binary outcome) per unit change in the exposure. [**Weighted median MR**](https://doi.org/10.1002/gepi.21965) allows for 50% of the instrumental variables to be invalid. [**MR-Egger regression**](https://doi.org/10.1093/ije/dyw220) allows all the instrumental variables to be subject to direct effects (i.e. horizontal pleiotropy), with the intercept representing bias in the causal estimate due to pleiotropy and the slope representing the causal estimate. [**Weighted Mode**](https://doi.org/10.1093/ije/dyx102) gives consistent estimates as the sample size increases if a plurality (or weighted plurality) of the genetic variants are valid instruments.
<br>



Table 6 presents the MR causal estimates of genetically predicted Heart Failure on COVID: A2.
<br>

**Table 6** MR causaul estimates for Heart Failure on COVID: A2
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["nsnp"],"name":[6],"type":["int"],"align":["right"]},{"label":["b"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"wQewuR","2":"smsYrp","3":"covidhgi2020anaA2v4eurwoukbb","4":"Shah2020heartfailure","5":"Inverse variance weighted (fixed effects)","6":"10","7":"-0.3390110","8":"0.2262682","9":"0.13406291"},{"1":"wQewuR","2":"smsYrp","3":"covidhgi2020anaA2v4eurwoukbb","4":"Shah2020heartfailure","5":"Weighted median","6":"10","7":"-0.5349054","8":"0.3025426","9":"0.07705535"},{"1":"wQewuR","2":"smsYrp","3":"covidhgi2020anaA2v4eurwoukbb","4":"Shah2020heartfailure","5":"Weighted mode","6":"10","7":"-0.5766473","8":"0.3414821","9":"0.12555228"},{"1":"wQewuR","2":"smsYrp","3":"covidhgi2020anaA2v4eurwoukbb","4":"Shah2020heartfailure","5":"MR Egger","6":"10","7":"-1.0374633","8":"0.8217724","9":"0.24233616"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Figure 1 illustrates the SNP-specific associations with Heart Failure versus the association in COVID: A2 and the corresponding MR estimates.
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovideurwoukbb/Shah2020heartfailure/covidhgi2020anaA2v4eurwoukbb/Shah2020heartfailure_5e-8_covidhgi2020anaA2v4eurwoukbb_MR_Analaysis_files/figure-html/scatter_plot-1.png" alt="Fig. 1: Scatterplot of SNP effects for the association of the Exposure on the Outcome"  />
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
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["Q"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["Q_df"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["Q_pval"],"name":[8],"type":["dbl"],"align":["right"]}],"data":[{"1":"wQewuR","2":"smsYrp","3":"covidhgi2020anaA2v4eurwoukbb","4":"Shah2020heartfailure","5":"MR Egger","6":"12.60976","7":"8","8":"0.1260005"},{"1":"wQewuR","2":"smsYrp","3":"covidhgi2020anaA2v4eurwoukbb","4":"Shah2020heartfailure","5":"Inverse variance weighted","6":"13.90294","7":"9","8":"0.1258201"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Figure 2 shows a funnel plot displaying the MR estimates of individual genetic variants against their precession. Aysmmetry in the funnel plot may arrise due to some genetic variants having unusally strong effects on the outcome, which is indicative of directional pleiotropy.
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovideurwoukbb/Shah2020heartfailure/covidhgi2020anaA2v4eurwoukbb/Shah2020heartfailure_5e-8_covidhgi2020anaA2v4eurwoukbb_MR_Analaysis_files/figure-html/funnel_plot-1.png" alt="Fig. 2: Funnel plot of the MR causal estimates against their precession"  />
<p class="caption">Fig. 2: Funnel plot of the MR causal estimates against their precession</p>
</div>
<br>

Figure 3 shows a [Radial Plots](https://github.com/WSpiller/RadialMR) can be used to visualize influential data points with large contributions to Cochran's Q Statistic that may bias causal effect estimates.



<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovideurwoukbb/Shah2020heartfailure/covidhgi2020anaA2v4eurwoukbb/Shah2020heartfailure_5e-8_covidhgi2020anaA2v4eurwoukbb_MR_Analaysis_files/figure-html/Radial_Plot-1.png" alt="Fig. 4: Radial Plot showing influential data points using Radial IVW"  />
<p class="caption">Fig. 4: Radial Plot showing influential data points using Radial IVW</p>
</div>
<br>

The intercept of the MR-Regression model captures the average pleitropic affect across all genetic variants (Table 8).
<br>

**Table 8:** MR Egger test for directional pleitropy
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["egger_intercept"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[7],"type":["dbl"],"align":["right"]}],"data":[{"1":"wQewuR","2":"smsYrp","3":"covidhgi2020anaA2v4eurwoukbb","4":"Shah2020heartfailure","5":"0.05030926","6":"0.05554282","7":"0.3915184"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Pleiotropy was also assesed using Mendelian Randomization Pleiotropy RESidual Sum and Outlier [(MR-PRESSO)](https://doi.org/10.1038/s41588-018-0099-7), that allows for the evlation of evaluation of horizontal pleiotropy in a standared MR model (Table 9). MR-PRESSO performs a global test for detection of horizontal pleiotropy and correction of pleiotropy via outlier removal (Table 10).
<br>

**Table 9:** MR-PRESSO Global Test for pleitropy
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["pt"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["outliers_removed"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["n_outliers"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["RSSobs"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"wQewuR","2":"smsYrp","3":"covidhgi2020anaA2v4eurwoukbb","4":"Shah2020heartfailure","5":"5e-08","6":"FALSE","7":"0","8":"16.55954","9":"0.1496"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>


**Table 10:** MR Estimates after MR-PRESSO outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["nsnp"],"name":[6],"type":["int"],"align":["right"]},{"label":["b"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"wQewuR","2":"smsYrp","3":"covidhgi2020anaA2v4eurwoukbb","4":"Shah2020heartfailure","5":"Inverse variance weighted (fixed effects)","6":"10","7":"-0.3390110","8":"0.2262682","9":"0.13406291"},{"1":"wQewuR","2":"smsYrp","3":"covidhgi2020anaA2v4eurwoukbb","4":"Shah2020heartfailure","5":"Weighted median","6":"10","7":"-0.5349054","8":"0.3125089","9":"0.08696146"},{"1":"wQewuR","2":"smsYrp","3":"covidhgi2020anaA2v4eurwoukbb","4":"Shah2020heartfailure","5":"Weighted mode","6":"10","7":"-0.5766473","8":"0.3444346","9":"0.12841870"},{"1":"wQewuR","2":"smsYrp","3":"covidhgi2020anaA2v4eurwoukbb","4":"Shah2020heartfailure","5":"MR Egger","6":"10","7":"-1.0374633","8":"0.8217724","9":"0.24233616"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovideurwoukbb/Shah2020heartfailure/covidhgi2020anaA2v4eurwoukbb/Shah2020heartfailure_5e-8_covidhgi2020anaA2v4eurwoukbb_MR_Analaysis_files/figure-html/scatter_plot_outlier-1.png" alt="Fig. 5: Scatterplot of SNP effects for the association of the Exposure on the Outcome after outlier removal"  />
<p class="caption">Fig. 5: Scatterplot of SNP effects for the association of the Exposure on the Outcome after outlier removal</p>
</div>
<br>

**Table 11:** Heterogenity Tests after outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["Q"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["Q_df"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["Q_pval"],"name":[8],"type":["dbl"],"align":["right"]}],"data":[{"1":"wQewuR","2":"smsYrp","3":"covidhgi2020anaA2v4eurwoukbb","4":"Shah2020heartfailure","5":"MR Egger","6":"12.60976","7":"8","8":"0.1260005"},{"1":"wQewuR","2":"smsYrp","3":"covidhgi2020anaA2v4eurwoukbb","4":"Shah2020heartfailure","5":"Inverse variance weighted","6":"13.90294","7":"9","8":"0.1258201"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

**Table 12:** MR Egger test for directional pleitropy after outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["egger_intercept"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[7],"type":["dbl"],"align":["right"]}],"data":[{"1":"wQewuR","2":"smsYrp","3":"covidhgi2020anaA2v4eurwoukbb","4":"Shah2020heartfailure","5":"0.05030926","6":"0.05554282","7":"0.3915184"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>