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

#instala todos os outros pacotes necessários
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
pbr <- read.csv("C:/Users/Matheus/OneDrive/PDM/scripts/R/Séries/Petr4.csv")

# Criar colunas de mês e ano
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

# Transformando a base de dados em uma série temporal com ts
#lembre-se: as datas devem estar no formato yyyy-mm-dd
ZOO <- zoo(pbr$Close, order.by=as.Date(as.character(pbr$Date), format='%Y-%m-%d'))
pbr_ts <- ts(ZOO)
#conferir se se trata de uma série temporal
is.ts(pbr_ts)

# Explorar os dados
print(pbr_ts)
#Informa que se trata de uma série temporal que inicia em 1 e termina em 250, com uma frequência de 1

# Quantidade de elementos na base
length(pbr_ts)

# Mostra os primeiros elementos
head(pbr_ts,n=10)

# Mostra os ultimos elementos
tail(pbr_ts,n=10)

# Estatística descritiva
summary(pbr$close)

# desvio padrão
sd(pbr$close)

# Inicio e fim
start(pbr_ts)
end(pbr_ts)

# Numero de observações por unidade de tempo
frequency(pbr_ts)

# Gráficos
plot(pbr_ts,xlab="Dia",ylab="Preço de fechamento", main="PETR4 Closing Stock Prices")
plot(pbr_ts,xlab="Dia",ylab="Preço de fechamento", main="PETR4 Closing Stock Prices", type="b")

ggplot(pbr, aes(Dates, Close)) + geom_point(color = "navyblue") +
  facet_wrap( ~ month) + ylab("Preço") +
  xlab("Dia")

# limpar possíveis outlyers e missings
pbr_tss = ts(pbr[,c("Close")])
pbr$Close_clean = tsclean(pbr_tss)

ggplot() + geom_line(data = pbr, aes(x = Dates, y = Close_clean)) +
  ylab("Preço limpo") +
  xlab("Dia")

ggplot() + geom_line(data = pbr, aes(x = Dates, y = Close)) +
  ylab("Preço limpo") +
  xlab("Dia")
#nada mudou para o caso das ações, ao que parece, esse tipo d e dado é mais limpo

# Gráfico com médias móveis mensais e semanais
pbr$cnt_ma7 = ma(pbr$Close, order = 7)
pbr$cnt_ma30 = ma(pbr$Close, order = 30)
ggplot() + geom_line(data = pbr, aes(x = Dates, y = Close, colour = "Preço")) +
  geom_line(data = pbr, aes(x = Dates, y = cnt_ma7, colour = "Média Móvel 7")) +
  geom_line(data = pbr, aes(x = Dates, y = cnt_ma30, colour = "Média Móvel 30")) +
  ylab("Preço") +
  xlab("Dia")


# Candles
pbr[,1] <- as.Date(pbr[,1])
pbr <- xts(pbr[, -1], order.by=as.POSIXct(pbr$Date))# transforma a primeira coluna em data
pbr <- xts(pbr) #para transformar a base do tipo data frame em xts
chartSeries(pbr, subset="last 3 months")
chart_Series(pbr)

pbr <- read.csv("C:/Users/Matheus/OneDrive/PDM/scripts/R/Séries/Petr4.csv")

#Esses gráficos são interessantes para captar possível tendência, sazonalidade, quebras etc.

################################################
# Uma série temporal tem várias características:
# -pode ter uma tendência ao longo do tempo (valores crescentes ou decrescentes).
# -pode apresentar ciclicidade ou sazonalidade (ciclo de repetição durante um período). 
# Existe um padrão sazonal quando uma série é influenciada por fatores sazonais.
# -Correlação serial entre observações subsequentes.
# -Componente irregular, que é chamado de Ruído Branco. Esta é a variação aleatória não explicada por nenhum outro fator.
# White Noise é um processo estacionário com uma média e variância constantes.
################################################

## DECOMPOSIÇÃO
plot(as.ts(pbr_ts))

# Aplicando ln
p_pbr <- pbr$Close
l_p_pbr <- log(p_pbr)

# tendência
trend_pbr = ma(p_pbr, order = 4, centre = T)
plot(as.ts(p_pbr))
lines(trend_pbr)
plot(as.ts(trend_pbr))

# sazonalidade
detrend_pbr = p_pbr - trend_pbr
plot(as.ts(detrend_pbr))

# média e sazonalidade
m_pbr = t(matrix(data = detrend_pbr, nrow = 4))
seasonal_pbr = colMeans(m_pbr, na.rm = T)
plot(as.ts(rep(seasonal_pbr,16)))

# componente aleatório
random_pbr = p_pbr - trend_pbr - seasonal_pbr
plot(as.ts(random_pbr))

# unir os quatro aspectos em um gráfico
ts_pbr = ts(p_pbr, frequency = 4)
decompose_pbr = decompose(ts_pbr, "multiplicative") # pode-se substituir o additive por multiplicative

plot(as.ts(decompose_pbr$seasonal))
plot(as.ts(decompose_pbr$trend))
plot(as.ts(decompose_pbr$random))
plot(decompose_pbr)

## Estacionariedade

################################################
# características de uma série estacionária:
# -Tem uma média constante ao longo do tempo.
# -Tem uma variância constante ao longo do tempo.
# -Autocorrelação permanece a mesma ao longo do tempo.
# A autocorrelação é uma situação em que os dados da série temporal são influenciados 
# por seus próprios valores históricos.

# Motivos de se querer estacionariedade:
# a) previsão:
# -a ideia é que você possa assumir que suas propriedades estatísticas permanecerão as mesmas no futuro como no passado!
# b) propriedade estatísticas:
# -ajuda a obter estatísticas amostrais importantes, como médias, variâncias e correlações com outras variáveis.
################################################

# Formas de estabilizar a série:
# Aplicando ln
pbr_linear<-log(pbr_ts)
plot.ts(pbr_linear, main="Daily Stock Prices (log)", ylab="Price", col=4)

# Removendo a tendência
pbr_linear_diff <- diff(pbr_linear)
plot.ts(pbr_linear_diff, main="Daily Stock Prices (log)", ylab="Price", col=4)

# Correlação entre a série defasada e a atual
plot(pbr_ts[-250],pbr_ts[-1],main="Scatterplot (lag=1)")
abline(lm(pbr_ts[-1] ~ pbr_ts[-250]),col=4)

# Corelação entre a série atual e a defasada em 1 período
cor(pbr_ts[-250],pbr_ts[-1])

# Corelação entre a série atual e a defasada em 2 períodos
cor(pbr_ts[-(249:250)],pbr_ts[-(1:2)])

# FAC
acf(pbr_ts, lag.max=50, plot=FALSE)
acf(pbr_ts, lag.max=50)

# FACP
pacf(pbr_ts, lag.max=50)

# FAC e a FACP
tsdisplay(pbr_ts)
#A trama ACF mostra decadência lenta de lag para 0 indicando um modelo AR.
#O gráfico PACF sugere modelo AR da ordem 1 AR(1) como número PACF está perto de 
#0 após lag 1.

#### Estimando modelos
## Ruído Branco
pbr_rb <- arima(pbr_ts, order = c(0, 0, 0))
pbr_rb

##################
##### AR
# Modelo auto regressivo
pbr_ar <- arima(pbr_ts , order = c(6, 0, 0))
pbr_ar

# Ver a classe dos resíduos
summary(pbr_ar)

# Extrair os resíduos
residuals <- residuals(pbr_ar)

# Extrair o modelo estimado
pbr_estimado <- pbr_ts - residuals

# Comparação do modelo estimado com o real
ts.plot(pbr_ts)
points(pbr_estimado, type = "l", col = 20, lty = 2)

# Previsão do modelo
pbr_forecast <- predict(pbr_ar, n.ahead = 20)
pbr_forecast

# Extrair a média e desvio padrão da previsão
pbr_forecast_values <- pbr_forecast$pred
pbr_forecast_se <- pbr_forecast$se

# Gráfico de previsão
plot.ts(pbr_ts, xlim = c(0, 270), ylim = c(10,30))
points(pbr_forecast_values , type = "l", col = 2)
points(pbr_forecast_values - 2*pbr_forecast_se, type = "l", col = 4, lty = 2)
points(pbr_forecast_values + 2*pbr_forecast_se, type = "l", col = 4, lty = 2)

mae(pbr_ts, pbr_estimado)

##################
##### MA
# Modelo média móvel
pbr_ma <- arima(pbr_ts , order = c(0, 0, 8))
pbr_ma

# Extrair os resíduos
residuals <- residuals(pbr_ma)

# Extrair o modelo estimado
pbr_estimado <- pbr_ts - residuals

# Comparação do modelo estimado com o real
ts.plot(pbr_ts)
points(pbr_estimado, type = "l", col = 2, lty = 2)

###### SE A ESTIMAÇÃO NÃO FOR BOA ISSO PODE SER QUE A SÉRIE NÃO É ESTACIONÁRIA E 
###### É NECESSÁRIO ESTACIONARIZA-LA
pbr_ma <- arima(pbr_ts, order = c(0, 1, 8))
residuals <- residuals(pbr_ma)
pbr_estimado <- pbr_ts - residuals
ts.plot(pbr_ts)
points(pbr_estimado, type = "l", col = 2, lty = 2)

# Previsão do modelo
pbr_forecast <- predict(pbr_ma, n.ahead = 20)
pbr_forecast

# Extrair a média e desvio padrão da previsão
pbr_forecast_values <- pbr_forecast$pred
pbr_forecast_se <- pbr_forecast$se

# Gráfico de previsão
plot.ts(pbr_ts, xlim = c(0, 270), ylim = c(10,30))
points(pbr_forecast_values , type = "l", col = 2)
points(pbr_forecast_values - 1*pbr_forecast_se, type = "l", col = 4, lty = 2)
points(pbr_forecast_values + 1*pbr_forecast_se, type = "l", col = 4, lty = 2)

##################
##### ARIMA
# Identificar a ordem de estacionariedade
adf.test(pbr_ts)
#se o p-valor for maior que 0.05 indica que a série é não estacionária e deve ser diferenciada

# Modelo arima
pbr_arima <- arima(pbr_ts , order = c(7, 1, 7))
pbr_arima

# Extrair os resíduos
residuals <- residuals(pbr_arima)

# Extrair o modelo estimado
pbr_estimado <- pbr_ts - residuals

# Comparação do modelo estimado com o real
ts.plot(pbr_ts)
points(pbr_estimado, type = "l", col = 2, lty = 2)

# Previsão do modelo
pbr_forecast <- predict(pbr_arima, n.ahead = 3)
pbr_forecast

# Extrair a média e desvio padrão da previsão
pbr_forecast_values <- pbr_forecast$pred
pbr_forecast_se <- pbr_forecast$se

# Gráfico de previsão
plot.ts(pbr_ts, xlim = c(0, 270), ylim = c(10,30))
points(pbr_estimado, type = "l", col = 2, lty = 2)
points(pbr_forecast_values , type = "l", col = 2)
points(pbr_forecast_values - 1*pbr_forecast_se, type = "l", col = 4, lty = 2)
points(pbr_forecast_values + 1*pbr_forecast_se, type = "l", col = 4, lty = 2)

mae(pbr_ts, pbr_estimado)

# Automatização do arima
# Esse modelo sugere a melhor forma funcional de acordo com os critérios AIC, BIC etc.
pbr_auto <- auto.arima(pbr_ts)
pbr_auto

pbr_fit <- arima(pbr_ts, order = c(0, 1, 0))
pbr_forecast <- predict(pbr_fit , n.ahead = 20)
pbr_forecast_values <- pbr_forecast$pred
plot.ts(pbr_ts, xlim = c(50, 260), ylim = c(10,30))
points(pbr_forecast_values , type = "l", col = 2)