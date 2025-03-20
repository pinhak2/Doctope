#################################################################################################################################################
#																		#
#									Script mutagem								#
#																		#
#################################################################################################################################################
#v1.0
## USAGE
# pymol -c mutagem_x1.py
#
#
## DETAILS
# Este script vai utilizar dois arquivos como entrada: o epitopo, no formato fasta, que se quer modelar e o epitopo do MHC padrao
#
#
## REQUIREMENTS
# - Arquivo com a sequencia fasta do epitopo a ser modelado
# - Arquivo com o epitopo padrao (B2705_9mer_pattern) na pasta ~/Documentos/MATERIAL_REFERENCIA/ARQUIVOS/Dock_Files_2012-07-01/ 
# - Script mutagem_x1.py
#
## Importando arquivos do PyMol
from pymol.cgo import *
from pymol import cmd
from pymol import stored
#
## Carregar arquivo contendo a sequencia do epitopo desejado para modelagem
cmd.load ("EPITOPO.fasta")
## Mudar cadeia do epitopo
cmd.alter (("epitopo"),'chain="A"')
## Salvar epitopo no formato pdb
cmd.do ("save epitopo.pdb")
## Reinicializar o Pymol
cmd.do ("reinitialize")
#
## Abrir o epitopo 9mer padrao de B2705_9mer e o epitopo desejado para modelagem
cmd.load ("/usr/local/bioscripts/biofiles/HLA-B2705_9mer_pattern.pdb")
cmd.load ("epitopo.pdb")
#
## Criar dois grupos vazios - um para o EPITOPO e outro para o epitopo padrao do MHC - que irao conter as informacoes relativas a cadeia, nome do residuo e numero do residuo
chainresnresiEPITOPO = []
chainresnresiMHC = []
## Passar pelos arquivos pdb (do epitopo e do epitopo padrao do MHC) e resgatar as informacoes relativas a cadeia, nome do residuo e numero do residuo do carbono alfa (CA). Apos, unir essas informaces aos grupos anteriormente criados
cmd.iterate ('("epitopo")' and 'name CA', 'chainresnresiEPITOPO.append([("epitopo"),chain,resn,resi])')
cmd.iterate ('("HLA-B2705_9mer_pattern")' and 'name CA', 'chainresnresiMHC.append([("HLA-B2705_9mer_pattern"),chain,resn,resi])')
## Imprimir na tela o novo conteudo dos grupos 
print chainresnresiEPITOPO
print chainresnresiMHC
#
## Abrir o prompt de comando da ferramenta "mutagenesis"
cmd.wizard("mutagenesis")
## Para o numero de itens no grupo chainresnresiEPITOPO, efetuar os seguintes comandos
for i in range(len(chainresnresiEPITOPO)):
    cmd.do("refresh_wizard")
    # Escolher o primeiro (i = 1 no primeiro laco) residuo ([2] se refere ao NOME do residuo dentro do grupo chainresnresiEPITOPO)
    cmd.get_wizard().set_mode("%s"%chainresnresiEPITOPO[i][2])
    # Criar um variavel chamada 'selection' que ira conter o NUMERO referente ao primeiro residuo do epitopo padrao do MHC
    selection="/HLA-B2705_9mer_pattern//C/%s"%(chainresnresiMHC[i][3])
    # Fazer a troca
    cmd.get_wizard().do_select(selection)
    # Escolher o primeiro rotamero (provavelmente o melhor)
    cmd.frame(1)
    # Aplicar as alteracoes
    cmd.get_wizard().apply()
    # Repetir o 'for' ate terminar
#
## Fechar o prompt do "wizard"
cmd.set_wizard("done")
## Remover o epitopo com o padrao antigo
cmd.delete ("epitopo")
## Salvar a nova estrutura com o padrao correto
cmd.do ("save Epitope_pattern.pdb")












