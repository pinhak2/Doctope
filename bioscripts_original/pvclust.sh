########################################################################################
#      		                   Script pvclust v2.0    
########################################################################################
#Note: This script will use the R package pvclust.
#
#Initialinzing user interface...
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo -e "\n                        \"pvclust v2.0\"                         "
echo -e "\n             Pipeline to perform HCA automatically"
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
#
if [ -e HCA_input.csv ] 
	then 
		echo -e "\nRemove previous \"HCA_input.csv\"? (y/n)"; read question0         		
		if [ $question0 = 'y' ] || [ $question0 = 'Y' ]
			then
				rm HCA_input.csv
			else
				mv HCA_input.csv HCA_input-BACKUP.csv
		fi
fi	
####
if test -z "$1"
	then
		echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
		echo -e "\n           WARNING: User fail to provide a input file!!! "
		echo -e "\n           Mode of use: pvclust table.csv  100           "
		echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"	
		exit	
	else
		echo -e "\nProceeding with $1."
fi
####
fname=${1%.*};
cp $1 HCA_input.csv
####
if test -z "$3"
	then
		echo -e "\nProceeding with table in PVclust format."
	else
		if [ $3 = 'SPSS' ] || [ $3 = 'SPSS' ]  
			then
				echo -e "\nProceeding with table in SPSS format." 
				tr ',' '.' <HCA_input.csv > HCA_input_x1.csv
				rm HCA_input.csv
				tr ';' ',' <HCA_input_x1.csv > Table_input.csv
				#Transpose Matrix for use with PVclust.
				/usr/local/bioscripts/transpose_CSV_x3.r
				sed '/,V1/d' Table_transposed_output.csv > HCA_input.csv
				sed -i 's/[^,]*,//' HCA_input.csv
				cp HCA_input.csv $fname-Pvclust.csv
				rm Table_transposed_output.csv Table_input.csv HCA_input_x1.csv
			else
				echo -e "\n"
		fi
fi
####
if test -z "$2"
	then
        echo -e "Bootstrap value was not defined.\nUsing default (bootstrap=10000)\n"
        /usr/local/bioscripts/Automatic_HCA_b10000.r
		mv Rplots.pdf $fname-b10000.pdf
	else
		if [ $2 = '100' ];
			then 
				echo -e "Using low boostrap value (bootstrap=100)\n"
				/usr/local/bioscripts/Automatic_HCA_b$2.r
				mv Rplots.pdf $fname-b100.pdf
			else
				if [ $2 = '10000' ];
					then
						echo -e "Using bootstrap=10000.\n"
						/usr/local/bioscripts/Automatic_HCA_b10000.r
					else
				        echo -e "Incorrect bootstrap value.\nUsing default (bootstrap=10000)\n"
				        /usr/local/bioscripts/Automatic_HCA_b10000.r
						mv Rplots.pdf $fname-b10000.pdf
				fi
		fi
fi
#
echo -e "\nAutomatic HCA performed with Pvclust.\nResults available in $fname.pdf\n."
#
rm HCA_input.csv 

