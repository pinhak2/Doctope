########################################################################################
#	                     Script Edited-D1EMD2 v2.0 (p_edited-D1EMD2)    
########################################################################################
###Script de montagem automatizada dos complexos pMHC
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo -e "\n                      Script Edited-D1EMD2 v2.0         "
echo -e "\n     Montagem de complexos utilizando arquivos editados para o D1.          "
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
#Testando parâmetro do alelo:
if test -z "$1"
	then
		echo -e "\n\tAtenção: Parâmetros não encontrados!!!"
		echo -e "\nMODO DE USAR: p_edited-D1EMD2 MHC-allele NP epitope"
		echo -e "Nota 2: Os alelos aceitos são A0201, B2705, H2DB, e H2KB."
		echo -e "Nota 3: Indique o número de núcleos na variável NP."
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
		echo -e "Qual alelo de MHC você deseja utilizar?"; read allele
    else
		#Transferir o valor de $1#
		allele=$1
fi
#Testando parâmetro do número de núcleos:
echo -e "\n"
if test -z "$2"
    then
		echo -e "\n\tAtenção: Não foi identificado o número de núcleos!!!"
		echo -e "\nMODO DE USAR: p_edited-D1EMD2 MHC-allele NP epitope"
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
		echo -e "Quantos núcleos você deseja utilizar para o Vina?"; read np
    else
		#Transferir o valor de $2#
		np=$2
fi
#
#Testando parâmetro do epitopo:
echo -e "\n"
if test -z "$3"
    then
		echo -e "\n\tAtenção: Não foi fornecido o arquivo do epitopo!!!"
		echo -e "\nMODO DE USAR: p_edited-D1EMD2 MHC-allele NP epitope"
		echo -e "\nBuscando pdbs na pasta..."
		echo -e "\Listando arquivos:"
		ls -1 *pdb
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
		cp *.pdb ligante.pdb
    else
		#Transferir o valor de $2#
		cp $3 ligante.pdb
fi	
#Criar pasta e PDBQT do ligante:
mkdir D1/
cd D1/
mv ../ligante.pdb .
/usr/local/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_ligand4.py -l ligante.pdb -B "None"
cp /usr/local/bioscripts/biofiles/MVina_CESUP.sh .
#Copiar arquivos específicos do MHC que será utilizado#
#Nao importa se o usuario forneceu o MHC em letra maiuscula ou minuscula
if [ $(echo "$allele" |tr [:upper:] [:lower:]) = "a0201" ] || [ $(echo "$allele" |tr [:upper:] [:lower:]) = "a-0201" ]
	then
		cp /usr/local/bioscripts/biofiles/donor_HLA-A0201.pdb .
		cp /usr/local/bioscripts/biofiles/donor_HLA-A0201.pdbqt .
		cp /usr/local/bioscripts/biofiles/Vina_config_HLA-A0201 .
		mv Vina_config_HLA-A0201 Vina_config
fi
#
if [ $(echo "$allele" |tr [:upper:] [:lower:]) = "b2705" ] || [ $(echo "$allele" |tr [:upper:] [:lower:]) = "b-2705" ]
	then
		cp /usr/local/bioscripts/biofiles/donor_HLA-B2705.pdb .
		cp /usr/local/bioscripts/biofiles/donor_HLA-B2705.pdbqt .
		cp /usr/local/bioscripts/biofiles/Vina_config_HLA-B2705 .
		mv Vina_config_HLA-B2705 Vina_config
fi
#
if [ $(echo "$allele" |tr [:upper:] [:lower:]) = "h2kb" ] || [ $(echo "$allele" |tr [:upper:] [:lower:]) = "h2-kb" ] || [ $(echo "$allele" |tr [:upper:] [:lower:]) = "kb" ]
	then
	cp /usr/local/bioscripts/biofiles/donor_H2Kb.pdb .
	cp /usr/local/bioscripts/biofiles/donor_H2Kb.pdbqt .
	cp /usr/local/bioscripts/biofiles/Vina_config_H2Kb .
	mv Vina_config_H2Kb Vina_config
fi
#
if [ $(echo "$allele" |tr [:upper:] [:lower:]) = "h2db" ] || [ $(echo "$allele" |tr [:upper:] [:lower:]) = "h2-db" ] || [ $(echo "$allele" |tr [:upper:] [:lower:]) = "db" ]
	then
	cp /usr/local/bioscripts/biofiles/donor_H2Db.pdb .
	cp /usr/local/bioscripts/biofiles/donor_H2Db.pdbqt .
	cp /usr/local/bioscripts/biofiles/Vina_config_H2Db .
	mv Vina_config_H2Db Vina_config
fi
#
#Chamar os scripts subsequentes...
#Rodar o D1:
p_vina $np
#Criar arquivo "sinal" para automatização
echo "auto" > ../d1emd2.din
#Escolher melhor resultado do D1 e prepar para o D2:
p_structchoice D1 $allele
#Remover arquivo "sinal" para automatização
rm ../d1emd2.din 
#Remover pasta de EM do pMHC
cd ..
cp pMHC_EM/pMHC_emlog.log .
rm -rf pMHC_EM/
#Rodar o D2:
cd $allele-D2/
p_vina $np
#Escolher melhor resultado do D2:
p_structchoice D2 $allele
