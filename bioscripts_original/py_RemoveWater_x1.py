#Script para remover H2O#
from pymol.cgo import *
from pymol import cmd

cmd.load ("SAIDA.pdb")
cmd.do ("remove SOL")
cmd.do ("sele ////NA")
cmd.do ("remove sele")
cmd.do ("sele ////CL")
cmd.do ("remove sele")
cmd.do ("sele all")
cmd.do ("save sele.pdb")
