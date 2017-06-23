################################################################################################## 
## INTRODUCTION TO COMPUTATIONAL SOCIAL SEQUENCE ANALYSIS USING TRAMINER (1 of 3)               ##
## GOALS: 1) Understand and handle sequential datasets                                          ##
##        2) Compute basic sequence metrics                                                     ##
##        3) Conduct initial sequence analysis and visualisation                                ##
##                                                                                              ##
## TraMineR Documentation: http://mephisto.unige.ch/pub/TraMineR/doc/TraMineR-Users-Guide.pdf   ##
## prepared by Philipp Hukal (Warwick Business School; p.hukal@warwick.ac.uk)                   ##
## all mistakes remain my own                                                                   ##
## V1.0 / June 2017                                                                             ##
##################################################################################################

# if at any time something is not clear type: help(function name) or the equivalent: ?function name 
?library
help(library) 

# load required libraries
library(TraMineR)

# load data set 
# included with TraMineR; original study available at http://onlinelibrary.wiley.com/doi/10.1111/1467-985X.00641
# INSERT "mvad" 
data( )

# summary and overview
# prints number of rows and columns
# INSERT "mvad" 
dim( ) 
# print summary
# EXECUTE
summary(mvad)
# summary of all covariates and first 3 months of sequence data (columns 3 to 18)
# REPLACE x with column to derive "from:to" subset
summary(mvad[,3:x]) 

# example record (sequences start in column 15)
# CHOSE any x
mvad[x,15:25] # R bracket subsetting via data[row, from_col:to_col] 

# defining sequence objects
mvad.seq <- seqdef(data = ,            # INSERT name of dataset 
                   var = x:ncol(mvad), # columns that hold the sequence data 
                   informat = 'STS',   # leave that as is; determines sequence format
                   id = ,              # SPECIFY the column that holds the ids of subjects
                   labels = c('EM', 'FE', 'HE', 'UE', 'SC', 'TR')) # leave as is; determines short labels of states

# print alphabet of the sequence object
# INSERT name of sequence object 
alphabet( )

# summary per sequence index
summary(mvad.seq)

# descriptive statistics
# frequency table of states
seqstatf(mvad.seq)
# frequency table of sequences
# SELECT TEN most frequent sequences by specifying argument "tlim=" from:to (e.g. 1:2)
seqtab(mvad.seq, tlim = )

# different formats 
# 'SPS = State Permanence Sequence' / 'DSS = Distinct State Sequence'
# 'SRS = Shifted Replicates Sequence' / 'TSE = Time Stamped Events' 
# CHOSE any of the above three letter codes and pass it to the 'to=' argument
head(seqformat(mvad.seq, from = "STS", to = "XXX"))[,1:5]

### INTIAL VISUAL ANALYSIS ###
# plotting selected sequences  (sequence-index-plot)
# EXECUTE
seqplot(mvad.seq, 
        tlim = 1:5, # index of sequences to plot
        legend.prop = 0.25,
        type = 'i') # adjust size of legend to fit plot 

# plotting all sequences (capital I = all indicies)
# SWAP 'i' for 'I' (capital i) in 'type' argument below and execute
seqplot(mvad.seq,
        legend.prop = 0.25, 
        type = 'i')

# plotting all sequences by group 
# OBSERVE convenience function seqIplot instead of seqplot(type = "I")
# CHOSE a factor variable from the mvad data for the 'group=' argument ("mvad$COLUMN")
seqIplot(mvad.seq, 
         group =,          # allows to split the plot by groups of data 
         legend.prop = 0.25)

# plotting groups by manually filtered sub-sequences
# manual filter of subsequence
EM_6 <- seqpm(mvad.seq, "employmentemploymentemploymentemploymentemploymentemployment")
# plot by index with sub-sequence
seqIplot(mvad.seq, group = mvad$id%in%EM_6$MIndex, legend.prop = 0.25)

# plotting state distribution
seqplot(mvad.seq, border = TRUE, legend.prop = 0.22, type = 'd')
# with grouping (observe convenience function again)
seqdplot(mvad.seq, group = mvad$id%in%EM_6$MIndex, border = NA, legend.prop = 0.22)

# distinct states and number of transitions
# LOOK UP function "seqdss()"
help( ) # insert function name
mvad.dss <- seqdss(mvad.seq)
seqlength(mvad.dss)

# number and frequency of transitions
seqtransn(mvad.seq)
round(seqtrate(mvad.seq), 3)
# histogram of state transitions 
hist(seqtransn(mvad.seq), col = 'lightblue', breaks = 12, main = 'Histogram of State Transitions')
# sequence entropy or measures of uncertainty/order
# EXECUTE
head(seqient(mvad.seq, norm = TRUE), n = 10)


# two sets of visiuals in grids
# 1) Across Sequences: Distribution and Frequency of States
par(mfrow=c(2,2)) # initalise 2x2 grid 
seqiplot(mvad.seq, withlegend = FALSE, border = NA, title = "Index plot (first 10)", tlim = 1:10) # index plot 
seqfplot(mvad.seq, withlegend = FALSE, border = NA, title = "Sequence Frequency") # frequent sequences
seqdplot(mvad.seq, withlegend = FALSE, border = NA, title = "State Distribution") # state distributions
seqlegend(mvad.seq, fontsize = 0.57)

# 2) Across Sequences: Entropy and Turbulence
par(mfrow=c(2,2)) # 2 x 2 grid
seqHtplot(mvad.seq, title = "Sequence Entropy") # entropy of state distribution over time 
hist(seqST(mvad.seq), col = "blue", main = "Sequence Turbulence") # Turbulence = phi(x) {number of DSS * Variance of times spent in each}
seqmtplot(mvad.seq, withlegend = FALSE, title = 'Mean Time Spent') # mean time spent in each state
hist(seqtransn(mvad.seq), col = 'lightblue', breaks = 12, main = 'State Transitions')

### END OF SCRIPT ### 


