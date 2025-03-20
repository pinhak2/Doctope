#v20.0
#$1=alelo 
#$2=x (parâmetro opcional, para automatização na geração do pdbqt do epitopo)
###Script de preparação do epitopo para o D1 - Compatível com Gromacs 4.5.1###
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo -e "\n    Script de preparação para o Docking 1 (D1-EM-D2)\n"
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
#Testando parâmetro do alelo:
if test -z "$1"
	then
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
		echo -e "\n\tAtenção: Parâmetros não encontrados!!!"
		echo -e "\nMODO DE USAR: p_prep4D1 MHC-allele"
		echo -e "Nota 1: Este script irá procurar por um arquivo \"*.fasta\" (epitopo)."
		echo -e "Nota 2: Os alelos aceitos são A0201, B2705, H2DB, e H2KB."
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
		echo -e "Qual alelo de MHC você deseja utilizar?"; read allele
    else
		#Transferir o valor de $1#
		allele=$1
fi
#Testando parâmetro do epitopo:
echo -e "\n"
cp *.fasta EPITOPO.fasta
if [ -e "EPITOPO.fasta" ]
    then
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        echo -e "\n\tRecebendo sequência do epitopo...!!!"
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    else
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
		echo -e "\n\tAtenção: Epitopo não encontrado!!!"
		echo -e "\nNota: Forneça um arquivo de texto com o epitopo no formato FASTA."
		echo -e "Qual arquivo de sequência você deseja utilizar? (nome exato do arquivo!)"; read epitope
		#Renomear arquivo do epitopo#
		cp $epitope EPITOPO.fasta
fi
#Prosseguir com o script#
		echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
		echo -e "\n         Parâmetros identificados com sucesso."
		echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"   
if [ $(echo "$allele" |tr [:upper:] [:lower:]) = "a0201" ] || [ $(echo "$allele" |tr [:upper:] [:lower:]) = "a-0201" ]
	then
		pymol -c /usr/local/bioscripts/mutagem_A0201_9mer_x1.py
fi
#
if [ $(echo "$allele" |tr [:upper:] [:lower:]) = "b2705" ] || [ $(echo "$allele" |tr [:upper:] [:lower:]) = "b-2705" ]
	then
		pymol -c /usr/local/bioscripts/mutagem_B2705_9mer_x1.py
fi
#
if [ $(echo "$allele" |tr [:upper:] [:lower:]) = "h2kb" ] || [ $(echo "$allele" |tr [:upper:] [:lower:]) = "h2-kb" ] || [ $(echo "$allele" |tr [:upper:] [:lower:]) = "kb" ]
	then
		pymol -c /usr/local/bioscripts/mutagem_H2Kb_8mer_x1.py
fi
#
if [ $(echo "$allele" |tr [:upper:] [:lower:]) = "h2db" ] || [ $(echo "$allele" |tr [:upper:] [:lower:]) = "h2-db" ] || [ $(echo "$allele" |tr [:upper:] [:lower:]) = "db" ]
	then
		echo -e "Digite o número de aminoácidos que o seu epitopo possui (9 ou 10):"; read option
			if [ $option = "9" ]
				then		
					pymol -c /usr/local/bioscripts/mutagem_H2Db_9mer_x1.py
			else
					pymol -c /usr/local/bioscripts/mutagem_H2Db_10mer_x1.py
			fi
fi
#
#Minimização de Energia#
echo -e "13\r\n1\r" | pdb2gmx -f Epitope_pattern.pdb -ignh -p Epitope -o Epitope
editconf -f Epitope -o -d 0.9 
genbox -cp out -cs -p Epitope -o Epitope_box
grompp -v -f /usr/local/bioscripts/biofiles/em10000ps -c Epitope_box -o Epitope_topol -p Epitope
mdrun -v -s Epitope_topol -o Epitope_traj -c FINAL_Epitope_BOXem -g Epitope_emlog
echo -e "1\r" | trjconv -f FINAL_Epitope_BOXem.gro -s Epitope_topol.tpr -o ligante_noChain.pdb 
editconf -f ligante_noChain.pdb -o ligante.pdb -label C
#
#Organização dos Arquivos#
mkdir EM
mv *.edr *.itp *.log *.pdb *.gro *.tpr *.mdp *.top *.trr EM/
rm \#* 
#	
mkdir D1
#	
cd D1/
mv ../EM/ligante.pdb . 
cp /usr/local/bioscripts/biofiles/MVina_CESUP.sh .
sed -i 's/#$ -N/#$ -N D1_'$1'/' MVina_CESUP.sh
#	
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
#Preparar o ligante de forma automatizada ou manual?
if test -z "$2"
	then
        #Parâmetro de automatização não recebido, prosseguir para operação manual;
        #Abrir ADT para seleção das torções flexíveis#
		#Abrir o epitopo para gerar o pdbqt#
		adt ligante.pdb &
		echo -e "\n*********************************************************************************"
		echo -e "\n  ATENÇÃO: Renomeie o arquivo \"ligante_model0.pdbqt\" para \"ligante.pdbqt\"    "
		echo -e "\n*********************************************************************************"
		#Encerrar o script#
        exit
	else
        #Parâmetro de automatização recebido, prosseguir para geração do ligante.pdbqt;
        /usr/local/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_ligand4.py -l ligante.pdb -B "None"
fi
#
