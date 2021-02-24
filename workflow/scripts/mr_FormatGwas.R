#!/usr/bin/Rscript
## ========================================================================== ##
## MR: Format input GWAS to be in standardized format
## ========================================================================== ##

infile_gwas = snakemake@input[["ss"]]
outfile = snakemake@output[["formated_ss"]]
snp_col = snakemake@params[["snp_col"]]
chrom_col = snakemake@params[["chrom_col"]]
pos_col = snakemake@params[["pos_col"]]
ref_col = snakemake@params[["ref_col"]]
alt_col = snakemake@params[["alt_col"]]
af_col = snakemake@params[["af_col"]]
beta_col = snakemake@params[["beta_col"]]
se_col = snakemake@params[["se_col"]]
p_col = snakemake@params[["p_col"]]
z_col = snakemake@params[["z_col"]]
n_col = snakemake@params[["n_col"]]
trait_col = snakemake@params[["trait_col"]]

if(any(grepl("conda", .libPaths(), fixed = TRUE))){
  message("Setting libPaths")
  df = .libPaths()
  conda_i = which(grepl("conda", df, fixed = TRUE))
  .libPaths(c(df[conda_i], df[-conda_i]))
}

# library(gwasvcf)
# library(VariantAnnotation)
library(tidyverse)
library(magrittr)

message('\n', 'Columns names are: ', 'SNP: ', snp_col, ', CHROM: ', chrom_col,
        ', POS: ', pos_col, ', REF: ', ref_col, ', ALT: ', alt_col, ', AF: ', af_col,
        ', BETA: ', beta_col, ', SE: ', se_col, ', P: ', p_col, ', Z: ', z_col,
        ', N: ', n_col, ', TRAIT: ', trait_col, '\n')

if(str_detect(infile_gwas, ".vcf.gz")){
  ## Formating for IEU OPEN GWAS .vcf files
  message("IEU OPEN GWAS FORMAT")

  vcf <- VariantAnnotation::readVcf(infile_gwas)
  trait.gwas <- gwasvcf::vcf_to_tibble(vcf)
  traitID = tolower(samples(header(vcf)))

  ieugwas <- read_csv("data/raw/ieugwas_201020.csv")
  trait_meta <- select(ieugwas, id, trait, sample_size, ncase, ncontrol) %>% filter(id == traitID)

  out <- trait.gwas %>%
    mutate(EZ = ES/SE,
           P = 10^-LP,
           TRAIT = pull(trait_meta, trait),
           N = pull(trait_meta, sample_size),
           NCASE = pull(trait_meta, ncase),
           NCTRL = pull(trait_meta, ncontrol)) %>%
    filter(nchar(REF) == 1) %>%
    filter(nchar(ALT) == 1) %>%
    mutate(Z = ifelse(BETA == 0 & SE == 0, 0, Z)) %>%
    select(SNP = ID, CHROM = seqnames, POS = start, REF = REF, ALT = ALT, AF = AF,
           BETA = ES, SE, Z = EZ, P, N, TRAIT, NCASE, NCTRL) %>%
    distinct(SNP, .keep_all = TRUE)

  out %>%
    write_tsv(gzfile(outfile))

} else if(str_detect(infile_gwas, ".chrall.CPRA_b37.tsv.gz")){
  ## Formating for MSSM files
  message("MSSM GWAS FORMAT")

  trait.gwas <- suppressMessages(vroom::vroom(infile_gwas, comment = '#', guess_max = 11000000))

  out <- trait.gwas %>%
    rename(SNP = snp_col, CHROM = chrom_col, POS = pos_col, REF = ref_col,
           ALT = alt_col, AF = af_col, BETA = beta_col, SE = se_col, Z = z_col,
           P = p_col, N = n_col, TRAIT = trait_col) %>%
    filter(nchar(REF) == 1) %>%
    filter(nchar(ALT) == 1) %>%
    mutate(Z = ifelse(BETA == 0 & SE == 0, 0, Z)) %>%
    select(SNP, CHROM, POS, REF, ALT, AF, BETA, SE, Z, P, N, TRAIT) %>%
    drop_na %>%
    distinct(SNP, .keep_all = TRUE)

  out %>%
    write_tsv(gzfile(outfile))

}

message('\n', 'SNPs in orginal file: ', nrow(trait.gwas), '; SNPs in formated file: ', pos_col, ', REF: ', nrow(out), '\n')
