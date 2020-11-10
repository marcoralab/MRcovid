# Render hmtl_report.Rmd to generate html report of output
## Input script for rule html_Report

rmarkdown::render(
  input = snakemake@input[["markdown"]],
  clean = TRUE, 
  intermediates_dir = snakemake@params[["output_dir"]], 
  output_file = snakemake@output[["outfile"]], 
  output_dir = snakemake@params[["output_dir"]], 
  output_format = "all",
  params = list(
    rwd = snakemake@params[["rwd"]],
    exposure.snps = snakemake@input[["ExposureSnps"]],
    outcome.snps = snakemake@input[["OutcomeSnps"]],
    proxy.snps = snakemake@input[["ProxySnps"]],
    harmonized.dat = snakemake@input[["HarmonizedDat"]],
    mrpresso_global = snakemake@input[["mrpresso_global"]],
    power = snakemake@input[["power"]],
    outcome.code = snakemake@params[["OutcomeCode"]],
    exposure.code = snakemake@params[["ExposureCode"]],
    Outcome = snakemake@params[["Outcome"]],
    Exposure = snakemake@params[["Exposure"]],
    p.threshold = snakemake@params[["Pthreshold"]],
    r2.threshold = snakemake@params[["r2threshold"]],
    kb.threshold = snakemake@params[["kbthreshold"]],
    out = snakemake@params[["output_name"]])
)