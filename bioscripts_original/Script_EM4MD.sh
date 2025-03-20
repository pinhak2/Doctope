#v2.5
###Script para minimização EM PARALELO com f4 (MDPs_IV).
if test -z "$1"
    then
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        echo -e "\n                ALERTA: Parâmetro \"file.pdb\" não encontrado!!!"
        echo -e "\n                Modo de usar: p_EM4MD file.pdb np      "
        echo -e "\n                NOTA: \"np\"= número de processadores (int)"
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
        #Abortar script#
        exit
    else
		if test -z "$2"
			then
				echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
		        echo -e "\n                ALERTA: Parâmetro \"np\" não encontrado!!!"
				echo -e "\n                Modo de usar: p_EM4MD file.pdb np      "
				echo -e "\n                NOTA: \"np\"= número de processadores (int)"
				echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
				#Abortar script#
				exit
			else
				echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
				echo -e "\n        Parâmetros de input identificados com sucesso."
				echo -e "\n        Iniciando a minimização da estrutura $1..."
				echo -e "\n        Número de processadores utilizados = $2."
				echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
		fi
fi
#Prosseguir com o script#
#Etapa de preparação dos arquivos (topologia, estrutura, caixa d'água);
echo -e "13\r\n1\r" | pdb2gmx -f $1 -ignh -p prot_TOPOLOGIA -o prot
editconf -f prot -o -c -d 0.9 -bt cubic
genbox -cp out -cs -p prot_TOPOLOGIA -o prot_box
#Adição de íons (o mdp utilizado nesta etapa é irrelevante, pois o objetivo é apenas editar a topologia)#
grompp  -f /usr/local/bioscripts/biofiles/MDPs_IV/005_em_pr -c prot_box -p prot_TOPOLOGIA -o protmdrun_EM0
echo -e "13\r" | genion -s protmdrun_EM0.tpr -o prot_ION.gro -g genion.log -p prot_TOPOLOGIA.top -pname NA -nname CL -neutral -conc 0.15
#Minimização de Energia com PR;
grompp  -f /usr/local/bioscripts/biofiles/MDPs_IV/005_em_pr -c prot_ION.gro -p prot_TOPOLOGIA -o protmdrun_EM1
mpirun -np $2 mdrun -v -s protmdrun_EM1 -o prot_traj_EM1 -c prot_BOX_EM1 -g prot_log_EM1 -e energia_EM1.edr
#Minimização de Energia flexível;
grompp  -f /usr/local/bioscripts/biofiles/MDPs_IV/010_em_full_steep -c prot_BOX_EM1 -p prot_TOPOLOGIA -o protmdrun_EM2
mpirun -np $2 mdrun -s protmdrun_EM2 -o prot_traj_EM2 -c prot_BOX_EM2 -g prot_log_EM2 -e energia_EM2.edr
#Minimização de Energia CG;
grompp  -f /usr/local/bioscripts/biofiles/MDPs_IV/015_em_full_cg -c prot_BOX_EM2 -p prot_TOPOLOGIA -o protmdrun_EM3
mpirun -np $2 mdrun -s protmdrun_EM3 -o prot_traj_EM3 -c prot_BOX_EM3 -g prot_log_EM3 -e energia_EM3.edr
#Gerar PDB sem águas...
echo -e "1\r" | trjconv -s protmdrun_EM0.tpr -f prot_BOX_EM3.gro -o SAIDA_NW.pdb
