# **Sprint 1: Desafio**

## **1. Objetivos**

Este desafio teve como objetivo a criação de dois scripts que automatizassem a geração de relatórios de vendas a partir de um arquivo **[`.csv`](https://github.com/heitorkobayashi/PB-HEITOR-KOBAYASHI/blob/main/Sprint%201/desafio/entregaveis/ecommerce/dados_de_vendas.csv)**, com execução durante 4 dias seguidos.

O primeiro script, o qual chamaremos de **[Script 1](https://github.com/heitorkobayashi/PB-HEITOR-KOBAYASHI/blob/main/Sprint%201/desafio/entregaveis/ecommerce/processamento_de_vendas.sh)**, realiza a criação de diretórios e subdiretórios, a cópia do arquivo  para arquivos de backup junto com a moção desses arquivos para determinados diretórios, além da extração de dados deste arquivo e a criação de relatórios **[`relatorio.txt`](https://github.com/heitorkobayashi/PB-HEITOR-KOBAYASHI/tree/main/Sprint%201/desafio/entregaveis/ecommerce/vendas/backup)** contendo todas essas informações. Já o segundo script, **[Script 2](https://github.com/heitorkobayashi/PB-HEITOR-KOBAYASHI/blob/main/Sprint%201/desafio/entregaveis/ecommerce/consolidador_de_processamento_de_vendas.sh)**, teve como função a junção de todos os relatórios gerados a partir do script anterior e, assim, criar um arquivo chamado **[`relatorio_final.txt`](https://github.com/heitorkobayashi/PB-HEITOR-KOBAYASHI/blob/main/Sprint%201/desafio/entregaveis/ecommerce/vendas/backup/relatorio_final.txt)**

O diretório contendo todos os resultados do desafio, você pode encontrar **[aqui neste link](https://github.com/heitorkobayashi/PB-HEITOR-KOBAYASHI/tree/main/Sprint%201/desafio/entregaveis)**.

## **2. Preparação**

Antes de iniciar o script em si, foi realizada a preparação da área de trabalho, ou seja, a criação dos diretórios necessários para a execução deste desafio.

### **2.1. Criação do diretório ecommerce**

Para criar o diretório [`ecommerce`](https://github.com/heitorkobayashi/PB-HEITOR-KOBAYASHI/tree/main/Sprint%201/desafio/entregaveis/ecommerce) foi utilizado o comando `mkdir ecommerce`. O arquivo `dados_de_vendas.csv` foi inserido manualmente no linux. Com o comando `ls` pode-se listar os diretórios e arquivos existentes, como mostra a imagem abaixo:

![imagem_01](https://github.com/heitorkobayashi/PB-HEITOR-KOBAYASHI/blob/main/Sprint%201/evidencias/01_criacao_pasta_ecommerce.png) 


## **3. Criação do Script 1**

Nesta etapa, no processo de criação do script, foi dada a preferência por desenvolvê-lo em estágios para garantir que o caminho desenvolvido estava correto, a fim de evitar surpresas ao final do código.

### **3.1. Criação dos subdiretórios**

O primeiro passo deste script foi a criação dos subdiretórios [`vendas`](https://github.com/heitorkobayashi/PB-HEITOR-KOBAYASHI/tree/main/Sprint%201/desafio/entregaveis/ecommerce/vendas) e [`backup`](https://github.com/heitorkobayashi/PB-HEITOR-KOBAYASHI/tree/main/Sprint%201/desafio/entregaveis/ecommerce/vendas/backup), além da realização de uma cópia do arquivo `dados_de_vendas.csv` para a pasta `vendas`.

- Com o comando `cd` é definido onde o script será executado.
- Sabendo que o script será realizado mais que uma vez, com o `mkdir -p` é possível realizar a criação da pasta vendas e prevenir erros futuros por conta da criação de diretórios já existentes, neste caso os diretórios `vendas` e `backup`. 
- É importante ressaltar a utilização dos caminhos absolutos no script. Na Seção 7, este tema será aprofundado, pois foi uma das maiores dificuldades encontradas na realização deste código.

![imagem_02](https://github.com/heitorkobayashi/PB-HEITOR-KOBAYASHI/blob/main/Sprint%201/evidencias/02_codigo_criacao_subdiretorios.png) 

Abaixo, podemos ver o resultado desta primeira parte do script. Nota-se a utilização do `chmod u+x` para garantir a permissão de execução do arquivo. 

![imagem_03](https://github.com/heitorkobayashi/PB-HEITOR-KOBAYASHI/blob/main/Sprint%201/evidencias/03_resultado_codigo_criacao_subdiretorios.png) 

### **3.2. Renomeação do arquivo de backup**

Para a renomeação do arquivo `dados_de_vendas.csv`, foi necessário a definição da variável `data` conforme a data atual do sistema operacional. Com o comando `data=$(date +%Y%m%d)` é possível obter este resultado. Assim, bastou realizar a cópia do arquivo para a pasta `backup` e a renomeação do arquivo com o comando `mv`.

```bash
data=$(date +%Y%m%d)
cp dados_de_vendas.csv /home/heitorkobayashi/ecommerce/vendas/backup
cd /home/heitorkobayashi/ecommerce/vendas/backup
mv dados_de_vendas.csv backup-dados-$data.csv
```

- Nota-se a utilização do `$`, que juntamente ao `=` foi utilizado para atribuir valores a variáveis e substituir valores, como no caso da renomeação do arquivo de `backup` com a data atual do sistema.

### **3.3. Extração de dados**

Para extrair as informações do arquivo `.csv`, foi necessário armazenar o nome do arquivo de backup renomeado em uma variável, no caso, com toda a criatividade disponível no momento, a variável `dados_tabela`, possibilitando o acesso ao arquivo. 

```bash
dados_tabela="backup-dados-$data.csv"
primeiro_registro=$(awk -F ',' 'NR==2 {print $5}' "$dados_tabela")
ultimo_registro=$(awk -F ',' 'END {print $5}' "$dados_tabela")
total_itens=$(awk 'NR!=1' "$dados_tabela" | wc -l)
```

Para cada item de informação contida no relatório foram definidas variáveis, como o "primeiro registro de vendas", o "último registro de vendas" e a "quantidade total de itens diferentes". Dessa forma, além de facilitar na parte do código da criação do relatório, foi possível armazenar os dados solicitados e extraí-los utilizando o comando `awk`, que se deu por vários motivos:

- O comando `awk` foi projetado para trabalhar com dados estruturados por colunas, ou seja, muito útil para arquivos `.csv`.
- Além disso, ele processa o arquivo linha por linha, o que era exatamente o necessário nessa situação.
- A flag `-F` é extremamente útil para delimitar os campos, neste caso, a vírgula.

Agora, sobre os demais itens da sintaxe:

- O comando `NR` é um contador automático de linhas, dessa forma, ele define a linha pretendida, sendo possível acessar as linhas desejadas.
- O comando `{print $5}` define a impressão do quinto campo da linha.
- O comando `END` faz com que a ação do `awk` seja contabilizada até a última linha, poupando o trabalho de fazer a contagem com `NR`.
- Para a variável `total_itens`, foi levado em consideração apenas a extração de todos os itens, não importando o id dos itens e o cabeçalho. Para isso, foi necessário a utilização do `NR!=1` para ignorar a primeira linha e a utilização do `wc -l`, para contar o restante das linhas.
- O comando `wc` é utilizado para contar linhas e caracteres. Com a flag `-l`, define a contagem apenas das linhas. Dessa forma é possível contabilizar o número total de itens.
- O `|` se chama pipe, um operador que permite conectar as entradas e saídas dos comandos.

### **3.4. Criação do arquivo relatorio.txt**

Para a criação do arquivo `relatorio.txt` foi utilizado a atribuição da variável `arquivo` ao nome do arquivo de relatório que será criado.

```bash
arquivo="relatorio-$data.txt"
```

- Nota-se a utilização da variável `$data` para atribuição do nome ao arquivo conforme solicitado.

Agora, para que o relatório pudesse conter todas as informações que foram extraídas, foi utilizado o comando `cat`. Aqui, farei uma breve pausa para explicar a minha linha de raciocínio nessa escolha:

- Durante as minhas pesquisas sobre como eu poderia colocar os dados extraídos dentro de um arquivo, eu me deparei com diversos comandos para fazer isso, como o `echo`, `printf` e até mesmo o `awk`. Mas esses métodos não estavam fazendo muito sentido para mim. Vendo as aulas de linux lembrei do comando `cat xarquivo.txt >> yarquivo.txt` que é capaz de concatenar o conteúdo de um arquivo dentro de outro arquivo. Dessa forma, fui atrás para saber se existia algum jeito de fazer isso utilizando o `cat`. E não é que era possível? Depois de muita pesquisa, achei esse notação:

    ```bash
    cat << END > "arquivo" 
    texto
    END
    ```
    A sintaxe utilizada por este comando é muito semelhante ao pouco que sei de programação, assim consegui assimilar a algo que já conhecia previamente, facilitando a minha vida e o andamento do desafio.

Voltando ao que interessa, a escolha pelo pelo `cat` também foi motivada por outros fatores:

- A facilidade de usar: o comando é muito intuitivo, de fácil leitura e possibilita a utilização de vários blocos de textos no próprio corpo do comando.
- Com ele é possível inserir as variáveis que foram definidas anteriormente de forma simples. 


```bash
arquivo="relatorio-$data.txt"
cat << END > "$arquivo"
Data do primeiro registro: $primeiro_registro
Data do último registro: $ultimo_registro
Total de itens: $total_itens
Data e hora da geração do relatório: $(date +'%Y%m%d %Hh:%Mm')
$(tail -n +2 backup-dados-$data.csv | head -n 10)
END
```
Acima, podemos ver o comando completo e ressaltar alguns pontos:

- O conteúdo que será escrito no relatório está entre `<< END` e `END`. Como dito anteriormente, as variáveis podem ser adicionadas ao corpo do texto, facilitando a leitura.
- A inclusão das horas e minutos na definição da data. 
- A utilização do comando `tail` e `head` para extrair do arquivo apenas os 10 primeiros itens da lista. Lembrando que a flag `-n` define exatamente a linha a ser delimitada.

Na imagem abaixo, podemos conferir todo o procedimento realizado: 

![imagem_04](https://github.com/heitorkobayashi/PB-HEITOR-KOBAYASHI/blob/main/Sprint%201/evidencias/04_codigo_extracao_dados_criacao_relatorio.png) 

Para notificar o usuário de que o relatório foi gerado com sucesso, o comando `echo` foi utilizado, assim como o comando `cat` para facilitar a visualização e ter a certeza de que o relatório estava conforme o solicitado, como mostra o resultado do script na imagem abaixo:

![imagem_05](https://github.com/heitorkobayashi/PB-HEITOR-KOBAYASHI/blob/main/Sprint%201/evidencias/05_resultado_extracao_dados_criacao_relatorio.png)

### **3.5. Compressão do arquivo em zip e remoção dos arquivos `.csv`**

Com o `zip` instalado no sistema, pode-se realizar a compressão do arquivo de backup e, posteriormente, a remoção dos arquivos `.csv`:

![imagem_06](https://github.com/heitorkobayashi/PB-HEITOR-KOBAYASHI/blob/main/Sprint%201/evidencias/06_zip_remocao_backup.png)

A utilização do `zip -r` foi essencial para incluir todos os arquivos e subdiretórios dentro do diretório desejado, ou melhor, utilizando os termos técnicos, de forma **recursiva** _(coisas que aprendemos na prática... por muitas tentativas o meu zip deu errado)_.

### **3.6. Agendamento**

Para que o script fosse automatizado, era necessário a realização do agendamento pelo próprio sistema. Com o comando `crontab -e` pode-se efetuar esta tarefa. Antes de executar o agendamento conforme o horário solicitado no desafio, optei pela realização de um teste para saber se estava no caminho correto.

![imagem_09](https://github.com/heitorkobayashi/PB-HEITOR-KOBAYASHI/blob/main/Sprint%201/evidencias/09_agendamento_teste.png)

Com `crontab -l` podemos listar os agendamentos implementados. Esse teste teve como objetivo executar o Script 1 a cada minuto. Para mostrar os relatórios com nomes diferentes, houve uma mudança no nome dos arquivos, como mostra a imagem a seguir:

![imagem_10](https://github.com/heitorkobayashi/PB-HEITOR-KOBAYASHI/blob/main/Sprint%201/evidencias/10_agendamento_teste_modificacao_data.png)

Dessa forma, pode-se obter os seguintes resultados:

![imagem_11](https://github.com/heitorkobayashi/PB-HEITOR-KOBAYASHI/blob/main/Sprint%201/evidencias/11_agendamento_teste_resultado.png)

Com o teste sendo bem sucedido, bastava apenas a criação do Script 2 e o agendamento nos dias solicitados. 


## **4. Criação do Script 2**

Por se tratar de um script mais simples comparado ao anterior, optei por, logo após os testes, desenvolvê-lo para ter todas as ferramentas em mãos antes da execução de todo o procedimento. Dessa forma, os riscos que poderiam se suceder seriam diminuídos.

### **4.1. Código do Script 2**

A imagem abaixo mostra a criação do arquivo executável e a utilização do comando `chmod u+x` para garantir a execução do script. 

![imagem_12](https://github.com/heitorkobayashi/PB-HEITOR-KOBAYASHI/blob/main/Sprint%201/evidencias/12_script2_criacao.png)

Sobre o código em si do **[Script 2](https://github.com/heitorkobayashi/PB-HEITOR-KOBAYASHI/blob/main/Sprint%201/desafio/entregaveis/ecommerce/consolidador_de_processamento_de_vendas.sh)**, podemos destacar: 

```bash
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
```

- A criação da variável `caminho_relatorios` para facilitar a utilização do caminho absoluto.
- A definição da variável do relatório final.
- A utilização do comando `cat` para a concatenação dos relatórios em apenas um arquivo, o `$arquivo_final`.
- A notação utilizada para identificar os relatórios existentes no diretório `relatorio-*.txt`. O asterisco tem como função selecionar todos os arquivos existentes que possuem em seu nome a palavra "relatorio-" e que terminam em ".txt"

### **4.2. Teste de execução**

Com o script finalizado e com alguns relatórios gerados na pasta backup, era hora de testá-lo:

![imagem_14](https://github.com/heitorkobayashi/PB-HEITOR-KOBAYASHI/blob/main/Sprint%201/evidencias/14_script2_teste_exec.png)


## **5. Execução do procedimento**

Agora tudo estava pronto para a realização do procedimento. Para remover o agendamento de teste foi utilizado o comando `crontab -r`. 

![imagem15](https://github.com/heitorkobayashi/PB-HEITOR-KOBAYASHI/blob/main/Sprint%201/evidencias/15_crontab_agendamento.png)

- Com o `crontab -e` pode-se agendar a execução do Script 1.
- A task `27 15 * * 3-6 /home...` quer dizer que o agendamento será realizado de quarta-feira a sábado às 15 horas e 27 minutos. 

## **6. Resultados**

### **6.1. Primeiro dia**

Com a execução do Script 1 agendado, bastava apenas a coleta dos resultados e a adição de dados no arquivo `dados_de_vendas.csv` durante os dias do agendamento.

Para o primeiro dia não foi necessária a inserção de dados, então os resultados obtidos foram estes:

![imagem16](https://github.com/heitorkobayashi/PB-HEITOR-KOBAYASHI/blob/main/Sprint%201/evidencias/15_crontab_agendamento.png)

### **6.2. Segundo, terceiro e quarto dias**

Neste segundo dia, foi preciso inserir dados novos. Para garantir a permissão de alteração do arquivo `dados_de_vendas.csv`, o comando `chmod u+w` foi utilizado, conforme mostra a imagem abaixo:

![imagem17](https://github.com/heitorkobayashi/PB-HEITOR-KOBAYASHI/blob/main/Sprint%201/evidencias/17_permissao_dados_dia2.png)

Em seguida, a linha com ID "89" foi adicionada ao arquivo, e assim sucessivamente:

![imagem15](https://github.com/heitorkobayashi/PB-HEITOR-KOBAYASHI/blob/main/Sprint%201/evidencias/15_crontab_agendamento.png)

![imagem20](https://github.com/heitorkobayashi/PB-HEITOR-KOBAYASHI/blob/main/Sprint%201/evidencias/20_adicional_dados_dia3.png)

![imagem22](https://github.com/heitorkobayashi/PB-HEITOR-KOBAYASHI/blob/main/Sprint%201/evidencias/22_adicional_dados_dia4.png)

No final do dia 4, obteve-se o seguinte resultado:

![imagem23](https://github.com/heitorkobayashi/PB-HEITOR-KOBAYASHI/blob/main/Sprint%201/evidencias/23_resultado_dia4.png)


### **6.3. Resultado do Script 2**

Por fim, após as execuções do Script 1 e, com todos os relatórios gerados durantes os dias, restava apenas a execução manual do Script 2.

![imagem24](https://github.com/heitorkobayashi/PB-HEITOR-KOBAYASHI/blob/main/Sprint%201/evidencias/24_script2_execucao.png)

Pela imagem, percebe-se a criação do arquivo [`relatorio_final.txt`](https://github.com/heitorkobayashi/PB-HEITOR-KOBAYASHI/blob/main/Sprint%201/desafio/entregaveis/ecommerce/vendas/backup/relatorio_final.txt) exatamente na pasta solicitada. A utilização do comando `cat` foi para evidenciar o conteúdo do arquivo final.


## **7. Dificuldades e Considerações Finais**

Enquanto redigia este README, me dei conta que estava passando a ideia de que as etapas foram fluídas entre elas. Claro, isto foi intencional, mas as coisas não aconteceram tão bem assim. Durante a realização deste desafio, encontrei algumas adversidades e, a seguir, listarei os processos que mais deram trabalho durante o seu desenvolvimento.

### **7.1. Desenvolvimento do Script 1**

A primeira dificuldade foi o desenvolvimento do primeiro script, com destaque para a extração dos dados e a criação do relatório. Foram dois dias de trabalho intenso, quebrando a cabeça e a cara para achar uma solução para o problema. 

A meta era terminar o script até segunda-feira (26/08/2024). Nesse dia, eu cheguei a finalizar e conseguia executar o script manualmente, mas infelizmente me deparei com um outro empecilho, o **agendamento**. 

### **7.2. O agendamento e a utilização dos caminhos absolutos**

Na imagem abaixo está o meu primeiro código:

![imagem25](https://github.com/heitorkobayashi/PB-HEITOR-KOBAYASHI/blob/main/Sprint%201/evidencias/25_dificuldade_primeiro_script.png)

Além do péssimo design que eu escolhi ao trabalhar, você, caro técnico leitor, com certeza já notou o problema, não é mesmo? 

Pois bem, até eu achar a solução para o meu código, que era a inserção dos caminhos absolutos e a inclusão do caminho a ser executado o script, passaram-se 2 dias. Até fiz uma gravação de tela para mostrar as minhas frustradas tentativas:

![gif26](https://github.com/heitorkobayashi/PB-HEITOR-KOBAYASHI/blob/main/Sprint%201/evidencias/26_dificuldade_tentativas.gif)

Antes de saber que o problema era o código em si, eu pensava que o problema era com o agendamento. Então pensei em fazer um teste que criava um arquivo chamado `minuto.txt` que atualizava com a data atual do sistema:

```bash
* * * * * echo$(date) >> /home/heitorkoba/ecommerce/minuto.txt
```

Infelizmente acabei esquecendo de evidenciar essa etapa devidamente, por isso, na imagem abaixo, eu fiz a demonstração desse procedimento após a realização do script.

![imagem27](https://github.com/heitorkobayashi/PB-HEITOR-KOBAYASHI/blob/main/Sprint%201/evidencias/27_dificuldade_crontab.jpg)

- o arquivo `a.sh` era um script que fazia parte dos meus testes e continha um simples comando `touch abc.txt`.

Vendo que o problema não era o agendamento, levei a questão para monitoria na quarta-feira (28/08/24). Prontamente fui respondido para rever os caminhos do meu código. A resposta me atendeu muito bem já que não foi entregue de "mão beijada", mas sim despertou uma faísca na minha mente. Após algumas horas, consegui chegar no resultado final do Script 1. 

Vale ressaltar aqui a cooperação não só entre os membros da minha Squad, mas de todas as pessoas do Programa. Alguns enfrentavam problemas semelhantes ao meu, e posso dizer com tranquilidade que, sozinho, não alcançaria o resultado esperado.


## **8. Referências**

Neste texto, fiz diversas afirmações que, obviamente, tiveram como base alguma fonte de pesquisa. Optei por não adotar o esquema de citações ao longo do texto para evitar que ele se tornasse massante, e acredito que não seria adequado neste formato.

De qualquer forma, incluirei as fontes que utilizei para encontrar os comandos e para fundamentar teoricamente o conteúdo apresentado.

- GEEKSFORGEEKS. **awk command in Unix/Linux with examples.** Disponível em: https://www.geeksforgeeks.org/awk-command-unixlinux-examples/. Acesso em: 24 aug. 2024.

- KODEKLOUD. **EOF in Bash**. Disponível em: https://kodekloud.com/blog/eof-bash/. Acesso em: 25 ago. 2024.

- LEARN LINUX TV. **How to use awk to process CSV files.** YouTube, 3 ago. 2021. Disponível em: https://youtu.be/oPEnvuj9QrI. Acesso em: 24 ago. 2024.

- LINUXHELP. **How to schedule a Cron Job to run a script on Ubuntu 16.04**. YouTube, 8 jun. 2018. Disponível em: https://www.youtube.com/watch?v=CIVI-DIzCFk. Acesso em: 26 ago. 2024.

- PRACIANO, Elias. **Como adicionar a data atual ao nome de um arquivo no Bash.** 2017. Disponível em: https://elias.praciano.com/2017/04/como-adicionar-a-data-atual-ao-nome-de-um-arquivo-no-bash/#:~:text=Acompanhe%20mais%20alguns%20exemplos%20de,%2C%20hoje%3A%20%24nomearquivo. Acesso em: 24 ago. 2024.

- TOTVS DEVELOPERS. **Entendendo o crontab. Medium, 20 set. 2020**. Disponível em: https://medium.com/totvsdevelopers/entendendo-o-crontab-607bc9f00ed3. Acesso em: 26 ago. 2024.

- WDEV. **Cron, crontab e cronjob: agendando tarefas automáticas**. YouTube, 10 dez. 2020. Disponível em: https://youtu.be/TG--rQkZvGc. Acesso em: 26 de ago. 2024.