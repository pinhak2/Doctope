#Script to split MHC and epitope#
#v1.0
#(it assumes chains A+B for MHC and C for epitope)

from pymol.cgo import *
from pymol import cmd

cmd.load ("EM-OUT_NW.pdb")
cmd.do ("sele chain A+B")
cmd.do ("remove sele")
cmd.do ("save ep_4D2.pdb")
cmd.do ("reinitialize")

cmd.load ("EM-OUT_NW.pdb")
cmd.do ("sele chain C")
cmd.do ("remove sele")
cmd.do ("save MHC_4D2.pdb")
