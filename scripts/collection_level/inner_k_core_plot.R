# Caricamento librerie
library("igraph")
library("ggplot2")

# Lettura dataset e creazione grafo
nft_data <- read.csv("/home/user/Progetti/NFT-PrefAttach/graphsV2/COLLLevel/(2021, 3)/edge_list.csv", header = TRUE)
g <- graph.data.frame(nft_data, directed = TRUE)
g <- simplify(g, edge.attr.comb='mean')

# Funzione per la creazione del layout
CorenessLayout <- function(g) {
  coreness <- graph.coreness(g, mode = "in");
  xy <- array(NA, dim=c(length(coreness), 2));
  shells <- sort(unique(coreness));
  
  for(shell in shells) {
    v <- 1 - ((shell-1) / max(shells));
    nodes_in_shell <- sum(coreness==shell);
    angles <- seq(0,360,(360/nodes_in_shell));
    angles <- angles[-length(angles)]; # remove last element
    xy[coreness==shell, 1] <- sin(angles) * v;
    xy[coreness==shell, 2] <- cos(angles) * v;
  }
  
  return(xy);
}

# Calcolo la coreness (in-degree) sul grafo
coreness <- graph.coreness(g, mode = "all") 

# Definisco la palette dei colori
#colfunc<-colorRampPalette(c("red","yellow","springgreen","royalblue"))
colfunc<-colorRampPalette(c("royalblue","springgreen","yellow","red"))
colbar =colfunc(max(coreness))

# Calcolo il layout
ll <- CorenessLayout(g);

##### Nuova rete #####
# Effettuiamo il pruning degli archi in base al primo quartile dei pesi (unici)
quartile_list <- quantile(unique(E(g)$weight))
first_quartile <- quartile_list[[2]]
print(paste("first quantile =", first_quartile))
g2 <- delete_edges(g, which(E(g)$weight < first_quartile))
print(paste("ecuont(g) =", ecount(g)))
print(paste("ecount(g2) =", ecount(g2)))

#edgecol = gray.colors(max(E(g)$weight),start=0.97, end=0.25)
edgecol = gray.colors(50,start=0.95, end=0.25)
edgecol = c(edgecol,rep(edgecol[50],max(E(g2)$weight))) # padding da peso 50 fino al max
E(g2)$color = edgecol[E(g2)$weight]

pdf("allcore-decomposition.pdf", paper="a4")
#plot(g, layout=ll, vertex.size=1.5, edge.width = 2, edge.arrow.size=0,  vertex.label=NA, vertex.color=colbar[coreness+1], vertex.frame.color=colbar[coreness+1]);
plot(g2, layout=ll, vertex.size=1, edge.width = 1, edge.color = E(g2)$color, edge.arrow.size=0,  vertex.label=NA, vertex.color=colbar[coreness+1], vertex.frame.color=colbar[coreness+1]);
dev.off()

pdf("allncore-decomposition_arrow.pdf", paper="a4")
#plot(g, layout=ll, vertex.size=1.5, edge.width = 2, edge.arrow.size=0,  vertex.label=NA, vertex.color=colbar[coreness+1], vertex.frame.color=colbar[coreness+1]);
plot(g2, layout=ll, vertex.size=1, edge.width = 1, edge.color = E(g2)$color, edge.arrow.size=0.3,  vertex.label=NA, vertex.color=colbar[coreness+1], vertex.frame.color=colbar[coreness+1]);
dev.off()
