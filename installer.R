#########################################################
#                                                       #
#  installer -- Installs the required R packages        #   
#                                                       #   
#  Author:  Shafeie Zargar, Mahmood                     #   
#                                                       #   
#  License:  GPLv3                                      #   
#                                                       #   
######################################################### 

packs <- c(
  "xml2",
  "devtools",
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
  "textclean"
)

for (pack in packs) {
  if (!pack %in% installed.packages()[, "Package"]) {
    install.packages(pack)
  }
}

repos <- c(
  "ThreadNet/ThreadNet",
  "jimhester/archive",
  "hrbrmstr/htmltidy"
)

for (repo in strsplit(repos, split = "/")) {
  if (!repo[2] %in% installed.packages()[, "Package"]) {
    devtools::install_github(paste(repo[1], repo[2], sep = "/"))
  }
}

