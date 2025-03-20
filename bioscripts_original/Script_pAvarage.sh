########################################################################################
#      		                   Script p_avarage v2.0    
########################################################################################
##Script to calculate RMSD Mean and SD of a group of molecular dynamics replicates.
#Alias at Bioscripst: "p_avarage"
#
###README;
#
# NOTE: This pipeline calls Justin's script "avarage_multi.pl" (executed with Perl), 
# which shall be at "/usr/local/bioscripts/";
#
# HOW TO USE: p_avarage TAG 
# (where "TAG" is a word present in the name off all desired input files)
#
# Alternatively you can run directly Justin's script:
# HOW TO: perl /usr/local/bioscripts/avarage_multi.pl file1.xvg file2.xvg file3.xvg ... file'n'.xvg
#
#Initializing user interface...
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo -e "\n                        \"p_avarage v2.0\"                         "
echo -e "\n     Pipeline to calculate RMSD Mean and SD from MD replicates       "
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
if test -z "$1"
    then
        #No TAG provided...
	    echo -e "\nNOTE: This script requires one \"TAG\" parameter wihch will be used to"
	    echo -e "list all available input files containing the specified \"TAG\"."
	    echo -e "\nPlease inform a valid \"TAG\":"; read tag         		
	    echo -e "\nInput files for p_avarage will be:"
        ls -1 *$tag*.xvg
	    echo -e "\nDo you confirm these input files and wanna proceed? (y/n)"; read lsfiles         		
	        if [ $lsfiles = 'y' ] || [ $lsfiles = 'Y' ]
	        	then
	        		echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
				    echo -e "\n Proceeeding with selected files..."
				    echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
			    else
				    echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
				    echo -e "\n Wrong answer or missing files."
				    echo -e "\n Aborting script."
                   	echo -e "\n HOW TO USE: p_avarage TAG"
				    echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
	        		exit
		    fi
    else
        #Identified TAG...
    	tag=$1
		if test -z "$2"
    		then		
				echo -e "\nListing input files:"
				ls -1 *$tag*.xvg
				echo -e "\nDo you confirm these input files and wanna proceed? (y/n)"; read lsfiles         		
					if [ $lsfiles = 'y' ] || [ $lsfiles = 'Y' ]
						then
							echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
							echo -e "\n Proceeeding with selected files..."
							echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
						else
							echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
							echo -e "\n Wrong answer or missing files."
							echo -e "\n Aborting script."
				           	echo -e "\n HOW TO USE: p_avarage TAG"
							echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
							exit
					fi
			else
				#$2 is a hidden optional paramenter to jump iterative verification of input files.
				echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
				echo -e "\n Proceeeding with selected files..."
				echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
		fi
fi
#Initializing script "per se"
#Loop for input list.
i=1
mkdir $tag
for input in *$tag*.xvg ; do
	echo -e "../$input" > $tag/file_$i
    i=$((i + 1)) 
done
#Prepare and run...
echo -e "perl /usr/local/bioscripts/avarage_multi.pl" > $tag/go.sh
echo -e "WARNING: Do not remove this folder if you are running p_avarage!\nWhile the terminal is \"Running avarages\", calculations are been performed inside this folder." > $tag/DO-NOT-REMOVE-THIS-FOLDER
#
cd $tag/
	paste go.sh file_* > run-$tag.sh
	echo -e "\nCalculations will be started. Do not close this terminal."
	echo -e "WARNING: This might take several minutes."
	echo -e "\nRunning avarages..."
	chmod +x run-$tag.sh
	./run-$tag.sh
	#Rename output
	mv output.dat ../"$tag"_RMSD-Mean.dat
cd ..
rm -rf $tag
#
echo -e "\n All tasks concluded."
echo -e " For results, check the file \""$tag"_RMSD-Mean.dat\""
echo -e " (To visualize Mean and SD with Xmgrace, go to \"Data>Import>ASCII...\")" 
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo -e "\n                  Thanks for using \"p_avarage v2.0\"                 "
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
