###########################################################################################
#														                                                                        
# 				     	Script RMSCheck v2.0
#
###########################################################################################
#
## USAGE
# pymol -c RMSCheck.py
# 
#
## DETAILS
# This script will run with two input files: MHC1 (Reference) and MHC2 (model). After alignment of MHC1 and MHC2, the goal is extract RMSD value bewtween EP1 and EP2
#
#
## REQUIREMENTS
# - MHC1.pdb and MHC2.pdb
# - The epitope should have a chain "C", otherwise the script wont work
#
#
## RUNNING
## Importing PyMol files
from pymol.cgo import *
from pymol import cmd
from pymol import stored
# Loading MHC1
cmd.load ("MHC1.pdb")
#Change chain C to chain M (MHC1 epitope)
cmd.alter (('chain C'),'chain="M"')
# Loading MHC2
cmd.load ("MHC2.pdb")
#Change chain C to chain R (MHC2 epitope)
cmd.alter (('chain C'),'chain="R"')
## Align MHC1 and MHC2
cmd.do ("align MHC1, MHC2")
## MHC1 epitope selection (EP1)
cmd.do ("sele EP1, chain M")
## MHC2 epitope selection (EP2)
cmd.do ("sele EP2, chain R")
## Remove chain names (this is required so 'rms_cur' will work properly)
cmd.alter (("all"),'chain=""')
## Residues numbers aligned (this is required so 'rms_cur' will work properly)
cmd.alter (("all"),'segi=""')
## Run rms_current.py
cmd.do ("run /usr/local/bioscripts/rms_current.py")
## RMSD Calculation between EP1 and EP2
cmd.do ("rms_current EP1, n. CA, EP2, n. CA")
##
## This script could be run with the following line: "pymol -c RMSCheck.py | awk '/: RMS/{print $4}' > RMSCheck.txt"
## In this way, the "RMSCheck_value.txt" will contain only the RMSD value calculated between EP1 and EP2. This will go through each line and every time it finds one that contains ": RMS", 
## it will save the 4th field as 'val'. The END{} block is executed after all lines have been processed so at that point, val will be the last value found, the one you want 
## copy the value
##
## COMMENTS FROM "Stack Exchange" page
#
#I am not entirely clear on how you get the output you show. I am assuming it is produced by the script you mentioned and that you can simply pipe it through something else to parse it. If so, these solutions should work:
#
##your_script | tail -n 2 | awk '/RMS/{print $4}'
#tail -n 2 prints the last two lines and the awk will print the 4th field of any line containing RMS, that is the value you are after.
#
#Alternatively:
#
#your_script | tail -n 2 | grep -oP '[.\d]+' | head -1
#That will grep for sets of numbers or . and uses head to print the first one.
#
#Since you know you want the last line that contains RMS, you could also simply do:
#
#your_script | awk '/: RMS/{val=$4}END{print val}' 
#This will go through each line and every time it finds one that contains : RMS, it will save the 4th field as val. The END{} block is executed after all lines have been processed so at that point, val will be the last value found, the one you want.

