********************************************************************************
*********************** TRABALHANDO COM O DATAZOON *****************************
********************************************************************************

**** para pegar o maximo de desempenho do stata
set more off
set memory 512m

**** PARA INSTALAR O DATAZOON E PODER ACESSAR AS DIVERSAS BASES DE DADOS CONTIDAS NO PROGRAMA
net from http://www.econ.puc-rio.br/datazoom/portugues

****// Clique no pacote da pesquisa de interesse
****// Exemplo: datazoom_pmenova
****// Uma nova janela abrirá automaticamente
****// Exemplo: Viewer - net describe datazoom_censo
****// Clique no link de instalação
****// (click here to install)

*** Esse processo deve ser repetido para cada pacote de interesse.
*** Uma vez instalado,não é necessário reinstalar a cada nova utilização do computador.

****// Recomenda-se a utilização por interface gráfica. 

**** PARA ACESSAR A CAIXA DE DIÁLOGO
db datazoom_pmenova

*** colar em "dados originais" o endereÃ§o da pasta com os arquivos txt
*** colar em "salvar" o endereÃ§o da pasta onde os arquivos dta serÃ£o salvos

****// Exemplo: db datazoom_censo

**** PARA ACESSAR O HELP
help datazoom_pmenova

***// Exemplo: h datazoom_censo

***// Para empilhar as bases de dados
