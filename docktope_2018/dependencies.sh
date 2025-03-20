#This script runs the full installation and set up of dependencies.
#This script must be executed inside the docktope-backend folder (or your clone of that folder - can be with a different name)
#
#For instance:
#git clone -b master git@gitlab.com:iedb-tools/Docktope/docktope-backend.git
#cd docktope-backend
#bash dependencies.sh
#
#Paths to the docktope folder will be exported (only for this bash session).
#For permanent set up, lines 46 to 50 must be copied to the ~.bashrc file, replacing $local with the correct path.

local=$(pwd)

## Dependencies

### GROMACS 2018, PyMOL (includes Python2 if needed), PIP and numpy.oldnumeric
sudo apt-get install software-properties-common
sudo apt-add-repository universe
sudo apt-get update
sudo apt-get install gromacs pymol python-pip bc
pip install numpy==1.8.2
echo -e "\n"

### MGLTools
wget mgltools.scripps.edu/downloads/tars/releases/nightly/1.5.7/REL/mgltools_x86_64Linux2_1.5.7rc1.tar.gz
tar -xvzf mgltools_x86_64Linux2_1.5.7rc1.tar.gz
tar -xvzf mgltools_x86_64Linux2_1.5.7rc1/MGLToolsPckgs.tar.gz
mv MGLToolsPckgs/ $local
rm -rf mgltools_x86_64Linux2_1.5.7rc1/
echo -e "\n"

### AutoDock Vina
wget vina.scripps.edu/download/autodock_vina_1_1_2_linux_x86.tgz
tar -xvzf autodock_vina_1_1_2_linux_x86.tgz
mv autodock_vina_1_1_2_linux_x86/bin/vina* $local
rm -rf autodock_vina_1_1_2_linux_x86/
echo -e "\n"

## Setting up the environment
export DOCKTOPE_PATH=$local
export PATH="$PATH:$local"
export PATH="$PATH:$local/MGLToolsPckgs/AutoDockTools/Utilities24"
export PYTHONPATH="${PYTHONPATH}:$local/MGLToolsPckgs/"
echo -e "Warning: Environmental variables and paths to scripts were exported once (for this script)."
echo -e "To make these changes permanent, copy and paste the following lines to your ~.bashrc file.\n"
echo -e "export DOCKTOPE_PATH=$local"
echo -e "export PATH=\"\$PATH:$local\""
echo -e "export PATH=\"\$PATH:$local/MGLToolsPckgs/AutoDockTools/Utilities24\""
echo -e "export PYTHONPATH=\"\${PYTHONPATH}:$local/MGLToolsPckgs/\"\n"

## Testing installation
echo "Read Warning message above before proceeding."
echo "This concludes all the installation steps."
echo "Do you wish to proceed with a testing run of DockTope? (y/n)"; read test
if [ "$test" == "y" ] || [ "$test" == "Y" ]; then
    echo -e "Creating a \"~/test_docktope\" folder"
    cd ~
	mkdir test_docktope
	cd test_docktope
	echo ">Test peptide sequence" > test.fasta
	echo "AVAAAAAAV" >> test.fasta
	#
	echo "How many threads are available for DockTope? (int)"; read np
	if [ "$np" -ge 1 ] && [ "$np" -le 32 ]; then
		p_D1EMD2.sh A0201 $np
		else
		p_D1EMD2.sh A0201 1 #parameter is not a number, os is too big; use 1 thread for testing.
	fi
    #Check results
    if [ -e *-D2/*_pMHC.pdb ]
        then
            echo -e "\nCongrats!!! Everything seems to have worked as planned!!"
            echo -e "You can run additional tests by calling p_D1EMD2.sh or queue_docktope.sh\n"
        else
            echo -e "\nWARNING: The final complex was not found in the D2 folder."
            echo -e "It seems something went wrong."
            echo -e "\nRunning tests to help diagnosing the problem...\n"
            echo -e "###>COMMAND: echo \$DOCKTOPE_PATH  #should print the path for your docktope-backend folder\n"
            echo $DOCKTOPE_PATH
            echo -e "\nPress ENTER to continue...\n";read
            echo -e "\n###>COMMAND: queue_docktope.sh  #should print how to use queue_docktope.sh\n"
            queue_docktope.sh | tail --lines 14
            echo -e "\nPress ENTER to continue...\n";read
            echo -e "\n###>COMMAND: gmx editconf       #should print how to use gmx editconf\n"
            gmx editconf -h | head
            echo -e "\nPress ENTER to continue...\n";read
            echo -e "\n###>COMMAND: prepare_ligand4.py #should print how to use prepare_ligands4.py\n"
            prepare_ligand4.py
            echo -e "\nPress ENTER to continue...\n";read
            echo -e "\n###>COMMAND: pymol -c $DOCKTOPE_PATH/pMHC_Built.py"  
            echo -e "#should write \"sele.pdb\" \n"
            cp $DOCKTOPE_PATH/donor_HLA-A0201.pdb selected_MHC.pdb
            cp $DOCKTOPE_PATH/HLA-A0201_9mer_pattern.pdb selected_ligand.pdb
            pymol -c $DOCKTOPE_PATH/pMHC_Built.py 
            ls -1v sele.pdb
    fi
fi	
