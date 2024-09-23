#
# Construção Completa Modelo SARIMA(p,d,q)x(P,D,Q) para Venda Passagens Aéreas UK
# ***************************************************************************************
#========================================================================================
#
#     É usada a série de Venda de Passagens Aereas UK 
#
#========================================================================================

rm(list=ls())
graphics.off()

library(forecast) 
library(TSA)

#========================================================================================
# Lendo e Plotando a série de Vendas de Passagens Aereas UK
#
#   A série está disponivel internamente no R e chama-se 'AirPassengers'.
#   Também encontra-se já no formato TS de série temporal.
#
#========================================================================================
serie <- AirPassengers
plot(serie, main = "Vendas Mensais de Passagens Aéreas no Reino Unido 1949-1960")


# Dividindo a série em períodos de estimação e de teste preditivo
#
#   Período de Estimação: 1949,1 a 1959,12
#   Perído de Teste Preditivo: 1960,1 a 1960,12
#========================================================================================
abline(v = c(1960,1)) # <= mostra no gráfico a divisão de períodos
seriea <- window(serie, end = c(1959,12))
seriep <- window(serie, start = c(1960,1))

# Verificação do gráfico e da ACF
#=======================================================================================
ts.plot(seriea, main = "Vendas de Passagens Aéreas UK")
acf(seriea, drop.lag.0 = T, lag=36)

#========================================================================================

# Teste Aumentado de Dickey-Fuller
#=======================================================================================
# ur.df(y, type = c("none", "drift", "trend"), lags = 1, selectlags = c("Fixed", "AIC", "BIC"))
require(urca)
adf.seriea <- ur.df(y = seriea, type = c("trend"), lags = 10, selectlags = "BIC")
summary(adf.seriea)

d_seriea = diff(seriea)
plot(d_seriea)
adf.d_seriea <- ur.df(y = d_seriea, type = c("none"), lags = 10, selectlags = "BIC")
summary(adf.d_seriea)
seriea1 <- window(d_seriea, end = c(1953.12))
seriea2 <- window(d_seriea, start = c(1955.1))
var.test(seriea2,seriea1)

lseriea <- log(seriea)
adf.lseriea <- ur.df(y = lseriea, type = c("none"), lags = 10, selectlags = "BIC")
summary(adf.lseriea)
d_lseriea <- (diff(lseriea))
plot(d_lseriea)
acf(d_lseriea, drop.lag.0 = T, lag=48)


# Diferenciação sazonal
#========================================================================================
dd_lseriea <- diff(d_lseriea, lag = 12)
plot(cbind(seriea,d_seriea,dd_lseriea), main = "série(seriea), dif.simples (d_seriea) e dif. sazonal (dd_lseriea)")


# Etapa 1: Identificação
#========================================================================================
acf(dd_lseriea, lag=48, drop.lag.0 = TRUE)
pacf(dd_lseriea,lag=48)


# Etapa 2: Estimação e Diagnóstico
#========================================================================================
# Uso as informações sobre diferenciação e 
# identificação (p,q,P e Q) para, agora, 
# estimar o modelo ARMA. Atenção aqui porque o 
# argumento deve ser a variável seriea (= série não diferenciada)

# Etapa 2: Modelo SARIMA(0,1,1)x(0,1,1) para YA
#========================================================================================
fit.mod1 <- Arima(seriea, order = c(0,1,1), 
                  seasonal = c(0, 1, 1), xreg = NULL, 
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

t.test(fit.mod1)
# Vendo resultados
# Nota: coeficientes e demais estatisticas são 
# para a versão SARMA (sem "I") do modelo, isto é, para a variávlel WA
print(fit.mod1)

# Diagnosticando os resíduos
resid1 <- fit.mod1$residuals
plot(resid1)
acf(resid1, drop.lag.0 = T, lag=36)
pacf(resid1, lag=36)
qlb1 <- Box.test(resid1, lag = 18, type="Ljung")
qlb1
acf(resid1^2, drop.lag.0 = T, lag = 20)
library(BETS)
arch_test(resid1)
library(normtest)
jb.norm.test(resid1)
skewness.norm.test(resid1)
kurtosis.norm.test(resid1)

seriea_aj <- fit.mod1$fitted

#   Gráfico
plot(seriea, main = "Real x Ajustado para Série Original")
lines(seriea_aj, col = 'red')
legend('topleft', legend=c("série real", "série ajustada"),col=c("black","red"), 
       lty=c(1,5), cex=0.8,
       lwd =c(1,2))

# Qualidade do Ajustamento
accuracy(seriea,seriea_aj)

# Desempenho Preditivo
prev.mod1 <- forecast(fit.mod1,h = 12)
prev.mod1
plot(prev.mod1)
seriep_prev <-prev.mod1$mean
accuracy(seriep,seriep_prev)

#   Gráfico geral (Ajustado + Previsto) x Serie Original
plot(serie, main = "Real x (Ajustado + Previsto) para Serie Original")
lines(seriea_aj, col = 'red')
lines(seriep_prev, col = 'blue')
abline(v=c(1960,1))
legend('topleft', legend=c("série real", "série ajustada", "série prevista"),col=c("black","red","blue"), 
       lty=c(1,5), cex=0.8,
       lwd =c(1,2))
