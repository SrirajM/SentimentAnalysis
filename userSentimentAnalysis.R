##Getting youtube data
install.packages("httr")

library(SocialMediaLab)



install.packages("httr")
if(!"devtools" %in% installed.packages()) install.packages("devtools")
require(devtools)
#we have to install an earlier version of the 'httr' package
#due to incompatibility problems with the 'twitteR' package
devtools::install_version("httr",version="0.6.0",repos="http://cran.us.r-project.org")
devtools::install_github("voson-lab/SocialMediaLab/SocialMediaLab")
require(SocialMediaLab)
if(!"magrittr" %in% installed.packages())install.packages("magrittr")
require(magrittr)

#Google developer API key

apikey <- "###"


key <- AuthenticateWithYoutubeAPI(apikey)

video <- c('xqsgnXWUA4M')
ytdata <- CollectDataYoutube(video , key , writeToFile = FALSE)
str(ytdata)
write.csv(ytdata , file='D:/Sriraj/data/yt.csv' ,row.names = F)
data <- read.csv(file.choose(), header = T)
str(data)
View(data)

data <- data[data$ReplyToAnotherUser != FALSE ,]
view(data)
y <- data.frame(data$User ,data$ReplyToAnotherUser)
View(y)


##CreateUserNetwork
library(igraph)
net <- graph.data.frame(y , directed =T)
net <- simplify(net)
V(net)
E(net)

V(net)$label <-V(net)$name
V(net)$degree <- degree(net)

#Histogram

hist(V(net)$degree,
        col ='green',
main = 'Histogram of node degree',
ylab = 'Frequency',
xlab = 'Degree of Vertices')


plot(net ,
     vertex.size = 0.2*V(net)$degree ,
     edge.arrow.sidge = 0.1,
     vertex.label.cex =0.01*V(net)$degree)

#Sentiment analysis


install.packages("syuzhet")
library(syuzhet)
data <- read.csv(file.choose() , header = T)
str(data)
comments <- iconv(data$Comment , to = 'UTF-8')
View(comments)


#Obtain sentiment scores
s<- get_sentiment(comments, method="nrc", lang = "english")

s <- get_nrc_sentiment(comments)


View(s)
head(s)
comments[3]
s$neutral <- ifelse(s$negative+s$positive ==0, 1, 0)
View(s)

comments[3]


#Barplot 
barplot(100*colSums(s)/sum(s), las =2 ,col =rainbow(10),ylab ='Percentage',main ='Sentiment scores for Youtube comments')


