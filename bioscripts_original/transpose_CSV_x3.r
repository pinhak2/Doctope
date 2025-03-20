#!/usr/bin/Rscript
#v1.0
Table <- read.csv("Table_input.csv", header = TRUE)
Table_trans <- t(Table)
write.csv(Table_trans, file = "Table_transposed_output.csv", quote = FALSE)
