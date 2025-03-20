#######################################################################################
#      		                   Script p_delphi v1.0									  #
#######################################################################################
#Note: This script will call delphi95 through the alias "delphi".
#
#Initialinzing user interface...
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo -e "\n                        \"p_delphi v1.0\"                         "
echo -e "\n     Pipeline to compute electrostatic potential maps for proteins	  "
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
#Confirming actions...
echo -e "\n NOTE 1: This script will list ALL PDB FILES in this folder. All PDB"
echo -e "files will be used as input for Delphi."
echo -e "\n NOTE 2: If you intend to use Chimera to plot the \"phi maps\" over the"
echo -e "protein structure (pMHC), is recomended to abort and use \"prep2grasp\"."
echo -e "\nAre you sure you want to proceed? (y/n)"; read question0         		
if [ $question0 = 'y' ] || [ $question0 = 'Y' ]
	then
		echo -e "\n>>>\nProceeding with Delphi tasks...\n>>>\n"
	else
		echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
		echo -e "\n                  Thanks for using \"p_delphi v1.0\"                 "
		echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
		exit
fi
#Running Delphi
cp /usr/local/bioscripts/biofiles/default.crg .
cp /usr/local/bioscripts/biofiles/default.siz .
cp /usr/local/bioscripts/biofiles/delphi.param .
mkdir Delphi inputfiles
for phifile in *.pdb ; do
	phiname=${phifile%.*};
	mv $phifile TARGET.pdb
	delphi delphi.param
	mv fort.20 $phiname.phi
	mv $phiname.phi Delphi
	mv TARGET.pdb $phifile
	mv $phifile inputfiles
done
#Organizing files
rm default.crg default.siz delphi.param ARCDAT
#
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo -e "\n                  Thanks for using \"p_delphi v1.0\"                 "
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
