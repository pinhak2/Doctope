#################################################################################################################################################
#																		#
#									Script mutagem								#
#																		#
#################################################################################################################################################
#v2.0
## USAGE
# pymol -c mutagem_*.py
#
#
## DETAILS
# This script uses as input: EPITOPE.fasta and the desired *_pattern.pdb
#
## Import from PyMOL
from pymol.cgo import *
from pymol import cmd
from pymol import stored
#
## Load file with target epitope sequence
cmd.load ("EPITOPE.fasta")
## Update epitope chain ID
cmd.alter (("epitope"),'chain="A"')
## Save epitope in pdb format (3D coordinates)
cmd.do ("save epitope.pdb")
## Reinitialize Pymol
cmd.do ("reinitialize")
#
## Open template pattern and target epitope (to model backbone)
cmd.load ("$DOCKTOPE_PATH/HLA-A0201_9mer_pattern.pdb")
cmd.load ("epitope.pdb")
#
## Initialize lists (to save chain, residue name and residue number)
chainresnresiEPITOPE = []
chainresnresiMHC = []
## Iterate through files and save info into created lists
cmd.iterate ('("epitope")' and 'name CA', 'chainresnresiEPITOPE.append([("epitope"),chain,resn,resi])')
cmd.iterate ('("HLA-A0201_9mer_pattern")' and 'name CA', 'chainresnresiMHC.append([("HLA-A0201_9mer_pattern"),chain,resn,resi])')
## Print lists
print chainresnresiEPITOPE
print chainresnresiMHC
#
## Open "mutagenesis" plugin
cmd.wizard("mutagenesis")
## Loop over items in chainresnresiEPITOPE
for i in range(len(chainresnresiEPITOPE)):
    cmd.do("refresh_wizard")
    # Choose first (i = 1 first loop) residue ([2] refers to the residue NAME on chainresnresiEPITOPE)
    cmd.get_wizard().set_mode("%s"%chainresnresiEPITOPE[i][2])
    # Create variable 'selection' to save the NUMBER of the first residue of the epitope pattern
    selection="/HLA-A0201_9mer_pattern//C/%s"%(chainresnresiMHC[i][3])
    # Make change
    cmd.get_wizard().do_select(selection)
    # Choose first rotamer (likely to be best)
    cmd.frame(1)
    # Apply changes
    cmd.get_wizard().apply()
#
## Close "wizard"
cmd.set_wizard("done")
## Remove template epitope (pattern)
cmd.delete ("epitope")
## Save new structure with enforced backbone conformation
cmd.do ("save Epitope_pattern.pdb")












