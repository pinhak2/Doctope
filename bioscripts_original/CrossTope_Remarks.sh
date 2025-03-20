########################################################################################
#      		                   Script CrossTope Remarks v1.5    
########################################################################################
#This script will add REMARKs on a PDB file before publication on CrossTope website.
#
#Initialinzing user interface...
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo -e "\n                      \"CrossTope Remarks v1.5\"                         "
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
#
if test -z "$1"
	then
		#Confirming actions...
		echo -e "\n NOTE: This script will list ALL PDB FILES in this folder. All PDB files"
		echo -e "will be EDITED (for inclusion of CrossTope reference REMARKs)."
		echo -e "\nAre you sure you want to proceed? (y/n)"; read question0         		
		if [ $question0 = 'y' ] || [ $question0 = 'Y' ]
			then
				echo -e "\n>>>\nProceeding with Remarks...\n>>>\n"
				for file in *.pdb ; do 
					sed -i '/^REMARK/d' $file
					sed -i '/^SPDBV*/d' $file
					cat /usr/local/bioscripts/biofiles/CrossTope_Remark.txt $file > EditpMHC
					mv EditpMHC $file
					done
					echo -e "\nAll tasks concluded."
					echo -e "\nListing all edited files:"
					ls -cr -w 75 *.pdb
					echo -e "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
			else
				echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
				echo -e "\n              Thanks for using \"CrossTope Remarks v1.5\"               "
				echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
				exit
		fi
	else
		sed -i '/^REMARK/d' $1
		sed -i '/^SPDBV*/d' $1
		cat /usr/local/bioscripts/biofiles/CrossTope_Remark.txt $file > EditpMHC
		mv EditpMHC $1
 		echo -e "\nAll tasks concluded."
		echo -e "\nCrossTope REMARKs included in \"$1\"."
		echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
fi
#
