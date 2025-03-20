#Transpose Matrix from SPSS for use with PVclust.
#v1.0
fname=${$1%.*};
cp $1 Table_input.csv
/usr/local/bioscripts/transpose_CSV_x3.r
sed -i '/,V1/d' Table_transposed_output.csv
sed -i 's/[^,]*,//' Table_transposed_output.csv
mv Table_transposed_output.csv "$fname"_Table_PVclust.csv 
rm Table_input.csv
#