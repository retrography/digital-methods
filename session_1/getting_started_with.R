#TODO: Header
#TODO: Correct working directory

##### INIT #####

#setwd("~/Google Drive/Teaching/Research Design & Methods/Code") # Sets the working directory if you remove the pound sign from the beginning
rm(list = ls()) # Remove all variables in the environment (memory)
library(tidyverse) # Load the tidyverse package

##### (1) LOAD DATASET #####

df <- read.csv("phm-clean.csv", na.strings = c("","NA"), stringsAsFactors = F)
# Load the CSV file (Powerhouse.csv from the working directory) into a data frame called 'df'. Don't encode strings as categorical variables (factors). Consider empty strings as missing values (NA).

##### (2) TRANSFORM DATASET #####

df <- # Put the results of all the following operations back into the data frame 'df'
  df %>% # Take all that is in df and feed it into the next command (as its data source)
  mutate( # Generate new columns based on the old columns
    Height.2 = recode(Height.2, mm = 1, cm = 10, m = 100, .default = 1), # Recode the column Height.2 based on its old values
    Width.2 = recode(Width.2, mm = 1, cm = 10, m = 100, .default = 1), # Recode the column Width.2 based on its old values
    Depth.2 = recode(Depth.2, mm = 1, cm = 10, m = 100, .default = 1) # Recode the column Depth.2 based on its old values
    ) %>% # Take the results and feed them into the next command (as its data source)
  transmute( # Generate new columns based on the old columns, then drop the old columns
    Record.ID, # Keep Record.ID
    Categories, # Keep Categories
    Registration.Number, # Keep Registration.Number
    Height = Height.1 * Height.2, # Calculate new column Height
    Width = Width.1 * Width.2, # Calculate new column Width
    Depth = Depth.1 * Depth.2 # Calculate new column Depth
    )

##### (3) FILTER DATASET #####

subdf <- # Put the results of all the following operations into data frame 'subdf'
  df %>% # Take all that is in df and feed it into the next command (as its data source)
  filter( # Filter the data based on the following conditions (all the conditions must be satisfied)
    !is.na(Height), # Height is not missing
    Height < 5000, # Height is lower than 5000
    !is.na(Width), # Width is not missing
    Width < 5000, # Width is lower than 5000
    !is.na(Depth), # Depth is not missing
    Depth < 5000 # Depth is lower than 5000
  )

##### (4) CORRELATION #####

subdf %>% # Take all that is in subdf and feed it into the next command (as its data source)
  select(Height, Width, Depth) %>% # Keep only Height, Width and Depth columns in the data source (and drop the rest). Feed the results into the next command.
  cor() # Print the correlation table.

##### (5) HISTOGRAM #####

subdf %>% # Take all that is in subdf and feed it into the next command (as its data source)
  ggplot(aes(x=Height)) + # Define the column in the data source that will be used for histogram
  geom_histogram(bins = 100) # Define the width of the histogram bins (in pixels)

##### (6) SCATTERPLOT #####

subdf %>% # Take all that is in subdf and feed it into the next command (as its data source)
  ggplot(aes(x=Height, y=Width)) + # Define the columns in the data source that will be used for the two axes of the scatterplot
  geom_point()+ # Show the data points as actual points on the diagram (That's what a scatterplot is about)
  geom_smooth(method=lm) # Draw a trend line (line of best fit) using the lm method

##### (7) FREQUENCY #####

tidf <-  # Put the results of all the following operations into data frame 'tidf'
  df %>% # Take all that is in df and feed it into the next command (as its data source)
  separate_rows(Categories, sep="\\|") %>% # Create rows with single categories in each (and feed the data forward)
  mutate(Category = as.factor(Categories)) %>% # Generate new columns based on the old columns (categorical variable Category based on splitted Categories), then feed forward
  select(-Categories) # Get rid of the Categories column (because we already have the splitted categories in the column Category)

tidf$Category %>% # Take only the colum Category in df and feed it into the next command (as its data source)
  table() %>% # Create the frequency table for the data source (then feed forward)
  sort(decreasing = T) %>% # Sort the data source in descending order (then feed forward)
  head(20) %>% # Keep only the top 20 rows (the feed forward)
  as.data.frame() # Format the results as a data frame and print it out

##### (8) WRITE OUT #####

saveRDS(tidf, file="tidf.RDS") # Saving a single R object in compressed binary file
save.image(file = "env.RData") # Saving all the variables in the environment in compressed binary file

