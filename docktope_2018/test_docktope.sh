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
