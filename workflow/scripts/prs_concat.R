## ========================================================================== ##
## Concat output from GLM, and PRScice files
## ========================================================================== ##

library(tidyverse)
library(qvalue)

## File Paths
res.files = snakemake@input[["res"]]
out <- snakemake@output[["summ"]]
file_type <- snakemake@params[["file_type"]]


if(file_type == "association"){
  message("\n Concat GLM assocation statistics: ", res.files, "\n")
  # GLM assocations stats
  ## res.files <- list.files(pattern = 'association.tsv', recursive = T)
  res <- map_dfr(res.files, read_tsv) %>%
    mutate(OR = exp(estimate),
           LCI = exp(estimate-std.error*1.96),
           UCI = exp(estimate+std.error*1.96))
  write_csv(res, out)

} else if(file_type == "prsice"){
  message("\n Concat PRSice files: ", res.files, "\n")
  ##Summary files of output from PRSice
  ## prsice.files <- list.files(pattern = '.prsice', recursive = T)
  prsice.files <- map_dfr(res.files, function(x){
    read_tsv(x) %>% mutate(Phenotype = str_extract(x, pattern = '(?<=prs_)[A-Za-z,0-9]+(?=_)'))
  }) %>%
    filter(Threshold == 5e-8)
  write_csv(prsice.files, out)

} else if(file_type == "summary"){
  message("\n Concat Summary files of output from PRSice: ", res.files, "\n")
  # Summary files of output from PRSice
  ## sum.files <- list.files(pattern = '.summary', recursive = T)
  sum.files <-  map_dfr(res.files, function(x){
    read_tsv(x) %>%
      mutate(Phenotype = str_extract(x, pattern = '(?<=prs_)[A-Za-z,0-9]+(?=_)'))
  })
  write_csv(sum.files, out)

} else {

  stop("In compatiable file type used as input")

}
