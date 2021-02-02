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

### Exposure: Risk tolerance
`#r exposure.blurb`
<br>

**Table 1:** Independent SNPs associated with Risk tolerance
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["CHROM"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["REF"],"name":[4],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[5],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[12],"type":["chr"],"align":["left"]}],"data":[{"1":"rs10914678","2":"1","3":"33767228","4":"G","5":"T","6":"0.3758080","7":"0.01189","8":"0.00215","9":"5.530233","10":"3.452e-08","11":"466571","12":"Risk_tolerance"},{"1":"rs35068223","2":"1","3":"204967186","4":"A","5":"T","6":"0.2060360","7":"0.01433","8":"0.00260","9":"5.511540","10":"3.472e-08","11":"466571","12":"Risk_tolerance"},{"1":"rs3818802","2":"1","3":"243449881","4":"G","5":"A","6":"0.5271020","7":"0.01361","8":"0.00211","9":"6.450237","10":"1.240e-10","11":"466571","12":"Risk_tolerance"},{"1":"rs12617392","2":"2","3":"27336827","4":"C","5":"A","6":"0.4502930","7":"-0.01171","8":"0.00211","9":"-5.549763","10":"2.808e-08","11":"466571","12":"Risk_tolerance"},{"1":"rs10865313","2":"2","3":"60117297","4":"A","5":"G","6":"0.5672470","7":"0.01168","8":"0.00212","9":"5.509430","10":"3.785e-08","11":"466571","12":"Risk_tolerance"},{"1":"rs359243","2":"2","3":"60475509","4":"T","5":"C","6":"0.6176930","7":"0.01190","8":"0.00214","9":"5.560750","10":"2.876e-08","11":"466571","12":"Risk_tolerance"},{"1":"rs283914","2":"3","3":"17330649","4":"T","5":"C","6":"0.4648750","7":"-0.01201","8":"0.00210","9":"-5.719050","10":"1.039e-08","11":"466571","12":"Risk_tolerance"},{"1":"rs62250712","2":"3","3":"85513716","4":"C","5":"T","6":"0.6113340","7":"-0.02469","8":"0.00216","9":"-11.430556","10":"2.465e-30","11":"466571","12":"Risk_tolerance"},{"1":"rs4434184","2":"3","3":"181422854","4":"A","5":"G","6":"0.1887900","7":"0.01751","8":"0.00273","9":"6.413920","10":"1.440e-10","11":"466571","12":"Risk_tolerance"},{"1":"rs279846","2":"4","3":"46329886","4":"C","5":"T","6":"0.4443490","7":"-0.01151","8":"0.00210","9":"-5.480952","10":"4.082e-08","11":"466571","12":"Risk_tolerance"},{"1":"rs992493","2":"4","3":"106180264","4":"T","5":"C","6":"0.7908070","7":"-0.01697","8":"0.00267","9":"-6.355810","10":"2.159e-10","11":"466571","12":"Risk_tolerance"},{"1":"rs12639706","2":"4","3":"157638546","4":"C","5":"T","6":"0.0812904","7":"0.01985","8":"0.00364","9":"5.453297","10":"4.883e-08","11":"466571","12":"Risk_tolerance"},{"1":"rs6923811","2":"6","3":"27289776","4":"T","5":"C","6":"0.3212040","7":"-0.01381","8":"0.00225","9":"-6.137780","10":"8.235e-10","11":"466571","12":"Risk_tolerance"},{"1":"rs34905321","2":"6","3":"109131107","4":"T","5":"C","6":"0.4229130","7":"-0.01205","8":"0.00211","9":"-5.710900","10":"1.209e-08","11":"466571","12":"Risk_tolerance"},{"1":"rs8180817","2":"7","3":"114047542","4":"G","5":"C","6":"0.4630120","7":"-0.01549","8":"0.00211","9":"-7.341232","10":"2.317e-13","11":"466571","12":"Risk_tolerance"},{"1":"rs9641536","2":"7","3":"114979967","4":"A","5":"T","6":"0.5060670","7":"-0.01265","8":"0.00209","9":"-6.052630","10":"1.527e-09","11":"466571","12":"Risk_tolerance"},{"1":"rs4841041","2":"8","3":"8654541","4":"C","5":"G","6":"0.7707730","7":"0.01499","8":"0.00245","9":"6.118370","10":"9.615e-10","11":"466571","12":"Risk_tolerance"},{"1":"rs7834566","2":"8","3":"33611488","4":"A","5":"G","6":"0.4803050","7":"-0.01160","8":"0.00209","9":"-5.550240","10":"3.022e-08","11":"466571","12":"Risk_tolerance"},{"1":"rs9650210","2":"8","3":"65496059","4":"C","5":"A","6":"0.1109790","7":"-0.02158","8":"0.00331","9":"-6.519637","10":"6.730e-11","11":"466571","12":"Risk_tolerance"},{"1":"rs7817124","2":"8","3":"81404008","4":"G","5":"C","6":"0.2717890","7":"0.01591","8":"0.00246","9":"6.467480","10":"9.537e-11","11":"466571","12":"Risk_tolerance"},{"1":"rs9630089","2":"10","3":"98968967","4":"G","5":"A","6":"0.5645060","7":"-0.01181","8":"0.00212","9":"-5.570755","10":"2.336e-08","11":"466571","12":"Risk_tolerance"},{"1":"rs7112324","2":"11","3":"29073285","4":"A","5":"T","6":"0.3136740","7":"-0.01245","8":"0.00225","9":"-5.533330","10":"3.173e-08","11":"466571","12":"Risk_tolerance"},{"1":"rs7951031","2":"11","3":"104303010","4":"C","5":"A","6":"0.1588700","7":"0.01640","8":"0.00295","9":"5.559322","10":"2.804e-08","11":"466571","12":"Risk_tolerance"},{"1":"rs6575642","2":"14","3":"98556621","4":"A","5":"G","6":"0.4973980","7":"0.01178","8":"0.00210","9":"5.609520","10":"1.973e-08","11":"466571","12":"Risk_tolerance"},{"1":"rs2098747","2":"16","3":"71358937","4":"G","5":"A","6":"0.3119650","7":"0.01248","8":"0.00229","9":"5.449782","10":"4.887e-08","11":"466571","12":"Risk_tolerance"},{"1":"rs62074192","2":"17","3":"16245127","4":"G","5":"A","6":"0.5105790","7":"0.01172","8":"0.00209","9":"5.607656","10":"2.195e-08","11":"466571","12":"Risk_tolerance"},{"1":"rs1382119","2":"18","3":"53459905","4":"C","5":"T","6":"0.3588240","7":"0.01283","8":"0.00221","9":"5.805430","10":"6.093e-09","11":"466571","12":"Risk_tolerance"},{"1":"rs28520003","2":"22","3":"46411969","4":"G","5":"A","6":"0.3065600","7":"-0.01253","8":"0.00228","9":"-5.495614","10":"4.017e-08","11":"466571","12":"Risk_tolerance"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

### Outcome: COVID: B2, w/o 23andMe
`#r outcome.blurb`
<br>

**Table 2:** SNPs associated with Risk tolerance avaliable in COVID: B2, w/o 23andMe
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["CHROM"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["REF"],"name":[4],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[5],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[12],"type":["chr"],"align":["left"]}],"data":[{"1":"rs10914678","2":"1","3":"33767228","4":"G","5":"T","6":"0.3774","7":"-8.0173e-03","8":"0.030623","9":"-0.261806485","10":"0.793500","11":"895822","12":"COVID:_hospitalized_vs._population__eur_w/o_23andMe"},{"1":"rs35068223","2":"1","3":"204967186","4":"A","5":"T","6":"0.1997","7":"-3.2113e-02","8":"0.034454","9":"-0.932054333","10":"0.351300","11":"898438","12":"COVID:_hospitalized_vs._population__eur_w/o_23andMe"},{"1":"rs3818802","2":"1","3":"243449881","4":"G","5":"A","6":"0.5369","7":"-2.5142e-02","8":"0.023222","9":"-1.082680217","10":"0.278900","11":"908494","12":"COVID:_hospitalized_vs._population__eur_w/o_23andMe"},{"1":"rs12617392","2":"2","3":"27336827","4":"C","5":"A","6":"0.4346","7":"-6.8303e-05","8":"0.027699","9":"-0.002465901","10":"0.998000","11":"898438","12":"COVID:_hospitalized_vs._population__eur_w/o_23andMe"},{"1":"rs10865313","2":"2","3":"60117297","4":"A","5":"G","6":"0.6210","7":"3.6706e-02","8":"0.023442","9":"1.565822029","10":"0.117400","11":"907881","12":"COVID:_hospitalized_vs._population__eur_w/o_23andMe"},{"1":"rs359243","2":"2","3":"60475509","4":"T","5":"C","6":"0.6034","7":"-6.3660e-03","8":"0.028342","9":"-0.224613648","10":"0.822300","11":"897825","12":"COVID:_hospitalized_vs._population__eur_w/o_23andMe"},{"1":"rs283914","2":"3","3":"17330649","4":"T","5":"C","6":"0.4619","7":"2.3116e-02","8":"0.023162","9":"0.998013988","10":"0.318300","11":"907881","12":"COVID:_hospitalized_vs._population__eur_w/o_23andMe"},{"1":"rs62250712","2":"3","3":"85513716","4":"C","5":"T","6":"0.6374","7":"8.9292e-03","8":"0.023658","9":"0.377428354","10":"0.705900","11":"908494","12":"COVID:_hospitalized_vs._population__eur_w/o_23andMe"},{"1":"rs4434184","2":"3","3":"181422854","4":"A","5":"G","6":"0.1713","7":"9.5549e-02","8":"0.040021","9":"2.387471577","10":"0.016960","11":"895822","12":"COVID:_hospitalized_vs._population__eur_w/o_23andMe"},{"1":"rs279846","2":"4","3":"46329886","4":"C","5":"T","6":"0.4667","7":"-5.7384e-02","8":"0.023409","9":"-2.451364860","10":"0.014230","11":"907881","12":"COVID:_hospitalized_vs._population__eur_w/o_23andMe"},{"1":"rs992493","2":"4","3":"106180264","4":"T","5":"C","6":"0.8113","7":"7.9769e-02","8":"0.029124","9":"2.738943826","10":"0.006165","11":"907881","12":"COVID:_hospitalized_vs._population__eur_w/o_23andMe"},{"1":"rs12639706","2":"4","3":"157638546","4":"C","5":"T","6":"0.0926","7":"-7.3065e-02","8":"0.042184","9":"-1.732054808","10":"0.083270","11":"908494","12":"COVID:_hospitalized_vs._population__eur_w/o_23andMe"},{"1":"rs6923811","2":"6","3":"27289776","4":"T","5":"C","6":"0.2564","7":"3.1111e-02","8":"0.024563","9":"1.266579815","10":"0.205300","11":"908494","12":"COVID:_hospitalized_vs._population__eur_w/o_23andMe"},{"1":"rs34905321","2":"6","3":"109131107","4":"T","5":"C","6":"0.4313","7":"-2.9711e-02","8":"0.023699","9":"-1.253681590","10":"0.210000","11":"395372","12":"COVID:_hospitalized_vs._population__eur_w/o_23andMe"},{"1":"rs8180817","2":"7","3":"114047542","4":"G","5":"C","6":"0.4324","7":"4.4248e-03","8":"0.027807","9":"0.159125400","10":"0.873600","11":"898438","12":"COVID:_hospitalized_vs._population__eur_w/o_23andMe"},{"1":"rs9641536","2":"7","3":"114979967","4":"A","5":"T","6":"0.4731","7":"-5.6323e-02","8":"0.029606","9":"-1.902418429","10":"0.057110","11":"895822","12":"COVID:_hospitalized_vs._population__eur_w/o_23andMe"},{"1":"rs4841041","2":"8","3":"8654541","4":"C","5":"G","6":"0.7581","7":"-1.0408e-02","8":"0.026497","9":"-0.392799185","10":"0.694500","11":"908494","12":"COVID:_hospitalized_vs._population__eur_w/o_23andMe"},{"1":"rs7834566","2":"8","3":"33611488","4":"A","5":"G","6":"0.4850","7":"6.5728e-03","8":"0.027810","9":"0.236346638","10":"0.813200","11":"898438","12":"COVID:_hospitalized_vs._population__eur_w/o_23andMe"},{"1":"rs9650210","2":"8","3":"65496059","4":"C","5":"A","6":"0.1251","7":"2.7349e-03","8":"0.036011","9":"0.075946239","10":"0.939500","11":"634083","12":"COVID:_hospitalized_vs._population__eur_w/o_23andMe"},{"1":"rs7817124","2":"8","3":"81404008","4":"G","5":"C","6":"0.2107","7":"-2.5879e-02","8":"0.026278","9":"-0.984816196","10":"0.324700","11":"908494","12":"COVID:_hospitalized_vs._population__eur_w/o_23andMe"},{"1":"rs9630089","2":"10","3":"98968967","4":"G","5":"A","6":"0.5471","7":"-2.3382e-02","8":"0.030913","9":"-0.756380811","10":"0.449400","11":"895822","12":"COVID:_hospitalized_vs._population__eur_w/o_23andMe"},{"1":"rs7112324","2":"11","3":"29073285","4":"A","5":"T","6":"0.3529","7":"-5.6794e-03","8":"0.032194","9":"-0.176411754","10":"0.860000","11":"895822","12":"COVID:_hospitalized_vs._population__eur_w/o_23andMe"},{"1":"rs7951031","2":"11","3":"104303010","4":"C","5":"A","6":"0.1610","7":"3.8642e-02","8":"0.032940","9":"1.173102611","10":"0.240800","11":"634083","12":"COVID:_hospitalized_vs._population__eur_w/o_23andMe"},{"1":"rs6575642","2":"14","3":"98556621","4":"A","5":"G","6":"0.4714","7":"5.4273e-02","8":"0.030080","9":"1.804288564","10":"0.071190","11":"895822","12":"COVID:_hospitalized_vs._population__eur_w/o_23andMe"},{"1":"rs2098747","2":"16","3":"71358937","4":"G","5":"A","6":"0.2987","7":"1.3049e-02","8":"0.031652","9":"0.412264628","10":"0.680100","11":"895822","12":"COVID:_hospitalized_vs._population__eur_w/o_23andMe"},{"1":"rs62074192","2":"17","3":"16245127","4":"G","5":"A","6":"0.4956","7":"-1.6728e-02","8":"0.028090","9":"-0.595514418","10":"0.551500","11":"898438","12":"COVID:_hospitalized_vs._population__eur_w/o_23andMe"},{"1":"rs1382119","2":"18","3":"53459905","4":"C","5":"T","6":"0.3674","7":"8.9057e-03","8":"0.024174","9":"0.368399934","10":"0.712600","11":"907881","12":"COVID:_hospitalized_vs._population__eur_w/o_23andMe"},{"1":"rs28520003","2":"22","3":"46411969","4":"G","5":"A","6":"0.2935","7":"-4.1784e-02","8":"0.029880","9":"-1.398393574","10":"0.162000","11":"898438","12":"COVID:_hospitalized_vs._population__eur_w/o_23andMe"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

**Table 3:** Proxy SNPs for COVID: B2, w/o 23andMe
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["proxy.outcome"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["target_snp"],"name":[2],"type":["lgl"],"align":["right"]},{"label":["proxy_snp"],"name":[3],"type":["lgl"],"align":["right"]},{"label":["ld.r2"],"name":[4],"type":["lgl"],"align":["right"]},{"label":["Dprime"],"name":[5],"type":["lgl"],"align":["right"]},{"label":["ref.proxy"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["alt.proxy"],"name":[7],"type":["lgl"],"align":["right"]},{"label":["CHROM"],"name":[8],"type":["lgl"],"align":["right"]},{"label":["POS"],"name":[9],"type":["lgl"],"align":["right"]},{"label":["ALT.proxy"],"name":[10],"type":["lgl"],"align":["right"]},{"label":["REF.proxy"],"name":[11],"type":["lgl"],"align":["right"]},{"label":["AF"],"name":[12],"type":["lgl"],"align":["right"]},{"label":["BETA"],"name":[13],"type":["lgl"],"align":["right"]},{"label":["SE"],"name":[14],"type":["lgl"],"align":["right"]},{"label":["P"],"name":[15],"type":["lgl"],"align":["right"]},{"label":["N"],"name":[16],"type":["lgl"],"align":["right"]},{"label":["ref"],"name":[17],"type":["lgl"],"align":["right"]},{"label":["alt"],"name":[18],"type":["lgl"],"align":["right"]},{"label":["ALT"],"name":[19],"type":["lgl"],"align":["right"]},{"label":["REF"],"name":[20],"type":["lgl"],"align":["right"]},{"label":["PHASE"],"name":[21],"type":["lgl"],"align":["right"]}],"data":[{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA","13":"NA","14":"NA","15":"NA","16":"NA","17":"NA","18":"NA","19":"NA","20":"NA","21":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

## Data harmonization
Harmonize the exposure and outcome datasets so that the effect of a SNP on the exposure and the effect of that SNP on the outcome correspond to the same allele. The harmonise_data function from the TwoSampleMR package can be used to perform the harmonization step, by default it try's to infer the forward strand alleles using allele frequency information.
<br>

**Table 4:** Harmonized Risk tolerance and COVID: B2, w/o 23andMe datasets
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["effect_allele.exposure"],"name":[2],"type":["chr"],"align":["left"]},{"label":["other_allele.exposure"],"name":[3],"type":["chr"],"align":["left"]},{"label":["effect_allele.outcome"],"name":[4],"type":["chr"],"align":["left"]},{"label":["other_allele.outcome"],"name":[5],"type":["chr"],"align":["left"]},{"label":["beta.exposure"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["beta.outcome"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["eaf.exposure"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["eaf.outcome"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["remove"],"name":[10],"type":["lgl"],"align":["right"]},{"label":["palindromic"],"name":[11],"type":["lgl"],"align":["right"]},{"label":["ambiguous"],"name":[12],"type":["lgl"],"align":["right"]},{"label":["id.outcome"],"name":[13],"type":["chr"],"align":["left"]},{"label":["chr.outcome"],"name":[14],"type":["dbl"],"align":["right"]},{"label":["pos.outcome"],"name":[15],"type":["dbl"],"align":["right"]},{"label":["se.outcome"],"name":[16],"type":["dbl"],"align":["right"]},{"label":["z.outcome"],"name":[17],"type":["dbl"],"align":["right"]},{"label":["pval.outcome"],"name":[18],"type":["dbl"],"align":["right"]},{"label":["samplesize.outcome"],"name":[19],"type":["dbl"],"align":["right"]},{"label":["outcome"],"name":[20],"type":["chr"],"align":["left"]},{"label":["mr_keep.outcome"],"name":[21],"type":["lgl"],"align":["right"]},{"label":["pval_origin.outcome"],"name":[22],"type":["chr"],"align":["left"]},{"label":["chr.exposure"],"name":[23],"type":["dbl"],"align":["right"]},{"label":["pos.exposure"],"name":[24],"type":["dbl"],"align":["right"]},{"label":["se.exposure"],"name":[25],"type":["dbl"],"align":["right"]},{"label":["z.exposure"],"name":[26],"type":["dbl"],"align":["right"]},{"label":["pval.exposure"],"name":[27],"type":["dbl"],"align":["right"]},{"label":["samplesize.exposure"],"name":[28],"type":["dbl"],"align":["right"]},{"label":["exposure"],"name":[29],"type":["chr"],"align":["left"]},{"label":["mr_keep.exposure"],"name":[30],"type":["lgl"],"align":["right"]},{"label":["pval_origin.exposure"],"name":[31],"type":["chr"],"align":["left"]},{"label":["id.exposure"],"name":[32],"type":["chr"],"align":["left"]},{"label":["action"],"name":[33],"type":["dbl"],"align":["right"]},{"label":["mr_keep"],"name":[34],"type":["lgl"],"align":["right"]},{"label":["pt"],"name":[35],"type":["dbl"],"align":["right"]},{"label":["pleitropy_keep"],"name":[36],"type":["lgl"],"align":["right"]},{"label":["mrpresso_RSSobs"],"name":[37],"type":["dbl"],"align":["right"]},{"label":["mrpresso_pval"],"name":[38],"type":["dbl"],"align":["right"]},{"label":["mrpresso_keep"],"name":[39],"type":["lgl"],"align":["right"]}],"data":[{"1":"rs10865313","2":"G","3":"A","4":"G","5":"A","6":"0.01168","7":"3.6706e-02","8":"0.5672470","9":"0.6210","10":"FALSE","11":"FALSE","12":"FALSE","13":"cqCjw4","14":"2","15":"60117297","16":"0.023442","17":"1.565822029","18":"0.117400","19":"907881","20":"covidhgi2020anaB2v4eur","21":"TRUE","22":"reported","23":"2","24":"60117297","25":"0.00212","26":"5.509430","27":"3.785e-08","28":"466571","29":"Linner2019risk","30":"TRUE","31":"reported","32":"WA95hx","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"1.477001e-03","38":"1.0000","39":"TRUE"},{"1":"rs10914678","2":"T","3":"G","4":"T","5":"G","6":"0.01189","7":"-8.0173e-03","8":"0.3758080","9":"0.3774","10":"FALSE","11":"FALSE","12":"FALSE","13":"cqCjw4","14":"1","15":"33767228","16":"0.030623","17":"-0.261806485","18":"0.793500","19":"895822","20":"covidhgi2020anaB2v4eur","21":"TRUE","22":"reported","23":"1","24":"33767228","25":"0.00215","26":"5.530233","27":"3.452e-08","28":"466571","29":"Linner2019risk","30":"TRUE","31":"reported","32":"WA95hx","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"6.145276e-05","38":"1.0000","39":"TRUE"},{"1":"rs12617392","2":"A","3":"C","4":"A","5":"C","6":"-0.01171","7":"-6.8303e-05","8":"0.4502930","9":"0.4346","10":"FALSE","11":"FALSE","12":"FALSE","13":"cqCjw4","14":"2","15":"27336827","16":"0.027699","17":"-0.002465901","18":"0.998000","19":"898438","20":"covidhgi2020anaB2v4eur","21":"TRUE","22":"reported","23":"2","24":"27336827","25":"0.00211","26":"-5.549763","27":"2.808e-08","28":"466571","29":"Linner2019risk","30":"TRUE","31":"reported","32":"WA95hx","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"1.792255e-07","38":"1.0000","39":"TRUE"},{"1":"rs12639706","2":"T","3":"C","4":"T","5":"C","6":"0.01985","7":"-7.3065e-02","8":"0.0812904","9":"0.0926","10":"FALSE","11":"FALSE","12":"FALSE","13":"cqCjw4","14":"4","15":"157638546","16":"0.042184","17":"-1.732054808","18":"0.083270","19":"908494","20":"covidhgi2020anaB2v4eur","21":"TRUE","22":"reported","23":"4","24":"157638546","25":"0.00364","26":"5.453297","27":"4.883e-08","28":"466571","29":"Linner2019risk","30":"TRUE","31":"reported","32":"WA95hx","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"5.607693e-03","38":"1.0000","39":"TRUE"},{"1":"rs1382119","2":"T","3":"C","4":"T","5":"C","6":"0.01283","7":"8.9057e-03","8":"0.3588240","9":"0.3674","10":"FALSE","11":"FALSE","12":"FALSE","13":"cqCjw4","14":"18","15":"53459905","16":"0.024174","17":"0.368399934","18":"0.712600","19":"907881","20":"covidhgi2020anaB2v4eur","21":"TRUE","22":"reported","23":"18","24":"53459905","25":"0.00221","26":"5.805430","27":"6.093e-09","28":"466571","29":"Linner2019risk","30":"TRUE","31":"reported","32":"WA95hx","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"9.365830e-05","38":"1.0000","39":"TRUE"},{"1":"rs2098747","2":"A","3":"G","4":"A","5":"G","6":"0.01248","7":"1.3049e-02","8":"0.3119650","9":"0.2987","10":"FALSE","11":"FALSE","12":"FALSE","13":"cqCjw4","14":"16","15":"71358937","16":"0.031652","17":"0.412264628","18":"0.680100","19":"895822","20":"covidhgi2020anaB2v4eur","21":"TRUE","22":"reported","23":"16","24":"71358937","25":"0.00229","26":"5.449782","27":"4.887e-08","28":"466571","29":"Linner2019risk","30":"TRUE","31":"reported","32":"WA95hx","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"1.883730e-04","38":"1.0000","39":"TRUE"},{"1":"rs279846","2":"T","3":"C","4":"T","5":"C","6":"-0.01151","7":"-5.7384e-02","8":"0.4443490","9":"0.4667","10":"FALSE","11":"FALSE","12":"FALSE","13":"cqCjw4","14":"4","15":"46329886","16":"0.023409","17":"-2.451364860","18":"0.014230","19":"907881","20":"covidhgi2020anaB2v4eur","21":"TRUE","22":"reported","23":"4","24":"46329886","25":"0.00210","26":"-5.480952","27":"4.082e-08","28":"466571","29":"Linner2019risk","30":"TRUE","31":"reported","32":"WA95hx","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"3.578174e-03","38":"0.2704","39":"TRUE"},{"1":"rs283914","2":"C","3":"T","4":"C","5":"T","6":"-0.01201","7":"2.3116e-02","8":"0.4648750","9":"0.4619","10":"FALSE","11":"FALSE","12":"FALSE","13":"cqCjw4","14":"3","15":"17330649","16":"0.023162","17":"0.998013988","18":"0.318300","19":"907881","20":"covidhgi2020anaB2v4eur","21":"TRUE","22":"reported","23":"3","24":"17330649","25":"0.00210","26":"-5.719050","27":"1.039e-08","28":"466571","29":"Linner2019risk","30":"TRUE","31":"reported","32":"WA95hx","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"5.610236e-04","38":"1.0000","39":"TRUE"},{"1":"rs28520003","2":"A","3":"G","4":"A","5":"G","6":"-0.01253","7":"-4.1784e-02","8":"0.3065600","9":"0.2935","10":"FALSE","11":"FALSE","12":"FALSE","13":"cqCjw4","14":"22","15":"46411969","16":"0.029880","17":"-1.398393574","18":"0.162000","19":"898438","20":"covidhgi2020anaB2v4eur","21":"TRUE","22":"reported","23":"22","24":"46411969","25":"0.00228","26":"-5.495614","27":"4.017e-08","28":"466571","29":"Linner2019risk","30":"TRUE","31":"reported","32":"WA95hx","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"1.870944e-03","38":"1.0000","39":"TRUE"},{"1":"rs34905321","2":"C","3":"T","4":"C","5":"T","6":"-0.01205","7":"-2.9711e-02","8":"0.4229130","9":"0.4313","10":"FALSE","11":"FALSE","12":"FALSE","13":"cqCjw4","14":"6","15":"109131107","16":"0.023699","17":"-1.253681590","18":"0.210000","19":"395372","20":"covidhgi2020anaB2v4eur","21":"TRUE","22":"reported","23":"6","24":"109131107","25":"0.00211","26":"-5.710900","27":"1.209e-08","28":"466571","29":"Linner2019risk","30":"TRUE","31":"reported","32":"WA95hx","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"9.756421e-04","38":"1.0000","39":"TRUE"},{"1":"rs35068223","2":"T","3":"A","4":"T","5":"A","6":"0.01433","7":"-3.2113e-02","8":"0.2060360","9":"0.1997","10":"FALSE","11":"TRUE","12":"FALSE","13":"cqCjw4","14":"1","15":"204967186","16":"0.034454","17":"-0.932054333","18":"0.351300","19":"898438","20":"covidhgi2020anaB2v4eur","21":"TRUE","22":"reported","23":"1","24":"204967186","25":"0.00260","26":"5.511540","27":"3.472e-08","28":"466571","29":"Linner2019risk","30":"TRUE","31":"reported","32":"WA95hx","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"1.056692e-03","38":"1.0000","39":"TRUE"},{"1":"rs359243","2":"C","3":"T","4":"C","5":"T","6":"0.01190","7":"-6.3660e-03","8":"0.6176930","9":"0.6034","10":"FALSE","11":"FALSE","12":"FALSE","13":"cqCjw4","14":"2","15":"60475509","16":"0.028342","17":"-0.224613648","18":"0.822300","19":"897825","20":"covidhgi2020anaB2v4eur","21":"TRUE","22":"reported","23":"2","24":"60475509","25":"0.00214","26":"5.560750","27":"2.876e-08","28":"466571","29":"Linner2019risk","30":"TRUE","31":"reported","32":"WA95hx","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"3.811902e-05","38":"1.0000","39":"TRUE"},{"1":"rs3818802","2":"A","3":"G","4":"A","5":"G","6":"0.01361","7":"-2.5142e-02","8":"0.5271020","9":"0.5369","10":"FALSE","11":"FALSE","12":"FALSE","13":"cqCjw4","14":"1","15":"243449881","16":"0.023222","17":"-1.082680217","18":"0.278900","19":"908494","20":"covidhgi2020anaB2v4eur","21":"TRUE","22":"reported","23":"1","24":"243449881","25":"0.00211","26":"6.450237","27":"1.240e-10","28":"466571","29":"Linner2019risk","30":"TRUE","31":"reported","32":"WA95hx","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"6.779854e-04","38":"1.0000","39":"TRUE"},{"1":"rs4434184","2":"G","3":"A","4":"G","5":"A","6":"0.01751","7":"9.5549e-02","8":"0.1887900","9":"0.1713","10":"FALSE","11":"FALSE","12":"FALSE","13":"cqCjw4","14":"3","15":"181422854","16":"0.040021","17":"2.387471577","18":"0.016960","19":"895822","20":"covidhgi2020anaB2v4eur","21":"TRUE","22":"reported","23":"3","24":"181422854","25":"0.00273","26":"6.413920","27":"1.440e-10","28":"466571","29":"Linner2019risk","30":"TRUE","31":"reported","32":"WA95hx","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"9.762285e-03","38":"0.3952","39":"TRUE"},{"1":"rs4841041","2":"G","3":"C","4":"G","5":"C","6":"0.01499","7":"-1.0408e-02","8":"0.7707730","9":"0.7581","10":"FALSE","11":"TRUE","12":"FALSE","13":"cqCjw4","14":"8","15":"8654541","16":"0.026497","17":"-0.392799185","18":"0.694500","19":"908494","20":"covidhgi2020anaB2v4eur","21":"TRUE","22":"reported","23":"8","24":"8654541","25":"0.00245","26":"6.118370","27":"9.615e-10","28":"466571","29":"Linner2019risk","30":"TRUE","31":"reported","32":"WA95hx","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"1.092504e-04","38":"1.0000","39":"TRUE"},{"1":"rs62074192","2":"A","3":"G","4":"A","5":"G","6":"0.01172","7":"-1.6728e-02","8":"0.5105790","9":"0.4956","10":"FALSE","11":"FALSE","12":"FALSE","13":"cqCjw4","14":"17","15":"16245127","16":"0.028090","17":"-0.595514418","18":"0.551500","19":"898438","20":"covidhgi2020anaB2v4eur","21":"TRUE","22":"reported","23":"17","24":"16245127","25":"0.00209","26":"5.607656","27":"2.195e-08","28":"466571","29":"Linner2019risk","30":"TRUE","31":"reported","32":"WA95hx","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"2.824959e-04","38":"1.0000","39":"TRUE"},{"1":"rs62250712","2":"T","3":"C","4":"T","5":"C","6":"-0.02469","7":"8.9292e-03","8":"0.6113340","9":"0.6374","10":"FALSE","11":"FALSE","12":"FALSE","13":"cqCjw4","14":"3","15":"85513716","16":"0.023658","17":"0.377428354","18":"0.705900","19":"908494","20":"covidhgi2020anaB2v4eur","21":"TRUE","22":"reported","23":"3","24":"85513716","25":"0.00216","26":"-11.430556","27":"2.465e-30","28":"466571","29":"Linner2019risk","30":"TRUE","31":"reported","32":"WA95hx","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"9.489000e-05","38":"1.0000","39":"TRUE"},{"1":"rs6575642","2":"G","3":"A","4":"G","5":"A","6":"0.01178","7":"5.4273e-02","8":"0.4973980","9":"0.4714","10":"FALSE","11":"FALSE","12":"FALSE","13":"cqCjw4","14":"14","15":"98556621","16":"0.030080","17":"1.804288564","18":"0.071190","19":"895822","20":"covidhgi2020anaB2v4eur","21":"TRUE","22":"reported","23":"14","24":"98556621","25":"0.00210","26":"5.609520","27":"1.973e-08","28":"466571","29":"Linner2019risk","30":"TRUE","31":"reported","32":"WA95hx","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"3.120409e-03","38":"1.0000","39":"TRUE"},{"1":"rs6923811","2":"C","3":"T","4":"C","5":"T","6":"-0.01381","7":"3.1111e-02","8":"0.3212040","9":"0.2564","10":"FALSE","11":"FALSE","12":"FALSE","13":"cqCjw4","14":"6","15":"27289776","16":"0.024563","17":"1.266579815","18":"0.205300","19":"908494","20":"covidhgi2020anaB2v4eur","21":"TRUE","22":"reported","23":"6","24":"27289776","25":"0.00225","26":"-6.137780","27":"8.235e-10","28":"466571","29":"Linner2019risk","30":"TRUE","31":"reported","32":"WA95hx","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"1.035502e-03","38":"1.0000","39":"TRUE"},{"1":"rs7112324","2":"T","3":"A","4":"T","5":"A","6":"-0.01245","7":"-5.6794e-03","8":"0.3136740","9":"0.3529","10":"FALSE","11":"TRUE","12":"FALSE","13":"cqCjw4","14":"11","15":"29073285","16":"0.032194","17":"-0.176411754","18":"0.860000","19":"895822","20":"covidhgi2020anaB2v4eur","21":"TRUE","22":"reported","23":"11","24":"29073285","25":"0.00225","26":"-5.533330","27":"3.173e-08","28":"466571","29":"Linner2019risk","30":"TRUE","31":"reported","32":"WA95hx","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"3.818175e-05","38":"1.0000","39":"TRUE"},{"1":"rs7817124","2":"C","3":"G","4":"C","5":"G","6":"0.01591","7":"-2.5879e-02","8":"0.2717890","9":"0.2107","10":"FALSE","11":"TRUE","12":"FALSE","13":"cqCjw4","14":"8","15":"81404008","16":"0.026278","17":"-0.984816196","18":"0.324700","19":"908494","20":"covidhgi2020anaB2v4eur","21":"TRUE","22":"reported","23":"8","24":"81404008","25":"0.00246","26":"6.467480","27":"9.537e-11","28":"466571","29":"Linner2019risk","30":"TRUE","31":"reported","32":"WA95hx","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"7.202290e-04","38":"1.0000","39":"TRUE"},{"1":"rs7834566","2":"G","3":"A","4":"G","5":"A","6":"-0.01160","7":"6.5728e-03","8":"0.4803050","9":"0.4850","10":"FALSE","11":"FALSE","12":"FALSE","13":"cqCjw4","14":"8","15":"33611488","16":"0.027810","17":"0.236346638","18":"0.813200","19":"898438","20":"covidhgi2020anaB2v4eur","21":"TRUE","22":"reported","23":"8","24":"33611488","25":"0.00209","26":"-5.550240","27":"3.022e-08","28":"466571","29":"Linner2019risk","30":"TRUE","31":"reported","32":"WA95hx","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"4.087218e-05","38":"1.0000","39":"TRUE"},{"1":"rs7951031","2":"A","3":"C","4":"A","5":"C","6":"0.01640","7":"3.8642e-02","8":"0.1588700","9":"0.1610","10":"FALSE","11":"FALSE","12":"FALSE","13":"cqCjw4","14":"11","15":"104303010","16":"0.032940","17":"1.173102611","18":"0.240800","19":"634083","20":"covidhgi2020anaB2v4eur","21":"TRUE","22":"reported","23":"11","24":"104303010","25":"0.00295","26":"5.559322","27":"2.804e-08","28":"466571","29":"Linner2019risk","30":"TRUE","31":"reported","32":"WA95hx","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"1.646866e-03","38":"1.0000","39":"TRUE"},{"1":"rs8180817","2":"C","3":"G","4":"C","5":"G","6":"-0.01549","7":"4.4248e-03","8":"0.4630120","9":"0.4324","10":"FALSE","11":"TRUE","12":"TRUE","13":"cqCjw4","14":"7","15":"114047542","16":"0.027807","17":"0.159125400","18":"0.873600","19":"898438","20":"covidhgi2020anaB2v4eur","21":"TRUE","22":"reported","23":"7","24":"114047542","25":"0.00211","26":"-7.341232","27":"2.317e-13","28":"466571","29":"Linner2019risk","30":"TRUE","31":"reported","32":"WA95hx","33":"2","34":"FALSE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"NA"},{"1":"rs9630089","2":"A","3":"G","4":"A","5":"G","6":"-0.01181","7":"-2.3382e-02","8":"0.5645060","9":"0.5471","10":"FALSE","11":"FALSE","12":"FALSE","13":"cqCjw4","14":"10","15":"98968967","16":"0.030913","17":"-0.756380811","18":"0.449400","19":"895822","20":"covidhgi2020anaB2v4eur","21":"TRUE","22":"reported","23":"10","24":"98968967","25":"0.00212","26":"-5.570755","27":"2.336e-08","28":"466571","29":"Linner2019risk","30":"TRUE","31":"reported","32":"WA95hx","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"5.876621e-04","38":"1.0000","39":"TRUE"},{"1":"rs9641536","2":"T","3":"A","4":"T","5":"A","6":"-0.01265","7":"5.6323e-02","8":"0.5060670","9":"0.5269","10":"FALSE","11":"TRUE","12":"TRUE","13":"cqCjw4","14":"7","15":"114979967","16":"0.029606","17":"-1.902418429","18":"0.057110","19":"895822","20":"covidhgi2020anaB2v4eur","21":"TRUE","22":"reported","23":"7","24":"114979967","25":"0.00209","26":"-6.052630","27":"1.527e-09","28":"466571","29":"Linner2019risk","30":"TRUE","31":"reported","32":"WA95hx","33":"2","34":"FALSE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"NA"},{"1":"rs9650210","2":"A","3":"C","4":"A","5":"C","6":"-0.02158","7":"2.7349e-03","8":"0.1109790","9":"0.1251","10":"FALSE","11":"FALSE","12":"FALSE","13":"cqCjw4","14":"8","15":"65496059","16":"0.036011","17":"0.075946239","18":"0.939500","19":"634083","20":"covidhgi2020anaB2v4eur","21":"TRUE","22":"reported","23":"8","24":"65496059","25":"0.00331","26":"-6.519637","27":"6.730e-11","28":"466571","29":"Linner2019risk","30":"TRUE","31":"reported","32":"WA95hx","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"4.911215e-06","38":"1.0000","39":"TRUE"},{"1":"rs992493","2":"C","3":"T","4":"C","5":"T","6":"-0.01697","7":"7.9769e-02","8":"0.7908070","9":"0.8113","10":"FALSE","11":"FALSE","12":"FALSE","13":"cqCjw4","14":"4","15":"106180264","16":"0.029124","17":"2.738943826","18":"0.006165","19":"907881","20":"covidhgi2020anaB2v4eur","21":"TRUE","22":"reported","23":"4","24":"106180264","25":"0.00267","26":"-6.355810","27":"2.159e-10","28":"466571","29":"Linner2019risk","30":"TRUE","31":"reported","32":"WA95hx","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"6.950930e-03","38":"0.1118","39":"TRUE"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

SNPs that genome-wide significant in the outcome GWAS are likely pleitorpic and should be removed from analysis. Additionaly remove variants within the APOE locus by exclude variants 1MB either side of APOE e4 (rs429358 = 19:45411941, GRCh37.p13)
<br>


**Table 5:** SNPs that were genome-wide significant in the COVID: B2, w/o 23andMe GWAS
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
{"columns":[{"label":["outliers_removed"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["pve.exposure"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["F"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["Alpha"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["NCP"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["Power"],"name":[6],"type":["dbl"],"align":["right"]}],"data":[{"1":"FALSE","2":"0.002083927","3":"37.47207","4":"0.05","5":"0.01142287","6":"0.05130954"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

The I2_GX statistic can be used to quantify the strength of the NOME violation for MR-Egger regression and should be used to evalute potential bias in the MR-Egger causal estimate, with values less then 90% indicating that causal estimated should interpreted with caution due to regression diluation.

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["outliers_removed"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["Isq_gx"],"name":[2],"type":["dbl"],"align":["right"]}],"data":[{"1":"FALSE","2":"0.5576869"},{"1":"TRUE","2":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>


##  MR Results
To obtain an overall estimate of causal effect, the SNP-exposure and SNP-outcome coefficients were combined in 1) a fixed-effects meta-analysis using an inverse-variance weighted approach (IVW); 2) a Weighted Median approach; 3) Weighted Mode approach and 4) Egger Regression.


[**IVW**](https://doi.org/10.1002/gepi.21758) is equivalent to a weighted regression of the SNP-outcome coefficients on the SNP-exposure coefficients with the intercept constrained to zero. This method assumes that all variants are valid instrumental variables based on the Mendelian randomization assumptions. The causal estimate of the IVW analysis expresses the causal increase in the outcome (or log odds of the outcome for a binary outcome) per unit change in the exposure. [**Weighted median MR**](https://doi.org/10.1002/gepi.21965) allows for 50% of the instrumental variables to be invalid. [**MR-Egger regression**](https://doi.org/10.1093/ije/dyw220) allows all the instrumental variables to be subject to direct effects (i.e. horizontal pleiotropy), with the intercept representing bias in the causal estimate due to pleiotropy and the slope representing the causal estimate. [**Weighted Mode**](https://doi.org/10.1093/ije/dyx102) gives consistent estimates as the sample size increases if a plurality (or weighted plurality) of the genetic variants are valid instruments.
<br>



Table 6 presents the MR causal estimates of genetically predicted Risk tolerance on COVID: B2, w/o 23andMe.
<br>

**Table 6** MR causaul estimates for Risk tolerance on COVID: B2, w/o 23andMe
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["nsnp"],"name":[6],"type":["int"],"align":["right"]},{"label":["b"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"WA95hx","2":"cqCjw4","3":"covidhgi2020anaB2v4eur","4":"Linner2019risk","5":"Inverse variance weighted (fixed effects)","6":"26","7":"-0.02938368","8":"0.3806711","9":"0.9384731"},{"1":"WA95hx","2":"cqCjw4","3":"covidhgi2020anaB2v4eur","4":"Linner2019risk","5":"Weighted median","6":"26","7":"-0.39593647","8":"0.6183644","9":"0.5219800"},{"1":"WA95hx","2":"cqCjw4","3":"covidhgi2020anaB2v4eur","4":"Linner2019risk","5":"Weighted mode","6":"26","7":"-0.67034381","8":"0.8385200","9":"0.4315677"},{"1":"WA95hx","2":"cqCjw4","3":"covidhgi2020anaB2v4eur","4":"Linner2019risk","5":"MR Egger","6":"26","7":"-2.87949538","8":"1.9989736","9":"0.1626490"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Figure 1 illustrates the SNP-specific associations with Risk tolerance versus the association in COVID: B2, w/o 23andMe and the corresponding MR estimates.
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovideurwoukbb/Linner2019risk/covidhgi2020anaB2v4eur/Linner2019risk_5e-8_covidhgi2020anaB2v4eur_MR_Analaysis_files/figure-html/scatter_plot-1.png" alt="Fig. 1: Scatterplot of SNP effects for the association of the Exposure on the Outcome"  />
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
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["Q"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["Q_df"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["Q_pval"],"name":[8],"type":["dbl"],"align":["right"]}],"data":[{"1":"WA95hx","2":"cqCjw4","3":"covidhgi2020anaB2v4eur","4":"Linner2019risk","5":"MR Egger","6":"36.86127","7":"24","8":"0.04517426"},{"1":"WA95hx","2":"cqCjw4","3":"covidhgi2020anaB2v4eur","4":"Linner2019risk","5":"Inverse variance weighted","6":"40.16769","7":"25","8":"0.02802813"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Figure 2 shows a funnel plot displaying the MR estimates of individual genetic variants against their precession. Aysmmetry in the funnel plot may arrise due to some genetic variants having unusally strong effects on the outcome, which is indicative of directional pleiotropy.
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovideurwoukbb/Linner2019risk/covidhgi2020anaB2v4eur/Linner2019risk_5e-8_covidhgi2020anaB2v4eur_MR_Analaysis_files/figure-html/funnel_plot-1.png" alt="Fig. 2: Funnel plot of the MR causal estimates against their precession"  />
<p class="caption">Fig. 2: Funnel plot of the MR causal estimates against their precession</p>
</div>
<br>

Figure 3 shows a [Radial Plots](https://github.com/WSpiller/RadialMR) can be used to visualize influential data points with large contributions to Cochran's Q Statistic that may bias causal effect estimates.




```
## [1] "No significant Outliers"
```

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovideurwoukbb/Linner2019risk/covidhgi2020anaB2v4eur/Linner2019risk_5e-8_covidhgi2020anaB2v4eur_MR_Analaysis_files/figure-html/Radial_Plot-1.png" alt="Fig. 4: Radial Plot showing influential data points using Radial IVW"  />
<p class="caption">Fig. 4: Radial Plot showing influential data points using Radial IVW</p>
</div>
<br>

The intercept of the MR-Egger Regression model captures the average pleitropic affect across all genetic variants (Table 8).
<br>

**Table 8:** MR Egger test for directional pleitropy
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["egger_intercept"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[7],"type":["dbl"],"align":["right"]}],"data":[{"1":"WA95hx","2":"cqCjw4","3":"covidhgi2020anaB2v4eur","4":"Linner2019risk","5":"0.04210704","6":"0.02869824","7":"0.1552954"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Pleiotropy was also assesed using Mendelian Randomization Pleiotropy RESidual Sum and Outlier [(MR-PRESSO)](https://doi.org/10.1038/s41588-018-0099-7), that allows for the evlation of evaluation of horizontal pleiotropy in a standared MR model (Table 9). MR-PRESSO performs a global test for detection of horizontal pleiotropy and correction of pleiotropy via outlier removal (Table 10).
<br>

**Table 9:** MR-PRESSO Global Test for pleitropy
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["pt"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["outliers_removed"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["n_outliers"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["RSSobs"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"WA95hx","2":"cqCjw4","3":"covidhgi2020anaB2v4eur","4":"Linner2019risk","5":"5e-08","6":"FALSE","7":"0","8":"43.2634","9":"0.0312"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>


**Table 10:** MR Estimates after MR-PRESSO outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["nsnp"],"name":[6],"type":["int"],"align":["right"]},{"label":["b"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"WA95hx","2":"cqCjw4","3":"covidhgi2020anaB2v4eur","4":"Linner2019risk","5":"Inverse variance weighted (fixed effects)","6":"26","7":"-0.02938368","8":"0.3806711","9":"0.9384731"},{"1":"WA95hx","2":"cqCjw4","3":"covidhgi2020anaB2v4eur","4":"Linner2019risk","5":"Weighted median","6":"26","7":"-0.39593647","8":"0.6036069","9":"0.5118558"},{"1":"WA95hx","2":"cqCjw4","3":"covidhgi2020anaB2v4eur","4":"Linner2019risk","5":"Weighted mode","6":"26","7":"-0.67034381","8":"0.7819633","9":"0.3994462"},{"1":"WA95hx","2":"cqCjw4","3":"covidhgi2020anaB2v4eur","4":"Linner2019risk","5":"MR Egger","6":"26","7":"-2.87949538","8":"1.9989736","9":"0.1626490"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovideurwoukbb/Linner2019risk/covidhgi2020anaB2v4eur/Linner2019risk_5e-8_covidhgi2020anaB2v4eur_MR_Analaysis_files/figure-html/scatter_plot_outlier-1.png" alt="Fig. 5: Scatterplot of SNP effects for the association of the Exposure on the Outcome after outlier removal"  />
<p class="caption">Fig. 5: Scatterplot of SNP effects for the association of the Exposure on the Outcome after outlier removal</p>
</div>
<br>

**Table 11:** Heterogenity Tests after outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["Q"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["Q_df"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["Q_pval"],"name":[8],"type":["dbl"],"align":["right"]}],"data":[{"1":"WA95hx","2":"cqCjw4","3":"covidhgi2020anaB2v4eur","4":"Linner2019risk","5":"MR Egger","6":"36.86127","7":"24","8":"0.04517426"},{"1":"WA95hx","2":"cqCjw4","3":"covidhgi2020anaB2v4eur","4":"Linner2019risk","5":"Inverse variance weighted","6":"40.16769","7":"25","8":"0.02802813"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

**Table 12:** MR Egger test for directional pleitropy after outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["egger_intercept"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[7],"type":["dbl"],"align":["right"]}],"data":[{"1":"WA95hx","2":"cqCjw4","3":"covidhgi2020anaB2v4eur","4":"Linner2019risk","5":"0.04210704","6":"0.02869824","7":"0.1552954"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>
