#!/usr/bin/Rscript
#v1.0
HCA_data <- read.csv("HCA_input.csv", header = TRUE)
#
library (pvclust)
#
HCA_5k <- pvclust(HCA_data, method.dist='cor', method.hclust='average', nboot=10000)
#
HCA_5k_plot <- plot(HCA_5k)
#
#HCA_5k_plot2 <- pvrect(HCA_5k, alpha=0.95)
#
SEplot_HCA_5k <- seplot(HCA_5k, identify=FALSE)
#
