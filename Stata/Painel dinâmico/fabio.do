
****colocar em painel
reshape , i(codigo da unidade da cross section) j(ano)
***colocar ln
gen = ln(pat)
**defasando um per�odo
gen lnpd1 = l.lnpd
gen lnpd2 = l.lnpd1



***xtset obrigat�rio
xtset num ano
xtdescribe
xtsum pat escola papers pd poup ied ftrab
****observa��o importante: Para decidir entre pols, efeitos fixos e aleat�rios. 1)primeiro roda efeitos aleat�rio, depois faz o teste de breusch (decidir sobre a presen�a de efeitos n�o observados). Se n�o d� efeitos n�o observados, rodar o pols mesmo. se d� efeitos n�o observados, fazer teste de hausman para decidir entre fixos e aleat�rios. 

*inicio de pols
xi: regress lnpat lnescola lnpd1 lnpoup lnied lnftrab, vce (robust)
****fim de POLS


**inicio de aleat�rio
xi: xtreg lnpat lnescola lnpapers lnpd lnpoup lnied lnftrab, re vce (robust)
****
****fim de aleat�rio

*****breuch iniciou aq
**breuch (decidir entre POLS ou (fixos e aleat�rios))
**ef ( a rejei��o da hip�tese nula a qualquer n�vel de signific�ncia para os modelos estimados. Desta forma, foi poss�vel aceitar a hip�tese alternativa a qualquer n�vel de signific�ncia de exist�ncia de efeitos n�o observados para todos os modelos)
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
*****hausman ( A hip�tese nula do teste de Hausman aponta que o estimador de EA � eficiente e consistente. Portanto, a rejei��o da hip�tese nula leva � conclus�o de que o m�todo de efeitos fixos � mais apropriado,  levando  a estimativas consistentes e eficientes. )
*****hausman terminou aq

***painel dinamico (ps: tem como estimar robusto. so colocar: vce(robust))
***arellano e bond
 xtabond pib_ plp_, lags(1) twostep maxldep(3) artests(2)
 ***maxldep n�mero de defasagem dos instrumentos 
 ***teste de autocorrela��o dos res�duos... no caso, considerando 1 lag de defasagem na dependente, ent�o, pode haver correla��o somente no 1ag
 ***al�m disso, s� contabiliza se usar twostep (mais utilizado)... usando  one-step n�o contabiliza este teste. 
 estat abond, artests(2...)
 ***teste de valdiade dos instrumentos (se rejeita a nula: instrumentos n�o s�o adequados)
 estat sargan
 
***din�mico blundel e bond 1998 (� o mais novo)
xtdpdsys pib_ plp_ ,lags(1) maxldep(3)  artests(1) 
 estat abond
***teste autocorrela��o dos res�duos.
estat abond, artests(2...)
***( rejeita a hip�tese nula, o que indica que algum instrumento pode n�o ser  adequado. )
estat sargan

