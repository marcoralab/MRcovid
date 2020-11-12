# Causal effect of modifiable risk factors on COVID
Esimating the causal association of  potentially modifiable risk factors on COVID susceptibility using Mendelian randomization.

## Data Avaliability
### Exposures
Exposures were selected based on guidelines from the [CDC](https://www.cdc.gov/coronavirus/2019-ncov/need-extra-precautions/people-with-medical-conditions.html) and [OpenSafely](https://www.nature.com/articles/s41586-020-2521-4) that report risk factors assoicated with COVID-19 susceptibility, severity and mortality.

* `docs/covid_exposures.csv`: csv file listing the traits and respective GWAS used as exposures

### Outcomes
Genome-wide assocations studies for COIVD-19 susceptibility, severity, and outcomes were obtained from the [COVID-19 host genetics initiative](https://5f91b3fda119c20007acd6e6--condescending-perlman-ec107b.netlify.app/).

* `docs/covid_outcomes.csv`: csv file listing the traits used as outcomes

## Data Analysis
The Snakemake workflow management system was used implement pipelines for the PRS and MR anlaysis. The master work flow is `workflow/Snakefile` with `workflow/rules/mr.smk` used to implment the MR pipelines. This pipeline is a adapted from [Andrews et al (2020) Annals of Neurology](https://dx.doi.org/10.1002/ana.25918).

### MR

Mendelian randomization analysis was conducted using the TwoSampleMR package. Primary analysis was conducted using IVW to estimated causal relationships, while senstivity analysis were conducted using WME, WMBE, MR-Egger and MR-PRESSO.

Snakefile

* `workflow/rules/mr.smk`: workflow for implementing MR anlaysis

Configuration files

* `config_covid.yaml`: analysis parameters for MR analysis using A2, B1, B2, C2, all, without 23andMe as outcomes
* `config_covid_eur.yaml`: analysis parameters for MR analysis using , B2, C2, EUR only, without 23andMe as outcomes
* `config_covid_eur_wo_ukbb.yaml`: analysis parameters for MR analysis using A2, B2, C2, EUR, without 23andMe & UKBB as outcomes

Script files

* `workflow/scripts/mr_*`: script files for implementing spefific rules in MR workflow

Results

* `data/MRcovid`, `data/MRcovideur`, and `data/MRcovideurwoukbb` contain intermediatry files generated during MR workflow
* `results/MRcovid`, `results/MRcovideur`, and `results/MRcovideurwoukbb` contain final results for MR analysis
