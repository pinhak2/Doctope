#Script para separar MHC e epitopo (em HLA0201)#
#v1.0
from pymol.cgo import *
from pymol import cmd

cmd.load ("SAIDA_NW.pdb")
cmd.do ("sele chain A+B")
cmd.do ("remove sele")
cmd.do ("save ep_4D2.pdb")
cmd.do ("reinitialize")

cmd.load ("SAIDA_NW.pdb")
cmd.do ("sele chain C")
cmd.do ("remove sele")
cmd.do ("save MHC_4D2.pdb")
