#########################################################           
#                                                       #
#  ABRI / KIN / VU Amsterdam                            #
#  Digital Methods for Qualitative Research             #
#                                                       #
#  beer -- Loads the data from beer.stackexchange.com   #   
#                                                       #   
#  Author:  Shafeie Zargar, Mahmood                     #   
#  License:  GPLv3                                      #   
#                                                       #   
######################################################### 

# Install the required packages, if not done before
# source("https://raw.githubusercontent.com/retrography/digital-methods/master/setup.R")

#### Load Packages ####

library(tidyverse)
library(archive)
library(xml2)
library(lubridate)
library(textclean)

#### Global Variables ####

# Customize the data path for your computer
data.dir <- "~/Data/digi_methods/session_2"
# Which stack exchange community?
se.archive <- "beer"

#### Helper Functions ####

# Convert html entities, remove html tags, newlines, extra spaces
str_clean <-
  function(str) {
    str %>%
      replace_html() %>%
      str_replace_all("\\s+", " ") %>%
      str_trim()
  }

# Take an XML with "row" entities and attributes, and return a neat dataframe
xml2df <-
  function(xml.data) {
    xml.rows <- xml_find_all(xml.data, "//row")
    xml.attrs <- xml_attrs(xml.rows)
    xml.attr.labs <-
      lapply(xml.attrs, names) %>%
      unlist() %>%
      unique()
    df <-
      xml.attrs %>%
      lapply(function(row.attrs) {
        row.attrs[xml.attr.labs] %>%
          na.omit() %>%
          as.list()
      }) %>%
      bind_rows() %>%
      type_convert() %>%
      return()
  }

#### Preps ####

# Create and set the working directory
data.dir <- paste(data.dir, se.archive, sep = "/")
dir.create(data.dir, recursive = T)
setwd(data.dir)

# Download and extract the archive
temp.file <- tempfile()
download.path <- paste0("https://archive.org/download/stackexchange/", se.archive, ".stackexchange.com.7z")
download.file(
  download.path,
  temp.file
)
archive_extract(temp.file, data.dir)
xml.files <- dir(path = "./", pattern = "*.xml")

#### Tabulate XMLs ####

# Load all XMLs in the directors as dataframes
for (xml.file in xml.files) {
  xml.data <- read_xml(xml.file)
  df <-
    xml2df(xml.data)
  
  df.name <-
    xml.file %>%
    str_extract("([^/]+)$") %>%
    str_replace("\\..*$", "") %>%
    tolower()
  
  assign(df.name, df, envir = .GlobalEnv)
  rm(xml.data, df, df.name, xml.file)
}

rm(data.dir, xml.files, temp.file, download.path)

#### Final Data Fixes ####

# Clean text columns
comments$Text <- str_clean(comments$Text)

users$AboutMe <- str_clean(users$AboutMe)

posthistory <-
  posthistory %>%
  mutate_at(c("Text", "Comment"),
            funs(str_clean))

# Create the post-tag table
posttags <-
  posts %>%
  transmute(PostId = Id,
            TagName = str_replace_all(Tags, "(^<|>$)", "")) %>%
  separate_rows(TagName, sep = "><") %>%
  drop_na() %>%
  inner_join(select(tags, TagId = Id, TagName), by = "TagName") %>%
  select(-TagName)

# Clean text columns and drop tags
posts <-
  posts %>%
  mutate_at(c("Body", "Title"), funs(str_clean)) %>%
  select(-Tags)

rm(str_clean, xml2df)

# Save the environment to data file(s)
for (objectName in ls()) {
  obj <- get(objectName)
  if (is.data.frame(obj)) {
    saveRDS(obj, paste0(objectName, ".RDS"), compress = "xz")
  }
}
rm(obj, objectName)

save.image("beer.RData", compress = T)
