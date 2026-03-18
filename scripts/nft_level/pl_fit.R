library("poweRlaw")
library("igraph")

edges <- read.csv("/home/user/Progetti/NFT-PrefAttach/graphsV2/NFTLevel-Pruning_V2/(2019, 3)/edge_list.csv", header = TRUE, colClasses = c(NA, NA, "NULL"))
g <- graph_from_data_frame(edges, directed = TRUE)

g

data <- degree(g, mode = "in")
distrib <- setdiff(data,0)

m_pl = displ$new(distrib)
estpl = estimate_xmin(m_pl)
m_pl$setXmin(estpl)

m_ln = dislnorm$new(distrib)
estln = estimate_xmin(m_ln)
m_ln$setXmin(estln)

m_exp = disexp$new(distrib)
estexp = estimate_xmin(m_exp)
m_exp$setXmin(estexp)

m_pois = dispois$new(distrib)
estpois = estimate_xmin(m_pois) 
m_pois$setXmin(estpois)

pdf("/home/user/Progetti/NFT-PrefAttach/scripts/fitting_ccdf_in(2019, 3).pdf", width = 10, height = 10)
par(mar=c(8,8,3,3), mgp=c(6,1,0))
plot(m_pl, xlab = "in-degree", ylab="CCDF", cex.lab=2, cex.axis=2, lwd = 7, xaxt="n", yaxt="n")
axis(side=1, at=c(1, 10, 50, 200, 700, 5000), las=1, cex.axis=2)
axis(side=2, at=c(0.005, 0.020, 0.050, 0.200, 0.500), las=2, cex.axis=2)
legend("bottomleft", col=c(2,3,4,5), legend=c("power law fit", "log normal fit", "exponential fit", "poisson fit"), cex=2, lwd=5, lty=c(1,2,3,4))
lines(m_pl, col=2, lwd=5, lty=1)
lines(m_ln, col=3, lwd=5, lty=2)
lines(m_exp, col=4, lwd=5, lty=3)
lines(m_pois, col=5, lwd=5, lty=4)
dev.off()

fit = power.law.fit(distrib,xmin=estpl$xmin)    #Smaller scores of KS.stat denote better fit, small p-values (< 0.05) indicate that the test rejected the hypothesis that the original data could have been drawn from the fitted power-law distribution
print(fit)

sw = shapiro.test(log(distrib))  # test di Shapiro-Wilk per la normalità. Se p-value > signific_level  allora l'ipotesi di normalità è accettata
print(sw)
