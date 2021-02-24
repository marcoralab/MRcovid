---
title: "Mendelian Randomization Analysis"
author: "Dr. Shea Andrews"
date: "2021-02-17"
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

### Outcome: COVID: C2
`#r outcome.blurb`
<br>

**Table 2:** SNPs associated with Depression avaliable in COVID: C2
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["CHROM"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["REF"],"name":[4],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[5],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[12],"type":["chr"],"align":["left"]}],"data":[{"1":"rs10127497","2":"1","3":"67050144","4":"A","5":"T","6":"0.15080","7":"0.02620700","8":"0.0114010","9":"2.29865801","10":"0.02152","11":"1683769","12":"COVID_C2__EUR"},{"1":"rs7548151","2":"1","3":"177026983","4":"G","5":"A","6":"0.09371","7":"-0.02919100","8":"0.0139210","9":"-2.09690396","10":"0.03600","11":"1678150","12":"COVID_C2__EUR"},{"1":"rs30266","2":"5","3":"103972357","4":"G","5":"A","6":"0.31660","7":"-0.01602900","8":"0.0087577","9":"-1.83027507","10":"0.06720","11":"1673985","12":"COVID_C2__EUR"},{"1":"rs11961509","2":"6","3":"28989210","4":"A","5":"G","6":"0.05649","7":"0.02530500","8":"0.0169410","9":"1.49371348","10":"0.13530","11":"1683769","12":"COVID_C2__EUR"},{"1":"rs3132685","2":"6","3":"29945949","4":"G","5":"A","6":"0.10960","7":"-0.02046000","8":"0.0140650","9":"-1.45467472","10":"0.14570","11":"1478258","12":"COVID_C2__EUR"},{"1":"rs112348907","2":"6","3":"73587953","4":"A","5":"G","6":"0.30310","7":"-0.00290330","8":"0.0090415","9":"-0.32110822","10":"0.74810","11":"1673354","12":"COVID_C2__EUR"},{"1":"rs3807865","2":"7","3":"12250402","4":"G","5":"A","6":"0.39830","7":"-0.01032000","8":"0.0083283","9":"-1.23914845","10":"0.21530","11":"1674649","12":"COVID_C2__EUR"},{"1":"rs2402273","2":"7","3":"117600424","4":"T","5":"C","6":"0.45170","7":"-0.01161700","8":"0.0084861","9":"-1.36894451","10":"0.17100","11":"1664234","12":"COVID_C2__EUR"},{"1":"rs263575","2":"9","3":"17033840","4":"G","5":"A","6":"0.45930","7":"0.01688100","8":"0.0080668","9":"2.09265136","10":"0.03637","11":"1683769","12":"COVID_C2__EUR"},{"1":"rs1021363","2":"10","3":"106610839","4":"A","5":"G","6":"0.65810","7":"0.00039499","8":"0.0086127","9":"0.04586134","10":"0.96340","11":"1674649","12":"COVID_C2__EUR"},{"1":"rs10501696","2":"11","3":"88748162","4":"A","5":"G","6":"0.48340","7":"0.00863820","8":"0.0085411","9":"1.01136856","10":"0.31180","11":"1592927","12":"COVID_C2__EUR"},{"1":"rs9530139","2":"13","3":"31847324","4":"C","5":"T","6":"0.20950","7":"-0.00091816","8":"0.0104430","9":"-0.08792110","10":"0.92990","11":"1602598","12":"COVID_C2__EUR"},{"1":"rs28541419","2":"15","3":"88945878","4":"C","5":"G","6":"0.22310","7":"0.02597500","8":"0.0101880","9":"2.54956812","10":"0.01078","11":"1592564","12":"COVID_C2__EUR"},{"1":"rs6699744","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

**Table 3:** Proxy SNPs for COVID: C2
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["target_snp"],"name":[1],"type":["chr"],"align":["left"]},{"label":["proxy_snp"],"name":[2],"type":["chr"],"align":["left"]},{"label":["ld.r2"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["Dprime"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["PHASE"],"name":[5],"type":["chr"],"align":["left"]},{"label":["X12"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["CHROM"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["REF.proxy"],"name":[9],"type":["lgl"],"align":["right"]},{"label":["ALT.proxy"],"name":[10],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[12],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[13],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[14],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[15],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[16],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[17],"type":["chr"],"align":["left"]},{"label":["ref"],"name":[18],"type":["chr"],"align":["left"]},{"label":["ref.proxy"],"name":[19],"type":["lgl"],"align":["right"]},{"label":["alt"],"name":[20],"type":["lgl"],"align":["right"]},{"label":["alt.proxy"],"name":[21],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[22],"type":["lgl"],"align":["right"]},{"label":["REF"],"name":[23],"type":["chr"],"align":["left"]},{"label":["proxy.outcome"],"name":[24],"type":["lgl"],"align":["right"]}],"data":[{"1":"rs6699744","2":"rs2012697","3":"1","4":"1","5":"AT/TC","6":"NA","7":"1","8":"72819612","9":"TRUE","10":"C","11":"0.6079","12":"-0.0005433","13":"0.010035","14":"-0.05414051","15":"0.9568","16":"1579000","17":"COVID_C2__EUR","18":"A","19":"TRUE","20":"TRUE","21":"C","22":"TRUE","23":"A","24":"TRUE"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

## Data harmonization
Harmonize the exposure and outcome datasets so that the effect of a SNP on the exposure and the effect of that SNP on the outcome correspond to the same allele. The harmonise_data function from the TwoSampleMR package can be used to perform the harmonization step, by default it try's to infer the forward strand alleles using allele frequency information.
<br>

**Table 4:** Harmonized Depression and COVID: C2 datasets
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["effect_allele.exposure"],"name":[2],"type":["chr"],"align":["left"]},{"label":["other_allele.exposure"],"name":[3],"type":["chr"],"align":["left"]},{"label":["effect_allele.outcome"],"name":[4],"type":["chr"],"align":["left"]},{"label":["other_allele.outcome"],"name":[5],"type":["chr"],"align":["left"]},{"label":["beta.exposure"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["beta.outcome"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["eaf.exposure"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["eaf.outcome"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["remove"],"name":[10],"type":["lgl"],"align":["right"]},{"label":["palindromic"],"name":[11],"type":["lgl"],"align":["right"]},{"label":["ambiguous"],"name":[12],"type":["lgl"],"align":["right"]},{"label":["id.outcome"],"name":[13],"type":["chr"],"align":["left"]},{"label":["chr.outcome"],"name":[14],"type":["dbl"],"align":["right"]},{"label":["pos.outcome"],"name":[15],"type":["dbl"],"align":["right"]},{"label":["se.outcome"],"name":[16],"type":["dbl"],"align":["right"]},{"label":["z.outcome"],"name":[17],"type":["dbl"],"align":["right"]},{"label":["pval.outcome"],"name":[18],"type":["dbl"],"align":["right"]},{"label":["samplesize.outcome"],"name":[19],"type":["dbl"],"align":["right"]},{"label":["outcome"],"name":[20],"type":["chr"],"align":["left"]},{"label":["mr_keep.outcome"],"name":[21],"type":["lgl"],"align":["right"]},{"label":["pval_origin.outcome"],"name":[22],"type":["chr"],"align":["left"]},{"label":["chr.exposure"],"name":[23],"type":["dbl"],"align":["right"]},{"label":["pos.exposure"],"name":[24],"type":["dbl"],"align":["right"]},{"label":["se.exposure"],"name":[25],"type":["dbl"],"align":["right"]},{"label":["z.exposure"],"name":[26],"type":["dbl"],"align":["right"]},{"label":["pval.exposure"],"name":[27],"type":["dbl"],"align":["right"]},{"label":["samplesize.exposure"],"name":[28],"type":["dbl"],"align":["right"]},{"label":["exposure"],"name":[29],"type":["chr"],"align":["left"]},{"label":["mr_keep.exposure"],"name":[30],"type":["lgl"],"align":["right"]},{"label":["pval_origin.exposure"],"name":[31],"type":["chr"],"align":["left"]},{"label":["id.exposure"],"name":[32],"type":["chr"],"align":["left"]},{"label":["action"],"name":[33],"type":["dbl"],"align":["right"]},{"label":["mr_keep"],"name":[34],"type":["lgl"],"align":["right"]},{"label":["pt"],"name":[35],"type":["dbl"],"align":["right"]},{"label":["pleitropy_keep"],"name":[36],"type":["lgl"],"align":["right"]},{"label":["mrpresso_RSSobs"],"name":[37],"type":["dbl"],"align":["right"]},{"label":["mrpresso_pval"],"name":[38],"type":["dbl"],"align":["right"]},{"label":["mrpresso_keep"],"name":[39],"type":["lgl"],"align":["right"]}],"data":[{"1":"rs10127497","2":"T","3":"A","4":"T","5":"A","6":"0.0097175","7":"0.02620700","8":"0.1382330","9":"0.15080","10":"FALSE","11":"TRUE","12":"FALSE","13":"4N0VDv","14":"1","15":"67050144","16":"0.0114010","17":"2.29865801","18":"0.02152","19":"1683769","20":"covidhgi2020C2v5alleur","21":"TRUE","22":"reported","23":"1","24":"67050144","25":"0.0017084","26":"5.688071","27":"1.287064e-08","28":"322580","29":"Howard2018dep","30":"TRUE","31":"reported","32":"SGaAr8","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"1.176045e-03","38":"0.0336","39":"FALSE"},{"1":"rs1021363","2":"G","3":"A","4":"G","5":"A","6":"-0.0070386","7":"0.00039499","8":"0.6422000","9":"0.65810","10":"FALSE","11":"FALSE","12":"FALSE","13":"4N0VDv","14":"10","15":"106610839","16":"0.0086127","17":"0.04586134","18":"0.96340","19":"1674649","20":"covidhgi2020C2v5alleur","21":"TRUE","22":"reported","23":"10","24":"106610839","25":"0.0012298","26":"-5.723370","27":"1.043999e-08","28":"322580","29":"Howard2018dep","30":"TRUE","31":"reported","32":"SGaAr8","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"1.601500e-05","38":"1.0000","39":"TRUE"},{"1":"rs10501696","2":"G","3":"A","4":"G","5":"A","6":"-0.0078805","7":"0.00863820","8":"0.4987210","9":"0.48340","10":"FALSE","11":"FALSE","12":"FALSE","13":"4N0VDv","14":"11","15":"88748162","16":"0.0085411","17":"1.01136856","18":"0.31180","19":"1592927","20":"covidhgi2020C2v5alleur","21":"TRUE","22":"reported","23":"11","24":"88748162","25":"0.0012074","26":"-6.526835","27":"6.729767e-11","28":"322580","29":"Howard2018dep","30":"TRUE","31":"reported","32":"SGaAr8","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"1.893654e-05","38":"1.0000","39":"TRUE"},{"1":"rs112348907","2":"G","3":"A","4":"G","5":"A","6":"0.0073444","7":"-0.00290330","8":"0.2959040","9":"0.30310","10":"FALSE","11":"FALSE","12":"FALSE","13":"4N0VDv","14":"6","15":"73587953","16":"0.0090415","17":"-0.32110822","18":"0.74810","19":"1673354","20":"covidhgi2020C2v5alleur","21":"TRUE","22":"reported","23":"6","24":"73587953","25":"0.0012977","26":"5.659552","27":"1.518099e-08","28":"322580","29":"Howard2018dep","30":"TRUE","31":"reported","32":"SGaAr8","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"2.293994e-06","38":"1.0000","39":"TRUE"},{"1":"rs11961509","2":"G","3":"A","4":"G","5":"A","6":"0.0142470","7":"0.02530500","8":"0.0572851","9":"0.05649","10":"FALSE","11":"FALSE","12":"FALSE","13":"4N0VDv","14":"6","15":"28989210","16":"0.0169410","17":"1.49371348","18":"0.13530","19":"1683769","20":"covidhgi2020C2v5alleur","21":"TRUE","22":"reported","23":"6","24":"28989210","25":"0.0025342","26":"5.621893","27":"1.889296e-08","28":"322580","29":"Howard2018dep","30":"TRUE","31":"reported","32":"SGaAr8","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"1.304472e-03","38":"0.4970","39":"TRUE"},{"1":"rs2402273","2":"C","3":"T","4":"C","5":"T","6":"0.0072069","7":"-0.01161700","8":"0.4094360","9":"0.45170","10":"FALSE","11":"FALSE","12":"FALSE","13":"4N0VDv","14":"7","15":"117600424","16":"0.0084861","17":"-1.36894451","18":"0.17100","19":"1664234","20":"covidhgi2020C2v5alleur","21":"TRUE","22":"reported","23":"7","24":"117600424","25":"0.0012008","26":"6.001749","27":"1.952540e-09","28":"322580","29":"Howard2018dep","30":"TRUE","31":"reported","32":"SGaAr8","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"6.268607e-05","38":"1.0000","39":"TRUE"},{"1":"rs263575","2":"A","3":"G","4":"A","5":"G","6":"-0.0065899","7":"0.01688100","8":"0.4600810","9":"0.45930","10":"FALSE","11":"FALSE","12":"FALSE","13":"4N0VDv","14":"9","15":"17033840","16":"0.0080668","17":"2.09265136","18":"0.03637","19":"1683769","20":"covidhgi2020C2v5alleur","21":"TRUE","22":"reported","23":"9","24":"17033840","25":"0.0011794","26":"-5.587502","27":"2.305685e-08","28":"322580","29":"Howard2018dep","30":"TRUE","31":"reported","32":"SGaAr8","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"1.927166e-04","38":"1.0000","39":"TRUE"},{"1":"rs28541419","2":"G","3":"C","4":"G","5":"C","6":"-0.0078206","7":"0.02597500","8":"0.2309700","9":"0.22310","10":"FALSE","11":"TRUE","12":"FALSE","13":"4N0VDv","14":"15","15":"88945878","16":"0.0101880","17":"2.54956812","18":"0.01078","19":"1592564","20":"covidhgi2020C2v5alleur","21":"TRUE","22":"reported","23":"15","24":"88945878","25":"0.0014078","26":"-5.555192","27":"2.777154e-08","28":"322580","29":"Howard2018dep","30":"TRUE","31":"reported","32":"SGaAr8","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"5.125259e-04","38":"0.3598","39":"TRUE"},{"1":"rs30266","2":"A","3":"G","4":"A","5":"G","6":"0.0077850","7":"-0.01602900","8":"0.3286880","9":"0.31660","10":"FALSE","11":"FALSE","12":"FALSE","13":"4N0VDv","14":"5","15":"103972357","16":"0.0087577","17":"-1.83027507","18":"0.06720","19":"1673985","20":"covidhgi2020C2v5alleur","21":"TRUE","22":"reported","23":"5","24":"103972357","25":"0.0012541","26":"6.207639","27":"5.381459e-10","28":"322580","29":"Howard2018dep","30":"TRUE","31":"reported","32":"SGaAr8","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"1.531584e-04","38":"1.0000","39":"TRUE"},{"1":"rs3132685","2":"A","3":"G","4":"A","5":"G","6":"-0.0130550","7":"-0.02046000","8":"0.1302020","9":"0.10960","10":"FALSE","11":"FALSE","12":"FALSE","13":"4N0VDv","14":"6","15":"29945949","16":"0.0140650","17":"-1.45467472","18":"0.14570","19":"1478258","20":"covidhgi2020C2v5alleur","21":"TRUE","22":"reported","23":"6","24":"29945949","25":"0.0017833","26":"-7.320698","27":"2.471724e-13","28":"322580","29":"Howard2018dep","30":"TRUE","31":"reported","32":"SGaAr8","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"9.396076e-04","38":"0.4158","39":"TRUE"},{"1":"rs3807865","2":"A","3":"G","4":"A","5":"G","6":"0.0081747","7":"-0.01032000","8":"0.4117220","9":"0.39830","10":"FALSE","11":"FALSE","12":"FALSE","13":"4N0VDv","14":"7","15":"12250402","16":"0.0083283","17":"-1.23914845","18":"0.21530","19":"1674649","20":"covidhgi2020C2v5alleur","21":"TRUE","22":"reported","23":"7","24":"12250402","25":"0.0011930","26":"6.852221","27":"7.277798e-12","28":"322580","29":"Howard2018dep","30":"TRUE","31":"reported","32":"SGaAr8","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"3.676328e-05","38":"1.0000","39":"TRUE"},{"1":"rs6699744","2":"T","3":"A","4":"T","5":"A","6":"0.0089463","7":"-0.00054330","8":"0.6120220","9":"0.60790","10":"FALSE","11":"TRUE","12":"FALSE","13":"4N0VDv","14":"1","15":"72819612","16":"0.0100350","17":"-0.05414051","18":"0.95680","19":"1579000","20":"covidhgi2020C2v5alleur","21":"TRUE","22":"reported","23":"1","24":"72825144","25":"0.0012130","26":"7.375350","27":"1.640590e-13","28":"322580","29":"Howard2018dep","30":"TRUE","31":"reported","32":"SGaAr8","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"2.609402e-05","38":"1.0000","39":"TRUE"},{"1":"rs7548151","2":"A","3":"G","4":"A","5":"G","6":"0.0125070","7":"-0.02919100","8":"0.0836238","9":"0.09371","10":"FALSE","11":"FALSE","12":"FALSE","13":"4N0VDv","14":"1","15":"177026983","16":"0.0139210","17":"-2.09690396","18":"0.03600","19":"1678150","20":"covidhgi2020C2v5alleur","21":"TRUE","22":"reported","23":"1","24":"177026983","25":"0.0021234","26":"5.890082","27":"3.868121e-09","28":"322580","29":"Howard2018dep","30":"TRUE","31":"reported","32":"SGaAr8","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"5.589527e-04","38":"1.0000","39":"TRUE"},{"1":"rs9530139","2":"T","3":"C","4":"T","5":"C","6":"-0.0088540","7":"-0.00091816","8":"0.1954640","9":"0.20950","10":"FALSE","11":"FALSE","12":"FALSE","13":"4N0VDv","14":"13","15":"31847324","16":"0.0104430","17":"-0.08792110","18":"0.92990","19":"1602598","20":"covidhgi2020C2v5alleur","21":"TRUE","22":"reported","23":"13","24":"31847324","25":"0.0014872","26":"-5.953470","27":"2.629662e-09","28":"322580","29":"Howard2018dep","30":"TRUE","31":"reported","32":"SGaAr8","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"4.328238e-05","38":"1.0000","39":"TRUE"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
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
{"columns":[{"label":["outliers_removed"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["pve.exposure"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["F"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["Alpha"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["NCP"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["Power"],"name":[6],"type":["dbl"],"align":["right"]}],"data":[{"1":"FALSE","2":"0.001650927","3":"38.10084","4":"0.05","5":"3.804655","6":"0.4962914"},{"1":"TRUE","2":"0.001551117","3":"38.54729","4":"0.05","5":"6.438613","6":"0.7181953"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

The I2_GX statistic can be used to quantify the strength of the NOME violation for MR-Egger regression and should be used to evalute potential bias in the MR-Egger causal estimate, with values less then 90% indicating that causal estimated should interpreted with caution due to regression diluation.

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["outliers_removed"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["Isq_gx"],"name":[2],"type":["dbl"],"align":["right"]}],"data":[{"1":"FALSE","2":"0"},{"1":"TRUE","2":"0"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>


## MR Results
To obtain an overall estimate of causal effect, the SNP-exposure and SNP-outcome coefficients were combined in 1) a fixed-effects meta-analysis using an inverse-variance weighted approach (IVW); 2) a Weighted Median approach; 3) Weighted Mode approach and 4) Egger Regression.


[**IVW**](https://doi.org/10.1002/gepi.21758) is equivalent to a weighted regression of the SNP-outcome coefficients on the SNP-exposure coefficients with the intercept constrained to zero. This method assumes that all variants are valid instrumental variables based on the Mendelian randomization assumptions. The causal estimate of the IVW analysis expresses the causal increase in the outcome (or log odds of the outcome for a binary outcome) per unit change in the exposure. [**Weighted median MR**](https://doi.org/10.1002/gepi.21965) allows for 50% of the instrumental variables to be invalid. [**MR-Egger regression**](https://doi.org/10.1093/ije/dyw220) allows all the instrumental variables to be subject to direct effects (i.e. horizontal pleiotropy), with the intercept representing bias in the causal estimate due to pleiotropy and the slope representing the causal estimate. [**Weighted Mode**](https://doi.org/10.1093/ije/dyx102) gives consistent estimates as the sample size increases if a plurality (or weighted plurality) of the genetic variants are valid instruments.
<br>



Table 6 presents the MR causal estimates of genetically predicted Depression on COVID: C2.
<br>

**Table 6** MR causaul estimates for Depression on COVID: C2
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["method"],"name":[5],"type":["chr"],"align":["left"]},{"label":["nsnp"],"name":[6],"type":["int"],"align":["right"]},{"label":["b"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"SGaAr8","2":"4N0VDv","3":"covidhgi2020C2v5alleur","4":"Howard2018dep","5":"Inverse variance weighted (fixed effects)","6":"14","7":"-0.5886056","8":"0.3082172","9":"0.05617052"},{"1":"SGaAr8","2":"4N0VDv","3":"covidhgi2020C2v5alleur","4":"Howard2018dep","5":"Weighted median","6":"14","7":"-0.7106776","8":"0.4717547","9":"0.13195025"},{"1":"SGaAr8","2":"4N0VDv","3":"covidhgi2020C2v5alleur","4":"Howard2018dep","5":"Weighted mode","6":"14","7":"-1.0441646","8":"0.8183453","9":"0.22430114"},{"1":"SGaAr8","2":"4N0VDv","3":"covidhgi2020C2v5alleur","4":"Howard2018dep","5":"MR Egger","6":"14","7":"3.5810066","8":"1.9599056","9":"0.09264107"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Figure 1 illustrates the SNP-specific associations with Depression versus the association in COVID: C2 and the corresponding MR estimates.
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovideur/Howard2018dep/covidhgi2020C2v5alleur/Howard2018dep_5e-8_covidhgi2020C2v5alleur_MR_Analaysis_files/figure-html/scatter_plot-1.png" alt="Fig. 1: Scatterplot of SNP effects for the association of the Exposure on the Outcome"  />
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
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["method"],"name":[5],"type":["chr"],"align":["left"]},{"label":["Q"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["Q_df"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["Q_pval"],"name":[8],"type":["dbl"],"align":["right"]}],"data":[{"1":"SGaAr8","2":"4N0VDv","3":"covidhgi2020C2v5alleur","4":"Howard2018dep","5":"MR Egger","6":"20.91488","7":"12","8":"0.051640919"},{"1":"SGaAr8","2":"4N0VDv","3":"covidhgi2020C2v5alleur","4":"Howard2018dep","5":"Inverse variance weighted","6":"29.15873","7":"13","8":"0.006214793"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Figure 2 shows a funnel plot displaying the MR estimates of individual genetic variants against their precession. Aysmmetry in the funnel plot may arrise due to some genetic variants having unusally strong effects on the outcome, which is indicative of directional pleiotropy.
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovideur/Howard2018dep/covidhgi2020C2v5alleur/Howard2018dep_5e-8_covidhgi2020C2v5alleur_MR_Analaysis_files/figure-html/funnel_plot-1.png" alt="Fig. 2: Funnel plot of the MR causal estimates against their precession"  />
<p class="caption">Fig. 2: Funnel plot of the MR causal estimates against their precession</p>
</div>
<br>

Figure 3 shows a [Radial Plots](https://github.com/WSpiller/RadialMR) can be used to visualize influential data points with large contributions to Cochran's Q Statistic that may bias causal effect estimates.




```
## [1] "No significant Outliers"
```

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovideur/Howard2018dep/covidhgi2020C2v5alleur/Howard2018dep_5e-8_covidhgi2020C2v5alleur_MR_Analaysis_files/figure-html/Radial_Plot-1.png" alt="Fig. 4: Radial Plot showing influential data points using Radial IVW"  />
<p class="caption">Fig. 4: Radial Plot showing influential data points using Radial IVW</p>
</div>
<br>

The intercept of the MR-Egger Regression model captures the average pleitropic affect across all genetic variants (Table 8).
<br>

**Table 8:** MR Egger test for directional pleitropy
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["egger_intercept"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[7],"type":["dbl"],"align":["right"]}],"data":[{"1":"SGaAr8","2":"4N0VDv","3":"covidhgi2020C2v5alleur","4":"Howard2018dep","5":"-0.03616154","6":"0.01662719","7":"0.05035649"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Pleiotropy was also assesed using Mendelian Randomization Pleiotropy RESidual Sum and Outlier [(MR-PRESSO)](https://doi.org/10.1038/s41588-018-0099-7), that allows for the evlation of evaluation of horizontal pleiotropy in a standared MR model (Table 9). MR-PRESSO performs a global test for detection of horizontal pleiotropy and correction of pleiotropy via outlier removal (Table 10).
<br>

**Table 9:** MR-PRESSO Global Test for pleitropy
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["pt"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["outliers_removed"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["n_outliers"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["RSSobs"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"SGaAr8","2":"4N0VDv","3":"covidhgi2020C2v5alleur","4":"Howard2018dep","5":"5e-08","6":"FALSE","7":"1","8":"33.68325","9":"0.0077"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>


**Table 10:** MR Estimates after MR-PRESSO outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["method"],"name":[5],"type":["chr"],"align":["left"]},{"label":["nsnp"],"name":[6],"type":["int"],"align":["right"]},{"label":["b"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"SGaAr8","2":"4N0VDv","3":"covidhgi2020C2v5alleur","4":"Howard2018dep","5":"Inverse variance weighted (fixed effects)","6":"13","7":"-0.8321591","8":"0.3194371","9":"0.009185283"},{"1":"SGaAr8","2":"4N0VDv","3":"covidhgi2020C2v5alleur","4":"Howard2018dep","5":"Weighted median","6":"13","7":"-1.0046038","8":"0.4841106","9":"0.037972317"},{"1":"SGaAr8","2":"4N0VDv","3":"covidhgi2020C2v5alleur","4":"Howard2018dep","5":"Weighted mode","6":"13","7":"-1.0389675","8":"0.8433281","9":"0.241550107"},{"1":"SGaAr8","2":"4N0VDv","3":"covidhgi2020C2v5alleur","4":"Howard2018dep","5":"MR Egger","6":"13","7":"2.8548424","8":"1.7367135","9":"0.128461580"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovideur/Howard2018dep/covidhgi2020C2v5alleur/Howard2018dep_5e-8_covidhgi2020C2v5alleur_MR_Analaysis_files/figure-html/scatter_plot_outlier-1.png" alt="Fig. 5: Scatterplot of SNP effects for the association of the Exposure on the Outcome after outlier removal"  />
<p class="caption">Fig. 5: Scatterplot of SNP effects for the association of the Exposure on the Outcome after outlier removal</p>
</div>
<br>

**Table 11:** Heterogenity Tests after outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["method"],"name":[5],"type":["chr"],"align":["left"]},{"label":["Q"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["Q_df"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["Q_pval"],"name":[8],"type":["dbl"],"align":["right"]}],"data":[{"1":"SGaAr8","2":"4N0VDv","3":"covidhgi2020C2v5alleur","4":"Howard2018dep","5":"MR Egger","6":"14.51178","7":"11","8":"0.20595627"},{"1":"SGaAr8","2":"4N0VDv","3":"covidhgi2020C2v5alleur","4":"Howard2018dep","5":"Inverse variance weighted","6":"20.73546","7":"12","8":"0.05439108"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

**Table 12:** MR Egger test for directional pleitropy after outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["egger_intercept"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[7],"type":["dbl"],"align":["right"]}],"data":[{"1":"SGaAr8","2":"4N0VDv","3":"covidhgi2020C2v5alleur","4":"Howard2018dep","5":"-0.03172317","6":"0.01460552","7":"0.05259355"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>
