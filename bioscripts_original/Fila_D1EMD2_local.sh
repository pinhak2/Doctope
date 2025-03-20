########################################################################################
#  		                   Script Multi-D1EMD2 v3.0 (p_mD1EMD2)    
########################################################################################
##Script to run "p_D1EMD2" for all *.fasta in the folder, or a CSV file with
##Initializing user interface...
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo -e "\n                \"Script Multi-D1EMD2 v3.0 (p_mD1EMD2)\"                "
echo -e "\nNOTE: This script will search for a \"*.csv\" table or \"*.fasta\" files."
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
##Checking parameters...
#
#Testing $3 (CSV Table with a list of epitopes)
if test -z "$3"
	then
		#Checking for CSV files in this folder:
		echo -e "\nSearching for input files (CSV)..."
		table=$(cat *.csv)	
		if test -z "$table"
			then
				echo -e "\nSearching for input files (FASTA)..."
				fasta=$(cat *.fasta)	
				if test -z "$fasta"
					then
				        echo -e "\n####\t  WARNING: FAIL TO FIND ANY CSV OR FASTA FILES!!!\t ####"
				        echo -e "\nListing accepted parameters for p_mD1EMD2:"
				        echo -e "\$1> MHC allele;"
				        echo -e "\$2> Number of cores;"
				        echo -e "\$3> Input CSV Table   (optional);"
				        echo -e "\$4> NH (\"No Heading\") (optional);"
				        echo -e "\nValid Examples:"
				        echo -e "(1) p_mD1EMD2 H2KB 4"
				        echo -e "(2) p_mD1EMD2 A0201 8 Table.csv"
				        echo -e "(3) p_mD1EMD2 B2705 6 ~/Downloads/Table.csv nh"
				        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"  
						exit
					else
						echo -e "\nProceeding with following targets:"
						ls -cr -w 75 *.fasta
						echo -e "\n"
				fi
			else
				#Execute fastaSaver script
				echo -e "\nInitiating \"fastaSaver\"..."
				fastaSaver
		fi
	else
		if [ -e $3 ]
			then
				#Testing $4 parameter (no heading) 
				if test -z "$4"
					then
						#Execute fastaSaver script
						fastaSaver $3
					else
						#Execute fastaSaver script
						fastaSaver $3 nh
				fi
			else
				#User provided an invalid $3 parameter (CSV Table not found!)
				echo -e "\nSearching for input files (CSV)..."
				table=$(cat *.csv)
				if test -z "$table"
					then
				        echo -e "WARNING: Fail to find \$3 parameter (\"$3\") or any CSV file!!\n"
				        echo -e "Listing accepted parameters for p_mD1EMD2:"
				        echo -e "\$1> MHC allele;"
				        echo -e "\$2> Number of cores;"
				        echo -e "\$3> Input CSV Table   (optional);"
				        echo -e "\$4> NH (\"No Heading\") (optional);"
				        echo -e "\nValid Examples:"
				        echo -e "(1) p_mD1EMD2 H2KB 4"
				        echo -e "(2) p_mD1EMD2 A0201 8 Table.csv"
				        echo -e "(3) p_mD1EMD2 B2705 6 ~/Downloads/Table.csv nh"
				        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"  
						exit
					else
                        #Execute fastaSaver script with the 1st CSV in the folder
                        echo -e "\nWARNING: Fail to find \$3 parameter (\"$3\")..."                        
                        ls -1 *.csv > csvs.list
				        firstcsv=$(sed -n 1p csvs.list)
						echo -e "\nInitiating \"fastaSaver\" with \"$firstcsv\"..."
                        rm csvs.list
                        sleep 3                        
                        #Saving LOG of this incident:
                        echo -e "\nWARNING: Fail to find \$3 parameter (\"$3\")..." > Warning-CSV.log    
						echo -e "\nInitiating \"fastaSaver\" with \"$firstcsv\"..." >> Warning-CSV.log
                        echo -e "\nNOTE: Assuming that \"$firstcsv\" has Headings (1st line will be excluded)..."  >> Warning-CSV.log
						fastaSaver $firstcsv
				fi			
		fi
fi
#Testing for Warnings
if [ -e Warning.log ]
    then
        echo -e "\n"
        more Warning.log
        echo -e "\n"
        exit
fi
#
echo -e "Initiating \"D1-EM-D2\"..."
sleep 3
#Testing $1 (allele)
if test -z "$1"
    then
        echo -e "\nWARNING: Missing MHC allele information!"
		echo -e "\nNOTE: Accepted alleles are A0201, B2705, H2DB and H2KB."
        echo -e "\nWhich allele you would like to use?"; read allele
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        echo -e "\n         Allele parameter received."
        echo -e "\n         Running p_D1EMD2 for $allele"
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"            
    else
        #Proceeding with script#
        allele=$1
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        echo -e "\n         Allele parameter received."
        echo -e "\n         Running p_D1EMD2 for $allele"
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"       
fi
#
#Testing $2 (number of cores)
if test -z "$2"
    then
        echo -e "\nWARNING: Missing information on the number of cores to be used!"
        echo -e "\nNOTE: Autodock Vina can run in parallel (Faster!)."
        echo -e "\nHow many cores (or threads) you would like to use? (Enter the nº)"; read np
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        echo -e "\n         Autodock Vina will be distributed in $np cores."
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"            
    else
        #Proceeding with script#
        np=$2
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        echo -e "\n         Autodock Vina will be distributed in $np cores."
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"  
fi
#
#Prepare Folders
if [ -e Results ]
	then
		tar -czvf Backup_Overwritten-Files.tar.gz Results Fastas-Done Finished-Complexes.txt
		rm -rf Results Fastas-Done Finished-Complexes.txt
		mkdir Results Fastas-Done
	else
		mkdir Results Fastas-Done
fi
#
#Starting script tasks for FASTA files...
echo "Finished Complexes:" > Finished-Complexes.txt
for fasta in *.fasta ; do  #(1)Loop with all *.fasta in the folder.
	fname=${fasta%.*};     #(2)Get the name of the file, without extension.
    #
	if [ -e $fname ]       #(3)Check if this folder was created before.
		then
			echo -e "WARNING: This folder already exists. Old version will be removed."
		    rm -rf $fname  #(4)Remove obsolete folder.
		else
			echo -e "\nProceeding to \"D1EMD2\" with $fname.\n"
	fi
    #
	mkdir $fname
	cp $fasta $fname/
	cd $fname
	p_D1EMD2 $allele $np                          #(5)Run "D1EMD2"
	if [ -e D1/BEST_pMHC_D1.pdb ]                 #(6)Check Result "D1"
		then
			cd *-D2/
			mv FINAL-$allele-pMHC.pdb $fname-pMHC.pdb #(7)Rename resultant complex.
			cp	$fname-pMHC.pdb ../../Results         #(8)Copy result.
			cd ../../
			if [ -e Results/$fname-pMHC.pdb ]         #(9)Check Result "D2"
				then
					mv $fasta Fastas-Done             #(10)Move *fasta if result was OK.
					echo "$fname (OK)" >> Finished-Complexes.txt
				else
					echo -e "WARNING: Complex $fname-pMHC.pdb was not located!!"
			fi
		else
			echo -e "\nWARNING: \"BEST_pMHC_D1.pdb\" was not found!!"
			echo -e "\nWARNING: Aborting $fname modeling."
			echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"  
			cd ../
			echo "$fname >> ABORTED!" >> Finished-Complexes.txt
	fi
done
