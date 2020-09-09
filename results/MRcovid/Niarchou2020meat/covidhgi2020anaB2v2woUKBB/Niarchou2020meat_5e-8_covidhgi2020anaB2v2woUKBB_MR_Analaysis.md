---
title: "Mendelian Randomization Analysis"
author: "Dr. Shea Andrews"
date: "2020-08-27"
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

### Exposure: Meat related diet
`#r exposure.blurb`
<br>

**Table 1:** Independent SNPs associated with Meat related diet
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["CHROM"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["REF"],"name":[4],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[5],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[12],"type":["chr"],"align":["left"]}],"data":[{"1":"rs2815753","2":"1","3":"72812324","4":"G","5":"A","6":"0.601201","7":"-0.0183605","8":"0.00247730","9":"-7.41150","10":"1.2e-13","11":"335576","12":"meat_diet"},{"1":"rs506589","2":"1","3":"177894287","4":"T","5":"C","6":"0.206119","7":"-0.0164985","8":"0.00300566","9":"-5.48914","10":"4.0e-08","11":"335576","12":"meat_diet"},{"1":"rs36016753","2":"1","3":"187269477","4":"G","5":"A","6":"0.405961","7":"0.0139536","8":"0.00248123","9":"5.62366","10":"1.9e-08","11":"335576","12":"meat_diet"},{"1":"rs10900457","2":"1","3":"205146726","4":"G","5":"A","6":"0.621425","7":"-0.0143457","8":"0.00250486","9":"-5.72715","10":"1.0e-08","11":"335576","12":"meat_diet"},{"1":"rs62106258","2":"2","3":"417167","4":"T","5":"C","6":"0.048512","7":"0.0362759","8":"0.00564869","9":"6.42200","10":"1.3e-10","11":"335576","12":"meat_diet"},{"1":"rs7644667","2":"3","3":"69040601","4":"T","5":"C","6":"0.547560","7":"0.0142657","8":"0.00243810","9":"5.85115","10":"4.9e-09","11":"335576","12":"meat_diet"},{"1":"rs13340130","2":"3","3":"81790970","4":"A","5":"T","6":"0.346035","7":"0.0146033","8":"0.00255453","9":"5.71663","10":"1.1e-08","11":"335576","12":"meat_diet"},{"1":"rs701760","2":"4","3":"113439212","4":"C","5":"G","6":"0.483589","7":"-0.0134451","8":"0.00243618","9":"-5.51893","10":"3.4e-08","11":"335576","12":"meat_diet"},{"1":"rs300046","2":"5","3":"37081705","4":"A","5":"G","6":"0.453693","7":"0.0134073","8":"0.00245446","9":"5.46242","10":"4.7e-08","11":"335576","12":"meat_diet"},{"1":"rs10064431","2":"5","3":"92950673","4":"T","5":"C","6":"0.524467","7":"0.0159263","8":"0.00243369","9":"6.54410","10":"6.0e-11","11":"335576","12":"meat_diet"},{"1":"rs806794","2":"6","3":"26200677","4":"A","5":"G","6":"0.270603","7":"-0.0197927","8":"0.00273532","9":"-7.23597","10":"4.6e-13","11":"335576","12":"meat_diet"},{"1":"rs35797675","2":"7","3":"72878044","4":"T","5":"G","6":"0.212993","7":"-0.0199499","8":"0.00300577","9":"-6.63720","10":"3.2e-11","11":"335576","12":"meat_diet"},{"1":"rs11772832","2":"7","3":"135073047","4":"T","5":"C","6":"0.398899","7":"-0.0135343","8":"0.00248076","9":"-5.45571","10":"4.9e-08","11":"335576","12":"meat_diet"},{"1":"rs10125463","2":"9","3":"15677925","4":"A","5":"T","6":"0.506358","7":"0.0206152","8":"0.00244783","9":"8.42183","10":"3.7e-17","11":"335576","12":"meat_diet"},{"1":"rs6478868","2":"9","3":"131927092","4":"T","5":"C","6":"0.315903","7":"-0.0171298","8":"0.00262040","9":"-6.53709","10":"6.3e-11","11":"335576","12":"meat_diet"},{"1":"rs1912286","2":"10","3":"87318888","4":"G","5":"A","6":"0.665374","7":"0.0158809","8":"0.00257568","9":"6.16571","10":"7.0e-10","11":"335576","12":"meat_diet"},{"1":"rs3909727","2":"11","3":"126587382","4":"A","5":"G","6":"0.835788","7":"0.0185228","8":"0.00328005","9":"5.64711","10":"1.6e-08","11":"335576","12":"meat_diet"},{"1":"rs4759074","2":"12","3":"54664097","4":"C","5":"T","6":"0.410809","7":"0.0147949","8":"0.00246406","9":"6.00428","10":"1.9e-09","11":"335576","12":"meat_diet"},{"1":"rs12103229","2":"16","3":"74167594","4":"C","5":"A","6":"0.547810","7":"-0.0138449","8":"0.00244789","9":"-5.65585","10":"1.6e-08","11":"335576","12":"meat_diet"},{"1":"rs12232804","2":"19","3":"42677807","4":"C","5":"T","6":"0.112306","7":"0.0228620","8":"0.00385512","9":"5.93030","10":"3.0e-09","11":"335576","12":"meat_diet"},{"1":"rs429358","2":"19","3":"45411941","4":"T","5":"C","6":"0.155607","7":"-0.0242948","8":"0.00335552","9":"-7.24025","10":"4.5e-13","11":"335576","12":"meat_diet"},{"1":"rs79564737","2":"20","3":"43408372","4":"G","5":"A","6":"0.306786","7":"-0.0151755","8":"0.00264239","9":"-5.74310","10":"9.3e-09","11":"335576","12":"meat_diet"},{"1":"rs136528","2":"22","3":"27245262","4":"G","5":"C","6":"0.381980","7":"0.0149240","8":"0.00252151","9":"5.91868","10":"3.2e-09","11":"335576","12":"meat_diet"},{"1":"rs139911","2":"22","3":"40704052","4":"C","5":"T","6":"0.576683","7":"0.0141502","8":"0.00247127","9":"5.72588","10":"1.0e-08","11":"335576","12":"meat_diet"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

### Outcome: hospitalized covid vs. population wo/ UKBB
`#r outcome.blurb`
<br>

**Table 2:** SNPs associated with Meat related diet avaliable in hospitalized covid vs. population wo/ UKBB
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["CHROM"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["REF"],"name":[4],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[5],"type":["chr"],"align":["left"]},{"label":["AF"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[12],"type":["chr"],"align":["left"]}],"data":[{"1":"rs2815753","2":"1","3":"72812324","4":"G","5":"A","6":"0.6151180","7":"-0.04896800","8":"0.045870","9":"-1.06753870","10":"0.28570","11":"7","12":"COVID:_hospitalized_vs._population__woUKBB"},{"1":"rs506589","2":"1","3":"177894287","4":"T","5":"C","6":"0.1627910","7":"0.05483900","8":"0.060028","9":"0.91355701","10":"0.36090","11":"7","12":"COVID:_hospitalized_vs._population__woUKBB"},{"1":"rs36016753","2":"1","3":"187269477","4":"G","5":"A","6":"0.4233860","7":"-0.03335800","8":"0.043867","9":"-0.76043495","10":"0.44700","11":"7","12":"COVID:_hospitalized_vs._population__woUKBB"},{"1":"rs10900457","2":"1","3":"205146726","4":"G","5":"A","6":"0.5934310","7":"-0.05549500","8":"0.043909","9":"-1.26386390","10":"0.20630","11":"7","12":"COVID:_hospitalized_vs._population__woUKBB"},{"1":"rs62106258","2":"2","3":"417167","4":"T","5":"C","6":"0.0351322","7":"0.07810000","8":"0.099454","9":"0.78528767","10":"0.43230","11":"6","12":"COVID:_hospitalized_vs._population__woUKBB"},{"1":"rs7644667","2":"3","3":"69040601","4":"T","5":"C","6":"0.5276360","7":"-0.01931600","8":"0.043430","9":"-0.44476169","10":"0.65650","11":"7","12":"COVID:_hospitalized_vs._population__woUKBB"},{"1":"rs13340130","2":"3","3":"81790970","4":"A","5":"T","6":"0.3771860","7":"0.07332100","8":"0.052608","9":"1.39372339","10":"0.16340","11":"4","12":"COVID:_hospitalized_vs._population__woUKBB"},{"1":"rs701760","2":"4","3":"113439212","4":"C","5":"G","6":"0.4443840","7":"0.01560200","8":"0.043122","9":"0.36181068","10":"0.71750","11":"7","12":"COVID:_hospitalized_vs._population__woUKBB"},{"1":"rs300046","2":"5","3":"37081705","4":"A","5":"G","6":"0.4833940","7":"0.02658900","8":"0.043909","9":"0.60554784","10":"0.54480","11":"7","12":"COVID:_hospitalized_vs._population__woUKBB"},{"1":"rs10064431","2":"5","3":"92950673","4":"T","5":"C","6":"0.4847380","7":"-0.04057300","8":"0.042894","9":"-0.94588987","10":"0.34420","11":"7","12":"COVID:_hospitalized_vs._population__woUKBB"},{"1":"rs806794","2":"6","3":"26200677","4":"A","5":"G","6":"0.3497100","7":"0.00075418","8":"0.045450","9":"0.01659362","10":"0.98680","11":"7","12":"COVID:_hospitalized_vs._population__woUKBB"},{"1":"rs35797675","2":"7","3":"72878044","4":"T","5":"G","6":"0.2021910","7":"-0.06222200","8":"0.064606","9":"-0.96309940","10":"0.33550","11":"4","12":"COVID:_hospitalized_vs._population__woUKBB"},{"1":"rs11772832","2":"7","3":"135073047","4":"T","5":"C","6":"0.3783980","7":"-0.00451080","8":"0.044573","9":"-0.10120028","10":"0.91940","11":"7","12":"COVID:_hospitalized_vs._population__woUKBB"},{"1":"rs1912286","2":"10","3":"87318888","4":"G","5":"A","6":"0.7193400","7":"0.02054700","8":"0.044142","9":"0.46547506","10":"0.64160","11":"7","12":"COVID:_hospitalized_vs._population__woUKBB"},{"1":"rs3909727","2":"11","3":"126587382","4":"A","5":"G","6":"0.8397950","7":"0.00825770","8":"0.061497","9":"0.13427809","10":"0.89320","11":"6","12":"COVID:_hospitalized_vs._population__woUKBB"},{"1":"rs4759074","2":"12","3":"54664097","4":"C","5":"T","6":"0.4335880","7":"0.01163800","8":"0.045729","9":"0.25449933","10":"0.79910","11":"7","12":"COVID:_hospitalized_vs._population__woUKBB"},{"1":"rs12103229","2":"16","3":"74167594","4":"C","5":"A","6":"0.5579580","7":"-0.02359200","8":"0.043857","9":"-0.53793009","10":"0.59060","11":"7","12":"COVID:_hospitalized_vs._population__woUKBB"},{"1":"rs12232804","2":"19","3":"42677807","4":"C","5":"T","6":"0.0881381","7":"0.05569700","8":"0.070903","9":"0.78553799","10":"0.43210","11":"6","12":"COVID:_hospitalized_vs._population__woUKBB"},{"1":"rs429358","2":"19","3":"45411941","4":"T","5":"C","6":"0.1318100","7":"-0.12253000","8":"0.071193","9":"-1.72109618","10":"0.08522","11":"7","12":"COVID:_hospitalized_vs._population__woUKBB"},{"1":"rs79564737","2":"20","3":"43408372","4":"G","5":"A","6":"0.2762250","7":"-0.00746800","8":"0.047191","9":"-0.15825051","10":"0.87430","11":"7","12":"COVID:_hospitalized_vs._population__woUKBB"},{"1":"rs136528","2":"22","3":"27245262","4":"G","5":"C","6":"0.3930910","7":"0.00054522","8":"0.046195","9":"0.01180258","10":"0.99060","11":"7","12":"COVID:_hospitalized_vs._population__woUKBB"},{"1":"rs139911","2":"22","3":"40704052","4":"C","5":"T","6":"0.5937390","7":"0.03187800","8":"0.044283","9":"0.71986993","10":"0.47160","11":"7","12":"COVID:_hospitalized_vs._population__woUKBB"},{"1":"rs10125463","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA"},{"1":"rs6478868","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

**Table 3:** Proxy SNPs for hospitalized covid vs. population wo/ UKBB
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["target_snp"],"name":[1],"type":["chr"],"align":["left"]},{"label":["proxy_snp"],"name":[2],"type":["chr"],"align":["left"]},{"label":["ld.r2"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["Dprime"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["PHASE"],"name":[5],"type":["chr"],"align":["left"]},{"label":["X12"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["CHROM"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["POS"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["REF.proxy"],"name":[9],"type":["chr"],"align":["left"]},{"label":["ALT.proxy"],"name":[10],"type":["lgl"],"align":["right"]},{"label":["AF"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["BETA"],"name":[12],"type":["dbl"],"align":["right"]},{"label":["SE"],"name":[13],"type":["dbl"],"align":["right"]},{"label":["Z"],"name":[14],"type":["dbl"],"align":["right"]},{"label":["P"],"name":[15],"type":["dbl"],"align":["right"]},{"label":["N"],"name":[16],"type":["dbl"],"align":["right"]},{"label":["TRAIT"],"name":[17],"type":["chr"],"align":["left"]},{"label":["ref"],"name":[18],"type":["chr"],"align":["left"]},{"label":["ref.proxy"],"name":[19],"type":["lgl"],"align":["right"]},{"label":["alt"],"name":[20],"type":["chr"],"align":["left"]},{"label":["alt.proxy"],"name":[21],"type":["chr"],"align":["left"]},{"label":["ALT"],"name":[22],"type":["chr"],"align":["left"]},{"label":["REF"],"name":[23],"type":["chr"],"align":["left"]},{"label":["proxy.outcome"],"name":[24],"type":["lgl"],"align":["right"]}],"data":[{"1":"rs10125463","2":"rs6474946","3":"0.992051","4":"1","5":"TT/AC","6":"NA","7":"9","8":"15674969","9":"C","10":"TRUE","11":"0.504380","12":"0.0053554","13":"0.043531","14":"0.123025","15":"0.9021","16":"7","17":"COVID:_hospitalized_vs._population__woUKBB","18":"T","19":"TRUE","20":"A","21":"C","22":"T","23":"A","24":"TRUE"},{"1":"rs6478868","2":"rs12057089","3":"0.990173","4":"1","5":"CT/TC","6":"NA","7":"9","8":"131929957","9":"C","10":"TRUE","11":"0.264627","12":"-0.0606840","13":"0.049477","14":"-1.226509","15":"0.2200","16":"6","17":"COVID:_hospitalized_vs._population__woUKBB","18":"C","19":"TRUE","20":"T","21":"C","22":"C","23":"T","24":"TRUE"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

## Data harmonization
Harmonize the exposure and outcome datasets so that the effect of a SNP on the exposure and the effect of that SNP on the outcome correspond to the same allele. The harmonise_data function from the TwoSampleMR package can be used to perform the harmonization step, by default it try's to infer the forward strand alleles using allele frequency information.
<br>

**Table 4:** Harmonized Meat related diet and hospitalized covid vs. population wo/ UKBB datasets
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["SNP"],"name":[1],"type":["chr"],"align":["left"]},{"label":["effect_allele.exposure"],"name":[2],"type":["chr"],"align":["left"]},{"label":["other_allele.exposure"],"name":[3],"type":["chr"],"align":["left"]},{"label":["effect_allele.outcome"],"name":[4],"type":["chr"],"align":["left"]},{"label":["other_allele.outcome"],"name":[5],"type":["chr"],"align":["left"]},{"label":["beta.exposure"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["beta.outcome"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["eaf.exposure"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["eaf.outcome"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["remove"],"name":[10],"type":["lgl"],"align":["right"]},{"label":["palindromic"],"name":[11],"type":["lgl"],"align":["right"]},{"label":["ambiguous"],"name":[12],"type":["lgl"],"align":["right"]},{"label":["id.outcome"],"name":[13],"type":["chr"],"align":["left"]},{"label":["chr.outcome"],"name":[14],"type":["dbl"],"align":["right"]},{"label":["pos.outcome"],"name":[15],"type":["dbl"],"align":["right"]},{"label":["se.outcome"],"name":[16],"type":["dbl"],"align":["right"]},{"label":["z.outcome"],"name":[17],"type":["dbl"],"align":["right"]},{"label":["pval.outcome"],"name":[18],"type":["dbl"],"align":["right"]},{"label":["samplesize.outcome"],"name":[19],"type":["dbl"],"align":["right"]},{"label":["outcome"],"name":[20],"type":["chr"],"align":["left"]},{"label":["mr_keep.outcome"],"name":[21],"type":["lgl"],"align":["right"]},{"label":["pval_origin.outcome"],"name":[22],"type":["chr"],"align":["left"]},{"label":["chr.exposure"],"name":[23],"type":["dbl"],"align":["right"]},{"label":["pos.exposure"],"name":[24],"type":["dbl"],"align":["right"]},{"label":["se.exposure"],"name":[25],"type":["dbl"],"align":["right"]},{"label":["z.exposure"],"name":[26],"type":["dbl"],"align":["right"]},{"label":["pval.exposure"],"name":[27],"type":["dbl"],"align":["right"]},{"label":["samplesize.exposure"],"name":[28],"type":["dbl"],"align":["right"]},{"label":["exposure"],"name":[29],"type":["chr"],"align":["left"]},{"label":["mr_keep.exposure"],"name":[30],"type":["lgl"],"align":["right"]},{"label":["pval_origin.exposure"],"name":[31],"type":["chr"],"align":["left"]},{"label":["id.exposure"],"name":[32],"type":["chr"],"align":["left"]},{"label":["action"],"name":[33],"type":["dbl"],"align":["right"]},{"label":["mr_keep"],"name":[34],"type":["lgl"],"align":["right"]},{"label":["pt"],"name":[35],"type":["dbl"],"align":["right"]},{"label":["pleitropy_keep"],"name":[36],"type":["lgl"],"align":["right"]},{"label":["mrpresso_RSSobs"],"name":[37],"type":["lgl"],"align":["right"]},{"label":["mrpresso_pval"],"name":[38],"type":["lgl"],"align":["right"]},{"label":["mrpresso_keep"],"name":[39],"type":["lgl"],"align":["right"]}],"data":[{"1":"rs10064431","2":"C","3":"T","4":"C","5":"T","6":"0.0159263","7":"-0.04057300","8":"0.524467","9":"0.4847380","10":"FALSE","11":"FALSE","12":"FALSE","13":"ieOh27","14":"5","15":"92950673","16":"0.042894","17":"-0.94588987","18":"0.34420","19":"7","20":"covidhgi2020anaB2v2woUKBB","21":"TRUE","22":"reported","23":"5","24":"92950673","25":"0.00243369","26":"6.54410","27":"6.0e-11","28":"335576","29":"Niarchou2020meat","30":"TRUE","31":"reported","32":"TCva3t","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs10125463","2":"T","3":"A","4":"T","5":"A","6":"0.0206152","7":"0.00535540","8":"0.506358","9":"0.5043800","10":"FALSE","11":"TRUE","12":"TRUE","13":"ieOh27","14":"9","15":"15674969","16":"0.043531","17":"0.12302497","18":"0.90210","19":"7","20":"covidhgi2020anaB2v2woUKBB","21":"TRUE","22":"reported","23":"9","24":"15677925","25":"0.00244783","26":"8.42183","27":"3.7e-17","28":"335576","29":"Niarchou2020meat","30":"TRUE","31":"reported","32":"TCva3t","33":"2","34":"FALSE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"NA"},{"1":"rs10900457","2":"A","3":"G","4":"A","5":"G","6":"-0.0143457","7":"-0.05549500","8":"0.621425","9":"0.5934310","10":"FALSE","11":"FALSE","12":"FALSE","13":"ieOh27","14":"1","15":"205146726","16":"0.043909","17":"-1.26386390","18":"0.20630","19":"7","20":"covidhgi2020anaB2v2woUKBB","21":"TRUE","22":"reported","23":"1","24":"205146726","25":"0.00250486","26":"-5.72715","27":"1.0e-08","28":"335576","29":"Niarchou2020meat","30":"TRUE","31":"reported","32":"TCva3t","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs11772832","2":"C","3":"T","4":"C","5":"T","6":"-0.0135343","7":"-0.00451080","8":"0.398899","9":"0.3783980","10":"FALSE","11":"FALSE","12":"FALSE","13":"ieOh27","14":"7","15":"135073047","16":"0.044573","17":"-0.10120028","18":"0.91940","19":"7","20":"covidhgi2020anaB2v2woUKBB","21":"TRUE","22":"reported","23":"7","24":"135073047","25":"0.00248076","26":"-5.45571","27":"4.9e-08","28":"335576","29":"Niarchou2020meat","30":"TRUE","31":"reported","32":"TCva3t","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs12103229","2":"A","3":"C","4":"A","5":"C","6":"-0.0138449","7":"-0.02359200","8":"0.547810","9":"0.5579580","10":"FALSE","11":"FALSE","12":"FALSE","13":"ieOh27","14":"16","15":"74167594","16":"0.043857","17":"-0.53793009","18":"0.59060","19":"7","20":"covidhgi2020anaB2v2woUKBB","21":"TRUE","22":"reported","23":"16","24":"74167594","25":"0.00244789","26":"-5.65585","27":"1.6e-08","28":"335576","29":"Niarchou2020meat","30":"TRUE","31":"reported","32":"TCva3t","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs12232804","2":"T","3":"C","4":"T","5":"C","6":"0.0228620","7":"0.05569700","8":"0.112306","9":"0.0881381","10":"FALSE","11":"FALSE","12":"FALSE","13":"ieOh27","14":"19","15":"42677807","16":"0.070903","17":"0.78553799","18":"0.43210","19":"6","20":"covidhgi2020anaB2v2woUKBB","21":"TRUE","22":"reported","23":"19","24":"42677807","25":"0.00385512","26":"5.93030","27":"3.0e-09","28":"335576","29":"Niarchou2020meat","30":"TRUE","31":"reported","32":"TCva3t","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs13340130","2":"T","3":"A","4":"T","5":"A","6":"0.0146033","7":"0.07332100","8":"0.346035","9":"0.3771860","10":"FALSE","11":"TRUE","12":"FALSE","13":"ieOh27","14":"3","15":"81790970","16":"0.052608","17":"1.39372339","18":"0.16340","19":"4","20":"covidhgi2020anaB2v2woUKBB","21":"TRUE","22":"reported","23":"3","24":"81790970","25":"0.00255453","26":"5.71663","27":"1.1e-08","28":"335576","29":"Niarchou2020meat","30":"TRUE","31":"reported","32":"TCva3t","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs136528","2":"C","3":"G","4":"C","5":"G","6":"0.0149240","7":"0.00054522","8":"0.381980","9":"0.3930910","10":"FALSE","11":"TRUE","12":"FALSE","13":"ieOh27","14":"22","15":"27245262","16":"0.046195","17":"0.01180258","18":"0.99060","19":"7","20":"covidhgi2020anaB2v2woUKBB","21":"TRUE","22":"reported","23":"22","24":"27245262","25":"0.00252151","26":"5.91868","27":"3.2e-09","28":"335576","29":"Niarchou2020meat","30":"TRUE","31":"reported","32":"TCva3t","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs139911","2":"T","3":"C","4":"T","5":"C","6":"0.0141502","7":"0.03187800","8":"0.576683","9":"0.5937390","10":"FALSE","11":"FALSE","12":"FALSE","13":"ieOh27","14":"22","15":"40704052","16":"0.044283","17":"0.71986993","18":"0.47160","19":"7","20":"covidhgi2020anaB2v2woUKBB","21":"TRUE","22":"reported","23":"22","24":"40704052","25":"0.00247127","26":"5.72588","27":"1.0e-08","28":"335576","29":"Niarchou2020meat","30":"TRUE","31":"reported","32":"TCva3t","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs1912286","2":"A","3":"G","4":"A","5":"G","6":"0.0158809","7":"0.02054700","8":"0.665374","9":"0.7193400","10":"FALSE","11":"FALSE","12":"FALSE","13":"ieOh27","14":"10","15":"87318888","16":"0.044142","17":"0.46547506","18":"0.64160","19":"7","20":"covidhgi2020anaB2v2woUKBB","21":"TRUE","22":"reported","23":"10","24":"87318888","25":"0.00257568","26":"6.16571","27":"7.0e-10","28":"335576","29":"Niarchou2020meat","30":"TRUE","31":"reported","32":"TCva3t","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs2815753","2":"A","3":"G","4":"A","5":"G","6":"-0.0183605","7":"-0.04896800","8":"0.601201","9":"0.6151180","10":"FALSE","11":"FALSE","12":"FALSE","13":"ieOh27","14":"1","15":"72812324","16":"0.045870","17":"-1.06753870","18":"0.28570","19":"7","20":"covidhgi2020anaB2v2woUKBB","21":"TRUE","22":"reported","23":"1","24":"72812324","25":"0.00247730","26":"-7.41150","27":"1.2e-13","28":"335576","29":"Niarchou2020meat","30":"TRUE","31":"reported","32":"TCva3t","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs300046","2":"G","3":"A","4":"G","5":"A","6":"0.0134073","7":"0.02658900","8":"0.453693","9":"0.4833940","10":"FALSE","11":"FALSE","12":"FALSE","13":"ieOh27","14":"5","15":"37081705","16":"0.043909","17":"0.60554784","18":"0.54480","19":"7","20":"covidhgi2020anaB2v2woUKBB","21":"TRUE","22":"reported","23":"5","24":"37081705","25":"0.00245446","26":"5.46242","27":"4.7e-08","28":"335576","29":"Niarchou2020meat","30":"TRUE","31":"reported","32":"TCva3t","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs35797675","2":"G","3":"T","4":"G","5":"T","6":"-0.0199499","7":"-0.06222200","8":"0.212993","9":"0.2021910","10":"FALSE","11":"FALSE","12":"FALSE","13":"ieOh27","14":"7","15":"72878044","16":"0.064606","17":"-0.96309940","18":"0.33550","19":"4","20":"covidhgi2020anaB2v2woUKBB","21":"TRUE","22":"reported","23":"7","24":"72878044","25":"0.00300577","26":"-6.63720","27":"3.2e-11","28":"335576","29":"Niarchou2020meat","30":"TRUE","31":"reported","32":"TCva3t","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs36016753","2":"A","3":"G","4":"A","5":"G","6":"0.0139536","7":"-0.03335800","8":"0.405961","9":"0.4233860","10":"FALSE","11":"FALSE","12":"FALSE","13":"ieOh27","14":"1","15":"187269477","16":"0.043867","17":"-0.76043495","18":"0.44700","19":"7","20":"covidhgi2020anaB2v2woUKBB","21":"TRUE","22":"reported","23":"1","24":"187269477","25":"0.00248123","26":"5.62366","27":"1.9e-08","28":"335576","29":"Niarchou2020meat","30":"TRUE","31":"reported","32":"TCva3t","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs3909727","2":"G","3":"A","4":"G","5":"A","6":"0.0185228","7":"0.00825770","8":"0.835788","9":"0.8397950","10":"FALSE","11":"FALSE","12":"FALSE","13":"ieOh27","14":"11","15":"126587382","16":"0.061497","17":"0.13427809","18":"0.89320","19":"6","20":"covidhgi2020anaB2v2woUKBB","21":"TRUE","22":"reported","23":"11","24":"126587382","25":"0.00328005","26":"5.64711","27":"1.6e-08","28":"335576","29":"Niarchou2020meat","30":"TRUE","31":"reported","32":"TCva3t","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs429358","2":"C","3":"T","4":"C","5":"T","6":"-0.0242948","7":"-0.12253000","8":"0.155607","9":"0.1318100","10":"FALSE","11":"FALSE","12":"FALSE","13":"ieOh27","14":"19","15":"45411941","16":"0.071193","17":"-1.72109618","18":"0.08522","19":"7","20":"covidhgi2020anaB2v2woUKBB","21":"TRUE","22":"reported","23":"19","24":"45411941","25":"0.00335552","26":"-7.24025","27":"4.5e-13","28":"335576","29":"Niarchou2020meat","30":"TRUE","31":"reported","32":"TCva3t","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs4759074","2":"T","3":"C","4":"T","5":"C","6":"0.0147949","7":"0.01163800","8":"0.410809","9":"0.4335880","10":"FALSE","11":"FALSE","12":"FALSE","13":"ieOh27","14":"12","15":"54664097","16":"0.045729","17":"0.25449933","18":"0.79910","19":"7","20":"covidhgi2020anaB2v2woUKBB","21":"TRUE","22":"reported","23":"12","24":"54664097","25":"0.00246406","26":"6.00428","27":"1.9e-09","28":"335576","29":"Niarchou2020meat","30":"TRUE","31":"reported","32":"TCva3t","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs506589","2":"C","3":"T","4":"C","5":"T","6":"-0.0164985","7":"0.05483900","8":"0.206119","9":"0.1627910","10":"FALSE","11":"FALSE","12":"FALSE","13":"ieOh27","14":"1","15":"177894287","16":"0.060028","17":"0.91355701","18":"0.36090","19":"7","20":"covidhgi2020anaB2v2woUKBB","21":"TRUE","22":"reported","23":"1","24":"177894287","25":"0.00300566","26":"-5.48914","27":"4.0e-08","28":"335576","29":"Niarchou2020meat","30":"TRUE","31":"reported","32":"TCva3t","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs62106258","2":"C","3":"T","4":"C","5":"T","6":"0.0362759","7":"0.07810000","8":"0.048512","9":"0.0351322","10":"FALSE","11":"FALSE","12":"FALSE","13":"ieOh27","14":"2","15":"417167","16":"0.099454","17":"0.78528767","18":"0.43230","19":"6","20":"covidhgi2020anaB2v2woUKBB","21":"TRUE","22":"reported","23":"2","24":"417167","25":"0.00564869","26":"6.42200","27":"1.3e-10","28":"335576","29":"Niarchou2020meat","30":"TRUE","31":"reported","32":"TCva3t","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs6478868","2":"C","3":"T","4":"C","5":"T","6":"-0.0171298","7":"-0.06068400","8":"0.315903","9":"0.2646270","10":"FALSE","11":"FALSE","12":"FALSE","13":"ieOh27","14":"9","15":"131929957","16":"0.049477","17":"-1.22650929","18":"0.22000","19":"6","20":"covidhgi2020anaB2v2woUKBB","21":"TRUE","22":"reported","23":"9","24":"131927092","25":"0.00262040","26":"-6.53709","27":"6.3e-11","28":"335576","29":"Niarchou2020meat","30":"TRUE","31":"reported","32":"TCva3t","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs701760","2":"G","3":"C","4":"G","5":"C","6":"-0.0134451","7":"0.01560200","8":"0.483589","9":"0.4443840","10":"FALSE","11":"TRUE","12":"TRUE","13":"ieOh27","14":"4","15":"113439212","16":"0.043122","17":"0.36181068","18":"0.71750","19":"7","20":"covidhgi2020anaB2v2woUKBB","21":"TRUE","22":"reported","23":"4","24":"113439212","25":"0.00243618","26":"-5.51893","27":"3.4e-08","28":"335576","29":"Niarchou2020meat","30":"TRUE","31":"reported","32":"TCva3t","33":"2","34":"FALSE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"NA"},{"1":"rs7644667","2":"C","3":"T","4":"C","5":"T","6":"0.0142657","7":"-0.01931600","8":"0.547560","9":"0.5276360","10":"FALSE","11":"FALSE","12":"FALSE","13":"ieOh27","14":"3","15":"69040601","16":"0.043430","17":"-0.44476169","18":"0.65650","19":"7","20":"covidhgi2020anaB2v2woUKBB","21":"TRUE","22":"reported","23":"3","24":"69040601","25":"0.00243810","26":"5.85115","27":"4.9e-09","28":"335576","29":"Niarchou2020meat","30":"TRUE","31":"reported","32":"TCva3t","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs79564737","2":"A","3":"G","4":"A","5":"G","6":"-0.0151755","7":"-0.00746800","8":"0.306786","9":"0.2762250","10":"FALSE","11":"FALSE","12":"FALSE","13":"ieOh27","14":"20","15":"43408372","16":"0.047191","17":"-0.15825051","18":"0.87430","19":"7","20":"covidhgi2020anaB2v2woUKBB","21":"TRUE","22":"reported","23":"20","24":"43408372","25":"0.00264239","26":"-5.74310","27":"9.3e-09","28":"335576","29":"Niarchou2020meat","30":"TRUE","31":"reported","32":"TCva3t","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"},{"1":"rs806794","2":"G","3":"A","4":"G","5":"A","6":"-0.0197927","7":"0.00075418","8":"0.270603","9":"0.3497100","10":"FALSE","11":"FALSE","12":"FALSE","13":"ieOh27","14":"6","15":"26200677","16":"0.045450","17":"0.01659362","18":"0.98680","19":"7","20":"covidhgi2020anaB2v2woUKBB","21":"TRUE","22":"reported","23":"6","24":"26200677","25":"0.00273532","26":"-7.23597","27":"4.6e-13","28":"335576","29":"Niarchou2020meat","30":"TRUE","31":"reported","32":"TCva3t","33":"2","34":"TRUE","35":"5e-08","36":"TRUE","37":"NA","38":"NA","39":"TRUE"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

SNPs that genome-wide significant in the outcome GWAS are likely pleitorpic and should be removed from analysis. Additionaly remove variants within the APOE locus by exclude variants 1MB either side of APOE e4 (rs429358 = 19:45411941, GRCh37.p13)
<br>


**Table 5:** SNPs that were genome-wide significant in the hospitalized covid vs. population wo/ UKBB GWAS
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
{"columns":[{"label":["outliers_removed"],"name":[1],"type":["lgl"],"align":["right"]},{"label":["pve.exposure"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["F"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["Alpha"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["NCP"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["Power"],"name":[6],"type":["dbl"],"align":["right"]}],"data":[{"1":"FALSE","2":"0.002460751","3":"37.62497","4":"0.05","5":"35.71395","6":"0.9999704"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

##  MR Results
To obtain an overall estimate of causal effect, the SNP-exposure and SNP-outcome coefficients were combined in 1) a fixed-effects meta-analysis using an inverse-variance weighted approach (IVW); 2) a Weighted Median approach; 3) Weighted Mode approach and 4) Egger Regression.


[**IVW**](https://doi.org/10.1002/gepi.21758) is equivalent to a weighted regression of the SNP-outcome coefficients on the SNP-exposure coefficients with the intercept constrained to zero. This method assumes that all variants are valid instrumental variables based on the Mendelian randomization assumptions. The causal estimate of the IVW analysis expresses the causal increase in the outcome (or log odds of the outcome for a binary outcome) per unit change in the exposure. [**Weighted median MR**](https://doi.org/10.1002/gepi.21965) allows for 50% of the instrumental variables to be invalid. [**MR-Egger regression**](https://doi.org/10.1093/ije/dyw220) allows all the instrumental variables to be subject to direct effects (i.e. horizontal pleiotropy), with the intercept representing bias in the causal estimate due to pleiotropy and the slope representing the causal estimate. [**Weighted Mode**](https://doi.org/10.1093/ije/dyx102) gives consistent estimates as the sample size increases if a plurality (or weighted plurality) of the genetic variants are valid instruments.
<br>



Table 6 presents the MR causal estimates of genetically predicted Meat related diet on hospitalized covid vs. population wo/ UKBB.
<br>

**Table 6** MR causaul estimates for Meat related diet on hospitalized covid vs. population wo/ UKBB
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["nsnp"],"name":[6],"type":["int"],"align":["right"]},{"label":["b"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"TCva3t","2":"ieOh27","3":"covidhgi2020anaB2v2woUKBB","4":"Niarchou2020meat","5":"Inverse variance weighted (fixed effects)","6":"22","7":"1.243184","8":"0.6395782","9":"0.05192489"},{"1":"TCva3t","2":"ieOh27","3":"covidhgi2020anaB2v2woUKBB","4":"Niarchou2020meat","5":"Weighted median","6":"22","7":"1.430273","8":"0.8504924","9":"0.09262693"},{"1":"TCva3t","2":"ieOh27","3":"covidhgi2020anaB2v2woUKBB","4":"Niarchou2020meat","5":"Weighted mode","6":"22","7":"1.780357","8":"1.5233837","9":"0.25562637"},{"1":"TCva3t","2":"ieOh27","3":"covidhgi2020anaB2v2woUKBB","4":"Niarchou2020meat","5":"MR Egger","6":"22","7":"4.319306","8":"3.1906117","9":"0.19091639"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Figure 1 illustrates the SNP-specific associations with Meat related diet versus the association in hospitalized covid vs. population wo/ UKBB and the corresponding MR estimates.
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovid/Niarchou2020meat/covidhgi2020anaB2v2woUKBB/Niarchou2020meat_5e-8_covidhgi2020anaB2v2woUKBB_MR_Analaysis_files/figure-html/scatter_plot-1.png" alt="Fig. 1: Scatterplot of SNP effects for the association of the Exposure on the Outcome"  />
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
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["Q"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["Q_df"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["Q_pval"],"name":[8],"type":["dbl"],"align":["right"]}],"data":[{"1":"TCva3t","2":"ieOh27","3":"covidhgi2020anaB2v2woUKBB","4":"Niarchou2020meat","5":"MR Egger","6":"10.57544","7":"20","8":"0.9564987"},{"1":"TCva3t","2":"ieOh27","3":"covidhgi2020anaB2v2woUKBB","4":"Niarchou2020meat","5":"Inverse variance weighted","6":"11.54388","7":"21","8":"0.9511215"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Figure 2 shows a funnel plot displaying the MR estimates of individual genetic variants against their precession. Aysmmetry in the funnel plot may arrise due to some genetic variants having unusally strong effects on the outcome, which is indicative of directional pleiotropy.
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovid/Niarchou2020meat/covidhgi2020anaB2v2woUKBB/Niarchou2020meat_5e-8_covidhgi2020anaB2v2woUKBB_MR_Analaysis_files/figure-html/funnel_plot-1.png" alt="Fig. 2: Funnel plot of the MR causal estimates against their precession"  />
<p class="caption">Fig. 2: Funnel plot of the MR causal estimates against their precession</p>
</div>
<br>

Figure 3 shows a [Radial Plots](https://github.com/WSpiller/RadialMR) can be used to visualize influential data points with large contributions to Cochran's Q Statistic that may bias causal effect estimates.




```
## [1] "No significant Outliers"
```

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovid/Niarchou2020meat/covidhgi2020anaB2v2woUKBB/Niarchou2020meat_5e-8_covidhgi2020anaB2v2woUKBB_MR_Analaysis_files/figure-html/Radial_Plot-1.png" alt="Fig. 4: Radial Plot showing influential data points using Radial IVW"  />
<p class="caption">Fig. 4: Radial Plot showing influential data points using Radial IVW</p>
</div>
<br>

The intercept of the MR-Regression model captures the average pleitropic affect across all genetic variants (Table 8).
<br>

**Table 8:** MR Egger test for directional pleitropy
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["egger_intercept"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[7],"type":["dbl"],"align":["right"]}],"data":[{"1":"TCva3t","2":"ieOh27","3":"covidhgi2020anaB2v2woUKBB","4":"Niarchou2020meat","5":"-0.05151687","6":"0.05234968","7":"0.3368267"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

Pleiotropy was also assesed using Mendelian Randomization Pleiotropy RESidual Sum and Outlier [(MR-PRESSO)](https://doi.org/10.1038/s41588-018-0099-7), that allows for the evlation of evaluation of horizontal pleiotropy in a standared MR model (Table 9). MR-PRESSO performs a global test for detection of horizontal pleiotropy and correction of pleiotropy via outlier removal (Table 10).
<br>

**Table 9:** MR-PRESSO Global Test for pleitropy
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["chr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["chr"],"align":["left"]},{"label":["pt"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["outliers_removed"],"name":[6],"type":["lgl"],"align":["right"]},{"label":["n_outliers"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["RSSobs"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"TCva3t","2":"ieOh27","3":"covidhgi2020anaB2v2woUKBB","4":"Niarchou2020meat","5":"5e-08","6":"FALSE","7":"0","8":"12.66041","9":"0.9534"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>


**Table 10:** MR Estimates after MR-PRESSO outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["nsnp"],"name":[6],"type":["int"],"align":["right"]},{"label":["b"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[9],"type":["dbl"],"align":["right"]}],"data":[{"1":"TCva3t","2":"ieOh27","3":"covidhgi2020anaB2v2woUKBB","4":"Niarchou2020meat","5":"Inverse variance weighted (fixed effects)","6":"22","7":"1.243184","8":"0.6395782","9":"0.05192489"},{"1":"TCva3t","2":"ieOh27","3":"covidhgi2020anaB2v2woUKBB","4":"Niarchou2020meat","5":"Weighted median","6":"22","7":"1.430273","8":"0.8864459","9":"0.10663763"},{"1":"TCva3t","2":"ieOh27","3":"covidhgi2020anaB2v2woUKBB","4":"Niarchou2020meat","5":"Weighted mode","6":"22","7":"1.780357","8":"1.6231241","9":"0.28511713"},{"1":"TCva3t","2":"ieOh27","3":"covidhgi2020anaB2v2woUKBB","4":"Niarchou2020meat","5":"MR Egger","6":"22","7":"4.319306","8":"3.1906117","9":"0.19091639"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

<div class="figure" style="text-align: center">
<img src="/sc/arion/projects/LOAD/shea/Projects/MRcovid/results/MRcovid/Niarchou2020meat/covidhgi2020anaB2v2woUKBB/Niarchou2020meat_5e-8_covidhgi2020anaB2v2woUKBB_MR_Analaysis_files/figure-html/scatter_plot_outlier-1.png" alt="Fig. 5: Scatterplot of SNP effects for the association of the Exposure on the Outcome after outlier removal"  />
<p class="caption">Fig. 5: Scatterplot of SNP effects for the association of the Exposure on the Outcome after outlier removal</p>
</div>
<br>

**Table 11:** Heterogenity Tests after outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["method"],"name":[5],"type":["fctr"],"align":["left"]},{"label":["Q"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["Q_df"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["Q_pval"],"name":[8],"type":["dbl"],"align":["right"]}],"data":[{"1":"TCva3t","2":"ieOh27","3":"covidhgi2020anaB2v2woUKBB","4":"Niarchou2020meat","5":"MR Egger","6":"10.57544","7":"20","8":"0.9564987"},{"1":"TCva3t","2":"ieOh27","3":"covidhgi2020anaB2v2woUKBB","4":"Niarchou2020meat","5":"Inverse variance weighted","6":"11.54388","7":"21","8":"0.9511215"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>

**Table 12:** MR Egger test for directional pleitropy after outlier removal
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["id.exposure"],"name":[1],"type":["chr"],"align":["left"]},{"label":["id.outcome"],"name":[2],"type":["chr"],"align":["left"]},{"label":["outcome"],"name":[3],"type":["fctr"],"align":["left"]},{"label":["exposure"],"name":[4],"type":["fctr"],"align":["left"]},{"label":["egger_intercept"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["se"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["pval"],"name":[7],"type":["dbl"],"align":["right"]}],"data":[{"1":"TCva3t","2":"ieOh27","3":"covidhgi2020anaB2v2woUKBB","4":"Niarchou2020meat","5":"-0.05151687","6":"0.05234968","7":"0.3368267"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>
<br>
