#
#   Modelo ARIMA para o PIB do BRASIL (anual)
#
#     Série real, deflacionada, período 1961-2012

setwd(" ")


rm(list=ls())
graphics.off()

library(forecast)
library(TSA) 
#=======================================================================================

# Lendo dados da série de PIB brasileiro 1961-2012
#=======================================================================================
D <- read.table("pibrasil.txt", header=TRUE, sep = "")
pibra <- ts(D, start = 1961, frequency = 1)

# Verificação do gráfico e da ACF
#=======================================================================================
ts.plot(pibra, main = "PIB Brasileiro")
acf(pibra, drop.lag.0 = T, lag=36)

# Teste Aumentado de Dickey-Fuller
#=======================================================================================
# ur.df(y, type = c("none", "drift", "trend"), lags = 1, selectlags = c("Fixed", "AIC", "BIC"))
require(urca)
adf.pibra <- ur.df(y = pibra, type = c("trend"), lags = 10, selectlags = "BIC")
summary(adf.pibra)

d_pibra = diff(pibra)
plot(d_pibra)
adf.d_pibra <- ur.df(y = d_pibra, type = c("drift"), lags = 10, selectlags = "BIC")
summary(adf.d_pibra)

# Transformação de Box-Cox
#=======================================================================================
pibra1 <- window(d_pibra, end = c(1980))
pibra2 <- window(d_pibra, start = c(1983))
var.test(pibra2,pibra1)
pibra_tbc <- log(pibra)
plot(diff(pibra_tbc))

adf.pibra_tbc <- ur.df(y = diff(pibra_tbc), type = c("drift"), lags = 10, selectlags = "BIC")
summary(adf.pibra_tbc)
PP.test(diff(pibra_tbc))

# Calculando as Funções de Autocorrelação e Autocorrelação Parcial
#=======================================================================================
acf(diff(pibra_tbc), drop.lag.0 = T)
pacf(diff(pibra_tbc))

# Estimação Modelo ARIMA(2,1,0)
#======================================================================================= 
fit1.pibra <- Arima(pibra, order = c(2,1,0), 
                    seasonal = NULL, xreg = NULL, 
                    include.constant = TRUE, 
                    lambda = 0, method = "ML")

# Verificação da significância dos coeficientes
#=======================================================================================
t.test <- function(modelo_arima){
  # estatística t
  coef <- modelo_arima$coef
  se <- sqrt(diag(modelo_arima$var.coef))
  t <- abs(coef/se)
  # Teste t
  ok <- t > qt(0.975, length(modelo_arima$x) - sum(modelo_arima$arma[c(1,2,3,4,6,7)]))
  resul <- data.frame(Coef = coef, sd = se, t = t, rej_H0 = ok)
  return(resul)
}

t.test(fit1.pibra)

# Diagnosticando Modelo ARIMA(2,1,0)
#======================================================================================= 
resid1 <- fit1.pibra$residuals
plot(resid1)
acf(resid1, drop.lag.0 = T)
pacf(resid1)
qlb1 <- Box.test(resid1, lag = 18, type="Ljung")
qlb1
acf(resid1^2, drop.lag.0 = T, lag = 20)
library(BETS)
arch_test(resid1)
library(FinTS)
ArchTest(resid1)
library(normtest)
jb.norm.test(resid1)
skewness.norm.test(resid1)
kurtosis.norm.test(resid1)
plot(exp(pibra_tbc))
lines(fit1.pibra$fitted, col = 'red')

#  Estimação Modelo ARIMA(2,1,1)
#======================================================================================= 
fit2.pibra <- Arima(pibra, order = c(2,1,1), 
                    seasonal = NULL, xreg = NULL, 
                    include.constant = TRUE, 
                    lambda = 0, method = "ML")

t.test(fit2.pibra) 

#  Estimação ARIMA(0,1,2)
#======================================================================================= 
fit3.pibra <- Arima(pibra, order = c(0,1,2), 
                    seasonal = NULL, xreg = NULL, 
                    include.constant = TRUE, 
                    lambda = 0, method = "ML")

t.test(fit3.pibra) 

# Diagnosticando Modelo ARIMA(0,1,2)
#======================================================================================== 
resid3 <- fit3.pibra$residuals
plot(resid3)
acf(resid3, drop.lag.0 = T)
qlb3 <- Box.test(resid3, lag = 18, type="Ljung")
qlb3
acf(resid3^2, drop.lag.0 = T, lag = 20)
library(BETS)
arch_test(resid3)
library(normtest)
jb.norm.test(resid3)
skewness.norm.test(resid3)
kurtosis.norm.test(resid3)
plot(exp(pibra_tbc))
lines(fit3.pibra$fitted, col = 'red')

# Comparando os modelos
#======================================================================================= 
list(fit1.pibra)
list(fit3.pibra)

# Previsão do ARIMA(2,1,0)
#======================================================================================= 
prev.pibra <- forecast(object = fit1.pibra, h=12, level = 0.95)
prev.pibra
plot(prev.pibra)
