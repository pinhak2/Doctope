#Script para montar o complexo pMHC:
#v1.0
from pymol.cgo import *
from pymol import cmd

cmd.load ("MHC_utilizado.pdb")
cmd.load ("ligante_escolhido.pdb")
cmd.do ("sele all")
cmd.do ("save sele.pdb")

