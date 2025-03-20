#! /bin/bash
#Script to run Autodock Vina multiple times using the same input files.
#v4.0
#Parameters requested:
# $1: Configuration file (CONFIG);
# $2: Number of nodes (NP);
# $3: Number of repeats;
#
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< VS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo -e "\n       Script to run Autodock Vina multiple times "
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< VS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
#Testing parameters:
if test -z "$1"
    then
		echo -e "\nWARNING: User must indicate Vina configuration file (CONFIG)."
		echo -e "\nMode of use: bash vina_loop.sh CONFIG NP"
		echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< VS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
		exit
	else
		conf=$1;
		if test -z "$2"
    		then
				echo -e "\nWARNING: User must indicate the number of nodes available (NP)."
				echo -e "\nMode of use: bash vina_vs_loop.sh CONFIG NP"
				echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< VS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
				exit
			else
				np=$2;
				echo -e "\nStart docking using $2 nodes..."
				if test -z "$3"
    				then
						echo -e "\nNOTE: User didn't specify the number of runs (replicates)."
						echo -e "\nUsing default value (Vina will run 20 times)."
						echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< VS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
						jobs=20
					else
						jobs=$3
						echo -e "\nVina will run $jobs times with the same input files.\n"
				fi
		fi
fi
#
for ((x=1; x <= $jobs ; x++)); do
	    starttime=$(date "+%H:%M:%S")
        start=$(date +%s)
	    echo -e "Starting time: $starttime."		
	    vina --cpu $np --out vina_out_$x.pdbqt --log log_$x --config $conf --exhaustiveness 8
        end=$(date +%s)
        secs=$((end-start))
        runtime=$(printf '%dh:%dm:%ds\n' $(($secs/3600)) $(($secs%3600/60)) $(($secs%60)))
	    echo -e "Runtime: $runtime."
	    echo -e "Runtime: $runtime." >> log_$x
		if [ -e vina_out_$x.pdbqt ]
			then
				echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< VS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
				echo -e "Docking nº $x/$jobs successfully completed."
				echo -e "\nResults available at:"
				pwd
				echo -e "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< VS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
			else
				if [ $x = 1 ] 
					then
						echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< VS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
						echo -e "\nWARNING: Error at the first docking round!"
						echo -e "\nWorking directory:"
						pwd
						echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< VS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
						exit
					else
						echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< VS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
						echo -e "\nWARNING: Docking nº $x/$jobs was NOT completed successfully."
						echo -e "\nWorking directory:"
						pwd
						echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< VS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"						
				fi
		fi
	done
#Analyze logs and generate file affinities.txt
echo "Binding energies of the top scoring conformation from each docking round:" > affinities.txt
for log in `ls -1v log_*`; do
	num=${log#*_};
	BE=$(grep -A 1 "+" $log | sed -n 2p | awk '{print $2}')
    echo -e "Dock $num: $BE\tkcal/mol" >> affinities.txt
done
