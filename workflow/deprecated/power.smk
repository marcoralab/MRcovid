# snakejob -s power.smk --configfile config.yaml -j 1000 --max-jobs-per-second 1 --keep-going --notemp

import os
from itertools import product
import pandas as pd
RWD = os.getcwd()

shell.prefix('module load plink/1.90 R/3.5.3; ')


REF = config['REF']
r2 = config['clumpr2']
kb = config['clumpkb']
EXPOSURES = pd.DataFrame.from_records(config["EXPOSURES"], index = "CODE")
OUTCOMES = pd.DataFrame.from_records(config["OUTCOMES"], index = "CODE")
Pthreshold = config['Pthreshold']
DataOut = config['DataOut']
DataOutput = config['DataOutput']

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
        DataOutput + 'All/power.txt'


rule power:
    input: infile = DataOut + "{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_mrpresso_MRdat.csv"
    output: outfile = DataOut + "{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_MR_power.txt"
    script: 'src/PowerEstimates_dos.R'

## define list of power estimates so they can be merged into a single file
def MR_power_input(wildcards):
    return expand(DataOut + "{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_MR_power.txt",
        filtered_product,
        ExposureCode=EXPOSURES.index.tolist(),
        OutcomeCode=OUTCOMES.index.tolist(),
        Pthreshold=Pthreshold)

rule merge_power:
    input: mr_power = MR_power_input
    output: DataOutput + 'All/power.txt'
    shell: "awk 'FNR==1 && NR!=1{{next;}}{{print}}' {input.mr_power} > {output}"
