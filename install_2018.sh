#This script runs the full intsallation and set up inside the current folder.
#Paths to the docktope folder will be exported (only for this bash session).
#For permanent set up, lines 40 to 44 must be copied to the ~.bashrc file, replacing $local with the correct path.

local=$(pwd)

##DockTope
sudo apt-get install git-core
#git clone -b master git@github.com:KavrakiLab/DockTope.git
git clone http://@github.com/KavrakiLab/DockTope.git
cp -r DockTope/docktope_2018 docktope
echo -e "\n"

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
mv MGLToolsPckgs/ $local/docktope
rm -rf mgltools_x86_64Linux2_1.5.7rc1/
echo -e "\n"

### AutoDock Vina
wget vina.scripps.edu/download/autodock_vina_1_1_2_linux_x86.tgz
tar -xvzf autodock_vina_1_1_2_linux_x86.tgz
mv autodock_vina_1_1_2_linux_x86/bin/vina* $local/docktope
rm -rf autodock_vina_1_1_2_linux_x86/
echo -e "\n"

## Setting up the environment
export DOCKTOPE_PATH=$local/docktope
export PATH="$PATH:$local/docktope"
export PATH="$PATH:$local/docktope/MGLToolsPckgs/AutoDockTools/Utilities24"
export PYTHONPATH="${PYTHONPATH}:$local/docktope/MGLToolsPckgs/"
echo -e "Warning: Environmental variables and paths to scripts were exported once (for this script)."
echo -e "To make these changes permanent, copy and paste the following lines to your ~.bashrc file.\n"
echo -e "export DOCKTOPE_PATH=$local/docktope"
echo -e "export PATH=\"\$PATH:$local/docktope\""
echo -e "export PATH=\"\$PATH:$local/docktope/MGLToolsPckgs/AutoDockTools/Utilities24\""
echo -e "export PYTHONPATH=\"\${PYTHONPATH}:$local/docktope/MGLToolsPckgs/\"\n"

## Testing installation
echo "Read Warning message above before proceeding."
echo "This concludes all the installation steps."
echo "Do you wish to proceed with a testing run of DockTope? (y/n)"; read test
if [ "$test" == "y" ] || [ "$test" == "Y" ]; then
	mkdir test_docktope
	cd test_docktope
	echo ">Test peptide sequence" > test.fasta
	echo "CVNGVCWTV" >> test.fasta
	#
	echo "How many threads are available for DockTope? (int)"; read np
	if [ "$np" -ge 1 ] && [ "$np" -le 32 ]; then
		p_D1EMD2.sh A0201 $np debug
		else
		p_D1EMD2.sh A0201 1 debug #parameter is not a number, os is too big; use 1 thread for testing.
	fi
fi	
