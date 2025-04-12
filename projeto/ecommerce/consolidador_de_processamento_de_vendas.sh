#!/bin/bash

caminho_relatorios="/home/heitorkobayashi/ecommerce/vendas/backup"

arquivo_final="relatorio_final.txt"

cd "$caminho_relatorios"

cat relatorio-*.txt >> "$arquivo_final"

echo "O arquivo $arquivo_final foi gerado!"