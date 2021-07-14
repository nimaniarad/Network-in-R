# Making a Network in R

# Sometimes there is a huge network of people in a company. Not just limited to the company itself but also 
# includes people outside the company. 
# You want to find out their connections and know most important persons. For example, consider a non-profit company 
# that want to know how their connections can help them to raise more fund. 

# We can do this in R. 

# Loading Library...

library(dplyr)
library(igraph)

# Loading the Data...

BCTA <- read.csv("C:/Nima/Rstudio/Git/Data/BCTA.csv", header=T, as.is=T)

# First making symmetric matrix:

d <-BCTA %>%
  dplyr::count(Board,Chamber) %>%
  tidyr::spread(key = Board,value = n)
d[is.na(d)] = 0
mtx <-as.matrix(d)

# As we see in the environment, it is symmetrical. 

# Let's Making a network and plot it: 

ntwork <-graph.adjacency(mtx, mode="undirected", diag=FALSE, weighted=TRUE)

plot(ntwork, vertex.label.color = "black", layout = layout_in_circle(ntwork))

# It is a nice clean graph but it cannot help us to understand who is more central to the network. Mike has
# more connections than the others but it should not be the whole story!

plot(ntwork, layout = layout.random, vertex.label.cex=c(0.4), vertex.color=degree(ntwork)*25)

# Now lets's do some analysis:

df <- data.frame(deg = degree(ntwork),cls = closeness(ntwork), btw = betweenness(ntwork))
df %>%
  arrange(desc(btw))

# Node Mike has the highest degree of centrality. It is connected to three other nodes in the network, more
# than any other node.
# However, closeness and betweenness are telling a different story. The first two on the top have 2 degrees! It
# is proved we cannot decide the centrality just by degree. Let's see the betweenness separately to find out
# who the persons are:
# If we look at just betweenness, we can find out who has the highest betweenness:

betweenness(ntwork)

# Arnold and Fred are the nodes that control the flow of information in the network. This is the path that
# most other ones have to go through these two to reach other ones. So, those are our guys! 




