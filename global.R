library(shiny)
library(DT)

smac_genes <- c("SNAI2", "BIM", "MIB2", "TNFRSF1B", "FASLG", "GPR25", "MAPK8",
  "FAS", "RELA", "BIRC3", "BIRC2", "AKAP3", "TNFRSF1A", "RNF31",
  "RIPK3", "NFKBIA", "TRAF3", "CYLD", "MLKL", "MAP3K14", "BIRC5",
  "REL", "CFLAR", "CASP8", "RBCK1", "BIRC7", "NR2C2", "TNFSF10",
  "OTULIN", "RIPK1", "TNF", "MAPK14", "TNFAIP3", "SND1",
  "TNFRSF10B", "TNFRSF10C", "TNFRSF10D", "TNFRSF10A", "IKBKB",
  "RIPK2", "SHARPIN", "TRAF2")

smac_genes <- smac_genes[order(smac_genes)]
load("C:/Users/giner.g.WEHI/Google Drive/Files/datasets/DGEList_ERvsTNBC_Filt_Norm.RData")
o <- order(d$genes$Symbol)
d <- d[o,]

genes_all <- d$genes$Symbol
# d.fn.smac <- d.fn[d.fn$genes$Symbol %in% smac,]

pval.all <- read.csv("C:/Users/giner.g.WEHI/Google Drive/Files/datasets/ERvsTN_all.csv", row.names = 1)[ , c(1, 4:5, 9)]
colnames(pval.all) <- c("Gene", "Description", "Fold Change", "Adjusted Pvalue")
pval.all$`Adjusted Pvalue` <- format(pval.all$`Adjusted Pvalue`, scientific = TRUE, digits = 3)
pval.all$`Adjusted Pvalue` <- as.numeric(pval.all$`Adjusted Pvalue`)
pval.all$`Fold Change` <- as.numeric(pval.all$`Fold Change`)
pval.all$`Fold Change` <- round(pval.all$`Fold Change`, 3)
pval.all <- pval.all[order(pval.all$Gene),]
# pval.smac <- pval.all[pval.all$Gene %in% smac,]

#col <- c("#FF9999","#9370db")

col <- c("#cc99ff", "#ff9999")

