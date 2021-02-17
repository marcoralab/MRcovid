'''Snakefile for HDL GenCorr Estimates'''

import os
from itertools import product
import pandas as pd
from datetime import date

# shell.prefix('module list R/3.6.3; ')
shell.prefix('module load R/4.0.3; ')

today_date = date.today()
traits = pd.read_csv(config['TRAITS_PATH'])
# traits = traits.iloc[0:2]
G1 = traits["g1"].tolist()
G2 = traits["g2"].tolist()
Project = config['PROJECT']
Project = [Project] * len(traits)
CODE = list(set(G1 + G2))
EXCLUSION = pd.DataFrame.from_records(config["EXCLUSION"], index = "NAME")

# print(traits)
# print(Project)
# print(G1)
# print(G2)

rule all:
    input:
        # "input/traits.csv",
        # expand("data/formated/{code}/{code}_rgformated.txt.gz", code = CODE),
        # expand("data/formated/ldsc/{code}.sumstats.gz", code = CODE),
        # expand("data/formated/hdl/{code}_formated.hdl.rds", code = CODE),
        expand("data/{project}/ldsc/{g1}_{g2}_ldsc.tsv", zip, g1 = G1, g2 = G2, project = Project),
        expand("data/{project}/hdl/{g1}_{g2}_HDL.tsv", zip, g1 = G1, g2 = G2, project = Project),
        expand("data/{project}/gnvoa/{g1}_{g2}_GNOVA.tsv", zip, g1 = G1, g2 = G2, project = Project),
        expand("data/{project}/supergnvoa/{g1}_{g2}_SUPERGNOVA.txt", zip, g1 = G1, g2 = G2, project = Project),
        expand("results/{project}/ldsc/all_results_ldsc_{DATE}.tsv", project = Project, DATE = today_date),
        expand("results/{project}/hdl/all_results_hdl_{DATE}.tsv", project = Project, DATE = today_date),
        expand("results/{project}/gnvoa/all_results_gnova_{DATE}.tsv", project = Project, DATE = today_date),
        expand("results/{project}/supergnvoa/all_results_supergnvoa_{DATE}.txt", project = Project, DATE = today_date)

# rule traits:
#     input: "raw/GWAS/"
#     output: "input/traits.csv",
#     shell: "Rscript scripts/traits.R"

rule FormatExposure:
    input: ss = "data/formated/{code}/{code}_formated.txt.gz"
    output: out = temp("data/formated/{code}/{code}_rgformated.txt.gz")
    params:
        regions_chrm = EXCLUSION["CHROM"],
        regions_start = EXCLUSION["START"],
        regions_stop = EXCLUSION["STOP"]
    script: '../scripts/rg_region_exclude.R'

rule HDLwrangle:
    input: "data/formated/{code}/{code}_rgformated.txt.gz"
    output: temp("data/formated/hdl/{code}_formated.hdl.rds")
    params:
        SNP = "SNP",
        A1 = "ALT",
        A2 = "REF",
        N = "N",
        Z = "Z",
        log = "data/formated/hdl/{code}_HDLformated_log",
        outfile = "data/formated/hdl/{code}_formated"
    shell:
        """
        Rscript src/HDL/HDL.data.wrangling.R \
        gwas.file={input} \
        LD.path=data/raw/UKB_imputed_SVD_eigen99_extraction \
        SNP={params.SNP} A1={params.A1} A2={params.A2} N={params.N} Z={params.Z} \
        output.file={params.outfile} \
        log.file={params.log}
        """

rule LDSCwrangle:
    input: "data/formated/{code}/{code}_rgformated.txt.gz"
    output: temp("data/formated/ldsc/{code}.sumstats.gz")
    params: out = 'data/formated/ldsc/{code}'
    conda: "../envs/py2.yaml"
    shell:
        """
        python2.7 src/ldsc/munge_sumstats.py --sumstats {input} \
            --ignore BETA, --a1 ALT --a2 REF \
            --merge-alleles src/ldsc/w_hm3.snplist \
            --out {params.out};
        Rscript workflow/scripts/rg_FormatGNOVA.R {output}
        """

rule LDSC:
    input:
        g1 = "data/formated/ldsc/{g1}.sumstats.gz",
        g2 = "data/formated/ldsc/{g2}.sumstats.gz"
    output:
        log = "data/{project}/ldsc/{g1}_{g2}_ldsc.log",
        rg = "data/{project}/ldsc/{g1}_{g2}_ldsc.tsv",
    params: "data/{project}/ldsc/{g1}_{g2}_ldsc"
    conda: "../envs/py2.yaml"
    shell:
        """
        src/ldsc/ldsc.py \
            --rg {input.g1},{input.g2} \
            --ref-ld-chr src/ldsc/eur_ref_ld_chr/ \
            --w-ld-chr src/ldsc/eur_w_ld_chr/ \
            --out {params};
        Rscript workflow/scripts/rg_extract_ldsc.R {output.log}
        """

rule aggregate_ldsc:
    input: expand("data/{project}/ldsc/{g1}_{g2}_ldsc.tsv", zip, g1 = G1, g2 = G2, project = Project)
    output: "results/{project}/ldsc/all_results_ldsc_{DATE}.tsv"
    shell: "awk 'FNR==1 && NR!=1{{next;}}{{print}}' {input} > {output}"

rule plot_ldsc:
    input: rg = "results/{project}/ldsc/all_results_ldsc_{DATE}.tsv"
    output:
        "results/{project}/ldsc/ldsc_heatmap_eur_{DATE}.png",
        "results/{project}/ldsc/ldsc_heatmap_eurLeaveUKB_{DATE}.png",
        "results/{project}/ldsc/ldsc_forest_eur_{DATE}.png",
        "results/{project}/ldsc/ldsc_forest_eurLeaveUKB_{DATE}.png",
    params:
        date = today_date,
        out = "results/{project}/ldsc/ldsc_"
    script: '../scripts/rg_plot_ldsc.R'

rule HDLrg:
    input:
        g1 = "data/formated/hdl/{g1}_formated.hdl.rds",
        g2 = "data/formated/hdl/{g2}_formated.hdl.rds"
    output:
        log = "data/{project}/hdl/{g1}_{g2}_HDL.Rout",
        rg = "data/{project}/hdl/{g1}_{g2}_HDL.tsv",
    shell:
        """
        Rscript src/HDL/HDL.run.R \
            gwas1.df={input.g1} \
            gwas2.df={input.g2} \
            LD.path=raw/UKB_imputed_SVD_eigen99_extraction \
            output.file={output};
        Rscript workflow/scripts/rg_extract_hdl.R {output.log}
        """

rule aggregate_hdl:
    input: expand("data/{project}/hdl/{g1}_{g2}_HDL.tsv", zip, g1 = G1, g2 = G2, project = Project)
    output: "results/{project}/hdl/all_results_hdl_{DATE}.tsv"
    shell: "awk 'FNR==1 && NR!=1{{next;}}{{print}}' {input} > {output}"

rule GNOVA:
    input:
        g1 = "data/formated/ldsc/{g1}.sumstats.gz",
        g2 = "data/formated/ldsc/{g2}.sumstats.gz"
    output:
        res = "data/{project}/gnvoa/{g1}_{g2}_GNOVA.txt",
        rg = "data/{project}/gnvoa/{g1}_{g2}_GNOVA.tsv"
    params:
        g1 = '{g1}',
        g2 = '{g2}',
    conda: "../envs/py2.yaml"
    shell:
        """
        python2.7 src/GNOVA/gnova.py {input.g1} {input.g2} \
            --bfile data/raw/bfiles/eur_chr@_SNPmaf5 \
            --out {output.res};
        Rscript workflow/scripts/rg_extract_gnova.R {output.res} {params.g1} {params.g2}
        """

rule aggregate_gnova:
    input: expand("data/{project}/gnvoa/{g1}_{g2}_GNOVA.tsv", zip, g1 = G1, g2 = G2, project = Project)
    output: "results/{project}/gnvoa/all_results_gnova_{DATE}.tsv"
    shell: "awk 'FNR==1 && NR!=1{{next;}}{{print}}' {input} > {output}"

rule SUPERGNOVA:
    input:
        g1 = "data/formated/ldsc/{g1}.sumstats.gz",
        g2 = "data/formated/ldsc/{g2}.sumstats.gz"
    output: "data/{project}/supergnvoa/{g1}_{g2}_SUPERGNOVA.txt"
    params:
        g1 = '{g1}',
        g2 = '{g2}',
    shell:
        """
        python3 src/SUPERGNOVA/supergnova.py {input.g1} {input.g2} \
            --bfile data/raw/bfiles/eur_chr@_SNPmaf5 \
            --partition src/SUPERGNOVA/partition/eur_chr@.bed \
            --thread 8 \
            --out {output};
        Rscript workflow/scripts/rg_extract_supergnova.R {output} {params.g1} {params.g2}
        """

rule aggregate_supergnova:
    input: expand("data/{project}/supergnvoa/{g1}_{g2}_SUPERGNOVA.txt", zip, g1 = G1, g2 = G2, project = Project)
    output: "results/{project}/supergnvoa/all_results_supergnvoa_{DATE}.txt"
    shell: "awk 'FNR==1 && NR!=1{{next;}}{{print}}' {input} > {output}"
