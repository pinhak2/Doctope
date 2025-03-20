#v2.0
###Script para minimização simples com o em10000ps###
#Testando parâmetros fornecidos:
if test -z "$1"
    then
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        echo -e "\n                ALERTA: Parâmetros não encontrados!!!"
        echo -e "\n                Modo de usar: p_EM file.pdb         "
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
        #Abortar script#
        exit
    else
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        echo -e "\n        Parâmetro de input identificado com sucesso."
        echo -e "\n        Iniciando a minimização da estrutura $1..."
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
fi
#Prosseguir com o script#
echo -e "13\r\n1\r" | pdb2gmx -f $1 -ignh -p prot_TOPOLOGIA -o prot
editconf -f prot -o -c -d 0.9 -bt cubic
genbox -cp out -cs -p prot_TOPOLOGIA -o prot_box
grompp -v -f /usr/local/bioscripts/biofiles/em10000ps -c prot_box -o prot_topol -p prot_TOPOLOGIA
mdrun -v -s prot_topol -o prot_traj -c FINAL_prot_BOXem -g prot_emlog
#Gerar PDB sem águas...
echo -e "1\r" | trjconv -s prot_topol.tpr -f FINAL_prot_BOXem.gro -o SAIDA_NW.pdb
#

