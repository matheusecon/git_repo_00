*************************************************
****************MQ2E*****************************
*************************************************
***Inicialemten vamos reconhecer a amostra como dados de séries temporais**
***O primeiro ano da amostra é 1947.

gen tempo = y(1947) + _n-1

***Defina o formato da variável para o período anual***

format tempo %ty

***Na sequencia você pode "Setar" a variável tempo como tempo da regressão

tsset tempo


ivreg2 cf t (pib = inv cg), first

*Entre parênteses, do lado direito da igualdade, ficam as variáveis a serem usadas como instrumentais
*Comando ivreg2 solta todos os testes de uma vez, 
*Em caso de não ter o comando ivreg2, pode se usar o ivreg ou ivregress, mas estes não rodam o comando para detecção de heterocedasticidade (ivhettest, ph)

ivreg 2sls cf t (pib = inv cg), first


***Underidentification test (Anderson canon. corr. LM statistic)***
*testa se o modelo é sobreidentificado;
*Ho: modelo é sobreidentificado
*Hi: modelo é identificado
**p-valor tender a zero, rejeita-se a hipótese nula

***Weak identification test(Cragg-Donald Wald F statistic)***
**p-valor tender a zero, rejeita-se a hipótese nula

***Teste de Endogeneidade***
*Ho:  Regressor é exógeno
*Hi: O regressor é endogeno

ivendog

**p-valor tender a zero, rejeita-se a hipótese nula

***Sargan statistic(overidentification test of all instruments)***
*Teste de Validade dos instrumentos
*Ho:Todos os instrumentos são válidos
*Hi:Pelo menos um instrumento não é valido (pelo menos um instrumento está correlacionados com o termo do erro)
overid
**p-valor tender a zero, rejeita-se a hipótese nula


***HETEROCEDÁSTICIDADE***
*Ho: erros são homocedasticos
ivhettest, ph
**p-valor tender a zero, rejeita-se a hipótese nula





