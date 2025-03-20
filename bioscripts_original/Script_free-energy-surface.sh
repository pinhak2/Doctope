#Pipeline universal para cálculo da superfície de energia livre em uma dinâmica molecular.
#v3.0
#Alias no Bioscripst: "p_fes"
#
###README;
#
# NOTA: Este pipeline chama o script "fes.py" (executado com Python), o qual deve estar salvo em "/usr/local/bioscripts/";
#
#Parâmetros solicitados
#$1: Arquivo de Raio de Giro (*.xvg);
#$2: Arquivo de RMSD (*.xvg);
#
# NOTA 2: Caso algum dos arquivos não estiver na pasta em que o script está sendo executado, fornecer o caminho absoluto.
#
# MODO DE USAR: bash p_free-energy-surface.sh $1 $2 ou, pelo alias, p_fes $1 $2
#
# Exemplo: bash p_fes rg.xvg rmsd.xvg
#
###Fim do README; 
###Parte interativa do Script;
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo -e "\nScript universal para cálculo da superfície de energia livre na MD"
#Checar parâmetro $1 (raio de giro) e avisar sobre os parâmetros necessários:
if test -z "$1"
    then
	echo -e "\nNOTA: Este script exige dois parâmetros de entrada:"
	echo -e "\t> P1: Arquivo de Raio de Giro (*.xvg);"
	echo -e "\t> P2: Arquivo de RMSD (*.xvg);"
	echo -e "\nMODO DE USAR: p_fes P1 P2"
	echo -e "\nOs parâmetros não foram recebidos. Deseja informar interativamente? (s/n)"; read pergunta0         		
		if [ $pergunta0 = 's' ] || [ $pergunta0 = 'S' ]
			then
				echo -e "\nIniciando fornecimento interativo dos parâmetros."
				echo -e "\nNOTA: Arquivos devem estar nesta pasta (ou forneça o caminho completo);"
				echo -e "NOTA: Escreva o nome EXATO do arquivo (o autocompletar não funciona);"
				echo -e "\nQual é seu arquivo de Raio de Giro?"; read rg
				echo -e "\nQual é seu arquivo de RMSD?"; read rmsd
				echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
				echo -e "\nOs parâmetros recebidos foram:"
				echo -e "  P1: $rg"
				echo -e "  P2: $rmsd"
				echo -e "\nVocê confirma os 2 parâmetros e deseja continuar? (s/n)"; read pergunta1         		
					if [ $pergunta1 = 's' ] || [ $pergunta1 = 'S' ]
						then
							echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
							echo -e "\n Usuário deseja prosseguir."
							echo -e "\n Utilizando parâmetros fornecidos."
							echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
						else
							echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
							echo -e "\n Resposta negativa ou parâmetros não identificados."
							echo -e "\n O script será encerrado."
							echo -e "\nModo de usar: p_fes P1 P2"
							echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
							exit
					fi
			else
				echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
				echo -e "\n Resposta negativa ou parâmetros não identificados."
				echo -e "\n O script será encerrado."
				echo -e "\nModo de usar: p_fes P1 P2"
				echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
				exit
		fi
    else
        #Prosseguir com o script#
        echo -e "\n         Primeiro parâmetro identificado com sucesso."
        echo -e "\n         O script será executado com os parâmetros fornecidos."
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n" 
	#Repassando variáveis:				
	rg=$1
	rmsd=$2
fi
#
###Parte funcional do Script;
echo -e "Escolha um dos scripts abaixo:"	
echo -e "(1) fes_OnePlot.py (gera apenas o plot default);"
echo -e "(2) fes.py (gera 6 variações para o mesmo plot);"; read fes
if [ $fes = '2' ]
    then
        echo -e "\n>>>\nExecutando script \"fes.py\""
        echo -e "Gerando gráficos de superfície de energia livre..."
        echo -e "   (Aguarde alguns segundos pelo \"pop-up\")\n>>>"
        echo -e "\nNota 1: Observe o gráfico gerado (eixo y = RMSD, eixo x = RG)."
        echo -e "Nota 2: A interface do gráfico permite editar e salvar o plot."
        echo -e "Nota 3: Outras opções de plot serão fornecidas sequencialmente."
        echo -e "        (feche o plot que está aberto para visualizar o próximo)."
        #
        python /usr/local/bioscripts/fes.py --rg_file $rg --rmsd_file $rmsd --bin1 30 --bin2 30 --temp 310 --output outfile --fsize 30
    else
        echo -e "\n>>>\nExecutando script \"fes_OnePlot.py\""
        echo -e "Gerando gráfico de superfície de energia livre..."
        echo -e "   (Aguarde alguns segundos pelo \"pop-up\")\n>>>"
        echo -e "\nNota 1: Observe o gráfico gerado (eixo y = RMSD, eixo x = RG)."
        echo -e "Nota 2: A interface do gráfico permite editar e salvar o plot."
        echo -e "Nota 3: Feche a o gráfico para liberar o terminal."
        #
        python /usr/local/bioscripts/fes_OnePlot.py --rg_file $rg --rmsd_file $rmsd --bin1 30 --bin2 30 --temp 310 --output OUTFILE_$rmsd --fsize 30
fi
#
################################################
#Encerrando interface com usuário:
echo -e "\n>>>\nCálculo de superfície de energia livre finalizado."
echo -e "\nArquivos de output disponíveis em:"
pwd
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
