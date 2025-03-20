#Script for structural aligment of MHC_4D2 over donor_MHC:
#v1.0
from pymol.cgo import *
from pymol import cmd
#
cmd.load ("donor_MHC.pdb")
cmd.load ("MHC_4D2.pdb")
#
cmd.do ("fit MHC_4D2, donor_MHC")
#
cmd.do ("remove donor_MHC")
#
cmd.do ("save MHC_4D2.pdb")


