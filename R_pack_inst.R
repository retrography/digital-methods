packs <- c(
  "XML",
  "devtools",
  "tidyverse",
  "jsonlite",
  "igraph",
  "tm",
  "lda",
  "data.table",
  "curl",
  "foreign",
  "httr",
  "htmltools",
  "statnet",
  "topicmodels",
  "TraMineR"
)

for (pack in packs) {
  if (!pack %in% installed.packages()[, "Package"]) {
    install.packages(pack)
  }
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

