########################################################################################
#      		                   Structchoice v20.0.9            
#          Script para otimizar a escolha dos ligantes oriundos do vina.
########################################################################################
#!/bin/bash
#$1=D1, D2 ou Dx
#$2=Alelo/Receptor
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo -e "\n    Script para análise automatizada dos múltiplos outputs do Vina\n"
#Testando parâmetros fornecidos:
if test -z "$1"
    then
        echo -e "\n               ALERTA: Parâmetros não encontrados!!!"
        echo -e "\n               Modo de usar: p_structchoice opção"
        echo -e "\n               Lista das opções aceitas: D1, D2 ou Dx."
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        echo -e "Digite uma das opções aceitas?"; read option            
    else
        #Prosseguir com o script#
        option=$1
fi
#
echo -e "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo -e "\n         Parâmetro identificado com sucesso."
echo -e "\n         Iniciando análise de $option."
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"    
#Prosseguir com o script#
#Nao importa se o usuario passou os parametros em letra maiuscula ou minuscula
if [ $(echo "$option" |tr [:upper:] [:lower:]) = "d1" ] || [ $(echo "$option" |tr [:upper:] [:lower:]) = "d2" ] || [ $(echo "$option" |tr [:upper:] [:lower:]) = "dx" ]
    then
        #Verificar se existem outputs do Vina para analisar  
        if [ -e vina_out_1.pdbqt ]
            then
                echo -e "\nInicializando Vina_split...\n"
            else            
                #Verificar se o script já não foi executado nesta pasta
                if [ -e Vina_OUTs ]
                    then
                        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
                        echo -e "\nALERTA: O p_structchoice já foi executado nesta pasta."
                        echo -e "\nRepetir a escolha utilizando os arquivos da pasta Vina_OUTs? [s/n]"; read repeat
                            if [ $repeat = 'S' ] || [ $repeat = 's' ]
                                then
                                    #Reorganizar arquivos para repetir a escolha
                                    cp Vina_OUTs/* .
                                    cp LOGs/* .                                    
                                    rm -R Top20 Estruturas-escolhidas LOGs Vina_OUTs TheOne \#* RMSCheck*.log
                                else
                                    #Abortar o script
                                    echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
                                    echo -e "\n     Script interrompido pelo usuário."
                                    echo -e "\n     Verifique a pasta em que está executando o p_structchoice."
                                    echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
                                    exit
                            fi
                    else
                        #Abortar o script
                        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
                        echo -e "\n     ALERTA: Não existem outputs do Vina nesta pasta."
                        echo -e "\n     Verifique a pasta em que está executando o p_structchoice."
                        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
                        exit
                fi                    
        fi
        #Laço para rodar o vina_split 20 vezes
        for ((vs=1; vs <= 20 ; vs++))
            do
                vina_split --input vina_out_$vs.pdbqt --ligand vina_out_$vs-ligand_
                /usr/local/MGLToolsPckgs/AutoDockTools/Utilities24/pdbqt_to_pdb.py -f vina_out_$vs-ligand_1.pdbqt -o vina_out_$vs-ligand_1.pdb
            done
        #Gerar o arquivo EXCLUDED
        logvina
    else
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        echo -e "\n                  ALERTA: Parâmetro não identificado!!!"
        echo -e "\n                Nota: Os parâmetros aceitos são D1, D2 ou Dx."
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
        #Abortar script#
        exit
fi
################################################
# Escolher os logs contendo os melhores Binding Energy (BE)
# Média dos BE
var=1
count=0
#
until [ $var = "0" ]; do
   awk 'match($0,"   1 ") != 0 {print $2}' log_$var > BE_$var
   var=`expr $var + 1` 
   if [ $count = 19 ]; then
      var=0
   fi
   count=`expr $count + 1`    
done
#
cat BE_1 BE_2 BE_3 BE_4 BE_5 BE_6 BE_7 BE_8 BE_9 BE_10 BE_11 BE_12 BE_13 BE_14 BE_15 BE_16 BE_17 BE_18 BE_19 BE_20 > BE_cat
#
awk '{sum=sum+$1}END{print sum}' BE_cat > BE_soma
variavel=$(awk '{ div1=$1/20 } { print div1 }' BE_soma)
#
var=1
count=0
#
until [ $var = "0" ]; do
   awk 'match($0,"   1 ") != 0 {print $2}' log_$var > log_$var.2
   awk '{if($1<= '$variavel') print $1}' log_$var.2 >log_$var.3
   sed "s/^-[0-9]/log_$var &/" log_$var.3 >log_$var.4
   awk '/^l/ {print $1}' log_$var.4 >log_$var.5
   sed "s/log_$var/cp vina_out_$var-ligand_1.pdb Estruturas-escolhidas/g" log_$var.5  >log_$var.6 
   var=`expr $var + 1` 
   if [ $count = 19 ]; then
      var=0
   fi
   count=`expr $count + 1`    
done
#
#Concatenar os arquivos log_*.6 e Executar o comando 'cp' dentro do log_list, que vai copiar as estruturas .pdb com o melhor BE
cat log_*.6 > log_list
chmod +x log_list
#
# Remover os arquivos de log que não serão mais utilizados
for ((x=1; x <= 20 ; x++))
    do
        for ((y=2; y<= 6 ; y++))
            do
            rm log_$x.$y
            done
    done
#
#Se o arquivo existir, e for maior que '0 kb', executá-lo. Se não, sair do programa
if [ -s log_list ]
    then
        mkdir Estruturas-escolhidas
        ./log_list
    else
        rm log_list
        echo
        echo -e "\tNão foi encontrado nenhum arquivo com o limite de BE especificado!"
        echo
        exit
fi
#
#Entrar no diretório onde estão as estruturas escolhidas
cd Estruturas-escolhidas

# Testa a existência dos arquivos '.pdb' e executa o script em caso positivo;
for ((x=1; x <= 20 ; x++)); do
	if [ -e vina_out_$x-ligand_1.pdb ]; then
		echo "Nota: vina_out_$x-ligand_1.pdb -Arquivo existe."

	for ((y=1; y <= 20 ; y++)); do
		if [ -e vina_out_$y-ligand_1.pdb ]; then
			echo "Nota: vina_out_$y-ligand_1.pdb -Arquivo existe."
			
		# Script para g_confrms;
			echo -e "1\r\n1\r" | g_confrms -f1 vina_out_$x-ligand_1 -f2 vina_out_$y-ligand_1 -o $x-RMSD-$x-$y > RMSD-$x-$y

			awk '/^Root/ {print $9}' RMSD-$x-$y > rmsd-$x-$y
			rm RMSD-$x-$y

		#Concatenar os arquivos contendo os RMSDs entre cada par de epitopos em um único arquivo, para cada epitopo
		#a=1og_$var
			cat rmsd-$x-* > cat-$x
		fi

	# Remover as linhas que contém 'e' dos arquivos concatenados.
	# São aqueles em que foi calculado o RMSD da estrutura contra ela mesma;
		sed /'e'/d cat-$x > cat-$x-del
		#find cat-$x-del -size -30c | xargs rm	


	# Somar os valores de cada linha e dividir pelo número de linhas (vai retornar a média de RMSD referente a cada ligante);
	# Conta o número de linhas de cada arquivo cat-x-del; 
		awk '/[0-9]/ { ++x } END { print x}' cat-$x-del > cat-linhas$x

	# Remove os arquivos .gro (saida do g_confrms)
		#rm *.gro

	# Loop para calcular a média;
	# Soma de todas as linhas;
		paste -s -d + cat-$x-del | bc > cat-$x-soma

	# Arquivo único, contendo a soma na coluna 1 e o número de linhas na coluna 2;
		paste cat-$x-soma cat-linhas$x > cat-$x-soma-e-linha

	# Cálculo da média;
		awk '{ div1=$1/$2 } { print '$x', div1 }' cat-$x-soma-e-linha > cat-$x-media
	
	# Escolher o ligante que possui a menor média
	# Concatenar arquivos de media;
		cat cat-*-media > cat-medias
		sed "s/[.]/,/g" cat-medias > cat-medias2
		awk '{print  $1}' cat-medias2 > cat-medias5
		awk '{print  $2}' cat-medias2 > cat-medias6
		sed 's/$/./' cat-medias5 > cat-medias7
		paste cat-medias7 cat-medias6 > cat-medias8
	
	# Ordenar as linhas de acordo com o menor RMSD;
		sort -k 2,2 -s cat-medias8 > cat-ordenado
	
	# Copiar primeira linha para outro arquivo;
		sed -e '2,20d' cat-ordenado > cat-BEST

	# Copiar apenas a primeira coluna;
		awk '{print $1}' cat-BEST > cat-BEST2
	done

	else
		echo "Nota: vina_out_$x-ligand_1.pdb - Arquivo não existe"
	fi
done

#Criar diretório que vai armazenar o .pdb referente ao melhor ligante
mkdir Ligante-escolhido

#Armazenar o número do melhor ligante na variável "file"
sed -i 's/\.$//g' cat-BEST2
file=$(sed -n "1p" cat-BEST2)
echo -e "cp vina_out_$file-ligand_1.pdb Ligante-escolhido" > cat-MELHOR$file

#Executar cat-MELHOR   
chmod +x cat-MELHOR$file
./cat-MELHOR$file
#
#Remove arquivos com 0 bytes
#find . -size 0k | xargs rm
###############################################################Inciando acréscimos do Dinler...
#Sair da pasta e copiar o melhor ligante para fora, renomeando-o.
cd ../
cp Estruturas-escolhidas/Ligante-escolhido/vina_* ligante_escolhido.pdb
#Mover arquivos do BE e remover arquivos redundantes.
mv BE_* Estruturas-escolhidas/
rm vina_*-ligand_*.pdbqt
mkdir Top20 Vina_OUTs LOGs TheOne
mv vina_out*.pdbqt Vina_OUTs
mv vina_*-ligand_*.pdb Top20
mv log_* LOGs
cp Estruturas-escolhidas/Ligante-escolhido/vina_* TheOne
rm -R Estruturas-escolhidas/
#################################Prosseguir para a montagem do complexo (sele.pdb)
#
#########################Iniciando acréscimos para Dx...
#Este segmento de código (entre as linhas ~242 e ~286) foi incluido para permitir a utilização do
#Strcutchoice na escolha de resultados de Docking para outros complexos Receptor-Ligante. A 
#primeira parte deste scrit (acima) independe do sistema, portanto não precisa ser ajustada. 
#Assim sendo, este trecho de código não tem nenhum envolvimento com o processo de montagem de 
#complexos (D1-EM-D2), podendo ser removido em uma eventual otimização deste script.
#
if [ $(echo "$option" |tr [:upper:] [:lower:]) = "dx" ]
    then
        #Usuário não está construindo pMHC (não é D1-EM-D2).
        #Verificar parâmetro $2 (No caso Dx, $2 é o nome do receptor!).
        if test -z "$2"
            then
                echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
                echo -e "\nALERTA: Nome do receptor não identificado!!!"
                echo -e "\nOpção Dx exige o nome do \"receptor\".pdb"
                echo -e "\nNota:\"receptor\".pdb DEVE estar na pasta."
                echo -e "\nQual \"receptor\" você está utilizando? (grafia EXATA, sem o \".pdb\")"; read receptor
                echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
                echo -e "\n         Parâmetro de receptor identificado com sucesso."
                echo -e "\n         Iniciando receptor $receptor.pdb"
                echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"            
            else
                #Prosseguir com o script#
                receptor=$2
                echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
                echo -e "\n         Parâmetro de receptor identificado com sucesso."
                echo -e "\n         Iniciando receptor $receptor.pdb"
                echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
        fi
        #Montar complexo final.
        cp $receptor.pdb Receptor.pdb
        pymol -c /usr/local/bioscripts/dock_Built.py
        mv sele.pdb FINAL-$receptor-complex.pdb
        #Remover o "Receptor.pdb" e encerrar script (fim da análise para Dx)
        rm Receptor.pdb ligante_escolhido.pdb
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        echo -e "\n         Escolha do melhor resultado finalizada com sucesso."
        echo -e "\n         Ligante escolhido salvo na pasta \"TheOne\"".
        echo -e "\n         Complexo salvo como \"FINAL-$receptor-complex.pdb\"."
        echo -e "\n         Obrigado por utilizar nosso script!"
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n" 
    exit
fi
########################Prosseguindo com script ajustado para D1-EM-D2... 
#Checar parâmetro $2 (No casos "D1" e "D2", $2 é o nome do Alelo de MHC) 
if test -z "$2"
	then      
		echo -e "\nNOTA: OBSERVE A GRAFIA EXATA (UPERCASE) DO ALELO UTILIZADO!"
		echo -e "\n      Opções: A0201, B2705, H2KB e H2DB."
		echo -e "\nQual a sigla do alelo que você está rodando?"; read allele
	else
	allele=$2
fi
#Definir tarefas para D1 ou D2:
if [ $(echo "$option" |tr [:upper:] [:lower:]) = "d2" ]
    then 
		#Usuário estava avaliando um D2 -> Fim da Análise do D2.		
		#Gerar o complexo final
		cp MHC_4D2.pdb MHC_utilizado.pdb
		pymol -c /usr/local/bioscripts/pMHC_Built.py
		mv sele.pdb FINAL-$allele-pMHC.pdb
		model="FINAL-$allele-pMHC.pdb"
		rm MHC_utilizado.pdb ligante_escolhido.pdb
    else
        #Usuário estava avaliando um D1 -> Prosseguir para a construção do BEST_pMHC_D1.pdb
        cp donor_*.pdb MHC_utilizado.pdb
        pymol -c /usr/local/bioscripts/pMHC_Built.py
        mv sele.pdb BEST_pMHC_D1.pdb
		model="BEST_pMHC_D1.pdb"
        rm MHC_utilizado.pdb ligante_escolhido.pdb
fi
#########################Prosseguindo com RMSCheck...
#Teste de localização do epitopo ==> Ponto de corte definido em 1.98 angstrons! (variável n2 na linha do awk)
cp /usr/local/bioscripts/biofiles/MHC1_$allele*.pdb MHC1.pdb
cp $model MHC2.pdb
pymol -c /usr/local/bioscripts/RMSCheck.py | awk '/: RMS/{print $4}' > RMSCheck.txt
#RMSCheck.txt deve ter 2 valores de RMS, o do epitopo está na segunda linha.
lines=$(cat RMSCheck.txt | wc -l)
if [ "$lines" -eq 2 ]
	then
		rms=$(sed -n "2p" RMSCheck.txt)
	else
		echo -e "########################### RMSCheck LOG ###########################" > RMSCheck_ERROR.log 
		echo -e "\nWARNING: RMSCheck was not able to calculate epitope RMSD!!" >> RMSCheck_ERROR.log
		echo -e "\nWARNING: Please check your files!!" >> RMSCheck_ERROR.log
		echo -e "\n########################### RMSCheck LOG ###########################\n" >> RMSCheck_ERROR.log 
		more RMSCheck_ERROR.log
		mv $model \#"$model"#
		rm RMSCheck.txt
		exit
fi
rm MHC1.pdb MHC2.pdb RMSCheck.txt
#Cálculo de RMSD realizado pelo awk
echo | awk -v n1=$rms -v n2=1.98  '{if (n1>n2) print ("WARNING: RMS for epitope backbone is too high!!") ;}'>RMSCheck_ERROR.log
find . -size 0k | xargs rm
if [ -e RMSCheck_ERROR.log ]
	then
		sed -i '/WARNING/i ########################### RMSCheck LOG ###########################\n' RMSCheck_ERROR.log
		echo -e "\nWARNING: RMSD = $rms Angstrons!!!! (backbone)" >> RMSCheck_ERROR.log
		echo -e "\nWARNING: Epitope seems to be out of place!!" >> RMSCheck_ERROR.log
		echo -e "\n########################### RMSCheck LOG ###########################\n" >> RMSCheck_ERROR.log 
		mv $model \#"$model"#
		more RMSCheck_ERROR.log
	else
		echo -e "########################### RMSCheck LOG ###########################" > RMSCheck.log 
		echo -e "\nNote: RMSCheck verifies the epitope position inside the MHC cleft." >> RMSCheck.log 
		echo -e "RMSD values (for backbone) higher than 1.98 Angstrons are indicative\nof a wrong docking result." >> RMSCheck.log
		echo -e "\nCalculated RMSD for this epitope at \"$option\": $rms Angstrons." >> RMSCheck.log
		echo -e "\n########################### RMSCheck LOG ###########################" >> RMSCheck.log 
		echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
		echo -e "\n        Análise dos resultados do \"$option\" realizada com sucesso."
		echo -e "\n        Salvando a estrutura final ($model)..."
		echo -e "\n        Obrigado por utilizar nosso script."
		echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
fi
#
