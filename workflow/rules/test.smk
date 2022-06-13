'''Snakefile for LDSC GenCorr Estimates'''

import os
from itertools import product
import pandas as pd
from datetime import datetime

SAMPLE= config['SAMPLE']
G1= config['G1']
G2= config['G2']
EXCLUSION = pd.DataFrame.from_records(config["EXCLUSION"], index = "NAME")

rule all:
    input:
        # expand("data/raw/freeze5/{sample}.txt", sample = SAMPLE),
        expand("data/raw/freeze5/{sample}_rgformated.txt.gz", sample = SAMPLE),
        expand("data/raw/freeze5/{sample}.sumstats.gz", sample = SAMPLE),
        expand("data/raw/freeze5/{sample}_h2.log", sample = SAMPLE),
        expand("data/raw/freeze5/{g1}_{g2}_ldsc.log", g1 = G1, g2 = G2)

# rule unzip:
#      input: infile = "data/raw/GWAS/{sample}.chrall.CPRA_b37.tsv.gz"
#      output: outfile = "data/raw/freeze5/{sample}.txt"
#      conda: "../envs/plink.yaml"
#      shell: "gunzip -c {input.infile} > {output.outfile}"
#
# rule FormatGWAS:
#       input: infile = rules.unzip.output.outfile
#       output: outfile = "data/raw/freeze5/{sample}_fixed.txt"
#       conda: "../envs/mlr.yaml"
#       shell:
#           r"""
#          mlr --tsv --skip-comments rename DBSNP_ID,SNP \
#              {input.infile} > {output.outfile}
#           """

rule rgFormatGWAS:
    input: ss = "data/raw/freeze5/{sample}_formated.txt.gz"
    output: out = temp("data/raw/freeze5/{sample}_rgformated.txt.gz")
    params:
        regions_chrm = EXCLUSION["CHROM"],
        regions_start = EXCLUSION["START"],
        regions_stop = EXCLUSION["STOP"]
    conda: '../envs/r.yaml'
    script: '../scripts/rg_region_exclude.R'


rule munge:
    input: "data/raw/freeze5/{sample}_rgformated.txt.gz"
    output: temp("data/raw/freeze5/{sample}.sumstats.gz")
    params:
        out = 'data/raw/freeze5/{sample}'
    conda: "../envs/ldsc.yaml"
    shell:
        r"""
         workflow/src/ldsc/munge_sumstats.py --sumstats {input} \
            --ignore BETA, --a1 ALT --a2 REF \
            --merge-alleles workflow/src/ldsc/w_hm3.snplist \
            --out {output}
        """

rule heritability:
    input:
        ss = "data/raw/freeze5/{sample}.sumstats.gz"
    output:
        log = "data/raw/freeze5/{sample}_h2.log",
    params: "data/raw/freeze5/{sample}_h2"
    conda: "../envs/ldsc.yaml"
    shell:
        r"""
        workflow/src/ldsc/ldsc.py \
            --h2 {input.ss} \
            --ref-ld-chr workflow/src/ldsc/eur_ref_ld_chr/ \
            --w-ld-chr workflow/src/ldsc/eur_w_ld_chr/ \
            --out {output.log}
        """
rule LDSC:
    input:
        g1 = "data/raw/freeze5/{g1}.sumstats.gz",
        g2 = "data/raw/freeze5/{g2}.sumstats.gz"
    output:
        log = "data/raw/freeze5/{g1}_{g2}_ldsc.log"
    params: "data/raw/freeze5/{g1}_{g2}_ldsc"
    conda: "../envs/ldsc.yaml"
    shell:
        r"""
        workflow/src/ldsc/ldsc.py \
            --rg {input.g1},{input.g2} \
            --ref-ld-chr workflow/src/ldsc/eur_ref_ld_chr/ \
            --w-ld-chr workflow/src/ldsc/eur_w_ld_chr/ \
            --out {output.log};
        """
# the slope of the LD score regression represents the genetic correlation, while the intercept term of the LD score regression represents the phenotypic correlation
