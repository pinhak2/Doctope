#!/usr/bin/Rscript
#v1.0
ASA_Results_Table_default <- read.csv("ASA_Results_Table_default.csv", header = TRUE)
ASA_Results_Table_Rclust <- t(ASA_Results_Table_default)
write.csv(ASA_Results_Table_Rclust, file = "ASA_Results_Table_PVclust.csv", quote = FALSE)
#sed -i '/,V1/d' ASA_Results_Table_t.csv
