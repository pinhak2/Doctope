#Script to build the pMHC complex:
#v1.0
from pymol.cgo import *
from pymol import cmd

cmd.load ("selected_MHC.pdb")
cmd.load ("selected_ligand.pdb")
cmd.do ("sele all")
cmd.do ("save sele.pdb")

