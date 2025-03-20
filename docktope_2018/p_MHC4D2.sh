########################################################################################
#      Pipeline to run pMHC energy minimization and to prepare the files for D2
########################################################################################
#
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo -e "\n    Script to prepare the files for Docking 2 (D1-EM-D2)\n"
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
#Testing parameters:
if test -z "$1"
	then
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
		echo -e "\n     Warning: Missing parameters!!!"
		echo -e "\n     Use: p_MHC4D2 MHC-allele(required) NP(required) name(optional)"
		echo -e "\n     Note 1: \"MHC-allele\" must be one of A0201, B2705, H2DB, or H2KB."
		echo -e "\n     Note 2: \"NP\" is the number of processors (int)."
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n\n"
		#Abort script#
        exit
	else
        if [ $1 == "A0201" ] || [ $1 == "B2705" ] || [ $1 == "H2KB" ] || [ $1 == "H2DB9" ] || [ $1 == "H2DB10" ]
			then
				#Proceed with script#
                np=$2
                allele=$1
                echo -e "\n<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>"
    			echo -e "\n             Parameters obtained."
                echo -e "\n<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>\n\n"
			else
                echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
				echo -e "\n     Warning: the MHC allele was not indentified!!!"
				echo -e "\n     Use: p_MHC4D2 MHC-allele(required) name(optional)"
		        echo -e "\n     Note 1: \"MHC-allele\" must be one of A0201, B2705, H2DB, or H2KB."
        		echo -e "\n     Note 2: \"NP\" is the number of processors (int)."
                echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n\n"
		fi
fi
#Energy Minimization#
p_EM.sh BEST_pMHC_D1.pdb $np
#Testing name parameter
if test -z "$3"
	then
		name=$1
		echo -e "\n<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>"
		echo -e "\n  Note 1: No name was provided for Dock2."
		echo -e "\n  Note 2: Folder renamed to $name-D2."		
		echo -e "\n<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>\n"
	else
    #Proceed with script#
		name=$3
        echo -e "\n<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>"
        echo -e "\n Note 1: User provided a name for Dock2."
        echo -e "\n Note 2: Folder renamed to $name-D2."       
        echo -e "\n<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>\n"
fi
#Organizing folders#
mkdir $name-D2
mkdir pMHC_EM
#Spliting chains#
pymol -c $DOCKTOPE_PATH/pMHC_split.py
#Organizing files#
mv ep_4D2.pdb MHC_4D2.pdb $name-D2/
mv *.edr *.itp *.log *.pdb *.gro *.tpr *.mdp *.top *.trr pMHC_EM/
rm \#*
#cp $DOCKTOPE_PATH/MVina_CESUP.sh $name-D2/
cd $name-D2/ 
#Copy files of selected MHC allele#
if [ $1 == "A0201" ]; then
    cp $DOCKTOPE_PATH/Vina_config_HLA-A0201_D2 .
    mv Vina_config_HLA-A0201_D2 Vina_config
    cp $DOCKTOPE_PATH/donor_HLA-A0201.pdb .
    mv donor_HLA-A0201.pdb donor_MHC.pdb
fi
if [ $1 == "B2705" ]; then
    cp $DOCKTOPE_PATH/Vina_config_HLA-B2705_D2 . 
    mv Vina_config_HLA-B2705_D2 Vina_config
    cp $DOCKTOPE_PATH/donor_HLA-B2705.pdb .
    mv donor_HLA-B2705.pdb donor_MHC.pdb
fi
if [ $1 == "H2KB" ]; then
    cp $DOCKTOPE_PATH/Vina_config_H2Kb_D2 .
    mv Vina_config_H2Kb_D2 Vina_config
    cp $DOCKTOPE_PATH/donor_H2Kb.pdb .
    mv donor_H2Kb.pdb donor_MHC.pdb
fi
if [ $1 == "H2DB9" ] || [ $1 == "H2DB10" ]; then
    cp $DOCKTOPE_PATH/Vina_config_H2Db_D2 .
    mv Vina_config_H2Db_D2 Vina_config
    cp $DOCKTOPE_PATH/donor_H2Db.pdb .
    mv donor_H2Db.pdb donor_MHC.pdb
fi
#Fit selected structure to the MHC-donor (used in D1), in order to reuse the same grid coordinates on Vina_config.
#sed -i 's/#$ -N/#$ -N D2_'$1'/' MVina_CESUP.sh
pymol -c $DOCKTOPE_PATH/MHC_epitope-FIT.py
rm donor_MHC.pdb
prepare_receptor4.py -r MHC_4D2.pdb -A -o
#Proceed to generate ep_4D2.pdbqt
prepare_ligand4.py -l ep_4D2.pdb -B "None"   
#
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
echo -e "\n     Complex minimization of \"$allele\" successfully completed."
echo -e "\n     Saving structures ep_4D2.pdb an MHC_4D2.pdb..."
echo -e "\n     Thanks for using our method.\n"
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n\n" 
