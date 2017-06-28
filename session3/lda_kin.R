require(tm)

# read the data to posts
data <- read.csv("bitcoindata.csv", sep = ",")
posts <- data$post

# read in some stopwords:
library(tm)
stop_words <- stopwords("SMART")

# force text to lowercase
posts <- tolower(posts) 
head(posts)

# tokenize on space and output as a list:
doc.list <- strsplit(posts, "[[:space:]]+")

# compute the table of terms:
term.list <- table(unlist(doc.list))
term.list <- sort(term.list, decreasing = TRUE)
head(term.list)

# remove terms that are stop words or occur fewer than 10 times:
del <- names(term.list) %in% stop_words | term.list < 10
term.list <- term.list[!del]
vocab <- names(term.list)
head(vocab)

# now put the documents into the format required by the lda package:
get.terms <- function(x) {
  index <- match(x, vocab)
  index <- index[!is.na(index)]
  rbind(as.integer(index - 1), as.integer(rep(1, length(index))))
}
documents <- lapply(doc.list, get.terms)
head(documents)

### FIT THE TOPIC MODEL ###

# Compute some statistics related to the data set:
D <- length(documents)  # number of documents (13,032)
W <- length(vocab)  # number of terms in the vocab (6,704)
doc.length <- sapply(documents, function(x) sum(x[2, ]))  # number of tokens per document [312, 288, 170, 436, 291, ...]
N <- sum(doc.length)  # total number of tokens in the data (507,552)
term.frequency <- as.integer(term.list)  # frequencies of terms in the corpus [8939, 5544, 2411, 2410, 2143, ...]

# MCMC and model tuning parameters:
K <- 20
G <- 5000
alpha <- 0.02
eta <- 0.02

# Fit the model:
install.packages('lda')
library(lda)
set.seed(357)
t1 <- Sys.time()
fit <- lda.collapsed.gibbs.sampler(documents = documents, K = K, vocab = vocab, 
                                   num.iterations = G, alpha = alpha, 
                                   eta = eta, initial = NULL, burnin = 0,
                                   compute.log.likelihood = TRUE)
t2 <- Sys.time()
t2 - t1  # how long did it take to run?


### VISUALISE WITH LDAVIS ###
theta <- t(apply(fit$document_sums + alpha, 2, function(x) x/sum(x)))
phi <- t(apply(t(fit$topics) + eta, 2, function(x) x/sum(x)))

bitcoinPosts <- list(phi = phi,
                     theta = theta,
                     doc.length = doc.length,
                     vocab = vocab,
                     term.frequency = term.list)

library(LDAvis)

# create the JSON object to feed the visualization:
json <- createJSON(phi = bitcoinPosts$phi, 
                   theta = bitcoinPosts$theta, 
                   doc.length = bitcoinPosts$doc.length, 
                   vocab = bitcoinPosts$vocab, 
                   term.frequency = bitcoinPosts$term.frequency)

serVis(json, out.dir = 'bitcoinLDA', open.browser = FALSE)