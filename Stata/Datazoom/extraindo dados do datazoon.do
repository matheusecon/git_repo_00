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
****// Uma nova janela abrir� automaticamente
****// Exemplo: Viewer - net describe datazoom_censo
****// Clique no link de instala��o
****// (click here to install)

*** Esse processo deve ser repetido para cada pacote de interesse.
*** Uma vez instalado,n�o � necess�rio reinstalar a cada nova utiliza��o do computador.

****// Recomenda-se a utiliza��o por interface gr�fica. 

**** PARA ACESSAR A CAIXA DE DI�LOGO
db datazoom_pmenova

*** colar em "dados originais" o endereço da pasta com os arquivos txt
*** colar em "salvar" o endereço da pasta onde os arquivos dta serão salvos

****// Exemplo: db datazoom_censo

**** PARA ACESSAR O HELP
help datazoom_pmenova

***// Exemplo: h datazoom_censo

***// Para empilhar as bases de dados
