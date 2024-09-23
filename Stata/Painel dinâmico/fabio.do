
****colocar em painel
reshape , i(codigo da unidade da cross section) j(ano)
***colocar ln
gen = ln(pat)
**defasando um período
gen lnpd1 = l.lnpd
gen lnpd2 = l.lnpd1



***xtset obrigatório
xtset num ano
xtdescribe
xtsum pat escola papers pd poup ied ftrab
****observação importante: Para decidir entre pols, efeitos fixos e aleatórios. 1)primeiro roda efeitos aleatório, depois faz o teste de breusch (decidir sobre a presença de efeitos não observados). Se não dê efeitos não observados, rodar o pols mesmo. se dê efeitos não observados, fazer teste de hausman para decidir entre fixos e aleatórios. 

*inicio de pols
xi: regress lnpat lnescola lnpd1 lnpoup lnied lnftrab, vce (robust)
****fim de POLS


**inicio de aleatório
xi: xtreg lnpat lnescola lnpapers lnpd lnpoup lnied lnftrab, re vce (robust)
****
****fim de aleatório

*****breuch iniciou aq
**breuch (decidir entre POLS ou (fixos e aleatórios))
**ef ( a rejeição da hipótese nula a qualquer nível de significância para os modelos estimados. Desta forma, foi possível aceitar a hipótese alternativa a qualquer nível de significância de existência de efeitos não observados para todos os modelos)
*****breusch terminou aq
xi: xtreg lnpat lnescola lnpd2 lnpoup lnied lnftrab, re vce (robust)
xttest0

****efeito fixo inicio
xi: xtreg lnpat lnescola lnpd2 lnpoup lnied lnftrab, fe vce (robust)


*****para fazer hausman tem que rodar isso td
quietly xi: xtreg lnpat lnescola lnpd2 lnpoup lnied lnftrab , re
estimates store RE	
quietly xi: xtreg lnpat lnescola lnpd2 lnpoup lnied lnftrab , fe
estimates store FE	
hausman FE RE, sigmamore
*****hausman ( A hipótese nula do teste de Hausman aponta que o estimador de EA é eficiente e consistente. Portanto, a rejeição da hipótese nula leva à conclusão de que o método de efeitos fixos é mais apropriado,  levando  a estimativas consistentes e eficientes. )
*****hausman terminou aq

***painel dinamico (ps: tem como estimar robusto. so colocar: vce(robust))
***arellano e bond
 xtabond pib_ plp_, lags(1) twostep maxldep(3) artests(2)
 ***maxldep número de defasagem dos instrumentos 
 ***teste de autocorrelação dos resíduos... no caso, considerando 1 lag de defasagem na dependente, então, pode haver correlação somente no 1ag
 ***além disso, só contabiliza se usar twostep (mais utilizado)... usando  one-step não contabiliza este teste. 
 estat abond, artests(2...)
 ***teste de valdiade dos instrumentos (se rejeita a nula: instrumentos não são adequados)
 estat sargan
 
***dinâmico blundel e bond 1998 (é o mais novo)
xtdpdsys pib_ plp_ ,lags(1) maxldep(3)  artests(1) 
 estat abond
***teste autocorrelação dos resíduos.
estat abond, artests(2...)
***( rejeita a hipótese nula, o que indica que algum instrumento pode não ser  adequado. )
estat sargan

