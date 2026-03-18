# Caricamento librerie
library(igraph)

# Caricamento funzione kcore
k_core <- function(graph, output){

    if(!is_directed(graph)){
        stop("Errore! Grafo non orientato ricevuto.")
    }

    # Calcolo la coreness orientata - in
    in_core <- coreness(graph, mode = "in")
    graph_max_coreness_in <- max(in_core)

    # Calcolo la coreness orientata - out
    out_core <- coreness(graph, mode = "out")
    graph_max_coreness_out <- max(out_core)

    # Calcolo la coreness non orientata - all
    all_core <- coreness(graph, mode = "all")
    graph_max_coreness_all <- max(all_core)
    
    # Preparo i nomi dei file
    distribution_output_in <- paste("distribution_in_", output, sep = "")
    distribution_output_out <- paste("distribution_out_", output, sep = "")
    distribution_output_all <- paste("distribution_all_", output, sep = "")
    info_output <- paste("info_", output, sep = "")

    # Esporto le distribuzioni
    in_distribution <- data.frame("node" = names(in_core), as.data.frame(in_core))
    out_distribution <- data.frame("node" = names(out_core), as.data.frame(out_core))
    all_distribution <- data.frame("node" = names(all_core), as.data.frame(all_core))

    write.csv(in_distribution, distribution_output_in, row.names = FALSE)
    write.csv(out_distribution, distribution_output_out, row.names = FALSE)
    write.csv(all_distribution, distribution_output_all, row.names = FALSE)

    # Calcolo le statistiche - in
    graph_vertices_max_coreness_in <- which(in_core == graph_max_coreness_in)
    induced_k_graph_in <- induced_subgraph(graph, vids = graph_vertices_max_coreness_in)

    # Calcolo le statistiche - out
    graph_vertices_max_coreness_out <- which(out_core == graph_max_coreness_out)
    induced_k_graph_out <- induced_subgraph(graph, vids = graph_vertices_max_coreness_out)

    # Calcolo le statistiche - all
    graph_vertices_max_coreness_all <- which(all_core == graph_max_coreness_all)
    induced_k_graph_all <- induced_subgraph(graph, vids = graph_vertices_max_coreness_all)

    # Preparo il dataframe con le statistiche
    parziali <- data.frame()

    info_in <- data.frame("mode" = "in", "inner_most_vertices" = vcount(induced_k_graph_in), "inner_most_edges" = ecount(induced_k_graph_in), "max_coreness" = graph_max_coreness_in)
    parziali <- rbind(parziali, info_in)

    info_out <- data.frame("mode" = "out", "inner_most_vertices" = vcount(induced_k_graph_out), "inner_most_edges" = ecount(induced_k_graph_out), "max_coreness" = graph_max_coreness_out)
    parziali <- rbind(parziali, info_out)

    info_all <- data.frame("mode" = "all", "inner_most_vertices" = vcount(induced_k_graph_all), "inner_most_edges" = ecount(induced_k_graph_all), "max_coreness" = graph_max_coreness_all)
    parziali <- rbind(parziali, info_all)

    # Esporto le informazioni
    write.csv(parziali, info_output, row.names = FALSE)
    
    # Salvo i grafi
    induced_k_graph_in_file <- as_data_frame(induced_k_graph_in)
    colnames(induced_k_graph_in_file) <- c("source", "target")
    
    induced_k_graph_out_file <- as_data_frame(induced_k_graph_out)
    colnames(induced_k_graph_out_file) <- c("source", "target")
    
    induced_k_graph_all_file <- as_data_frame(induced_k_graph_all)
    colnames(induced_k_graph_all_file) <- c("source", "target")
    
    write.csv(induced_k_graph_in_file, "inner_most_core_nft(2019, 3)_in.csv", row.names = FALSE)
    write.csv(induced_k_graph_out_file, "inner_most_core_nft(2019, 3)_out.csv", row.names = FALSE)
    write.csv(induced_k_graph_all_file, "inner_most_core_nft(2019, 3)_all.csv", row.names = FALSE)
}

# Caricamento dataset
nft_data <- read.csv("/home/user/Progetti/NFT-PrefAttach/graphsV2/NFTLevel-Pruning/(2019, 3)/edge_list.csv", header = TRUE, colClasses = c(NA, NA, "NULL"))

# Generazione grafi orientati
nft_graph <- graph_from_data_frame(nft_data, directed = TRUE)
nft_graph <- simplify(nft_graph, edge.attr.comb = 'mean')

# K-Core decomposition
k_core(nft_graph, "kcore_nft_(2019, 3).csv")
