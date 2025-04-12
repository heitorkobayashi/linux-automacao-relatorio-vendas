#!/bin/bash

#Definição do caminho do diretório
caminho_relatorios="/home/heitorkobayashi/ecommerce/vendas/backup"

#Definição da variável do relatório
arquivo_final="relatorio_final.txt"

#Mudança de diretório
cd "$caminho_relatorios"

#Junção de todos relatórios em um só
cat relatorio-*.txt >> "$arquivo_final"

#Mensagem final
echo "O arquivo $arquivo_final foi gerado!"