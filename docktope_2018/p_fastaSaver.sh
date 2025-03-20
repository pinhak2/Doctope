##########################################################
#   	        Script p_fastaSaver
##########################################################
#Initialinzing user interface...
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo -e "\n                        \"fastaSaver v3.0\"                         "
echo -e "\n      Pipeline to save FASTA input files for queue_docktope.sh      "
echo -e "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
#Check for input Table
if test -z "$1"
    then
        echo -e "\nNOTE 1: This script will read an input Table and generate a FASTA"  
        echo -e "file for each listed peptide."
        echo -e "\nNOTE 2: Input table must be a CSV two column comma separated file,"
        echo -e "including column headings."
        echo -e "\nExample:"
        echo -e "\tName,Sequence"
        echo -e "\tG1-01,CVNGVCWTV"
        echo -e "\tG1-02,CVSGVMWTV"
        echo -e "\t(...)"
        echo -e "\nSearching for CSV input files:"
        ls -1 *.csv
        echo -e "\nProvide the complete name of the desired file (only one!):";read inputfile
        if [ -e $inputfile ]
            then     
                #Check for "headings"
                echo -e "\nChecking $inputfile content:"
                head $inputfile
                echo -e "(...)\n"
                echo -e "Exclude first line (Heading)? (y/n)"; read line1
                if [ $line1 = y ] || [ $line1 = Y ]
                    then 
                        sed -e '1d' $inputfile > Table.csv
                    else
                        echo -e "\nUser provided a Table without headings."    
                        cp $inputfile Table.csv
                fi
            else
                echo -e "\nFail to find $inputfile..."
				echo -e "\nNOTE: File name CANNOT have spaces!! (Use underline)"
    			echo -e "\nAborting script.\n"
                echo -e "WARNING: Fail to find file provided by user (\"$inputfile\")." > Warning.log
				echo -e "\nNOTE: File name CANNOT have spaces!! (Use underline)" >> Warning.log
				exit
        fi        
    else
        inputfile=$1
        if [ -e $inputfile ]
            then     
                echo -e "\nProceeding with $inputfile..."
            else
                echo -e "\nFail to find $inputfile..."
				echo -e "\nNOTE: File name CANNOT have spaces!! (Use underline)"
    			echo -e "\nAborting script.\n"
                echo -e "WARNING: Fail to find \"$inputfile\"..." > Warning.log
				echo -e "\nNOTE: File name CANNOT have spaces!! (Use underline)" >> Warning.log
				exit
        fi
        #Check for "headings"
        if test -z "$2"
            then
                echo -e "\nExcluding first line of the Table (Heading)..."
                sed -e '1d' $inputfile > Table.csv
            else
                if [ $2 = nh ] || [ $2 = NH ] || [ $2 = Nh ] || [ $2 = nH ] 
                    then
                        echo -e "\nUser provided a Table without headings."    
                        cp $inputfile Table.csv
                    else
                        echo -e "\nUser provided an unknown \$2 parameter."
                        echo -e "\nExcluding first line of input Table (Heading)..."
                        sed -e '1d' $inputfile > Table.csv
                fi       
        fi  
fi
#Get the number of rows (Targets) in the input csv file:
rows=$(cat Table.csv | wc -l)
#
cut -d, -f1 Table.csv > Targets.txt
cut -d, -f2 Table.csv > Sequences.txt
echo ">" > Symbol.txt
#
#To test these sed comands in a prompt, use:
#sed -n "3p" Targets.txt
#(to print the 3rd line of Targets.txt file)
for ((x=1; x < 10; x++));do
	sed -n "${x}{p}" Targets.txt > Target_0$x.txt
	sed -n "${x}{p}" Sequences.txt > pMHC_0$x.seq
    paste -d '\0' Symbol.txt Target_0$x.txt > pMHC_0$x.id
    epname=$(more Target_0$x.txt) 
	cat pMHC_0$x.id pMHC_0$x.seq > $epname.fasta
	rm pMHC_0$x.id pMHC_0$x.seq Target_0$x.txt
done
#
for ((y=10; y <= $rows; y++));do
	sed -n "${y}{p}" Targets.txt > Target_$y.txt
	sed -n "${y}{p}" Sequences.txt > pMHC_$y.seq
    paste -d '\0' Symbol.txt Target_$y.txt > pMHC_$y.id
    epname=$(more Target_$y.txt) 
	cat pMHC_$y.id pMHC_$y.seq > $epname.fasta
	rm pMHC_$y.id pMHC_$y.seq Target_$y.txt
done
#
rm Symbol.txt Sequences.txt Targets.txt Table.csv
#cat *.fasta > Report_FASTAs.txt
#
echo -e "\nAll tasks concluded."
total=$(ls -1 *.fasta | wc -l)
echo -e "\nListing all $total generated FASTA files:"
ls -cr -w 75 *.fasta
echo -e "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NBLI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
#Exchange file extension (prevents p_mD1EMD2 of calling this script again).
fname=${inputfile%.*};
mv $inputfile $fname.xls

