## ========================================================================== ##
## MR: Extract proxy SNPs from outcome GWAS
## ========================================================================== ##

## ==== Load required packages ==== ##
suppressMessages(library(plyr))
suppressMessages(library(tidyverse))
`%nin%` = Negate(`%in%`)

summary.path = snakemake@input[["OutcomeSummary"]] # Outcome Summary statistics
proxy.path = snakemake@input[["OutcomeProxys"]] # prox snps
snps.path = snakemake@input[["OutcomeSNPs"]]
out = snakemake@params[["Outcome"]]

message("READING IN OUTCOME AND PROXY's \n")
summary.dat <- read_tsv(summary.path, comment = '#', guess_max = 15000000)
proxy.dat <- read_table2(proxy.path)
outcome.raw <- read_tsv(snps.path)

if(empty(proxy.dat)){
  message("NO PROXY SNPS AVALIABLE \n")
  outcome.dat <- outcome.raw %>% filter(!is.na(CHROM))
} else if (empty(filter(proxy.dat, SNP_A != SNP_B)) |
           empty(filter(summary.dat, SNP %in% (filter(proxy.dat, SNP_A != SNP_B) %>% pull(SNP_B)))) ){
  message("NO PROXY SNPS AVALIABLE \n")
  outcome.dat <- outcome.raw %>% filter(!is.na(CHROM))
  query_snps <- proxy.dat %>%
    filter(SNP_A == SNP_B)
} else {
  message("WRANGLING TARGET AND PROXY SNPs \n")
  ## Filter Query SNPs
  query_snps <- proxy.dat %>%
    filter(SNP_A == SNP_B) %>%
    select(CHR_A, BP_A, SNP_A, PHASE)

  ## Filter Proxy SNPs
  proxy.snps <- proxy.dat %>%
    filter(SNP_A != SNP_B) %>%                        ## remove query snps
    left_join(summary.dat, by = c('SNP_B' = 'SNP')) %>%
    filter(!is.na(ALT)) %>%                 ## remove snps with missing information
    group_by(SNP_A) %>%                      ## by query snp
    arrange(-R2) %>%                                  ## arrange by ld
    slice(1) %>%                                      ## select top proxy snp
    ungroup() %>%
    rename(ALT.proxy = ALT,
           REF.proxy = REF) %>%
    select(-CHR_A, -CHR_B, -BP_A, -BP_B, -MAF_A, -MAF_B, -R2, -DP)            ## remove uneeded columns

  ## Select correlated alleles
  alleles <- proxy.snps %>% select(PHASE) %>%
    mutate(PHASE = str_replace(PHASE, "/", ""))
  alleles <- str_split(alleles$PHASE, "", n = 4, simplify = T)
  colnames(alleles) <- c('ref', 'ref.proxy', 'alt', 'alt.proxy')
  alleles <- as_tibble(alleles)

  ## Bind Proxy SNPs and correlated alleles
  proxy.out <- proxy.snps %>%
    bind_cols(alleles) %>%
    rename(SNP = SNP_A) %>%
    mutate(ALT = ifelse(ALT.proxy == ref.proxy, ref, alt)) %>%
    mutate(REF = ifelse(REF.proxy == ref.proxy, ref, alt)) %>%
    mutate(CHROM = as.numeric(CHROM)) %>%
    mutate(AF = as.numeric(AF))

  ## Outcome data
  outcome.dat <- outcome.raw %>%
    filter(SNP %nin% proxy.out$SNP) %>%
    bind_rows(select(proxy.out, SNP, CHROM, POS, REF, ALT, AF, BETA, SE, Z, P, N, TRAIT)) %>%
    arrange(CHROM, POS) %>%
    filter(!is.na(CHROM))

}

message("\n EXPORTING \n")
## Write out outcomes SNPs
write_tsv(outcome.dat, paste0(out, '_ProxySNPs.txt'))

## Write out Proxy SNPs
if(empty(proxy.dat)){
  tibble(proxy.outcome = NA, target_snp = NA, proxy_snp = NA, ld.r2 = NA, Dprime = NA, ref.proxy = NA, alt.proxy = NA,
         CHROM = NA, POS = NA, ALT.proxy = NA, REF.proxy = NA,
         AF = NA, BETA = NA, SE = NA, P = NA, N = NA, ref = NA, alt = NA,
         ALT = NA, REF = NA, PHASE = NA) %>%
    write_csv(paste0(out, '_MatchedProxys.csv'))
} else if (empty(filter(proxy.dat, SNP_A != SNP_B)) |
           empty(filter(summary.dat, SNP %in% (filter(proxy.dat, SNP_A != SNP_B) %>% pull(SNP_B)))) ){
  tibble(proxy.outcome = NA, target_snp = query_snps$SNP_A, proxy_snp = NA, ld.r2 = NA, Dprime = NA, ref.proxy = NA, alt.proxy = NA,
         CHROM = NA, POS = NA, ALT.proxy = NA, REF.proxy = NA,
         AF = NA, BETA = NA, SE = NA, P = NA, N = NA, ref = NA, alt = NA,
         ALT = NA, REF = NA, PHASE = NA) %>%
    write_csv(paste0(out, '_MatchedProxys.csv'))
}else{
  proxy.dat %>%
    select(SNP_A, SNP_B, R2, DP) %>%
    inner_join(proxy.out, by = c('SNP_A' = 'SNP', 'SNP_B')) %>%
    rename(target_snp = SNP_A, proxy_snp = SNP_B, ld.r2 = R2, Dprime = DP) %>%
    mutate(proxy.outcome = TRUE) %>%
    full_join(select(query_snps, SNP_A), by = c('target_snp' = 'SNP_A')) %>%
    write_csv(paste0(out, '_MatchedProxys.csv'))
}
