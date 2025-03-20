#! /bin/bash
#Script to run Autodock Vina multiple times using the same input files (modified to run batches of parallel jobs).
#v5.0
#Parameters requested:
# $1: Configuration file (CONFIG);
# $2: Number of processors, or nodes (NP); 
# $3: Number of repeats; (optional) 
#
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< VS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo -e "\n  Script to run multiple Autodock Vina jobs, in parallel batches  "
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
# In this version, runtime cannot be computed for each vina job, bacause of the parallelization. So it will be computed for p_vina.sh 
starttime=$(date "+%H:%M:%S") 
start=$(date +%s)
echo -e "Starting time: $starttime."
#
# Parallelization parameters:
# In this version, the number of vina_cpus is fixed (defined bellow), 
# and the number of parallel jobs per batch ($N) is defined by dividing the number of available nodes ($np) 
# by the number of $vina_cpus. 
# Since $np cannot be smaller than vina_cpus, a special case (withouth parallelization) is defined for $np<4 
if [ "$np" -lt 4 ]
    then 
        vina_cpus=$np
        N=1                          #no parallelization
    else
        vina_cpus=4
        N=$(($np / $vina_cpus))      #number of parallel jobs per batch
fi
#
for ((x=1; x <= $jobs ; x++)); do
        ((i=i%N)); ((i++==0)) && wait # parallelization in batches of $N jobs. 		
   	    vina --cpu $vina_cpus --out vina_out_$x.pdbqt --log log_$x --config $conf --exhaustiveness 8 &
done
#
#Test to make sure all vina jobs were finished before proceeding with remaining tasks
outs=$(ls -1 vina_out_*.pdbqt | wc -l)
while [ $outs -lt $jobs ]; do
        sleep 5 
        outs=$(ls -1 vina_out_*.pdbqt | wc -l)
done
# Compute runtime for the entire loop of vina jobs
end=$(date +%s)
secs=$((end-start))
runtime=$(printf '%dh:%dm:%ds\n' $(($secs/3600)) $(($secs%3600/60)) $(($secs%60)))
echo -e "Runtime: $runtime."
echo -e "Vina executed $jobs replicated docking jobs, with the same input files." > runtime.log
echo -e "Since $np nodes were available, and $vina_cpus cpus were requested for each vina instance," >> runtime.log
echo -e "the dockings were divided into batches of $N parallel vina instances." >> runtime.log
echo -e "Total runtime for the $jobs docking jobs: $runtime." >> runtime.log
#
#Analyze logs and generate file affinities.txt
echo "Binding energies of the top scoring conformation from each docking round:" > affinities.txt
for log in `ls -1v log_*`; do
	num=${log#*_};
	BE=$(grep -A 1 "+" $log | sed -n 2p | awk '{print $2}')
    echo -e "Dock $num: $BE\tkcal/mol" >> affinities.txt
done
