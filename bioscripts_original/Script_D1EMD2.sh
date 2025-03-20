########################################################################################
#  		                     Script D1EMD2 v7.0.1 (p_D1EMD2)    
########################################################################################
###Script de montagem automatizada dos complexos pMHC
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo -e "\n             Script para montagem automatizada de complexos.          "
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
#Testando parâmetro do alelo:
if test -z "$1"
	then
		echo -e "\n\tAtenção: Parâmetros não encontrados!!!"
		echo -e "\nMODO DE USAR: p_D1EMD2 MHC-allele NP"
		echo -e "Nota 1: Este script irá procurar por um arquivo \"*.fasta\" (epitopo)."
		echo -e "Nota 2: Os alelos aceitos são A0201, B2705, H2DB, e H2KB."
		echo -e "Nota 3: Indique o número de núcleos na variável NP."
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
		echo -e "Qual alelo de MHC você deseja utilizar?"; read allele
    else
		#Transferir o valor de $1#
		allele=$1
fi
#Testando parâmetro do epitopo:
echo -e "\n"
if [ -e "epitopo.fasta" ]
    then
		mv epitopo.fasta EPITOPO.fasta
	else
		cp *.fasta EPITOPO.fasta
fi
#
if [ -e "EPITOPO.fasta" ]
    then
        echo -e "\n\tRecebendo sequência do epitopo...!!!"
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    else
		echo -e "\n\tAtenção: Epitopo não encontrado!!!"
		echo -e "\nNota: Forneça um arquivo de texto com o epitopo no formato FASTA."
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
		echo -e "Qual arquivo de sequência você deseja utilizar? (nome exato do arquivo!)"; read epitope
		#Renomear arquivo do epitopo#
		cp $epitope EPITOPO.fasta
fi
#Testando parâmetro do número de núcleos:
echo -e "\n"
if test -z "$2"
    then
		echo -e "\n\tAtenção: Não foi identificado o número de núcleos!!!"
		echo -e "\nMODO DE USAR: p_D1EMD2 MHC-allele NP"
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
		echo -e "Quantos núcleos você deseja utilizar para o Vina?"; read np
    else
		#Transferir o valor de $2#
		np=$2
fi
#Chamar os scripts subsequentes...
#Preparação para o D1:
p_prep4D1 $allele x
#Remover pasta de EM do epitopo
cp EM/Epitope_emlog.log .
rm -rf EM
#Rodar o D1:
cd D1/
p_vina $np
#Escolher melhor resultado do D1 e montar complexo final ("BEST"):
p_structchoice D1 $allele
#Verificar resultado do passo anterior
if [ -e BEST_pMHC_D1.pdb ]
	then
		echo -e "\n\tProsseguindo para etapas de Minimização Energia..."
	else
		echo -e "\nATENÇÃO: \"BEST_pMHC_D1.pdb\" não foi encontrado!!"
		echo -e "\nVerificando RMSCheck...\n"
		more RMSCheck*.log
		echo -e "\nAbortando \"D1-EM-D2\"..."
		exit
fi
#Sair da pasta do D1, carregando junto o BEST_pMHC_D1.pdb:
cp BEST_pMHC_D1.pdb ../
cd ..
#Chamar o Script de preparação para o Dock2:
p_MHC4D2 $allele
#Remover pasta de EM do pMHC
cp pMHC_EM/pMHC_emlog.log .
rm -rf pMHC_EM/
#Rodar o D2:
cd $allele-D2/
p_vina $np
#Escolher melhor resultado do D2:
p_structchoice D2 $allele
#Adiciona identificação (TITLE) no PDB gerado:
cd ..
/usr/local/bioscripts/ComplexID.sh $allele
