# Usa-se para comentários
# ctrl + enter = executar uma tarefa
# ctrl + f = executar uma tarefa

### OPERAÇÕES BÁSICAS MATEMÁTICAS ###
#adição: +
4+5

#subtração: -
4-5

#multiplicação: *
4*5

#divisão: /
20/4

#exponenciação: ^ ou **
4^2
4**2

#Resto da divisão: %%
2%%4

#raiz quadrada: sqrt()
sqrt(4)

# raiz de ordem mais elevada
8^(1/3)

#quociente da divisão: %/%
9%/%2

# diferente: !=

# como criar objetos (dummies)
x <- 0
(y <- (3*x-1)^2)

### VETORES ###
# criar uma sequência
vetor1 <- 1:6
vetor3 <- array(1:6)
## este é o vetor de valores de 1 a 6 ##

vetor2 <- c(2,4,3,5,6,8,1)
## este comando adciona um vetor com diversos valores aleatórios ##

## identificar um elemento do vetor
vetor3 [3]
## ex.: terceiro elemento do vetor 3 ##

vetor3 [3:6]
## ex.: terceiro até o sexto elemento do vetor 3 ##

x <- c(1,1,1,2,2,3,3,3,3,4,5,9,9,7,7,7)

### MATRIZES ###
# para criar matrizes: matrix ()
M <- matrix(1:6, nrow=2, ncol=3)
## matriz de 1 a 6 com 2 linhas e 3 colunas ##

# valor especifico da matriz
M[1,2]
## valor da primeira linha e da segunda coluna ##

M[2,]
## mostra todos os valores da segunda linha ##

M[,3]
## mostra todos os valores da terceira coluna ##

### DATAFRAME ###
## é usado para criar tabalas e se comunicar com excel ou bloco de notas ##
tabela1 <- data.frame (nome = c("Matheus","Mariana"), idade =c(28,23))

# mostrar os valores de uma coluna
tabela1$nome

# criar uma nova coluna
tabela1$salario <- c(1200)

# agregar valores por coluna e linha:  cbind e rbind, respectivamente
tabela <- cbind(tabela1, data.frame(casado = c(TRUE,FALSE)))

tabela <- rbind(tabela1, data.frame(nome = "marcela", idade = 27, salario = 4200))

### MOSTRAR OS OBJETOS QUE JA FORAM CRIADOS ###
ls()

### para remover algum objeto criado ###
remove(vetor1)
rm(vetor2)

### PACOTES ###
#instalar pacotes: install.packages("nome do pacote")
#carregar as funções do pacote: library("nome do pacote") ou require(nome do pacote)
install.packages("survey")
require(xlsx)

### DIRETÓRIO ###
#ver em qual pasta esta
getwd()

#mudar a pasta
setwd("C:/Users/Matheus/Desktop/matheus/R")

### ESTATÍSTICA DESCRITIVA ###
### MEDIDAS DE POSIÇÃO ###
#média: mean()
mean(vetor3)
mean(vetor3,na.rm=T)
##esse segundo comando desconsidera que há missings nas observações e faz a média apenas dos resultados #
# com informações ##
soma <- sum(vetor3)
n <- length(vetor3)
soma/n

#mediana: median()
median(vetor3)

#máximo
max(x)

#minimo
min(x)

### MEDIDAS DE DISPERSÃO ###
#variância: var()
var(x)

#desvio padrão: sd()
sd(x)

## lembrar de colocar na.rm=T se houver missings ##

#coeficiente de variação: cv
cv<-function(x){coef<-sd(x)/mean(x)*100
return(coef)}
cv(x)

## um cv acima de 30% indica que a amostra é hetogenea e há uma alta variação em torno da média ##
