## teclas de atalho: 
# "Help" -> "Keyboard Shortcuts"
#CTRL + L: Limpa o console

## para pedir ajuda sobre uma fun��o
# ?"nome da fun��o"
?mean
help(mean)

## busca por texto
# EX.: necessidade de gerar n�meros aleat�rios de uma distribui��o normal multivariada, 
# mas n�o se recorda o comando.
??"normal distribution"
help.search("normal distribuition")

## carregar pacote
# � necess�rio carregar um pacote antes para utilizar suas fun��es
library(MASS) #carrega o pacote

# ver os pacotes carregados 
search()

# descarregar um pacote

## INSTALAR/DELETAR PACOTE
# instalar
install.packages("nome do pacote")

# desinstalar
update.packages("nome do pacote")

# instalar diversos pacotes
install.packages(c("AER","lmtest","sem","car","ROCR","MASS","pscl","forecast","astsa","dynl
m","plm","sandwich","ggpplot2","pastecs","vars","urca","strucchange","foreign","aod"))

## Pacote que permite a visualiza��o di�ria dos verbetes do wikipedia
# instalar
install.packages("wikipediatrend")

# carregar o pacote
library(wikipediatrend)

# obter as visualiza��es
pageviews <-
  wp_trend(
    page = c("Coronavirus", "Fake") ,
    from = "2019-12-01",
    to   = "2020-24-03",
    lang=c("en"),
    file = "C:/Users/Matheus/Desktop/matheus/R/econometria/coronavirus"
     )
#**# est� dando erro (voltar nesse pacote), parece interessante

### COMANDOS DE MATEM�TICA
#o R faz c�lculo de n�meros diretamente
1+1

## ATRIBUINDO VALORES A UMA VARI�VEL
# atribuindo o valor 15 a x
x <- 3

#mostrando o valor
x

#uma express�o alg�brica
log(x+123)-sqrt(x)^exp(x/2)+factorial(5)
factorial(5)
-sqrt(x)^exp(x/2)

## C�LCULO VETORIAL
#nomeando um vetor
a <- c(3,4,5,8)
sort(a) #ordena os valores de a
length(a)
sum(a) #soma os valores de a
prod(a) #produt�rio

# vetor de m�dias de gols
medias <- c("100","200", "10", "2")
times <- c("galo","cru", "coelho", "coimbra")
names(medias)<-times
medias
#**# note que vari�veis textuais devem vir entre aspas

# pedir para mostrar os dados
medias[2]
medias[1:3]
medias["galo"]
medias[medias<20]

# trabalhar com uma matriz
k <- c(2,3,4,5,6,7)
A <- matrix(k,nrow = 3)
A
B <- matrix(k,nrow = 2)
B
C <- matrix(k,ncol = 3)
C

#  criar diferentes vetores e unifica-los em um objeto matriz
k <- c(2,3,4,5,6,7)
v <- c(4,4,2,1,7,8)
z <- c(4,5,2,3,33,1,0,0)
# os vetores s�o transformados em linhas de uma matriz
uau <- rbind(k,v,z)
uau
# os vetores s�o transformados em colunas de uma matriz
wow <- cbind(k,v,z)
wow

# opera��es com matrizes
oia <- rbind(z,-v,k)
oia+uau
oia*uau
aio<-t(oia)
aio
(dado<-aio%*%oia) #ao colocarmos o comando entre par�nteses, o resultado � automaticamente mostrado no console
banana<-matrix(c(2,3,4,5),nrow = 2)
solve(banana)

# lista de elementos de diferentes tipos
listinha<-list(A=seq(2,3,1), oi="io")
listinha
names(listinha)
listinha$A

### DATA FRAME
# � considerado a base de dados no R. Como um planilha no excel. 
# � semelhante a uma matriz mas as suas colunas t�m nomes e podem conter dados de tipo diferente
# Cada linha corresponde a um registo (linha) da tabela.
v1<-c(10,2,11,-4)
v2<-c(1,2,3,4)
semana<-c(1,2,3,4)
vendas<-cbind(v1,v2)
rownames(vendas)<-semana
vendas
vendasnovo<-as.data.frame(vendas)
vendasnovo

vendasnovo$v1

### PLOTAR GR�FICO 
# Ex.: dos n�meros de 1 a 10
plot(1:10)

## DIAGRAMA DE DISPERS�O E A RETA DE REGRESS�O
plot(vendasnovo$v1, vendasnovo$v2, main="diagrama de dispers�o",
     xlab="v1", ylab = "v2",pch=19)
abline(lm(v1~v2,data=vendasnovo), col="red")

### REMOVER OBJETOS CRIADOS
remove(x)

### IMPORTAR DADOS 
## primeiro � necess�rio falar onde esta o arquivo
# saber onde esta o diret�rio
getwd()

#mudar o diret�rio
setwd("C:/Users/Matheus/Desktop/matheus/R/econometria/planilhas_minicurso_2016")

## XLSX
# instalar o pacote para puxar o arquivo xlsx
install.packages("openxlsx")
library("openxlsx")

# carregar a planilha 
jap<- read.xlsx("C:/Users/Matheus/Desktop/matheus/R/econometria/planilhas_minicurso_2016/japao.xlsx")
jap
#**# uma alternativa a jap � head(jap)

## Carregar manualmente
file.choose()

### GR�FICOS
## esse � um gr�fico de dispers�o mais trabalhado
library(ggplot2)
ggplot(jap, aes(x=gdp_growth, y=gangster_growth)) + 
  geom_point(shape=1) + #bolinhas
  geom_smooth(method=lm) + #reta de regress�o (default 95%)
  ggtitle("o crime compensa?")

### ESTAT�STICA DESCRITIVA
## Carregar uma base
library(AER) #essa � uma base, Affairs, no pacote AER, sobre casos extra-conjugais
data("Affairs")
view(Affairs) #visualiza a base de dados em uma planilha
summary(Affairs) #fornece a estat�stica descritiva dos dados da base
library(pastecs) #fornece a estat�stica descritiva dos dados da base
stat.desc(Affairs) #fornece a estat�stica descritiva dos dados da base

#**# a vari�vel affair se refere ao n�mero de casos extraconjugais do indiv�duo no ano anterior

## Frequ�cia
(table(Affairs$affairs)) #mostra a frequ�ncia da vari�vel affairs na base de dados Affairs

prop.table(table(Affairs$affairs)) #mostra a frequ�ncia relativa da vari�vel affairs na base de dados Affairs

## Histograma
hist(Affairs$affairs)
hist(Affairs$affairs, freq=FALSE)
lines(density(Affairs$affairs), lwd=3) #sobrep�e a densidade ao histograma (lwd se refere a espessura da linha)

## Tabela de conting�ncia entre affairs e children
contingencia <- table(Affairs$affairs, Affairs$children)
contingencia

prop.table(contingencia,margin = 1)
prop.table(contingencia,margin = 2)
#**# mostra a propor��o de individuos com determinada caracter�stica que possuiam outra caracteristica

## Gr�fico de barras
barplot(table(Affairs$yearsmarried), horiz=TRUE, main= "Distribui��o dos Anos de Casado")

## Gr�fico de dispers�o
plot(Affairs$age, Affairs$yearsmarried)

### MODELO DE REGRESS�O LINEAR (MQO)
#**# o modelo aqui utilizado se refere a equa��o de consumo
library(AER)
data("USMacroG")
plot(USMacroG[, c("dpi", "consumption")], lty = c(3, 1), plot.type = "single", ylab= "")
legend("topleft", legend = c("income", "consumption"), lty = c(3, 1), bty = "n")

## Mostrar quantas observa��es para uma vari�vel
length("consumption")

## Estima��o da fun��o consumo keynesiana tradicional
cons_key <- lm(consumption ~dpi, data=USMacroG)
summary(cons_key)

# Gr�ficos da regress�o
summary(influence.measures(cons_key))
par(mfrow=c(3,3))
plot(cons_key, which=1:6)

#**# outra maneira de observar os pontos de influ�ncia
influenceIndexPlot(cons_key,vars=c("Cook", "hat"), id.n=3)
#**# Segundo Bollen & Jackman (1990), pontos com dist�ncias de Cook 
#**# acima de 4/n (n = tamanho da amostra) devem ser analisados com cautela. 


# n� de obs usadas na regress�o
nobs(cons_key)

#informa os nomes dos componentes do objeto cons_key
names(cons_key)
cons_key$coefficients
cons_key$residuals
#**# facilita manipula��es posteriores como a constru��o de testes de hip�tese manualmente

# Teste de Breusch-Godfrey
bgtest(cons_key)

# Teste de Box-Ljung
Box.test(residuals(cons_key),type="Ljung-Box")

# Teste de Breusch Pagan
bptest(cons_key)

#Teste RESET
reset(cons_key)
#**# esses 4 testes testam a heterocedasticidade
#**# se a hetero for verificada � necess�rio um modelo com erros robustos

# Teste de estacionariedade BW
dwtest(cons_key)
#**# H� evid�ncias de n�o-estacionaridade, medida pela aplica��o da regra de bolso ("R2 > DW")

## Regress�o da fun��o keynesiana simples com erros robustos
coeftest(cons_key, vcocv=VCOVHC, type="HC4")

## Estima��o da fun��o consumo de renda permanente (na qual a renda permanente esperada segue um ajuste de Koyck)
install.packages("dynlm")
library("dynlm")
cons_rp <- dynlm(consumption ~dpi + L(consumption)-1, data=USMacroG)
summary(cons_rp)

# Gr�ficos da regress�o
summary(influence.measures(cons_rp)) #detecta pontos de influ�ncia e, logo, � ecess�rio rodar a regress�o com erros padr�es robustos
par(mfrow=c(3,3))
plot(cons_rp, which=1:6)

## Estima��o da fun��o consumo com forma��o de h�bitos (o consumo � que segue uma movimenta��o no tempo ao estilo das defasagens de Koyck)
cons_hab <- dynlm(consumption ~dpi + L(consumption),na.action = NULL, data=USMacroG)
summary(cons_hab)

# Gr�ficos da regress�o
summary(influence.measures(cons_hab))
par(mfrow=c(3,3))
plot(cons_hab, which=1:6)


### Sistemas de equa��es (simult�neas ou resursivas)
#**# O numero de observa��es dos modelos devem ser o mesmo
#**# portanto deve-se alinhar conjuntamente as vari�veis, eli-
#**# minando as c�lulas vazias, para depois fazer as regress�es.

## Gerar vari�veis defasadas no R
#**# A vantagem dessa abordagem est� na compara��o de regress�es por meio
#**# de testes de Wald. A desvantagem � o cuidado com os nomes das vari�veis.
# Decretar que se trata de uma s�rie temporal
cons<-as.ts(USMacroG[, "consumption"])
dpi<- as.ts(USMacroG[, "dpi"])
# Gerar as defasagens das vari�veis
conslag=lag(cons,-1)
dpilag=lag(dpi,-1)
# Alinhamos conjuntamente (tie) as vari�veis previamente
consbi=ts.intersect(cons, conslag)
dpibi =ts.intersect(dpi, dpilag)
consbi

# Compara��o entre as fun��es keynesiana, renda permanente e consumo com h�bito
cons_keyn<-lm(consbi[,1]~dpibi[,1])
cons_rpn <-lm(consbi[,1]~dpibi[,1] + consbi[,2]-1)
cons_habn <-lm(consbi[,1]~dpibi[,1]+consbi[,2])
summary(cons_keyn)
summary(cons_rpn)
summary(cons_habn)

## Teste de Wald para comparar os tr�s modelos
waldtest(cons_rpn, cons_habn, cons_keyn)

## teste Type I ANOVA
anova(cons_habn)

### MQ2E E VARI�VEIS INSTRUMENTAIS
## Carregar pacotes e dados
library(AER)
library(sem)
library(lmtest)
data("CollegeDistance")
cd.d<-CollegeDistance

## Teste de correla��o com os poss�veis instrumentos
corr_variaveis = data.frame(cbind(cd.d$education,cd.d$distance,cd.d$score))
colnames(corr_variaveis)=cbind("education","distance","score")
cor(corr_variaveis)

## Manualmente
#**# 1� est�gio (VI para educa��o)
reg.simples<-lm(education~urban+gender+ethnicity+unemp+distance, data=cd.d)
summary(reg.simples)

# salvar a VI
cd.d$ed.pred<- predict(reg.simples)

#**# 2� est�gio
segundo.estagio<-lm(wage~urban+gender+ethnicity+unemp+ed.pred, data=cd.d)
summary(segundo.estagio)

## Vari�veis Instrumentais (IV)
m<-ivreg(formula=wage~urban+gender+ethnicity+unemp+education | urban+gender+ethnicity+unemp+distance, data=cd.d)
summary(m)

## MQ2E
m2 <- tsls(wage ~ urban + gender + ethnicity + unemp + education,
           ~ urban + gender + ethnicity + unemp + distance, data = cd.d)
summary(m2)

## Com mais instrumentos
reg2<-lm(education~urban+gender+ethnicity+unemp+distance+score, data=cd.d)
summary(reg2)