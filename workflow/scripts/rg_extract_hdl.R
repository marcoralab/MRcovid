#! bin/bash
library(tidyverse)
library(magrittr)

args = commandArgs(trailingOnly = TRUE) # Set arguments from the command line
input = args[1]

## Extract rg results from HDL log output
extract_hdl <- function(x){
  hdl_res <- read_lines(x)
  tribble(
    ~term, ~var,
    "h2_trait1", extract(hdl_res, str_detect(hdl_res, "Heritability of phenotype 1:")),
    "h2_trait2", extract(hdl_res, str_detect(hdl_res, "Heritability of phenotype 2:")),
    "rho", extract(hdl_res, str_detect(hdl_res, "Genetic Covariance:")),
    "rg", extract(hdl_res, str_detect(hdl_res, "Genetic Correlation:")),
    "p", extract(hdl_res, str_detect(hdl_res, "P:")),
  ) %>%
    separate(var, into = c("var", "est"), sep = ":") %>%
    separate(est, into = c("b", "se"), sep = "\\(") %>%
    mutate(se = str_remove(se, "\\)"),
           b = str_trim(b) %>% as.numeric(),
           se = str_trim(se) %>% as.numeric()) %>%
    select(-var) %>%
    pivot_wider(names_from = term, values_from = c(b, se)) %>%
    mutate(trait1 = extract(hdl_res, str_detect(hdl_res, "gwas1.df")) %>%
             str_extract(., pattern = '(?<=input/hdl/)[A-Za-z,0-9]+(?=_formated)'),
           trait2 = extract(hdl_res, str_detect(hdl_res, "gwas2.df")) %>%
             str_extract(., pattern = '(?<=input/hdl/)[A-Za-z,0-9]+(?=_formated)')) %>%
    select(trait1, trait2, b_h2_trait1, se_h2_trait1, b_h2_trait2, se_h2_trait2,
           b_rho, se_rho, b_rg, se_rg, p = b_p, -se_p)
}

dat = read_lines(input)

if(str_detect(dat, "Genetic Covariance:") %>% any()){
  # If HDL finished suscesucully
  message("HDL output present: Extracting")
  extract_hdl(input) %>%
    mutate(success = ifelse(b_rg == "Inf", FALSE, TRUE)) %>%
    write_tsv(., str_replace(input, ".Rout", ".tsv"))

} else {
  # If HDL threw an error
  message("HDL output not present")
  tibble(
    trait1 = str_extract(input, pattern = '(?<=res/hdl/)[A-Za-z,0-9]+(?=_)'),
    trait2 = str_extract(input, pattern = '(?<=_)[A-Za-z,0-9]+(?=_HDL)'),
    b_h2_trait1 = NA,
    se_h2_trait1 = NA,
    b_h2_trait2 = NA,
    se_h2_trait2 = NA,
    b_rho = NA,
    se_rho = NA,
    b_rg = NA,
    se_rg = NA,
    p  = NA,
    success = FALSE
  ) %>%
    write_tsv(., str_replace(input, ".Rout", ".tsv"))
}
