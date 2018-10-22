################################################################################################## 
## INTRODUCTION TO COMPUTATIONAL SOCIAL SEQUENCE ANALYSIS USING TRAMINER (2 of 3)               ##
## GOALS: 1) Get acquainted with sequence similarity measures                                   ##
##        2) Compute dissmilarity using optimal matching                                        ##
##        3) Use clustering to inferer similarity inductively                                   ##
##                                                                                              ##
## TraMineR Documentation: http://mephisto.unige.ch/pub/TraMineR/doc/TraMineR-Users-Guide.pdf   ##
## prepared by Philipp Hukal (Warwick Business School; p.hukal@warwick.ac.uk)                   ##
## all mistakes remain my own                                                                   ##
## V1.0 / June 2017                                                                             ##
##################################################################################################

# load required libraries
library(TraMineR)
library(ggplot2)

# load data set 'MVAD'
# included with TraMineR; original study available at http://onlinelibrary.wiley.com/doi/10.1111/1467-985X.00641
data("mvad")

# Introduction to various similarity measures
# a) non-alingment techniques
# REPLACE x and y with any number 1 to 712 (the ids of students)
seqmpos(mvad.seq[x, ], mvad.seq[y, ])                     # shared sequence element-positions
seqLLCP(mvad.seq[x, ], mvad.seq[y, ])                     # longest common prefix (i.e. shared sequence elements from start of sequence)
seqLLCS(mvad.seq[x, ], mvad.seq[y, ])                     # longest common subsequence (i.e. share elements in order allowing gaps)

# b) alingment techniques: Optimal Matching
# First step: substitution matrix (cost of exchanging one element in the sequence alphabet for another)
submat.const <- seqsubm(mvad.seq, 
                        method = "CONSTANT",              # constant value for substitution 
                        cval = 2)                         # heresub = 2x1 operation (delete, insert)

# Alternatively: based on overall frequency of transitions in data
submat.trans <- seqsubm(mvad.seq,                         
                        method = "TRATE")


# Next: decide on 'cost' for inserting, deleting
indel_cost = rep(1, length(alphabet(mvad.seq))) # assign cost for every sequence element; here '1' unit
indel_cost = c(1,1,1,1,1,99)

# Finally: compute number of operations to transform sequences (= distances between each pair)
# COMPLETE the command

dist.match <- seqdist(seqdata = ,                    # the dataset
                      method = ,                      # 'OM' for optimal matching method after Needlemann-Wunsch
                      indel = ,                 # insert/deletion cost (if constant = same cost)
                      sm = ,                  # sm for substitution matrix 
                      norm = 'maxlength')                 # normalization if unequal sequence length


dist.match[1:5,1:5]

mvad.distances <- disscenter(dist.match)
mvad.distances_order <- mvad.distances[order(mvad.distances, decreasing = FALSE)]
mvad.rep10 <- which(mvad.distances %in% mvad.distances_order[1:10])

seqiplot(mvad.seq[which(mvad$id %in% mvad.rep10)])


# and now?
library(cluster)

# PAM clustering
optimal_k_for_pam <- function(df) {
  # obtain optimal k for PAM based on silhouette
  asw <- numeric(15)
  ## Note that "k=1" won't work!
  for (k in 2:15){
    set.seed(123)
    asw[k] <- pam(df, k, diss = FALSE, metric = 'euclidean') $ silinfo $ avg.width
  }
  k.best <- which.max(asw)
  cat("silhouette-optimal number of clusters:", k.best, "\n")
  
  plot(1:15, asw, type= "h", main = "pam() clustering assessment",
       xlab= "k  (# clusters)", ylab = "average silhouette width")
  axis(1, k.best, paste(" ", "best",k.best,sep="\n"), col = "red", col.axis = 'red')
}
optimal_k_for_pam(dist.match)

# manual checks
fit.pam <- pam(dist.match, k = 4, diss = TRUE, stand = TRUE)
clusplot(dist.match, clus = fit.pam$clustering, lines = 0, shade = TRUE)

seqdplot(mvad.seq, group = fit.pam$clustering)
seqfplot(mvad.seq, group = fit.pam$clustering, title = "Sequence Frequency") # frequent sequences

# use clustering results for further analysis 
seqHtplot(mvad.seq, group = fit.pam$clustering, title = "Sequence Entropy") # entropy of state distribution over time 

table(fit.pam$clustering)

ggplot(data = mvad, aes(x =  mvad$catholic, y = seqient(mvad.seq))) + geom_boxplot() + facet_wrap(~fit.pam$clustering)


# plots and clustering
# clustering
clusterward <- agnes(test.OME, diss = TRUE, method = "ward")
plot(clusterward,  which.plots = 2)

# table of clusters
cluster2 <- factor(cutree(clusterward, k = 4), labels = c(paste0("Type", seq(1:4))))
print(table(cluster2))

seqfplot(seq.pce_rails[index, 1:10] , pbarw = FALSE)




