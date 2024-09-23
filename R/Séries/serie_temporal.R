##### SERIE TEMPORAL NO R #######
####//#### EX.: Ações da petrobras ####//####

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


# Lista todos objetos trabalhados all objects in the workspace
ls()

# remover objetos
rm("diffPETR4.SA", "pbr_ret")
rm(list= ls()) ## remove todos os objetos

#vizualizar base de dados
view(pbr)

# Ler os dados na forma irregular
## Note que os dados são diários e, claro, não existem valores para sábados e domingos.
#pbr <- read.zoo("C:/Users/Matheus/OneDrive/PDM/scripts/R/Séries/Petr4.csv", header=TRUE, sep=";" , format = "%Y-%m-%d")

# Importar dados
pbr <- read.csv("Petr4.csv")
# daria para usar esse apenas se os dados fossem regulares

# Renomear coluna

pbr[,1] <- as.Date(pbr[,1])
pbr <- xts(pbr[, -1], order.by=as.POSIXct(pbr$Date))# transforma a primeira coluna em data
pbr <- xts(pbr) #para transformar a base do tipo data frame em xts

# Estatística descritiva 
head(pbr) #mostra as primeiras linhas
tail(pbr) #mostra as últimas linhas
summary(pbr) #mostra a estatística descritiva
str(pbr) #

# Gráficos de candles
chartSeries(pbr, subset="last 3 months")
chart_Series(pbr)

#grafico
plot.xts(pbr$Adj.Close,major.format="%b/%d/%Y",
         main="PETR4.SA.",ylab="Close price.",xlab="Time.")

#Calcula o log-retorno.
pbr_ret <- diff(log(pbr[,5]))

#Plota a série temporal dos preços de fechamento
plot.xts(pbr$Adj.Close,major.format="%b/%d/%Y",
         main="PETR4.SA.",ylab="Log-return Close price.",xlab="Time")

# Estatistica descritiva
summary(pbr$Adj.Close)

# desvio padrão
sd(pbr$Adj.Close)

# decomposição 
plot(as.ts(pbr))

p_pbr <- pbr$Adj.Close
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

# Outra forma de decomposição
tsdisplay(l_p_pbr) #fornece a fac e a facp

#FAC
Acf(
  p_pbr,
  lag.max = NULL,
  type = c("correlation", "covariance", "partial"),
  plot = TRUE,
  na.action = na.contiguous,
  demean = TRUE,
)

#FACP
Pacf(
  p_pbr,
  lag.max = NULL,
  plot = TRUE,
  na.action = na.contiguous,
  demean = TRUE,
)


## Modelos de previsão (AR, ARMA, ARIMA, SARIMA)
## Modelo AR
pbr_ar <- arima(p_pbr , order = c(8, 0, 0))
pbr_ar

print(pbr_ar)

pbr_forecast <- predict(pbr_ar, n.ahead = 20)
pbr_forecast

pbr_forecast_values <- pbr_forecast$pred
pbr_forecast_se <- pbr_forecast$se

plot.ts(p_pbr, xlim = c(0, 300), ylim = c(40,80))
points(pbr_forecast_values , type = "l", col = 2)

## Modelo ARMA 
