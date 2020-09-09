'''Snakefile for Mendelian Randomization'''
#  snakemake -s Harmonization.smk --configfile config/harmonize.yaml

import os
from itertools import product
import pandas as pd
RWD = os.getcwd()

shell.prefix('module load plink/1.90 R/3.6.3; ')


REF = config['REF']
r2 = config['clumpr2']
kb = config['clumpkb']
RLIB = config['RLIB']
EXPOSURES = pd.DataFrame.from_records(config["EXPOSURES"], index = "CODE")
OUTCOMES = pd.DataFrame.from_records(config["OUTCOMES"], index = "CODE")
Pthreshold = config['Pthreshold']
DataOut = config['DataOut']
DataOutput = config['DataOutput']
EXCLUSION = pd.DataFrame.from_records(config["EXCLUSION"], index = "NAME")

print(EXCLUSION)
print(EXCLUSION["CHROM"].tolist())
print(EXCLUSION["START"])
print(EXCLUSION["STOP"])
localrules: all

# Filter forbidden wild card combinations
## https://stackoverflow.com/questions/41185567/how-to-use-expand-in-snakemake-when-some-particular-combinations-of-wildcards-ar
def filter_combinator(combinator, blacklist):
    def filtered_combinator(*args, **kwargs):
        for wc_comb in combinator(*args, **kwargs):
            # Use frozenset instead of tuple
            # in order to accomodate
            # unpredictable wildcard order
            if frozenset(wc_comb) not in blacklist:
                yield wc_comb
    return filtered_combinator

forbidden = {frozenset(wc_comb.items()) for wc_comb in config["missing"]}
filtered_product = filter_combinator(product, forbidden)

rule all:
    input:
        lambda wildcards: expand(DataOutput + "{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_MRdat.csv",
            filtered_product,
            ExposureCode=EXPOSURES.index.tolist(),
            OutcomeCode=OUTCOMES.index.tolist(),
            Pthreshold=Pthreshold)


rule Harmonize:
    input:
        ExposureSummary = DataOut + "{ExposureCode}/{ExposureCode}_{Pthreshold}_SNPs.txt",
        OutcomeSummary = DataOut + "{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_ProxySNPs.txt",
        ProxySNPs = DataOut + "{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_MatchedProxys.csv"
    output:
        Harmonized = DataOutput + "{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_MRdat.csv",
    params:
        Pthreshold = '{Pthreshold}',
        excposurecode = "{ExposureCode}",
        outcomecode = "{OutcomeCode}",
        regions_chrm = EXCLUSION["CHROM"].tolist(),
        regions_start = EXCLUSION["START"].tolist(),
        regions_stop = EXCLUSION["STOP"].tolist(),
        rlib = RLIB
    script: "sandbox/DataHarmonization.R"
