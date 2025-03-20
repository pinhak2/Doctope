#!/bin/bash
#$ -S /bin/sh
#$ -N dock
#$ -o .
#$ -e .
#$ -q p_fat_small.q
#$ -pe mpich 16-32
#$ -cwd
#v2014
#Laço para rodar o vina 20 vezes, utilizando o mesmo input.
for ((x=1; x <= 20 ; x++))
    do
        /home/u/biogeek/vina/autodock_vina_1_1_1_linux_x86/bin/vina --cpu $NSLOTS --out vina_out_$x.pdbqt --log log_$x --config Vina_config
		if [ -e vina_out_$x.pdbqt ]
			then
				echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
				echo -e "Docking nº $x/20 finalizado com sucesso."
				echo -e "Resultados salvos na pasta:"
				pwd
				echo -e "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
			else
				if [ $x = 1 ] 
					then
						echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
						echo -e "ATENÇÃO: Falha de execução na primeira rodada do docking!!!!"
						echo -e "\nConsulte o arquivo \"log_$x\" e o relatório do terminal (acima)."
						echo -e "\nArquivos de input e log podem ser encontrados em:"
						pwd
						echo -e "\nNota 1: Verifique se esta pasta contém os dois *.pdbqt e o \"Vina_config\""
						echo -e "Nota 2: O script \"MultiVina-CESUP.sh\" será interrompido!"
						echo -e "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
						exit
					else
						echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
						echo -e "\nATENÇÃO: o docking nº $x/20 não foi concluido corretamente."
						echo -e "\nConsulte o arquivo \"log_$x\" ou o relatório do terminal (nohup)."
						echo -e "\nArquivos de input e log podem ser encontrados em:"
						pwd
						echo -e "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"						
				fi
		fi
    done
#Analisar os logs e gerar o arquivo EXCLUDED#
bash /home/u/biogeek/bioscripts-CESUP/logvina_unique_v7.sh
#
if [ -e vina_out_20.pdbqt ]
	then
		echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
		echo -e "\n         Script p_vina finalizado com sucesso."
		echo -e "\n         O arquivo EXCLUDED contém uma compilação dos Logs."
		echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n" 
	else
		echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
		echo -e "\nATENÇÃO: Script p_vina apresentou problemas em sua execução."
		echo -e "\nConsulte os arquivos de log e o relatório do terminal (job_eID) para"
		echo -e "identificar e corrigir o erro antes de executar o script novamente."
		echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n" 
fi
###FIM###
