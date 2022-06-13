
# Downloaded starndard files:

# wget https://urldefense.proofpoint.com/v2/url?u=https-3A__data.broadinstitute.org_alkesgroup_LDSCORE_LDSC-5FSEG-5Fldscores_-24-257Bcts-5Fname-257D-5F1000Gv3-5Fldscores.tgz&d=DwIGAg&c=shNJtf5dKgNcPZ6Yh64b-A&r=MkWKtjCusEfVADif0HRkv59n-fRmDLJmQztWdKITpZo&m=tIEEOcU8ZAu16dA_76pKo1975c_YCKMaz5iQ7Ez1Sac&s=PuBykouvLGiRp8y4fQHEamF2021sg-WwFlu2S1ETmDg&e=
# wget https://urldefense.proofpoint.com/v2/url?u=https-3A__data.broadinstitute.org_alkesgroup_LDSCORE_1000G-5FPhase3-5Fbaseline-5Fldscores.tgz&d=DwIGAg&c=shNJtf5dKgNcPZ6Yh64b-A&r=MkWKtjCusEfVADif0HRkv59n-fRmDLJmQztWdKITpZo&m=tIEEOcU8ZAu16dA_76pKo1975c_YCKMaz5iQ7Ez1Sac&s=KB6z0eYaDqVxZUYfsAZeDSKdnpgkzg9rFklDI452Mu8&e=
# wget https://urldefense.proofpoint.com/v2/url?u=https-3A__data.broadinstitute.org_alkesgroup_LDSCORE_w-5Fhm3.snplist.bz2&d=DwIGAg&c=shNJtf5dKgNcPZ6Yh64b-A&r=MkWKtjCusEfVADif0HRkv59n-fRmDLJmQztWdKITpZo&m=tIEEOcU8ZAu16dA_76pKo1975c_YCKMaz5iQ7Ez1Sac&s=VV4M8bF8XTOSDUyTifq4nLnefKCsYuqdGfIJUpWk0-M&e=
# tar -xvzf 1000G_Phase3_baseline_ldscores.tgz
# tar -xvzf weights_hm3_no_hla.tgz
# bunzip2 w_hm3.snplist.bz2


# Notes about saige sumstats header for ldsc:
# - SAIGE OUTPUT beta is for Allele2 which is ALT, whereas ldsc input beta is for A1 in the ldsc scripts, so use flags to identify the correct column. So use the ALT (saige effect allele A2) as A1 in munging sumstats
# - ldsc default variant ID is taken from column "SNP" which in SAIGE output is chrpos-based ID, and won't match with hapmap snp list. Therefore use
#   the rsid header for reading in betas
# - you'll need to add a beta flag to read in the correct header from SAIGE output, as here I had manually changed the column name to "BETA"
# - ldsc might not work unless you also manually remove the hash from in front of header column "#CHR"
# - add number of cases and controls using the flags

# munge sumstats:
/home/maekniem/bin/ldsc/https://urldefense.proofpoint.com/v2/url?u=http-3A__munge-5Fsumstats.py&d=DwIGAg&c=shNJtf5dKgNcPZ6Yh64b-A&r=MkWKtjCusEfVADif0HRkv59n-fRmDLJmQztWdKITpZo&m=tIEEOcU8ZAu16dA_76pKo1975c_YCKMaz5iQ7Ez1Sac&s=Jl_BismsYR9rOAv_yVAtEpv_btYtxDwTgiYB_YiSgo0&e=  --sumstats /home/maekniem/covid_meta/freeze5/sumstats.freeze5/eur/COVID19_HGI_A2_ALL_eur_20210107.header_edited.txt  --snp rsid --a1 ALT --a2 REF --p all_inv_var_meta_p --N-cas 5101 --N-con 1383241  --out /home/maekniem/covid_ldsc/freeze5/sumstats_munged/eur/COVID19_HGI_A2_ALL_eur_20210107.munged

### heritability:
/home/maekniem/bin/ldsc/https://urldefense.proofpoint.com/v2/url?u=http-3A__ldsc.py&d=DwIGAg&c=shNJtf5dKgNcPZ6Yh64b-A&r=MkWKtjCusEfVADif0HRkv59n-fRmDLJmQztWdKITpZo&m=tIEEOcU8ZAu16dA_76pKo1975c_YCKMaz5iQ7Ez1Sac&s=6YHLiLW36Z1eT4tw1dTD0iNjfCtNFI8wmoHZZcaiEAc&e=   --h2 /home/maekniem/covid_ldsc/freeze5/sumstats_munged/eur/COVID19_HGI_A2_ALL_eur_20210107.munged.sumstats.gz --ref-ld-chr /home/maekniem/bin/ldsc/eur_w_ld_chr/ --out /home/maekniem/covid_ldsc/freeze5/regression/eur/COVID19_HGI_A2_ALL_eur_20210107.munged --w-ld-chr /home/maekniem/bin/ldsc/eur_w_ld_chr/
# add p-value for heritability using formula
2*pnorm(-abs(z))
# e.g. h2=0.002 (SE=0.0004) has  z<- 0.002/0.0004


### partitioned heritability:
cts_name=Multi_tissue_gene_expr
/home/maekniem/bin/ldsc/https://urldefense.proofpoint.com/v2/url?u=http-3A__ldsc.py&d=DwIGAg&c=shNJtf5dKgNcPZ6Yh64b-A&r=MkWKtjCusEfVADif0HRkv59n-fRmDLJmQztWdKITpZo&m=tIEEOcU8ZAu16dA_76pKo1975c_YCKMaz5iQ7Ez1Sac&s=6YHLiLW36Z1eT4tw1dTD0iNjfCtNFI8wmoHZZcaiEAc&e=  --h2-cts  /home/maekniem/covid_ldsc/freeze5/sumstats_munged/eur/COVID19_HGI_A2_ALL_eur_20210107.munged.sumstats.gz --ref-ld-chr /home/maekniem/bin/ldsc/1000G_EUR_Phase3_baseline/baseline. --out /home/maekniem/covid_ldsc/freeze5/partitioned/COVID19_HGI_A2_ALL_eur_20210107.munged --ref-ld-chr-cts /home/maekniem/bin/ldsc/$cts_name.ldcts --w-ld-chr /home/maekniem/bin/ldsc/weights_hm3_no_hla/weights.


### munge sumstats:

workflow/src/ldsc/munge_sumstats.py \
--sumstats data/raw/freeze5/COVID19_HGI_A2_ALL_eur_20210107.b37_fixed.txt.gz \
--a1 ALT \
--a2 REF \
--N-cas 5042 \ 
--N-con 1383166 \
--merge-alleles workflow/src/ldsc/w_hm3.snplist \
--out data/RGcovid/ldsc/covidhgi2020A2v5alleur

workflow/src/ldsc/munge_sumstats.py \
--sumstats data/raw/freeze5/COVID19_HGI_B2_ALL_eur_20210107.b37_fixed.txt.gz \
--a1 ALT \
--a2 REF \
--N-cas 9668 \
--N-con 1877085 \
--merge-alleles workflow/src/ldsc/w_hm3.snplist \
--out data/RGcovid/ldsc/covidhgi2020B2v5alleur

workflow/src/ldsc/munge_sumstats.py \
--sumstats data/raw/freeze5/COVID19_HGI_C2_ALL_eur_20210107.b37_fixed.txt.gz \
--a1 ALT \
--a2 REF \
--N-cas 38878 \
--N-con 1644709 \
--merge-alleles workflow/src/ldsc/w_hm3.snplist \
--out data/RGcovid/ldsc/covidhgi2020C2v5alleur


### heritability
workflow/src/ldsc/ldsc.py \
        --h2 data/RGcovid/ldsc/covidhgi2020A2v5alleur.sumstats.gz \
        --ref-ld-chr workflow/src/ldsc/eur_ref_ld_chr/ \
        --w-ld-chr workflow/src/ldsc/eur_w_ld_chr/ \
        --out data/RGcovid/ldsc/covidhgi2020A2v5alleur_h2.log


workflow/src/ldsc/ldsc.py \
        --h2 data/RGcovid/ldsc/covidhgi2020B2v5alleur.sumstats.gz \
        --ref-ld-chr workflow/src/ldsc/eur_ref_ld_chr/ \
        --w-ld-chr workflow/src/ldsc/eur_w_ld_chr/ \
        --out data/RGcovid/ldsc/covidhgi2020B2v5alleur_h2.log

workflow/src/ldsc/ldsc.py \
        --h2 data/RGcovid/ldsc/covidhgi2020C2v5alleur.sumstats.gz \
        --ref-ld-chr workflow/src/ldsc/eur_ref_ld_chr/ \
        --w-ld-chr workflow/src/ldsc/eur_w_ld_chr/ \
        --out data/RGcovid/ldsc/covidhgi2020C2v5alleur_h2.log







heritability
