#!/usr/bin/Rscript

## Load Packages
suppressMessages(library(tidyverse))
suppressMessages(library(ggplot2))
suppressMessages(library(ggman))
suppressMessages(library(gridExtra))

snp.r2 <- function(eaf, beta){
  2*eaf*(1 - eaf)*beta^2
}

## Read in arguments
infile_gwas = snakemake@input[["ingwas"]]
infile_clump = snakemake@input[["inclump"]]
outfile_plot = snakemake@output[["out"]]
PlotTitle = snakemake@params[["PlotTitle"]]

message(paste(PlotTitle, '\n'))

## Read in GWAS and Plink Clumped File
trait.gwas <- read_tsv(infile_gwas, comment = '##', guess_max = 15000000,
                       col_types = list(AF = col_number())) %>%
  mutate(r2 = snp.r2(AF, BETA))

trait.clump <- suppressMessages(read_table2(infile_clump)) %>%
  filter(!is.na(CHR)) %>%
  select(CHR, F, SNP, BP, P, TOTAL, NSIG)

## Count number of SNPs in clumped dataset
clump.n <- trait.clump %>%
  mutate(p.cut = cut(P, breaks = c(Inf, 0.05, 5e-5, 5e-6, 5e-7, 5e-8, -Inf), lablels = F)) %>%
  left_join(select(trait.gwas, SNP, r2)) %>%
  mutate(r2 = as.numeric(r2)) %>%
  group_by(p.cut) %>% summarise(n = n(), r2 = round(sum(r2, na.rm = T), 4))

## Count number of SNPs in total dataset
all.n <- trait.gwas %>%
  mutate(p.cut = cut(P, breaks = c(Inf, 0.05, 5e-5, 5e-6, 5e-7, 5e-8, -Inf), lablels = F)) %>%
  group_by(p.cut) %>% summarise(n = n())

## Merge Summary files
tab.TRAIT <- full_join(all.n, clump.n, by = 'p.cut', suffix = c('.all', '.clump'))

## Calculate Maximum Pvalue
max.p <- max(-log10(filter(trait.clump, P > 0)$P)) + 5

## Index SNPs
IndexSnps1 <- filter(trait.clump, P <= 5e-8)$SNP
IndexSnps2 <- filter(trait.clump, P <= 5e-6 & P > 5e-8)$SNP

## Plot GWAS
p.TRAIT <- ggman(filter(trait.gwas, P < 0.05), snp = 'SNP', chrom = 'CHROM', bp = 'POS', pvalue = 'P', ymin = 0, ymax = max.p,
                 title = PlotTitle, sigLine = -log10(5e-8), relative.positions = TRUE) +
  theme_classic() + theme(text = element_text(size=10)) +
  geom_hline(yintercept = -log10(5e-5), colour = 'blue', size = 0.25) +
  geom_hline(yintercept = -log10(5e-6), colour = 'red', size = 0.25, linetype = 2)

if(length(IndexSnps1) >= 1){
  p.TRAIT <- ggmanHighlight(p.TRAIT, highlight = IndexSnps1, shape = 18, colour = 'red')
}
if(length(IndexSnps2) >= 1){
  p.TRAIT <- ggmanHighlight(p.TRAIT, highlight = IndexSnps2, shape = 18, colour = 'blue')
}

out.TRAIT <- arrangeGrob(p.TRAIT,  tableGrob(tab.TRAIT, theme = ttheme_minimal(base_size = 8)),
                          ncol = 2, widths = 2:1, layout_matrix = rbind(c(1,2), c(1, NA)))

ggsave(outfile_plot, device = 'png', units = 'in', width = 10, height = 5, plot = out.TRAIT)
