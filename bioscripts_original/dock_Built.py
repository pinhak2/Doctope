#Script para montar um complexo Receptor+ligante:
#v1.0
from pymol.cgo import *
from pymol import cmd

cmd.load ("Receptor.pdb")
cmd.load ("ligante_escolhido.pdb")
cmd.do ("sele all")
cmd.do ("save sele.pdb")

