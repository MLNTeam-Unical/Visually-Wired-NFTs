# Visually Wired NFTs: Exploring the Role of Inspiration in Non-Fungible Tokens

[![Paper](https://img.shields.io/badge/ACM%20TWEB-10.1145%2F3703411-blue?style=for-the-badge)](https://dl.acm.org/doi/10.1145/3703411)

**Lucio La Cava** · **Davide Costa** · **Andrea Tagarelli**

*University of Calabria*

*ACM Transactions on the Web*, Vol. 19, No. 2, Article 15, May 2025

---

## Abstract

The fervor for Non-Fungible Tokens (NFTs) attracted countless creators, leading to a Big Bang of digital assets driven by latent or explicit forms of inspiration, as in many creative processes. This work exploits Vision Transformers and graph-based modeling to delve into visual inspiration phenomena between NFTs over the years, i.e., the visual influence that can be detected whenever an NFT appears to be visually close to another that was published earlier in the market. Our goals include unveiling the main structural traits that shape visual inspiration networks, exploring the interrelation between visual inspiration and asset performances, investigating crypto influence on inspiration processes, and explaining the inspiration relationships among NFTs. Our findings unveil how the pervasiveness of inspiration led to a temporary saturation of the visual feature space, the impact of the dichotomy between inspiring and inspired NFTs on their financial performance, and an intrinsic self-regulatory mechanism between markets and inspiration waves. Our work can serve as a starting point for gaining a broader view of the evolution of Web3.

---

## Repository Structure

```
.
├── notebooks/                                         # Jupyter notebooks (Python)
│   ├── Crawl.ipynb                                    #   NFT metadata crawling (Alchemy/OpenSea)
│   ├── GenerateInput_data.ipynb                       #   Transaction data preprocessing
│   ├── GenerateDataset.ipynb                          #   Dataset subset creation
│   ├── Graph_Generator_V2NFT_Level.ipynb              #   NFT-level graph generation
│   ├── Graph_Generator_V2 COLL_Level.ipynb            #   Collection-level graph generation (MAX/MEAN/MIN)
│   ├── GraphExplorator NFT-Level.ipynb                #   NFT-level graph exploration & TLCC analysis
│   ├── GraphExplorator COLL_Level.ipynb               #   Collection-level graph exploration & TLCC
│   ├── GraphExploratorCOLL_from_NFT.ipynb             #   Collection graphs derived from NFT-level
│   ├── RQ_Answers.ipynb                               #   Research question analysis
│   ├── PA-check.ipynb                                 #   Preferential attachment verification
│   ├── Entropy_check.ipynb                            #   Community analysis
│   ├── UMAP_plot.ipynb                                #   UMAP embedding visualization
│   ├── SHAP Explainability.ipynb                      #   SHAP-based visual explainability
│   └── Lime explainability.ipynb                      #   LIME-based visual explainability
│
├── scripts/                                           # R scripts for graph analysis
│   ├── nft_level/                                     #   NFT-level
│   │   ├── pl_fit.R                                   #     Power-law fitting (in-degree)
│   │   ├── statistiche_topology.R                     #     Graph topology statistics
│   │   ├── kcore_decomposition.R                      #     K-core decomposition
│   │   └── inner_k_core_plot.R                        #     K-core shell visualization
│   └── collection_level/                              #   Collection-level
│       ├── pl_fit.R                                   #     Power-law fitting (in-degree)
│       ├── statistiche_topology.R                     #     Graph topology statistics
│       ├── kcore_decomposition.R                      #     K-core decomposition
│       └── inner_k_core_plot.R                        #     K-core shell visualization
│
├── data/                                              # Input data (see data/README.md)
├── output/                                            # Generated graphs and plots
└── requirements.txt                                   # Python dependencies
```

---

## Pipeline

```
 1. Data Acquisition & Preprocessing
    └─ Crawl.ipynb → GenerateInput_data.ipynb → GenerateDataset.ipynb

 2. Graph Generation
    ├─ Graph_Generator_V2NFT_Level.ipynb       → NFT-level similarity graphs
    └─ Graph_Generator_V2 COLL_Level.ipynb     → Collection-level graphs (MAX/MEAN/MIN)

 3. Structural Analysis
    ├─ GraphExplorator NFT-Level.ipynb         → Time series & TLCC analysis
    ├─ GraphExplorator COLL_Level.ipynb        → Collection-level TLCC analysis
    ├─ PA-check.ipynb                          → Preferential attachment checks
    ├─ scripts/*/pl_fit.R                      → Power-law fitting (KS-test)
    ├─ scripts/*/statistiche_topology.R        → Topology statistics
    └─ scripts/*/kcore_decomposition.R         → K-core analysis

 4. Market & Crypto Analysis
    └─ RQ_Answers.ipynb                        → Copy-rate, volume, price analysis

 5. Explainability
    ├─ SHAP Explainability.ipynb               → SHAP attribution heatmaps
    └─ Lime explainability.ipynb               → LIME superpixel explanations

 6. Additional Analysis
    ├─ Entropy_check.ipynb                     → Community structure analysis
    └─ UMAP_plot.ipynb                         → Embedding space visualization
```

---

## Graph Model

**NFT Graph.** A directed weighted graph where nodes are NFTs. An edge from *v_i* to *v_j* (from different collections) indicates that *v_i* appeared after *v_j* in the market, with weight equal to cosine similarity in the ViT embedding space. Only edges with similarity ≥ 0.5 are retained.

**Collection Graph.** An aggregated graph where nodes are collections. Edge weights are computed using one of three linkage criteria (**max**, **avg**, **min**) over pairwise NFT similarities, with a penalization factor accounting for the proportion of contributing NFTs.

---

## Setup

### Python

```bash
pip install -r requirements.txt
```

> **Python version:** 3.7+ (developed with 3.7.13)
>
> **Key dependencies:** PyTorch, Transformers (ViT), torchmetrics, NetworkX, pandas, matplotlib, SHAP, LIME, umap-learn, yfinance

### R

```r
install.packages(c("igraph", "poweRlaw", "tictoc", "ggplot2"))
```

### Data

See [`data/README.md`](data/README.md) for required input files and instructions.

The underlying transaction data comes from [Nadini et al. (2021)](https://doi.org/10.1038/s41598-021-00053-8).
NFT image embeddings are extracted using a pre-trained [ViT-base-patch16-224](https://huggingface.co/google/vit-base-patch16-224) via CLS-token pooling.

---

## Citation

If you use this code or data, please cite our paper:

```bibtex
@article{10.1145/3703411,
  author    = {La Cava, Lucio and Costa, Davide and Tagarelli, Andrea},
  title     = {Visually Wired NFTs: Exploring the Role of Inspiration in
               Non-Fungible Tokens},
  year      = {2025},
  issue_date = {May 2025},
  publisher = {Association for Computing Machinery},
  address   = {New York, NY, USA},
  volume    = {19},
  number    = {2},
  issn      = {1559-1131},
  url       = {https://doi.org/10.1145/3703411},
  doi       = {10.1145/3703411},
  journal   = {ACM Trans. Web},
  month     = may,
  articleno = {15},
  numpages  = {18},
  keywords  = {NFT similarity search, visual inspiration, web graph mining, Web3}
}
```
