# Data

This directory should contain the input data required to run the analysis pipeline.

## Required Files

### Embeddings
| File | Description |
|------|-------------|
| `nft2emb_dummyViT-train.pkl` | Pre-computed ViT embeddings for NFT images (CLS-pooling from `google/vit-base-patch16-224`) |
| `unique2path.pkl` | Mapping from NFT identifiers to image file paths |
| `unique2description.pkl` | Mapping from NFT identifiers to text descriptions (optional) |

### Transaction Data
| File | Description |
|------|-------------|
| `nft2txs.pkl` | Dictionary mapping each NFT to its transaction history (price, timestamp, seller, buyer) |
| `nft2category.pkl` | Mapping from NFT identifiers to their category (Art, Collectible, Games, Metaverse, Utility, Other) |
| `BTC-USD.csv` | Historical Bitcoin prices (downloaded via Yahoo Finance) |

### Images (optional, needed for explainability notebooks)
| File | Description |
|------|-------------|
| `imgs/` | Directory containing NFT images referenced by `unique2path.pkl` |

### Pre-trained Embeddings (optional, for NFT-aware pipeline)
| File | Description |
|------|-------------|
| `nft2emb_train.pt` | NFT-aware ViT embeddings (train split) |
| `nft2emb_val.pt` | NFT-aware ViT embeddings (validation split) |

## Data Source

The underlying transaction data comes from the dataset by [Nadini et al. (2021)](https://doi.org/10.1038/s41598-021-00053-8),
containing 6.1M purchase transactions involving 4.7M NFTs across 4k+ collections (2017–2021).

After filtering for accessible NFT images with at least one sale, the working dataset consists of ~180k NFTs.

## Generating Embeddings

NFT image embeddings are extracted using a pre-trained Vision Transformer (ViT):

```python
from transformers import AutoFeatureExtractor, AutoModel

feature_extractor = AutoFeatureExtractor.from_pretrained("google/vit-base-patch16-224")
model = AutoModel.from_pretrained("google/vit-base-patch16-224")
```

CLS-token pooling is applied to produce a single 768-dimensional vector per image.
