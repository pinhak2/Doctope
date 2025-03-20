#!/bin/bash
#$ -S /bin/sh
#$ -N DMD_A02
#$ -o .
#$ -e .
#$ -q p_fat_small.q
#$ -pe mpich 16-32
#$ -cwd
#
allele=A0201
##############################################################################
#p_mD1EMD2-CESUP_v6.0
##Script to run "p_D1EMD2" for all *.fasta in the folder.
echo -e "\nSearching for input files (FASTA)..."
fasta=$(cat *.fasta)	
    if test -z "$fasta"
		then
	        echo -e "\n####\t  WARNING: FAIL TO FIND ANY FASTA FILES!!!\t ####"
			exit
		else
			echo -e "\nProceeding with following targets:"
			ls -cr -w 75 *.fasta
			echo -e "\n"
    fi
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
#Proceed with modeling tasks...
echo -e "Initiating \"D1-EM-D2\"..."
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
	bash /home/u/biogeek/bioscripts-CESUP/p_D1EMD2-CESUP.sh $allele $NSLOTS #(5)Run "D1EMD2"
	if [ -e D1/BEST_pMHC_D1.pdb ]                     #(6)Check Result "D1"
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
###
