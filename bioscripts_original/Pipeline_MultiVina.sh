#Pipeline para docking múltiplo (Fila_Vina) e edição automática dos outputs#
#v3.0
#Certifique-se de que o MGLTools-1.5.4 está instalado em "/usr/local"#
###Vina####Vina Split###PDBQT to PDB###
#Checar parâmetro $1 (número de núcleos)
if test -z "$1"
    then
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        echo -e "\nALERTA: Usuário não definiu o número de núcleos a serem utilizados!"
        echo -e "\nNota: O Autodock Vina pode rodar em paralelo (mais rápido!)."
        echo -e "\nQuantos núcleos (ou threads) você deseja utilizar? (digite o nº)"; read np
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        echo -e "\n         Parâmetro identificado com sucesso."
        echo -e "\n         O processamento utilizará $np núcleos."
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"            
    else
        #Prosseguir com o script#
        np=$1
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        echo -e "\n         Parâmetro identificado com sucesso."
        echo -e "\n         O processamento utilizará $np núcleos."
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"  
fi
#Laço para rodar o vina 20 vezes
for ((x=1; x <= 20 ; x++))
    do
        vina --cpu $np --out vina_out_$x.pdbqt --log log_$x --config Vina_config
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
						echo -e "Nota 2: O script \"p_vina\" será interrompido!"
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
logvina
#
if [ -e vina_out_20.pdbqt ]
	then
		echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
		echo -e "\n         Script p_vina finalizado com sucesso."
		echo -e "\n         O arquivo EXCLUDED contém uma compilação dos Logs."
		echo -e "\n         Para escolher a melhor conformação, execute: p_structchoice"
		echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n" 
	else
		echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
		echo -e "\nATENÇÃO: Script p_vina apresentou problemas em sua execução."
		echo -e "\nConsulte os arquivos de log e o relatório do terminal (nohup) para"
		echo -e "identificar e corrigir o erro antes de executar o script novamente."
		echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n" 
fi
###FIM###
