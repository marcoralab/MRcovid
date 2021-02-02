---
title: "Mendelian Randomization Analysis"
author: "Dr. Shea Andrews"
date: "2020-11-14"
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
**SNP Inclusion:** SNPS associated with at a p-value threshold of p < 5e-6 were included in this analysis.
<br>

**LD Clumping:** For standard two sample MR it is important to ensure that the instruments for the exposure are independent. LD clumping was performed in PLINK using the EUR samples from the 1000 Genomes Project to estimate LD between SNPs, and, amongst SNPs that have an LD above a given threshold, retain only the SNP with the lowest p-value. A clumping window of 10^{4}, r2 of 0.001 and significance level of 1 was used for the index and secondary SNPs.
<br>

**Proxy SNPs:** Where SNPs were not available in the outcome GWAS, the EUR thousand genomes was queried to identify potential proxy SNPs that are in linkage disequilibrium (r2 > 0.8) of the missing SNP.
<br>

### Exposure: Bipolar Disorder
`#r exposure.blurb`
<br>

**Table 1:** Independent SNPs associated with Bipolar Disorder
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["CHROM"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["REF"],"name":[4],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[5],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[12],"type":["chr"],"align":["left"]}],"data":[{"1":"rs147538909","2":"1","3":"115746","4":"C","5":"T","6":"0.0663616","7":"0.31050220","8":"0.0623","9":"4.983984","10":"6.235e-07","11":"51710","12":"Bipolar_Disorder"},{"1":"rs10950456","2":"7","3":"1979750","4":"G","5":"A","6":"0.6601750","7":"0.06510399","8":"0.0138","9":"4.717680","10":"2.376e-06","11":"51710","12":"Bipolar_Disorder"},{"1":"rs10744560","2":"12","3":"2387099","4":"C","5":"T","6":"0.3825880","7":"0.08320079","8":"0.0140","9":"5.942914","10":"2.918e-09","11":"51710","12":"Bipolar_Disorder"},{"1":"rs72673100","2":"14","3":"21673369","4":"C","5":"A","6":"0.4723940","7":"-0.07130268","8":"0.0149","9":"-4.785415","10":"1.760e-06","11":"51710","12":"Bipolar_Disorder"},{"1":"rs35955717","2":"14","3":"33395060","4":"T","5":"C","6":"0.1598980","7":"-0.09450080","8":"0.0198","9":"-4.772770","10":"1.892e-06","11":"51710","12":"Bipolar_Disorder"},{"1":"rs12898460","2":"15","3":"38986813","4":"C","5":"T","6":"0.2792510","7":"-0.07899992","8":"0.0146","9":"-5.410953","10":"6.354e-08","11":"51710","12":"Bipolar_Disorder"},{"1":"rs73406518","2":"15","3":"42847033","4":"C","5":"T","6":"0.0697457","7":"0.11850278","8":"0.0235","9":"5.042671","10":"4.593e-07","11":"51710","12":"Bipolar_Disorder"},{"1":"rs66506713","2":"17","3":"1819511","4":"C","5":"T","6":"0.4139250","7":"0.07179960","8":"0.0157","9":"4.573223","10":"4.989e-06","11":"51710","12":"Bipolar_Disorder"},{"1":"rs6051659","2":"20","3":"91508","4":"G","5":"A","6":"0.7921210","7":"-0.08379474","8":"0.0183","9":"-4.578947","10":"4.787e-06","11":"51710","12":"Bipolar_Disorder"},{"1":"rs6079463","2":"20","3":"14475757","4":"A","5":"G","6":"0.2045780","7":"0.09060330","8":"0.0167","9":"5.425350","10":"5.378e-08","11":"51710","12":"Bipolar_Disorder"},{"1":"rs6060023","2":"20","3":"33322119","4":"T","5":"C","6":"0.8821700","7":"0.08879840","8":"0.0181","9":"4.905990","10":"9.566e-07","11":"51710","12":"Bipolar_Disorder"},{"1":"rs1007893","2":"21","3":"47877594","4":"T","5":"C","6":"0.4994560","7":"0.06200310","8":"0.0134","9":"4.627090","10":"3.463e-06","11":"51710","12":"Bipolar_Disorder"},{"1":"rs5754941","2":"22","3":"22101995","4":"C","5":"G","6":"0.5456860","7":"-0.07030000","8":"0.0136","9":"-5.169120","10":"2.270e-07","11":"51710","12":"Bipolar_Disorder"},{"1":"rs138321","2":"22","3":"41209304","4":"G","5":"A","6":"0.5058220","7":"0.07930089","8":"0.0135","9":"5.874140","10":"4.692e-09","11":"51710","12":"Bipolar_Disorder"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

### Outcome: COVID: B2
`#r outcome.blurb`
<br>

**Table 2:** SNPs associated with Bipolar Disorder avaliable in COVID: B2
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["CHROM"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["REF"],"name":[4],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[5],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[12],"type":["chr"],"align":["left"]}],"data":[{"1":"rs10950456","2":"7","3":"1979750","4":"G","5":"A","6":"0.58380","7":"0.0214570","8":"0.029774","9":"0.7206623","10":"0.471100","11":"895822","12":"COVID:_hospitalized_vs._population__eur"},{"1":"rs10744560","2":"12","3":"2387099","4":"C","5":"T","6":"0.32970","7":"0.0265630","8":"0.029593","9":"0.8976109","10":"0.369400","11":"898438","12":"COVID:_hospitalized_vs._population__eur"},{"1":"rs72673100","2":"14","3":"21673369","4":"C","5":"A","6":"0.48530","7":"-0.0212730","8":"0.032363","9":"-0.6573247","10":"0.511000","11":"895209","12":"COVID:_hospitalized_vs._population__eur"},{"1":"rs35955717","2":"14","3":"33395060","4":"T","5":"C","6":"0.14860","7":"0.0120860","8":"0.040264","9":"0.3001689","10":"0.764000","11":"898438","12":"COVID:_hospitalized_vs._population__eur"},{"1":"rs12898460","2":"15","3":"38986813","4":"C","5":"T","6":"0.30490","7":"0.0188300","8":"0.024819","9":"0.7586929","10":"0.448000","11":"908494","12":"COVID:_hospitalized_vs._population__eur"},{"1":"rs73406518","2":"15","3":"42847033","4":"C","5":"T","6":"0.09544","7":"-0.0854900","8":"0.041001","9":"-2.0850711","10":"0.037060","11":"908494","12":"COVID:_hospitalized_vs._population__eur"},{"1":"rs66506713","2":"17","3":"1819511","4":"C","5":"T","6":"0.39870","7":"0.0074279","8":"0.030483","9":"0.2436735","10":"0.807500","11":"895822","12":"COVID:_hospitalized_vs._population__eur"},{"1":"rs6051659","2":"20","3":"91508","4":"G","5":"A","6":"0.80540","7":"-0.1049500","8":"0.037594","9":"-2.7916689","10":"0.005243","11":"898438","12":"COVID:_hospitalized_vs._population__eur"},{"1":"rs6079463","2":"20","3":"14475757","4":"A","5":"G","6":"0.20650","7":"0.0611590","8":"0.028339","9":"2.1581213","10":"0.030920","11":"908494","12":"COVID:_hospitalized_vs._population__eur"},{"1":"rs6060023","2":"20","3":"33322119","4":"T","5":"C","6":"0.84260","7":"-0.0426450","8":"0.031551","9":"-1.3516212","10":"0.176500","11":"908494","12":"COVID:_hospitalized_vs._population__eur"},{"1":"rs1007893","2":"21","3":"47877594","4":"T","5":"C","6":"0.49780","7":"0.0143470","8":"0.023008","9":"0.6235657","10":"0.532900","11":"908494","12":"COVID:_hospitalized_vs._population__eur"},{"1":"rs5754941","2":"22","3":"22101995","4":"C","5":"G","6":"0.53470","7":"0.0504680","8":"0.030648","9":"1.6466980","10":"0.099620","11":"895822","12":"COVID:_hospitalized_vs._population__eur"},{"1":"rs138321","2":"22","3":"41209304","4":"G","5":"A","6":"0.50440","7":"-0.0221660","8":"0.029940","9":"-0.7403474","10":"0.459100","11":"895209","12":"COVID:_hospitalized_vs._population__eur"},{"1":"rs147538909","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

**Table 3:** Proxy SNPs for COVID: B2
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["proxy.outcome"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["target_snp"],"name":[2],"type":["chr"],"align":["left"]},{"label":["proxy_snp"],"name":[3],"type":["lgl"],"align":["right"]},{"label":["ld.r2"],"name":[4],"type":["lgl"],"align":["right"]},{"label":["Dprime"],"name":[5],"type":["lgl"],"align":["right"]},{"label":["ref.proxy"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["alt.proxy"],"name":[7],"type":["lgl"],"align":["right"]},{"label":["CHROM"],"name":[8],"type":["lgl"],"align":["right"]},{"label":["POS"],"name":[9],"type":["lgl"],"align":["right"]},{"label":["ALT.proxy"],"name":[10],"type":["lgl"],"align":["right"]},{"label":["REF.proxy"],"name":[11],"type":["lgl"],"align":["right"]},{"label":["AF"],"name":[12],"type":["lgl"],"align":["right"]},{"label":["BETA"],"name":[13],"type":["lgl"],"align":["right"]},{"label":["SE"],"name":[14],"type":["lgl"],"align":["right"]},{"label":["P"],"name":[15],"type":["lgl"],"align":["right"]},{"label":["N"],"name":[16],"type":["lgl"],"align":["right"]},{"label":["ref"],"name":[17],"type":["lgl"],"align":["right"]},{"label":["alt"],"name":[18],"type":["lgl"],"align":["right"]},{"label":["ALT"],"name":[19],"type":["lgl"],"align":["right"]},{"label":["REF"],"name":[20],"type":["lgl"],"align":["right"]},{"label":["PHASE"],"name":[21],"type":["lgl"],"align":["right"]}],"data":[{"1":"NA","2":"rs147538909","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA","13":"NA","14":"NA","15":"NA","16":"NA","17":"NA","18":"NA","19":"NA","20":"NA","21":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

## Data harmonization
Harmonize the exposure and outcome datasets so that the effect of a SNP on the exposure and the effect of that SNP on the outcome correspond to the same allele. The harmonise_data function from the TwoSampleMR package can be used to perform the harmonization step, by default it try's to infer the forward strand alleles using allele frequency information.
<br>

**Table 4:** Harmonized Bipolar Disorder and COVID: B2 datasets
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["effect_allele.exposure"],"name":[2],"type":["chr"],"align":["left"]},{"label":["other_allele.exposure"],"name":[3],"type":["chr"],"align":["left"]},{"label":["effect_allele.outcome"],"name":[4],"type":["chr"],"align":["left"]},{"label":["other_allele.outcome"],"name":[5],"type":["chr"],"align":["left"]},{"label":["beta.exposure"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["beta.outcome"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["eaf.exposure"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["eaf.outcome"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["remove"],"name":[10],"type":["lgl"],"align":["right"]},{"label":["palindromic"],"name":[11],"type":["lgl"],"align":["right"]},{"label":["ambiguous"],"name":[12],"type":["lgl"],"align":["right"]},{"label":["id.outcome"],"name":[13],"type":["chr"],"align":["left"]},{"label":["chr.outcome"],"name":[14],"type":["dbl"],"align":["right"]},{"label":["pos.outcome"],"name":[15],"type":["dbl"],"align":["right"]},{"label":["se.outcome"],"name":[16],"type":["dbl"],"align":["right"]},{"label":["z.outcome"],"name":[17],"type":["dbl"],"align":["right"]},{"label":["pval.outcome"],"name":[18],"type":["dbl"],"align":["right"]},{"label":["samplesize.outcome"],"name":[19],"type":["dbl"],"align":["right"]},{"label":["outcome"],"name":[20],"type":["chr"],"align":["left"]},{"label":["mr_keep.outcome"],"name":[21],"type":["lgl"],"align":["right"]},{"label":["pval_origin.outcome"],"name":[22],"type":["chr"],"align":["left"]},{"label":["chr.exposure"],"name":[23],"type":["dbl"],"align":["right"]},{"label":["pos.exposure"],"name":[24],"type":["dbl"],"align":["right"]},{"label":["se.exposure"],"name":[25],"type":["dbl"],"align":["right"]},{"label":["z.exposure"],"name":[26],"type":["dbl"],"align":["right"]},{"label":["pval.exposure"],"name":[27],"type":["dbl"],"align":["right"]},{"label":["samplesize.exposure"],"name":[28],"type":["dbl"],"align":["right"]},{"label":["exposure"],"name":[29],"type":["chr"],"align":["left"]},{"label":["mr_keep.exposure"],"name":[30],"type":["lgl"],"align":["right"]},{"label":["pval_origin.exposure"],"name":[31],"type":["chr"],"align":["left"]},{"label":["id.exposure"],"name":[32],"type":["chr"],"align":["left"]},{"label":["action"],"name":[33],"type":["dbl"],"align":["right"]},{"label":["mr_keep"],"name":[34],"type":["lgl"],"align":["right"]},{"label":["pt"],"name":[35],"type":["dbl"],"align":["right"]},{"label":["pleitropy_keep"],"name":[36],"type":["lgl"],"align":["right"]},{"label":["mrpresso_RSSobs"],"name":[37],"type":["dbl"],"align":["right"]},{"label":["mrpresso_pval"],"name":[38],"type":["dbl"],"align":["right"]},{"label":["mrpresso_keep"],"name":[39],"type":["lgl"],"align":["right"]}],"data":[{"1":"rs1007893","2":"C","3":"T","4":"C","5":"T","6":"0.06200310","7":"0.0143470","8":"0.4994560","9":"0.49780","10":"FALSE","11":"FALSE","12":"FALSE","13":"eCmMO9","14":"21","15":"47877594","16":"0.023008","17":"0.6235657","18":"0.532900","19":"908494","20":"covidhgi2020anaB2v4eur","21":"TRUE","22":"reported","23":"21","24":"47877594","25":"0.0134","26":"4.627090","27":"3.463e-06","28":"51710","29":"Stahl2019bip","30":"TRUE","31":"reported","32":"fnAcTy","33":"2","34":"TRUE","35":"5e-06","36":"TRUE","37":"1.180975e-04","38":"1.0000","39":"TRUE"},{"1":"rs10744560","2":"T","3":"C","4":"T","5":"C","6":"0.08320079","7":"0.0265630","8":"0.3825880","9":"0.32970","10":"FALSE","11":"FALSE","12":"FALSE","13":"eCmMO9","14":"12","15":"2387099","16":"0.029593","17":"0.8976109","18":"0.369400","19":"898438","20":"covidhgi2020anaB2v4eur","21":"TRUE","22":"reported","23":"12","24":"2387099","25":"0.0140","26":"5.942914","27":"2.918e-09","28":"51710","29":"Stahl2019bip","30":"TRUE","31":"reported","32":"fnAcTy","33":"2","34":"TRUE","35":"5e-06","36":"TRUE","37":"5.185062e-04","38":"1.0000","39":"TRUE"},{"1":"rs10950456","2":"A","3":"G","4":"A","5":"G","6":"0.06510399","7":"0.0214570","8":"0.6601750","9":"0.58380","10":"FALSE","11":"FALSE","12":"FALSE","13":"eCmMO9","14":"7","15":"1979750","16":"0.029774","17":"0.7206623","18":"0.471100","19":"895822","20":"covidhgi2020anaB2v4eur","21":"TRUE","22":"reported","23":"7","24":"1979750","25":"0.0138","26":"4.717680","27":"2.376e-06","28":"51710","29":"Stahl2019bip","30":"TRUE","31":"reported","32":"fnAcTy","33":"2","34":"TRUE","35":"5e-06","36":"TRUE","37":"3.179633e-04","38":"1.0000","39":"TRUE"},{"1":"rs12898460","2":"T","3":"C","4":"T","5":"C","6":"-0.07899992","7":"0.0188300","8":"0.2792510","9":"0.30490","10":"FALSE","11":"FALSE","12":"FALSE","13":"eCmMO9","14":"15","15":"38986813","16":"0.024819","17":"0.7586929","18":"0.448000","19":"908494","20":"covidhgi2020anaB2v4eur","21":"TRUE","22":"reported","23":"15","24":"38986813","25":"0.0146","26":"-5.410953","27":"6.354e-08","28":"51710","29":"Stahl2019bip","30":"TRUE","31":"reported","32":"fnAcTy","33":"2","34":"TRUE","35":"5e-06","36":"TRUE","37":"7.721145e-04","38":"1.0000","39":"TRUE"},{"1":"rs138321","2":"A","3":"G","4":"A","5":"G","6":"0.07930089","7":"-0.0221660","8":"0.5058220","9":"0.50440","10":"FALSE","11":"FALSE","12":"FALSE","13":"eCmMO9","14":"22","15":"41209304","16":"0.029940","17":"-0.7403474","18":"0.459100","19":"895209","20":"covidhgi2020anaB2v4eur","21":"TRUE","22":"reported","23":"22","24":"41209304","25":"0.0135","26":"5.874140","27":"4.692e-09","28":"51710","29":"Stahl2019bip","30":"TRUE","31":"reported","32":"fnAcTy","33":"2","34":"TRUE","35":"5e-06","36":"TRUE","37":"9.199378e-04","38":"1.0000","39":"TRUE"},{"1":"rs35955717","2":"C","3":"T","4":"C","5":"T","6":"-0.09450080","7":"0.0120860","8":"0.1598980","9":"0.14860","10":"FALSE","11":"FALSE","12":"FALSE","13":"eCmMO9","14":"14","15":"33395060","16":"0.040264","17":"0.3001689","18":"0.764000","19":"898438","20":"covidhgi2020anaB2v4eur","21":"TRUE","22":"reported","23":"14","24":"33395060","25":"0.0198","26":"-4.772770","27":"1.892e-06","28":"51710","29":"Stahl2019bip","30":"TRUE","31":"reported","32":"fnAcTy","33":"2","34":"TRUE","35":"5e-06","36":"TRUE","37":"4.050576e-04","38":"1.0000","39":"TRUE"},{"1":"rs5754941","2":"G","3":"C","4":"G","5":"C","6":"-0.07030000","7":"0.0504680","8":"0.5456860","9":"0.53470","10":"FALSE","11":"TRUE","12":"TRUE","13":"eCmMO9","14":"22","15":"22101995","16":"0.030648","17":"1.6466980","18":"0.099620","19":"895822","20":"covidhgi2020anaB2v4eur","21":"TRUE","22":"reported","23":"22","24":"22101995","25":"0.0136","26":"-5.169120","27":"2.270e-07","28":"51710","29":"Stahl2019bip","30":"TRUE","31":"reported","32":"fnAcTy","33":"2","34":"FALSE","35":"5e-06","36":"TRUE","37":"NA","38":"NA","39":"NA"},{"1":"rs6051659","2":"A","3":"G","4":"A","5":"G","6":"-0.08379474","7":"-0.1049500","8":"0.7921210","9":"0.80540","10":"FALSE","11":"FALSE","12":"FALSE","13":"eCmMO9","14":"20","15":"91508","16":"0.037594","17":"-2.7916689","18":"0.005243","19":"898438","20":"covidhgi2020anaB2v4eur","21":"TRUE","22":"reported","23":"20","24":"91508","25":"0.0183","26":"-4.578947","27":"4.787e-06","28":"51710","29":"Stahl2019bip","30":"TRUE","31":"reported","32":"fnAcTy","33":"2","34":"TRUE","35":"5e-06","36":"TRUE","37":"1.106079e-02","38":"0.0660","39":"TRUE"},{"1":"rs6060023","2":"C","3":"T","4":"C","5":"T","6":"0.08879840","7":"-0.0426450","8":"0.8821700","9":"0.84260","10":"FALSE","11":"FALSE","12":"FALSE","13":"eCmMO9","14":"20","15":"33322119","16":"0.031551","17":"-1.3516212","18":"0.176500","19":"908494","20":"covidhgi2020anaB2v4eur","21":"TRUE","22":"reported","23":"20","24":"33322119","25":"0.0181","26":"4.905990","27":"9.566e-07","28":"51710","29":"Stahl2019bip","30":"TRUE","31":"reported","32":"fnAcTy","33":"2","34":"TRUE","35":"5e-06","36":"TRUE","37":"2.919622e-03","38":"1.0000","39":"TRUE"},{"1":"rs6079463","2":"G","3":"A","4":"G","5":"A","6":"0.09060330","7":"0.0611590","8":"0.2045780","9":"0.20650","10":"FALSE","11":"FALSE","12":"FALSE","13":"eCmMO9","14":"20","15":"14475757","16":"0.028339","17":"2.1581213","18":"0.030920","19":"908494","20":"covidhgi2020anaB2v4eur","21":"TRUE","22":"reported","23":"20","24":"14475757","25":"0.0167","26":"5.425350","27":"5.378e-08","28":"51710","29":"Stahl2019bip","30":"TRUE","31":"reported","32":"fnAcTy","33":"2","34":"TRUE","35":"5e-06","36":"TRUE","37":"3.873884e-03","38":"0.4068","39":"TRUE"},{"1":"rs66506713","2":"T","3":"C","4":"T","5":"C","6":"0.07179960","7":"0.0074279","8":"0.4139250","9":"0.39870","10":"FALSE","11":"FALSE","12":"FALSE","13":"eCmMO9","14":"17","15":"1819511","16":"0.030483","17":"0.2436735","18":"0.807500","19":"895822","20":"covidhgi2020anaB2v4eur","21":"TRUE","22":"reported","23":"17","24":"1819511","25":"0.0157","26":"4.573223","27":"4.989e-06","28":"51710","29":"Stahl2019bip","30":"TRUE","31":"reported","32":"fnAcTy","33":"2","34":"TRUE","35":"5e-06","36":"TRUE","37":"6.146852e-06","38":"1.0000","39":"TRUE"},{"1":"rs72673100","2":"A","3":"C","4":"A","5":"C","6":"-0.07130268","7":"-0.0212730","8":"0.4723940","9":"0.48530","10":"FALSE","11":"FALSE","12":"FALSE","13":"eCmMO9","14":"14","15":"21673369","16":"0.032363","17":"-0.6573247","18":"0.511000","19":"895209","20":"covidhgi2020anaB2v4eur","21":"TRUE","22":"reported","23":"14","24":"21673369","25":"0.0149","26":"-4.785415","27":"1.760e-06","28":"51710","29":"Stahl2019bip","30":"TRUE","31":"reported","32":"fnAcTy","33":"2","34":"TRUE","35":"5e-06","36":"TRUE","37":"2.953052e-04","38":"1.0000","39":"TRUE"},{"1":"rs73406518","2":"T","3":"C","4":"T","5":"C","6":"0.11850278","7":"-0.0854900","8":"0.0697457","9":"0.09544","10":"FALSE","11":"FALSE","12":"FALSE","13":"eCmMO9","14":"15","15":"42847033","16":"0.041001","17":"-2.0850711","18":"0.037060","19":"908494","20":"covidhgi2020anaB2v4eur","21":"TRUE","22":"reported","23":"15","24":"42847033","25":"0.0235","26":"5.042671","27":"4.593e-07","28":"51710","29":"Stahl2019bip","30":"TRUE","31":"reported","32":"fnAcTy","33":"2","34":"TRUE","35":"5e-06","36":"TRUE","37":"1.086479e-02","38":"0.1752","39":"TRUE"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
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
{"columns":[{"label":["outliers_removed"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["pve.exposure"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["F"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["Alpha"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["NCP"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["Power"],"name":[6],"type":["dbl"],"align":["right"]}],"data":[{"1":"FALSE","2":"0.005948158","3":"25.7785","4":"0.05","5":"0.400328","6":"0.09697471"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

##  MR Results
To obtain an overall estimate of causal effect, the SNP-exposure and SNP-outcome coefficients were combined in 1) a fixed-effects meta-analysis using an inverse-variance weighted approach (IVW); 2) a Weighted Median approach; 3) Weighted Mode approach and 4) Egger Regression.


[**IVW**](https://doi.org/10.1002/gepi.21758) is equivalent to a weighted regression of the SNP-outcome coefficients on the SNP-exposure coefficients with the intercept constrained to zero. This method assumes that all variants are valid instrumental variables based on the Mendelian randomization assumptions. The causal estimate of the IVW analysis expresses the causal increase in the outcome (or log odds of the outcome for a binary outcome) per unit change in the exposure. [**Weighted median MR**](https://doi.org/10.1002/gepi.21965) allows for 50% of the instrumental variables to be invalid. [**MR-Egger regression**](https://doi.org/10.1093/ije/dyw220) allows all the instrumental variables to be subject to direct effects (i.e. horizontal pleiotropy), with the intercept representing bias in the causal estimate due to pleiotropy and the slope representing the causal estimate. [**Weighted Mode**](https://doi.org/10.1093/ije/dyx102) gives consistent estimates as the sample size increases if a plurality (or weighted plurality) of the genetic variants are valid instruments.
<br>



Table 6 presents the MR causal estimates of genetically predicted Bipolar Disorder on COVID: B2.
<br>

**Table 6** MR causaul estimates for Bipolar Disorder on COVID: B2
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["nsnp"],"name":[6],"type":["int"],"align":["right"]},{"label":["b"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"fnAcTy","2":"eCmMO9","3":"covidhgi2020anaB2v4eur","4":"Stahl2019bip","5":"Inverse variance weighted (fixed effects)","6":"12","7":"0.07119054","8":"0.1088049","9":"0.5129216"},{"1":"fnAcTy","2":"eCmMO9","3":"covidhgi2020anaB2v4eur","4":"Stahl2019bip","5":"Weighted median","6":"12","7":"0.10176178","8":"0.1715896","9":"0.5531455"},{"1":"fnAcTy","2":"eCmMO9","3":"covidhgi2020anaB2v4eur","4":"Stahl2019bip","5":"Weighted mode","6":"12","7":"0.10343352","8":"0.3131790","9":"0.7474009"},{"1":"fnAcTy","2":"eCmMO9","3":"covidhgi2020anaB2v4eur","4":"Stahl2019bip","5":"MR Egger","6":"12","7":"-0.98529146","8":"0.9192763","9":"0.3089894"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Figure 1 illustrates the SNP-specific associations with Bipolar Disorder versus the association in COVID: B2 and the corresponding MR estimates.
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovideur/Stahl2019bip/covidhgi2020anaB2v4eur/Stahl2019bip_5e-6_covidhgi2020anaB2v4eur_MR_Analaysis_files/figure-html/scatter_plot-1.png" alt="Fig. 1: Scatterplot of SNP effects for the association of the Exposure on the Outcome"  />
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
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["Q"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["Q_df"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["Q_pval"],"name":[8],"type":["dbl"],"align":["right"]}],"data":[{"1":"fnAcTy","2":"eCmMO9","3":"covidhgi2020anaB2v4eur","4":"Stahl2019bip","5":"MR Egger","6":"19.03358","7":"10","8":"0.03983818"},{"1":"fnAcTy","2":"eCmMO9","3":"covidhgi2020anaB2v4eur","4":"Stahl2019bip","5":"Inverse variance weighted","6":"21.61638","7":"11","8":"0.02751944"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Figure 2 shows a funnel plot displaying the MR estimates of individual genetic variants against their precession. Aysmmetry in the funnel plot may arrise due to some genetic variants having unusally strong effects on the outcome, which is indicative of directional pleiotropy.
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovideur/Stahl2019bip/covidhgi2020anaB2v4eur/Stahl2019bip_5e-6_covidhgi2020anaB2v4eur_MR_Analaysis_files/figure-html/funnel_plot-1.png" alt="Fig. 2: Funnel plot of the MR causal estimates against their precession"  />
<p class="caption">Fig. 2: Funnel plot of the MR causal estimates against their precession</p>
</div>
<br>

Figure 3 shows a [Radial Plots](https://github.com/WSpiller/RadialMR) can be used to visualize influential data points with large contributions to Cochran's Q Statistic that may bias causal effect estimates.




```
## [1] "No significant Outliers"
```

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovideur/Stahl2019bip/covidhgi2020anaB2v4eur/Stahl2019bip_5e-6_covidhgi2020anaB2v4eur_MR_Analaysis_files/figure-html/Radial_Plot-1.png" alt="Fig. 4: Radial Plot showing influential data points using Radial IVW"  />
<p class="caption">Fig. 4: Radial Plot showing influential data points using Radial IVW</p>
</div>
<br>

The intercept of the MR-Regression model captures the average pleitropic affect across all genetic variants (Table 8).
<br>

**Table 8:** MR Egger test for directional pleitropy
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["egger_intercept"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[7],"type":["dbl"],"align":["right"]}],"data":[{"1":"fnAcTy","2":"eCmMO9","3":"covidhgi2020anaB2v4eur","4":"Stahl2019bip","5":"0.08599663","6":"0.07382387","7":"0.2710996"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Pleiotropy was also assesed using Mendelian Randomization Pleiotropy RESidual Sum and Outlier [(MR-PRESSO)](https://doi.org/10.1038/s41588-018-0099-7), that allows for the evlation of evaluation of horizontal pleiotropy in a standared MR model (Table 9). MR-PRESSO performs a global test for detection of horizontal pleiotropy and correction of pleiotropy via outlier removal (Table 10).
<br>

**Table 9:** MR-PRESSO Global Test for pleitropy
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["pt"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["outliers_removed"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["n_outliers"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["RSSobs"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"fnAcTy","2":"eCmMO9","3":"covidhgi2020anaB2v4eur","4":"Stahl2019bip","5":"5e-06","6":"FALSE","7":"0","8":"26.03771","9":"0.0309"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>


**Table 10:** MR Estimates after MR-PRESSO outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["nsnp"],"name":[6],"type":["int"],"align":["right"]},{"label":["b"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"fnAcTy","2":"eCmMO9","3":"covidhgi2020anaB2v4eur","4":"Stahl2019bip","5":"Inverse variance weighted (fixed effects)","6":"12","7":"0.07119054","8":"0.1088049","9":"0.5129216"},{"1":"fnAcTy","2":"eCmMO9","3":"covidhgi2020anaB2v4eur","4":"Stahl2019bip","5":"Weighted median","6":"12","7":"0.10176178","8":"0.1647972","9":"0.5369068"},{"1":"fnAcTy","2":"eCmMO9","3":"covidhgi2020anaB2v4eur","4":"Stahl2019bip","5":"Weighted mode","6":"12","7":"0.10343352","8":"0.2932105","9":"0.7309335"},{"1":"fnAcTy","2":"eCmMO9","3":"covidhgi2020anaB2v4eur","4":"Stahl2019bip","5":"MR Egger","6":"12","7":"-0.98529146","8":"0.9192763","9":"0.3089894"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovideur/Stahl2019bip/covidhgi2020anaB2v4eur/Stahl2019bip_5e-6_covidhgi2020anaB2v4eur_MR_Analaysis_files/figure-html/scatter_plot_outlier-1.png" alt="Fig. 5: Scatterplot of SNP effects for the association of the Exposure on the Outcome after outlier removal"  />
<p class="caption">Fig. 5: Scatterplot of SNP effects for the association of the Exposure on the Outcome after outlier removal</p>
</div>
<br>

**Table 11:** Heterogenity Tests after outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["Q"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["Q_df"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["Q_pval"],"name":[8],"type":["dbl"],"align":["right"]}],"data":[{"1":"fnAcTy","2":"eCmMO9","3":"covidhgi2020anaB2v4eur","4":"Stahl2019bip","5":"MR Egger","6":"19.03358","7":"10","8":"0.03983818"},{"1":"fnAcTy","2":"eCmMO9","3":"covidhgi2020anaB2v4eur","4":"Stahl2019bip","5":"Inverse variance weighted","6":"21.61638","7":"11","8":"0.02751944"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

**Table 12:** MR Egger test for directional pleitropy after outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["egger_intercept"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[7],"type":["dbl"],"align":["right"]}],"data":[{"1":"fnAcTy","2":"eCmMO9","3":"covidhgi2020anaB2v4eur","4":"Stahl2019bip","5":"0.08599663","6":"0.07382387","7":"0.2710996"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>
