#v16.1
###Pipeline para Minimizar o pMHC e preparar os arquivos para o D2 - Compatível com Gromacs 4.5.1###
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo -e "\n    Script de preparação para o Docking 2 (D1-EM-D2)\n"
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
#Testando parâmetros fornecidos:
if test -z "$1"
	then
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
		echo -e "\n     ALERTA: Parâmetros não identificados!!!"
		echo -e "\n     Modo de Usar: p_MHC4D2 MHC-allele(obrigatório) name(opcional)"
		echo -e "\n     Lista dos alelos de MHC aceitos: A0201, B2705, H2DB e H2KB."
		echo -e "\n     Nota: Você pode fornecer qualquer \"name\" para o seu Dock2."
        echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n\n"
		#Abortar script#
        exit
	else
		if [ $(echo "$1" |tr [:upper:] [:lower:]) = "a0201" ] || [ $(echo "$1" |tr [:upper:] [:lower:]) = "a-0201" ] || [ $(echo "$1" |tr [:upper:] [:lower:]) = "b2705" ] || [ $(echo "$1" |tr [:upper:] [:lower:]) = "b-2705" ] ||  [ $(echo "$1" |tr [:upper:] [:lower:]) = "h2kb" ] || [ $(echo "$1" |tr [:upper:] [:lower:]) = "h2-kb" ] || [ $(echo "$1" |tr [:upper:] [:lower:]) = "kb" ] || [ $(echo "$1" |tr [:upper:] [:lower:]) = "h2db" ] || [ $(echo "$1" |tr [:upper:] [:lower:]) = "h2-db" ] || [ $(echo "$1" |tr [:upper:] [:lower:]) = "db" ]
			then
				#Prosseguir com o script#
                allele=$1
                echo -e "\n<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>"
    			echo -e "\n             Parâmetros recebidos."
                echo -e "\n<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>\n\n"
			else
                echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
				echo -e "\n     ALERTA: Alelo de MHC não identificado!!!"
				echo -e "\n     Modo de Usar: p_MHC4D2 MHC-allele(obrigatório) name(opcional)"
				echo -e "\n     Lista dos alelos de MHC aceitos: A0201, B2705, H2DB e H2KB."
                echo -e "\n     Nota: Você pode fornecer qualquer \"name\" para o seu Dock2.\n"
                echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n\n"
		fi
fi
#Minimização de Energia#
echo -e "13\r\n1\r" | pdb2gmx -f BEST_pMHC_D1 -ignh -p pMHC -o pMHC
editconf -f pMHC -o -d 0.9 
genbox -cp out -cs -p pMHC -o pMHC_box
grompp -v -f /usr/local/bioscripts/biofiles/em10000ps -c pMHC_box -o pMHC_topol -p pMHC
mdrun -v -s pMHC_topol -o pMHC_traj -c FINAL_pMHC_BOXem -g pMHC_emlog
echo -e "1\r" | trjconv -f FINAL_pMHC_BOXem.gro -s pMHC_topol.tpr -o SAIDA_NW.pdb
#Testando o segundo parâmetro#
if test -z "$2"
	then
		set $2= "Complex"
		echo -e "\n<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>"
		echo -e "\n  Nota1: O Nome do Dock2 não foi fornecido."
		echo -e "\n  Nota2: Renomeando pasta para $2-D2."		
		echo -e "\n<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>\n"
	else
    #Prosseguir com o script#
        echo -e "\n<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>"
        echo -e "\n Nota1: Nome do Dock2 fornecido pelo usuário."
        echo -e "\n Nota2: Renomeando pasta para $2-D2."       
        echo -e "\n<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>\n"
fi
#Organização das Pastas#
mkdir $2-D2
mkdir pMHC_EM
#Separação das cadeias#
pymol -c /usr/local/bioscripts/pMHC_split.py
#Organização dos Arquivos#
mv ep_4D2.pdb MHC_4D2.pdb $2-D2/
mv *.edr *.itp *.log *.pdb *.gro *.tpr *.mdp *.top *.trr pMHC_EM/
rm \#*
cp /usr/local/bioscripts/biofiles/MVina_CESUP.sh $2-D2/
cd $2-D2/ 
#Copiar arquivos específicos do MHC que será utlizado#
if [ $(echo "$1" |tr [:upper:] [:lower:]) = "a0201" ] || [ $(echo "$1" |tr [:upper:] [:lower:]) = "a-0201" ]
	then
		cp /usr/local/bioscripts/biofiles/Vina_config_HLA-A0201_D2 .
		mv Vina_config_HLA-A0201_D2 Vina_config
		cp /usr/local/bioscripts/biofiles/donor_HLA-A0201.pdb .
		mv donor_HLA-A0201.pdb donor_MHC.pdb
       else
        if [ $(echo "$1" |tr [:upper:] [:lower:]) = "b2705" ] || [ $(echo "$1" |tr [:upper:] [:lower:]) = "b-2705" ]
	        then
		        cp /usr/local/bioscripts/biofiles/Vina_config_HLA-B2705_D2 . 
		        mv Vina_config_HLA-B2705_D2 Vina_config
			cp /usr/local/bioscripts/biofiles/donor_HLA-B2705.pdb .
			mv donor_HLA-B2705.pdb donor_MHC.pdb
            else
                if [ $(echo "$1" |tr [:upper:] [:lower:]) = "h2kb" ] || [ $(echo "$1" |tr [:upper:] [:lower:]) = "h2-kb" ] || [ $(echo "$1" |tr [:upper:] [:lower:]) = "kb" ]
	                then
                	    cp /usr/local/bioscripts/biofiles/Vina_config_H2Kb_D2 .
                	    mv Vina_config_H2Kb_D2 Vina_config
			    cp /usr/local/bioscripts/biofiles/donor_H2Kb.pdb .
			    mv donor_H2Kb.pdb donor_MHC.pdb
                    else
                        if [ $(echo "$1" |tr [:upper:] [:lower:]) = "h2db" ] || [ $(echo "$1" |tr [:upper:] [:lower:]) = "h2-db" ] || [ $(echo "$1" |tr [:upper:] [:lower:]) = "db" ]
                    	    then
                        	    cp /usr/local/bioscripts/biofiles/Vina_config_H2Db_D2 .
                        	    mv Vina_config_H2Db_D2 Vina_config
			            cp /usr/local/bioscripts/biofiles/donor_H2Db.pdb .
			            mv donor_H2Db.pdb donor_MHC.pdb
                            else
                                #Limpar a pasta e encerrar o script#
                                cp /usr/local/bioscripts/biofiles/MVina_CESUP.sh .
                                mv *.edr *.itp *.log *.pdb *.gro *.tpr *.mdp *.top *.trr pMHC_EM/
                                rm \#*
								echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
                                echo -e "\n   ALERTA: Alelo não identificado!!!"
                        		echo -e "\n   Nota1: Vina_config não foi copiado para a pasta $2-D2."
		                        echo -e "\n   Nota2: SAIDA_NW.pdb não foi separado em ep_4D2.pdb e MHC_4D2.pdb."
                                echo -e "\n   Nota3: O arquivo SAIDA_NW.pdb permanece na pasta pMHC_EM."
								echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n\n"
                                exit
                        fi
                fi
        fi
fi
#Roda o script para fitar o MHC donor, utilizado no D1, com o MHC escolhido pelo structchoise (para manter as mesmas coordenadas da caixa no Vina_config)
sed -i 's/#$ -N/#$ -N D2_'$1'/' MVina_CESUP.sh
pymol -c /usr/local/bioscripts/MHC_epitope-FIT.py
rm donor_MHC.pdb
adt MHC_4D2.pdb &
#Preparar o ligante de forma manual
#Abrir ADT para seleção das torções flexíveis#
adt ep_4D2.pdb &
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
echo -e "\n     Minimização do complexo \"$2\" realizada com sucesso."
echo -e "\n     Salvando as estruturas ep_4D2.pdb e MHC_4D2.pdb..."
echo -e "\n     Nota1: Utilize o ADT para salvar o ep_4D2.pdbqt."
echo -e "\n     Nota2: Para definir as torsões, use a aba \"Ligand\"."
echo -e "\n     Obrigado por utilizar nosso programa.\n"
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n\n"
#Encerrar o script#
#
