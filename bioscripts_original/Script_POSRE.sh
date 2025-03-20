#v6.0
#!/bin/bash
## Script para fazer os arquivos de position restraint com diferentes forças
##Antes de executar este script, deve ser executada a linha 'pdb2gmx' do gromacs para gerar os arquivos de entrada

#Preparar pasta para armazenar os arquivos:
mkdir posre-files/

## Se o programa receber 5 argumentos (5 cadeias)

if [ $# -eq 5 ]; then
mv posre_Protein_chain_$1.itp posre_Protein_chain_$2.itp posre_Protein_chain_$3.itp posre_Protein_chain_$4.itp posre_Protein_chain_$5.itp posre-files/
cd posre-files/
mv posre_Protein_chain_$1.itp posre_Protein_chain_$1_1000.itp  
mv posre_Protein_chain_$2.itp posre_Protein_chain_$2_1000.itp 
mv posre_Protein_chain_$3.itp posre_Protein_chain_$3_1000.itp
mv posre_Protein_chain_$4.itp posre_Protein_chain_$4_1000.itp 
mv posre_Protein_chain_$5.itp posre_Protein_chain_$5_1000.itp  

#Deletar todas linhas que começam com ";"
sed '/\;/d' posre_Protein_chain_$1_1000.itp > posre_Protein_chain_A_1000-del-ptvirg.itp
sed '/\;/d' posre_Protein_chain_$2_1000.itp > posre_Protein_chain_B_1000-del-ptvirg.itp
sed '/\;/d' posre_Protein_chain_$3_1000.itp > posre_Protein_chain_C_1000-del-ptvirg.itp
sed '/\;/d' posre_Protein_chain_$4_1000.itp > posre_Protein_chain_D_1000-del-ptvirg.itp
sed '/\;/d' posre_Protein_chain_$5_1000.itp > posre_Protein_chain_E_1000-del-ptvirg.itp

# Separar a linha "[ position restraint ]" do resto do arquivo. Salvar ela em um novo arquivo e o resto em outro
awk '/^\[/ {print $1,"",$2,"", $3}' posre_Protein_chain_A_1000-del-ptvirg.itp > first_line
sed -e '1,2d' posre_Protein_chain_A_1000-del-ptvirg.itp > posre_Protein_chain_A_1000-wout-first-line.itp
sed -e '1,2d' posre_Protein_chain_B_1000-del-ptvirg.itp > posre_Protein_chain_B_1000-wout-first-line.itp
sed -e '1,2d' posre_Protein_chain_C_1000-del-ptvirg.itp > posre_Protein_chain_C_1000-wout-first-line.itp
sed -e '1,2d' posre_Protein_chain_D_1000-del-ptvirg.itp > posre_Protein_chain_D_1000-wout-first-line.itp
sed -e '1,2d' posre_Protein_chain_E_1000-del-ptvirg.itp > posre_Protein_chain_E_1000-wout-first-line.itp

# Começar a troca de valores das colunas relativas às forças
  
  # Apenas colunas 1 e 2
  awk '{print $1,"",$2}' posre_Protein_chain_A_1000-wout-first-line.itp > posre_Protein_chain_A_1000-colunas-1e2.itp
  awk '{print $1,"",$2}' posre_Protein_chain_B_1000-wout-first-line.itp > posre_Protein_chain_B_1000-colunas-1e2.itp
  awk '{print $1,"",$2}' posre_Protein_chain_C_1000-wout-first-line.itp > posre_Protein_chain_C_1000-colunas-1e2.itp
  awk '{print $1,"",$2}' posre_Protein_chain_D_1000-wout-first-line.itp > posre_Protein_chain_D_1000-colunas-1e2.itp
  awk '{print $1,"",$2}' posre_Protein_chain_E_1000-wout-first-line.itp > posre_Protein_chain_E_1000-colunas-1e2.itp
  
  # Apenas colunas das forças
  awk '{print $3,"",$4,"",$5}' posre_Protein_chain_A_1000-wout-first-line.itp > colunas_1000A
  awk '{print $3,"",$4,"",$5}' posre_Protein_chain_B_1000-wout-first-line.itp > colunas_1000B  
  awk '{print $3,"",$4,"",$5}' posre_Protein_chain_C_1000-wout-first-line.itp > colunas_1000C
  awk '{print $3,"",$4,"",$5}' posre_Protein_chain_D_1000-wout-first-line.itp > colunas_1000D
  awk '{print $3,"",$4,"",$5}' posre_Protein_chain_E_1000-wout-first-line.itp > colunas_1000E

  # Troca dos valores das forças
  sed "s/1000/5000/g" colunas_1000A > colunas_5000A
  sed "s/1000/5000/g" colunas_1000B > colunas_5000B
  sed "s/1000/5000/g" colunas_1000C > colunas_5000C
  sed "s/1000/5000/g" colunas_1000D > colunas_5000D
  sed "s/1000/5000/g" colunas_1000E > colunas_5000E

  sed "s/1000/500/g" colunas_1000A > colunas_500A
  sed "s/1000/500/g" colunas_1000B > colunas_500B
  sed "s/1000/500/g" colunas_1000C > colunas_500C
  sed "s/1000/500/g" colunas_1000D > colunas_500D
  sed "s/1000/500/g" colunas_1000E > colunas_500E

  sed "s/1000/250/g" colunas_1000A > colunas_250A
  sed "s/1000/250/g" colunas_1000B > colunas_250B
  sed "s/1000/250/g" colunas_1000C > colunas_250C
  sed "s/1000/250/g" colunas_1000D > colunas_250D
  sed "s/1000/250/g" colunas_1000E > colunas_250E

  sed "s/1000/100/g" colunas_1000A > colunas_100A
  sed "s/1000/100/g" colunas_1000B > colunas_100B
  sed "s/1000/100/g" colunas_1000C > colunas_100C
  sed "s/1000/100/g" colunas_1000D > colunas_100D
  sed "s/1000/100/g" colunas_1000E > colunas_100E

  sed "s/1000/10/g" colunas_1000A > colunas_10A
  sed "s/1000/10/g" colunas_1000B > colunas_10B
  sed "s/1000/10/g" colunas_1000C > colunas_10C
  sed "s/1000/10/g" colunas_1000D > colunas_10D
  sed "s/1000/10/g" colunas_1000E > colunas_10E

  sed "s/1000/5/g" colunas_1000A > colunas_5A
  sed "s/1000/5/g" colunas_1000B > colunas_5B
  sed "s/1000/5/g" colunas_1000C > colunas_5C
  sed "s/1000/5/g" colunas_1000D > colunas_5D
  sed "s/1000/5/g" colunas_1000E > colunas_5E

  sed "s/1000/3/g" colunas_1000A > colunas_3A
  sed "s/1000/3/g" colunas_1000B > colunas_3B
  sed "s/1000/3/g" colunas_1000C > colunas_3C
  sed "s/1000/3/g" colunas_1000D > colunas_3D
  sed "s/1000/3/g" colunas_1000E > colunas_3E

  sed "s/1000/2/g" colunas_1000A > colunas_2A
  sed "s/1000/2/g" colunas_1000B > colunas_2B
  sed "s/1000/2/g" colunas_1000C > colunas_2C
  sed "s/1000/2/g" colunas_1000D > colunas_2D
  sed "s/1000/2/g" colunas_1000E > colunas_2E

  sed "s/1000/1/g" colunas_1000A > colunas_1A
  sed "s/1000/1/g" colunas_1000B > colunas_1B
  sed "s/1000/1/g" colunas_1000C > colunas_1C
  sed "s/1000/1/g" colunas_1000D > colunas_1D
  sed "s/1000/1/g" colunas_1000E > colunas_1E

  sed "s/1000/0.5/g" colunas_1000A > colunas_0_5A
  sed "s/1000/0.5/g" colunas_1000B > colunas_0_5B
  sed "s/1000/0.5/g" colunas_1000C > colunas_0_5C
  sed "s/1000/0.5/g" colunas_1000D > colunas_0_5D
  sed "s/1000/0.5/g" colunas_1000E > colunas_0_5E

  sed "s/1000/0.2/g" colunas_1000A > colunas_0_2A
  sed "s/1000/0.2/g" colunas_1000B > colunas_0_2B
  sed "s/1000/0.2/g" colunas_1000C > colunas_0_2C
  sed "s/1000/0.2/g" colunas_1000D > colunas_0_2D
  sed "s/1000/0.2/g" colunas_1000E > colunas_0_2E

# Unir "first line" + "colunas com novas forças" + "colunas 1 e 2"
  
  #F = 5000
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_5000A > posre_Protein_chain_A_5000-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_5000-wout-header > posre_Protein_chain_A_5000-blank-first-line
  paste first_line posre_Protein_chain_A_5000-blank-first-line > posre_Protein_chain_$1_5000.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_5000B > posre_Protein_chain_B_5000-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_5000-wout-header > posre_Protein_chain_B_5000-blank-first-line
  paste first_line posre_Protein_chain_B_5000-blank-first-line > posre_Protein_chain_$2_5000.itp

  paste posre_Protein_chain_C_1000-colunas-1e2.itp colunas_5000C > posre_Protein_chain_C_5000-wout-header
  sed "1s/^/\n/" posre_Protein_chain_C_5000-wout-header > posre_Protein_chain_C_5000-blank-first-line
  paste first_line posre_Protein_chain_C_5000-blank-first-line > posre_Protein_chain_$3_5000.itp

  paste posre_Protein_chain_D_1000-colunas-1e2.itp colunas_5000D > posre_Protein_chain_D_5000-wout-header
  sed "1s/^/\n/" posre_Protein_chain_D_5000-wout-header > posre_Protein_chain_D_5000-blank-first-line
  paste first_line posre_Protein_chain_D_5000-blank-first-line > posre_Protein_chain_$4_5000.itp

  paste posre_Protein_chain_E_1000-colunas-1e2.itp colunas_5000E > posre_Protein_chain_E_5000-wout-header
  sed "1s/^/\n/" posre_Protein_chain_E_5000-wout-header > posre_Protein_chain_E_5000-blank-first-line
  paste first_line posre_Protein_chain_E_5000-blank-first-line > posre_Protein_chain_$5_5000.itp


  #F = 500
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_500A > posre_Protein_chain_A_500-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_500-wout-header > posre_Protein_chain_A_500-blank-first-line
  paste first_line posre_Protein_chain_A_500-blank-first-line > posre_Protein_chain_$1_500.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_500B > posre_Protein_chain_B_500-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_500-wout-header > posre_Protein_chain_B_500-blank-first-line
  paste first_line posre_Protein_chain_B_500-blank-first-line > posre_Protein_chain_$2_500.itp
  
  paste posre_Protein_chain_C_1000-colunas-1e2.itp colunas_500C > posre_Protein_chain_C_500-wout-header
  sed "1s/^/\n/" posre_Protein_chain_C_500-wout-header > posre_Protein_chain_C_500-blank-first-line
  paste first_line posre_Protein_chain_C_500-blank-first-line > posre_Protein_chain_$3_500.itp

  paste posre_Protein_chain_D_1000-colunas-1e2.itp colunas_500D > posre_Protein_chain_D_500-wout-header
  sed "1s/^/\n/" posre_Protein_chain_D_500-wout-header > posre_Protein_chain_D_500-blank-first-line
  paste first_line posre_Protein_chain_D_500-blank-first-line > posre_Protein_chain_$4_500.itp

  paste posre_Protein_chain_E_1000-colunas-1e2.itp colunas_500E > posre_Protein_chain_E_500-wout-header
  sed "1s/^/\n/" posre_Protein_chain_E_500-wout-header > posre_Protein_chain_E_500-blank-first-line
  paste first_line posre_Protein_chain_E_500-blank-first-line > posre_Protein_chain_$5_500.itp

  #F = 250
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_250A > posre_Protein_chain_A_250-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_250-wout-header > posre_Protein_chain_A_250-blank-first-line
  paste first_line posre_Protein_chain_A_250-blank-first-line > posre_Protein_chain_$1_250.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_250B > posre_Protein_chain_B_250-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_250-wout-header > posre_Protein_chain_B_250-blank-first-line
  paste first_line posre_Protein_chain_B_250-blank-first-line > posre_Protein_chain_$2_250.itp

  paste posre_Protein_chain_C_1000-colunas-1e2.itp colunas_250C > posre_Protein_chain_C_250-wout-header
  sed "1s/^/\n/" posre_Protein_chain_C_250-wout-header > posre_Protein_chain_C_250-blank-first-line
  paste first_line posre_Protein_chain_C_250-blank-first-line > posre_Protein_chain_$3_250.itp

  paste posre_Protein_chain_D_1000-colunas-1e2.itp colunas_250D > posre_Protein_chain_D_250-wout-header
  sed "1s/^/\n/" posre_Protein_chain_D_250-wout-header > posre_Protein_chain_D_250-blank-first-line
  paste first_line posre_Protein_chain_D_250-blank-first-line > posre_Protein_chain_$4_250.itp

  paste posre_Protein_chain_E_1000-colunas-1e2.itp colunas_250E > posre_Protein_chain_E_250-wout-header
  sed "1s/^/\n/" posre_Protein_chain_E_250-wout-header > posre_Protein_chain_E_250-blank-first-line
  paste first_line posre_Protein_chain_E_250-blank-first-line > posre_Protein_chain_$5_250.itp


  #F = 100
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_100A > posre_Protein_chain_A_100-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_100-wout-header > posre_Protein_chain_A_100-blank-first-line
  paste first_line posre_Protein_chain_A_100-blank-first-line > posre_Protein_chain_$1_100.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_100B > posre_Protein_chain_B_100-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_100-wout-header > posre_Protein_chain_B_100-blank-first-line
  paste first_line posre_Protein_chain_B_100-blank-first-line > posre_Protein_chain_$2_100.itp

  paste posre_Protein_chain_C_1000-colunas-1e2.itp colunas_100C > posre_Protein_chain_C_100-wout-header
  sed "1s/^/\n/" posre_Protein_chain_C_100-wout-header > posre_Protein_chain_C_100-blank-first-line
  paste first_line posre_Protein_chain_C_100-blank-first-line > posre_Protein_chain_$3_100.itp

  paste posre_Protein_chain_D_1000-colunas-1e2.itp colunas_100D > posre_Protein_chain_D_100-wout-header
  sed "1s/^/\n/" posre_Protein_chain_D_100-wout-header > posre_Protein_chain_D_100-blank-first-line
  paste first_line posre_Protein_chain_D_100-blank-first-line > posre_Protein_chain_$4_100.itp

  paste posre_Protein_chain_E_1000-colunas-1e2.itp colunas_100E > posre_Protein_chain_E_100-wout-header
  sed "1s/^/\n/" posre_Protein_chain_E_100-wout-header > posre_Protein_chain_E_100-blank-first-line
  paste first_line posre_Protein_chain_E_100-blank-first-line > posre_Protein_chain_$5_100.itp


  #F = 10
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_10A > posre_Protein_chain_A_10-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_10-wout-header > posre_Protein_chain_A_10-blank-first-line
  paste first_line posre_Protein_chain_A_10-blank-first-line > posre_Protein_chain_$1_10.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_10B > posre_Protein_chain_B_10-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_10-wout-header > posre_Protein_chain_B_10-blank-first-line
  paste first_line posre_Protein_chain_B_10-blank-first-line > posre_Protein_chain_$2_10.itp

  paste posre_Protein_chain_C_1000-colunas-1e2.itp colunas_10C > posre_Protein_chain_C_10-wout-header
  sed "1s/^/\n/" posre_Protein_chain_C_10-wout-header > posre_Protein_chain_C_10-blank-first-line
  paste first_line posre_Protein_chain_C_10-blank-first-line > posre_Protein_chain_$3_10.itp

  paste posre_Protein_chain_D_1000-colunas-1e2.itp colunas_10D > posre_Protein_chain_D_10-wout-header
  sed "1s/^/\n/" posre_Protein_chain_D_10-wout-header > posre_Protein_chain_D_10-blank-first-line
  paste first_line posre_Protein_chain_D_10-blank-first-line > posre_Protein_chain_$4_10.itp

  paste posre_Protein_chain_E_1000-colunas-1e2.itp colunas_10E > posre_Protein_chain_E_10-wout-header
  sed "1s/^/\n/" posre_Protein_chain_E_10-wout-header > posre_Protein_chain_E_10-blank-first-line
  paste first_line posre_Protein_chain_E_10-blank-first-line > posre_Protein_chain_$5_10.itp


  #F = 5
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_5A > posre_Protein_chain_A_5-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_5-wout-header > posre_Protein_chain_A_5-blank-first-line
  paste first_line posre_Protein_chain_A_5-blank-first-line > posre_Protein_chain_$1_5.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_5B > posre_Protein_chain_B_5-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_5-wout-header > posre_Protein_chain_B_5-blank-first-line
  paste first_line posre_Protein_chain_B_5-blank-first-line > posre_Protein_chain_$2_5.itp

  paste posre_Protein_chain_C_1000-colunas-1e2.itp colunas_5C > posre_Protein_chain_C_5-wout-header
  sed "1s/^/\n/" posre_Protein_chain_C_5-wout-header > posre_Protein_chain_C_5-blank-first-line
  paste first_line posre_Protein_chain_C_5-blank-first-line > posre_Protein_chain_$3_5.itp

  paste posre_Protein_chain_D_1000-colunas-1e2.itp colunas_5D > posre_Protein_chain_D_5-wout-header
  sed "1s/^/\n/" posre_Protein_chain_D_5-wout-header > posre_Protein_chain_D_5-blank-first-line
  paste first_line posre_Protein_chain_D_5-blank-first-line > posre_Protein_chain_$4_5.itp

  paste posre_Protein_chain_E_1000-colunas-1e2.itp colunas_5E > posre_Protein_chain_E_5-wout-header
  sed "1s/^/\n/" posre_Protein_chain_E_5-wout-header > posre_Protein_chain_E_5-blank-first-line
  paste first_line posre_Protein_chain_E_5-blank-first-line > posre_Protein_chain_$5_5.itp


  #F = 3
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_3A > posre_Protein_chain_A_3-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_3-wout-header > posre_Protein_chain_A_3-blank-first-line
  paste first_line posre_Protein_chain_A_3-blank-first-line > posre_Protein_chain_$1_3.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_3B > posre_Protein_chain_B_3-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_3-wout-header > posre_Protein_chain_B_3-blank-first-line
  paste first_line posre_Protein_chain_B_3-blank-first-line > posre_Protein_chain_$2_3.itp

  paste posre_Protein_chain_C_1000-colunas-1e2.itp colunas_3C > posre_Protein_chain_C_3-wout-header
  sed "1s/^/\n/" posre_Protein_chain_C_3-wout-header > posre_Protein_chain_C_3-blank-first-line
  paste first_line posre_Protein_chain_C_3-blank-first-line > posre_Protein_chain_$3_3.itp

  paste posre_Protein_chain_D_1000-colunas-1e2.itp colunas_3D > posre_Protein_chain_D_3-wout-header
  sed "1s/^/\n/" posre_Protein_chain_D_3-wout-header > posre_Protein_chain_D_3-blank-first-line
  paste first_line posre_Protein_chain_D_3-blank-first-line > posre_Protein_chain_$4_3.itp

  paste posre_Protein_chain_E_1000-colunas-1e2.itp colunas_3E > posre_Protein_chain_E_3-wout-header
  sed "1s/^/\n/" posre_Protein_chain_E_3-wout-header > posre_Protein_chain_E_3-blank-first-line
  paste first_line posre_Protein_chain_E_3-blank-first-line > posre_Protein_chain_$5_3.itp

  #F = 2
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_2A > posre_Protein_chain_A_2-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_2-wout-header > posre_Protein_chain_A_2-blank-first-line
  paste first_line posre_Protein_chain_A_2-blank-first-line > posre_Protein_chain_$1_2.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_2B > posre_Protein_chain_B_2-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_2-wout-header > posre_Protein_chain_B_2-blank-first-line
  paste first_line posre_Protein_chain_B_2-blank-first-line > posre_Protein_chain_$2_2.itp

  paste posre_Protein_chain_C_1000-colunas-1e2.itp colunas_2C > posre_Protein_chain_C_2-wout-header
  sed "1s/^/\n/" posre_Protein_chain_C_2-wout-header > posre_Protein_chain_C_2-blank-first-line
  paste first_line posre_Protein_chain_C_2-blank-first-line > posre_Protein_chain_$3_2.itp

  paste posre_Protein_chain_D_1000-colunas-1e2.itp colunas_2D > posre_Protein_chain_D_2-wout-header
  sed "1s/^/\n/" posre_Protein_chain_D_2-wout-header > posre_Protein_chain_D_2-blank-first-line
  paste first_line posre_Protein_chain_D_2-blank-first-line > posre_Protein_chain_$4_2.itp

  paste posre_Protein_chain_E_1000-colunas-1e2.itp colunas_2E > posre_Protein_chain_E_2-wout-header
  sed "1s/^/\n/" posre_Protein_chain_E_2-wout-header > posre_Protein_chain_E_2-blank-first-line
  paste first_line posre_Protein_chain_E_2-blank-first-line > posre_Protein_chain_$5_2.itp

  #F = 1
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_1A > posre_Protein_chain_A_1-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_1-wout-header > posre_Protein_chain_A_1-blank-first-line
  paste first_line posre_Protein_chain_A_1-blank-first-line > posre_Protein_chain_$1_1.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_1B > posre_Protein_chain_B_1-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_1-wout-header > posre_Protein_chain_B_1-blank-first-line
  paste first_line posre_Protein_chain_B_1-blank-first-line > posre_Protein_chain_$2_1.itp

  paste posre_Protein_chain_C_1000-colunas-1e2.itp colunas_1C > posre_Protein_chain_C_1-wout-header
  sed "1s/^/\n/" posre_Protein_chain_C_1-wout-header > posre_Protein_chain_C_1-blank-first-line
  paste first_line posre_Protein_chain_C_1-blank-first-line > posre_Protein_chain_$3_1.itp

  paste posre_Protein_chain_D_1000-colunas-1e2.itp colunas_1D > posre_Protein_chain_D_1-wout-header
  sed "1s/^/\n/" posre_Protein_chain_D_1-wout-header > posre_Protein_chain_D_1-blank-first-line
  paste first_line posre_Protein_chain_D_1-blank-first-line > posre_Protein_chain_$4_1.itp

  paste posre_Protein_chain_E_1000-colunas-1e2.itp colunas_1E > posre_Protein_chain_E_1-wout-header
  sed "1s/^/\n/" posre_Protein_chain_E_1-wout-header > posre_Protein_chain_E_1-blank-first-line
  paste first_line posre_Protein_chain_E_1-blank-first-line > posre_Protein_chain_$5_1.itp

  #F = 0.5
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_0_5A > posre_Protein_chain_A_0_5-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_0_5-wout-header > posre_Protein_chain_A_0_5-blank-first-line
  paste first_line posre_Protein_chain_A_0_5-blank-first-line > posre_Protein_chain_$1_0_5.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_0_5B > posre_Protein_chain_B_0_5-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_0_5-wout-header > posre_Protein_chain_B_0_5-blank-first-line
  paste first_line posre_Protein_chain_B_0_5-blank-first-line > posre_Protein_chain_$2_0_5.itp

  paste posre_Protein_chain_C_1000-colunas-1e2.itp colunas_0_5C > posre_Protein_chain_C_0_5-wout-header
  sed "1s/^/\n/" posre_Protein_chain_C_0_5-wout-header > posre_Protein_chain_C_0_5-blank-first-line
  paste first_line posre_Protein_chain_C_0_5-blank-first-line > posre_Protein_chain_$3_0_5.itp

  paste posre_Protein_chain_D_1000-colunas-1e2.itp colunas_0_5D > posre_Protein_chain_D_0_5-wout-header
  sed "1s/^/\n/" posre_Protein_chain_D_0_5-wout-header > posre_Protein_chain_D_0_5-blank-first-line
  paste first_line posre_Protein_chain_D_0_5-blank-first-line > posre_Protein_chain_$4_0_5.itp

  paste posre_Protein_chain_E_1000-colunas-1e2.itp colunas_0_5E > posre_Protein_chain_E_0_5-wout-header
  sed "1s/^/\n/" posre_Protein_chain_E_0_5-wout-header > posre_Protein_chain_E_0_5-blank-first-line
  paste first_line posre_Protein_chain_E_0_5-blank-first-line > posre_Protein_chain_$5_0_5.itp

  #F = 0.2
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_0_2A > posre_Protein_chain_A_0_2-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_0_2-wout-header > posre_Protein_chain_A_0_2-blank-first-line
  paste first_line posre_Protein_chain_A_0_2-blank-first-line > posre_Protein_chain_$1_0_2.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_0_2B > posre_Protein_chain_B_0_2-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_0_2-wout-header > posre_Protein_chain_B_0_2-blank-first-line
  paste first_line posre_Protein_chain_B_0_2-blank-first-line > posre_Protein_chain_$2_0_2.itp

  paste posre_Protein_chain_C_1000-colunas-1e2.itp colunas_0_2C > posre_Protein_chain_C_0_2-wout-header
  sed "1s/^/\n/" posre_Protein_chain_C_0_2-wout-header > posre_Protein_chain_C_0_2-blank-first-line
  paste first_line posre_Protein_chain_C_0_2-blank-first-line > posre_Protein_chain_$3_0_2.itp

  paste posre_Protein_chain_D_1000-colunas-1e2.itp colunas_0_2D > posre_Protein_chain_D_0_2-wout-header
  sed "1s/^/\n/" posre_Protein_chain_D_0_2-wout-header > posre_Protein_chain_D_0_2-blank-first-line
  paste first_line posre_Protein_chain_D_0_2-blank-first-line > posre_Protein_chain_$4_0_2.itp

  paste posre_Protein_chain_E_1000-colunas-1e2.itp colunas_0_2E > posre_Protein_chain_E_0_2-wout-header
  sed "1s/^/\n/" posre_Protein_chain_E_0_2-wout-header > posre_Protein_chain_E_0_2-blank-first-line
  paste first_line posre_Protein_chain_E_0_2-blank-first-line > posre_Protein_chain_$5_0_2.itp

fi

## Se o programa receber 4 argumentos (4 cadeias)

if [ $# -eq 4 ]; then
mv posre_Protein_chain_$1.itp posre_Protein_chain_$2.itp posre_Protein_chain_$3.itp posre_Protein_chain_$4.itp posre-files/
cd posre-files/
mv posre_Protein_chain_$1.itp posre_Protein_chain_$1_1000.itp  
mv posre_Protein_chain_$2.itp posre_Protein_chain_$2_1000.itp 
mv posre_Protein_chain_$3.itp posre_Protein_chain_$3_1000.itp
mv posre_Protein_chain_$4.itp posre_Protein_chain_$4_1000.itp 


#Deletar todas linhas que começam com ";"
sed '/\;/d' posre_Protein_chain_$1_1000.itp > posre_Protein_chain_A_1000-del-ptvirg.itp
sed '/\;/d' posre_Protein_chain_$2_1000.itp > posre_Protein_chain_B_1000-del-ptvirg.itp
sed '/\;/d' posre_Protein_chain_$3_1000.itp > posre_Protein_chain_C_1000-del-ptvirg.itp
sed '/\;/d' posre_Protein_chain_$4_1000.itp > posre_Protein_chain_D_1000-del-ptvirg.itp


# Separar a linha "[ position restraint ]" do resto do arquivo. Salvar ela em um novo arquivo e o resto em outro
awk '/^\[/ {print $1,"",$2,"", $3}' posre_Protein_chain_A_1000-del-ptvirg.itp > first_line
sed -e '1,2d' posre_Protein_chain_A_1000-del-ptvirg.itp > posre_Protein_chain_A_1000-wout-first-line.itp
sed -e '1,2d' posre_Protein_chain_B_1000-del-ptvirg.itp > posre_Protein_chain_B_1000-wout-first-line.itp
sed -e '1,2d' posre_Protein_chain_C_1000-del-ptvirg.itp > posre_Protein_chain_C_1000-wout-first-line.itp
sed -e '1,2d' posre_Protein_chain_D_1000-del-ptvirg.itp > posre_Protein_chain_D_1000-wout-first-line.itp


# Começar a troca de valores das colunas relativas às forças
  
  # Apenas colunas 1 e 2
  awk '{print $1,"",$2}' posre_Protein_chain_A_1000-wout-first-line.itp > posre_Protein_chain_A_1000-colunas-1e2.itp
  awk '{print $1,"",$2}' posre_Protein_chain_B_1000-wout-first-line.itp > posre_Protein_chain_B_1000-colunas-1e2.itp
  awk '{print $1,"",$2}' posre_Protein_chain_C_1000-wout-first-line.itp > posre_Protein_chain_C_1000-colunas-1e2.itp
  awk '{print $1,"",$2}' posre_Protein_chain_D_1000-wout-first-line.itp > posre_Protein_chain_D_1000-colunas-1e2.itp

  
  # Apenas colunas das forças
  awk '{print $3,"",$4,"",$5}' posre_Protein_chain_A_1000-wout-first-line.itp > colunas_1000A
  awk '{print $3,"",$4,"",$5}' posre_Protein_chain_B_1000-wout-first-line.itp > colunas_1000B  
  awk '{print $3,"",$4,"",$5}' posre_Protein_chain_C_1000-wout-first-line.itp > colunas_1000C
  awk '{print $3,"",$4,"",$5}' posre_Protein_chain_D_1000-wout-first-line.itp > colunas_1000D


  # Troca dos valores das forças
  sed "s/1000/5000/g" colunas_1000A > colunas_5000A
  sed "s/1000/5000/g" colunas_1000B > colunas_5000B
  sed "s/1000/5000/g" colunas_1000C > colunas_5000C
  sed "s/1000/5000/g" colunas_1000D > colunas_5000D


  sed "s/1000/500/g" colunas_1000A > colunas_500A
  sed "s/1000/500/g" colunas_1000B > colunas_500B
  sed "s/1000/500/g" colunas_1000C > colunas_500C
  sed "s/1000/500/g" colunas_1000D > colunas_500D


  sed "s/1000/250/g" colunas_1000A > colunas_250A
  sed "s/1000/250/g" colunas_1000B > colunas_250B
  sed "s/1000/250/g" colunas_1000C > colunas_250C
  sed "s/1000/250/g" colunas_1000D > colunas_250D


  sed "s/1000/100/g" colunas_1000A > colunas_100A
  sed "s/1000/100/g" colunas_1000B > colunas_100B
  sed "s/1000/100/g" colunas_1000C > colunas_100C
  sed "s/1000/100/g" colunas_1000D > colunas_100D


  sed "s/1000/10/g" colunas_1000A > colunas_10A
  sed "s/1000/10/g" colunas_1000B > colunas_10B
  sed "s/1000/10/g" colunas_1000C > colunas_10C
  sed "s/1000/10/g" colunas_1000D > colunas_10D


  sed "s/1000/5/g" colunas_1000A > colunas_5A
  sed "s/1000/5/g" colunas_1000B > colunas_5B
  sed "s/1000/5/g" colunas_1000C > colunas_5C
  sed "s/1000/5/g" colunas_1000D > colunas_5D


  sed "s/1000/3/g" colunas_1000A > colunas_3A
  sed "s/1000/3/g" colunas_1000B > colunas_3B
  sed "s/1000/3/g" colunas_1000C > colunas_3C
  sed "s/1000/3/g" colunas_1000D > colunas_3D


  sed "s/1000/2/g" colunas_1000A > colunas_2A
  sed "s/1000/2/g" colunas_1000B > colunas_2B
  sed "s/1000/2/g" colunas_1000C > colunas_2C
  sed "s/1000/2/g" colunas_1000D > colunas_2D


  sed "s/1000/1/g" colunas_1000A > colunas_1A
  sed "s/1000/1/g" colunas_1000B > colunas_1B
  sed "s/1000/1/g" colunas_1000C > colunas_1C
  sed "s/1000/1/g" colunas_1000D > colunas_1D


  sed "s/1000/0.5/g" colunas_1000A > colunas_0_5A
  sed "s/1000/0.5/g" colunas_1000B > colunas_0_5B
  sed "s/1000/0.5/g" colunas_1000C > colunas_0_5C
  sed "s/1000/0.5/g" colunas_1000D > colunas_0_5D


  sed "s/1000/0.2/g" colunas_1000A > colunas_0_2A
  sed "s/1000/0.2/g" colunas_1000B > colunas_0_2B
  sed "s/1000/0.2/g" colunas_1000C > colunas_0_2C
  sed "s/1000/0.2/g" colunas_1000D > colunas_0_2D


# Unir "first line" + "colunas com novas forças" + "colunas 1 e 2"
  
  #F = 5000
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_5000A > posre_Protein_chain_A_5000-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_5000-wout-header > posre_Protein_chain_A_5000-blank-first-line
  paste first_line posre_Protein_chain_A_5000-blank-first-line > posre_Protein_chain_$1_5000.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_5000B > posre_Protein_chain_B_5000-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_5000-wout-header > posre_Protein_chain_B_5000-blank-first-line
  paste first_line posre_Protein_chain_B_5000-blank-first-line > posre_Protein_chain_$2_5000.itp

  paste posre_Protein_chain_C_1000-colunas-1e2.itp colunas_5000C > posre_Protein_chain_C_5000-wout-header
  sed "1s/^/\n/" posre_Protein_chain_C_5000-wout-header > posre_Protein_chain_C_5000-blank-first-line
  paste first_line posre_Protein_chain_C_5000-blank-first-line > posre_Protein_chain_$3_5000.itp

  paste posre_Protein_chain_D_1000-colunas-1e2.itp colunas_5000D > posre_Protein_chain_D_5000-wout-header
  sed "1s/^/\n/" posre_Protein_chain_D_5000-wout-header > posre_Protein_chain_D_5000-blank-first-line
  paste first_line posre_Protein_chain_D_5000-blank-first-line > posre_Protein_chain_$4_5000.itp

  
  #F = 500
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_500A > posre_Protein_chain_A_500-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_500-wout-header > posre_Protein_chain_A_500-blank-first-line
  paste first_line posre_Protein_chain_A_500-blank-first-line > posre_Protein_chain_$1_500.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_500B > posre_Protein_chain_B_500-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_500-wout-header > posre_Protein_chain_B_500-blank-first-line
  paste first_line posre_Protein_chain_B_500-blank-first-line > posre_Protein_chain_$2_500.itp
  
  paste posre_Protein_chain_C_1000-colunas-1e2.itp colunas_500C > posre_Protein_chain_C_500-wout-header
  sed "1s/^/\n/" posre_Protein_chain_C_500-wout-header > posre_Protein_chain_C_500-blank-first-line
  paste first_line posre_Protein_chain_C_500-blank-first-line > posre_Protein_chain_$3_500.itp

  paste posre_Protein_chain_D_1000-colunas-1e2.itp colunas_500D > posre_Protein_chain_D_500-wout-header
  sed "1s/^/\n/" posre_Protein_chain_D_500-wout-header > posre_Protein_chain_D_500-blank-first-line
  paste first_line posre_Protein_chain_D_500-blank-first-line > posre_Protein_chain_$4_500.itp

  #F = 250
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_250A > posre_Protein_chain_A_250-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_250-wout-header > posre_Protein_chain_A_250-blank-first-line
  paste first_line posre_Protein_chain_A_250-blank-first-line > posre_Protein_chain_$1_250.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_250B > posre_Protein_chain_B_250-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_250-wout-header > posre_Protein_chain_B_250-blank-first-line
  paste first_line posre_Protein_chain_B_250-blank-first-line > posre_Protein_chain_$2_250.itp

  paste posre_Protein_chain_C_1000-colunas-1e2.itp colunas_250C > posre_Protein_chain_C_250-wout-header
  sed "1s/^/\n/" posre_Protein_chain_C_250-wout-header > posre_Protein_chain_C_250-blank-first-line
  paste first_line posre_Protein_chain_C_250-blank-first-line > posre_Protein_chain_$3_250.itp

  paste posre_Protein_chain_D_1000-colunas-1e2.itp colunas_250D > posre_Protein_chain_D_250-wout-header
  sed "1s/^/\n/" posre_Protein_chain_D_250-wout-header > posre_Protein_chain_D_250-blank-first-line
  paste first_line posre_Protein_chain_D_250-blank-first-line > posre_Protein_chain_$4_250.itp


  #F = 100
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_100A > posre_Protein_chain_A_100-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_100-wout-header > posre_Protein_chain_A_100-blank-first-line
  paste first_line posre_Protein_chain_A_100-blank-first-line > posre_Protein_chain_$1_100.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_100B > posre_Protein_chain_B_100-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_100-wout-header > posre_Protein_chain_B_100-blank-first-line
  paste first_line posre_Protein_chain_B_100-blank-first-line > posre_Protein_chain_$2_100.itp

  paste posre_Protein_chain_C_1000-colunas-1e2.itp colunas_100C > posre_Protein_chain_C_100-wout-header
  sed "1s/^/\n/" posre_Protein_chain_C_100-wout-header > posre_Protein_chain_C_100-blank-first-line
  paste first_line posre_Protein_chain_C_100-blank-first-line > posre_Protein_chain_$3_100.itp

  paste posre_Protein_chain_D_1000-colunas-1e2.itp colunas_100D > posre_Protein_chain_D_100-wout-header
  sed "1s/^/\n/" posre_Protein_chain_D_100-wout-header > posre_Protein_chain_D_100-blank-first-line
  paste first_line posre_Protein_chain_D_100-blank-first-line > posre_Protein_chain_$4_100.itp

  #F = 10
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_10A > posre_Protein_chain_A_10-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_10-wout-header > posre_Protein_chain_A_10-blank-first-line
  paste first_line posre_Protein_chain_A_10-blank-first-line > posre_Protein_chain_$1_10.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_10B > posre_Protein_chain_B_10-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_10-wout-header > posre_Protein_chain_B_10-blank-first-line
  paste first_line posre_Protein_chain_B_10-blank-first-line > posre_Protein_chain_$2_10.itp

  paste posre_Protein_chain_C_1000-colunas-1e2.itp colunas_10C > posre_Protein_chain_C_10-wout-header
  sed "1s/^/\n/" posre_Protein_chain_C_10-wout-header > posre_Protein_chain_C_10-blank-first-line
  paste first_line posre_Protein_chain_C_10-blank-first-line > posre_Protein_chain_$3_10.itp

  paste posre_Protein_chain_D_1000-colunas-1e2.itp colunas_10D > posre_Protein_chain_D_10-wout-header
  sed "1s/^/\n/" posre_Protein_chain_D_10-wout-header > posre_Protein_chain_D_10-blank-first-line
  paste first_line posre_Protein_chain_D_10-blank-first-line > posre_Protein_chain_$4_10.itp

  #F = 5
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_5A > posre_Protein_chain_A_5-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_5-wout-header > posre_Protein_chain_A_5-blank-first-line
  paste first_line posre_Protein_chain_A_5-blank-first-line > posre_Protein_chain_$1_5.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_5B > posre_Protein_chain_B_5-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_5-wout-header > posre_Protein_chain_B_5-blank-first-line
  paste first_line posre_Protein_chain_B_5-blank-first-line > posre_Protein_chain_$2_5.itp

  paste posre_Protein_chain_C_1000-colunas-1e2.itp colunas_5C > posre_Protein_chain_C_5-wout-header
  sed "1s/^/\n/" posre_Protein_chain_C_5-wout-header > posre_Protein_chain_C_5-blank-first-line
  paste first_line posre_Protein_chain_C_5-blank-first-line > posre_Protein_chain_$3_5.itp

  paste posre_Protein_chain_D_1000-colunas-1e2.itp colunas_5D > posre_Protein_chain_D_5-wout-header
  sed "1s/^/\n/" posre_Protein_chain_D_5-wout-header > posre_Protein_chain_D_5-blank-first-line
  paste first_line posre_Protein_chain_D_5-blank-first-line > posre_Protein_chain_$4_5.itp

  #F = 3
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_3A > posre_Protein_chain_A_3-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_3-wout-header > posre_Protein_chain_A_3-blank-first-line
  paste first_line posre_Protein_chain_A_3-blank-first-line > posre_Protein_chain_$1_3.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_3B > posre_Protein_chain_B_3-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_3-wout-header > posre_Protein_chain_B_3-blank-first-line
  paste first_line posre_Protein_chain_B_3-blank-first-line > posre_Protein_chain_$2_3.itp

  paste posre_Protein_chain_C_1000-colunas-1e2.itp colunas_3C > posre_Protein_chain_C_3-wout-header
  sed "1s/^/\n/" posre_Protein_chain_C_3-wout-header > posre_Protein_chain_C_3-blank-first-line
  paste first_line posre_Protein_chain_C_3-blank-first-line > posre_Protein_chain_$3_3.itp

  paste posre_Protein_chain_D_1000-colunas-1e2.itp colunas_3D > posre_Protein_chain_D_3-wout-header
  sed "1s/^/\n/" posre_Protein_chain_D_3-wout-header > posre_Protein_chain_D_3-blank-first-line
  paste first_line posre_Protein_chain_D_3-blank-first-line > posre_Protein_chain_$4_3.itp

  #F = 2
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_2A > posre_Protein_chain_A_2-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_2-wout-header > posre_Protein_chain_A_2-blank-first-line
  paste first_line posre_Protein_chain_A_2-blank-first-line > posre_Protein_chain_$1_2.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_2B > posre_Protein_chain_B_2-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_2-wout-header > posre_Protein_chain_B_2-blank-first-line
  paste first_line posre_Protein_chain_B_2-blank-first-line > posre_Protein_chain_$2_2.itp

  paste posre_Protein_chain_C_1000-colunas-1e2.itp colunas_2C > posre_Protein_chain_C_2-wout-header
  sed "1s/^/\n/" posre_Protein_chain_C_2-wout-header > posre_Protein_chain_C_2-blank-first-line
  paste first_line posre_Protein_chain_C_2-blank-first-line > posre_Protein_chain_$3_2.itp

  paste posre_Protein_chain_D_1000-colunas-1e2.itp colunas_2D > posre_Protein_chain_D_2-wout-header
  sed "1s/^/\n/" posre_Protein_chain_D_2-wout-header > posre_Protein_chain_D_2-blank-first-line
  paste first_line posre_Protein_chain_D_2-blank-first-line > posre_Protein_chain_$4_2.itp

  #F = 1
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_1A > posre_Protein_chain_A_1-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_1-wout-header > posre_Protein_chain_A_1-blank-first-line
  paste first_line posre_Protein_chain_A_1-blank-first-line > posre_Protein_chain_$1_1.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_1B > posre_Protein_chain_B_1-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_1-wout-header > posre_Protein_chain_B_1-blank-first-line
  paste first_line posre_Protein_chain_B_1-blank-first-line > posre_Protein_chain_$2_1.itp

  paste posre_Protein_chain_C_1000-colunas-1e2.itp colunas_1C > posre_Protein_chain_C_1-wout-header
  sed "1s/^/\n/" posre_Protein_chain_C_1-wout-header > posre_Protein_chain_C_1-blank-first-line
  paste first_line posre_Protein_chain_C_1-blank-first-line > posre_Protein_chain_$3_1.itp

  paste posre_Protein_chain_D_1000-colunas-1e2.itp colunas_1D > posre_Protein_chain_D_1-wout-header
  sed "1s/^/\n/" posre_Protein_chain_D_1-wout-header > posre_Protein_chain_D_1-blank-first-line
  paste first_line posre_Protein_chain_D_1-blank-first-line > posre_Protein_chain_$4_1.itp

  #F = 0.5
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_0_5A > posre_Protein_chain_A_0_5-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_0_5-wout-header > posre_Protein_chain_A_0_5-blank-first-line
  paste first_line posre_Protein_chain_A_0_5-blank-first-line > posre_Protein_chain_$1_0_5.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_0_5B > posre_Protein_chain_B_0_5-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_0_5-wout-header > posre_Protein_chain_B_0_5-blank-first-line
  paste first_line posre_Protein_chain_B_0_5-blank-first-line > posre_Protein_chain_$2_0_5.itp

  paste posre_Protein_chain_C_1000-colunas-1e2.itp colunas_0_5C > posre_Protein_chain_C_0_5-wout-header
  sed "1s/^/\n/" posre_Protein_chain_C_0_5-wout-header > posre_Protein_chain_C_0_5-blank-first-line
  paste first_line posre_Protein_chain_C_0_5-blank-first-line > posre_Protein_chain_$3_0_5.itp

  paste posre_Protein_chain_D_1000-colunas-1e2.itp colunas_0_5D > posre_Protein_chain_D_0_5-wout-header
  sed "1s/^/\n/" posre_Protein_chain_D_0_5-wout-header > posre_Protein_chain_D_0_5-blank-first-line
  paste first_line posre_Protein_chain_D_0_5-blank-first-line > posre_Protein_chain_$4_0_5.itp

  #F = 0.2
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_0_2A > posre_Protein_chain_A_0_2-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_0_2-wout-header > posre_Protein_chain_A_0_2-blank-first-line
  paste first_line posre_Protein_chain_A_0_2-blank-first-line > posre_Protein_chain_$1_0_2.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_0_2B > posre_Protein_chain_B_0_2-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_0_2-wout-header > posre_Protein_chain_B_0_2-blank-first-line
  paste first_line posre_Protein_chain_B_0_2-blank-first-line > posre_Protein_chain_$2_0_2.itp

  paste posre_Protein_chain_C_1000-colunas-1e2.itp colunas_0_2C > posre_Protein_chain_C_0_2-wout-header
  sed "1s/^/\n/" posre_Protein_chain_C_0_2-wout-header > posre_Protein_chain_C_0_2-blank-first-line
  paste first_line posre_Protein_chain_C_0_2-blank-first-line > posre_Protein_chain_$3_0_2.itp

  paste posre_Protein_chain_D_1000-colunas-1e2.itp colunas_0_2D > posre_Protein_chain_D_0_2-wout-header
  sed "1s/^/\n/" posre_Protein_chain_D_0_2-wout-header > posre_Protein_chain_D_0_2-blank-first-line
  paste first_line posre_Protein_chain_D_0_2-blank-first-line > posre_Protein_chain_$4_0_2.itp

fi


## Se o programa receber três argumentos (3 cadeias)

if [ $# -eq 3 ]; then
mv posre_Protein_chain_$1.itp posre_Protein_chain_$2.itp posre_Protein_chain_$3.itp posre-files/
cd posre-files/
mv posre_Protein_chain_$1.itp posre_Protein_chain_$1_1000.itp  
mv posre_Protein_chain_$2.itp posre_Protein_chain_$2_1000.itp 
mv posre_Protein_chain_$3.itp posre_Protein_chain_$3_1000.itp 

#Deletar todas linhas que começam com ";"
sed '/\;/d' posre_Protein_chain_$1_1000.itp > posre_Protein_chain_A_1000-del-ptvirg.itp
sed '/\;/d' posre_Protein_chain_$2_1000.itp > posre_Protein_chain_B_1000-del-ptvirg.itp
sed '/\;/d' posre_Protein_chain_$3_1000.itp > posre_Protein_chain_C_1000-del-ptvirg.itp

# Separar a linha "[ position restraint ]" do resto do arquivo. Salvar ela em um novo arquivo e o resto em outro
awk '/^\[/ {print $1,"",$2,"", $3}' posre_Protein_chain_A_1000-del-ptvirg.itp > first_line
sed -e '1,2d' posre_Protein_chain_A_1000-del-ptvirg.itp > posre_Protein_chain_A_1000-wout-first-line.itp
sed -e '1,2d' posre_Protein_chain_B_1000-del-ptvirg.itp > posre_Protein_chain_B_1000-wout-first-line.itp
sed -e '1,2d' posre_Protein_chain_C_1000-del-ptvirg.itp > posre_Protein_chain_C_1000-wout-first-line.itp

# Começar a troca de valores das colunas relativas às forças
  
  # Apenas colunas 1 e 2
  awk '{print $1,"",$2}' posre_Protein_chain_A_1000-wout-first-line.itp > posre_Protein_chain_A_1000-colunas-1e2.itp
  awk '{print $1,"",$2}' posre_Protein_chain_B_1000-wout-first-line.itp > posre_Protein_chain_B_1000-colunas-1e2.itp
  awk '{print $1,"",$2}' posre_Protein_chain_C_1000-wout-first-line.itp > posre_Protein_chain_C_1000-colunas-1e2.itp
  
  # Apenas colunas das forças
  awk '{print $3,"",$4,"",$5}' posre_Protein_chain_A_1000-wout-first-line.itp > colunas_1000A
  awk '{print $3,"",$4,"",$5}' posre_Protein_chain_B_1000-wout-first-line.itp > colunas_1000B  
  awk '{print $3,"",$4,"",$5}' posre_Protein_chain_C_1000-wout-first-line.itp > colunas_1000C

  # Troca dos valores das forças
  sed "s/1000/5000/g" colunas_1000A > colunas_5000A
  sed "s/1000/5000/g" colunas_1000B > colunas_5000B
  sed "s/1000/5000/g" colunas_1000C > colunas_5000C

  sed "s/1000/500/g" colunas_1000A > colunas_500A
  sed "s/1000/500/g" colunas_1000B > colunas_500B
  sed "s/1000/500/g" colunas_1000C > colunas_500C

  sed "s/1000/250/g" colunas_1000A > colunas_250A
  sed "s/1000/250/g" colunas_1000B > colunas_250B
  sed "s/1000/250/g" colunas_1000C > colunas_250C

  sed "s/1000/100/g" colunas_1000A > colunas_100A
  sed "s/1000/100/g" colunas_1000B > colunas_100B
  sed "s/1000/100/g" colunas_1000C > colunas_100C

  sed "s/1000/10/g" colunas_1000A > colunas_10A
  sed "s/1000/10/g" colunas_1000B > colunas_10B
  sed "s/1000/10/g" colunas_1000C > colunas_10C

  sed "s/1000/5/g" colunas_1000A > colunas_5A
  sed "s/1000/5/g" colunas_1000B > colunas_5B
  sed "s/1000/5/g" colunas_1000C > colunas_5C

  sed "s/1000/3/g" colunas_1000A > colunas_3A
  sed "s/1000/3/g" colunas_1000B > colunas_3B
  sed "s/1000/3/g" colunas_1000C > colunas_3C

  sed "s/1000/2/g" colunas_1000A > colunas_2A
  sed "s/1000/2/g" colunas_1000B > colunas_2B
  sed "s/1000/2/g" colunas_1000C > colunas_2C

  sed "s/1000/1/g" colunas_1000A > colunas_1A
  sed "s/1000/1/g" colunas_1000B > colunas_1B
  sed "s/1000/1/g" colunas_1000C > colunas_1C

  sed "s/1000/0.5/g" colunas_1000A > colunas_0_5A
  sed "s/1000/0.5/g" colunas_1000B > colunas_0_5B
  sed "s/1000/0.5/g" colunas_1000C > colunas_0_5C

  sed "s/1000/0.2/g" colunas_1000A > colunas_0_2A
  sed "s/1000/0.2/g" colunas_1000B > colunas_0_2B
  sed "s/1000/0.2/g" colunas_1000C > colunas_0_2C

# Unir "first line" + "colunas com novas forças" + "colunas 1 e 2"
  
  #F = 5000
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_5000A > posre_Protein_chain_A_5000-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_5000-wout-header > posre_Protein_chain_A_5000-blank-first-line
  paste first_line posre_Protein_chain_A_5000-blank-first-line > posre_Protein_chain_$1_5000.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_5000B > posre_Protein_chain_B_5000-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_5000-wout-header > posre_Protein_chain_B_5000-blank-first-line
  paste first_line posre_Protein_chain_B_5000-blank-first-line > posre_Protein_chain_$2_5000.itp

  paste posre_Protein_chain_C_1000-colunas-1e2.itp colunas_5000C > posre_Protein_chain_C_5000-wout-header
  sed "1s/^/\n/" posre_Protein_chain_C_5000-wout-header > posre_Protein_chain_C_5000-blank-first-line
  paste first_line posre_Protein_chain_C_5000-blank-first-line > posre_Protein_chain_$3_5000.itp


  #F = 500
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_500A > posre_Protein_chain_A_500-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_500-wout-header > posre_Protein_chain_A_500-blank-first-line
  paste first_line posre_Protein_chain_A_500-blank-first-line > posre_Protein_chain_$1_500.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_500B > posre_Protein_chain_B_500-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_500-wout-header > posre_Protein_chain_B_500-blank-first-line
  paste first_line posre_Protein_chain_B_500-blank-first-line > posre_Protein_chain_$2_500.itp
  
  paste posre_Protein_chain_C_1000-colunas-1e2.itp colunas_500C > posre_Protein_chain_C_500-wout-header
  sed "1s/^/\n/" posre_Protein_chain_C_500-wout-header > posre_Protein_chain_C_500-blank-first-line
  paste first_line posre_Protein_chain_C_500-blank-first-line > posre_Protein_chain_$3_500.itp

  #F = 250
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_250A > posre_Protein_chain_A_250-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_250-wout-header > posre_Protein_chain_A_250-blank-first-line
  paste first_line posre_Protein_chain_A_250-blank-first-line > posre_Protein_chain_$1_250.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_250B > posre_Protein_chain_B_250-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_250-wout-header > posre_Protein_chain_B_250-blank-first-line
  paste first_line posre_Protein_chain_B_250-blank-first-line > posre_Protein_chain_$2_250.itp

  paste posre_Protein_chain_C_1000-colunas-1e2.itp colunas_250C > posre_Protein_chain_C_250-wout-header
  sed "1s/^/\n/" posre_Protein_chain_C_250-wout-header > posre_Protein_chain_C_250-blank-first-line
  paste first_line posre_Protein_chain_C_250-blank-first-line > posre_Protein_chain_$3_250.itp


  #F = 100
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_100A > posre_Protein_chain_A_100-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_100-wout-header > posre_Protein_chain_A_100-blank-first-line
  paste first_line posre_Protein_chain_A_100-blank-first-line > posre_Protein_chain_$1_100.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_100B > posre_Protein_chain_B_100-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_100-wout-header > posre_Protein_chain_B_100-blank-first-line
  paste first_line posre_Protein_chain_B_100-blank-first-line > posre_Protein_chain_$2_100.itp

  paste posre_Protein_chain_C_1000-colunas-1e2.itp colunas_100C > posre_Protein_chain_C_100-wout-header
  sed "1s/^/\n/" posre_Protein_chain_C_100-wout-header > posre_Protein_chain_C_100-blank-first-line
  paste first_line posre_Protein_chain_C_100-blank-first-line > posre_Protein_chain_$3_100.itp


  #F = 10
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_10A > posre_Protein_chain_A_10-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_10-wout-header > posre_Protein_chain_A_10-blank-first-line
  paste first_line posre_Protein_chain_A_10-blank-first-line > posre_Protein_chain_$1_10.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_10B > posre_Protein_chain_B_10-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_10-wout-header > posre_Protein_chain_B_10-blank-first-line
  paste first_line posre_Protein_chain_B_10-blank-first-line > posre_Protein_chain_$2_10.itp

  paste posre_Protein_chain_C_1000-colunas-1e2.itp colunas_10C > posre_Protein_chain_C_10-wout-header
  sed "1s/^/\n/" posre_Protein_chain_C_10-wout-header > posre_Protein_chain_C_10-blank-first-line
  paste first_line posre_Protein_chain_C_10-blank-first-line > posre_Protein_chain_$3_10.itp


  #F = 5
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_5A > posre_Protein_chain_A_5-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_5-wout-header > posre_Protein_chain_A_5-blank-first-line
  paste first_line posre_Protein_chain_A_5-blank-first-line > posre_Protein_chain_$1_5.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_5B > posre_Protein_chain_B_5-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_5-wout-header > posre_Protein_chain_B_5-blank-first-line
  paste first_line posre_Protein_chain_B_5-blank-first-line > posre_Protein_chain_$2_5.itp

  paste posre_Protein_chain_C_1000-colunas-1e2.itp colunas_5C > posre_Protein_chain_C_5-wout-header
  sed "1s/^/\n/" posre_Protein_chain_C_5-wout-header > posre_Protein_chain_C_5-blank-first-line
  paste first_line posre_Protein_chain_C_5-blank-first-line > posre_Protein_chain_$3_5.itp

  #F = 3
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_3A > posre_Protein_chain_A_3-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_3-wout-header > posre_Protein_chain_A_3-blank-first-line
  paste first_line posre_Protein_chain_A_3-blank-first-line > posre_Protein_chain_$1_3.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_3B > posre_Protein_chain_B_3-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_3-wout-header > posre_Protein_chain_B_3-blank-first-line
  paste first_line posre_Protein_chain_B_3-blank-first-line > posre_Protein_chain_$2_3.itp

  paste posre_Protein_chain_C_1000-colunas-1e2.itp colunas_3C > posre_Protein_chain_C_3-wout-header
  sed "1s/^/\n/" posre_Protein_chain_C_3-wout-header > posre_Protein_chain_C_3-blank-first-line
  paste first_line posre_Protein_chain_C_3-blank-first-line > posre_Protein_chain_$3_3.itp

  #F = 2
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_2A > posre_Protein_chain_A_2-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_2-wout-header > posre_Protein_chain_A_2-blank-first-line
  paste first_line posre_Protein_chain_A_2-blank-first-line > posre_Protein_chain_$1_2.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_2B > posre_Protein_chain_B_2-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_2-wout-header > posre_Protein_chain_B_2-blank-first-line
  paste first_line posre_Protein_chain_B_2-blank-first-line > posre_Protein_chain_$2_2.itp

  paste posre_Protein_chain_C_1000-colunas-1e2.itp colunas_2C > posre_Protein_chain_C_2-wout-header
  sed "1s/^/\n/" posre_Protein_chain_C_2-wout-header > posre_Protein_chain_C_2-blank-first-line
  paste first_line posre_Protein_chain_C_2-blank-first-line > posre_Protein_chain_$3_2.itp

  #F = 1
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_1A > posre_Protein_chain_A_1-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_1-wout-header > posre_Protein_chain_A_1-blank-first-line
  paste first_line posre_Protein_chain_A_1-blank-first-line > posre_Protein_chain_$1_1.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_1B > posre_Protein_chain_B_1-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_1-wout-header > posre_Protein_chain_B_1-blank-first-line
  paste first_line posre_Protein_chain_B_1-blank-first-line > posre_Protein_chain_$2_1.itp

  paste posre_Protein_chain_C_1000-colunas-1e2.itp colunas_1C > posre_Protein_chain_C_1-wout-header
  sed "1s/^/\n/" posre_Protein_chain_C_1-wout-header > posre_Protein_chain_C_1-blank-first-line
  paste first_line posre_Protein_chain_C_1-blank-first-line > posre_Protein_chain_$3_1.itp

  #F = 0.5
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_0_5A > posre_Protein_chain_A_0_5-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_0_5-wout-header > posre_Protein_chain_A_0_5-blank-first-line
  paste first_line posre_Protein_chain_A_0_5-blank-first-line > posre_Protein_chain_$1_0_5.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_0_5B > posre_Protein_chain_B_0_5-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_0_5-wout-header > posre_Protein_chain_B_0_5-blank-first-line
  paste first_line posre_Protein_chain_B_0_5-blank-first-line > posre_Protein_chain_$2_0_5.itp

  paste posre_Protein_chain_C_1000-colunas-1e2.itp colunas_0_5C > posre_Protein_chain_C_0_5-wout-header
  sed "1s/^/\n/" posre_Protein_chain_C_0_5-wout-header > posre_Protein_chain_C_0_5-blank-first-line
  paste first_line posre_Protein_chain_C_0_5-blank-first-line > posre_Protein_chain_$3_0_5.itp

  #F = 0.2
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_0_2A > posre_Protein_chain_A_0_2-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_0_2-wout-header > posre_Protein_chain_A_0_2-blank-first-line
  paste first_line posre_Protein_chain_A_0_2-blank-first-line > posre_Protein_chain_$1_0_2.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_0_2B > posre_Protein_chain_B_0_2-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_0_2-wout-header > posre_Protein_chain_B_0_2-blank-first-line
  paste first_line posre_Protein_chain_B_0_2-blank-first-line > posre_Protein_chain_$2_0_2.itp

  paste posre_Protein_chain_C_1000-colunas-1e2.itp colunas_0_2C > posre_Protein_chain_C_0_2-wout-header
  sed "1s/^/\n/" posre_Protein_chain_C_0_2-wout-header > posre_Protein_chain_C_0_2-blank-first-line
  paste first_line posre_Protein_chain_C_0_2-blank-first-line > posre_Protein_chain_$3_0_2.itp

fi

## Se o programa receber dois argumentos (2 cadeias)

if [ $# -eq 2 ]; then

mv posre_Protein_chain_$1.itp posre_Protein_chain_$2.itp posre-files/
cd posre-files/
mv posre_Protein_chain_$1.itp posre_Protein_chain_$1_1000.itp  
mv posre_Protein_chain_$2.itp posre_Protein_chain_$2_1000.itp 

#Deletar todas linhas que começam com ";"
sed '/\;/d' posre_Protein_chain_$1_1000.itp > posre_Protein_chain_A_1000-del-ptvirg.itp
sed '/\;/d' posre_Protein_chain_$2_1000.itp > posre_Protein_chain_B_1000-del-ptvirg.itp

# Separar a linha "[ position restraint ]" do resto do arquivo. Salvar ela em um novo arquivo e o resto em outro
awk '/^\[/ {print $1,"",$2,"", $3}' posre_Protein_chain_A_1000-del-ptvirg.itp > first_line

sed -e '1,2d' posre_Protein_chain_A_1000-del-ptvirg.itp > posre_Protein_chain_A_1000-wout-first-line.itp
sed -e '1,2d' posre_Protein_chain_B_1000-del-ptvirg.itp > posre_Protein_chain_B_1000-wout-first-line.itp

# Começar a troca de valores das colunas relativas às forças
  
  # Apenas colunas 1 e 2
  awk '{print $1,"",$2}' posre_Protein_chain_A_1000-wout-first-line.itp > posre_Protein_chain_A_1000-colunas-1e2.itp
  awk '{print $1,"",$2}' posre_Protein_chain_B_1000-wout-first-line.itp > posre_Protein_chain_B_1000-colunas-1e2.itp
  
  # Apenas colunas das forças
  awk '{print $3,"",$4,"",$5}' posre_Protein_chain_A_1000-wout-first-line.itp > colunas_1000A
  awk '{print $3,"",$4,"",$5}' posre_Protein_chain_B_1000-wout-first-line.itp > colunas_1000B  

  # Troca dos valores das forças
  sed "s/1000/5000/g" colunas_1000A > colunas_5000A
  sed "s/1000/5000/g" colunas_1000B > colunas_5000B

  sed "s/1000/500/g" colunas_1000A > colunas_500A
  sed "s/1000/500/g" colunas_1000B > colunas_500B

  sed "s/1000/250/g" colunas_1000A > colunas_250A
  sed "s/1000/250/g" colunas_1000B > colunas_250B

  sed "s/1000/100/g" colunas_1000A > colunas_100A
  sed "s/1000/100/g" colunas_1000B > colunas_100B

  sed "s/1000/10/g" colunas_1000A > colunas_10A
  sed "s/1000/10/g" colunas_1000B > colunas_10B

  sed "s/1000/5/g" colunas_1000A > colunas_5A
  sed "s/1000/5/g" colunas_1000B > colunas_5B

  sed "s/1000/3/g" colunas_1000A > colunas_3A
  sed "s/1000/3/g" colunas_1000B > colunas_3B

  sed "s/1000/2/g" colunas_1000A > colunas_2A
  sed "s/1000/2/g" colunas_1000B > colunas_2B

  sed "s/1000/1/g" colunas_1000A > colunas_1A
  sed "s/1000/1/g" colunas_1000B > colunas_1B

  sed "s/1000/0.5/g" colunas_1000A > colunas_0_5A
  sed "s/1000/0.5/g" colunas_1000B > colunas_0_5B

  sed "s/1000/0.2/g" colunas_1000A > colunas_0_2A
  sed "s/1000/0.2/g" colunas_1000B > colunas_0_2B

# Unir "first line" + "colunas com novas forças" + "colunas 1 e 2"
  
  #F = 5000
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_5000A > posre_Protein_chain_A_5000-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_5000-wout-header > posre_Protein_chain_A_5000-blank-first-line
  paste first_line posre_Protein_chain_A_5000-blank-first-line > posre_Protein_chain_$1_5000.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_5000B > posre_Protein_chain_B_5000-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_5000-wout-header > posre_Protein_chain_B_5000-blank-first-line
  paste first_line posre_Protein_chain_B_5000-blank-first-line > posre_Protein_chain_$2_5000.itp

  
  #F = 500
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_500A > posre_Protein_chain_A_500-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_500-wout-header > posre_Protein_chain_A_500-blank-first-line
  paste first_line posre_Protein_chain_A_500-blank-first-line > posre_Protein_chain_$1_500.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_500B > posre_Protein_chain_B_500-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_500-wout-header > posre_Protein_chain_B_500-blank-first-line
  paste first_line posre_Protein_chain_B_500-blank-first-line > posre_Protein_chain_$2_500.itp
  
  #F = 250
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_250A > posre_Protein_chain_A_250-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_250-wout-header > posre_Protein_chain_A_250-blank-first-line
  paste first_line posre_Protein_chain_A_250-blank-first-line > posre_Protein_chain_$1_250.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_250B > posre_Protein_chain_B_250-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_250-wout-header > posre_Protein_chain_B_250-blank-first-line
  paste first_line posre_Protein_chain_B_250-blank-first-line > posre_Protein_chain_$2_250.itp

 
  #F = 100
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_100A > posre_Protein_chain_A_100-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_100-wout-header > posre_Protein_chain_A_100-blank-first-line
  paste first_line posre_Protein_chain_A_100-blank-first-line > posre_Protein_chain_$1_100.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_100B > posre_Protein_chain_B_100-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_100-wout-header > posre_Protein_chain_B_100-blank-first-line
  paste first_line posre_Protein_chain_B_100-blank-first-line > posre_Protein_chain_$2_100.itp

  #F = 10
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_10A > posre_Protein_chain_A_10-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_10-wout-header > posre_Protein_chain_A_10-blank-first-line
  paste first_line posre_Protein_chain_A_10-blank-first-line > posre_Protein_chain_$1_10.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_10B > posre_Protein_chain_B_10-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_10-wout-header > posre_Protein_chain_B_10-blank-first-line
  paste first_line posre_Protein_chain_B_10-blank-first-line > posre_Protein_chain_$2_10.itp

  #F = 5
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_5A > posre_Protein_chain_A_5-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_5-wout-header > posre_Protein_chain_A_5-blank-first-line
  paste first_line posre_Protein_chain_A_5-blank-first-line > posre_Protein_chain_$1_5.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_5B > posre_Protein_chain_B_5-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_5-wout-header > posre_Protein_chain_B_5-blank-first-line
  paste first_line posre_Protein_chain_B_5-blank-first-line > posre_Protein_chain_$2_5.itp

  #F = 3
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_3A > posre_Protein_chain_A_3-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_3-wout-header > posre_Protein_chain_A_3-blank-first-line
  paste first_line posre_Protein_chain_A_3-blank-first-line > posre_Protein_chain_$1_3.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_3B > posre_Protein_chain_B_3-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_3-wout-header > posre_Protein_chain_B_3-blank-first-line
  paste first_line posre_Protein_chain_B_3-blank-first-line > posre_Protein_chain_$2_3.itp

  #F = 2
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_2A > posre_Protein_chain_A_2-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_2-wout-header > posre_Protein_chain_A_2-blank-first-line
  paste first_line posre_Protein_chain_A_2-blank-first-line > posre_Protein_chain_$1_2.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_2B > posre_Protein_chain_B_2-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_2-wout-header > posre_Protein_chain_B_2-blank-first-line
  paste first_line posre_Protein_chain_B_2-blank-first-line > posre_Protein_chain_$2_2.itp

  #F = 1
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_1A > posre_Protein_chain_A_1-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_1-wout-header > posre_Protein_chain_A_1-blank-first-line
  paste first_line posre_Protein_chain_A_1-blank-first-line > posre_Protein_chain_$1_1.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_1B > posre_Protein_chain_B_1-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_1-wout-header > posre_Protein_chain_B_1-blank-first-line
  paste first_line posre_Protein_chain_B_1-blank-first-line > posre_Protein_chain_$2_1.itp

  #F = 0.5
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_0_5A > posre_Protein_chain_A_0_5-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_0_5-wout-header > posre_Protein_chain_A_0_5-blank-first-line
  paste first_line posre_Protein_chain_A_0_5-blank-first-line > posre_Protein_chain_$1_0_5.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_0_5B > posre_Protein_chain_B_0_5-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_0_5-wout-header > posre_Protein_chain_B_0_5-blank-first-line
  paste first_line posre_Protein_chain_B_0_5-blank-first-line > posre_Protein_chain_$2_0_5.itp

  #F = 0.2
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_0_2A > posre_Protein_chain_A_0_2-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_0_2-wout-header > posre_Protein_chain_A_0_2-blank-first-line
  paste first_line posre_Protein_chain_A_0_2-blank-first-line > posre_Protein_chain_$1_0_2.itp

  paste posre_Protein_chain_B_1000-colunas-1e2.itp colunas_0_2B > posre_Protein_chain_B_0_2-wout-header
  sed "1s/^/\n/" posre_Protein_chain_B_0_2-wout-header > posre_Protein_chain_B_0_2-blank-first-line
  paste first_line posre_Protein_chain_B_0_2-blank-first-line > posre_Protein_chain_$2_0_2.itp

fi

## Se o programa receber um argumento (1 cadeia)

if [ $# -eq 1 ]; then

mv posre.itp posre-files/
cd posre-files/
mv posre.itp posre_Protein_chain_$1_1000.itp  

#Deletar todas linhas que começam com ";"
sed '/\;/d' posre_Protein_chain_$1_1000.itp > posre_Protein_chain_A_1000-del-ptvirg.itp

# Separar a linha "[ position restraint ]" do resto do arquivo. Salvar ela em um novo arquivo e o resto em outro
awk '/^\[/ {print $1,"",$2,"", $3}' posre_Protein_chain_A_1000-del-ptvirg.itp > first_line

sed -e '1,2d' posre_Protein_chain_A_1000-del-ptvirg.itp > posre_Protein_chain_A_1000-wout-first-line.itp

# Começar a troca de valores das colunas relativas às forças
  
  # Apenas colunas 1 e 2
  awk '{print $1,"",$2}' posre_Protein_chain_A_1000-wout-first-line.itp > posre_Protein_chain_A_1000-colunas-1e2.itp
  
  # Apenas colunas das forças
  awk '{print $3,"",$4,"",$5}' posre_Protein_chain_A_1000-wout-first-line.itp > colunas_1000A

  # Troca dos valores das forças
  sed "s/1000/10000/g" colunas_1000A > colunas_10000A
  sed "s/1000/5000/g" colunas_1000A > colunas_5000A
  sed "s/1000/500/g" colunas_1000A > colunas_500A
  sed "s/1000/250/g" colunas_1000A > colunas_250A
  sed "s/1000/100/g" colunas_1000A > colunas_100A
  sed "s/1000/10/g" colunas_1000A > colunas_10A
  sed "s/1000/5/g" colunas_1000A > colunas_5A
  sed "s/1000/3/g" colunas_1000A > colunas_3A
  sed "s/1000/2/g" colunas_1000A > colunas_2A
  sed "s/1000/1/g" colunas_1000A > colunas_1A
  sed "s/1000/0.5/g" colunas_1000A > colunas_0_5A
  sed "s/1000/0.2/g" colunas_1000A > colunas_0_2A

# Unir "first line" + "colunas com novas forças" + "colunas 1 e 2"
  
  #F = 10000
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_10000A > posre_Protein_chain_A_10000-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_10000-wout-header > posre_Protein_chain_A_10000-blank-first-line
  paste first_line posre_Protein_chain_A_10000-blank-first-line > posre_Protein_chain_$1_10000.itp

  #F = 5000
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_5000A > posre_Protein_chain_A_5000-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_5000-wout-header > posre_Protein_chain_A_5000-blank-first-line
  paste first_line posre_Protein_chain_A_5000-blank-first-line > posre_Protein_chain_$1_5000.itp

  #F = 500
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_500A > posre_Protein_chain_A_500-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_500-wout-header > posre_Protein_chain_A_500-blank-first-line
  paste first_line posre_Protein_chain_A_500-blank-first-line > posre_Protein_chain_$1_500.itp

  #F = 250
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_250A > posre_Protein_chain_A_250-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_250-wout-header > posre_Protein_chain_A_250-blank-first-line
  paste first_line posre_Protein_chain_A_250-blank-first-line > posre_Protein_chain_$1_250.itp

  #F = 100
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_100A > posre_Protein_chain_A_100-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_100-wout-header > posre_Protein_chain_A_100-blank-first-line
  paste first_line posre_Protein_chain_A_100-blank-first-line > posre_Protein_chain_$1_100.itp

  #F = 10
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_10A > posre_Protein_chain_A_10-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_10-wout-header > posre_Protein_chain_A_10-blank-first-line
  paste first_line posre_Protein_chain_A_10-blank-first-line > posre_Protein_chain_$1_10.itp

  #F = 5
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_5A > posre_Protein_chain_A_5-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_5-wout-header > posre_Protein_chain_A_5-blank-first-line
  paste first_line posre_Protein_chain_A_5-blank-first-line > posre_Protein_chain_$1_5.itp

  #F = 3
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_3A > posre_Protein_chain_A_3-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_3-wout-header > posre_Protein_chain_A_3-blank-first-line
  paste first_line posre_Protein_chain_A_3-blank-first-line > posre_Protein_chain_$1_3.itp

  #F = 2
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_2A > posre_Protein_chain_A_2-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_2-wout-header > posre_Protein_chain_A_2-blank-first-line
  paste first_line posre_Protein_chain_A_2-blank-first-line > posre_Protein_chain_$1_2.itp

  #F = 1
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_1A > posre_Protein_chain_A_1-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_1-wout-header > posre_Protein_chain_A_1-blank-first-line
  paste first_line posre_Protein_chain_A_1-blank-first-line > posre_Protein_chain_$1_1.itp

  #F = 0.5
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_0_5A > posre_Protein_chain_A_0_5-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_0_5-wout-header > posre_Protein_chain_A_0_5-blank-first-line
  paste first_line posre_Protein_chain_A_0_5-blank-first-line > posre_Protein_chain_$1_0_5.itp

  #F = 0.2
  paste posre_Protein_chain_A_1000-colunas-1e2.itp colunas_0_2A > posre_Protein_chain_A_0_2-wout-header
  sed "1s/^/\n/" posre_Protein_chain_A_0_2-wout-header > posre_Protein_chain_A_0_2-blank-first-line
  paste first_line posre_Protein_chain_A_0_2-blank-first-line > posre_Protein_chain_$1_0_2.itp

fi

# Limpar arquivos que não serão mais usados
 rm colunas_*
 rm *-wout-header
 rm *-blank-first-line
 rm first_line
 rm *-colunas-1e2.itp
 rm *-del-ptvirg.itp
 rm *-wout-first-line.itp

#cd ../
#./Script_New_DM2.sh
