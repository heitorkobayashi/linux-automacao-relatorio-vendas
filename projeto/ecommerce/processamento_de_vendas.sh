#!/bin/bash

cd /home/heitorkobayashi/ecommerce

mkdir -p /home/heitorkobayashi/ecommerce/vendas

cp dados_de_vendas.csv /home/heitorkobayashi/ecommerce/vendas
cd /home/heitorkobayashi/ecommerce/vendas

mkdir -p /home/heitorkobayashi/ecommerce/vendas/backup

data=$(date +%Y%m%d)
cp dados_de_vendas.csv /home/heitorkobayashi/ecommerce/vendas/backup
cd /home/heitorkobayashi/ecommerce/vendas/backup
mv dados_de_vendas.csv backup-dados-$data.csv

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

echo "O arquivo '$arquivo' foi gerado."
cat /home/heitorkobayashi/ecommerce/vendas/backup/relatorio-$data.txt

#Compressão
cd /home/heitorkobayashi/ecommerce/vendas/backup
zip -r backup-dados-$data.zip backup-dados-$data.csv
rm backup-dados-$data.csv
cd /home/heitorkobayashi/ecommerce/vendas
rm dados_de_vendas.csv