########################################################################################
#      		                   Structchoice v20.0.9            
#                 Script to automate the selection of vina outputs
########################################################################################
#!/bin/bash
#$1=D1, D2
#$2=Allele
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo -e "\n    Script for automated analysis of multiple Vina outputs\n"
#Testing parameters:
if test -z "$1"
    then
        echo -e "\n               Warning: Parameters not found!!!"
        echo -e "\n               Use: p_structchoice option"
        echo -e "\n               Accepted options: D1, D2"
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        echo -e "Type one of the options:"; read option            
    else
        #Prosseguir com o script#
        option=$1
fi
#
echo -e "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo -e "\n         Parameters sucessfully identified."
echo -e "\n         Starting analysis of $option."
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"    
#Proceed with script
if [ $(echo "$option" |tr [:upper:] [:lower:]) = "d1" ] || [ $(echo "$option" |tr [:upper:] [:lower:]) = "d2" ]
    then
        #Check if there are vina outputs  
        if [ -e vina_out_1.pdbqt ]
            then
                echo -e "\nStarting Vina_split...\n"
            else            
                #Check if the script was previously executed in this folder
                if [ -e Vina_OUTs ]
                    then
                        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
                        echo -e "\nWarning: p_structchoice was previously executed in this folder."
                        echo -e "\nRepeat choice using files from Vina_OUTs folder? [y/n]"; read repeat
                            if [ $repeat = 'Y' ] || [ $repeat = 'y' ]
                                then
                                    #Reorganize files to repeat choice
                                    cp Vina_OUTs/* .
                                    cp LOGs/* .                                    
                                    rm -R Top20 Selected-structures LOGs Vina_OUTs TheOne \#* RMSCheck*.log
                                else
                                    #Abort
                                    echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
                                    echo -e "\n     Script aborted by the user."
                                    echo -e "\n     Check the folder in which p_structchoice is being executed."
                                    echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
                                    exit
                            fi
                    else
                        #Abort
                        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
                        echo -e "\n     Warning: There are no Vina outputs in this folder."
                        echo -e "\n     Check the folder in which p_structchoice is being executed."
                        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
                        exit
                fi                    
        fi
        #Loop to run vina_split 20 times
        for ((vs=1; vs <= 20 ; vs++))
            do
                vina_split --input vina_out_$vs.pdbqt --ligand vina_out_$vs-ligand_
                pdbqt_to_pdb.py -f vina_out_$vs-ligand_1.pdbqt -o vina_out_$vs-ligand_1.pdb
            done
    else
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        echo -e "\n                  Warning: Parameters not found!!!"
        echo -e "\n                Note: Accepted parameters are D1 or D2."
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
        #Abort
        exit
fi
################################################
# Choose logs with best Bindeing Energies (BEs)
# Mean of BEs
var=1
count=0
#
until [ $var = "0" ]; do
   awk 'match($0,"   1 ") != 0 {print $2}' log_$var > BE_$var
   var=`expr $var + 1` 
   if [ $count = 19 ]; then
      var=0
   fi
   count=`expr $count + 1`    
done
#
cat BE_1 BE_2 BE_3 BE_4 BE_5 BE_6 BE_7 BE_8 BE_9 BE_10 BE_11 BE_12 BE_13 BE_14 BE_15 BE_16 BE_17 BE_18 BE_19 BE_20 > BE_cat
#
awk '{sum=sum+$1}END{print sum}' BE_cat > BE_sum
variavel=$(awk '{ div1=$1/20 } { print div1 }' BE_sum)
#
var=1
count=0
#
until [ $var = "0" ]; do
   awk 'match($0,"   1 ") != 0 {print $2}' log_$var > log_$var.2
   awk '{if($1<= '$variavel') print $1}' log_$var.2 >log_$var.3
   sed "s/^-[0-9]/log_$var &/" log_$var.3 >log_$var.4
   awk '/^l/ {print $1}' log_$var.4 >log_$var.5
   sed "s/log_$var/cp vina_out_$var-ligand_1.pdb Selected-structures/g" log_$var.5  >log_$var.6 
   var=`expr $var + 1` 
   if [ $count = 19 ]; then
      var=0
   fi
   count=`expr $count + 1`    
done
#
#Concatenate log_*.6 files and execute the command 'cp' inside log_list, which will copy the .pdb structures with best BE
cat log_*.6 > log_list
chmod +x log_list
#
# Remove log files that will not be used
for ((x=1; x <= 20 ; x++))
    do
        for ((y=2; y<= 6 ; y++))
            do
            rm log_$x.$y
            done
    done
#
#If the file exists, and is bigger than '0 kb', execute it. If not, exit.
if [ -s log_list ]
    then
        mkdir Selected-structures
        ./log_list
    else
        rm log_list
        echo
        echo -e "\tNo file was found that correspond to the specified BE treshold!"
        echo
        exit
fi
#
#Enter the folder with the choosen structures
cd Selected-structures

# Test the existence of '.pdb' files and execute the script in case it finds;
for ((x=1; x <= 20 ; x++)); do
	if [ -e vina_out_$x-ligand_1.pdb ]; then
		echo "Note: vina_out_$x-ligand_1.pdb -File exists."

	for ((y=1; y <= 20 ; y++)); do
		if [ -e vina_out_$y-ligand_1.pdb ]; then
			echo "Note: vina_out_$y-ligand_1.pdb -File exists."
			
		# Script for g_confrms;
			#echo -e "1\r\n1\r" | g_confrms -f1 vina_out_$x-ligand_1 -f2 vina_out_$y-ligand_1 -o $x-RMSD-$x-$y > RMSD-$x-$y
            #If Gromacs 5.x or newer
			echo -e "1\r\n1\r" | gmx confrms -f1 vina_out_$x-ligand_1 -f2 vina_out_$y-ligand_1 -o $x-RMSD-$x-$y > RMSD-$x-$y

			awk '/^Root/ {print $9}' RMSD-$x-$y > rmsd-$x-$y
			rm RMSD-$x-$y

		#Concatenate files containing the RMSDs between pairs of peptides; one file per peptide
		#a=1og_$var
			cat rmsd-$x-* > cat-$x
		fi

	# Remove lines with 'e' from concatenated files.
	# They correspond to RMSDs of a peptide against itself.
		sed /'e'/d cat-$x > cat-$x-del
		#find cat-$x-del -size -30c | xargs rm	


	# Sum the values of each line and divide by the number of rows (returns the mean RMSD of each ligand);
	# Count the number of rows of each file cat-x-del; 
		awk '/[0-9]/ { ++x } END { print x}' cat-$x-del > cat-lines$x

	# Remove .gro files (output of confrms)
		#rm *.gro

	# Loop to calculate the mean;
	# Sum of all rows;
		paste -s -d + cat-$x-del | bc > cat-$x-sum

	# Single file with the sum on the 1st column and the number of rows on the 2nd;
		paste cat-$x-sum cat-lines$x > cat-$x-sum-and-line

	# Compute mean;
		awk '{ div1=$1/$2 } { print '$x', div1 }' cat-$x-sum-and-line > cat-$x-mean
	
	# Choose ligand with the lowest mean
	# Concatenate mean files;
		cat cat-*-mean > cat-means
		sed "s/[.]/,/g" cat-means > cat-means2
		awk '{print  $1}' cat-means2 > cat-means5
		awk '{print  $2}' cat-means2 > cat-means6
		sed 's/$/./' cat-means5 > cat-means7
		paste cat-means7 cat-means6 > cat-means8
	
	# Order rows according to lowest RMSD;
		sort -k 2,2 -s cat-means8 > cat-sorted
	
	# Copy the 1st row to other file;
		sed -e '2,20d' cat-sorted > cat-BEST

	# Copy 1st column only;
		awk '{print $1}' cat-BEST > cat-BEST2
	done

	else
		echo "Note: vina_out_$x-ligand_1.pdb - File not found"
	fi
done

#Create folder that will host .pdb of best ligand
mkdir Selected-ligand

#Store the number of the best ligand on the variable "file"
sed -i 's/\.$//g' cat-BEST2
file=$(sed -n "1p" cat-BEST2)
echo -e "cp vina_out_$file-ligand_1.pdb Selected-ligand" > cat-BEST$file

#Execute cat-BEST   
chmod +x cat-BEST$file
./cat-BEST$file
#
#Remove files with 0 bytes
#find . -size 0k | xargs rm
##########################################################Organize files
#Exit folder and copy the best ligand; rename file.
cd ../
cp Selected-structures/Selected-ligand/vina_* selected_ligand.pdb
#Move BE files and remove redundant files
mv BE_* Selected-structures/
rm vina_*-ligand_*.pdbqt
mkdir Top20 Vina_OUTs LOGs TheOne
mv vina_out*.pdbqt Vina_OUTs
mv vina_*-ligand_*.pdb Top20
mv log_* LOGs
cp Selected-structures/Selected-ligand/vina_* TheOne
rm -R Selected-structures/
##########################################################Proceed with D1-EM-D2
#Check parameter $2 ($2 is the MHC allele name) 
if test -z "$2"
	then      
		echo -e "\nNote: Observe the exact spelling (UPERCASE) of desired allele!"
		echo -e "\n      Options: A0201, B2705, H2KB e H2DB."
		echo -e "\nWhich allele do you want to select?"; read allele
	else
	allele=$2
fi
#Define tasks for D1 or D2:
if [ $(echo "$option" |tr [:upper:] [:lower:]) = "d2" ]
    then 
		#User running D2 -> Conclude D2 analysis.		
		#Generate final complex
		cp MHC_4D2.pdb selected_MHC.pdb
		pymol -c $DOCKTOPE_PATH/pMHC_Built.py
		mv sele.pdb FINAL-$allele-pMHC.pdb
		model="FINAL-$allele-pMHC.pdb"
		rm selected_MHC.pdb selected_ligand.pdb
    else
        #User running D1 -> Proceed with the construction of BEST_pMHC_D1.pdb
        cp donor_*.pdb selected_MHC.pdb
        pymol -c $DOCKTOPE_PATH/pMHC_Built.py
        mv sele.pdb BEST_pMHC_D1.pdb
		model="BEST_pMHC_D1.pdb"
        rm selected_MHC.pdb selected_ligand.pdb
fi
#########################Proceed with RMSCheck...
#Test location of peptide ==> Treshould defined as 1.98 angstrons! (variable n2 on awk line)
refrms=$(echo $DOCKTOPE_PATH/MHC1_$allele*.pdb | grep -o '[^/]*$')
cp $DOCKTOPE_PATH/MHC1_$allele*.pdb MHC1.pdb
cp $model MHC2.pdb
pymol -c $DOCKTOPE_PATH/RMSCheck.py | awk '/: RMS/{print $4}' > RMSCheck.txt
#RMSCheck.txt must have 2 RMS values, the one corresponding to the ligand is in the 2nd row.
lines=$(cat RMSCheck.txt | wc -l)
if [ "$lines" -eq 2 ]
	then
		rms=$(sed -n "2p" RMSCheck.txt)
	else
		echo -e "########################### RMSCheck LOG ###########################" > RMSCheck_ERROR.log 
		echo -e "\nWARNING: RMSCheck was not able to calculate epitope RMSD!!" >> RMSCheck_ERROR.log
		echo -e "\nWARNING: Please check your files!!" >> RMSCheck_ERROR.log
		echo -e "\n########################### RMSCheck LOG ###########################\n" >> RMSCheck_ERROR.log 
		more RMSCheck_ERROR.log
		mv $model \#"$model"#
		rm RMSCheck.txt
		exit
fi
rm MHC1.pdb MHC2.pdb RMSCheck.txt
#RMSD computation by awk
echo | awk -v n1=$rms -v n2=1.98  '{if (n1>n2) print ("WARNING: RMS for epitope backbone is too high!!") ;}'>RMSCheck_ERROR.log
find . -size 0k | xargs rm
if [ -e RMSCheck_ERROR.log ]
	then
		sed -i '/WARNING/i ########################### RMSCheck LOG ###########################\n' RMSCheck_ERROR.log
		echo -e "\nWARNING: RMSD = $rms Angstrons!!!! (backbone)" >> RMSCheck_ERROR.log
		echo -e "\nWARNING: Epitope seems to be out of place!!" >> RMSCheck_ERROR.log
		echo -e "\nReference file used: $refrms" >> RMSCheck_ERROR.log
		echo -e "\n########################### RMSCheck LOG ###########################\n" >> RMSCheck_ERROR.log 
		mv $model \#"$model"#
		more RMSCheck_ERROR.log
	else
		echo -e "########################### RMSCheck LOG ###########################" > RMSCheck.log 
		echo -e "\nNote: RMSCheck verifies the epitope position inside the MHC cleft." >> RMSCheck.log 
		echo -e "RMSD values (for backbone) higher than 1.98 Angstrons are indicative\nof a wrong docking result." >> RMSCheck.log
		echo -e "\nCalculated RMSD for this epitope at \"$option\": $rms Angstrons." >> RMSCheck.log
		echo -e "\nReference file used: $refrms" >> RMSCheck.log
		echo -e "\n########################### RMSCheck LOG ###########################" >> RMSCheck.log 
		echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
		echo -e "\n        Analysis of \"$option\" results concluded with success."
		echo -e "\n        Saving final structure ($model)..."
		echo -e "\n        Thanks for using our methods."
		echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
fi
#
