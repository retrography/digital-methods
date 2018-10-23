# Getting Started with R

__TODO: __

- Join / Merge datasets
- Aggregation and grouping / Window functions
- Wide and long formats

------------------

The objective of the following exercises is to give you the basics to start working with R. These include:

- Loading data files (comma-separated)
- Transforming data structures
- Filtering datasets and obtaining subsamples
- Calculating correlations
- Make histograms
- Make scatterplots

### 1. Loading data files 

Load the data file you exported from OpenRefine using [read.csv](http://rprogramming.net/read-csv-in-r/) function. Don't forget to set the `stringsAsFactors` flag to `FALSE`.

Hint: You can obtain help about any command by typing a question mark before the function name. Example: `?read.csv`

### 2. Transforming the dataset

Convert all the dimensions (Width, Height and Depth) to millimetres so that they become comparable. 

There are many ways to do this. One is to use the [mutate](http://dplyr.tidyverse.org/reference/mutate.html) function in combination with the [recode](http://dplyr.tidyverse.org/reference/recode.html) function from the `dplyr` package. Refer to [R Data Wrangling](https://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf) cheat sheet to obtain additional information on `dplyr` and `tidyr` packages.

Hint: Don't forget to import the [tidyverse](https://www.tidyverse.org/) library in order to get access to the `dplyr` functions: `library(tidyverse)`.

### 3. Filtering the dataset

Create a subsample, keeping only the records that have values below 5000 for all the dimensions (Width, Height and Depth).

There are many ways to do this. One is to use the [filter](https://blog.exploratory.io/filter-data-with-dplyr-76cf5f1a258e) function from the `dplyr` package.

### 4. Calculate the correlation table

Calculate the correlation between the three dimensions using the `cor` function.

### 5. Create a histogram

Make a histogram plot for the variable `Height`. 

There are different ways to do this, but one is [using `ggplot2` package](https://www.r-bloggers.com/how-to-make-a-histogram-with-ggplot2/).

### 6. Create a scatterplot

Make a scatterplot of the variables `Height` and `Width`.

There are different ways to do this, but one is [using `ggplot2` package](http://www.sthda.com/english/wiki/ggplot2-scatter-plots-quick-start-guide-r-software-and-data-visualization).