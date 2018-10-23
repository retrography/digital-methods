library(tm)

# read the data to posts
data <- read.csv("bitcoindata.csv", sep = ",")
posts <- data$post

# get rid of the "," characters so that it's more acceptable to the tm package
data <- apply(as.matrix(posts), 1, function (x) gsub(',',' ', x))
data[1:10]

# train corpus and generate doc-term matrix
posts.corpus <- Corpus(VectorSource(data))
posts.dtm <- DocumentTermMatrix(posts.corpus)
Zipf_plot(posts.dtm)
Heaps_plot(posts.dtm)

# filter out any terms that have shown up in less than 10 documents
posts.dict <- findFreqTerms(posts.dtm, 10 )
posts.dtm.filtered <- DocumentTermMatrix(posts.corpus, control=list(dictionary = posts.dict))
posts.dtm.filtered

# get a count of number of terms in each document (with the intent of deleting any documents with 0 terms)
term.counts <- apply(posts.dtm.filtered, 1, function (x) sum(x))
posts.dtm.filtered <- posts.dtm.filtered[term.counts > 1,]

# Filter out noisy terms from the matrix
posts.corpus <- tm_map(posts.corpus, removeWords, c("theresa","donald", "duck", "ninja", "gun"))  # Go back to line 6
posts.dtm.filtered <- DocumentTermMatrix(posts.corpus, list(dictionary = posts.dict))

# get some simple term frequencies so that I can plot them and decide which I'd like to filter out
posts.m <- as.data.frame(as.matrix(posts.dtm.filtered))
head(posts.m)
termfreq <- sort(colSums(posts.m), decreasing=TRUE)
termfreq <- data.frame(terms = names(termfreq), num_posts=termfreq)
termfreq$terms <- reorder(termfreq$terms, termfreq$num_posts)
head(termfreq)
class(termfreq)

# turn into data frame for plotting
plotfreq <- as.data.frame(as.matrix(termfreq))

library(ggplot2)

ggplot(plotfreq[1:30, ], aes(x=terms, y=num_posts)) + geom_point(size=5, colour="red") + coord_flip() +
      ggtitle("Frequency of top 30 terms") + 
      theme(axis.text.x=element_text(size=13,face="bold", colour="black"), axis.text.y=element_text(size=13,colour="black",
            face="bold"), axis.title.x=element_text(size=14, face="bold"), axis.title.y=element_text(size=14,face="bold"),
            plot.title=element_text(size=24,face="bold"))

