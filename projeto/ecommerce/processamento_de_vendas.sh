#!/bin/bash

#Definição do diretório para realização do script
cd /home/heitorkobayashi/ecommerce

#Criação da pasta vendas
mkdir -p /home/heitorkobayashi/ecommerce/vendas

#Cópia do arquivo .csv para pasta vendas e mudança de diretório
cp dados_de_vendas.csv /home/heitorkobayashi/ecommerce/vendas
cd /home/heitorkobayashi/ecommerce/vendas

#Criação do subdiretório backup
mkdir -p /home/heitorkobayashi/ecommerce/vendas/backup

#Renomeação do aquivo de backup com base na data do sistema
data=$(date +%Y%m%d)
cp dados_de_vendas.csv /home/heitorkobayashi/ecommerce/vendas/backup
cd /home/heitorkobayashi/ecommerce/vendas/backup
mv dados_de_vendas.csv backup-dados-$data.csv

#Definição da variável do arquivo backup .csv
dados_tabela="backup-dados-$data.csv"

#Extração de dados da tabela
primeiro_registro=$(awk -F ',' 'NR==2 {print $5}' "$dados_tabela")
ultimo_registro=$(awk -F ',' 'END {print $5}' "$dados_tabela")
total_itens=$(awk 'NR!=1' "$dados_tabela" | wc -l)

#Criação do arquivo relatório
arquivo="relatorio-$data.txt"
cat << END > "$arquivo"
Data do primeiro registro: $primeiro_registro
Data do último registro: $ultimo_registro
Total de itens: $total_itens
Data e hora da geração do relatório: $(date +'%Y%m%d %Hh:%Mm')
$(tail -n +2 backup-dados-$data.csv | head -n 10)
END

#Mensagem final
echo "O arquivo '$arquivo' foi gerado."
cat /home/heitorkobayashi/ecommerce/vendas/backup/relatorio-$data.txt

#Compressão e remoção dos arquivos solicitados
cd /home/heitorkobayashi/ecommerce/vendas/backup
zip -r backup-dados-$data.zip backup-dados-$data.csv
rm backup-dados-$data.csv
cd /home/heitorkobayashi/ecommerce/vendas
rm dados_de_vendas.csv