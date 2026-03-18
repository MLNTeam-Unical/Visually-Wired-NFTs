# Caricamento librerie
library(igraph)
library(tictoc)

# Funzione per il calcolo delle statistiche
statistiche <- function(g, output){
    if(is.null(g)){
        stop("Grafo non valido!")
    }

    tic("Stats computation")
    
    tic("Vertices number")
    vertices <- vcount(g)
    toc()

    tic("Edges number")
    edges <- ecount(g)
    toc()

    tic("Reciprocity")
    recipr <- reciprocity(g)
    toc()

    tic("Global cc NaN")
    global_cc_nan <- transitivity(g, type = "global", isolates = "NaN")
    toc()

    tic("Local avg cc NaN")
    local_avg_cc_nan <- transitivity(g, type = "localaverage", isolates = "NaN")
    toc()

    tic("Global cc zero")
    global_cc_zero <- transitivity(g, type = "global", isolates = "zero")
    toc()

    tic("Local avg cc zero")
    local_avg_cc_zero <- transitivity(g, type = "localaverage", isolates = "zero")
    toc()

    tic("Avg. path length")
    avg_path_length <- mean_distance(g, directed = is_directed(g))
    toc()

    tic("Diameter")
    diam <- diameter(g, directed = is_directed(g))
    toc()

    tic("Density")
    density <- edge_density(g)
    toc()

    tic("Sources")
    source <- length(which(degree(g, mode = "in") == 0))
    toc()

    tic("Sinks")
    sink <- length(which(degree(g, mode = "out") == 0))
    toc()

    tic("Mean in-degree")
    mean_in_degree <- mean(degree(g, mode = "in"))
    toc()
    
    tic("Mean out-degree")
    mean_out_degree <- mean(degree(g, mode = "out"))
    toc()
    
    tic("Mean full-degree")
    mean_full_degree <- mean(degree(g, mode = "all"))
    toc()

    tic("Strongly connected components")
    strongly <- components(g, mode = "strong")
    n_strongly <- strongly$no
    toc()

    tic("Weakly connected components")
    weakly <- components(g, mode = "weak")
    n_weakly <- weakly$no
    toc()

    tic("Communities")
    comm <- cluster_louvain(as.undirected(g))
    mod <- modularity(comm)
    len <- length(comm)
    toc()

    tic("Assortativity")
    assortativity_d <- assortativity_degree(g)
    toc()

    result <- data.frame("directed" = is_directed(g), "vertices" = vertices, "edges" = edges, "reciprocity" = recipr, "global.cc.NaN" = global_cc_nan, "local.avg.cc.NaN" = local_avg_cc_nan, "global.cc.zero" = global_cc_zero, "local.avg.cc.zero" = local_avg_cc_zero, "avg.path.length" = avg_path_length, "diameter" = diam, "density" = density, "sources" = source, "sinks" = sink, "avg_in_degree" = mean_in_degree, "avg_out_degree" = mean_out_degree, "avg_full_degree" = mean_full_degree, "strongly.conn.comp" = n_strongly, "weakly.conn.comp" = n_weakly, "communities" = len, "modularity" = mod, "assortativity" = assortativity_d)

    write.csv(result, output, row.names = FALSE)

    toc()
    return(result)
}

# Caricamento dataset
nft_data <- read.csv("/home/user/Progetti/NFT-PrefAttach/graphsV2/NFTLevel-Pruning_V2/(2019, 3)/edge_list.csv", header = TRUE, colClasses = c(NA, NA, "NULL"))

# Generazione grafi
nft_graph <- graph_from_data_frame(nft_data, directed = TRUE)

# Calcolo statistiche
nft_graph_stats_2019 <- statistiche(nft_graph, output = "nft_topology_(2019, 3).csv")