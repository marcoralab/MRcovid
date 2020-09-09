'''Snakefile for Mendelian Randomization'''
#  snakemake -s DistanceClump.smk --use-conda

import os
from itertools import product
import pandas as pd
RWD = os.getcwd()

shell.prefix('module load plink/1.90 R/3.6.3; ')

# DataOut = "data/MR_ADbidir/"
# EXPOSURES = ["Lambert2013load", "Kunkle2019load", "Huang2017aaos", "Deming2017ab42", "Deming2017ptau", "Deming2017tau", "Hilbar2017hipv", "Hilbar2015hipv", "Grasby2020thickness", "Grasby2020surfarea", "Beecham2014npany", "Beecham2014braak4"]

DataOut = "data/MR_ADphenome/"
EXPOSURES = ["Lee2018education23andMe", "SanchezRoige2019auditt23andMe", "Liu2019drnkwk23andMe", "Yengo2018bmi", "Xue2018diab", "Niarchou2020meat", "Niarchou2020fish", "Willer2013hdl", "Willer2013ldl", "Willer2013tc", "Willer2013tg", "Dashti2019slepdur", "Klimentidis2018mvpa", "Day2018sociso", "Wells2019hdiff", "Evangelou2018dbp", "Evangelou2018sbp", "Evangelou2018pp", "Howard2019dep23andMe", "Jansen2018insomnia23andMe", "Liu2019smkint23andMe", "Liu2019smkcpd23andMe"]

# DataOut = "data/MR_ADbidir/"
# EXPOSURES = ["Kunkle2019load"]

PT = ['5e-8', '5e-6']
RLIB = "renv/library/R-3.6/x86_64-pc-linux-gnu"

rule all:
    input:
        expand("sandbox/distclump/{ExposureCode}_LBclump_{Pthreshold}_SNPs.txt", ExposureCode = EXPOSURES, Pthreshold = PT),
        expand("sandbox/distclump/{ExposureCode}_LSclump_{Pthreshold}_SNPs.txt", ExposureCode = EXPOSURES, Pthreshold = PT)

## Extract SNPs to be used as instruments in exposure
rule ExposureSnps:
    input:
        ss = DataOut + "{ExposureCode}/{ExposureCode}_formated.txt.gz",
        clump = DataOut + '{ExposureCode}/{ExposureCode}.clumped.gz'
    output:
        out_lb =  "sandbox/distclump/{ExposureCode}_LBclump_{Pthreshold}_SNPs.txt",
        out_ls = "sandbox/distclump/{ExposureCode}_LSclump_{Pthreshold}_SNPs.txt"
    params:
        pt = '{Pthreshold}',
        rlib = RLIB
    script: 'src/DistanceClumping.R'
