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

### Exposure: LOAD
`#r exposure.blurb`
<br>

**Table 1:** Independent SNPs associated with LOAD
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["CHROM"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["REF"],"name":[4],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[5],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[12],"type":["chr"],"align":["left"]}],"data":[{"1":"rs679515","2":"1","3":"207750568","4":"T","5":"C","6":"0.8126","7":"-0.1508","8":"0.0183","9":"-8.240440","10":"1.555000e-16","11":"63926","12":"LOAD"},{"1":"rs6733839","2":"2","3":"127892810","4":"C","5":"T","6":"0.4067","7":"0.1693","8":"0.0154","9":"10.993506","10":"4.022000e-28","11":"63926","12":"LOAD"},{"1":"rs34665982","2":"6","3":"32560306","4":"T","5":"C","6":"0.5213","7":"-0.0967","8":"0.0166","9":"-5.825300","10":"5.798000e-09","11":"63926","12":"LOAD"},{"1":"rs114812713","2":"6","3":"41034000","4":"G","5":"C","6":"0.0301","7":"0.2980","8":"0.0431","9":"6.914153","10":"4.467000e-12","11":"63926","12":"LOAD"},{"1":"rs1385742","2":"6","3":"47595155","4":"A","5":"T","6":"0.6344","7":"-0.0876","8":"0.0157","9":"-5.579620","10":"2.232000e-08","11":"63926","12":"LOAD"},{"1":"rs11767557","2":"7","3":"143109139","4":"T","5":"C","6":"0.1968","7":"-0.1028","8":"0.0182","9":"-5.648350","10":"1.561000e-08","11":"63926","12":"LOAD"},{"1":"rs73223431","2":"8","3":"27219987","4":"C","5":"T","6":"0.3669","7":"0.0936","8":"0.0153","9":"6.117647","10":"8.342000e-10","11":"63926","12":"LOAD"},{"1":"rs867230","2":"8","3":"27468503","4":"C","5":"A","6":"0.6029","7":"0.1333","8":"0.0158","9":"8.436709","10":"3.492000e-17","11":"63926","12":"LOAD"},{"1":"rs12416487","2":"10","3":"11721057","4":"A","5":"T","6":"0.6519","7":"0.0850","8":"0.0154","9":"5.519480","10":"3.417000e-08","11":"63926","12":"LOAD"},{"1":"rs3740688","2":"11","3":"47380340","4":"G","5":"T","6":"0.5524","7":"0.0935","8":"0.0144","9":"6.493056","10":"9.702000e-11","11":"63926","12":"LOAD"},{"1":"rs1582763","2":"11","3":"60021948","4":"G","5":"A","6":"0.3729","7":"-0.1232","8":"0.0149","9":"-8.268456","10":"1.186000e-16","11":"63926","12":"LOAD"},{"1":"rs3851179","2":"11","3":"85868640","4":"T","5":"C","6":"0.6410","7":"0.1198","8":"0.0148","9":"8.094590","10":"5.809000e-16","11":"63926","12":"LOAD"},{"1":"rs11218343","2":"11","3":"121435587","4":"T","5":"C","6":"0.0401","7":"-0.2053","8":"0.0369","9":"-5.563690","10":"2.633000e-08","11":"63926","12":"LOAD"},{"1":"rs12590654","2":"14","3":"92938855","4":"G","5":"A","6":"0.3353","7":"-0.0906","8":"0.0157","9":"-5.770701","10":"8.729000e-09","11":"63926","12":"LOAD"},{"1":"rs12151021","2":"19","3":"1050874","4":"A","5":"G","6":"0.6753","7":"-0.1071","8":"0.0169","9":"-6.337280","10":"2.562000e-10","11":"63926","12":"LOAD"},{"1":"rs111358663","2":"19","3":"45196958","4":"T","5":"A","6":"0.0111","7":"-0.5369","8":"0.0795","9":"-6.753459","10":"1.436000e-11","11":"63926","12":"LOAD"},{"1":"rs4803765","2":"19","3":"45358448","4":"C","5":"T","6":"0.0243","7":"0.7165","8":"0.0610","9":"11.745902","10":"7.131000e-32","11":"63926","12":"LOAD"},{"1":"rs12972156","2":"19","3":"45387459","4":"C","5":"G","6":"0.2027","7":"0.9653","8":"0.0189","9":"51.074100","10":"2.225074e-308","11":"63926","12":"LOAD"},{"1":"rs117310449","2":"19","3":"45393516","4":"C","5":"T","6":"0.0130","7":"0.9879","8":"0.0691","9":"14.296671","10":"2.275000e-46","11":"63926","12":"LOAD"},{"1":"rs73033507","2":"19","3":"45431403","4":"C","5":"T","6":"0.0239","7":"-0.3620","8":"0.0657","9":"-5.509893","10":"3.646000e-08","11":"63926","12":"LOAD"},{"1":"rs114533385","2":"19","3":"45436753","4":"C","5":"T","6":"0.0210","7":"0.8281","8":"0.0661","9":"12.527988","10":"5.434000e-36","11":"63926","12":"LOAD"},{"1":"rs139995984","2":"19","3":"45574482","4":"G","5":"C","6":"0.0155","7":"-0.5343","8":"0.0879","9":"-6.078498","10":"1.192000e-09","11":"63926","12":"LOAD"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

### Outcome: COVID: A2
`#r outcome.blurb`
<br>

**Table 2:** SNPs associated with LOAD avaliable in COVID: A2
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["CHROM"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["REF"],"name":[4],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[5],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[12],"type":["chr"],"align":["left"]}],"data":[{"1":"rs679515","2":"1","3":"207750568","4":"T","5":"C","6":"0.808400","7":"0.0641330","8":"0.040704","9":"1.575594536","10":"0.115100","11":"261481","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs6733839","2":"2","3":"127892810","4":"C","5":"T","6":"0.374100","7":"0.0167950","8":"0.032104","9":"0.523143534","10":"0.600900","11":"261481","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs114812713","2":"6","3":"41034000","4":"G","5":"C","6":"0.011160","7":"0.0740880","8":"0.107100","9":"0.691764706","10":"0.489100","11":"261078","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs1385742","2":"6","3":"47595155","4":"A","5":"T","6":"0.641500","7":"-0.0306570","8":"0.052489","9":"-0.584065233","10":"0.559200","11":"12311","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs11767557","2":"7","3":"143109139","4":"T","5":"C","6":"0.167100","7":"-0.1111100","8":"0.040139","9":"-2.768130746","10":"0.005638","11":"261078","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs73223431","2":"8","3":"27219987","4":"C","5":"T","6":"0.363700","7":"-0.0752390","8":"0.048952","9":"-1.536995424","10":"0.124300","11":"251425","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs867230","2":"8","3":"27468503","4":"C","5":"A","6":"0.584900","7":"-0.0519060","8":"0.048401","9":"-1.072415859","10":"0.283500","11":"251425","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs12416487","2":"10","3":"11721057","4":"A","5":"T","6":"0.621300","7":"-0.0190250","8":"0.033083","9":"-0.575068766","10":"0.565200","11":"261481","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs3740688","2":"11","3":"47380340","4":"G","5":"T","6":"0.531200","7":"0.0068724","8":"0.046092","9":"0.149101796","10":"0.881500","11":"251425","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs1582763","2":"11","3":"60021948","4":"G","5":"A","6":"0.289300","7":"0.0697560","8":"0.031844","9":"2.190553951","10":"0.028480","11":"261481","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs3851179","2":"11","3":"85868640","4":"T","5":"C","6":"0.640300","7":"0.0816490","8":"0.048193","9":"1.694208703","10":"0.090230","11":"251425","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs11218343","2":"11","3":"121435587","4":"T","5":"C","6":"0.028190","7":"0.0010714","8":"0.078659","9":"0.013620819","10":"0.989100","11":"261481","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs12590654","2":"14","3":"92938855","4":"G","5":"A","6":"0.317100","7":"0.0566060","8":"0.049800","9":"1.136666667","10":"0.255700","11":"251425","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs12151021","2":"19","3":"1050874","4":"A","5":"G","6":"0.727500","7":"0.0090046","8":"0.052299","9":"0.172175376","10":"0.863300","11":"251425","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs111358663","2":"19","3":"45196958","4":"T","5":"A","6":"0.008714","7":"0.0933920","8":"0.183350","9":"0.509364603","10":"0.610500","11":"251022","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs4803765","2":"19","3":"45358448","4":"C","5":"T","6":"0.010650","7":"-0.1029300","8":"0.297880","9":"-0.345541829","10":"0.729700","11":"250701","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs12972156","2":"19","3":"45387459","4":"C","5":"G","6":"0.169200","7":"-0.1300100","8":"0.077313","9":"-1.681605939","10":"0.092650","11":"251425","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs117310449","2":"19","3":"45393516","4":"C","5":"T","6":"0.013260","7":"-0.1040900","8":"0.155120","9":"-0.671028881","10":"0.502200","11":"261078","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs73033507","2":"19","3":"45431403","4":"C","5":"T","6":"0.028590","7":"-0.0013690","8":"0.155610","9":"-0.008797635","10":"0.993000","11":"251425","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs114533385","2":"19","3":"45436753","4":"C","5":"T","6":"0.005441","7":"-0.3119400","8":"0.182840","9":"-1.706081820","10":"0.088000","11":"261078","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs139995984","2":"19","3":"45574482","4":"G","5":"C","6":"0.011200","7":"-0.3188000","8":"0.327750","9":"-0.972692601","10":"0.330700","11":"247590","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs34665982","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

**Table 3:** Proxy SNPs for COVID: A2
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["proxy.outcome"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["target_snp"],"name":[2],"type":["chr"],"align":["left"]},{"label":["proxy_snp"],"name":[3],"type":["lgl"],"align":["right"]},{"label":["ld.r2"],"name":[4],"type":["lgl"],"align":["right"]},{"label":["Dprime"],"name":[5],"type":["lgl"],"align":["right"]},{"label":["ref.proxy"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["alt.proxy"],"name":[7],"type":["lgl"],"align":["right"]},{"label":["CHROM"],"name":[8],"type":["lgl"],"align":["right"]},{"label":["POS"],"name":[9],"type":["lgl"],"align":["right"]},{"label":["ALT.proxy"],"name":[10],"type":["lgl"],"align":["right"]},{"label":["REF.proxy"],"name":[11],"type":["lgl"],"align":["right"]},{"label":["AF"],"name":[12],"type":["lgl"],"align":["right"]},{"label":["BETA"],"name":[13],"type":["lgl"],"align":["right"]},{"label":["SE"],"name":[14],"type":["lgl"],"align":["right"]},{"label":["P"],"name":[15],"type":["lgl"],"align":["right"]},{"label":["N"],"name":[16],"type":["lgl"],"align":["right"]},{"label":["ref"],"name":[17],"type":["lgl"],"align":["right"]},{"label":["alt"],"name":[18],"type":["lgl"],"align":["right"]},{"label":["ALT"],"name":[19],"type":["lgl"],"align":["right"]},{"label":["REF"],"name":[20],"type":["lgl"],"align":["right"]},{"label":["PHASE"],"name":[21],"type":["lgl"],"align":["right"]}],"data":[{"1":"NA","2":"rs34665982","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA","13":"NA","14":"NA","15":"NA","16":"NA","17":"NA","18":"NA","19":"NA","20":"NA","21":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

## Data harmonization
Harmonize the exposure and outcome datasets so that the effect of a SNP on the exposure and the effect of that SNP on the outcome correspond to the same allele. The harmonise_data function from the TwoSampleMR package can be used to perform the harmonization step, by default it try's to infer the forward strand alleles using allele frequency information.
<br>

**Table 4:** Harmonized LOAD and COVID: A2 datasets
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["effect_allele.exposure"],"name":[2],"type":["chr"],"align":["left"]},{"label":["other_allele.exposure"],"name":[3],"type":["chr"],"align":["left"]},{"label":["effect_allele.outcome"],"name":[4],"type":["chr"],"align":["left"]},{"label":["other_allele.outcome"],"name":[5],"type":["chr"],"align":["left"]},{"label":["beta.exposure"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["beta.outcome"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["eaf.exposure"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["eaf.outcome"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["remove"],"name":[10],"type":["lgl"],"align":["right"]},{"label":["palindromic"],"name":[11],"type":["lgl"],"align":["right"]},{"label":["ambiguous"],"name":[12],"type":["lgl"],"align":["right"]},{"label":["id.outcome"],"name":[13],"type":["chr"],"align":["left"]},{"label":["chr.outcome"],"name":[14],"type":["dbl"],"align":["right"]},{"label":["pos.outcome"],"name":[15],"type":["dbl"],"align":["right"]},{"label":["se.outcome"],"name":[16],"type":["dbl"],"align":["right"]},{"label":["z.outcome"],"name":[17],"type":["dbl"],"align":["right"]},{"label":["pval.outcome"],"name":[18],"type":["dbl"],"align":["right"]},{"label":["samplesize.outcome"],"name":[19],"type":["dbl"],"align":["right"]},{"label":["outcome"],"name":[20],"type":["chr"],"align":["left"]},{"label":["mr_keep.outcome"],"name":[21],"type":["lgl"],"align":["right"]},{"label":["pval_origin.outcome"],"name":[22],"type":["chr"],"align":["left"]},{"label":["chr.exposure"],"name":[23],"type":["dbl"],"align":["right"]},{"label":["pos.exposure"],"name":[24],"type":["dbl"],"align":["right"]},{"label":["se.exposure"],"name":[25],"type":["dbl"],"align":["right"]},{"label":["z.exposure"],"name":[26],"type":["dbl"],"align":["right"]},{"label":["pval.exposure"],"name":[27],"type":["dbl"],"align":["right"]},{"label":["samplesize.exposure"],"name":[28],"type":["dbl"],"align":["right"]},{"label":["exposure"],"name":[29],"type":["chr"],"align":["left"]},{"label":["mr_keep.exposure"],"name":[30],"type":["lgl"],"align":["right"]},{"label":["pval_origin.exposure"],"name":[31],"type":["chr"],"align":["left"]},{"label":["id.exposure"],"name":[32],"type":["chr"],"align":["left"]},{"label":["action"],"name":[33],"type":["dbl"],"align":["right"]},{"label":["mr_keep"],"name":[34],"type":["lgl"],"align":["right"]},{"label":["pt"],"name":[35],"type":["dbl"],"align":["right"]},{"label":["pleitropy_keep"],"name":[36],"type":["lgl"],"align":["right"]},{"label":["mrpresso_RSSobs"],"name":[37],"type":["lgl"],"align":["right"]},{"label":["mrpresso_pval"],"name":[38],"type":["lgl"],"align":["right"]},{"label":["mrpresso_keep"],"name":[39],"type":["lgl"],"align":["right"]}],"data":[{"1":"rs111358663","2":"A","3":"T","4":"A","5":"T","6":"-0.5369","7":"0.0933920","8":"0.0111","9":"0.008714","10":"FALSE","11":"TRUE","12":"FALSE","13":"lLtB5M","14":"19","15":"45196958","16":"0.183350","17":"0.509364603","18":"0.610500","19":"251022","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"19","24":"45196958","25":"0.0795","26":"-6.753459","27":"1.436e-11","28":"63926","29":"Kunkle2019load","30":"TRUE","31":"reported","32":"WDB1ej","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs11218343","2":"C","3":"T","4":"C","5":"T","6":"-0.2053","7":"0.0010714","8":"0.0401","9":"0.028190","10":"FALSE","11":"FALSE","12":"FALSE","13":"lLtB5M","14":"11","15":"121435587","16":"0.078659","17":"0.013620819","18":"0.989100","19":"261481","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"11","24":"121435587","25":"0.0369","26":"-5.563690","27":"2.633e-08","28":"63926","29":"Kunkle2019load","30":"TRUE","31":"reported","32":"WDB1ej","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs114533385","2":"T","3":"C","4":"T","5":"C","6":"0.8281","7":"-0.3119400","8":"0.0210","9":"0.005441","10":"FALSE","11":"FALSE","12":"FALSE","13":"lLtB5M","14":"19","15":"45436753","16":"0.182840","17":"-1.706081820","18":"0.088000","19":"261078","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"19","24":"45436753","25":"0.0661","26":"12.527988","27":"5.434e-36","28":"63926","29":"Kunkle2019load","30":"TRUE","31":"reported","32":"WDB1ej","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs114812713","2":"C","3":"G","4":"C","5":"G","6":"0.2980","7":"0.0740880","8":"0.0301","9":"0.011160","10":"FALSE","11":"TRUE","12":"FALSE","13":"lLtB5M","14":"6","15":"41034000","16":"0.107100","17":"0.691764706","18":"0.489100","19":"261078","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"6","24":"41034000","25":"0.0431","26":"6.914153","27":"4.467e-12","28":"63926","29":"Kunkle2019load","30":"TRUE","31":"reported","32":"WDB1ej","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs117310449","2":"T","3":"C","4":"T","5":"C","6":"0.9879","7":"-0.1040900","8":"0.0130","9":"0.013260","10":"FALSE","11":"FALSE","12":"FALSE","13":"lLtB5M","14":"19","15":"45393516","16":"0.155120","17":"-0.671028881","18":"0.502200","19":"261078","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"19","24":"45393516","25":"0.0691","26":"14.296671","27":"2.275e-46","28":"63926","29":"Kunkle2019load","30":"TRUE","31":"reported","32":"WDB1ej","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs11767557","2":"C","3":"T","4":"C","5":"T","6":"-0.1028","7":"-0.1111100","8":"0.1968","9":"0.167100","10":"FALSE","11":"FALSE","12":"FALSE","13":"lLtB5M","14":"7","15":"143109139","16":"0.040139","17":"-2.768130746","18":"0.005638","19":"261078","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"7","24":"143109139","25":"0.0182","26":"-5.648350","27":"1.561e-08","28":"63926","29":"Kunkle2019load","30":"TRUE","31":"reported","32":"WDB1ej","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs12151021","2":"G","3":"A","4":"G","5":"A","6":"-0.1071","7":"0.0090046","8":"0.6753","9":"0.727500","10":"FALSE","11":"FALSE","12":"FALSE","13":"lLtB5M","14":"19","15":"1050874","16":"0.052299","17":"0.172175376","18":"0.863300","19":"251425","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"19","24":"1050874","25":"0.0169","26":"-6.337280","27":"2.562e-10","28":"63926","29":"Kunkle2019load","30":"TRUE","31":"reported","32":"WDB1ej","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs12416487","2":"T","3":"A","4":"T","5":"A","6":"0.0850","7":"-0.0190250","8":"0.6519","9":"0.621300","10":"FALSE","11":"TRUE","12":"FALSE","13":"lLtB5M","14":"10","15":"11721057","16":"0.033083","17":"-0.575068766","18":"0.565200","19":"261481","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"10","24":"11721057","25":"0.0154","26":"5.519480","27":"3.417e-08","28":"63926","29":"Kunkle2019load","30":"TRUE","31":"reported","32":"WDB1ej","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs12590654","2":"A","3":"G","4":"A","5":"G","6":"-0.0906","7":"0.0566060","8":"0.3353","9":"0.317100","10":"FALSE","11":"FALSE","12":"FALSE","13":"lLtB5M","14":"14","15":"92938855","16":"0.049800","17":"1.136666667","18":"0.255700","19":"251425","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"14","24":"92938855","25":"0.0157","26":"-5.770701","27":"8.729e-09","28":"63926","29":"Kunkle2019load","30":"TRUE","31":"reported","32":"WDB1ej","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs12972156","2":"G","3":"C","4":"G","5":"C","6":"0.9653","7":"-0.1300100","8":"0.2027","9":"0.169200","10":"FALSE","11":"TRUE","12":"FALSE","13":"lLtB5M","14":"19","15":"45387459","16":"0.077313","17":"-1.681605939","18":"0.092650","19":"251425","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"19","24":"45387459","25":"0.0189","26":"51.074100","27":"1.000e-200","28":"63926","29":"Kunkle2019load","30":"TRUE","31":"reported","32":"WDB1ej","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs1385742","2":"T","3":"A","4":"T","5":"A","6":"-0.0876","7":"-0.0306570","8":"0.6344","9":"0.641500","10":"FALSE","11":"TRUE","12":"FALSE","13":"lLtB5M","14":"6","15":"47595155","16":"0.052489","17":"-0.584065233","18":"0.559200","19":"12311","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"6","24":"47595155","25":"0.0157","26":"-5.579620","27":"2.232e-08","28":"63926","29":"Kunkle2019load","30":"TRUE","31":"reported","32":"WDB1ej","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs139995984","2":"C","3":"G","4":"C","5":"G","6":"-0.5343","7":"-0.3188000","8":"0.0155","9":"0.011200","10":"FALSE","11":"TRUE","12":"FALSE","13":"lLtB5M","14":"19","15":"45574482","16":"0.327750","17":"-0.972692601","18":"0.330700","19":"247590","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"19","24":"45574482","25":"0.0879","26":"-6.078498","27":"1.192e-09","28":"63926","29":"Kunkle2019load","30":"TRUE","31":"reported","32":"WDB1ej","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs1582763","2":"A","3":"G","4":"A","5":"G","6":"-0.1232","7":"0.0697560","8":"0.3729","9":"0.289300","10":"FALSE","11":"FALSE","12":"FALSE","13":"lLtB5M","14":"11","15":"60021948","16":"0.031844","17":"2.190553951","18":"0.028480","19":"261481","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"11","24":"60021948","25":"0.0149","26":"-8.268456","27":"1.186e-16","28":"63926","29":"Kunkle2019load","30":"TRUE","31":"reported","32":"WDB1ej","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs3740688","2":"T","3":"G","4":"T","5":"G","6":"0.0935","7":"0.0068724","8":"0.5524","9":"0.531200","10":"FALSE","11":"FALSE","12":"FALSE","13":"lLtB5M","14":"11","15":"47380340","16":"0.046092","17":"0.149101796","18":"0.881500","19":"251425","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"11","24":"47380340","25":"0.0144","26":"6.493056","27":"9.702e-11","28":"63926","29":"Kunkle2019load","30":"TRUE","31":"reported","32":"WDB1ej","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs3851179","2":"C","3":"T","4":"C","5":"T","6":"0.1198","7":"0.0816490","8":"0.6410","9":"0.640300","10":"FALSE","11":"FALSE","12":"FALSE","13":"lLtB5M","14":"11","15":"85868640","16":"0.048193","17":"1.694208703","18":"0.090230","19":"251425","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"11","24":"85868640","25":"0.0148","26":"8.094590","27":"5.809e-16","28":"63926","29":"Kunkle2019load","30":"TRUE","31":"reported","32":"WDB1ej","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs4803765","2":"T","3":"C","4":"T","5":"C","6":"0.7165","7":"-0.1029300","8":"0.0243","9":"0.010650","10":"FALSE","11":"FALSE","12":"FALSE","13":"lLtB5M","14":"19","15":"45358448","16":"0.297880","17":"-0.345541829","18":"0.729700","19":"250701","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"19","24":"45358448","25":"0.0610","26":"11.745902","27":"7.131e-32","28":"63926","29":"Kunkle2019load","30":"TRUE","31":"reported","32":"WDB1ej","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs6733839","2":"T","3":"C","4":"T","5":"C","6":"0.1693","7":"0.0167950","8":"0.4067","9":"0.374100","10":"FALSE","11":"FALSE","12":"FALSE","13":"lLtB5M","14":"2","15":"127892810","16":"0.032104","17":"0.523143534","18":"0.600900","19":"261481","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"2","24":"127892810","25":"0.0154","26":"10.993506","27":"4.022e-28","28":"63926","29":"Kunkle2019load","30":"TRUE","31":"reported","32":"WDB1ej","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs679515","2":"C","3":"T","4":"C","5":"T","6":"-0.1508","7":"0.0641330","8":"0.8126","9":"0.808400","10":"FALSE","11":"FALSE","12":"FALSE","13":"lLtB5M","14":"1","15":"207750568","16":"0.040704","17":"1.575594536","18":"0.115100","19":"261481","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"1","24":"207750568","25":"0.0183","26":"-8.240440","27":"1.555e-16","28":"63926","29":"Kunkle2019load","30":"TRUE","31":"reported","32":"WDB1ej","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs73033507","2":"T","3":"C","4":"T","5":"C","6":"-0.3620","7":"-0.0013690","8":"0.0239","9":"0.028590","10":"FALSE","11":"FALSE","12":"FALSE","13":"lLtB5M","14":"19","15":"45431403","16":"0.155610","17":"-0.008797635","18":"0.993000","19":"251425","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"19","24":"45431403","25":"0.0657","26":"-5.509893","27":"3.646e-08","28":"63926","29":"Kunkle2019load","30":"TRUE","31":"reported","32":"WDB1ej","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs73223431","2":"T","3":"C","4":"T","5":"C","6":"0.0936","7":"-0.0752390","8":"0.3669","9":"0.363700","10":"FALSE","11":"FALSE","12":"FALSE","13":"lLtB5M","14":"8","15":"27219987","16":"0.048952","17":"-1.536995424","18":"0.124300","19":"251425","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"8","24":"27219987","25":"0.0153","26":"6.117647","27":"8.342e-10","28":"63926","29":"Kunkle2019load","30":"TRUE","31":"reported","32":"WDB1ej","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs867230","2":"A","3":"C","4":"A","5":"C","6":"0.1333","7":"-0.0519060","8":"0.6029","9":"0.584900","10":"FALSE","11":"FALSE","12":"FALSE","13":"lLtB5M","14":"8","15":"27468503","16":"0.048401","17":"-1.072415859","18":"0.283500","19":"251425","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"8","24":"27468503","25":"0.0158","26":"8.436709","27":"3.492e-17","28":"63926","29":"Kunkle2019load","30":"TRUE","31":"reported","32":"WDB1ej","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
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
{"columns":[{"label":["outliers_removed"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["pve.exposure"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["F"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["Alpha"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["NCP"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["Power"],"name":[6],"type":["dbl"],"align":["right"]}],"data":[{"1":"FALSE","2":"0.06713047","3":"185.523","4":"0.05","5":"13.50388","6":"0.9568089"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

##  MR Results
To obtain an overall estimate of causal effect, the SNP-exposure and SNP-outcome coefficients were combined in 1) a fixed-effects meta-analysis using an inverse-variance weighted approach (IVW); 2) a Weighted Median approach; 3) Weighted Mode approach and 4) Egger Regression.


[**IVW**](https://doi.org/10.1002/gepi.21758) is equivalent to a weighted regression of the SNP-outcome coefficients on the SNP-exposure coefficients with the intercept constrained to zero. This method assumes that all variants are valid instrumental variables based on the Mendelian randomization assumptions. The causal estimate of the IVW analysis expresses the causal increase in the outcome (or log odds of the outcome for a binary outcome) per unit change in the exposure. [**Weighted median MR**](https://doi.org/10.1002/gepi.21965) allows for 50% of the instrumental variables to be invalid. [**MR-Egger regression**](https://doi.org/10.1093/ije/dyw220) allows all the instrumental variables to be subject to direct effects (i.e. horizontal pleiotropy), with the intercept representing bias in the causal estimate due to pleiotropy and the slope representing the causal estimate. [**Weighted Mode**](https://doi.org/10.1093/ije/dyx102) gives consistent estimates as the sample size increases if a plurality (or weighted plurality) of the genetic variants are valid instruments.
<br>



Table 6 presents the MR causal estimates of genetically predicted LOAD on COVID: A2.
<br>

**Table 6** MR causaul estimates for LOAD on COVID: A2
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["nsnp"],"name":[6],"type":["int"],"align":["right"]},{"label":["b"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"WDB1ej","2":"lLtB5M","3":"covidhgi2020anaA2v4eurwoukbb","4":"Kunkle2019load","5":"Inverse variance weighted (fixed effects)","6":"21","7":"-0.1141964","8":"0.05304206","9":"0.03132337"},{"1":"WDB1ej","2":"lLtB5M","3":"covidhgi2020anaA2v4eurwoukbb","4":"Kunkle2019load","5":"Weighted median","6":"21","7":"-0.1301001","8":"0.07048910","9":"0.06493917"},{"1":"WDB1ej","2":"lLtB5M","3":"covidhgi2020anaA2v4eurwoukbb","4":"Kunkle2019load","5":"Weighted mode","6":"21","7":"-0.1285229","8":"0.07177023","9":"0.08848171"},{"1":"WDB1ej","2":"lLtB5M","3":"covidhgi2020anaA2v4eurwoukbb","4":"Kunkle2019load","5":"MR Egger","6":"21","7":"-0.1404468","8":"0.08815018","9":"0.12760039"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Figure 1 illustrates the SNP-specific associations with LOAD versus the association in COVID: A2 and the corresponding MR estimates.
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovideurwoukbb/Kunkle2019load/covidhgi2020anaA2v4eurwoukbb/Kunkle2019load_5e-8_covidhgi2020anaA2v4eurwoukbb_MR_Analaysis_files/figure-html/scatter_plot-1.png" alt="Fig. 1: Scatterplot of SNP effects for the association of the Exposure on the Outcome"  />
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
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["Q"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["Q_df"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["Q_pval"],"name":[8],"type":["dbl"],"align":["right"]}],"data":[{"1":"WDB1ej","2":"lLtB5M","3":"covidhgi2020anaA2v4eurwoukbb","4":"Kunkle2019load","5":"MR Egger","6":"26.71910","7":"19","8":"0.1113681"},{"1":"WDB1ej","2":"lLtB5M","3":"covidhgi2020anaA2v4eurwoukbb","4":"Kunkle2019load","5":"Inverse variance weighted","6":"26.97317","7":"20","8":"0.1360204"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Figure 2 shows a funnel plot displaying the MR estimates of individual genetic variants against their precession. Aysmmetry in the funnel plot may arrise due to some genetic variants having unusally strong effects on the outcome, which is indicative of directional pleiotropy.
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovideurwoukbb/Kunkle2019load/covidhgi2020anaA2v4eurwoukbb/Kunkle2019load_5e-8_covidhgi2020anaA2v4eurwoukbb_MR_Analaysis_files/figure-html/funnel_plot-1.png" alt="Fig. 2: Funnel plot of the MR causal estimates against their precession"  />
<p class="caption">Fig. 2: Funnel plot of the MR causal estimates against their precession</p>
</div>
<br>

Figure 3 shows a [Radial Plots](https://github.com/WSpiller/RadialMR) can be used to visualize influential data points with large contributions to Cochran's Q Statistic that may bias causal effect estimates.



<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovideurwoukbb/Kunkle2019load/covidhgi2020anaA2v4eurwoukbb/Kunkle2019load_5e-8_covidhgi2020anaA2v4eurwoukbb_MR_Analaysis_files/figure-html/Radial_Plot-1.png" alt="Fig. 4: Radial Plot showing influential data points using Radial IVW"  />
<p class="caption">Fig. 4: Radial Plot showing influential data points using Radial IVW</p>
</div>
<br>

The intercept of the MR-Regression model captures the average pleitropic affect across all genetic variants (Table 8).
<br>

**Table 8:** MR Egger test for directional pleitropy
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["egger_intercept"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[7],"type":["dbl"],"align":["right"]}],"data":[{"1":"WDB1ej","2":"lLtB5M","3":"covidhgi2020anaA2v4eurwoukbb","4":"Kunkle2019load","5":"0.008129346","6":"0.01912529","7":"0.6755698"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Pleiotropy was also assesed using Mendelian Randomization Pleiotropy RESidual Sum and Outlier [(MR-PRESSO)](https://doi.org/10.1038/s41588-018-0099-7), that allows for the evlation of evaluation of horizontal pleiotropy in a standared MR model (Table 9). MR-PRESSO performs a global test for detection of horizontal pleiotropy and correction of pleiotropy via outlier removal (Table 10).
<br>

**Table 9:** MR-PRESSO Global Test for pleitropy
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["pt"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["outliers_removed"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["n_outliers"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["RSSobs"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"WDB1ej","2":"lLtB5M","3":"covidhgi2020anaA2v4eurwoukbb","4":"Kunkle2019load","5":"5e-08","6":"FALSE","7":"0","8":"28.56509","9":"0.1861"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>


**Table 10:** MR Estimates after MR-PRESSO outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["fctr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["fctr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["nsnp"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["b"],"name":[7],"type":["lgl"],"align":["right"]},{"label":["se"],"name":[8],"type":["lgl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["lgl"],"align":["right"]}],"data":[{"1":"WDB1ej","2":"lLtB5M","3":"covidhgi2020anaA2v4eurwoukbb","4":"Kunkle2019load","5":"mrpresso","6":"NA","7":"NA","8":"NA","9":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovideurwoukbb/Kunkle2019load/covidhgi2020anaA2v4eurwoukbb/Kunkle2019load_5e-8_covidhgi2020anaA2v4eurwoukbb_MR_Analaysis_files/figure-html/scatter_plot_outlier-1.png" alt="Fig. 5: Scatterplot of SNP effects for the association of the Exposure on the Outcome after outlier removal"  />
<p class="caption">Fig. 5: Scatterplot of SNP effects for the association of the Exposure on the Outcome after outlier removal</p>
</div>
<br>

**Table 11:** Heterogenity Tests after outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["fctr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["fctr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["Q"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["Q_df"],"name":[7],"type":["lgl"],"align":["right"]},{"label":["Q_pval"],"name":[8],"type":["lgl"],"align":["right"]}],"data":[{"1":"WDB1ej","2":"lLtB5M","3":"covidhgi2020anaA2v4eurwoukbb","4":"Kunkle2019load","5":"mrpresso","6":"NA","7":"NA","8":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

**Table 12:** MR Egger test for directional pleitropy after outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["fctr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["fctr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["egger_intercept"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["se"],"name":[7],"type":["lgl"],"align":["right"]},{"label":["pval"],"name":[8],"type":["lgl"],"align":["right"]}],"data":[{"1":"WDB1ej","2":"lLtB5M","3":"covidhgi2020anaA2v4eurwoukbb","4":"Kunkle2019load","5":"mrpresso","6":"NA","7":"NA","8":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>