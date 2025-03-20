########################################################################################
#  		                       Script p_prep4D1   
########################################################################################
###Script for automated preparation of files for D1
#
#$1=allele 
#$2=x (optional parameter, to automate the generation of the peptide pdbqt file)
###Script for automated preparation of files for D1
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo -e "\n    Preparation script for Docking 1 (D1-EM-D2)\n"
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
#Testing allele parameter
if test -z "$1"
	then
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
		echo -e "\n\tWarning: Parameters not found!!!"
		echo -e "\nUse: p_prep4D1 MHC-allele NP"
		echo -e "Note 1: \"MHC-allele\" must be one of A0201, B2705, H2DB, or H2KB."
		echo -e "Note 2: \"NP\" is the number of processors (int)."
		echo -e "Note 3: This script will search for a \"*.fasta\" file (peptide)."
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
		echo -e "Qual alelo de MHC você deseja utilizar?"; read allele
    else
		#Transfer $1 and $2 values#
		allele=$1
        np=$2
fi
#Testing epitope parameter:
echo -e "\n"
cp *.fasta EPITOPE.fasta
if [ -e "EPITOPE.fasta" ]
    then
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        echo -e "\n\tReading peptide sequence..."
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    else
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
		echo -e "\n\tWarning: Epitope not found!!!"
		echo -e "\nNote: Provide a text file with an epitope sequence in the FASTA format."
		echo -e "Which sequence file do you whish to use? (exact file name!)"; read epitope
		#Rename epitope file#
		cp $epitope EPITOPE.fasta
fi
#Proceed with script
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo -e "\n         Parameters sucessfully identified."
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"   
if [ $allele == "A0201" ]
	then
        echo "Running: pymol -c mutagem_A0201_9mer_x1.py"
		pymol -c $DOCKTOPE_PATH/mutagem_A0201_9mer_x1.py
fi
#
if [ $allele == "B2705" ]
	then
        echo "Running: pymol -c mutagem_B2705_9mer_x1.py"
		pymol -c $DOCKTOPE_PATH/mutagem_B2705_9mer_x1.py
fi
#
if [ $allele == "H2KB" ]
	then
        echo "Running: pymol -c mutagem_H2Kb_8mer_x1.py"
		pymol -c $DOCKTOPE_PATH/mutagem_H2Kb_8mer_x1.py
fi
#
if [ $allele == "H2DB9" ] || [ $allele == "H2DB10" ]
    then 
        if [ $allele == "H2DB9" ]
           then		
                echo "Running: pymol -c mutagem_H2Db_9mer_x1.py"
                pymol -c $DOCKTOPE_PATH/mutagem_H2Db_9mer_x1.py
           else
                echo "Running: pymol -c mutagem_H2Db_10mer_x1.py"
			    pymol -c $DOCKTOPE_PATH/mutagem_H2Db_10mer_x1.py                
        fi
fi
#
####################################
#
#Energy minimization#
p_EM.sh Epitope_pattern.pdb $np C
#
#Organizing files
mkdir EM
mv *.edr *.itp *.log *.pdb *.gro *.tpr *.mdp *.top *.trr EM/
rm \#* 
#	
mkdir D1
#	
cd D1/
mv ../EM/peptide.pdb . 
#cp $DOCKTOPE_PATH/MVina_CESUP.sh .
#sed -i 's/#$ -N/#$ -N D1_'$1'/' MVina_CESUP.sh
#	
#Copy files of selected MHC
if [ $allele == "A0201" ]
	then
		cp $DOCKTOPE_PATH/donor_HLA-A0201.pdb .
		cp $DOCKTOPE_PATH/donor_HLA-A0201.pdbqt .
		cp $DOCKTOPE_PATH/Vina_config_HLA-A0201 .
		mv Vina_config_HLA-A0201 Vina_config
fi
#
if [ $allele == "B2705" ]
	then
		cp $DOCKTOPE_PATH/donor_HLA-B2705.pdb .
		cp $DOCKTOPE_PATH/donor_HLA-B2705.pdbqt .
		cp $DOCKTOPE_PATH/Vina_config_HLA-B2705 .
		mv Vina_config_HLA-B2705 Vina_config
fi
#
if [ $allele == "H2KB" ]
	then
	cp $DOCKTOPE_PATH/donor_H2Kb.pdb .
	cp $DOCKTOPE_PATH/donor_H2Kb.pdbqt .
	cp $DOCKTOPE_PATH/Vina_config_H2Kb .
	mv Vina_config_H2Kb Vina_config
fi
#
if [ $allele == "H2DB9" ] || [ $allele == "H2DB10" ]
	then
	cp $DOCKTOPE_PATH/donor_H2Db.pdb .
	cp $DOCKTOPE_PATH/donor_H2Db.pdbqt .
	cp $DOCKTOPE_PATH/Vina_config_H2Db .
	mv Vina_config_H2Db Vina_config
fi
#
#Proceeding with automated generation of pdbqt file
prepare_ligand4.py -l peptide.pdb -B "None"
