import os
from itertools import product
import pandas as pd
RWD = os.getcwd()

shell.prefix('module load R/3.6.3 plink/1.90; ')

pheno = config['pheno']
target = config['target']
cohort = config['cohort']
pheno_file = config['pheno_file']
outcome = config['outcome']
covar_file = config['covar_file']
covar = config['covar']
covar_factors = config['covar_factors']
bar_levels = config['bar_levels']
perm = config['perm']
r2 = config['r2']
kb = config['kb']

reference = config['reference']
EXCLUSION = pd.DataFrame.from_records(config["EXCLUSION"], index = "NAME")

PLINK = ['bed', 'fam', 'bim']
PRSICE = ['summary', 'all.score', 'best', 'prsice', 'log']

rule all:
    input:
        expand("results/{cohort}/output_{cohort}_rsq{r2}_{window}kb.html", r2 = r2, window = kb, cohort = cohort),
        # expand('data/{cohort}/{pheno}/prs_{pheno}_{cohort}_association.tsv', pheno = pheno, cohort = cohort)

rule decompress:
    input: 'data/raw/GWAS/{pheno}.chrall.CPRA_b37.tsv.gz'
    output: temp('data/temp/{pheno}.chrall.CPRA_b37.tsv')
    shell: "zcat {input} | sed '/^[[:blank:]]*#/d;s/#.*//' > {output}"

rule SampleExclude:
    input: pheno_file = pheno_file
    output:
        keep = 'data/{cohort}/{cohort}_samples.keep',
        pheno = 'data/{cohort}/{cohort}_filtered.pheno',
    script:
        '../scripts/prs_sample_exclude.R'

rule SNPgeno:
    input:
        target = expand(target + '.{ext}', ext = PLINK),
        samp_keep = rules.SampleExclude.output[0]
    output:
        out = temp(expand('data/{{cohort}}/{{cohort}}_geno.{ext}', ext = PLINK))
    params:
        input = target,
        out = 'data/{cohort}/{cohort}_geno'
    shell:
        "plink --bfile {params.input} --keep-allele-order --keep {input.samp_keep} --geno 0.05 --maf 0.01 --hwe 1e-10 midp include-nonctrl --make-bed --out {params.out}"

rule SNPmind:
    input:
        target = rules.SNPgeno.output['out']
    output:
        out = expand('data/{{cohort}}/{{cohort}}_filtered.{ext}', ext = PLINK),
        snplist = 'data/{cohort}/{cohort}_filtered.snplist.txt'
    params:
        input = 'data/{cohort}/{cohort}_geno',
        out = 'data/{cohort}/{cohort}_filtered'
    shell:
        """
        plink --bfile {params.input} --keep-allele-order --mind 0.05 --make-bed --out {params.out};
        awk '{{ print $2 }}\' {params.out}.bim > {params.out}.snplist.txt
        """

rule clump:
    input:
        ss = rules.decompress.output[0],
        snplist = rules.SNPmind.output['snplist'],
    output: 'data/temp/{pheno}_{cohort}.clumped'
    params:
        ref = reference,
        out =  'data/temp/{pheno}_{cohort}',
        r2 = r2,
        kb = kb
    shell:
        """
        plink --bfile {params.ref} --keep-allele-order --allow-no-sex \
        --extract {input.snplist} \
        --clump {input.ss} --clump-snp-field ID --clump-field P \
        --clump-r2 {params.r2} --clump-kb {params.kb} --clump-p1 1 --clump-p2 1 \
        --out {params.out}
        """

rule snps:
    input: rules.clump.output[0]
    output: 'data/temp/{pheno}_{cohort}.IndependentSnps.txt'
    params:
        regions_chrm = EXCLUSION["CHROM"],
        regions_start = EXCLUSION["START"],
        regions_stop = EXCLUSION["STOP"],
    script: "../scripts/prs_region_exclude.R"

rule prs:
    input:
        base = rules.decompress.output[0],
        snps = rules.snps.output[0],
        target = rules.SNPmind.output['out'],
        pheno = rules.SampleExclude.output['pheno'],
        covar = rules.SampleExclude.output['pheno']
    output:
        expand('data/{{cohort}}/{{pheno}}/prs_{{pheno}}_{{cohort}}.{ext}', ext = PRSICE)
    params:
        out = 'data/{cohort}/{pheno}/prs_{pheno}_{cohort}',
        target = 'data/{cohort}/{cohort}_filtered',
    shell:
        """
        ./src/PRSice \
        --base {input.base} \
        --target {params.target} \
        --pheno-file {input.pheno} \
        --pheno-col {outcome} \
        --cov-file {input.covar} \
        --cov-col {covar} \
        --cov-factor {covar_factors} \
        --no-clump \
        --extract {input.snps} \
        --beta --A1 ALT --A2 REF --bp POS --chr CHROM --pvalue P --snp ID --stat BETA \
        --all-score \
        --binary-target T \
        --print-snp \
        --bar-levels {bar_levels} \
        --fastscore \
        --perm 1000 \
        --out {params.out}
        """

rule prs_pca:
    input: 'data/{cohort}/{pheno}/prs_{pheno}_{cohort}.all.score'
    output: 'data/{cohort}/{pheno}/prs_{pheno}_{cohort}_prs.csv'
    script: "../scripts/prs_wrangle.R"

rule regression:
    input:
        summary = 'data/{cohort}/{pheno}/prs_{pheno}_{cohort}.summary',
        prs = 'data/{cohort}/{pheno}/prs_{pheno}_{cohort}_prs.csv',
        pheno_file = pheno_file
    output:
        out = 'data/{cohort}/{pheno}/prs_{pheno}_{cohort}_association.tsv'
    params:
        pheno = '{pheno}',
        r2 = r2,
        window = kb
    script:
        '../scripts/prs_glm.R'

def PRS_Results_input(wildcards):
    return expand('data/{cohort}/{pheno}/prs_{pheno}_{cohort}_association.tsv', pheno = pheno, cohort = cohort)

rule aggregate_glm:
    input: res = PRS_Results_input
    output: summ = expand('results/{cohort}/prs_association_{cohort}_rsq{r2}_{window}kb.csv', r2 = r2, window = kb, cohort = cohort)
    params: file_type = "association"
    script: '../scripts/prs_concat.R'

rule aggregate_prsice:
    input: res = expand('data/{cohort}/{pheno}/prs_{pheno}_{cohort}.prsice', pheno = pheno, cohort = cohort)
    output: summ = expand('results/{cohort}/prs_prsice_{cohort}_rsq{r2}_{window}kb.csv', r2 = r2, window = kb, cohort = cohort)
    params: file_type = "prsice"
    script: '../scripts/prs_concat.R'

rule aggregate_summary:
    input: res = expand('data/{cohort}/{pheno}/prs_{pheno}_{cohort}.summary', pheno = pheno, cohort = cohort)
    output: summ = expand('results/{cohort}/prs_summary_{cohort}_rsq{r2}_{window}kb.csv', r2 = r2, window = kb, cohort = cohort)
    params: file_type = "summary"
    script: '../scripts/prs_concat.R'

rule report:
    input:
        association = expand('results/{cohort}/prs_association_{cohort}_rsq{r2}_{window}kb.csv', r2 = r2, window = kb, cohort = cohort),
        prsice = expand('results/{cohort}/prs_prsice_{cohort}_rsq{r2}_{window}kb.csv', r2 = r2, window = kb, cohort = cohort),
        summary = expand('results/{cohort}/prs_summary_{cohort}_rsq{r2}_{window}kb.csv', r2 = r2, window = kb, cohort = cohort),
    output: "results/{cohort}/output_{cohort}_rsq{r2}_{window}kb.html"
    params:
        rwd = RWD,
        r2 = "{r2}",
        model = "{cohort}",
        window = "{window}"
    script: '../scripts/prs_output.Rmd'
