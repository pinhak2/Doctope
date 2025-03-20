#Pipeline universal para cálculo da frequência das ligações de hidrogênio entre dois grupos em uma dinâmica molecular.
#v3.1
###README;
#
# NOTA 1: Este pipeline chama o programa "g_hbond" do pacote gromacs-4.6.3 (instalado em /usr/local/gromacs-Extra);
# NOTA 2: Este pipeline chama o script "plot_hbmap.pl" (executado com PERL), o qual deve estar salvo em "/usr/local/bioscripts/";
#
#Parâmetros solicitados
#$1: Topologia da PR1 (*.tpr);
#$2: Trajetória da dinâmica de interesse (*.xtc);
#$3: Arquivo de indíce da dinâmica (*.ndx);
#$4: Grupo 1 no index (pontes serão calculadas apenas entre os grupos selecionados);
#$5: Grupo 2 no index (pontes serão calculadas apenas entre os grupos selecionados);
#$6: Nome do sistema que está sendo avaliado;
#
# NOTA 3: Caso algum dos arquivos não estiver na pasta em que o script está sendo executado, fornecer o caminho absoluto.
#
# MODO DE USAR: bash p_HBOND_index_X1.sh $1 $2 $3 $4 $5 $6
#
# Exemplo: bash p_HBOND_index_X1.sh ptasemdrun_PR1.tpr trjCONV-ptase-PR1-50ns.xvg index-1OHR.ndx 1 13 1OHR-NF 
#
###Fim do README; 
###Parte interativa do Script;
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo -e "\nScript universal para cálculo da frequência de Ligações de Hidrogênio"
#Checar parâmetro $1 (número de núcleos) e avisar sobre os parâmetros necessários:
if test -z "$1"
    then
	echo -e "\nNOTA: Este script exige seis parâmetros de entrada:"
	echo -e "\t> P1: Topologia da PR1 (*.tpr);"
	echo -e "\t> P2: Trajetória da dinâmica de interesse (*.xtc);"
	echo -e "\t> P3: Arquivo de índice da dinâmica (*.ndx);"
	echo -e "\t> P4: Grupo 1 (para o cálculo de HBONDs);"
	echo -e "\t> P5: Grupo 2 (para o cálculo de HBONDs);"
	echo -e "\t> P6: Nome do sistema que está sendo avaliado;"
	echo -e "\nMODO DE USAR: bash p_HBOND_index_X1.sh P1 P2 P3 P4 P5 P6"
	echo -e "\nOs parâmetros não foram recebidos. Deseja informar interativamente? (s/n)"; read pergunta0         		
		if [ $pergunta0 = 's' ] || [ $pergunta0 = 'S' ]
			then
				echo -e "\nIniciando fornecimento interativo dos parâmetros."
				echo -e "\nNOTA: Arquivos devem estar nesta pasta (ou forneça o caminho completo);"
				echo -e "NOTA: Escreva o nome EXATO do arquivo (o autocompletar não funciona);"
				echo -e "\nQual é seu arquivo tpr?"; read tpr
				echo -e "\nQual é seu arquivo xtc?"; read xtc
				echo -e "\nQual é seu arquivo ndx?"; read ndx
				echo -e "\nQual é o número do 1º grupo para o cálculo?"; read G1
				echo -e "\nQual é o número do 2º grupo para o cálculo?"; read G2
				echo -e "\nQual será o nome do seu \"job\"?"; read job
				echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
				echo -e "\nOs parâmetros recebidos foram:"
				echo -e "  P1: $tpr"
				echo -e "  P2: $xtc"
				echo -e "  P3: $ndx"
				echo -e "  P4: $G1"
				echo -e "  P5: $G2"
				echo -e "  P6: $job"
				echo -e "\nVocê confirma os 6 parâmetros e deseja continuar? (s/n)"; read pergunta1         		
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
							echo -e "\nModo de usar: bash p_HBOND_index_X2.sh P1 P2 P3 P4 P5 P6"
							echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
							exit
					fi
			else
				echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
				echo -e "\n Resposta negativa ou parâmetros não identificados."
				echo -e "\n O script será encerrado."
				echo -e "\nModo de usar: bash p_HBOND_index_X2.sh P1 P2 P3 P4 P5 P6"
				echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
				exit
		fi
    else
        #Prosseguir com o script#
        echo -e "\n         Primeiro parâmetro identificado com sucesso."
        echo -e "\n         O script será executado com os parâmetros fornecidos."
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n" 
	#Repassando variáveis:				
	tpr=$1
	xtc=$2
	ndx=$3
	G1=$4
	G2=$5
	job=$6 
fi
#
###Parte funcional do Script;
#
echo -e "$G1\r\n$G2\r" | /usr/local/gromacs-Extra/bin/g_hbond -s $tpr -f $xtc -num Hbond-$job.xvg -hbn hbond-index-full_$job.ndx -hbm hmap_$job.xpm -n $ndx
#
grep -i -A 200 "hbond" hbond-index-full_$job.ndx > hbond-index-CLEAN_$job.ndx
#
sed -i '1d' hbond-index-CLEAN_$job.ndx
/usr/local/gromacs-Extra/bin/editconf -f $tpr -o REFProtein-temp.pdb -label @
tr -d '@' <REFProtein-temp.pdb> REFProtein-noChain.pdb
sed -i '/SOL/d' REFProtein-noChain
rm REFProtein-temp.pdb
#
perl /usr/local/bioscripts/plot_hbmap.pl -s REFProtein-noChain.pdb -map hmap_$job.xpm -index hbond-index-CLEAN_$job.ndx
##Organizando arquivos
rm REFProtein-noChain.pdb hbond-index-CLEAN_$job.ndx hbond-index-full_$job.ndx
mv summary_HBmap.dat summary_HBmap_$job.dat
################################################
#Encerrando interface com usuário:
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo -e "\n Cálculo de pontes de hidrogênio finalizado."
echo -e "\n Resultados disponíveis em \"summary_HBmap_$job.dat\"."
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
