#### Extraindo dados da PNAD ####

### Direncionando para a pasta com os dados ###
setwd("C:/Users/Matheus/Desktop/matheus/R/pnad_2015/Dados")         ## coloca o novo diretório #
options("scipen" = 8)            ## mostrar até 8 casas decimais#
dir()              ## mostra o que tem no diretório #

getwd()            ## ver em qual pasta esta #

### leitura dos dados ###
## ler o arquivo txt #
pes2015 <- read.fwf(file='PES2015.txt',
widths=c(4,2,11,1,8,3,3,1,9,1,42,1,1,65,4,5,2,157,12,418,5,1))



