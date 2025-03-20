########################################################################################
#      		                   Script p_asa v2.5    
########################################################################################
#v2.5.2
##Script to calculate and recover ASA values for selected residues of pMHC complexes.
#Initializing user interface...
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo -e "\n                        \"p_asa v2.5\"                         "
echo -e "\n     Pipeline to calculate and recover ASA values of pMHC complexes"
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
#Confirming actions...
echo -e "\n NOTE: This script will list ALL PDB FILES in this folder. All PDB files"
echo -e "will be used as input for ASA assessment with Naccess program."
echo -e "\n Note 2: All pMHC PDBs must be a product of \"D1EMD2\"."
echo -e "\n Note 3: Residues will be selected based on \"HLA-A*02:01\"."
echo -e "\nAre you sure you want to proceed? (y/n)"; read question0         		
if [ $question0 = 'y' ] || [ $question0 = 'Y' ]
	then
		echo -e "\n>>>\nProceeding with Naccess tasks...\n>>>\n"
        for pdbfile in *.pdb ; do
        naccess $pdbfile
        done        
        mkdir Naccess_LOGs Naccess_ASAs Naccess_RSAs Input_PDBs
        mv *.log Naccess_LOGs
        mv *.asa Naccess_ASAs
        mv *.pdb Input_PDBs
	else
		echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
		echo -e "\n                  Thanks for using \"p_asa v2.5\"                 "
		echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
		exit
fi
##Proceeding with data extraction...
for rsafile in *.rsa ; do
	fname=${rsafile%.*};
	sed '/REM/d' $rsafile > A.txt
	sed '/END/d' A.txt > B.txt
	sed '/CHAIN/d' B.txt > C.txt
	sed '/TOTAL/d' C.txt > D.txt
	awk '{if($1="RES") print $2, $3, $4, $5}' D.txt > E.txt
	sed -n '/GLU A 19 /p' E.txt > 1.txt
	sed -n '/GLU A 58 /p' E.txt > 2.txt
	sed -n '/TYR A 59 /p' E.txt > 3.txt
	sed -n '/GLY A 62 /p' E.txt > 4.txt
	sed -n '/ARG A 65 /p' E.txt > 5.txt
	sed -n '/LYS A 66 /p' E.txt > 6.txt
	sed -n '/LYS A 68 /p' E.txt > 7.txt
	sed -n '/ALA A 69 /p' E.txt > 8.txt
	sed -n '/SER A 71 /p' E.txt > 9.txt
	sed -n '/GLN A 72 /p' E.txt > 10.txt
	sed -n '/THR A 73 /p' E.txt > 11.txt
	sed -n '/ARG A 75 /p' E.txt > 12.txt
	sed -n '/VAL A 76 /p' E.txt > 13.txt
	sed -n '/LYS A 146 /p' E.txt > 14.txt
	sed -n '/TRP A 147 /p' E.txt > 15.txt
	sed -n '/ALA A 149 /p' E.txt > 16.txt
	sed -n '/ALA A 150 /p' E.txt > 17.txt
	sed -n '/HIS A 151 /p' E.txt > 18.txt
	sed -n '/VAL A 152 /p' E.txt > 19.txt
	sed -n '/GLU A 154 /p' E.txt > 20.txt
	sed -n '/GLN A 155 /p' E.txt > 21.txt
	sed -n '/ALA A 158 /p' E.txt > 22.txt
	sed -n '/TYR A 159 /p' E.txt > 23.txt
	sed -n '/GLY A 162 /p' E.txt > 24.txt
	sed -n '/THR A 163 /p' E.txt > 25.txt
	sed -n '/GLU A 166 /p' E.txt > 26.txt
	sed -n '/TRP A 167 /p' E.txt > 27.txt
	sed -n '/ARG A 170 /p' E.txt > 28.txt
	cat 1.txt 2.txt 3.txt 4.txt 5.txt 6.txt 7.txt 8.txt 9.txt 10.txt 11.txt 12.txt 13.txt 14.txt 15.txt 16.txt 17.txt 18.txt 19.txt 20.txt 21.txt 22.txt 23.txt 24.txt 25.txt 26.txt 27.txt 28.txt > "$fname"_MHCres.rsa
	awk '{print $4}' "$fname"_MHCres.rsa > "$fname"_MHCres_JustASA.rsa
    #Obtaining epitope values
    awk '{print ""$2" "$3" "$4""}' E.txt > F.txt
    sed '/A/d' F.txt > G.txt
    sed '/B/d' G.txt > H.txt
    awk '{print $3}' H.txt > "$fname"_EPres_JustASA.rsa
    #Cat RSAs from MHC and epitope 
    echo $fname | cat > fname.txt
    cat fname.txt "$fname"_EPres_JustASA.rsa "$fname"_MHCres_JustASA.rsa > "$fname"_EPMHCres_JustASA.rsa
    echo $(<"$fname"_EPMHCres_JustASA.rsa) > "$fname"_EPMHCres_JustASA_Line.txt
    #Delete temp files
    rm A.txt B.txt C.txt D.txt E.txt F.txt G.txt H.txt 1.txt 2.txt 3.txt 4.txt 5.txt 6.txt 7.txt 8.txt 9.txt 10.txt 11.txt 12.txt 13.txt 14.txt 15.txt 16.txt 17.txt 18.txt 19.txt 20.txt 21.txt 22.txt 23.txt 24.txt 25.txt 26.txt 27.txt 28.txt "$fname"_MHCres.rsa "$fname"_MHCres_JustASA.rsa "$fname"_EPres_JustASA.rsa fname.txt "$fname"_EPMHCres_JustASA.rsa
	mv $rsafile Naccess_RSAs
done
##Proceeding with data export...
cat /usr/local/bioscripts/biofiles/ASA_Header.txt *Line.txt > ASA_Results_Table.txt
tr ' ' ',' <ASA_Results_Table.txt > ASA_Results_Table_default.csv
tr ',' ';' <ASA_Results_Table_default.csv > ASA_Results_Table_edited.csv
tr '.' ',' <ASA_Results_Table_edited.csv > ASA_Results_Table_SPSS.csv
#Trnaspose Matrix for use with PVclust.
/usr/local/bioscripts/transpose_CSV_x2.r
sed -i '/,V1/d' ASA_Results_Table_PVclust.csv
sed -i 's/[^,]*,//' ASA_Results_Table_PVclust.csv
#
rm ASA_Results_Table.txt ASA_Results_Table_edited.csv
#
mkdir Temp_Lines Naccess_Files
mv *Line.txt Temp_Lines
mv Temp_Lines Naccess_LOGs Naccess_ASAs Naccess_RSAs Naccess_Files
#
echo -e "\n Naccess tasks were concluded."
echo -e " For ASA values, check one of the \"ASA_Results_Table\" available."
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo -e "\n                  Thanks for using \"p_asa v2.5\"                 "
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
