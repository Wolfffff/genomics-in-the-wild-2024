# Importing qiime2 output into phyloseq and formatting for downstream analyses

# basic initialization
require(tidyverse)
require(ggplot2)
require(vegan)
require(phyloseq)
require(RColorBrewer)


# clear
rm(list = ls())

# set working directory
setwd(dir = "~/Documents/Princeton/EEB388_Kenya/data_analysis/")

# Things were sequenced in two pools
# species Pool 1 is good for Zebra and Soil
# species pool 2 is good for Hyrax and Rhino


# species Pool 1 ------------------------------------------------------------


#### species Pool 1 - Soil and Zebra
# One qiime run on everything - one OTU table
# import otu table and convert to matrix
otu_table <- read.csv("classPool1_qiime/phyloseq/otu_table.txt", sep = "\t", row.names = 1) # one big OTU table from qiime
otu_table <- as.matrix(otu_table)
colnames(otu_table) <- gsub("\\.", "-", colnames(otu_table)) # need to replace periods with dashes to match metadata sample names

# import taxonomy cleaned table and convert to matrix
taxonomy <- read.csv("classPool1_qiime/phyloseq/taxonomy_final.csv", sep = ",", row.names = 1)
taxonomy <- as.matrix(taxonomy)

# read in metadata
# note that the data is formatted differently from qiime2 format
# but just need to ensure that the sampleIDs match between qiime2 and this data table
# can edit metadata table as needed before
metadata <- read.table("classPool1_qiime/phyloseq/giw2023_meta.csv", sep = ",", row.names = 1, header = TRUE)

# read in tree
phy_tree <- read_tree("classPool1_qiime/phyloseq/tree.nwk")
# check the daughters
edges <- phy_tree(phy_tree)$edge
mycounts <- table(edges[, 1]) # Source nodes; 1st column of edge matrix
length(mycounts[mycounts == 2]) # Number of nodes with exactly 2 children
length(mycounts[mycounts != 2]) # Number of nodes with more or fewer children
mycounts[mycounts != 2] # How many nodes each of the above has

# correct for nodes with more than 2 children using ape
phy_tree_fixed <- ape::multi2di(phy_tree(phy_tree))

# import as phyloseq objects
OTU <- otu_table(otu_table, taxa_are_rows = TRUE)
TAX <- tax_table(taxonomy)
META <- sample_data(metadata)

# check for same number of OTU names across all three data types
taxa_names(TAX)
taxa_names(OTU)
taxa_names(phy_tree_fixed)

# check sample names, but genus doesn't matter
# if different number of sample names, phyloseq removes the unmatched ones
sample_names(OTU)
sample_names(META)

# import into phyloseq object
physeq <- phyloseq(OTU, TAX, META, phy_tree)

# to look at the different data types in the phyloseq object
physeq@sam_data

# separate by project
soil <- physeq %>%
  subset_samples(project == "soil") %>%
  subset_samples(gene == "16S") %>%
  # remove taxa not part of this data set
  prune_taxa(taxa_sums(.) > 0, .)

saveRDS(soil_ITS, "data_for_students/project_data/ITS/soil_physeq.RDS") # save phyloseq object

# export OTU tables by taxonomic level for vegan
ps <- soil_ITS
ps_domain <- tax_glom(ps, "domain")
otu_domain <- otu_table(ps_domain)
otu_domain <- t(otu_domain)
df_domain <- as.data.frame(otu_domain)
colnames(df_domain) <- as.data.frame(tax_table(ps_domain))$domain
write.csv(df_domain, "data_for_students/project_data/ITS/soil_domain_final.csv")
