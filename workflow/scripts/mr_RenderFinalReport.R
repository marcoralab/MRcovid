# Render finalreport.Rmd to generate html report of aggregate MR results from project
## Input script for rule html_Report
if(any(grepl("conda", .libPaths(), fixed = TRUE))){
  message("Setting libPaths")
  df = .libPaths()
  conda_i = which(grepl("conda", df, fixed = TRUE))
  .libPaths(c(df[conda_i], df[-conda_i]))
}
.libPaths(c(.libPaths(), "/hpc/users/harern01/.Rlib"))
# log_path = snakemake@log[[1]]
#
# ## Logging messages
# con <- file(log_path, open = "wt")
# sink(con, type = "message")

message("Render Final Report",
        "\n markdown: ", snakemake@input[["markdown"]],
        "\n intermediates_dir: ", snakemake@params[["output_dir"]],
        "\n output_file: ", snakemake@output[["outfile"]],
        "\n output_dir: ", snakemake@params[["output_dir"]],
        "\n model: ", snakemake@params[["project"]],
        "\n exposures: ", snakemake@params[["exposures"]],
        "\n outcomes: ", snakemake@params[["outcomes"]],
        "\n rwd: ", snakemake@params[["rwd"]],
        "\n rlib: ", snakemake@params[["rlib"]],
        "\n DATE: ", snakemake@params[["today_date"]],
        "\n MR_results.path: ", snakemake@input[["mrresults"]],
        "\n MRdat.path: ", snakemake@input[["mrdat"]],
        "\n mrpresso_res.path: ", snakemake@input[["mrpresso_res"]],
        "\n mrpresso_global.path: ", snakemake@input[["mrpresso_global"]],
        "\n mrpresso_global_wo_outliers.path: ", snakemake@input[["mrpresso_global_wo_outliers"]],
        "\n egger_comb.path: ", snakemake@input[["egger"]],
        "\n steiger.path: ", snakemake@input[["steiger"]],
        "\n power.path: ", snakemake@input[["power"]])


message("\n", getwd())

rmarkdown::render(
  input = snakemake@input[["markdown"]],
  clean = TRUE,
  intermediates_dir = snakemake@params[["output_dir"]],
  output_file = snakemake@output[["outfile"]],
  output_dir = snakemake@params[["output_dir"]],
  output_format = "all",
  params = list(
    model = snakemake@params[["project"]],
    rwd = snakemake@params[["rwd"]],
    exposures = snakemake@params[["exposures"]],
    outcomes = snakemake@params[["outcomes"]],
    rlib = snakemake@params[["rlib"]],
    DATE = snakemake@params[["today_date"]],
    MR_results.path = snakemake@input[["mrresults"]],
    MRdat.path = snakemake@input[["mrdat"]],
    mrpresso_res.path = snakemake@input[["mrpresso_res"]],
    mrpresso_global.path = snakemake@input[["mrpresso_global"]],
    mrpresso_global_wo_outliers.path = snakemake@input[["mrpresso_global_wo_outliers"]],
    egger_comb.path = snakemake@input[["egger"]],
    steiger.path = snakemake@input[["steiger"]],
    power.path = snakemake@input[["power"]]
  )
)
