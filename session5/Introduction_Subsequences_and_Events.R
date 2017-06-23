################################################################################################## 
## INTRODUCTION TO COMPUTATIONAL SOCIAL SEQUENCE ANALYSIS USING TRAMINER (3 of 3)               ##
## GOALS: 1) Transform (create) Event Sequence Objects from states                              ##
##        2) Conduct subsequence searches                                                       ##
##        3) Use Network Analysis to enrich event sequence perspectives                         ##
##                                                                                              ##
## TraMineR Documentation: http://mephisto.unige.ch/pub/TraMineR/doc/TraMineR-Users-Guide.pdf   ##
## prepared by Philipp Hukal (Warwick Business School; p.hukal@warwick.ac.uk)                   ##
## all mistakes remain my own                                                                   ##
## V1.0 / June 2017                                                                             ##
##################################################################################################
library(TraMineR)
library(TraMineRextras)

# First step: create an event sequence object from state sequence object
mvad.event <- seqecreate(mvad.seq)

# equvivalent to: define transition matrix using individual states
mvad.tm_states <- seqetm(mvad.seq, method = "state", use.labels = TRUE, sep = ">")
mvad.event <- seqecreate(mvad.seq, tevent=mvad.tm_states, use.labels = TRUE)

# event transition plot / (parallel coordinate plot) / with and without filter
seqpcplot(mvad.event,
          #filter = list(type = "function",
                        #value = "cumfreq",        # cumfreq/minfreq: threshold of described data
                        #level = 0.5),             # percentage value of cumulative/minimal frequencies
          cex = 1, lwd = 0.5, ltype = "non-embeddable")


# define transition matrix using transitions as single events 
mvad.tm_trans <- seqetm(mvad.seq, method = "transition", use.labels = TRUE, sep = ">")
mvad.event <- seqecreate(mvad.seq, tevent=mvad.tm_trans, use.labels = TRUE)

# look at transition matrix; every possible transition; diagonal gives individual states 
mvad.tm_trans

# Look for frequent event subsequences and plot the 15 most frequent ones (Fig. 2.5, see Section 10.2)
# generic search: what subsequences occur often enough to account for x% of data?
fsubseq <- seqefsub(mvad.event, pMinSupport = 0.05)
plot(fsubseq[1:25])

# derive discriminant sub-sequences by group: i.e. what events are typical for groups of data?
mvad.discr <- seqecmpgroup(fsubseq, group = mvad$male)
plot(mvad.discr[1:10])
# add covariate based on entropy
mvad$entropy <- seqient(mvad.seq, norm = TRUE)
mvad$entropy_group <- ifelse(mvad$entropy <= median(mvad$entropy), 'low entropy', 'high entropy')
levels(mvad$male) <- c('female', 'male')
# plot with single/combined covariate
plot(seqecmpgroup(fsubseq[1:15], group = paste(mvad$entropy_group, mvad$male), method = "chisq"))


# search for subsequence of interest: here transitions to full time employment
search_subseq <- c("TR>EM", "UE>EM", "FE>EM", "HE>EM", "SC>EM", "EM") # search pattern
search_constraint <- seqeconstraint(countMethod = "CDIST_O") # counting method

mysubseq <- seqefsub(mvad.event,                # the data set
                     pMinSupport = 0.01,        # support threshold in number or percentage (pMinSupport)
                     strsubseq = search_subseq,   # optional: specific pattern to look for
                     constraint = search_constraint) # optional: specific counting method 


# redo plot with custom search pattern 
plot(seqecmpgroup(mysubseq, group = mvad$entropy_group, method = "chisq"))



# Networks of sequences
# add number for each event that is shared by multiple students
# matrix for every student that shares event
# nodes = students
# edges = shared live event

# format states to time stamped events
mvad.tse <- seqformat(mvad.seq, from = "STS", to = "TSE", tevent = mvad.tm_trans)
mvad.tse <- mvad.tse[order(mvad.tse$id, mvad.tse$time, mvad.tse$event, decreasing = FALSE), ]
# look into data in Time-Stamped-Event format
head(mvad.tse, n = 10)

# add identifier for every possible event-time combination
mvad.tse$event_time <- paste0(mvad.tse$time, mvad.tse$event)
# store unique combinations for look-up
unique_events <- unique(mvad.tse$event_time)

# Affiliation/Incidence matrix A: which subjects share event-time positions?
# matrix: rows: students | cols: possible event-time combinations
mvad.edges <- matrix(nrow = length(unique(mvad.tse$id)), ncol = length(unique(paste0(mvad.tse$time, mvad.tse$event))))
# set all cells 0 as the default case will be that events are not shared
mvad.edges[,] <- 0
# naming matrix rows and columns
row.names(mvad.edges) <- unique(mvad.tse$id)
colnames(mvad.edges) <- unique(paste0(mvad.tse$time, mvad.tse$event))


# loop through unique events and record which students share this event at this time
student_index <- NULL
for (i in 1:length(unique_events)){
  # which students share event-time positions? 
  student_index <- mvad.tse$id[which(mvad.tse$event_time == unique_events[i])]
  # set these cells + 1 that share an event
  mvad.edges[student_index, unique_events[i]] <- 1
  # reset index just in case
  student_index <- NULL
  # print status to console 
  print(paste(i, 'of', length(unique_events), 'students linked'))
}


# what events are shared the most?
ranking_events <- data.frame(
  sums = colSums(mvad.edges),
  names = colnames(mvad.edges),
  #group = 
  row.names = NULL
)

ggplot(ranking_events[which(ranking_events$sums > 10), ], aes(x=reorder(names, sums), y = sums)) + 
  geom_bar(stat="identity") + 
  geom_text(aes(label=sums), size = 3, colour = "white", fontface = "plain", hjust = +1)+
  coord_flip()+
  ggtitle("Number of shared commits") +
  theme_bw()


# Adjacency / subject co-membership matrix (N = A*A')
N <- mvad.edges %*% t(mvad.edges)
diag(N) <- 0

ranking_students <- data.frame(
  sums = colSums(N),
  names = row.names(N),
  group = mvad$male, 
  row.names = NULL
)

ranking_students <- ranking_students[order(ranking_students$sums, decreasing = TRUE), ]

quantile(ranking_students$sums)

ggplot(ranking_students[1:50, ], aes(x=reorder(names, sums), y = sums)) + # add fill colour for group if needed
  geom_bar(stat="identity") + 
  geom_text(aes(label=sums), size = 3, colour = "white", fontface = "plain", hjust = +1)+
  coord_flip()+
  ggtitle("Co-Membership") +
  theme_bw()

# Adjacency matrix can be used to compute established network metrics
library(igraph)
mvad.net <- graph_from_adjacency_matrix(N, mode = 'undirected', diag = FALSE)
betweenness(mvad.net, directed=FALSE, weights=NA)
edge_betweenness(mvad.net, directed=FALSE, weights=NA)
centr_betw(mvad.net, directed=FALSE, normalized=TRUE)

# network metrics can be used for further investigation
# e.g. how does the fact that people do share a lot of events impact these sequences?
mvad$shared_events <- ifelse(ranking_students$sums < median(ranking_students$sums), 'few shared events', 'many shared events')
seqdplot(mvad.seq, group = paste(mvad$shared_events, mvad$male), legend.prop = 0.25)






