---
title: "Mendelian Randomization Analysis"
author: "Dr. Shea Andrews"
date: "2021-02-19"
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

### Exposure: Moderate-Vigours Physical Activity
`#r exposure.blurb`
<br>

**Table 1:** Independent SNPs associated with Moderate-Vigours Physical Activity
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["CHROM"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["REF"],"name":[4],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[5],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[12],"type":["chr"],"align":["left"]}],"data":[{"1":"rs2942127","2":"1","3":"204420067","4":"G","5":"A","6":"0.824644","7":"-0.0160370","8":"0.00290278","9":"-5.52470","10":"3.3e-08","11":"377234","12":"MVPA"},{"1":"rs1974771","2":"2","3":"54278543","4":"G","5":"A","6":"0.099975","7":"0.0213389","8":"0.00367836","9":"5.80120","10":"6.6e-09","11":"377234","12":"MVPA"},{"1":"rs2114286","2":"3","3":"41194283","4":"A","5":"G","6":"0.534243","7":"0.0122453","8":"0.00221725","9":"5.52274","10":"3.3e-08","11":"377234","12":"MVPA"},{"1":"rs877483","2":"3","3":"53846741","4":"T","5":"C","6":"0.566815","7":"-0.0122277","8":"0.00222756","9":"-5.48928","10":"4.0e-08","11":"377234","12":"MVPA"},{"1":"rs2035562","2":"3","3":"85056521","4":"A","5":"G","6":"0.672483","7":"0.0138763","8":"0.00235606","9":"5.88962","10":"3.9e-09","11":"377234","12":"MVPA"},{"1":"rs181220614","2":"3","3":"153806914","4":"C","5":"G","6":"0.009415","7":"0.0668260","8":"0.01189990","9":"5.61568","10":"2.0e-08","11":"377234","12":"MVPA"},{"1":"rs1972763","2":"4","3":"159860563","4":"C","5":"T","6":"0.657628","7":"-0.0128383","8":"0.00232366","9":"-5.52503","10":"3.3e-08","11":"377234","12":"MVPA"},{"1":"rs77742115","2":"5","3":"18330424","4":"T","5":"C","6":"0.138319","7":"0.0183480","8":"0.00319777","9":"5.73775","10":"9.6e-09","11":"377234","12":"MVPA"},{"1":"rs2854277","2":"6","3":"32628084","4":"C","5":"T","6":"0.082571","7":"-0.0320288","8":"0.00506676","9":"-6.32136","10":"2.6e-10","11":"377234","12":"MVPA"},{"1":"rs17075350","2":"6","3":"114014536","4":"G","5":"A","6":"0.015163","7":"0.0507131","8":"0.00900921","9":"5.62903","10":"1.8e-08","11":"377234","12":"MVPA"},{"1":"rs1186721","2":"7","3":"34974602","4":"G","5":"A","6":"0.315844","7":"0.0129900","8":"0.00237226","9":"5.47579","10":"4.4e-08","11":"377234","12":"MVPA"},{"1":"rs921915","2":"7","3":"50228581","4":"T","5":"C","6":"0.587905","7":"0.0138882","8":"0.00224013","9":"6.19973","10":"5.7e-10","11":"377234","12":"MVPA"},{"1":"rs1043595","2":"7","3":"128410012","4":"G","5":"A","6":"0.282865","7":"-0.0144110","8":"0.00245416","9":"-5.87207","10":"4.3e-09","11":"377234","12":"MVPA"},{"1":"rs7804463","2":"7","3":"133447651","4":"T","5":"C","6":"0.470424","7":"-0.0150095","8":"0.00221333","9":"-6.78141","10":"1.2e-11","11":"377234","12":"MVPA"},{"1":"rs2988004","2":"9","3":"37044388","4":"T","5":"G","6":"0.442245","7":"0.0131708","8":"0.00223979","9":"5.88037","10":"4.1e-09","11":"377234","12":"MVPA"},{"1":"rs7326482","2":"13","3":"54037803","4":"G","5":"T","6":"0.615163","7":"0.0129605","8":"0.00229416","9":"5.64934","10":"1.6e-08","11":"377234","12":"MVPA"},{"1":"rs10145335","2":"14","3":"98547748","4":"G","5":"A","6":"0.250611","7":"0.0141221","8":"0.00254139","9":"5.55684","10":"2.7e-08","11":"377234","12":"MVPA"},{"1":"rs4886868","2":"15","3":"74353561","4":"T","5":"G","6":"0.585862","7":"0.0124954","8":"0.00226611","9":"5.51403","10":"3.5e-08","11":"377234","12":"MVPA"},{"1":"rs12912808","2":"15","3":"95292223","4":"C","5":"T","6":"0.148607","7":"-0.0175460","8":"0.00310889","9":"-5.64381","10":"1.7e-08","11":"377234","12":"MVPA"},{"1":"rs429358","2":"19","3":"45411941","4":"T","5":"C","6":"0.154172","7":"0.0219822","8":"0.00305356","9":"7.19888","10":"6.1e-13","11":"377234","12":"MVPA"},{"1":"rs1921981","2":"21","3":"42422547","4":"G","5":"A","6":"0.325647","7":"-0.0130370","8":"0.00237139","9":"-5.49762","10":"3.8e-08","11":"377234","12":"MVPA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

### Outcome: COVID: B2
`#r outcome.blurb`
<br>

**Table 2:** SNPs associated with Moderate-Vigours Physical Activity avaliable in COVID: B2
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["CHROM"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["REF"],"name":[4],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[5],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[12],"type":["chr"],"align":["left"]}],"data":[{"1":"rs2942127","2":"1","3":"204420067","4":"G","5":"A","6":"0.797600","7":"0.0223900","8":"0.028499","9":"0.78564160","10":"0.43210","11":"1547355","12":"COVID_B2__EUR_w/o_UKBB"},{"1":"rs1974771","2":"2","3":"54278543","4":"G","5":"A","6":"0.116300","7":"0.0254880","8":"0.032925","9":"0.77412301","10":"0.43890","11":"1557411","12":"COVID_B2__EUR_w/o_UKBB"},{"1":"rs2114286","2":"3","3":"41194283","4":"A","5":"G","6":"0.556000","7":"-0.0257420","8":"0.024789","9":"-1.03844447","10":"0.29910","11":"1544118","12":"COVID_B2__EUR_w/o_UKBB"},{"1":"rs877483","2":"3","3":"53846741","4":"T","5":"C","6":"0.569500","7":"0.0160090","8":"0.020439","9":"0.78325750","10":"0.43350","11":"1557411","12":"COVID_B2__EUR_w/o_UKBB"},{"1":"rs2035562","2":"3","3":"85056521","4":"A","5":"G","6":"0.648300","7":"0.0208510","8":"0.024602","9":"0.84753272","10":"0.39670","11":"1547355","12":"COVID_B2__EUR_w/o_UKBB"},{"1":"rs181220614","2":"3","3":"153806914","4":"C","5":"G","6":"0.009272","7":"-0.0135410","8":"0.141510","9":"-0.09568935","10":"0.92380","11":"1538108","12":"COVID_B2__EUR_w/o_UKBB"},{"1":"rs1972763","2":"4","3":"159860563","4":"C","5":"T","6":"0.671400","7":"-0.0091059","8":"0.021869","9":"-0.41638392","10":"0.67710","11":"1554174","12":"COVID_B2__EUR_w/o_UKBB"},{"1":"rs77742115","2":"5","3":"18330424","4":"T","5":"C","6":"0.151300","7":"-0.0483330","8":"0.029325","9":"-1.64818414","10":"0.09932","11":"1557411","12":"COVID_B2__EUR_w/o_UKBB"},{"1":"rs17075350","2":"6","3":"114014536","4":"G","5":"A","6":"0.014550","7":"0.1576300","8":"0.106250","9":"1.48357647","10":"0.13790","11":"1526546","12":"COVID_B2__EUR_w/o_UKBB"},{"1":"rs1186721","2":"7","3":"34974602","4":"G","5":"A","6":"0.302100","7":"0.0021120","8":"0.026207","9":"0.08058916","10":"0.93580","11":"1544126","12":"COVID_B2__EUR_w/o_UKBB"},{"1":"rs921915","2":"7","3":"50228581","4":"T","5":"C","6":"0.579500","7":"-0.0060671","8":"0.020399","9":"-0.29742144","10":"0.76610","11":"1557411","12":"COVID_B2__EUR_w/o_UKBB"},{"1":"rs1043595","2":"7","3":"128410012","4":"G","5":"A","6":"0.256700","7":"0.0282730","8":"0.026234","9":"1.07772356","10":"0.28120","11":"1546121","12":"COVID_B2__EUR_w/o_UKBB"},{"1":"rs7804463","2":"7","3":"133447651","4":"T","5":"C","6":"0.448300","7":"-0.0067397","8":"0.023974","9":"-0.28112539","10":"0.77860","11":"1544739","12":"COVID_B2__EUR_w/o_UKBB"},{"1":"rs2988004","2":"9","3":"37044388","4":"T","5":"G","6":"0.420800","7":"-0.0233310","8":"0.024620","9":"-0.94764419","10":"0.34330","11":"1544118","12":"COVID_B2__EUR_w/o_UKBB"},{"1":"rs7326482","2":"13","3":"54037803","4":"G","5":"T","6":"0.597600","7":"-0.0313420","8":"0.024426","9":"-1.28314092","10":"0.19940","11":"1544739","12":"COVID_B2__EUR_w/o_UKBB"},{"1":"rs10145335","2":"14","3":"98547748","4":"G","5":"A","6":"0.243500","7":"-0.0046030","8":"0.023672","9":"-0.19444914","10":"0.84580","11":"1556790","12":"COVID_B2__EUR_w/o_UKBB"},{"1":"rs4886868","2":"15","3":"74353561","4":"T","5":"G","6":"0.558700","7":"0.0077278","8":"0.025373","9":"0.30456785","10":"0.76070","11":"1269707","12":"COVID_B2__EUR_w/o_UKBB"},{"1":"rs12912808","2":"15","3":"95292223","4":"C","5":"T","6":"0.157000","7":"-0.0022431","8":"0.027671","9":"-0.08106321","10":"0.93540","11":"1557411","12":"COVID_B2__EUR_w/o_UKBB"},{"1":"rs429358","2":"19","3":"45411941","4":"T","5":"C","6":"0.143700","7":"0.0144150","8":"0.030042","9":"0.47982824","10":"0.63130","11":"1283000","12":"COVID_B2__EUR_w/o_UKBB"},{"1":"rs1921981","2":"21","3":"42422547","4":"G","5":"A","6":"0.312600","7":"-0.0063620","8":"0.026504","9":"-0.24003924","10":"0.81030","11":"1544118","12":"COVID_B2__EUR_w/o_UKBB"},{"1":"rs2854277","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

**Table 3:** Proxy SNPs for COVID: B2
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["target_snp"],"name":[1],"type":["chr"],"align":["left"]},{"label":["proxy_snp"],"name":[2],"type":["chr"],"align":["left"]},{"label":["ld.r2"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["Dprime"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["PHASE"],"name":[5],"type":["chr"],"align":["left"]},{"label":["X12"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["CHROM"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["REF.proxy"],"name":[9],"type":["lgl"],"align":["right"]},{"label":["ALT.proxy"],"name":[10],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[12],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[13],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[14],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[15],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[16],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[17],"type":["chr"],"align":["left"]},{"label":["ref"],"name":[18],"type":["lgl"],"align":["right"]},{"label":["ref.proxy"],"name":[19],"type":["chr"],"align":["left"]},{"label":["alt"],"name":[20],"type":["chr"],"align":["left"]},{"label":["alt.proxy"],"name":[21],"type":["lgl"],"align":["right"]},{"label":["ALT"],"name":[22],"type":["lgl"],"align":["right"]},{"label":["REF"],"name":[23],"type":["chr"],"align":["left"]},{"label":["proxy.outcome"],"name":[24],"type":["lgl"],"align":["right"]}],"data":[{"1":"rs2854277","2":"rs9273369","3":"0.850886","4":"1","5":"TC/CT","6":"NA","7":"6","8":"32626484","9":"TRUE","10":"C","11":"0.1107","12":"-0.011994","13":"0.04093","14":"-0.2930369","15":"0.7695","16":"1543793","17":"COVID_B2__EUR_w/o_UKBB","18":"TRUE","19":"C","20":"C","21":"TRUE","22":"TRUE","23":"C","24":"TRUE"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

## Data harmonization
Harmonize the exposure and outcome datasets so that the effect of a SNP on the exposure and the effect of that SNP on the outcome correspond to the same allele. The harmonise_data function from the TwoSampleMR package can be used to perform the harmonization step, by default it try's to infer the forward strand alleles using allele frequency information.
<br>

**Table 4:** Harmonized Moderate-Vigours Physical Activity and COVID: B2 datasets
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["effect_allele.exposure"],"name":[2],"type":["chr"],"align":["left"]},{"label":["other_allele.exposure"],"name":[3],"type":["chr"],"align":["left"]},{"label":["effect_allele.outcome"],"name":[4],"type":["chr"],"align":["left"]},{"label":["other_allele.outcome"],"name":[5],"type":["chr"],"align":["left"]},{"label":["beta.exposure"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["beta.outcome"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["eaf.exposure"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["eaf.outcome"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["remove"],"name":[10],"type":["lgl"],"align":["right"]},{"label":["palindromic"],"name":[11],"type":["lgl"],"align":["right"]},{"label":["ambiguous"],"name":[12],"type":["lgl"],"align":["right"]},{"label":["id.outcome"],"name":[13],"type":["chr"],"align":["left"]},{"label":["chr.outcome"],"name":[14],"type":["dbl"],"align":["right"]},{"label":["pos.outcome"],"name":[15],"type":["dbl"],"align":["right"]},{"label":["se.outcome"],"name":[16],"type":["dbl"],"align":["right"]},{"label":["z.outcome"],"name":[17],"type":["dbl"],"align":["right"]},{"label":["pval.outcome"],"name":[18],"type":["dbl"],"align":["right"]},{"label":["samplesize.outcome"],"name":[19],"type":["dbl"],"align":["right"]},{"label":["outcome"],"name":[20],"type":["chr"],"align":["left"]},{"label":["mr_keep.outcome"],"name":[21],"type":["lgl"],"align":["right"]},{"label":["pval_origin.outcome"],"name":[22],"type":["chr"],"align":["left"]},{"label":["chr.exposure"],"name":[23],"type":["dbl"],"align":["right"]},{"label":["pos.exposure"],"name":[24],"type":["dbl"],"align":["right"]},{"label":["se.exposure"],"name":[25],"type":["dbl"],"align":["right"]},{"label":["z.exposure"],"name":[26],"type":["dbl"],"align":["right"]},{"label":["pval.exposure"],"name":[27],"type":["dbl"],"align":["right"]},{"label":["samplesize.exposure"],"name":[28],"type":["dbl"],"align":["right"]},{"label":["exposure"],"name":[29],"type":["chr"],"align":["left"]},{"label":["mr_keep.exposure"],"name":[30],"type":["lgl"],"align":["right"]},{"label":["pval_origin.exposure"],"name":[31],"type":["chr"],"align":["left"]},{"label":["id.exposure"],"name":[32],"type":["chr"],"align":["left"]},{"label":["action"],"name":[33],"type":["dbl"],"align":["right"]},{"label":["mr_keep"],"name":[34],"type":["lgl"],"align":["right"]},{"label":["pt"],"name":[35],"type":["dbl"],"align":["right"]},{"label":["pleitropy_keep"],"name":[36],"type":["lgl"],"align":["right"]},{"label":["mrpresso_RSSobs"],"name":[37],"type":["lgl"],"align":["right"]},{"label":["mrpresso_pval"],"name":[38],"type":["lgl"],"align":["right"]},{"label":["mrpresso_keep"],"name":[39],"type":["lgl"],"align":["right"]}],"data":[{"1":"rs10145335","2":"A","3":"G","4":"A","5":"G","6":"0.0141221","7":"-0.0046030","8":"0.250611","9":"0.243500","10":"FALSE","11":"FALSE","12":"FALSE","13":"CiIaVA","14":"14","15":"98547748","16":"0.023672","17":"-0.19444914","18":"0.84580","19":"1556790","20":"covidhgi2020B2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"14","24":"98547748","25":"0.00254139","26":"5.55684","27":"2.7e-08","28":"377234","29":"Klimentidis2018mvpa","30":"TRUE","31":"reported","32":"LXdDVl","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs1043595","2":"A","3":"G","4":"A","5":"G","6":"-0.0144110","7":"0.0282730","8":"0.282865","9":"0.256700","10":"FALSE","11":"FALSE","12":"FALSE","13":"CiIaVA","14":"7","15":"128410012","16":"0.026234","17":"1.07772356","18":"0.28120","19":"1546121","20":"covidhgi2020B2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"7","24":"128410012","25":"0.00245416","26":"-5.87207","27":"4.3e-09","28":"377234","29":"Klimentidis2018mvpa","30":"TRUE","31":"reported","32":"LXdDVl","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs1186721","2":"A","3":"G","4":"A","5":"G","6":"0.0129900","7":"0.0021120","8":"0.315844","9":"0.302100","10":"FALSE","11":"FALSE","12":"FALSE","13":"CiIaVA","14":"7","15":"34974602","16":"0.026207","17":"0.08058916","18":"0.93580","19":"1544126","20":"covidhgi2020B2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"7","24":"34974602","25":"0.00237226","26":"5.47579","27":"4.4e-08","28":"377234","29":"Klimentidis2018mvpa","30":"TRUE","31":"reported","32":"LXdDVl","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs12912808","2":"T","3":"C","4":"T","5":"C","6":"-0.0175460","7":"-0.0022431","8":"0.148607","9":"0.157000","10":"FALSE","11":"FALSE","12":"FALSE","13":"CiIaVA","14":"15","15":"95292223","16":"0.027671","17":"-0.08106321","18":"0.93540","19":"1557411","20":"covidhgi2020B2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"15","24":"95292223","25":"0.00310889","26":"-5.64381","27":"1.7e-08","28":"377234","29":"Klimentidis2018mvpa","30":"TRUE","31":"reported","32":"LXdDVl","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs17075350","2":"A","3":"G","4":"A","5":"G","6":"0.0507131","7":"0.1576300","8":"0.015163","9":"0.014550","10":"FALSE","11":"FALSE","12":"FALSE","13":"CiIaVA","14":"6","15":"114014536","16":"0.106250","17":"1.48357647","18":"0.13790","19":"1526546","20":"covidhgi2020B2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"6","24":"114014536","25":"0.00900921","26":"5.62903","27":"1.8e-08","28":"377234","29":"Klimentidis2018mvpa","30":"TRUE","31":"reported","32":"LXdDVl","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs181220614","2":"G","3":"C","4":"G","5":"C","6":"0.0668260","7":"-0.0135410","8":"0.009415","9":"0.009272","10":"FALSE","11":"TRUE","12":"FALSE","13":"CiIaVA","14":"3","15":"153806914","16":"0.141510","17":"-0.09568935","18":"0.92380","19":"1538108","20":"covidhgi2020B2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"3","24":"153806914","25":"0.01189990","26":"5.61568","27":"2.0e-08","28":"377234","29":"Klimentidis2018mvpa","30":"TRUE","31":"reported","32":"LXdDVl","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs1921981","2":"A","3":"G","4":"A","5":"G","6":"-0.0130370","7":"-0.0063620","8":"0.325647","9":"0.312600","10":"FALSE","11":"FALSE","12":"FALSE","13":"CiIaVA","14":"21","15":"42422547","16":"0.026504","17":"-0.24003924","18":"0.81030","19":"1544118","20":"covidhgi2020B2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"21","24":"42422547","25":"0.00237139","26":"-5.49762","27":"3.8e-08","28":"377234","29":"Klimentidis2018mvpa","30":"TRUE","31":"reported","32":"LXdDVl","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs1972763","2":"T","3":"C","4":"T","5":"C","6":"-0.0128383","7":"-0.0091059","8":"0.657628","9":"0.671400","10":"FALSE","11":"FALSE","12":"FALSE","13":"CiIaVA","14":"4","15":"159860563","16":"0.021869","17":"-0.41638392","18":"0.67710","19":"1554174","20":"covidhgi2020B2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"4","24":"159860563","25":"0.00232366","26":"-5.52503","27":"3.3e-08","28":"377234","29":"Klimentidis2018mvpa","30":"TRUE","31":"reported","32":"LXdDVl","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs1974771","2":"A","3":"G","4":"A","5":"G","6":"0.0213389","7":"0.0254880","8":"0.099975","9":"0.116300","10":"FALSE","11":"FALSE","12":"FALSE","13":"CiIaVA","14":"2","15":"54278543","16":"0.032925","17":"0.77412301","18":"0.43890","19":"1557411","20":"covidhgi2020B2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"2","24":"54278543","25":"0.00367836","26":"5.80120","27":"6.6e-09","28":"377234","29":"Klimentidis2018mvpa","30":"TRUE","31":"reported","32":"LXdDVl","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs2035562","2":"G","3":"A","4":"G","5":"A","6":"0.0138763","7":"0.0208510","8":"0.672483","9":"0.648300","10":"FALSE","11":"FALSE","12":"FALSE","13":"CiIaVA","14":"3","15":"85056521","16":"0.024602","17":"0.84753272","18":"0.39670","19":"1547355","20":"covidhgi2020B2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"3","24":"85056521","25":"0.00235606","26":"5.88962","27":"3.9e-09","28":"377234","29":"Klimentidis2018mvpa","30":"TRUE","31":"reported","32":"LXdDVl","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs2114286","2":"G","3":"A","4":"G","5":"A","6":"0.0122453","7":"-0.0257420","8":"0.534243","9":"0.556000","10":"FALSE","11":"FALSE","12":"FALSE","13":"CiIaVA","14":"3","15":"41194283","16":"0.024789","17":"-1.03844447","18":"0.29910","19":"1544118","20":"covidhgi2020B2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"3","24":"41194283","25":"0.00221725","26":"5.52274","27":"3.3e-08","28":"377234","29":"Klimentidis2018mvpa","30":"TRUE","31":"reported","32":"LXdDVl","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs2854277","2":"T","3":"C","4":"T","5":"C","6":"-0.0320288","7":"-0.0119940","8":"0.082571","9":"0.110700","10":"FALSE","11":"FALSE","12":"FALSE","13":"CiIaVA","14":"6","15":"32626484","16":"0.040930","17":"-0.29303689","18":"0.76950","19":"1543793","20":"covidhgi2020B2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"6","24":"32628084","25":"0.00506676","26":"-6.32136","27":"2.6e-10","28":"377234","29":"Klimentidis2018mvpa","30":"TRUE","31":"reported","32":"LXdDVl","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs2942127","2":"A","3":"G","4":"A","5":"G","6":"-0.0160370","7":"0.0223900","8":"0.824644","9":"0.797600","10":"FALSE","11":"FALSE","12":"FALSE","13":"CiIaVA","14":"1","15":"204420067","16":"0.028499","17":"0.78564160","18":"0.43210","19":"1547355","20":"covidhgi2020B2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"1","24":"204420067","25":"0.00290278","26":"-5.52470","27":"3.3e-08","28":"377234","29":"Klimentidis2018mvpa","30":"TRUE","31":"reported","32":"LXdDVl","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs2988004","2":"G","3":"T","4":"G","5":"T","6":"0.0131708","7":"-0.0233310","8":"0.442245","9":"0.420800","10":"FALSE","11":"FALSE","12":"FALSE","13":"CiIaVA","14":"9","15":"37044388","16":"0.024620","17":"-0.94764419","18":"0.34330","19":"1544118","20":"covidhgi2020B2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"9","24":"37044388","25":"0.00223979","26":"5.88037","27":"4.1e-09","28":"377234","29":"Klimentidis2018mvpa","30":"TRUE","31":"reported","32":"LXdDVl","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs429358","2":"C","3":"T","4":"C","5":"T","6":"0.0219822","7":"0.0144150","8":"0.154172","9":"0.143700","10":"FALSE","11":"FALSE","12":"FALSE","13":"CiIaVA","14":"19","15":"45411941","16":"0.030042","17":"0.47982824","18":"0.63130","19":"1283000","20":"covidhgi2020B2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"19","24":"45411941","25":"0.00305356","26":"7.19888","27":"6.1e-13","28":"377234","29":"Klimentidis2018mvpa","30":"TRUE","31":"reported","32":"LXdDVl","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs4886868","2":"G","3":"T","4":"G","5":"T","6":"0.0124954","7":"0.0077278","8":"0.585862","9":"0.558700","10":"FALSE","11":"FALSE","12":"FALSE","13":"CiIaVA","14":"15","15":"74353561","16":"0.025373","17":"0.30456785","18":"0.76070","19":"1269707","20":"covidhgi2020B2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"15","24":"74353561","25":"0.00226611","26":"5.51403","27":"3.5e-08","28":"377234","29":"Klimentidis2018mvpa","30":"TRUE","31":"reported","32":"LXdDVl","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs7326482","2":"T","3":"G","4":"T","5":"G","6":"0.0129605","7":"-0.0313420","8":"0.615163","9":"0.597600","10":"FALSE","11":"FALSE","12":"FALSE","13":"CiIaVA","14":"13","15":"54037803","16":"0.024426","17":"-1.28314092","18":"0.19940","19":"1544739","20":"covidhgi2020B2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"13","24":"54037803","25":"0.00229416","26":"5.64934","27":"1.6e-08","28":"377234","29":"Klimentidis2018mvpa","30":"TRUE","31":"reported","32":"LXdDVl","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs77742115","2":"C","3":"T","4":"C","5":"T","6":"0.0183480","7":"-0.0483330","8":"0.138319","9":"0.151300","10":"FALSE","11":"FALSE","12":"FALSE","13":"CiIaVA","14":"5","15":"18330424","16":"0.029325","17":"-1.64818414","18":"0.09932","19":"1557411","20":"covidhgi2020B2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"5","24":"18330424","25":"0.00319777","26":"5.73775","27":"9.6e-09","28":"377234","29":"Klimentidis2018mvpa","30":"TRUE","31":"reported","32":"LXdDVl","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs7804463","2":"C","3":"T","4":"C","5":"T","6":"-0.0150095","7":"-0.0067397","8":"0.470424","9":"0.448300","10":"FALSE","11":"FALSE","12":"FALSE","13":"CiIaVA","14":"7","15":"133447651","16":"0.023974","17":"-0.28112539","18":"0.77860","19":"1544739","20":"covidhgi2020B2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"7","24":"133447651","25":"0.00221333","26":"-6.78141","27":"1.2e-11","28":"377234","29":"Klimentidis2018mvpa","30":"TRUE","31":"reported","32":"LXdDVl","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs877483","2":"C","3":"T","4":"C","5":"T","6":"-0.0122277","7":"0.0160090","8":"0.566815","9":"0.569500","10":"FALSE","11":"FALSE","12":"FALSE","13":"CiIaVA","14":"3","15":"53846741","16":"0.020439","17":"0.78325750","18":"0.43350","19":"1557411","20":"covidhgi2020B2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"3","24":"53846741","25":"0.00222756","26":"-5.48928","27":"4.0e-08","28":"377234","29":"Klimentidis2018mvpa","30":"TRUE","31":"reported","32":"LXdDVl","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs921915","2":"C","3":"T","4":"C","5":"T","6":"0.0138882","7":"-0.0060671","8":"0.587905","9":"0.579500","10":"FALSE","11":"FALSE","12":"FALSE","13":"CiIaVA","14":"7","15":"50228581","16":"0.020399","17":"-0.29742144","18":"0.76610","19":"1557411","20":"covidhgi2020B2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"7","24":"50228581","25":"0.00224013","26":"6.19973","27":"5.7e-10","28":"377234","29":"Klimentidis2018mvpa","30":"TRUE","31":"reported","32":"LXdDVl","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

SNPs that genome-wide significant in the outcome GWAS are likely pleitorpic and should be removed from analysis. Additionaly remove variants within the APOE locus by exclude variants 1MB either side of APOE e4 (rs429358 = 19:45411941, GRCh37.p13)
<br>


**Table 5:** SNPs that were genome-wide significant in the COVID: B2 GWAS
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
{"columns":[{"label":["outliers_removed"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["pve.exposure"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["F"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["Alpha"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["NCP"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["Power"],"name":[6],"type":["dbl"],"align":["right"]}],"data":[{"1":"FALSE","2":"0.001897895","3":"34.15573","4":"0.05","5":"0.5846642","6":"0.1191979"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

The I2_GX statistic can be used to quantify the strength of the NOME violation for MR-Egger regression and should be used to evalute potential bias in the MR-Egger causal estimate, with values less then 90% indicating that causal estimated should interpreted with caution due to regression diluation.

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["outliers_removed"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["Isq_gx"],"name":[2],"type":["dbl"],"align":["right"]}],"data":[{"1":"FALSE","2":"0"},{"1":"TRUE","2":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>


## MR Results
To obtain an overall estimate of causal effect, the SNP-exposure and SNP-outcome coefficients were combined in 1) a fixed-effects meta-analysis using an inverse-variance weighted approach (IVW); 2) a Weighted Median approach; 3) Weighted Mode approach and 4) Egger Regression.


[**IVW**](https://doi.org/10.1002/gepi.21758) is equivalent to a weighted regression of the SNP-outcome coefficients on the SNP-exposure coefficients with the intercept constrained to zero. This method assumes that all variants are valid instrumental variables based on the Mendelian randomization assumptions. The causal estimate of the IVW analysis expresses the causal increase in the outcome (or log odds of the outcome for a binary outcome) per unit change in the exposure. [**Weighted median MR**](https://doi.org/10.1002/gepi.21965) allows for 50% of the instrumental variables to be invalid. [**MR-Egger regression**](https://doi.org/10.1093/ije/dyw220) allows all the instrumental variables to be subject to direct effects (i.e. horizontal pleiotropy), with the intercept representing bias in the causal estimate due to pleiotropy and the slope representing the causal estimate. [**Weighted Mode**](https://doi.org/10.1093/ije/dyx102) gives consistent estimates as the sample size increases if a plurality (or weighted plurality) of the genetic variants are valid instruments.
<br>



Table 6 presents the MR causal estimates of genetically predicted Moderate-Vigours Physical Activity on COVID: B2.
<br>

**Table 6** MR causaul estimates for Moderate-Vigours Physical Activity on COVID: B2
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["method"],"name":[5],"type":["chr"],"align":["left"]},{"label":["nsnp"],"name":[6],"type":["int"],"align":["right"]},{"label":["b"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"LXdDVl","2":"CiIaVA","3":"covidhgi2020B2v5alleurLeaveUKBB","4":"Klimentidis2018mvpa","5":"Inverse variance weighted (fixed effects)","6":"21","7":"-0.2151783","8":"0.3725602","9":"0.5635568"},{"1":"LXdDVl","2":"CiIaVA","3":"covidhgi2020B2v5alleurLeaveUKBB","4":"Klimentidis2018mvpa","5":"Weighted median","6":"21","7":"0.1496467","8":"0.5046190","9":"0.7668072"},{"1":"LXdDVl","2":"CiIaVA","3":"covidhgi2020B2v5alleurLeaveUKBB","4":"Klimentidis2018mvpa","5":"Weighted mode","6":"21","7":"0.4232343","8":"0.8266360","9":"0.6142612"},{"1":"LXdDVl","2":"CiIaVA","3":"covidhgi2020B2v5alleurLeaveUKBB","4":"Klimentidis2018mvpa","5":"MR Egger","6":"21","7":"1.5382552","8":"1.2749943","9":"0.2424405"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Figure 1 illustrates the SNP-specific associations with Moderate-Vigours Physical Activity versus the association in COVID: B2 and the corresponding MR estimates.
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovideurwoukbb/Klimentidis2018mvpa/covidhgi2020B2v5alleurLeaveUKBB/Klimentidis2018mvpa_5e-8_covidhgi2020B2v5alleurLeaveUKBB_MR_Analaysis_files/figure-html/scatter_plot-1.png" alt="Fig. 1: Scatterplot of SNP effects for the association of the Exposure on the Outcome"  />
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
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["method"],"name":[5],"type":["chr"],"align":["left"]},{"label":["Q"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["Q_df"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["Q_pval"],"name":[8],"type":["dbl"],"align":["right"]}],"data":[{"1":"LXdDVl","2":"CiIaVA","3":"covidhgi2020B2v5alleurLeaveUKBB","4":"Klimentidis2018mvpa","5":"MR Egger","6":"10.71608","7":"19","8":"0.9330197"},{"1":"LXdDVl","2":"CiIaVA","3":"covidhgi2020B2v5alleurLeaveUKBB","4":"Klimentidis2018mvpa","5":"Inverse variance weighted","6":"12.78395","7":"20","8":"0.8864601"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Figure 2 shows a funnel plot displaying the MR estimates of individual genetic variants against their precession. Aysmmetry in the funnel plot may arrise due to some genetic variants having unusally strong effects on the outcome, which is indicative of directional pleiotropy.
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovideurwoukbb/Klimentidis2018mvpa/covidhgi2020B2v5alleurLeaveUKBB/Klimentidis2018mvpa_5e-8_covidhgi2020B2v5alleurLeaveUKBB_MR_Analaysis_files/figure-html/funnel_plot-1.png" alt="Fig. 2: Funnel plot of the MR causal estimates against their precession"  />
<p class="caption">Fig. 2: Funnel plot of the MR causal estimates against their precession</p>
</div>
<br>

Figure 3 shows a [Radial Plots](https://github.com/WSpiller/RadialMR) can be used to visualize influential data points with large contributions to Cochran's Q Statistic that may bias causal effect estimates.




```
## [1] "No significant Outliers"
```

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovideurwoukbb/Klimentidis2018mvpa/covidhgi2020B2v5alleurLeaveUKBB/Klimentidis2018mvpa_5e-8_covidhgi2020B2v5alleurLeaveUKBB_MR_Analaysis_files/figure-html/Radial_Plot-1.png" alt="Fig. 4: Radial Plot showing influential data points using Radial IVW"  />
<p class="caption">Fig. 4: Radial Plot showing influential data points using Radial IVW</p>
</div>
<br>

The intercept of the MR-Egger Regression model captures the average pleitropic affect across all genetic variants (Table 8).
<br>

**Table 8:** MR Egger test for directional pleitropy
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["egger_intercept"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[7],"type":["dbl"],"align":["right"]}],"data":[{"1":"LXdDVl","2":"CiIaVA","3":"covidhgi2020B2v5alleurLeaveUKBB","4":"Klimentidis2018mvpa","5":"-0.02871603","6":"0.0199693","7":"0.1666992"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Pleiotropy was also assesed using Mendelian Randomization Pleiotropy RESidual Sum and Outlier [(MR-PRESSO)](https://doi.org/10.1038/s41588-018-0099-7), that allows for the evlation of evaluation of horizontal pleiotropy in a standared MR model (Table 9). MR-PRESSO performs a global test for detection of horizontal pleiotropy and correction of pleiotropy via outlier removal (Table 10).
<br>

**Table 9:** MR-PRESSO Global Test for pleitropy
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["pt"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["outliers_removed"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["n_outliers"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["RSSobs"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"LXdDVl","2":"CiIaVA","3":"covidhgi2020B2v5alleurLeaveUKBB","4":"Klimentidis2018mvpa","5":"5e-08","6":"FALSE","7":"0","8":"14.01316","9":"0.8905"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>


**Table 10:** MR Estimates after MR-PRESSO outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["method"],"name":[5],"type":["chr"],"align":["left"]},{"label":["nsnp"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["b"],"name":[7],"type":["lgl"],"align":["right"]},{"label":["se"],"name":[8],"type":["lgl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["lgl"],"align":["right"]}],"data":[{"1":"LXdDVl","2":"CiIaVA","3":"covidhgi2020B2v5alleurLeaveUKBB","4":"Klimentidis2018mvpa","5":"mrpresso","6":"NA","7":"NA","8":"NA","9":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovideurwoukbb/Klimentidis2018mvpa/covidhgi2020B2v5alleurLeaveUKBB/Klimentidis2018mvpa_5e-8_covidhgi2020B2v5alleurLeaveUKBB_MR_Analaysis_files/figure-html/scatter_plot_outlier-1.png" alt="Fig. 5: Scatterplot of SNP effects for the association of the Exposure on the Outcome after outlier removal"  />
<p class="caption">Fig. 5: Scatterplot of SNP effects for the association of the Exposure on the Outcome after outlier removal</p>
</div>
<br>

**Table 11:** Heterogenity Tests after outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["method"],"name":[5],"type":["chr"],"align":["left"]},{"label":["Q"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["Q_df"],"name":[7],"type":["lgl"],"align":["right"]},{"label":["Q_pval"],"name":[8],"type":["lgl"],"align":["right"]}],"data":[{"1":"LXdDVl","2":"CiIaVA","3":"covidhgi2020B2v5alleurLeaveUKBB","4":"Klimentidis2018mvpa","5":"mrpresso","6":"NA","7":"NA","8":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

**Table 12:** MR Egger test for directional pleitropy after outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["method"],"name":[5],"type":["chr"],"align":["left"]},{"label":["egger_intercept"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["se"],"name":[7],"type":["lgl"],"align":["right"]},{"label":["pval"],"name":[8],"type":["lgl"],"align":["right"]}],"data":[{"1":"LXdDVl","2":"CiIaVA","3":"covidhgi2020B2v5alleurLeaveUKBB","4":"Klimentidis2018mvpa","5":"mrpresso","6":"NA","7":"NA","8":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>
