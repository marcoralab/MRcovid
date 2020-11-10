library(tidyverse)
library(here)
source(here("workflow", "scripts", "prs_pca.R"), chdir = TRUE)

# Define Input
prs.file.path <- snakemake@input[[1]]
outfile = snakemake@output[[1]]

# Read in all PRS file
message('READ IN PRS \n')
prs <- read_table2(prs.file.path)  %>%
  rename_at(vars(-FID, -IID), function(x) paste0('prs.pt_', x))

prspca <- prs.pc(prs)

prs.out <- left_join(prs, prspca$data)

write_csv(prs.out, outfile)
