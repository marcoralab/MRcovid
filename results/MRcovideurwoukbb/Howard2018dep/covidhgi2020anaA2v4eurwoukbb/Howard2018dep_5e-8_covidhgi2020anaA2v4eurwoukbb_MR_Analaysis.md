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

### Exposure: Depression
`#r exposure.blurb`
<br>

**Table 1:** Independent SNPs associated with Depression
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["CHROM"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["REF"],"name":[4],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[5],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[12],"type":["chr"],"align":["left"]}],"data":[{"1":"rs10127497","2":"1","3":"67050144","4":"A","5":"T","6":"0.1382330","7":"0.0097175","8":"0.0017084","9":"5.688071","10":"1.287064e-08","11":"322580","12":"Depression"},{"1":"rs6699744","2":"1","3":"72825144","4":"A","5":"T","6":"0.6120220","7":"0.0089463","8":"0.0012130","9":"7.375350","10":"1.640590e-13","11":"322580","12":"Depression"},{"1":"rs7548151","2":"1","3":"177026983","4":"G","5":"A","6":"0.0836238","7":"0.0125070","8":"0.0021234","9":"5.890082","10":"3.868121e-09","11":"322580","12":"Depression"},{"1":"rs30266","2":"5","3":"103972357","4":"G","5":"A","6":"0.3286880","7":"0.0077850","8":"0.0012541","9":"6.207639","10":"5.381459e-10","11":"322580","12":"Depression"},{"1":"rs11961509","2":"6","3":"28989210","4":"A","5":"G","6":"0.0572851","7":"0.0142470","8":"0.0025342","9":"5.621893","10":"1.889296e-08","11":"322580","12":"Depression"},{"1":"rs3132685","2":"6","3":"29945949","4":"G","5":"A","6":"0.1302020","7":"-0.0130550","8":"0.0017833","9":"-7.320698","10":"2.471724e-13","11":"322580","12":"Depression"},{"1":"rs112348907","2":"6","3":"73587953","4":"A","5":"G","6":"0.2959040","7":"0.0073444","8":"0.0012977","9":"5.659552","10":"1.518099e-08","11":"322580","12":"Depression"},{"1":"rs3807865","2":"7","3":"12250402","4":"G","5":"A","6":"0.4117220","7":"0.0081747","8":"0.0011930","9":"6.852221","10":"7.277798e-12","11":"322580","12":"Depression"},{"1":"rs2402273","2":"7","3":"117600424","4":"T","5":"C","6":"0.4094360","7":"0.0072069","8":"0.0012008","9":"6.001749","10":"1.952540e-09","11":"322580","12":"Depression"},{"1":"rs263575","2":"9","3":"17033840","4":"G","5":"A","6":"0.4600810","7":"-0.0065899","8":"0.0011794","9":"-5.587502","10":"2.305685e-08","11":"322580","12":"Depression"},{"1":"rs1021363","2":"10","3":"106610839","4":"A","5":"G","6":"0.6422000","7":"-0.0070386","8":"0.0012298","9":"-5.723370","10":"1.043999e-08","11":"322580","12":"Depression"},{"1":"rs10501696","2":"11","3":"88748162","4":"A","5":"G","6":"0.4987210","7":"-0.0078805","8":"0.0012074","9":"-6.526835","10":"6.729767e-11","11":"322580","12":"Depression"},{"1":"rs9530139","2":"13","3":"31847324","4":"C","5":"T","6":"0.1954640","7":"-0.0088540","8":"0.0014872","9":"-5.953470","10":"2.629662e-09","11":"322580","12":"Depression"},{"1":"rs28541419","2":"15","3":"88945878","4":"C","5":"G","6":"0.2309700","7":"-0.0078206","8":"0.0014078","9":"-5.555192","10":"2.777154e-08","11":"322580","12":"Depression"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

### Outcome: COVID: A2
`#r outcome.blurb`
<br>

**Table 2:** SNPs associated with Depression avaliable in COVID: A2
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["CHROM"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["REF"],"name":[4],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[5],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[12],"type":["chr"],"align":["left"]}],"data":[{"1":"rs10127497","2":"1","3":"67050144","4":"A","5":"T","6":"0.14270","7":"0.0115420","8":"0.044319","9":"0.2604301","10":"0.79450","11":"261481","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs6699744","2":"1","3":"72825144","4":"A","5":"T","6":"0.65090","7":"0.0133290","8":"0.056580","9":"0.2355779","10":"0.81380","11":"10832","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs7548151","2":"1","3":"177026983","4":"G","5":"A","6":"0.09096","7":"-0.1247000","8":"0.052899","9":"-2.3573224","10":"0.01841","11":"261481","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs30266","2":"5","3":"103972357","4":"G","5":"A","6":"0.29230","7":"-0.0185380","8":"0.033570","9":"-0.5522192","10":"0.58080","11":"261078","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs11961509","2":"6","3":"28989210","4":"A","5":"G","6":"0.04035","7":"0.0867430","8":"0.062293","9":"1.3925000","10":"0.16380","11":"261481","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs3132685","2":"6","3":"29945949","4":"G","5":"A","6":"0.07576","7":"-0.2037200","8":"0.109800","9":"-1.8553734","10":"0.06353","11":"251425","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs112348907","2":"6","3":"73587953","4":"A","5":"G","6":"0.34180","7":"0.0680480","8":"0.050660","9":"1.3432294","10":"0.17920","11":"251425","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs3807865","2":"7","3":"12250402","4":"G","5":"A","6":"0.36660","7":"-0.0116920","8":"0.031604","9":"-0.3699532","10":"0.71140","11":"261481","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs2402273","2":"7","3":"117600424","4":"T","5":"C","6":"0.51870","7":"-0.0343900","8":"0.048119","9":"-0.7146865","10":"0.47480","11":"251425","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs263575","2":"9","3":"17033840","4":"G","5":"A","6":"0.43260","7":"0.0016272","8":"0.031222","9":"0.0521171","10":"0.95840","11":"261481","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs1021363","2":"10","3":"106610839","4":"A","5":"G","6":"0.71950","7":"0.0101620","8":"0.033391","9":"0.3043335","10":"0.76090","11":"261481","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs10501696","2":"11","3":"88748162","4":"A","5":"G","6":"0.42690","7":"0.0588210","8":"0.047582","9":"1.2362028","10":"0.21640","11":"251425","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs9530139","2":"13","3":"31847324","4":"C","5":"T","6":"0.27250","7":"0.0796700","8":"0.059388","9":"1.3415168","10":"0.17980","11":"251425","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"},{"1":"rs28541419","2":"15","3":"88945878","4":"C","5":"G","6":"0.16830","7":"0.0995580","8":"0.056898","9":"1.7497627","10":"0.08016","11":"251425","12":"very_severe_respiratory_confirmed_covid_vs._population__eur_wo_ukbb"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
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

**Table 4:** Harmonized Depression and COVID: A2 datasets
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["effect_allele.exposure"],"name":[2],"type":["chr"],"align":["left"]},{"label":["other_allele.exposure"],"name":[3],"type":["chr"],"align":["left"]},{"label":["effect_allele.outcome"],"name":[4],"type":["chr"],"align":["left"]},{"label":["other_allele.outcome"],"name":[5],"type":["chr"],"align":["left"]},{"label":["beta.exposure"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["beta.outcome"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["eaf.exposure"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["eaf.outcome"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["remove"],"name":[10],"type":["lgl"],"align":["right"]},{"label":["palindromic"],"name":[11],"type":["lgl"],"align":["right"]},{"label":["ambiguous"],"name":[12],"type":["lgl"],"align":["right"]},{"label":["id.outcome"],"name":[13],"type":["chr"],"align":["left"]},{"label":["chr.outcome"],"name":[14],"type":["dbl"],"align":["right"]},{"label":["pos.outcome"],"name":[15],"type":["dbl"],"align":["right"]},{"label":["se.outcome"],"name":[16],"type":["dbl"],"align":["right"]},{"label":["z.outcome"],"name":[17],"type":["dbl"],"align":["right"]},{"label":["pval.outcome"],"name":[18],"type":["dbl"],"align":["right"]},{"label":["samplesize.outcome"],"name":[19],"type":["dbl"],"align":["right"]},{"label":["outcome"],"name":[20],"type":["chr"],"align":["left"]},{"label":["mr_keep.outcome"],"name":[21],"type":["lgl"],"align":["right"]},{"label":["pval_origin.outcome"],"name":[22],"type":["chr"],"align":["left"]},{"label":["chr.exposure"],"name":[23],"type":["dbl"],"align":["right"]},{"label":["pos.exposure"],"name":[24],"type":["dbl"],"align":["right"]},{"label":["se.exposure"],"name":[25],"type":["dbl"],"align":["right"]},{"label":["z.exposure"],"name":[26],"type":["dbl"],"align":["right"]},{"label":["pval.exposure"],"name":[27],"type":["dbl"],"align":["right"]},{"label":["samplesize.exposure"],"name":[28],"type":["dbl"],"align":["right"]},{"label":["exposure"],"name":[29],"type":["chr"],"align":["left"]},{"label":["mr_keep.exposure"],"name":[30],"type":["lgl"],"align":["right"]},{"label":["pval_origin.exposure"],"name":[31],"type":["chr"],"align":["left"]},{"label":["id.exposure"],"name":[32],"type":["chr"],"align":["left"]},{"label":["action"],"name":[33],"type":["dbl"],"align":["right"]},{"label":["mr_keep"],"name":[34],"type":["lgl"],"align":["right"]},{"label":["pt"],"name":[35],"type":["dbl"],"align":["right"]},{"label":["pleitropy_keep"],"name":[36],"type":["lgl"],"align":["right"]},{"label":["mrpresso_RSSobs"],"name":[37],"type":["lgl"],"align":["right"]},{"label":["mrpresso_pval"],"name":[38],"type":["lgl"],"align":["right"]},{"label":["mrpresso_keep"],"name":[39],"type":["lgl"],"align":["right"]}],"data":[{"1":"rs10127497","2":"T","3":"A","4":"T","5":"A","6":"0.0097175","7":"0.0115420","8":"0.1382330","9":"0.14270","10":"FALSE","11":"TRUE","12":"FALSE","13":"IrGlKL","14":"1","15":"67050144","16":"0.044319","17":"0.2604301","18":"0.79450","19":"261481","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"1","24":"67050144","25":"0.0017084","26":"5.688071","27":"1.287064e-08","28":"322580","29":"Howard2018dep","30":"TRUE","31":"reported","32":"FJSZ9x","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs1021363","2":"G","3":"A","4":"G","5":"A","6":"-0.0070386","7":"0.0101620","8":"0.6422000","9":"0.71950","10":"FALSE","11":"FALSE","12":"FALSE","13":"IrGlKL","14":"10","15":"106610839","16":"0.033391","17":"0.3043335","18":"0.76090","19":"261481","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"10","24":"106610839","25":"0.0012298","26":"-5.723370","27":"1.043999e-08","28":"322580","29":"Howard2018dep","30":"TRUE","31":"reported","32":"FJSZ9x","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs10501696","2":"G","3":"A","4":"G","5":"A","6":"-0.0078805","7":"0.0588210","8":"0.4987210","9":"0.42690","10":"FALSE","11":"FALSE","12":"FALSE","13":"IrGlKL","14":"11","15":"88748162","16":"0.047582","17":"1.2362028","18":"0.21640","19":"251425","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"11","24":"88748162","25":"0.0012074","26":"-6.526835","27":"6.729767e-11","28":"322580","29":"Howard2018dep","30":"TRUE","31":"reported","32":"FJSZ9x","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs112348907","2":"G","3":"A","4":"G","5":"A","6":"0.0073444","7":"0.0680480","8":"0.2959040","9":"0.34180","10":"FALSE","11":"FALSE","12":"FALSE","13":"IrGlKL","14":"6","15":"73587953","16":"0.050660","17":"1.3432294","18":"0.17920","19":"251425","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"6","24":"73587953","25":"0.0012977","26":"5.659552","27":"1.518099e-08","28":"322580","29":"Howard2018dep","30":"TRUE","31":"reported","32":"FJSZ9x","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs11961509","2":"G","3":"A","4":"G","5":"A","6":"0.0142470","7":"0.0867430","8":"0.0572851","9":"0.04035","10":"FALSE","11":"FALSE","12":"FALSE","13":"IrGlKL","14":"6","15":"28989210","16":"0.062293","17":"1.3925000","18":"0.16380","19":"261481","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"6","24":"28989210","25":"0.0025342","26":"5.621893","27":"1.889296e-08","28":"322580","29":"Howard2018dep","30":"TRUE","31":"reported","32":"FJSZ9x","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs2402273","2":"C","3":"T","4":"C","5":"T","6":"0.0072069","7":"-0.0343900","8":"0.4094360","9":"0.51870","10":"FALSE","11":"FALSE","12":"FALSE","13":"IrGlKL","14":"7","15":"117600424","16":"0.048119","17":"-0.7146865","18":"0.47480","19":"251425","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"7","24":"117600424","25":"0.0012008","26":"6.001749","27":"1.952540e-09","28":"322580","29":"Howard2018dep","30":"TRUE","31":"reported","32":"FJSZ9x","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs263575","2":"A","3":"G","4":"A","5":"G","6":"-0.0065899","7":"0.0016272","8":"0.4600810","9":"0.43260","10":"FALSE","11":"FALSE","12":"FALSE","13":"IrGlKL","14":"9","15":"17033840","16":"0.031222","17":"0.0521171","18":"0.95840","19":"261481","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"9","24":"17033840","25":"0.0011794","26":"-5.587502","27":"2.305685e-08","28":"322580","29":"Howard2018dep","30":"TRUE","31":"reported","32":"FJSZ9x","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs28541419","2":"G","3":"C","4":"G","5":"C","6":"-0.0078206","7":"0.0995580","8":"0.2309700","9":"0.16830","10":"FALSE","11":"TRUE","12":"FALSE","13":"IrGlKL","14":"15","15":"88945878","16":"0.056898","17":"1.7497627","18":"0.08016","19":"251425","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"15","24":"88945878","25":"0.0014078","26":"-5.555192","27":"2.777154e-08","28":"322580","29":"Howard2018dep","30":"TRUE","31":"reported","32":"FJSZ9x","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs30266","2":"A","3":"G","4":"A","5":"G","6":"0.0077850","7":"-0.0185380","8":"0.3286880","9":"0.29230","10":"FALSE","11":"FALSE","12":"FALSE","13":"IrGlKL","14":"5","15":"103972357","16":"0.033570","17":"-0.5522192","18":"0.58080","19":"261078","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"5","24":"103972357","25":"0.0012541","26":"6.207639","27":"5.381459e-10","28":"322580","29":"Howard2018dep","30":"TRUE","31":"reported","32":"FJSZ9x","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs3132685","2":"A","3":"G","4":"A","5":"G","6":"-0.0130550","7":"-0.2037200","8":"0.1302020","9":"0.07576","10":"FALSE","11":"FALSE","12":"FALSE","13":"IrGlKL","14":"6","15":"29945949","16":"0.109800","17":"-1.8553734","18":"0.06353","19":"251425","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"6","24":"29945949","25":"0.0017833","26":"-7.320698","27":"2.471724e-13","28":"322580","29":"Howard2018dep","30":"TRUE","31":"reported","32":"FJSZ9x","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs3807865","2":"A","3":"G","4":"A","5":"G","6":"0.0081747","7":"-0.0116920","8":"0.4117220","9":"0.36660","10":"FALSE","11":"FALSE","12":"FALSE","13":"IrGlKL","14":"7","15":"12250402","16":"0.031604","17":"-0.3699532","18":"0.71140","19":"261481","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"7","24":"12250402","25":"0.0011930","26":"6.852221","27":"7.277798e-12","28":"322580","29":"Howard2018dep","30":"TRUE","31":"reported","32":"FJSZ9x","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs6699744","2":"T","3":"A","4":"T","5":"A","6":"0.0089463","7":"0.0133290","8":"0.6120220","9":"0.65090","10":"FALSE","11":"TRUE","12":"FALSE","13":"IrGlKL","14":"1","15":"72825144","16":"0.056580","17":"0.2355779","18":"0.81380","19":"10832","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"1","24":"72825144","25":"0.0012130","26":"7.375350","27":"1.640590e-13","28":"322580","29":"Howard2018dep","30":"TRUE","31":"reported","32":"FJSZ9x","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs7548151","2":"A","3":"G","4":"A","5":"G","6":"0.0125070","7":"-0.1247000","8":"0.0836238","9":"0.09096","10":"FALSE","11":"FALSE","12":"FALSE","13":"IrGlKL","14":"1","15":"177026983","16":"0.052899","17":"-2.3573224","18":"0.01841","19":"261481","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"1","24":"177026983","25":"0.0021234","26":"5.890082","27":"3.868121e-09","28":"322580","29":"Howard2018dep","30":"TRUE","31":"reported","32":"FJSZ9x","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs9530139","2":"T","3":"C","4":"T","5":"C","6":"-0.0088540","7":"0.0796700","8":"0.1954640","9":"0.27250","10":"FALSE","11":"FALSE","12":"FALSE","13":"IrGlKL","14":"13","15":"31847324","16":"0.059388","17":"1.3415168","18":"0.17980","19":"251425","20":"covidhgi2020anaA2v4eurwoukbb","21":"TRUE","22":"reported","23":"13","24":"31847324","25":"0.0014872","26":"-5.953470","27":"2.629662e-09","28":"322580","29":"Howard2018dep","30":"TRUE","31":"reported","32":"FJSZ9x","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
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
{"columns":[{"label":["outliers_removed"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["pve.exposure"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["F"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["Alpha"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["NCP"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["Power"],"name":[6],"type":["dbl"],"align":["right"]}],"data":[{"1":"FALSE","2":"0.001650927","3":"38.10084","4":"0.05","5":"1.571204","6":"0.2405984"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

##  MR Results
To obtain an overall estimate of causal effect, the SNP-exposure and SNP-outcome coefficients were combined in 1) a fixed-effects meta-analysis using an inverse-variance weighted approach (IVW); 2) a Weighted Median approach; 3) Weighted Mode approach and 4) Egger Regression.


[**IVW**](https://doi.org/10.1002/gepi.21758) is equivalent to a weighted regression of the SNP-outcome coefficients on the SNP-exposure coefficients with the intercept constrained to zero. This method assumes that all variants are valid instrumental variables based on the Mendelian randomization assumptions. The causal estimate of the IVW analysis expresses the causal increase in the outcome (or log odds of the outcome for a binary outcome) per unit change in the exposure. [**Weighted median MR**](https://doi.org/10.1002/gepi.21965) allows for 50% of the instrumental variables to be invalid. [**MR-Egger regression**](https://doi.org/10.1093/ije/dyw220) allows all the instrumental variables to be subject to direct effects (i.e. horizontal pleiotropy), with the intercept representing bias in the causal estimate due to pleiotropy and the slope representing the causal estimate. [**Weighted Mode**](https://doi.org/10.1093/ije/dyx102) gives consistent estimates as the sample size increases if a plurality (or weighted plurality) of the genetic variants are valid instruments.
<br>



Table 6 presents the MR causal estimates of genetically predicted Depression on COVID: A2.
<br>

**Table 6** MR causaul estimates for Depression on COVID: A2
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["nsnp"],"name":[6],"type":["int"],"align":["right"]},{"label":["b"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"FJSZ9x","2":"IrGlKL","3":"covidhgi2020anaA2v4eurwoukbb","4":"Howard2018dep","5":"Inverse variance weighted (fixed effects)","6":"14","7":"-1.509172","8":"1.390650","9":"0.2778208"},{"1":"FJSZ9x","2":"IrGlKL","3":"covidhgi2020anaA2v4eurwoukbb","4":"Howard2018dep","5":"Weighted median","6":"14","7":"-1.434254","8":"2.060444","9":"0.4863726"},{"1":"FJSZ9x","2":"IrGlKL","3":"covidhgi2020anaA2v4eurwoukbb","4":"Howard2018dep","5":"Weighted mode","6":"14","7":"-1.079894","8":"2.911031","9":"0.7166378"},{"1":"FJSZ9x","2":"IrGlKL","3":"covidhgi2020anaA2v4eurwoukbb","4":"Howard2018dep","5":"MR Egger","6":"14","7":"2.607590","8":"8.014953","9":"0.7505258"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Figure 1 illustrates the SNP-specific associations with Depression versus the association in COVID: A2 and the corresponding MR estimates.
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovideurwoukbb/Howard2018dep/covidhgi2020anaA2v4eurwoukbb/Howard2018dep_5e-8_covidhgi2020anaA2v4eurwoukbb_MR_Analaysis_files/figure-html/scatter_plot-1.png" alt="Fig. 1: Scatterplot of SNP effects for the association of the Exposure on the Outcome"  />
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
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["Q"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["Q_df"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["Q_pval"],"name":[8],"type":["dbl"],"align":["right"]}],"data":[{"1":"FJSZ9x","2":"IrGlKL","3":"covidhgi2020anaA2v4eurwoukbb","4":"Howard2018dep","5":"MR Egger","6":"18.69453","7":"12","8":"0.09617172"},{"1":"FJSZ9x","2":"IrGlKL","3":"covidhgi2020anaA2v4eurwoukbb","4":"Howard2018dep","5":"Inverse variance weighted","6":"19.12576","7":"13","8":"0.11925577"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Figure 2 shows a funnel plot displaying the MR estimates of individual genetic variants against their precession. Aysmmetry in the funnel plot may arrise due to some genetic variants having unusally strong effects on the outcome, which is indicative of directional pleiotropy.
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovideurwoukbb/Howard2018dep/covidhgi2020anaA2v4eurwoukbb/Howard2018dep_5e-8_covidhgi2020anaA2v4eurwoukbb_MR_Analaysis_files/figure-html/funnel_plot-1.png" alt="Fig. 2: Funnel plot of the MR causal estimates against their precession"  />
<p class="caption">Fig. 2: Funnel plot of the MR causal estimates against their precession</p>
</div>
<br>

Figure 3 shows a [Radial Plots](https://github.com/WSpiller/RadialMR) can be used to visualize influential data points with large contributions to Cochran's Q Statistic that may bias causal effect estimates.




```
## [1] "No significant Outliers"
```

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovideurwoukbb/Howard2018dep/covidhgi2020anaA2v4eurwoukbb/Howard2018dep_5e-8_covidhgi2020anaA2v4eurwoukbb_MR_Analaysis_files/figure-html/Radial_Plot-1.png" alt="Fig. 4: Radial Plot showing influential data points using Radial IVW"  />
<p class="caption">Fig. 4: Radial Plot showing influential data points using Radial IVW</p>
</div>
<br>

The intercept of the MR-Regression model captures the average pleitropic affect across all genetic variants (Table 8).
<br>

**Table 8:** MR Egger test for directional pleitropy
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["egger_intercept"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[7],"type":["dbl"],"align":["right"]}],"data":[{"1":"FJSZ9x","2":"IrGlKL","3":"covidhgi2020anaA2v4eurwoukbb","4":"Howard2018dep","5":"-0.03576944","6":"0.06798714","7":"0.6083909"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Pleiotropy was also assesed using Mendelian Randomization Pleiotropy RESidual Sum and Outlier [(MR-PRESSO)](https://doi.org/10.1038/s41588-018-0099-7), that allows for the evlation of evaluation of horizontal pleiotropy in a standared MR model (Table 9). MR-PRESSO performs a global test for detection of horizontal pleiotropy and correction of pleiotropy via outlier removal (Table 10).
<br>

**Table 9:** MR-PRESSO Global Test for pleitropy
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["pt"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["outliers_removed"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["n_outliers"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["RSSobs"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"FJSZ9x","2":"IrGlKL","3":"covidhgi2020anaA2v4eurwoukbb","4":"Howard2018dep","5":"5e-08","6":"FALSE","7":"0","8":"21.8753","9":"0.1349"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>


**Table 10:** MR Estimates after MR-PRESSO outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["fctr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["fctr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["nsnp"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["b"],"name":[7],"type":["lgl"],"align":["right"]},{"label":["se"],"name":[8],"type":["lgl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["lgl"],"align":["right"]}],"data":[{"1":"FJSZ9x","2":"IrGlKL","3":"covidhgi2020anaA2v4eurwoukbb","4":"Howard2018dep","5":"mrpresso","6":"NA","7":"NA","8":"NA","9":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovideurwoukbb/Howard2018dep/covidhgi2020anaA2v4eurwoukbb/Howard2018dep_5e-8_covidhgi2020anaA2v4eurwoukbb_MR_Analaysis_files/figure-html/scatter_plot_outlier-1.png" alt="Fig. 5: Scatterplot of SNP effects for the association of the Exposure on the Outcome after outlier removal"  />
<p class="caption">Fig. 5: Scatterplot of SNP effects for the association of the Exposure on the Outcome after outlier removal</p>
</div>
<br>

**Table 11:** Heterogenity Tests after outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["fctr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["fctr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["Q"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["Q_df"],"name":[7],"type":["lgl"],"align":["right"]},{"label":["Q_pval"],"name":[8],"type":["lgl"],"align":["right"]}],"data":[{"1":"FJSZ9x","2":"IrGlKL","3":"covidhgi2020anaA2v4eurwoukbb","4":"Howard2018dep","5":"mrpresso","6":"NA","7":"NA","8":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

**Table 12:** MR Egger test for directional pleitropy after outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["fctr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["fctr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["egger_intercept"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["se"],"name":[7],"type":["lgl"],"align":["right"]},{"label":["pval"],"name":[8],"type":["lgl"],"align":["right"]}],"data":[{"1":"FJSZ9x","2":"IrGlKL","3":"covidhgi2020anaA2v4eurwoukbb","4":"Howard2018dep","5":"mrpresso","6":"NA","7":"NA","8":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>