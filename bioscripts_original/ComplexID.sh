#######################################################################################
#    		                   Script ComplexID v2.0                                  #
#   Script to includ automatic identification (TITLE) on pMHCs built with "D1-EM-D2"  #
#######################################################################################
#$1 > MHC allele
#$2 > "EPITOPO.fasta"
####
if [ $(echo "$1" |tr [:upper:] [:lower:]) = "a0201" ] || [ $(echo "$1" |tr [:upper:] [:lower:]) = "a-0201" ]
	then
		allele=HLA-A0201
fi
#
if [ $(echo "$1" |tr [:upper:] [:lower:]) = "b2705" ] || [ $(echo "$1" |tr [:upper:] [:lower:]) = "b-2705" ]
	then
		allele=HLA-B2705
fi
#
if [ $(echo "$1" |tr [:upper:] [:lower:]) = "h2kb" ] || [ $(echo "$1" |tr [:upper:] [:lower:]) = "h2-kb" ] || [ $(echo "$1" |tr [:upper:] [:lower:]) = "kb" ]
	then
		allele=H2-Kb
fi
#
if [ $(echo "$1" |tr [:upper:] [:lower:]) = "h2db" ] || [ $(echo "$1" |tr [:upper:] [:lower:]) = "h2-db" ] || [ $(echo "$1" |tr [:upper:] [:lower:]) = "db" ]
	then
		allele=H2-Db
fi
#Check Epitope Sequence
if test -z "$2"
    then
		#Get epitope sequence
		seq=$(sed -n "2p" EPITOPO.fasta)
	else
		seq=$(sed -n "2p" $2)
fi
#Check for "FINAL" complex
if [ -e *-D2/FINAL-*-pMHC.pdb ]
	then
		echo -e "\nProceeding with complex identification..."
	else
		echo -e "\nWARNING: The PDB file with the final pMHC complex was not found!!"
		echo -e "\nWARNING: Aborting identification precess..."
		exit
fi
#Save info
echo -e "TITLE     Complex modeled with the D1-EM-D2 approach (Antunes et al., 2010)." > Title
echo -e "TITLE     This pMHC complex contains \"$seq\" in the context of $allele." >> Title
cat Title *-D2/FINAL-$1-pMHC.pdb > FINAL-$1-pMHC_id.pdb
rm Title EPITOPO.fasta *-D2/FINAL-$1-pMHC.pdb
cd *-D2
mv ../FINAL-$1-pMHC_id.pdb FINAL-$1-pMHC.pdb
#

