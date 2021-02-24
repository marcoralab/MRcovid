'''Snakefile for Mendelian Randomization'''

import os
from itertools import product
import pandas as pd
from datetime import datetime
RWD = os.getcwd()

REF = config['REF']
r2 = config['clumpr2']
kb = config['clumpkb']
EXPOSURES = pd.DataFrame.from_records(config["EXPOSURES"], index = "CODE")
OUTCOMES = pd.DataFrame.from_records(config["OUTCOMES"], index = "CODE")
EXCLUSION = pd.DataFrame.from_records(config["EXCLUSION"], index = "NAME")
Pthreshold = config['Pthreshold']
Project = config['PROJECT']
now = datetime.now() # current date and time
today_date = now.strftime("%Y%m%d")

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
        lambda wildcards: expand("results/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_MR_Analaysis.html",
            filtered_product,
            ExposureCode=EXPOSURES.index.tolist(),
            OutcomeCode=OUTCOMES.index.tolist(),
            Pthreshold=Pthreshold,
            Project = Project),
        expand('results/formated/Manhattan/{ExposureCode}_ManhattanPlot.png',
            filtered_product,
            ExposureCode=EXPOSURES.index.tolist(), Project = Project),
        expand("results/{Project}/All/{DATE}/{Project}_MR_Analaysis.html", Project = Project, DATE = today_date),
        # expand('results/{Project}/All/{DATE}/mrpresso_MRdat.csv', Project = Project),
        # expand('results/{Project}/All/{DATE}/global_mrpresso.txt', Project = Project),
        # expand('results/{Project}/All/{DATE}/heterogenity.txt', Project = Project),
        # expand('results/{Project}/All/{DATE}/pleiotropy.txt', Project = Project),
        # expand('results/{Project}/All/{DATE}/MRresults.txt', Project = Project),
        # expand('results/{Project}/All/{DATE}/global_mrpresso_wo_outliers.txt', Project = Project),
        # expand('results/{Project}/All/{DATE}/power.txt', Project = Project),
        # expand('results/{Project}/All/{DATE}/steiger.txt', Project = Project),
        # expand("results/{Project}/All/{DATE}/{Project}_MRsummary.csv", Project = Project, DATE = today_date),
        # expand("results/{Project}/All/{DATE}/{Project}_WideMRResults.csv", Project = Project, DATE = today_date),
        # expand("results/{Project}/All/{DATE}/{Project}_MRbest.csv", Project = Project, DATE = today_date),
        # expand("results/{Project}/All/{DATE}/{Project}_PublicationRes.csv", Project = Project, DATE = today_date),
        # expand("results/{Project}/All/{DATE}/{Project}_heatmap{DATE}.png", Project = Project, DATE = today_date),

## Read in Exposure summar statistics and format them to input required for pipeline
## Formated summary stats are a temp file that is delted as the end
rule FormatExposure:
    input:
        ss = lambda wildcards: EXPOSURES.loc[wildcards.ExposureCode]['FILE'],
    output:
        formated_ss = temp("data/formated/{ExposureCode}/{ExposureCode}_formated.txt.gz")
    params:
        snp_col = lambda wildcards: EXPOSURES.loc[wildcards.ExposureCode]['COLUMNS']['SNP'],
        chrom_col = lambda wildcards: EXPOSURES.loc[wildcards.ExposureCode]['COLUMNS']['CHROM'],
        pos_col = lambda wildcards: EXPOSURES.loc[wildcards.ExposureCode]['COLUMNS']['POS'],
        ref_col = lambda wildcards: EXPOSURES.loc[wildcards.ExposureCode]['COLUMNS']['REF'],
        alt_col = lambda wildcards: EXPOSURES.loc[wildcards.ExposureCode]['COLUMNS']['ALT'],
        af_col = lambda wildcards: EXPOSURES.loc[wildcards.ExposureCode]['COLUMNS']['AF'],
        beta_col = lambda wildcards: EXPOSURES.loc[wildcards.ExposureCode]['COLUMNS']['BETA'],
        se_col = lambda wildcards: EXPOSURES.loc[wildcards.ExposureCode]['COLUMNS']['SE'],
        p_col = lambda wildcards: EXPOSURES.loc[wildcards.ExposureCode]['COLUMNS']['P'],
        z_col = lambda wildcards: EXPOSURES.loc[wildcards.ExposureCode]['COLUMNS']['Z'],
        n_col = lambda wildcards: EXPOSURES.loc[wildcards.ExposureCode]['COLUMNS']['N'],
        trait_col = lambda wildcards: EXPOSURES.loc[wildcards.ExposureCode]['COLUMNS']['TRAIT']
    conda: "../envs/r.yaml"
    script:
        '../scripts/mr_FormatGwas.R'

## Read in Outcome summary statistics and format them to input required for pipeline
## Formated summary stats are a temp file that is delted as the end
rule FormatOutcome:
    input:
        ss = lambda wildcards: OUTCOMES.loc[wildcards.OutcomeCode]['FILE'],
    output:
        formated_ss = temp("data/formated/{OutcomeCode}/{OutcomeCode}_formated.txt.gz")
    params:
        snp_col = lambda wildcards: OUTCOMES.loc[wildcards.OutcomeCode]['COLUMNS']['SNP'],
        chrom_col = lambda wildcards: OUTCOMES.loc[wildcards.OutcomeCode]['COLUMNS']['CHROM'],
        pos_col = lambda wildcards: OUTCOMES.loc[wildcards.OutcomeCode]['COLUMNS']['POS'],
        ref_col = lambda wildcards: OUTCOMES.loc[wildcards.OutcomeCode]['COLUMNS']['REF'],
        alt_col = lambda wildcards: OUTCOMES.loc[wildcards.OutcomeCode]['COLUMNS']['ALT'],
        af_col = lambda wildcards: OUTCOMES.loc[wildcards.OutcomeCode]['COLUMNS']['AF'],
        beta_col = lambda wildcards: OUTCOMES.loc[wildcards.OutcomeCode]['COLUMNS']['BETA'],
        se_col = lambda wildcards: OUTCOMES.loc[wildcards.OutcomeCode]['COLUMNS']['SE'],
        p_col = lambda wildcards: OUTCOMES.loc[wildcards.OutcomeCode]['COLUMNS']['P'],
        z_col = lambda wildcards: OUTCOMES.loc[wildcards.OutcomeCode]['COLUMNS']['Z'],
        n_col = lambda wildcards: OUTCOMES.loc[wildcards.OutcomeCode]['COLUMNS']['N'],
        trait_col = lambda wildcards: OUTCOMES.loc[wildcards.OutcomeCode]['COLUMNS']['TRAIT']
    conda: "../envs/r.yaml"
    script:
        '../scripts/mr_FormatGwas.R'

## Peform LD clumping on exposure summary statisitics
## user defines r2 and window in config file
rule clump:
    input:
        ss = "data/formated/{ExposureCode}/{ExposureCode}_formated.txt.gz"
    output:
        exp_clumped = temp('data/formated/{ExposureCode}/{ExposureCode}.clumped'),
        exp_clumped_zipped = 'data/formated/{ExposureCode}/{ExposureCode}.clumped.gz'
    params:
        ref = REF,
        out =  'data/formated/{ExposureCode}/{ExposureCode}',
        r2 = r2,
        kb = kb
    conda: "../envs/plink.yaml"
    shell:
        """
        plink --bfile {params.ref} --keep-allele-order --allow-no-sex --clump {input.ss}  --clump-r2 {params.r2} --clump-kb {params.kb} --clump-p1 1 --clump-p2 1 --out {params.out};
        #gzip -k {output.exp_clumped} --keep not working now??
        gzip {output.exp_clumped};
        zcat {output.exp_clumped_zipped} > {output.exp_clumped}
        """

## Extract SNPs to be used as instruments in exposure
rule ExposureSnps:
    input:
        summary = "data/formated/{ExposureCode}/{ExposureCode}_formated.txt.gz",
        ExposureClump = 'data/formated/{ExposureCode}/{ExposureCode}.clumped.gz'
    output:
        out = "data/{Project}/{ExposureCode}/{ExposureCode}_{Pthreshold}_SNPs.txt"
    params:
        Pthreshold = '{Pthreshold}'
    conda: "../envs/r.yaml"
    script:
        '../scripts/mr_ExposureData.R'

## Plot manhattan plot of exposure gwas highlight instruments
rule manhattan_plot:
    input:
        ingwas = "data/formated/{ExposureCode}/{ExposureCode}_formated.txt.gz",
        inclump = 'data/formated/{ExposureCode}/{ExposureCode}.clumped.gz'
    params:
        PlotTitle = "{ExposureCode}"
    output:
        out = 'results/formated/Manhattan/{ExposureCode}_ManhattanPlot.png'
    conda: "../envs/r.yaml"
    script:
        "../scripts/manhattan_plot.R"

## Extract exposure instruments from outcome gwas
rule OutcomeSnps:
    input:
        ExposureSummary = "data/{Project}/{ExposureCode}/{ExposureCode}_{Pthreshold}_SNPs.txt",
        OutcomeSummary = "data/formated/{OutcomeCode}/{OutcomeCode}_formated.txt.gz"
    output:
        "data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_SNPs.txt",
        "data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_MissingSNPs.txt",
    params:
        Outcome = "data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}",
    conda: "../envs/r.yaml"
    script:
        '../scripts/mr_OutcomeData.R'

## Use plink to identify proxy snps instruments that were not avaliable in the outcome
rule FindProxySnps:
    input:
        MissingSNPs = "data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_MissingSNPs.txt"
    output:
        ProxyList = "data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_Proxys.ld",
    params:
        Outcome = "data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_Proxys",
        ref = REF
    conda: "../envs/plink.yaml"
    shell:
        """
        if [ $(wc -l < {input.MissingSNPs}) -eq 0 ]; then
            touch {output.ProxyList}
          else
           plink --bfile {params.ref} \
           --keep-allele-order \
           --r2 dprime in-phase with-freqs \
           --ld-snp-list {input.MissingSNPs} \
           --ld-window-r2 0.8 --ld-window-kb 500 --ld-window 1000 --out {params.Outcome}
          fi
"""

## Extract proxy SNPs from outcome gwas
rule ExtractProxySnps:
    input:
        OutcomeSummary = "data/formated/{OutcomeCode}/{OutcomeCode}_formated.txt.gz",
        OutcomeProxys = "data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_Proxys.ld",
        OutcomeSNPs = "data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_SNPs.txt",
    output:
        "data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_ProxySNPs.txt",
        "data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_MatchedProxys.csv",
    params:
        Outcome = "data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}",
    conda: "../envs/r.yaml"
    script:
        '../scripts/mr_ExtractProxySNPs.R'

## Use TwoSampleMR to harmonize exposure and outcome datasets
rule Harmonize:
    input:
        ExposureSummary = "data/{Project}/{ExposureCode}/{ExposureCode}_{Pthreshold}_SNPs.txt",
        OutcomeSummary = "data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_ProxySNPs.txt",
        ProxySNPs = "data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_MatchedProxys.csv"
    output:
        Harmonized = "data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_MRdat.csv",
    params:
        Pthreshold = '{Pthreshold}',
        excposurecode = "{ExposureCode}",
        outcomecode = "{OutcomeCode}",
        regions_chrm = EXCLUSION["CHROM"],
        regions_start = EXCLUSION["START"],
        regions_stop = EXCLUSION["STOP"],
    conda: "../envs/r.yaml"
    script: "../scripts/mr_DataHarmonization.R"

## Use MR-PRESSO to conduct a global heterogenity test and
## outlier test to identify SNPs that are outliers
rule MrPresso:
    input:
        mrdat = "data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_MRdat.csv",
    output:
        "data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_mrpresso.txt",
        "data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_mrpresso_global.txt",
        "data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_mrpresso_res.txt",
        "data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_mrpresso_MRdat.csv"
    params:
        out = "data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_mrpresso"
    conda: "../envs/r.yaml"
    script:
        '../scripts/mr_MRPRESSO.R'

## Conduct a second MR-PRESSO test after removing outliers
rule MRPRESSO_wo_outliers:
    input:
        mrdat = "data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_mrpresso_MRdat.csv",
    output:
        "data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_mrpresso_global_wo_outliers.txt",
        "data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_mrpresso_res_wo_outliers.txt",
    params:
        out = "data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_mrpresso"
    conda: "../envs/r.yaml"
    script:
        '../scripts/mr_MRPRESSO_wo_outliers.R'

## Conduct MR analysis
rule MR_analysis:
    input:
        mrdat = "data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_mrpresso_MRdat.csv"
    output:
        'data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_MR_heterogenity.txt',
        'data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_MR_egger_plei.txt',
        'data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_MR_Results.txt'
    params:
        out = 'data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}'
    conda: "../envs/r.yaml"
    script: '../scripts/mr_analysis.R'

rule steiger:
    input:
        mrdat = "data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_mrpresso_MRdat.csv"
    output:
        outfile = 'data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_MR_steiger.txt'
    params:
        pt = "{Pthreshold}"
    conda: "../envs/r.yaml"
    script: '../scripts/mr_SteigerTest.R'

## define list of steiger estimates so they can be merged into a single file
def MR_steiger_input(wildcards):
    return expand("data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_MR_steiger.txt",
        filtered_product,
        ExposureCode=EXPOSURES.index.tolist(),
        OutcomeCode=OUTCOMES.index.tolist(),
        Pthreshold=Pthreshold,
        Project = Project)

rule merge_steiger:
    input: mr_steiger = MR_steiger_input
    output: 'results/{Project}/All/{DATE}/steiger.txt'
    shell: "awk 'FNR==1 && NR!=1{{next;}}{{print}}' {input.mr_steiger} > {output}"

rule power:
    input: infile = "data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_mrpresso_MRdat.csv"
    output: outfile = "data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_MR_power.txt"
    conda: "../envs/r.yaml"
    script: '../scripts/mr_PowerEstimates.R'

## define list of power estimates so they can be merged into a single file
def MR_power_input(wildcards):
    return expand("data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_MR_power.txt",
        filtered_product,
        ExposureCode=EXPOSURES.index.tolist(),
        OutcomeCode=OUTCOMES.index.tolist(),
        Pthreshold=Pthreshold,
        Project = Project)

rule merge_power:
    input: mr_power = MR_power_input
    output: 'results/{Project}/All/{DATE}/power.txt'
    shell: "awk 'FNR==1 && NR!=1{{next;}}{{print}}' {input.mr_power} > {output}"

## define list of harmonized datasets so they can be merged into a single file
def mrpresso_MRdat_input(wildcards):
    return expand("data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_mrpresso_MRdat.csv",
        filtered_product,
        ExposureCode=EXPOSURES.index.tolist(),
        OutcomeCode=OUTCOMES.index.tolist(),
        Pthreshold=Pthreshold,
        Project = Project)

rule merge_mrpresso_MRdat:
    input:
        dat = mrpresso_MRdat_input,
    output:
        out = 'results/{Project}/All/{DATE}/mrpresso_MRdat.csv'
    conda: "../envs/r.yaml"
    script:
        '../scripts/mr_ConcatMRdat.R'

## define list of global MR-PRESSO tests so they can be merged into a single file
def mrpresso_global_input(wildcards):
    return expand("data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_mrpresso_global.txt",
        filtered_product,
        ExposureCode=EXPOSURES.index.tolist(),
        OutcomeCode=OUTCOMES.index.tolist(),
        Pthreshold=Pthreshold,
        Project = Project)
def mrpresso_global_wo_outliers_input(wildcards):
    return expand("data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_mrpresso_global_wo_outliers.txt",
        filtered_product,
        ExposureCode=EXPOSURES.index.tolist(),
        OutcomeCode=OUTCOMES.index.tolist(),
        Pthreshold=Pthreshold,
        Project = Project)

rule merge_mrpresso_global:
    input:
        mrpresso_global = mrpresso_global_input,
    output:
        'results/{Project}/All/{DATE}/global_mrpresso.txt'
    shell:
        "awk 'FNR==1 && NR!=1{{next;}}{{print}}' {input.mrpresso_global} > {output}"

rule merge_mrpresso_global_wo_outliers:
    input:
        mrpresso_global_wo_outliers = mrpresso_global_wo_outliers_input,
    output:
        'results/{Project}/All/{DATE}/global_mrpresso_wo_outliers.txt'
    shell:
        "awk 'FNR==1 && NR!=1{{next;}}{{print}}' {input.mrpresso_global_wo_outliers} > {output}"

def mrpresso_res_input(wildcards):
    return expand("data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_mrpresso_res.txt",
        filtered_product,
        ExposureCode=EXPOSURES.index.tolist(),
        OutcomeCode=OUTCOMES.index.tolist(),
        Pthreshold=Pthreshold,
        Project = Project)

rule merge_mrpresso_res:
    input:
        mrpresso_res = mrpresso_res_input,
    output:
        'results/{Project}/All/{DATE}/res_mrpresso.txt'
    shell:
        "awk 'FNR==1 && NR!=1{{next;}}{{print}}' {input.mrpresso_res} > {output}"

## define list of Heterogenity tests so they can be merged into a single file
def MR_heterogenity_input(wildcards):
    return expand("data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_MR_heterogenity.txt",
        filtered_product,
        ExposureCode=EXPOSURES.index.tolist(),
        OutcomeCode=OUTCOMES.index.tolist(),
        Pthreshold=Pthreshold,
        Project = Project)

rule merge_heterogenity:
    input:
        mr_heterogenity = MR_heterogenity_input,
    output:
        'results/{Project}/All/{DATE}/heterogenity.txt'
    shell:
        "awk 'FNR==1 && NR!=1{{next;}}{{print}}' {input.mr_heterogenity} > {output}"

## define list of MR Egger intercept tests so they can be merged into a single file
def MR_plei_input(wildcards):
    return expand("data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_MR_egger_plei.txt",
        filtered_product,
        ExposureCode=EXPOSURES.index.tolist(),
        OutcomeCode=OUTCOMES.index.tolist(),
        Pthreshold=Pthreshold,
        Project = Project)

rule merge_egger:
    input:
        mr_pleiotropy = MR_plei_input,
    output:
        'results/{Project}/All/{DATE}/pleiotropy.txt'
    shell:
        "awk 'FNR==1 && NR!=1{{next;}}{{print}}' {input.mr_pleiotropy} > {output}"

## define list of MR results so they can be merged into a single file
def MR_Results_input(wildcards):
    return expand("data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_MR_Results.txt",
        filtered_product,
        ExposureCode=EXPOSURES.index.tolist(),
        OutcomeCode=OUTCOMES.index.tolist(),
        Pthreshold=Pthreshold,
        Project = Project)

rule merge_mrresults:
    input:
        mr_results = MR_Results_input,
    output:
        'results/{Project}/All/{DATE}/MRresults.txt'
    shell:
        "awk 'FNR==1 && NR!=1{{next;}}{{print}}' {input.mr_results} > {output}"

## Write a html Rmarkdown report
rule html_Report:
    input:
        markdown = "workflow/scripts/mr_report.Rmd",
        ExposureSnps = "data/{Project}/{ExposureCode}/{ExposureCode}_{Pthreshold}_SNPs.txt",
        OutcomeSnps = "data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_SNPs.txt",
        ProxySnps = "data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_MatchedProxys.csv",
        HarmonizedDat = "data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_mrpresso_MRdat.csv",
        mrpresso_global = "data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_mrpresso_global.txt",
        mrpresso_global_wo_outliers = "data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_mrpresso_global_wo_outliers.txt",
        power = "data/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_MR_power.txt"
    output:
        outfile = "results/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}_MR_Analaysis.html"
    params:
        rwd = RWD,
        output_dir = "results/{Project}/{ExposureCode}/{OutcomeCode}/",
        output_name = "results/{Project}/{ExposureCode}/{OutcomeCode}/{ExposureCode}_{Pthreshold}_{OutcomeCode}",
        ExposureCode = '{ExposureCode}',
        OutcomeCode = '{OutcomeCode}',
        Pthreshold = "{Pthreshold}",
        r2threshold = r2,
        kbthreshold = kb,
        Exposure = lambda wildcards: EXPOSURES.loc[wildcards.ExposureCode]['NAME'],
        Outcome = lambda wildcards: OUTCOMES.loc[wildcards.OutcomeCode]['NAME']
    log:
        'data/{Project}/logs/{ExposureCode}_{Pthreshold}_{OutcomeCode}_html_Report.log',
    conda: "../envs/r.yaml"
    script: "../scripts/mr_RenderReport.R"

## Write a html Rmarkdown report
rule aggregate_Report:
    input:
        markdown = "workflow/scripts/mr_FinalReport.Rmd",
        mrresults = "results/{Project}/All/{DATE}/MRresults.txt",
        mrdat = "results/{Project}/All/{DATE}/mrpresso_MRdat.csv",
        mrpresso_res = "results/{Project}/All/{DATE}/res_mrpresso.txt",
        mrpresso_global = "results/{Project}/All/{DATE}/global_mrpresso.txt",
        mrpresso_global_wo_outliers = "results/{Project}/All/{DATE}/global_mrpresso_wo_outliers.txt",
        egger = "results/{Project}/All/{DATE}/pleiotropy.txt",
        power = "results/{Project}/All/{DATE}/power.txt",
        steiger = "results/{Project}/All/{DATE}/steiger.txt"
    output:
        outfile = "results/{Project}/All/{DATE}/{Project}_MR_Analaysis.html",
        HarmonizedDatasets = "results/{Project}/All/{DATE}/{Project}_HarmonizedDatasets.csv",
        MRsummary = "results/{Project}/All/{DATE}/{Project}_MRsummary.csv",
        WideMRResults = "results/{Project}/All/{DATE}/{Project}_WideMRResults.csv",
        MRbest = "results/{Project}/All/{DATE}/{Project}_MRbest.csv",
        PublicationRes = "results/{Project}/All/{DATE}/{Project}_PublicationRes.csv",
        heatmap = "results/{Project}/All/{DATE}/{Project}_heatmap.png",
    params:
        rwd = RWD,
        today_date = "{DATE}",
        project = '{Project}',
        output_dir = "results/{Project}/All/{DATE}/",
        exposures = EXPOSURES.index,
        outcomes = OUTCOMES.index
    conda: "../envs/r.yaml"
    script: "../scripts/mr_RenderFinalReport.R"
