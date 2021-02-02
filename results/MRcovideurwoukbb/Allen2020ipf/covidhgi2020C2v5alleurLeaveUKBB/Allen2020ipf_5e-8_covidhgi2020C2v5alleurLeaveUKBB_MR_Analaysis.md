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

### Exposure: IPF
`#r exposure.blurb`
<br>

**Table 1:** Independent SNPs associated with IPF
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["CHROM"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["REF"],"name":[4],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[5],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[12],"type":["chr"],"align":["left"]}],"data":[{"1":"rs78238620","2":"3","3":"44902386","4":"T","5":"A","6":"0.053459","7":"0.4593835","8":"0.07390969","9":"6.215471","10":"5.117086e-10","11":"11259","12":"Idiopathic_Pulmonary_Fibrosis"},{"1":"rs12696304","2":"3","3":"169481271","4":"C","5":"G","6":"0.278854","7":"0.2668156","8":"0.03717319","9":"7.177635","10":"7.092778e-13","11":"11259","12":"Idiopathic_Pulmonary_Fibrosis"},{"1":"rs2013701","2":"4","3":"89885086","4":"G","5":"T","6":"0.487438","7":"-0.2424697","8":"0.03330002","9":"-7.281368","10":"3.304528e-13","11":"11259","12":"Idiopathic_Pulmonary_Fibrosis"},{"1":"rs7725218","2":"5","3":"1282414","4":"G","5":"A","6":"0.323107","7":"-0.3293240","8":"0.03544862","9":"-9.290180","10":"1.540283e-20","11":"11259","12":"Idiopathic_Pulmonary_Fibrosis"},{"1":"rs2076295","2":"6","3":"7563232","4":"T","5":"G","6":"0.468835","7":"0.3799705","8":"0.03322854","9":"11.435066","10":"2.793256e-30","11":"11259","12":"Idiopathic_Pulmonary_Fibrosis"},{"1":"rs12699415","2":"7","3":"1909479","4":"A","5":"G","6":"0.580176","7":"-0.2440172","8":"0.03400225","9":"-7.176502","10":"7.151760e-13","11":"11259","12":"Idiopathic_Pulmonary_Fibrosis"},{"1":"rs2897075","2":"7","3":"99630342","4":"C","5":"T","6":"0.391410","7":"0.2585521","8":"0.03404714","9":"7.593945","10":"3.103096e-14","11":"11259","12":"Idiopathic_Pulmonary_Fibrosis"},{"1":"rs28513081","2":"8","3":"120934126","4":"A","5":"G","6":"0.427310","7":"-0.2034907","8":"0.03346963","9":"-6.079862","10":"1.202864e-09","11":"11259","12":"Idiopathic_Pulmonary_Fibrosis"},{"1":"rs35705950","2":"11","3":"1241221","4":"G","5":"T","6":"0.140904","7":"1.5773608","8":"0.05180105","9":"30.450365","10":"1.184630e-203","11":"11259","12":"Idiopathic_Pulmonary_Fibrosis"},{"1":"rs9577395","2":"13","3":"113534984","4":"C","5":"G","6":"0.207732","7":"-0.2642992","8":"0.04115030","9":"-6.422778","10":"1.338099e-10","11":"11259","12":"Idiopathic_Pulmonary_Fibrosis"},{"1":"rs59424629","2":"15","3":"40720542","4":"G","5":"T","6":"0.538260","7":"0.2678313","8":"0.03320740","9":"8.065411","10":"7.298965e-16","11":"11259","12":"Idiopathic_Pulmonary_Fibrosis"},{"1":"rs62023891","2":"15","3":"86097216","4":"G","5":"A","6":"0.300615","7":"0.2356498","8":"0.03664299","9":"6.430965","10":"1.267962e-10","11":"11259","12":"Idiopathic_Pulmonary_Fibrosis"},{"1":"rs17652520","2":"17","3":"44098967","4":"G","5":"A","6":"0.214766","7":"-0.3286135","8":"0.04066747","9":"-8.080502","10":"6.450078e-16","11":"11259","12":"Idiopathic_Pulmonary_Fibrosis"},{"1":"rs12610495","2":"19","3":"4717672","4":"A","5":"G","6":"0.305555","7":"0.2722340","8":"0.03899250","9":"6.981701","10":"2.916276e-12","11":"11259","12":"Idiopathic_Pulmonary_Fibrosis"},{"1":"rs41308092","2":"20","3":"62324391","4":"G","5":"A","6":"0.019674","7":"0.7503587","8":"0.12196998","9":"6.151995","10":"7.651443e-10","11":"11259","12":"Idiopathic_Pulmonary_Fibrosis"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

### Outcome: COVID: C2, EUR w/o UKBB
`#r outcome.blurb`
<br>

**Table 2:** SNPs associated with IPF avaliable in COVID: C2, EUR w/o UKBB
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["CHROM"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["REF"],"name":[4],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[5],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[12],"type":["chr"],"align":["left"]}],"data":[{"1":"rs78238620","2":"3","3":"44902386","4":"T","5":"A","6":"0.06062","7":"-0.0346400","8":"0.0198660","9":"-1.7436827","10":"0.0812300","11":"1348702","12":"COVID_C2__EUR_w/o_UKBB"},{"1":"rs12696304","2":"3","3":"169481271","4":"C","5":"G","6":"0.26690","7":"0.0025770","8":"0.0101280","9":"0.2544431","10":"0.7991000","11":"1348702","12":"COVID_C2__EUR_w/o_UKBB"},{"1":"rs2013701","2":"4","3":"89885086","4":"G","5":"T","6":"0.51790","7":"-0.0082848","8":"0.0090290","9":"-0.9175767","10":"0.3588000","11":"1347128","12":"COVID_C2__EUR_w/o_UKBB"},{"1":"rs7725218","2":"5","3":"1282414","4":"G","5":"A","6":"0.35230","7":"-0.0103520","8":"0.0094778","9":"-1.0922366","10":"0.2747000","11":"1277587","12":"COVID_C2__EUR_w/o_UKBB"},{"1":"rs2076295","2":"6","3":"7563232","4":"T","5":"G","6":"0.44110","7":"0.0183460","8":"0.0094545","9":"1.9404516","10":"0.0523200","11":"1329167","12":"COVID_C2__EUR_w/o_UKBB"},{"1":"rs12699415","2":"7","3":"1909479","4":"A","5":"G","6":"0.58020","7":"-0.0110330","8":"0.0091541","9":"-1.2052523","10":"0.2281000","11":"1277946","12":"COVID_C2__EUR_w/o_UKBB"},{"1":"rs2897075","2":"7","3":"99630342","4":"C","5":"T","6":"0.37850","7":"0.0327590","8":"0.0095261","9":"3.4388680","10":"0.0005842","11":"1338559","12":"COVID_C2__EUR_w/o_UKBB"},{"1":"rs28513081","2":"8","3":"120934126","4":"A","5":"G","6":"0.46490","7":"-0.0110020","8":"0.0092355","9":"-1.1912728","10":"0.2336000","11":"1338646","12":"COVID_C2__EUR_w/o_UKBB"},{"1":"rs35705950","2":"11","3":"1241221","4":"G","5":"T","6":"0.11380","7":"-0.0216760","8":"0.0161570","9":"-1.3415857","10":"0.1797000","11":"979346","12":"COVID_C2__EUR_w/o_UKBB"},{"1":"rs9577395","2":"13","3":"113534984","4":"C","5":"G","6":"0.22550","7":"0.0372850","8":"0.0108290","9":"3.4430695","10":"0.0005753","11":"1347433","12":"COVID_C2__EUR_w/o_UKBB"},{"1":"rs59424629","2":"15","3":"40720542","4":"G","5":"T","6":"0.54680","7":"0.0135700","8":"0.0089987","9":"1.5079956","10":"0.1316000","11":"1348702","12":"COVID_C2__EUR_w/o_UKBB"},{"1":"rs62023891","2":"15","3":"86097216","4":"G","5":"A","6":"0.29130","7":"0.0036618","8":"0.0100600","9":"0.3639960","10":"0.7158000","11":"1348702","12":"COVID_C2__EUR_w/o_UKBB"},{"1":"rs17652520","2":"17","3":"44098967","4":"G","5":"A","6":"0.18300","7":"-0.0304710","8":"0.0114260","9":"-2.6668125","10":"0.0076590","11":"1338646","12":"COVID_C2__EUR_w/o_UKBB"},{"1":"rs12610495","2":"19","3":"4717672","4":"A","5":"G","6":"0.30560","7":"0.0383100","8":"0.0104350","9":"3.6712985","10":"0.0002413","11":"1322860","12":"COVID_C2__EUR_w/o_UKBB"},{"1":"rs41308092","2":"20","3":"62324391","4":"G","5":"A","6":"0.03200","7":"0.0056672","8":"0.0349410","9":"0.1621934","10":"0.8712000","11":"1338104","12":"COVID_C2__EUR_w/o_UKBB"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
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

**Table 4:** Harmonized IPF and COVID: C2, EUR w/o UKBB datasets
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["effect_allele.exposure"],"name":[2],"type":["chr"],"align":["left"]},{"label":["other_allele.exposure"],"name":[3],"type":["chr"],"align":["left"]},{"label":["effect_allele.outcome"],"name":[4],"type":["chr"],"align":["left"]},{"label":["other_allele.outcome"],"name":[5],"type":["chr"],"align":["left"]},{"label":["beta.exposure"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["beta.outcome"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["eaf.exposure"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["eaf.outcome"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["remove"],"name":[10],"type":["lgl"],"align":["right"]},{"label":["palindromic"],"name":[11],"type":["lgl"],"align":["right"]},{"label":["ambiguous"],"name":[12],"type":["lgl"],"align":["right"]},{"label":["id.outcome"],"name":[13],"type":["chr"],"align":["left"]},{"label":["chr.outcome"],"name":[14],"type":["dbl"],"align":["right"]},{"label":["pos.outcome"],"name":[15],"type":["dbl"],"align":["right"]},{"label":["se.outcome"],"name":[16],"type":["dbl"],"align":["right"]},{"label":["z.outcome"],"name":[17],"type":["dbl"],"align":["right"]},{"label":["pval.outcome"],"name":[18],"type":["dbl"],"align":["right"]},{"label":["samplesize.outcome"],"name":[19],"type":["dbl"],"align":["right"]},{"label":["outcome"],"name":[20],"type":["chr"],"align":["left"]},{"label":["mr_keep.outcome"],"name":[21],"type":["lgl"],"align":["right"]},{"label":["pval_origin.outcome"],"name":[22],"type":["chr"],"align":["left"]},{"label":["chr.exposure"],"name":[23],"type":["dbl"],"align":["right"]},{"label":["pos.exposure"],"name":[24],"type":["dbl"],"align":["right"]},{"label":["se.exposure"],"name":[25],"type":["dbl"],"align":["right"]},{"label":["z.exposure"],"name":[26],"type":["dbl"],"align":["right"]},{"label":["pval.exposure"],"name":[27],"type":["dbl"],"align":["right"]},{"label":["samplesize.exposure"],"name":[28],"type":["dbl"],"align":["right"]},{"label":["exposure"],"name":[29],"type":["chr"],"align":["left"]},{"label":["mr_keep.exposure"],"name":[30],"type":["lgl"],"align":["right"]},{"label":["pval_origin.exposure"],"name":[31],"type":["chr"],"align":["left"]},{"label":["id.exposure"],"name":[32],"type":["chr"],"align":["left"]},{"label":["action"],"name":[33],"type":["dbl"],"align":["right"]},{"label":["mr_keep"],"name":[34],"type":["lgl"],"align":["right"]},{"label":["pt"],"name":[35],"type":["dbl"],"align":["right"]},{"label":["pleitropy_keep"],"name":[36],"type":["lgl"],"align":["right"]},{"label":["mrpresso_RSSobs"],"name":[37],"type":["dbl"],"align":["right"]},{"label":["mrpresso_pval"],"name":[38],"type":["dbl"],"align":["right"]},{"label":["mrpresso_keep"],"name":[39],"type":["lgl"],"align":["right"]}],"data":[{"1":"rs12610495","2":"G","3":"A","4":"G","5":"A","6":"0.2722340","7":"0.0383100","8":"0.305555","9":"0.30560","10":"FALSE","11":"FALSE","12":"FALSE","13":"cmRKMk","14":"19","15":"4717672","16":"0.0104350","17":"3.6712985","18":"0.0002413","19":"1322860","20":"covidhgi2020C2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"19","24":"4717672","25":"0.03899250","26":"6.981701","27":"2.916276e-12","28":"11259","29":"Allen2020ipf","30":"TRUE","31":"reported","32":"qOw8K9","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"1.284673e-03","38":"0.0060","39":"FALSE"},{"1":"rs12696304","2":"G","3":"C","4":"G","5":"C","6":"0.2668156","7":"0.0025770","8":"0.278854","9":"0.26690","10":"FALSE","11":"TRUE","12":"FALSE","13":"cmRKMk","14":"3","15":"169481271","16":"0.0101280","17":"0.2544431","18":"0.7991000","19":"1348702","20":"covidhgi2020C2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"3","24":"169481271","25":"0.03717319","26":"7.177635","27":"7.092778e-13","28":"11259","29":"Allen2020ipf","30":"TRUE","31":"reported","32":"qOw8K9","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"1.122402e-06","38":"1.0000","39":"TRUE"},{"1":"rs12699415","2":"G","3":"A","4":"G","5":"A","6":"-0.2440172","7":"-0.0110330","8":"0.580176","9":"0.58020","10":"FALSE","11":"FALSE","12":"FALSE","13":"cmRKMk","14":"7","15":"1909479","16":"0.0091541","17":"-1.2052523","18":"0.2281000","19":"1277946","20":"covidhgi2020C2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"7","24":"1909479","25":"0.03400225","26":"-7.176502","27":"7.151760e-13","28":"11259","29":"Allen2020ipf","30":"TRUE","31":"reported","32":"qOw8K9","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"6.435600e-05","38":"1.0000","39":"TRUE"},{"1":"rs17652520","2":"A","3":"G","4":"A","5":"G","6":"-0.3286135","7":"-0.0304710","8":"0.214766","9":"0.18300","10":"FALSE","11":"FALSE","12":"FALSE","13":"cmRKMk","14":"17","15":"44098967","16":"0.0114260","17":"-2.6668125","18":"0.0076590","19":"1338646","20":"covidhgi2020C2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"17","24":"44098967","25":"0.04066747","26":"-8.080502","27":"6.450078e-16","28":"11259","29":"Allen2020ipf","30":"TRUE","31":"reported","32":"qOw8K9","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"7.369448e-04","38":"0.2535","39":"TRUE"},{"1":"rs2013701","2":"T","3":"G","4":"T","5":"G","6":"-0.2424697","7":"-0.0082848","8":"0.487438","9":"0.51790","10":"FALSE","11":"FALSE","12":"FALSE","13":"cmRKMk","14":"4","15":"89885086","16":"0.0090290","17":"-0.9175767","18":"0.3588000","19":"1347128","20":"covidhgi2020C2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"4","24":"89885086","25":"0.03330002","26":"-7.281368","27":"3.304528e-13","28":"11259","29":"Allen2020ipf","30":"TRUE","31":"reported","32":"qOw8K9","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"2.702403e-05","38":"1.0000","39":"TRUE"},{"1":"rs2076295","2":"G","3":"T","4":"G","5":"T","6":"0.3799705","7":"0.0183460","8":"0.468835","9":"0.44110","10":"FALSE","11":"FALSE","12":"FALSE","13":"cmRKMk","14":"6","15":"7563232","16":"0.0094545","17":"1.9404516","18":"0.0523200","19":"1329167","20":"covidhgi2020C2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"6","24":"7563232","25":"0.03322854","26":"11.435066","27":"2.793256e-30","28":"11259","29":"Allen2020ipf","30":"TRUE","31":"reported","32":"qOw8K9","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"2.063761e-04","38":"1.0000","39":"TRUE"},{"1":"rs28513081","2":"G","3":"A","4":"G","5":"A","6":"-0.2034907","7":"-0.0110020","8":"0.427310","9":"0.46490","10":"FALSE","11":"FALSE","12":"FALSE","13":"cmRKMk","14":"8","15":"120934126","16":"0.0092355","17":"-1.1912728","18":"0.2336000","19":"1338646","20":"covidhgi2020C2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"8","24":"120934126","25":"0.03346963","26":"-6.079862","27":"1.202864e-09","28":"11259","29":"Allen2020ipf","30":"TRUE","31":"reported","32":"qOw8K9","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"7.155949e-05","38":"1.0000","39":"TRUE"},{"1":"rs2897075","2":"T","3":"C","4":"T","5":"C","6":"0.2585521","7":"0.0327590","8":"0.391410","9":"0.37850","10":"FALSE","11":"FALSE","12":"FALSE","13":"cmRKMk","14":"7","15":"99630342","16":"0.0095261","17":"3.4388680","18":"0.0005842","19":"1338559","20":"covidhgi2020C2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"7","24":"99630342","25":"0.03404714","26":"7.593945","27":"3.103096e-14","28":"11259","29":"Allen2020ipf","30":"TRUE","31":"reported","32":"qOw8K9","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"9.227153e-04","38":"0.0090","39":"FALSE"},{"1":"rs35705950","2":"T","3":"G","4":"T","5":"G","6":"1.5773608","7":"-0.0216760","8":"0.140904","9":"0.11380","10":"FALSE","11":"FALSE","12":"FALSE","13":"cmRKMk","14":"11","15":"1241221","16":"0.0161570","17":"-1.3415857","18":"0.1797000","19":"979346","20":"covidhgi2020C2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"11","24":"1241221","25":"0.05180105","26":"30.450365","27":"1.000000e-200","28":"11259","29":"Allen2020ipf","30":"TRUE","31":"reported","32":"qOw8K9","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"6.594976e-03","38":"0.0435","39":"FALSE"},{"1":"rs41308092","2":"A","3":"G","4":"A","5":"G","6":"0.7503587","7":"0.0056672","8":"0.019674","9":"0.03200","10":"FALSE","11":"FALSE","12":"FALSE","13":"cmRKMk","14":"20","15":"62324391","16":"0.0349410","17":"0.1621934","18":"0.8712000","19":"1338104","20":"covidhgi2020C2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"20","24":"62324391","25":"0.12196998","26":"6.151995","27":"7.651443e-10","28":"11259","29":"Allen2020ipf","30":"TRUE","31":"reported","32":"qOw8K9","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"2.080473e-05","38":"1.0000","39":"TRUE"},{"1":"rs59424629","2":"T","3":"G","4":"T","5":"G","6":"0.2678313","7":"0.0135700","8":"0.538260","9":"0.54680","10":"FALSE","11":"FALSE","12":"FALSE","13":"cmRKMk","14":"15","15":"40720542","16":"0.0089987","17":"1.5079956","18":"0.1316000","19":"1348702","20":"covidhgi2020C2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"15","24":"40720542","25":"0.03320740","26":"8.065411","27":"7.298965e-16","28":"11259","29":"Allen2020ipf","30":"TRUE","31":"reported","32":"qOw8K9","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"1.084099e-04","38":"1.0000","39":"TRUE"},{"1":"rs62023891","2":"A","3":"G","4":"A","5":"G","6":"0.2356498","7":"0.0036618","8":"0.300615","9":"0.29130","10":"FALSE","11":"FALSE","12":"FALSE","13":"cmRKMk","14":"15","15":"86097216","16":"0.0100600","17":"0.3639960","18":"0.7158000","19":"1348702","20":"covidhgi2020C2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"15","24":"86097216","25":"0.03664299","26":"6.430965","27":"1.267962e-10","28":"11259","29":"Allen2020ipf","30":"TRUE","31":"reported","32":"qOw8K9","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"2.456748e-07","38":"1.0000","39":"TRUE"},{"1":"rs7725218","2":"A","3":"G","4":"A","5":"G","6":"-0.3293240","7":"-0.0103520","8":"0.323107","9":"0.35230","10":"FALSE","11":"FALSE","12":"FALSE","13":"cmRKMk","14":"5","15":"1282414","16":"0.0094778","17":"-1.0922366","18":"0.2747000","19":"1277587","20":"covidhgi2020C2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"5","24":"1282414","25":"0.03544862","26":"-9.290180","27":"1.540283e-20","28":"11259","29":"Allen2020ipf","30":"TRUE","31":"reported","32":"qOw8K9","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"3.948091e-05","38":"1.0000","39":"TRUE"},{"1":"rs78238620","2":"A","3":"T","4":"A","5":"T","6":"0.4593835","7":"-0.0346400","8":"0.053459","9":"0.06062","10":"FALSE","11":"TRUE","12":"FALSE","13":"cmRKMk","14":"3","15":"44902386","16":"0.0198660","17":"-1.7436827","18":"0.0812300","19":"1348702","20":"covidhgi2020C2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"3","24":"44902386","25":"0.07390969","26":"6.215471","27":"5.117086e-10","28":"11259","29":"Allen2020ipf","30":"TRUE","31":"reported","32":"qOw8K9","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"1.759538e-03","38":"0.5790","39":"TRUE"},{"1":"rs9577395","2":"G","3":"C","4":"G","5":"C","6":"-0.2642992","7":"0.0372850","8":"0.207732","9":"0.22550","10":"FALSE","11":"TRUE","12":"FALSE","13":"cmRKMk","14":"13","15":"113534984","16":"0.0108290","17":"3.4430695","18":"0.0005753","19":"1347433","20":"covidhgi2020C2v5alleurLeaveUKBB","21":"TRUE","22":"reported","23":"13","24":"113534984","25":"0.04115030","26":"-6.422778","27":"1.338099e-10","28":"11259","29":"Allen2020ipf","30":"TRUE","31":"reported","32":"qOw8K9","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"1.771584e-03","38":"0.0030","39":"FALSE"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
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
{"columns":[{"label":["outliers_removed"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["pve.exposure"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["F"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["Alpha"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["NCP"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["Power"],"name":[6],"type":["dbl"],"align":["right"]}],"data":[{"1":"FALSE","2":"0.14289659","3":"124.96246","4":"0.05","5":"7.031905","6":"0.7554737"},{"1":"TRUE","2":"0.05826355","3":"63.25744","4":"0.05","5":"14.877912","6":"0.9711009"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

The I2_GX statistic can be used to quantify the strength of the NOME violation for MR-Egger regression and should be used to evalute potential bias in the MR-Egger causal estimate, with values less then 90% indicating that causal estimated should interpreted with caution due to regression diluation.

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["outliers_removed"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["Isq_gx"],"name":[2],"type":["dbl"],"align":["right"]}],"data":[{"1":"FALSE","2":"0.9700265"},{"1":"TRUE","2":"0.6055890"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>


##  MR Results
To obtain an overall estimate of causal effect, the SNP-exposure and SNP-outcome coefficients were combined in 1) a fixed-effects meta-analysis using an inverse-variance weighted approach (IVW); 2) a Weighted Median approach; 3) Weighted Mode approach and 4) Egger Regression.


[**IVW**](https://doi.org/10.1002/gepi.21758) is equivalent to a weighted regression of the SNP-outcome coefficients on the SNP-exposure coefficients with the intercept constrained to zero. This method assumes that all variants are valid instrumental variables based on the Mendelian randomization assumptions. The causal estimate of the IVW analysis expresses the causal increase in the outcome (or log odds of the outcome for a binary outcome) per unit change in the exposure. [**Weighted median MR**](https://doi.org/10.1002/gepi.21965) allows for 50% of the instrumental variables to be invalid. [**MR-Egger regression**](https://doi.org/10.1093/ije/dyw220) allows all the instrumental variables to be subject to direct effects (i.e. horizontal pleiotropy), with the intercept representing bias in the causal estimate due to pleiotropy and the slope representing the causal estimate. [**Weighted Mode**](https://doi.org/10.1093/ije/dyx102) gives consistent estimates as the sample size increases if a plurality (or weighted plurality) of the genetic variants are valid instruments.
<br>



Table 6 presents the MR causal estimates of genetically predicted IPF on COVID: C2, EUR w/o UKBB.
<br>

**Table 6** MR causaul estimates for IPF on COVID: C2, EUR w/o UKBB
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["nsnp"],"name":[6],"type":["int"],"align":["right"]},{"label":["b"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"qOw8K9","2":"cmRKMk","3":"covidhgi2020C2v5alleurLeaveUKBB","4":"Allen2020ipf","5":"Inverse variance weighted (fixed effects)","6":"15","7":"0.013492836","8":"0.007029821","9":"0.05493737"},{"1":"qOw8K9","2":"cmRKMk","3":"covidhgi2020C2v5alleurLeaveUKBB","4":"Allen2020ipf","5":"Weighted median","6":"15","7":"0.003591525","8":"0.010833691","9":"0.74025591"},{"1":"qOw8K9","2":"cmRKMk","3":"covidhgi2020C2v5alleurLeaveUKBB","4":"Allen2020ipf","5":"Weighted mode","6":"15","7":"-0.011409063","8":"0.009943325","9":"0.27044318"},{"1":"qOw8K9","2":"cmRKMk","3":"covidhgi2020C2v5alleurLeaveUKBB","4":"Allen2020ipf","5":"MR Egger","6":"15","7":"-0.023750315","8":"0.021850763","9":"0.29680930"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Figure 1 illustrates the SNP-specific associations with IPF versus the association in COVID: C2, EUR w/o UKBB and the corresponding MR estimates.
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovideurwoukbb/Allen2020ipf/covidhgi2020C2v5alleurLeaveUKBB/Allen2020ipf_5e-8_covidhgi2020C2v5alleurLeaveUKBB_MR_Analaysis_files/figure-html/scatter_plot-1.png" alt="Fig. 1: Scatterplot of SNP effects for the association of the Exposure on the Outcome"  />
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
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["Q"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["Q_df"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["Q_pval"],"name":[8],"type":["dbl"],"align":["right"]}],"data":[{"1":"qOw8K9","2":"cmRKMk","3":"covidhgi2020C2v5alleurLeaveUKBB","4":"Allen2020ipf","5":"MR Egger","6":"42.32913","7":"13","8":"5.785367e-05"},{"1":"qOw8K9","2":"cmRKMk","3":"covidhgi2020C2v5alleurLeaveUKBB","4":"Allen2020ipf","5":"Inverse variance weighted","6":"56.59679","7":"14","8":"4.593866e-07"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Figure 2 shows a funnel plot displaying the MR estimates of individual genetic variants against their precession. Aysmmetry in the funnel plot may arrise due to some genetic variants having unusally strong effects on the outcome, which is indicative of directional pleiotropy.
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovideurwoukbb/Allen2020ipf/covidhgi2020C2v5alleurLeaveUKBB/Allen2020ipf_5e-8_covidhgi2020C2v5alleurLeaveUKBB_MR_Analaysis_files/figure-html/funnel_plot-1.png" alt="Fig. 2: Funnel plot of the MR causal estimates against their precession"  />
<p class="caption">Fig. 2: Funnel plot of the MR causal estimates against their precession</p>
</div>
<br>

Figure 3 shows a [Radial Plots](https://github.com/WSpiller/RadialMR) can be used to visualize influential data points with large contributions to Cochran's Q Statistic that may bias causal effect estimates.



<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovideurwoukbb/Allen2020ipf/covidhgi2020C2v5alleurLeaveUKBB/Allen2020ipf_5e-8_covidhgi2020C2v5alleurLeaveUKBB_MR_Analaysis_files/figure-html/Radial_Plot-1.png" alt="Fig. 4: Radial Plot showing influential data points using Radial IVW"  />
<p class="caption">Fig. 4: Radial Plot showing influential data points using Radial IVW</p>
</div>
<br>

The intercept of the MR-Egger Regression model captures the average pleitropic affect across all genetic variants (Table 8).
<br>

**Table 8:** MR Egger test for directional pleitropy
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["egger_intercept"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[7],"type":["dbl"],"align":["right"]}],"data":[{"1":"qOw8K9","2":"cmRKMk","3":"covidhgi2020C2v5alleurLeaveUKBB","4":"Allen2020ipf","5":"0.01778802","6":"0.008497656","7":"0.05649663"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Pleiotropy was also assesed using Mendelian Randomization Pleiotropy RESidual Sum and Outlier [(MR-PRESSO)](https://doi.org/10.1038/s41588-018-0099-7), that allows for the evlation of evaluation of horizontal pleiotropy in a standared MR model (Table 9). MR-PRESSO performs a global test for detection of horizontal pleiotropy and correction of pleiotropy via outlier removal (Table 10).
<br>

**Table 9:** MR-PRESSO Global Test for pleitropy
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["pt"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["outliers_removed"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["n_outliers"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["RSSobs"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["chr"],"align":["left"]}],"data":[{"1":"qOw8K9","2":"cmRKMk","3":"covidhgi2020C2v5alleurLeaveUKBB","4":"Allen2020ipf","5":"5e-08","6":"FALSE","7":"4","8":"78.49576","9":"<1e-04"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>


**Table 10:** MR Estimates after MR-PRESSO outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["nsnp"],"name":[6],"type":["int"],"align":["right"]},{"label":["b"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"qOw8K9","2":"cmRKMk","3":"covidhgi2020C2v5alleurLeaveUKBB","4":"Allen2020ipf","5":"Inverse variance weighted (fixed effects)","6":"11","7":"0.034393471","8":"0.01072644","9":"0.001343975"},{"1":"qOw8K9","2":"cmRKMk","3":"covidhgi2020C2v5alleurLeaveUKBB","4":"Allen2020ipf","5":"Weighted median","6":"11","7":"0.041602185","8":"0.01408027","9":"0.003130300"},{"1":"qOw8K9","2":"cmRKMk","3":"covidhgi2020C2v5alleurLeaveUKBB","4":"Allen2020ipf","5":"Weighted mode","6":"11","7":"0.042045984","8":"0.01808932","9":"0.042456700"},{"1":"qOw8K9","2":"cmRKMk","3":"covidhgi2020C2v5alleurLeaveUKBB","4":"Allen2020ipf","5":"MR Egger","6":"11","7":"-0.004332199","8":"0.04563891","9":"0.926455534"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovideurwoukbb/Allen2020ipf/covidhgi2020C2v5alleurLeaveUKBB/Allen2020ipf_5e-8_covidhgi2020C2v5alleurLeaveUKBB_MR_Analaysis_files/figure-html/scatter_plot_outlier-1.png" alt="Fig. 5: Scatterplot of SNP effects for the association of the Exposure on the Outcome after outlier removal"  />
<p class="caption">Fig. 5: Scatterplot of SNP effects for the association of the Exposure on the Outcome after outlier removal</p>
</div>
<br>

**Table 11:** Heterogenity Tests after outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["Q"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["Q_df"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["Q_pval"],"name":[8],"type":["dbl"],"align":["right"]}],"data":[{"1":"qOw8K9","2":"cmRKMk","3":"covidhgi2020C2v5alleurLeaveUKBB","4":"Allen2020ipf","5":"MR Egger","6":"10.17281","7":"9","8":"0.3366772"},{"1":"qOw8K9","2":"cmRKMk","3":"covidhgi2020C2v5alleurLeaveUKBB","4":"Allen2020ipf","5":"Inverse variance weighted","6":"11.04082","7":"10","8":"0.3543463"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

**Table 12:** MR Egger test for directional pleitropy after outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["egger_intercept"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[7],"type":["dbl"],"align":["right"]}],"data":[{"1":"qOw8K9","2":"cmRKMk","3":"covidhgi2020C2v5alleurLeaveUKBB","4":"Allen2020ipf","5":"0.01171863","6":"0.01337253","7":"0.4036384"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>
