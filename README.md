# Causal effect of modifiable risk factors on the Alzheimer’s phenome
Esimating the causal associations between potentially modifiable risk factors and the Alzheimer’s phenome using Mendelian randomization.

Andrews, Shea J., Edoardo Marcora, and Alison M. Goate. 2019. “Causal Associations between Potentially Modifiable Risk Factors and the Alzheimer’s Phenome: A Mendelian Randomization Study.” [bioRxiv](https://doi.org/10.1101/689752)

## Abstract
**Background:** Potentially modifiable risk factors have been associated with Alzheimer’s disease (AD) that could be targeted to lifestyle interventions to reduce the prevalence of AD. However, the causality of these risk factors on AD is unclear. Using Mendelian randomization we evaluated the causal effect of potentially modifiable risk factors on AD and its associated endophenotypes.

**Methods and Findings:** Genetic instruments for the exposures were selected from genome wide association studies (GWAS) for traits previously linked to AD in observational studies including alcohol intake, physical activity, lipid traits, blood pressure traits, Type 2 diabetes, BMI, depression, sleep, social isolation, smoking, oily fish intake, and education. The outcomes included AD status, AD age of onset survival (AAOS), hippocampal volume, CSF levels of Aβ42, tau, and Ptau181, and neuropathological burden of neuritic plaques, neurofibrillary tangles, and vascular brain injury. MR estimates were calculated using an inverse variance weighted approach. Genetically predicted educational attainment (OR [CI]: 0.7 [0.63, 0.78]),  diastolic blood pressure DBP  (OR [CI]: 0.99 [0.98, 0.99]), systolic blood pressure (OR [CI]: 0.99 [0.99, 1]) and physical activity (OR [CI]: 2.5 [1.47, 4.23]) were causally associated with AD risk. Genetically predicted BMI (HR [CI]: 1.13 [1.07, 1.2]) and educational attainment (HR [CI]: 0.74 [0.68, 0.82]) were causally associated with AAOS. Genetically predicted alcohol consumption (β [CI]: -0.15 [-0.25, -0.05]), broad depressive symptoms (β [CI]: 0.5 [0.2, 0.8]), major depressive disorder (β [CI]: 0.12 [0.05, 0.18]) and physical activity were causally associated with CSF Aβ42 (β [CI]: 0.25 [0.1, 0.39]). Genetically predicted DBP was causally associated with CSF total Tau (β [CI]: -0.005 [-0.007, -0.002]). Increased risk of VBI were observed for genetically predicted DBP (OR [CI]: 1.05 [1.02, 1.08]), SBP (OR [CI]: 1.06 [1.03, 1.1]), and PP (OR [CI]: 1.03 [1.01, 1.05]). Increased risk of neuritic plaque burden were observed for genetically predicted LDL-cholesterol (OR [CI]: 1.87 [1.3, 2.69]) and total cholesterol (OR [CI]: 2.03 [1.44, 2.85]). Genetically predicted insomnia symptoms (β [CI]: -0.2 [-0.34, -0.06]) and total cholesterol were associated (β [CI]: -0.06 [-0.1, -0.03]) with hippocampal volume. Potential limitations include weak instrument bias, non-homogenous samples and other implicit limitations of MR analysis.

**Conclusions:** Demonstration of a causal relationship between blood pressure, cholesterol levels, BMI, depression, insomnia symptoms, physical activity and educational attainment on the AD phenome strongly support public health programs to educate the public about these preventable causes of AD.

## MR Analysis
Mendelian randomization was conducted using the [MR snakemake pipeline](https://github.com/marcoralab/MRPipeline). See the corresponding repo for more information.

## Data Avaliability
The data used in these analysis are either pubilicaly avaliable or were made avaliable by request from the authors. Summary Statistics were harmonized using the [Summary Statistic Munging pipeline](https://github.com/marcoralab/sumstats_munger).

Harmonized exposure - outcome SNP sets for conducting MR analysis can be found in `docs/TableS1.csv`.


Liu et al 2019 - https://genome.psych.umn.edu/index.php/GSCAN#Summary_Statistics <br>
Sanchez-Roige et al 2018 - by request <br>
Walters et al 2018 - https://www.med.unc.edu/pgc/data-index/ <br>
NealLab - http://www.nealelab.is/uk-biobank <br>
Xue et al 2018 - http://cnsgenomics.com/data.html <br>
Yengo et al 2018 - http://cnsgenomics.com/data.html <br>
Willer et al 2013 - http://csg.sph.umich.edu/willer/public/lipids2013/ <br>
Evangelou et al 2018 - by request <br>
Howard et al 2018 - https://datashare.is.ed.ac.uk/handle/10283/3083 <br>
Wray et al 2018 - https://www.med.unc.edu/pgc/data-index/ <br>
Jansen et al 2018 - https://ctg.cncr.nl/software/summary_statistics <br>
Dashti et al 2019 - http://sleepdisordergenetics.org/informational/data <br>
Day et al 2018 - https://www.repository.cam.ac.uk/handle/1810/277812 <br>
Lee et al 2018 - https://www.thessgac.org/data <br>
Lambert et al 2013 - https://www.niagads.org/datasets/ng00036 <br>
Kunkle et al 2019 - https://www.niagads.org/datasets/ng00075 <br>
Huang et al 2017 - https://www.niagads.org/datasets/ng00058 <br>
Beecham et al 2014 - https://www.niagads.org/datasets/ng00041 <br>
Deming et al 2017 - https://www.niagads.org/datasets/ng00055 <br>
Hibar et al 2015 - http://enigma.ini.usc.edu/research/download-enigma-gwas-results/ <br>
Hibar et al 2017 - http://enigma.ini.usc.edu/research/download-enigma-gwas-results/ <br>


## Shiny App
An interactive Shiny App is avaliable at: https://sjfandrews.shinyapps.io/MR_ADPhenome/

The shiny app can also be run localy using the `shiny/App.R` script by setting your working directory to `MR_ADPhenome/shiny` and running the following code.

```
setwd('MR_ADPhenome/shiny')
library(shiny)
runApp()
```

The following R packages are needed to run the shiny app:
```
tidyverse
TwoSampleMR
ggplot2
ggiraph
shinythemes
shiny
```
