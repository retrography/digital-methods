library(lsa)
 
# create some files
td = tempfile()
dir.create(td)
write( c("dog", "cat", "mouse"), file=paste(td, "D1", sep="/"))
write( c("hamster", "mouse", "sushi"), file=paste(td, "D2", sep="/"))
write( c("dog", "monster", "monster"), file=paste(td, "D3", sep="/"))
write( c("dog", "mouse", "dog"), file=paste(td, "D4", sep="/"))
 
# read files into a document-term matrix
myMatrix = textmatrix(td, minWordLength=1) # textvector dla jednego pliku
myMatrix

# Run TF-IDF algorithm to correct for frequent term usage
myMatrix = lw_bintf(myMatrix) * gw_idf(myMatrix)
myMatrix
 
# create the latent semantic space
myLSAspace = lsa(myMatrix, dims=dimcalc_raw())
 
# display it as a textmatrix again
round(as.textmatrix(myLSAspace),2) # should give the original
 
# create the latent semantic space
myLSAspace = lsa(myMatrix, dims=dimcalc_share())
 
# display it as a textmatrix again
myNewMatrix = as.textmatrix(myLSAspace)
myNewMatrix # should look different!

# calculate the optimal dimensionality 
share <- 0.5 # 119 dimensions with standard share of 0.5
k <- min(which(cumsum(myLSAspace$sk/sum(myLSAspace$sk))>=share))
print(k)
lsa.reduced <- lsa(myMatrix, dims = k)
summary(lsa.reduced)
 
# compare two terms with the cosine measure
cosine(myNewMatrix["dog",], myNewMatrix["cat",])
 
# calc associations for mouse
associate(myNewMatrix, "mouse")
 
# demonstrate generation of a query
query("monster", rownames(myNewMatrix))
query("monster dog", rownames(myNewMatrix)) 
 
# compare two documents with pearson
cor(myNewMatrix[,1], myNewMatrix[,2], method="pearson")

# clean up
unlink(td, recursive=TRUE)
