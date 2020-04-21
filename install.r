#!/usr/bin/env Rscript

local({
  r <- getOption("repos")
  r["CRAN"] <- "http://cran.r-project.org"
  options(repos=r)
})

install.packages('data.table')
install.packages('magrittr')
install.packages('remotes')
install.packages('readxl')
install.packages('littler')
remotes::install_github('jalvesaq/colorout')
remotes::install_github('cran/setwidth')

