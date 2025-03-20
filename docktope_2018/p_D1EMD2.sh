########################################################################################
#  		                       Script p_D1EMD2    
########################################################################################
###Script for automated prediction of pMHC structure using the D1-EM-D2 approach
#
###
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo -e "\n           Script for automated prediction of pMHC structure.         "
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
start=$(date +%s)
#Testing epitope parameter:
echo -e "\n"
if [ -e "epitope.fasta" ]
    then
		mv epitope.fasta EPITOPE.fasta
	else
		cp *.fasta EPITOPE.fasta
fi
#
if [ -e "EPITOPE.fasta" ]
    then
        echo -e "\n\tObtaining peptide sequence...!!!"
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    else
		echo -e "\nWarning: Peptide not found!!!"
		echo -e "\nNote: Provide a text file with the peptide sequence in the FASTA format."
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
		echo -e "Which FASTA file you would like to use? (type the exact file name!)"; read epitope
		#Rename peptide file#
		cp $epitope EPITOPE.fasta
fi
#Testing allele parameter:
if test -z "$1"
	then
		echo -e "\n\tWarning: Parameters not found!!!"
		echo -e "\nUSE: p_D1EMD2 MHC-allele NP"
		echo -e "Note 1: MHC-allele must be one of A0201, B2705, H2DB, or H2KB."
		echo -e "Note 2: NP must be replaced by the number of processors available (int)."
		echo -e "Note 3: This script will search for a \"*.fasta\" file (peptide)."
		echo -e "Note 4: For testing, add \"debug\" as \$3"
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
		echo -e "Which MHC allele you would like to use?"; read allele
    else
		#Transfer $1 value#
#		allele=$1
        if [ $(echo "$1" |tr [:upper:] [:lower:]) = "a0201" ] || [ $(echo "$1" |tr [:upper:] [:lower:]) = "a-0201" ] || [ $(echo "$1" |tr [:upper:] [:lower:]) = "a2" ]
	        then
                allele=A0201
        fi
        #
        if [ $(echo "$1" |tr [:upper:] [:lower:]) = "b2705" ] || [ $(echo "$1" |tr [:upper:] [:lower:]) = "b-2705" ] || [ $(echo "$1" |tr [:upper:] [:lower:]) = "b27" ]
	        then
                allele=B2705
        fi
        #
        if [ $(echo "$1" |tr [:upper:] [:lower:]) = "h2kb" ] || [ $(echo "$1" |tr [:upper:] [:lower:]) = "h2-kb" ] || [ $(echo "$1" |tr [:upper:] [:lower:]) = "kb" ]
	        then
                allele=H2KB
        fi
        #
        if [ $(echo "$1" |tr [:upper:] [:lower:]) = "h2db" ] || [ $(echo "$1" |tr [:upper:] [:lower:]) = "h2-db" ] || [ $(echo "$1" |tr [:upper:] [:lower:]) = "db" ] || [ $(echo "$1" |tr [:upper:] [:lower:]) = "h2db9" ] || [ $(echo "$1" |tr [:upper:] [:lower:]) = "h2db10" ] || [ $(echo "$1" |tr [:upper:] [:lower:]) = "H2DB-9mer" ] || [ $(echo "$1" |tr [:upper:] [:lower:]) = "H2DB-10mer" ]  
	        then
                if [ $(echo "$1" |tr [:upper:] [:lower:]) = "h2db9" ] || [ $(echo "$1" |tr [:upper:] [:lower:]) = "h2db10" ] || [ $(echo "$1" |tr [:upper:] [:lower:]) = "H2DB-10mer" ]
                    then 
                        if [ $(echo "$1" |tr [:upper:] [:lower:]) = "h2db9" ] || [ $(echo "$1" |tr [:upper:] [:lower:]) = "H2DB-9mer" ]
            		        then		
                                allele="H2DB9"
                   			else
                                allele="H2DB10"
                        fi
                    else
                        count=$(sed -n "2p" EPITOPE.fasta | wc -m) #counts all peptide residues plus \n
                        if [ $count -eq 10 ]
                            then 
                                echo "Count: $count"
                                allele="H2DB9"
                            else
                                echo "Count: $count"
                                allele="H2DB10"
                        fi
                fi
        fi
fi
#Testing parameter for number of processors:
echo -e "\n"
if test -z "$2"
    then
		echo -e "\n\tWarning: number of processors (NP) was not provided!!!"
		echo -e "\nUSE: p_D1EMD2 MHC-allele NP"
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
		echo -e "How many processors you would like to use? (int)"; read np
    else
		#Transfer $2 value#
		np=$2
fi
#Call the following scripts in the pipeline...
#Prepar for D1:
p_prep4D1.sh $allele $np
#Remove folder of the peptide energy minimization (EM)
cp EM/target_log_EM1.log EM_peptide.log
rm -rf EM
#Run D1:
cd D1/
#if [ "$3" = "debug" ]; then
#        p_vina.sh Vina_config $np 6
#    else
        p_vina.sh Vina_config $np 20
#fi
#Choose the best result from D1 and build the final complex ("BEST"):
p_structchoice.sh D1 $allele
#Check result from previous step
if [ -e BEST_pMHC_D1.pdb ]
	then
		echo -e "\n\tProceeding to Energy Minimization stages..."
	else
		echo -e "\nWarning: \"BEST_pMHC_D1.pdb\" was not found!!"
		echo -e "\nChecking RMSCheck...\n"
		more RMSCheck*.log
		echo -e "\nAborting \"D1-EM-D2\"..."
		exit
fi
#Exit D1 folder, and copy BEST_pMHC_D1.pdb:
cp BEST_pMHC_D1.pdb ../
cd ..
#Call script to prepar for D2:
p_MHC4D2.sh $allele $np
#Remove folder of the pMHC energy minimization (pMHC_EM)
cp pMHC_EM/target_log_EM1.log EM_pMHC.log
rm -rf pMHC_EM/
#Run D2:
cd $allele-D2/
#if [ "$3" = "debug" ]; then
#        p_vina.sh Vina_config $np 10
#    else
        p_vina.sh Vina_config $np 20
#fi
#Choose the best result from D2:
p_structchoice.sh D2 $allele
#Add TITLE to generated PDB, and create summary.txt:
p_finalize.sh $allele
#Save p_D1EMD2 runtime to summary.txt
cd ..
end=$(date +%s)
secs=$((end-start))
runtime=$(printf '%dh:%dm:%ds\n' $(($secs/3600)) $(($secs%3600/60)) $(($secs%60)))
echo -e "\nDockTope runtime: $runtime." >> summary.txt
echo -e "\nD1-EM-D2 runtime: $runtime.\n"
