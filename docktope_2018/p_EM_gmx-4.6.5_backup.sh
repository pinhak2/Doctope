#v3.0
###Script for Energy Minimization of ``target" peptide/complex.
if test -z "$1"
    then
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        echo -e "\n                Warning: Paramater \"file.pdb\" not found!!!"
        echo -e "\n                Use: p_EM.sh file.pdb NP      "
        echo -e "\n                Note: \"NP\"= number of processors/threads (int)"
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
        #Abortar script#
        exit
    else
		if test -z "$2"
			then
				echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
                echo -e "\n                Warning: Paramater \"np\" not found!!!"
                echo -e "\n                Use: p_EM.sh file.pdb NP      "
                echo -e "\n                Note: \"NP\"= number of processors/threads (int)"
				echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
				#Abortar script#
				exit
			else
				echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
				echo -e "\n        Input parameters sucessfully identified."
				echo -e "\n        Starting energy minimization of $1..."
				echo -e "\n        Number of processors available = $2."
				echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
		fi
fi
#
#Proceed with Gromacs 5.x
echo -e "13\r\n1\r" | gmx pdb2gmx -f $1 -ignh -p target_TOPOLOGY -o target
editconf -f target -c -d 1.5 -bt cubic -o target_box
genbox -cp target_box -cs -p target_TOPOLOGY -o target_box_sol
grompp  -f $DOCKTOPE_PATH/em10000ps -c target_box_sol -p target_TOPOLOGY -o targetmdrun_EM1 -r target_box_sol
mdrun -nt $2 -v -s targetmdrun_EM1 -o target_traj_EM1 -c Final_target_BOX-EM -g target_log_EM1 -e energia_EM1.edr
echo -e "1\r" | trjconv -s targetmdrun_EM1.tpr -f Final_target_BOX-EM.gro -o EM-OUT_NW.pdb
if test -z "$3"
    then
        echo -e "Completed Energy Minimization of $1 (output without waters: EM-OUT_NW.pdb)"
    else
        editconf -f EM-OUT_NW.pdb -o peptide.pdb -label $3
        echo -e "Completed Energy Minimization of $1 (output without waters: peptide.pdb)"
fi
