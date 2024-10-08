## Financial time series data

# senha quandl: Gmr4qyyw_2tsYEd9fCSh

# remover objetos
rm("diffPETR4.SA", "pbr_ret")
rm(list= ls()) ## remove todos os objetos

#Instalar e carregar pacotes
library(tseries)
library(Quandl)
library(readr)
library(zoo)
library(XLConnect)
library(lubridate)
library(ggplot2)
library(stats)
library(forecast)
library(xts)
library(dplyr)
library(quantmod)
library(MASS)
library(wikipediatrend)
library(openxlsx)
library(AER)
library(dynlm)
library(sem)
library(lmtest)
library(astsa)
library(fpp)
library(Ecdat)
library(Metrics)
library(forecast)
library(rio)
library(readxl)
library(ggplot2)
library(tidyverse)


#instala o pacote
install.packages("tidyverse")

#instala todos os outros pacotes necess�rios
install_formats("rio")

############################
# Carregar dados com pacote quandl
#Quandl.api_key("Gmr4qyyw_2tsYEd9fCSh")
#msft_data <- Quandl.datatable("WIKI/PRICES" ,
#                              qopts.columns=c("date", "close"),
#                              ticker=c("MSFT"),
#                              date.gte=c("2016-01-01"),
#                              date.lte=c("2016-12-31"))
#ZOO <- zoo(msft_data$close, order.by=as.Date(as.character(msft_data$date), format='%Y-%m-%d'))
#msft_ts <- ts(ZOO)
############################

# Carregar dados
pbr <- read.csv("C:/Users/Matheus/OneDrive/PDM/scripts/R/S�ries/Petr4.csv")

# Criar colunas de m�s e ano
pbr$Dates <- as.Date(pbr[,"Date"])
pbr[, "year"] <- format(pbr[,"Dates"], "%Y")
pbr[, "month"] <- format(pbr[,"Dates"], "%m")
pbr

# remover colunas do dataframe
#pbr$Open <- NULL
#pbr$High <- NULL
#pbr$Close <- NULL
#pbr$Volume <- NULL
#pbr$Low <- NULL

# renomear coluna
#names(pbr)[1:2] <- c("date", "close")

# Transformando a base de dados em uma s�rie temporal com ts
#lembre-se: as datas devem estar no formato yyyy-mm-dd
ZOO <- zoo(pbr$Close, order.by=as.Date(as.character(pbr$Date), format='%Y-%m-%d'))
pbr_ts <- ts(ZOO)
#conferir se se trata de uma s�rie temporal
is.ts(pbr_ts)

# Explorar os dados
print(pbr_ts)
#Informa que se trata de uma s�rie temporal que inicia em 1 e termina em 250, com uma frequ�ncia de 1

# Quantidade de elementos na base
length(pbr_ts)

# Mostra os primeiros elementos
head(pbr_ts,n=10)

# Mostra os ultimos elementos
tail(pbr_ts,n=10)

# Estat�stica descritiva
summary(pbr$close)

# desvio padr�o
sd(pbr$close)

# Inicio e fim
start(pbr_ts)
end(pbr_ts)

# Numero de observa��es por unidade de tempo
frequency(pbr_ts)

# Gr�ficos
plot(pbr_ts,xlab="Dia",ylab="Pre�o de fechamento", main="PETR4 Closing Stock Prices")
plot(pbr_ts,xlab="Dia",ylab="Pre�o de fechamento", main="PETR4 Closing Stock Prices", type="b")

ggplot(pbr, aes(Dates, Close)) + geom_point(color = "navyblue") +
  facet_wrap( ~ month) + ylab("Pre�o") +
  xlab("Dia")

# limpar poss�veis outlyers e missings
pbr_tss = ts(pbr[,c("Close")])
pbr$Close_clean = tsclean(pbr_tss)

ggplot() + geom_line(data = pbr, aes(x = Dates, y = Close_clean)) +
  ylab("Pre�o limpo") +
  xlab("Dia")

ggplot() + geom_line(data = pbr, aes(x = Dates, y = Close)) +
  ylab("Pre�o limpo") +
  xlab("Dia")
#nada mudou para o caso das a��es, ao que parece, esse tipo d e dado � mais limpo

# Gr�fico com m�dias m�veis mensais e semanais
pbr$cnt_ma7 = ma(pbr$Close, order = 7)
pbr$cnt_ma30 = ma(pbr$Close, order = 30)
ggplot() + geom_line(data = pbr, aes(x = Dates, y = Close, colour = "Pre�o")) +
  geom_line(data = pbr, aes(x = Dates, y = cnt_ma7, colour = "M�dia M�vel 7")) +
  geom_line(data = pbr, aes(x = Dates, y = cnt_ma30, colour = "M�dia M�vel 30")) +
  ylab("Pre�o") +
  xlab("Dia")


# Candles
pbr[,1] <- as.Date(pbr[,1])
pbr <- xts(pbr[, -1], order.by=as.POSIXct(pbr$Date))# transforma a primeira coluna em data
pbr <- xts(pbr) #para transformar a base do tipo data frame em xts
chartSeries(pbr, subset="last 3 months")
chart_Series(pbr)

pbr <- read.csv("C:/Users/Matheus/OneDrive/PDM/scripts/R/S�ries/Petr4.csv")

#Esses gr�ficos s�o interessantes para captar poss�vel tend�ncia, sazonalidade, quebras etc.

################################################
# Uma s�rie temporal tem v�rias caracter�sticas:
# -pode ter uma tend�ncia ao longo do tempo (valores crescentes ou decrescentes).
# -pode apresentar ciclicidade ou sazonalidade (ciclo de repeti��o durante um per�odo). 
# Existe um padr�o sazonal quando uma s�rie � influenciada por fatores sazonais.
# -Correla��o serial entre observa��es subsequentes.
# -Componente irregular, que � chamado de Ru�do Branco. Esta � a varia��o aleat�ria n�o explicada por nenhum outro fator.
# White Noise � um processo estacion�rio com uma m�dia e vari�ncia constantes.
################################################

## DECOMPOSI��O
count_ma = ts(na.omit(pbr$cnt_ma7), frequency = 30)
decomp = stl(count_ma, s.window="periodic")
deseasonal_cnt <- seasadj(decomp)
plot(decomp)


## Estacionariedade

################################################
# caracter�sticas de uma s�rie estacion�ria:
# -Tem uma m�dia constante ao longo do tempo.
# -Tem uma vari�ncia constante ao longo do tempo.
# -Autocorrela��o permanece a mesma ao longo do tempo.
# A autocorrela��o � uma situa��o em que os dados da s�rie temporal s�o influenciados 
# por seus pr�prios valores hist�ricos.

# Motivos de se querer estacionariedade:
# a) previs�o:
# -a ideia � que voc� possa assumir que suas propriedades estat�sticas permanecer�o as mesmas no futuro como no passado!
# b) propriedade estat�sticas:
# -ajuda a obter estat�sticas amostrais importantes, como m�dias, vari�ncias e correla��es com outras vari�veis.
################################################

# teste adf para a m�dia m�vel
adf.test(count_ma, alternative = "stationary")
#h1 = estacionariedade, uma vez que se sabe que a s�rie �
#n�o estacion�ria
#se atenha ao lag order, � a quantidade de ar da s�rie. no caso, igual a 6.

# Correla��o entre a s�rie defasada e a atual
plot(pbr_ts[-250],pbr_ts[-1],main="Scatterplot (lag=1)")
abline(lm(pbr_ts[-1] ~ pbr_ts[-250]),col=4)

# Corela��o entre a s�rie atual e a defasada em 1 per�odo
cor(pbr_ts[-250],pbr_ts[-1])

# Corela��o entre a s�rie atual e a defasada em 2 per�odos
cor(pbr_ts[-(249:250)],pbr_ts[-(1:2)])

# FAC e a FACP
tsdisplay(count_ma)
#A trama ACF mostra decad�ncia lenta de lag para 0 indicando um modelo AR.
#O gr�fico PACF sugere modelo AR da ordem 1 AR(1) como n�mero PACF est� perto de 
#0 ap�s lag 1.

# Aplica-se a o operador de diferen�a para ver se a s�rie se torna estacion�ria
count_d1 = diff(deseasonal_cnt, differences = 1)
plot(count_d1)

adf.test(count_d1, alternative = "stationary")
tsdisplay(count_d1)

#Note que tivemos que estacionarizar a s�rie apenas uma vez para que 
#ela se torne estacionaria e logo essa � a ordem de integra��o da s�rie
 
##########################
# Modelo Arima
fit <- auto.arima(deseasonal_cnt, seasonal=FALSE)
fit
tsdisplay(residuals(fit), lag.max=45, main = '(1,1,1) Model Residuals')
  
#note que o modelo ainda parece apresentar o lag igual a 6

fit2 = arima(deseasonal_cnt, order=c(2,1,7))
tsdisplay(residuals(fit2), lag.max=45, main = 'Seasonal Model Residuals')

# Previs�o
fcast <- forecast(fit2, h=30)
plot(fcast)

# Teste do modelo com uma valida��o
hold <- window(ts(deseasonal_cnt), start=200)
fit_no_holdout = arima(ts(deseasonal_cnt[-c(200:244)]), order=c(2,1,7))
fcast_no_holdout <- forecast(fit_no_holdout,h=45)
plot(fcast_no_holdout, main=" ")
lines(ts(deseasonal_cnt))

# Deve-se trazer a sazonalidade de volta para o modelo
fit_w_seasonality = auto.arima(deseasonal_cnt, seasonal=TRUE)
seas_fcast <- forecast(fit_w_seasonality,h=45)
plot(seas_fcast)

lines(ts(count_ma))
lines(ts(deseasonal_cnt))

#### Estimando modelos
## Ru�do Branco
pbr_rb <- arima(pbr_ts, order = c(0, 0, 0))
pbr_rb

##################
##### AR
# Modelo auto regressivo
pbr_ar <- arima(pbr_ts , order = c(6, 0, 0))
pbr_ar

# Ver a classe dos res�duos
summary(pbr_ar)

# Extrair os res�duos
residuals <- residuals(pbr_ar)

# Extrair o modelo estimado
pbr_estimado <- pbr_ts - residuals

# Compara��o do modelo estimado com o real
ts.plot(pbr_ts)
points(pbr_estimado, type = "l", col = 20, lty = 2)

# Previs�o do modelo
pbr_forecast <- predict(pbr_ar, n.ahead = 20)
pbr_forecast

# Extrair a m�dia e desvio padr�o da previs�o
pbr_forecast_values <- pbr_forecast$pred
pbr_forecast_se <- pbr_forecast$se

# Gr�fico de previs�o
plot.ts(pbr_ts, xlim = c(0, 270), ylim = c(10,30))
points(pbr_forecast_values , type = "l", col = 2)
points(pbr_forecast_values - 2*pbr_forecast_se, type = "l", col = 4, lty = 2)
points(pbr_forecast_values + 2*pbr_forecast_se, type = "l", col = 4, lty = 2)

mae(pbr_ts, pbr_estimado)

##################
##### MA
# Modelo m�dia m�vel
pbr_ma <- arima(pbr_ts , order = c(0, 0, 8))
pbr_ma

# Extrair os res�duos
residuals <- residuals(pbr_ma)

# Extrair o modelo estimado
pbr_estimado <- pbr_ts - residuals

# Compara��o do modelo estimado com o real
ts.plot(pbr_ts)
points(pbr_estimado, type = "l", col = 2, lty = 2)

###### SE A ESTIMA��O N�O FOR BOA ISSO PODE SER QUE A S�RIE N�O � ESTACION�RIA E 
###### � NECESS�RIO ESTACIONARIZA-LA
pbr_ma <- arima(pbr_ts, order = c(0, 1, 8))
residuals <- residuals(pbr_ma)
pbr_estimado <- pbr_ts - residuals
ts.plot(pbr_ts)
points(pbr_estimado, type = "l", col = 2, lty = 2)

# Previs�o do modelo
pbr_forecast <- predict(pbr_ma, n.ahead = 20)
pbr_forecast

# Extrair a m�dia e desvio padr�o da previs�o
pbr_forecast_values <- pbr_forecast$pred
pbr_forecast_se <- pbr_forecast$se

# Gr�fico de previs�o
plot.ts(pbr_ts, xlim = c(0, 270), ylim = c(10,30))
points(pbr_forecast_values , type = "l", col = 2)
points(pbr_forecast_values - 1*pbr_forecast_se, type = "l", col = 4, lty = 2)
points(pbr_forecast_values + 1*pbr_forecast_se, type = "l", col = 4, lty = 2)

##################
##### ARIMA
# Identificar a ordem de estacionariedade
adf.test(pbr_ts)
#se o p-valor for maior que 0.05 indica que a s�rie � n�o estacion�ria e deve ser diferenciada

# Modelo arima
pbr_arima <- arima(pbr_ts , order = c(7, 1, 7))
pbr_arima

# Extrair os res�duos
residuals <- residuals(pbr_arima)

# Extrair o modelo estimado
pbr_estimado <- pbr_ts - residuals

# Compara��o do modelo estimado com o real
ts.plot(pbr_ts)
points(pbr_estimado, type = "l", col = 2, lty = 2)

# Previs�o do modelo
pbr_forecast <- predict(pbr_arima, n.ahead = 3)
pbr_forecast

# Extrair a m�dia e desvio padr�o da previs�o
pbr_forecast_values <- pbr_forecast$pred
pbr_forecast_se <- pbr_forecast$se

# Gr�fico de previs�o
plot.ts(pbr_ts, xlim = c(0, 270), ylim = c(10,30))
points(pbr_estimado, type = "l", col = 2, lty = 2)
points(pbr_forecast_values , type = "l", col = 2)
points(pbr_forecast_values - 1*pbr_forecast_se, type = "l", col = 4, lty = 2)
points(pbr_forecast_values + 1*pbr_forecast_se, type = "l", col = 4, lty = 2)

mae(pbr_ts, pbr_estimado)

# Automatiza��o do arima
# Esse modelo sugere a melhor forma funcional de acordo com os crit�rios AIC, BIC etc.
pbr_auto <- auto.arima(pbr_ts)
pbr_auto

pbr_fit <- arima(pbr_ts, order = c(0, 1, 0))
pbr_forecast <- predict(pbr_fit , n.ahead = 20)
pbr_forecast_values <- pbr_forecast$pred
plot.ts(pbr_ts, xlim = c(50, 260), ylim = c(10,30))
points(pbr_forecast_values , type = "l", col = 2)