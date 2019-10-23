#########################################################           
#                                                       #
#  ABRI / KIN / VU Amsterdam                            #
#  Digital Methods for Qualitative Research             #
#                                                       #
#  setup -- Installs the required R packages            #   
#                                                       #   
#  Author:  Shafeie Zargar, Mahmood                     #   
#  License:  GPLv3                                      #   
#                                                       #   
######################################################### 

packs <- c(
  "xml2",
  "devtools",
  "pkgbuild",
  "tidyverse",
  "jsonlite",
  "igraph",
  "tm",
  "lda",
  "data.table",
  "curl",
  "foreign",
  "statnet",
  "topicmodels",
  "TraMineR",
  "lubridate",
  "textclean",
  "intergraph",
  "SnowballC",
  "curl",
  "textreuse",
  "htmltidy",
  "png",
  "rmarkdown",
  "reticulate",
  "keras",
  "forcats",
  "lemon",
  "data.table",
  "stargazer",
  "xtable"
)

for (pack in packs) {
  if (!pack %in% installed.packages()[, "Package"]) {
    install.packages(pack)
  }
}

if(.Platform$OS.type == "windows") {
  library(devtools)
  library(pkgbuild)
  assignInNamespace("version_info", 
                    c(devtools:::version_info, 
                      list("3.5" = list(version_min = "3.3.0", 
                                        version_max = "99.99.99", 
                                        path = "bin"))), 
                    "devtools")
}

repos <- c(
  "ThreadNet/ThreadNet",
  "jimhester/archive"
)

for (repo in strsplit(repos, split = "/")) {
  if (!repo[2] %in% installed.packages()[, "Package"]) {
    devtools::install_github(paste(repo[1], repo[2], sep = "/"))
  }
}

