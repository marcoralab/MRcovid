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

suppressMessages(library(tidyverse))
message('\n', 'Columns names are: ', 'SNP: ', snp_col, ', CHROM: ', chrom_col, ', POS: ', pos_col, ', REF: ', ref_col, ', ALT: ', alt_col, ', AF: ', af_col, ', BETA: ', beta_col, ', SE: ', se_col, ', P: ', p_col, ', Z: ', z_col, ', N: ', n_col, ', TRAIT: ', trait_col, '\n')

trait.gwas <- suppressMessages(read_tsv(infile_gwas, comment = '#', guess_max = 11000000))

out <- trait.gwas %>%
  rename(SNP = snp_col, CHROM = chrom_col, POS = pos_col, REF = ref_col, ALT = alt_col, AF = af_col, BETA = beta_col, SE = se_col, Z = z_col, P = p_col, N = n_col, TRAIT = trait_col) %>%
  filter(nchar(REF) == 1) %>%
  filter(nchar(ALT) == 1) %>%
  select(SNP, CHROM, POS, REF, ALT, AF, BETA, SE, Z, P, N, TRAIT) %>%
  drop_na %>%
  distinct(SNP, .keep_all = TRUE) %>%
  write_tsv(gzfile(outfile))

message('\n', 'SNPs in orginal file: ', nrow(trait.gwas), '; SNPs in formated file: ', pos_col, ', REF: ', nrow(out), '\n')
