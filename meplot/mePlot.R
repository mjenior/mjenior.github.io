
# Set variabels
Scholar_ID <- 'NLIAoMwAAAAJ'
Author_fullname <- c('Matthew Jenior', 'Matthew L Jenior')
Author_lastname <- 'Jenior'

# Load dependencies
deps <- c('easyPubMed','scholar','plotrix','gcite','tm','ggwordcloud','viridis','wordcloud2','viridis')
for (dep in deps){
  if (dep %in% installed.packages()[,'Package'] == FALSE){
    install.packages(as.character(dep), quiet=TRUE)} 
  library(dep, verbose=FALSE, character.only=TRUE)}
rm(deps, dep)

# Get data
pubs <- get_publications(Scholar_ID)
colnames(pubs) <- c("title","authors","journal","number","total.citations","publication.date","cid","pubid")
pubs$impact <- get_impactfactor(pubs$journal)$ImpactFactor
pubs <- subset(pubs, !journal %in% c('bioRxiv','BioRxiv',''))
history <- get_citation_history(Scholar_ID)

# Calculate h-index
calc_hindex <- function(data) {
  h <- 0
  x <- 1
  while (sum(data$total.citations > x) != h) {
    h <- sum(data$total.citations > x)
    x <- x + 1}
  return(as.numeric(h)-1)}

# Remove duplicate words
rmDupWords <- function(words, rmwords) {
  temp <- data.frame(word=rmwords[1], freq=sum(words$freq[words$word %in% rmwords]))
  words <- words[!words$word %in% rmwords,]
  words <- rbind(words, temp)
  return(words)}

# Calculate word cloud values
my_query <- paste(Author_fullname,"[AU]",sep="",collapse = " OR ")
my_entrez_id <- get_pubmed_ids(my_query)
my_abstracts_xml <- fetch_pubmed_data(pubmed_id_list = my_entrez_id)
my_PM_list <- articles_to_list(pubmed_data = my_abstracts_xml)
xx <- lapply(my_PM_list, article_to_df, autofill = TRUE, max_chars = 1000)
full_df <- do.call(rbind, xx)
my_Text <- unique(full_df$abstract)
docs <- Corpus(VectorSource(my_Text))
toSpace <- content_transformer(function (x , pattern ) gsub(pattern, ' ', x))
docs <- tm_map(docs, toSpace, '/')
docs <- tm_map(docs, toSpace, '@')
docs <- tm_map(docs, toSpace, '\\|')
docs <- tm_map(docs, content_transformer(tolower))
docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, removeWords, stopwords('english'))
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, stripWhitespace)
exclude_words <- c('will','can','also','including','showed','may','one','using','however',
                   'enabling','found','two','major','factor','demonstrated','following',
                   'multiple','cause','single','within')
docs <- tm_map(docs, removeWords, exclude_words)
dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m), decreasing=TRUE)
d <- data.frame(word=names(v), freq=v)
d <- rmDupWords(d, c('difficile','cdi','c difficile'))
d <- rmDupWords(d, c('gene','genes'))
d <- rmDupWords(d, c('bacteria','bacterial','bacterium'))
d <- d[order(d$freq, decreasing=TRUE),]
d <- subset(d, freq > 1)
rownames(d) <- d$word
d$freq <- as.numeric(d$freq)
d$freq[1] <- d$freq[1] + d$freq[7]
d <- d[-7, ] 

#-------------------------------------------------------------------------------------------#

# Generate figures

# plot citations over time
pdf(file='~/Desktop/citations_time.pdf', width=5, height=4)
par(mar=c(3,3,1,1), xpd=FALSE, las=1, mgp=c(1.7,0.6,0), lwd=2)
barplot(history$cites, names.arg=history$year, ylim=c(0,max(history$cites)+10), col=viridis(n=nrow(history)), 
        xlab='Year', ylab='Citations', cex.lab=1.2, font.lab=2)
legend('topleft', legend=c(paste('Total citations:', sum(history$cites)),paste('h-index:', calc_hindex(pubs))), 
       col='white', pt.cex=0, bty='n', text.font=2)
box()
dev.off()

# Abstract word cloud
set.seed(6819)

wordcloud(as.matrix(d), color=viridis(n=sum(d$freq > 3)))

# Year vs impact correlation
r_val <- round(as.numeric(cor.test(x=pubs$publication.date, y=pubs$impact, method='spearman', exact=FALSE)$estimate),3)
p_val <- round(as.numeric(cor.test(x=pubs$publication.date, y=pubs$impact, method='spearman', exact=FALSE)$p.value),3)
# R = 0.654, p-value = 0.04
pdf(file='~/Desktop/impact_correlation.pdf', width=5, height=4)
par(mar=c(3,3,1,1), xpd=FALSE, las=1, mgp=c(1.7,0.6,0), lwd=2)
plot(x=pubs$publication.date, y=pubs$impact, xlim=c(min(pubs$publication.date),max(pubs$publication.date)+1), 
     ylim=c(0,round(max(pubs$impact, na.rm=TRUE)+2)), ylab='Journal Impact Factor', xlab='Publication Year', 
     bg=viridis(n=nrow(pubs)), pch=21, cex=1.5, cex.axis=0.8, cex.lab=1.2, font.lab=2)
legend('topleft', legend=c(paste('Rho =', r_val), paste('p-value =', p_val)), 
       col='white', pt.cex=0, bty='n', text.font=2)
abline(lm(pubs$impact ~ pubs$publication.date), lwd=3)
box()
dev.off()

