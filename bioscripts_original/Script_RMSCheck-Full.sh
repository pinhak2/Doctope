########################################################################################
#      		                   Script RMSCheck-Full v1.5.1  
########################################################################################
#Note: This script will use the PyMol script RMSCheck_EpFull.py (/usr/local/bioscriopts).
#Parameters:
#$1 = pMHC1
#$2 = pMHC2
#
#Initialinzing user interface...
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo -e "\n                    \"Script RMSCheck-Full v1.5 \"                         "
echo -e "\n     Performs a full RMSD assessment of a MHC-restricted epitope"
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
####
if test -z "$1"
	then
		echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
		echo -e "\n           WARNING: User fail to provide input files!!! "
		echo -e "\n           Mode of use: p_RMSFull pMHC1.pdb pMHC2.pdb"
		echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"	
		exit	
	else
		pMHC1=$1
		if test -z "$2"
			then
				echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
				echo -e "\n           WARNING: User fail to provide input files!!! "
				echo -e "\n           Mode of use: p_RMSFull pMHC1.pdb pMHC2.pdb"
				echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"	
				exit	
			else
				pMHC2=$2
				echo -e "\nProceeding with complexes \"$pMHC1\" and \"$pMHC2\"..."
		fi

fi
#
if [ -e MHC1.pdb ] || [ -e MHC2.pdb ]
	then
		mv MHC1.pdb \#MHC1.pdb#
		mv MHC2.pdb \#MHC2.pdb#
fi
#
cp $pMHC1 MHC1.pdb
cp $pMHC2 MHC2.pdb
pymol -c /usr/local/bioscripts/RMSCheck_EpFull.py | awk '/: RMS/{print $4}' > RMSD_values.txt
#RMSCheck.txt deve ter 5 valores de RMS:
lines=$(cat RMSD_values.txt | wc -l)
if [ "$lines" -eq 5 ]
	then
		rms_pMHC=$(sed -n "1p" RMSD_values.txt)
		rms_fit=$(sed -n "2p" RMSD_values.txt)
		rms_full=$(sed -n "3p" RMSD_values.txt)
		rms_current=$(sed -n "4p" RMSD_values.txt)
		rms_current_CA=$(sed -n "5p" RMSD_values.txt)
	else
		echo -e "WARNING: RMSCheck-Full was not able to calculate epitope RMSDs!!" > RMSCheck-Full_ERROR.log
		echo -e "\nWARNING: Please check your files!!" >> RMSCheck-Full_ERROR.log
		echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
		more RMSCheck-Full_ERROR.log
		echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"							
		exit
fi
rm MHC1.pdb MHC2.pdb RMSD_values.txt
#
#echo -e "$rms_pMHC, $rms_fit, $rms_full, $rms_current, $rms_current_CA"
echo -e "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" > RMSD_Report.txt
echo -e "\n                   \"Script RMSCheck-Full v1.5\"    \n"               >> RMSD_Report.txt
echo -e " Input structures: \"$pMHC1\" and \"$pMHC2\" \n" >> RMSD_Report.txt
echo -e " Calculated Results:" >> RMSD_Report.txt
echo -e " RMSD (pMHC) = $rms_pMHC Angstrons (all pMHC atoms, after fit by MHC)." >> RMSD_Report.txt
echo -e " RMSD (full) = $rms_full Angstrons (all epitope atoms, after fit by MHC)." >> RMSD_Report.txt
echo -e " RMSD (fit)  = $rms_fit Angstrons (all epitope atoms, after fit by epitope)." >> RMSD_Report.txt
echo -e " RMSD (main) = $rms_current Angstrons (epitope main chain, with rms_current.py)." >> RMSD_Report.txt
echo -e " RMSD (epCA) = $rms_current_CA Angstrons (epitope CA atoms, with rms_current.py)." >> RMSD_Report.txt
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" >> RMSD_Report.txt
#
echo -e "\n"
more +7 RMSD_Report.txt
#

