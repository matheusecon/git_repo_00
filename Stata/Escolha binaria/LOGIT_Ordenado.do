*************************************************************
* PREPARACAO DE DADOS PNAD 2013 ***REVER AS DUMMIES E CONCERTAR QUESTÃO DO PONTO
*************************************************************

*cd "C:<endereço da pasta de saída>"

cd "C:\Users\Adalto\Documents\Políticas públicas\DOfile"

set more off
set memory 512m

 
* LEITURA DAS INFORMACOES DO DESENHO DA AMOSTRA NO ARQUIVO DE DOMICILIOS

clear
#delimit;
infix ano 1-4 UF 5-6 controle 5-12 serie 13-15 numPESDOM 18-19 numCOMODOS 26-27 
aguacanalizada 56 esgoto 64 energia 66 sitcen 100 codcens 101 rendamensaldom 162-173
strat 178-184 psu 185-191 Q1 210 Q2 211 Q3 212 Q4 213 Q5 214 Q6 215 Q7 216 Q8 217
menordeidade 218  Q9c 219 Q10c 220 Q11c 221 Q12c 222 Q13c 223 Q14c 224 
using "C:\Users\Adalto\Documents\PNAD\PNAD_2013\Dados\DOM2013.txt",clear;
#delimit cr


************ORDENAR OS DADOS*************

#delimit;
sort controle serie, stable;
format controle %15.0g;
format serie %15.0g;
replace controle = float(controle);
replace serie = float(serie);
#delimit cr

save dom2013, replace

**comando sort organiza as observaçoes dos dados atuais em ordem ascendente baseado nos valores das variaveis em varlist
*** neste caso controle e serie sao as variaveis usadas como referencia

* LEITURA DOS DADOS DAS PESSOAS 2013

clear
#delimit;
infix ano 1-4 UF 5-6 controle 5-12 serie 13-15 Sexo 18-18 Idade 27-29 CondDom 30-30 CondF 31-31 Cor 33-33 
alfab 69-69 freqescola 70-70 formacaosefreq 73-74 formacaosenaofreq 79-80 criacaoepesca1 96 criacaoepesca2 156  
funcionariopublico 305 criacaoepesca3 375 criacaoepesca4 489 aposentadoria1 519-520 
aposentadoria2 533-534 aposentadoria3 547-548 pensao 561-562 abonopermanencia 575-576 anosDestud 669-670 
emprego 673-674 trabalho 673-674 ativPrinc 682 pesofam 762-766 criança 769 numcompdomicilio 770-771 rendPerCapta 772-783 

using "C:\Users\Adalto\Documents\PNAD\PNAD_2013\Dados\PES2013.txt",clear;
#delimit cr 

*****JUNÇÃO DAS INFORMAÇÕES DE DESENHO DA AMOSTRA AO ARQUIVO DE PESSOAS DA PNAD 2014*********
**********Joinby
#delimit;
sort controle serie, stable;
joinby controle serie using dom2013;
#delimit cr

save pes2013, replace

* DECLARANDO/SETANDO O CONJUNTO DE DADOS COMO SENDO DE AMOSTRA COMPLEXA

clear
use pes2013, clear

svyset psu [pweight=pesofam], strata(strat) vce(linearized) || _n

svydes, single

save pes2013, replace

* ROTINA DE ALOCACAO DE ESTRATOS COM UM UNICO PSU EM ESTRATOS COM MAIOR NUMERO
* DE OBSERVACOES UTILIZANDO O DO.FILE idonepsu - ANO DE 2013

use pes2013, clear

*findit idonepsu (primeira vez que usar)
* Instalar o idonepsu (primeira vez que usar)

idonepsu, strata(strat) psu(psu) generate(new)
drop strat psu
rename newstr strat
rename newpsu psu

svyset psu [pweight=pesofam], strata(strat) vce(linearized) || _n

svydes, single

save pes2013, replace

*tem-se que eliminar obs=1, sendo unit = PSU

drop if strat == 290003  & psu == 35
drop if strat == 330026  & psu == 326
drop if strat == 350027  & psu == 186
drop if strat == 350034  & psu == 238

save pes2013, replace

*convém rodar idonepsu de novo para checar se ao apagar um estrato surgiram outros de psu único.
* DROPAGEM DOS DADOS DE PESSOAS QUE NÃO SÃO DE REFERENCIA, 
*DA RENDA PER CAPTA NÃO INFORMADA

drop if CondDom == 2
drop if CondDom == 3
drop if CondDom == 4
drop if CondDom == 5
drop if CondDom == 6
drop if CondDom == 7
drop if CondDom == 8

replace rendPerCapta = . if rendPerCapta > 5000000
replace rendPerCapta = . if rendPerCapta ==999999999999

save pes2013, replace

*Repetindo idonepsu:

idonepsu, strata(strat) psu(psu) generate(new)
drop strat psu
rename newstr strat
rename newpsu psu

svyset psu [pweight=pesofam], strata(strat) vce(linearized) || _n

svydes, single

save pes2013, replace

*GERANDO AS DUMMIES E OUTRAS VARIÁVEIS DERIVADAS
*ANOS DE ESTUDO

gen estudo = anosDestud - 1
replace estudo = . if anosDestud == 17
replace estudo = . if anosDestud ==.

* Formação

gen escalfabetizacao = 0
replace escalfabetizacao = 1 if formacaosefreq == 06 & alfab == 1
replace escalfabetizacao = 1 if formacaosefreq == 07 & alfab == 1
replace escalfabetizacao = 1 if formacaosefreq == 08 & alfab == 1
replace escalfabetizacao = 1 if formacaosefreq == 09 & alfab == 1
replace escalfabetizacao = 1 if formacaosenaofreq == 10 & alfab == 1
replace escalfabetizacao = 1 if formacaosenaofreq == 11 & alfab == 1
replace escalfabetizacao = 1 if formacaosenaofreq == 12 & alfab == 1
replace escalfabetizacao = . if alfab ==.
replace escalfabetizacao = . if formacaosefreq ==. & formacaosenaofreq ==.


gen escprimario = 1 if formacaosefreq == 01
replace escprimario = 1 if formacaosenaofreq == 01
replace escprimario = 0 if formacaosefreq > 01
replace escprimario = 1 if formacaosefreq == 03
replace escprimario = 0 if formacaosenaofreq > 01
replace escprimario = 1 if formacaosenaofreq == 13
replace escprimario = . if formacaosefreq ==. & formacaosenaofreq ==.


gen escfundamental = 0 
replace escfundamental = 1 if formacaosefreq == 02
replace escfundamental = 1 if formacaosefreq == 04
replace escfundamental = 1 if formacaosenaofreq == 04
replace escfundamental = 1 if formacaosenaofreq == 06
replace escfundamental = . if formacaosefreq ==. & formacaosenaofreq ==.


gen escmedio = 0 
replace escmedio = 1 if formacaosefreq == 05
replace escmedio = 1 if formacaosefreq == 10
replace escmedio = 1 if formacaosenaofreq == 02
replace escmedio = 1 if formacaosenaofreq == 03
replace escmedio = 1 if formacaosenaofreq == 05
replace escmedio = 1 if formacaosenaofreq == 07
replace escmedio = . if formacaosefreq ==. & formacaosenaofreq ==.


gen escsuperior = 0 
replace escsuperior = 1 if formacaosefreq == 11
replace escsuperior = 1 if formacaosenaofreq == 08
replace escsuperior = 1 if formacaosenaofreq == 09
replace escsuperior = . if formacaosefreq ==. & formacaosenaofreq ==.


*Pessoas/comodo

gen pesporcomodo = (numPESDOM/numCOMODOS)
replace pesporcomodo = . if numPESDOM ==.
replace pesporcomodo = . if numCOMODO ==.
replace pesporcomodo = . if numPESDOM ==0
replace pesporcomodo = . if numCOMODO ==0

*ENERGIA E SANEAMENTO

replace aguacanalizada = 0 if aguacanalizada == 3

replace esgoto = 1 if esgoto == 2
replace esgoto = 1 if esgoto == 3
replace esgoto = 0 if esgoto == 4
replace esgoto = 0 if esgoto == 5
replace esgoto = 0 if esgoto == 6
replace esgoto = 0 if esgoto == 7

replace energia = 0 if energia == 3
replace energia = 0 if energia ==5

*TRABALHOS

gen funcionariopublicooumilitar = 0 
replace funcionariopublicooumilitar = 1 if funcionariopublico == 4
replace funcionariopublicooumilitar = 1 if emprego == 2
replace funcionariopublicooumilitar = 1 if emprego == 3
replace funcionariopublicooumilitar = . if emprego == .

gen semcarteira = 0
replace semcarteira = 1 if emprego ==4
replace semcarteira = 1 if emprego ==7
replace semcarteira = . if emprego ==.

gen empregadodomestico = 0
replace empregadodomestico = 1 if emprego ==6
replace empregadodomestico = 1 if emprego ==7
replace empregadodomestico = . if emprego ==.

gen empregador = 0
replace empregador = 1 if emprego ==10
replace empregador = . if emprego ==.

gen contapropria = 0
replace contapropria = 1 if emprego ==9
replace contapropria = . if emprego ==.

gen aposentadoriaoupensao = 0
replace aposentadoriaoupensao = 1 if aposentadoria1 ==1
replace aposentadoriaoupensao = 1 if aposentadoria2 ==2
replace aposentadoriaoupensao = 1 if aposentadoria3 ==3
replace aposentadoriaoupensao = 1 if pensao ==4
replace aposentadoriaoupensao = 1 if abonopermanencia ==5

*PESSOA DE REFERENCIA IDOSA

gen idoso = 0
replace idoso = 1 if Idade >= 60 
replace idoso = 0 if Idade ==.

*Criação e pesca

gen criacaopesca = 0

replace criacaopesca = 1 if criacaoepesca2 ==2
replace criacaopesca = 1 if criacaoepesca2 ==1
replace criacaopesca = 1 if criacaoepesca3 ==2
replace criacaopesca = 1 if criacaoepesca4 ==1


*RURAL

gen rural=0
replace rural = 1 if sitcen ==4
replace rural = 1 if sitcen ==5
replace rural = 1 if sitcen ==6
replace rural = 1 if sitcen ==7
replace rural = 1 if sitcen ==8
replace rural = 1 if sitcen ==.
*ESTADO


gen RO = 1 if UF == 11
replace RO = 0 if UF>11
replace RO = 0 if UF<11
replace RO = . if UF ==.

gen AC = 1 if UF == 12
replace AC = 0 if UF>12
replace AC = 0 if UF<12
replace AC = . if UF ==.

gen AM=1 if UF == 13
replace AM = 0 if UF<13
replace AM = 0 if UF>13
replace AM = . if UF ==.

gen RR = 1 if UF == 14
replace RR = 0 if UF<14
replace RR = 0 if UF>14
replace RR = . if UF ==.

gen PA = 1 if UF == 15
replace PA = 0 if UF<15
replace PA = 0 if UF>15
replace PA = . if UF ==.

gen AP = 1 if UF == 16
replace AP = 0 if UF<16
replace AP = 0 if UF>16
replace AP = . if UF ==.

gen TO = 1 if UF == 17
replace TO = 0 if UF<17
replace TO = 0 if UF>17
replace TO = . if UF ==.

gen MA = 1 if UF == 21
replace MA = 0 if UF<21
replace MA = 0 if UF>21
replace MA = . if UF ==.

gen PI = 1 if UF == 22
replace PI = 0 if UF<22
replace PI = 0 if UF>22
replace PI = . if UF ==.

gen CE = 1 if UF == 23
replace CE = 0 if UF<23
replace CE = 0 if UF>23
replace CE = . if UF ==.

gen RN = 1 if UF == 24
replace RN = 0 if UF<24
replace RN = 0 if UF>24
replace RN = . if UF ==.

gen PB = 1 if UF == 25
replace PB = 0 if UF<25
replace PB = 0 if UF>25
replace PB = . if UF ==.

gen PE = 1 if UF == 26
replace PE = 0 if UF<26
replace PE = 0 if UF>26
replace PE = . if UF ==.

gen AL = 1 if UF ==27
replace AL = 0 if UF<27
replace AL = 0 if UF>27
replace AL = . if UF ==.

gen SE = 1 if UF == 28
replace SE = 0 if UF<28
replace SE = 0 if UF>28
replace SE = . if UF ==.

gen BA = 1 if UF == 29
replace BA = 0 if UF<29
replace BA = 0 if UF>29
replace BA = . if UF ==.

gen MG = 1 if UF == 31
replace MG = 0 if UF<31
replace MG = 0 if UF>31
replace MG = . if UF ==.

gen ES = 1 if UF ==32
replace ES = 0 if UF<32
replace ES = 0 if UF>32
replace ES = . if UF ==.

gen RJ = 1 if UF == 33
replace RJ = 0 if UF<33
replace RJ = 0 if UF>33
replace RJ = . if UF ==.

gen SP = 1 if UF == 35
replace SP = 0 if UF<35
replace SP = 0 if UF>35
replace SP = . if UF ==.

gen PN = 1 if UF == 41
replace PN = 0 if UF<41
replace PN = 0 if UF>41
replace PN = . if UF ==.

gen SC = 1 if UF == 42
replace SC = 0 if UF<42
replace SC = 0 if UF>42
replace SC = . if UF ==.

gen RS = 1 if UF == 43
replace RS = 0 if UF<43
replace RS = 0 if UF>43
replace RS = . if UF ==.

gen MS = 1 if UF == 50
replace MS = 0 if UF<50
replace MS = 0 if UF>50
replace MS = . if UF ==.

gen MT = 1 if UF == 51
replace MT = 0 if UF<51
replace MT = 0 if UF>51
replace MT = . if UF ==.

gen GO = 1 if UF == 52
replace GO = 0 if UF<52
replace GO = 0 if UF>52
replace GO = . if UF ==.

gen DF = 1 if UF == 53
replace DF = 0 if UF<53
replace DF = 0 if UF>53
replace DF = . if UF ==.

*SEXO

gen MASC = 1 if Sexo == 2
replace MASC = 0 if Sexo ==4
replace MASC = . if MASC==.

gen FEM = 1 if Sexo == 4
replace FEM = 0 if Sexo == 2
replace FEM = . if Sexo ==.

*COR

gen BRANCO = 1 if Cor == 2
replace BRANCO = 0 if Cor == 4
replace BRANCO = 0 if Cor == 6
replace BRANCO = 0 if Cor == 8
replace BRANCO = 0 if Cor == 0
replace BRANCO = . if Cor ==.

gen nbranco = 1 if Cor == 4
replace nbranco = 1 if Cor == 6
replace nbranco = 1 if Cor == 8
replace nbranco = 1 if Cor == 0
replace nbranco = 0 if Cor == 2
replace nbranco = . if Cor ==.

*ALFABETIZAÇÃO

gen alfabetizado = 1 if alfab == 1
replace alfabetizado = 0 if alfab == 3
replace alfabetizado = . if alfab ==.

gen nalfabetizado = 1 if alfab == 3
replace nalfabetizado = 0 if alfab == 1
replace nalfabetizado = . if alfab ==.

*RENDA PER CAPTA

*ATIVIDADE PRINCIPAL

gen agricola = 1 if ativPrinc == 1
replace agricola = 0 if ativPrinc ==2
replace agricola = . if ativPrinc ==.

gen nagricola = 1 if ativPrinc == 2
replace nagricola = 0 if ativPrinc ==1
replace nagricola = . if ativPrinc ==.

*Segurança alimentar

replace Q1 = 0 if Q1 ==3
replace Q2 = 0 if Q2 ==3
replace Q3 = 0 if Q3 ==3
replace Q4 = 0 if Q4 ==3
replace Q5 = 0 if Q5 ==3
replace Q6 = 0 if Q6 ==3
replace Q7 = 0 if Q7 ==3
replace Q8 = 0 if Q8 ==3
replace Q9c = 1 if Q9c ==2
replace Q10c = 1 if Q10c ==2
replace Q11c = 1 if Q11c ==2
replace Q12c = 1 if Q12c ==2
replace Q13c = 1 if Q13c ==2
replace Q14c = 1 if Q14c ==2
replace Q9c = 0 if Q9c ==4
replace Q10c = 0 if Q10c ==4
replace Q11c = 0 if Q11c ==4
replace Q12c = 0 if Q12c ==4
replace Q13c = 0 if Q13c ==4
replace Q14c = 0 if Q14c ==4
replace menordeidade = 0 if menordeidade ==3

gen somaQ = (Q1+Q2+Q3+Q4+Q5+Q6+Q7+Q8+Q9c+Q10c+Q11c+Q12c+Q13c+Q14c)

gen segalimentar = 0 
replace segalimentar=1 if somaQ==0
replace segalimentar=1 if somaQ==.


gen insegleve = 0
replace insegleve=1 if somaQ>=1 & somaQ<=5 & menordeidade==1
replace insegleve=1 if somaQ>=1 & somaQ<=3 & menordeidade==0


gen insegmoderada = 0
replace insegmoderada = 1 if somaQ>=6 & somaQ<=9 & menordeidade==1
replace insegmoderada = 1 if somaQ>=6 & somaQ<=9 & menordeidade==0


gen inseggrave = 0
replace inseggrave=1 if somaQ>=10 & somaQ<=14 & menordeidade==1
replace inseggrave=1 if somaQ>=6 & somaQ<=8 & menordeidade==0

gen inseguranca = 0
replace inseguranca =1 if (insegleve+insegmoderada+inseggrave)>0

gen seg = 0 
replace seg=1 if segalimentar==1
replace seg=2 if insegleve==1
replace seg=3 if insegmoderada==1
replace seg=4 if inseggrave==1


save pes2014, replace


*ANÁLISE DE REGRESSÃO LOGIT ORDENADO

. ologit seg RO AM RR PA AP TO MA PI AC CE RN PB PE AL SE BA MG ES RJ PN SC RS MS MT GO DF Idade estudo rendPerCapta pesporcomodo aguacanalizada esgoto energia funcionariopublicooumilitar semcarteira empregadodomestico empregador contapropria aposentadoriaoupensao idoso criacaopesca rural FEM nbranco agricola criança [pw = pesofam], vce(robust)
. lroc [fweight = pesofam]
. estat class [fweight = pesofam]
. predict p1ologit p2ologit p3ologit p4ologit, pr
. summarize p1ologit p2ologit p3ologit p4ologit [fw = pesofam]
. mfx

. lroc 

*plotagem de gráficos de probabilidade em função de uma variável

. mlogit seg Idade estudo rendPerCapta [pw = pesofam], nolog

. gen pi0 = (1)/(1+(exp(0.6450619 - 0.0268815*Idade - 0.022235*estudo -0.0022701*rendPerCapta)) + (exp(0.2373477 - 0.0254843*Idade - 0.08365801*estudo -0.0044044*rendPerCapta)) + (exp(0.0682964 - 0.0215672*Idade - 0.11624406*estudo -0.0052503*rendPerCapta)))
. gen pi1 = (exp(0.6450619 - 0.0268815*Idade - 0.022235*estudo -0.0022701*rendPerCapta))/(1+(exp(0.6450619 - 0.0268815*Idade - 0.022235*estudo -0.0022701*rendPerCapta)) + (exp(0.2373477 - 0.0254843*Idade - 0.08365801*estudo -0.0044044*rendPerCapta)) + (exp(0.0682964 - 0.0215672*Idade - 0.11624406*estudo -0.0052503*rendPerCapta)))
. gen pi2 = (exp(0.2373477 - 0.0254843*Idade - 0.08365801*estudo -0.0044044*rendPerCapta))/(1+(exp(0.6450619 - 0.0268815*Idade - 0.022235*estudo -0.0022701*rendPerCapta)) + (exp(0.2373477 - 0.0254843*Idade - 0.08365801*estudo -0.0044044*rendPerCapta)) + (exp(0.0682964 - 0.0215672*Idade - 0.11624406*estudo -0.0052503*rendPerCapta)))
. gen pi3 = (exp(0.0682964 - 0.0215672*Idade - 0.11624406*estudo -0.0052503*rendPerCapta))/(1+(exp(0.6450619 - 0.0268815*Idade - 0.022235*estudo -0.0022701*rendPerCapta)) + (exp(0.2373477 - 0.0254843*Idade - 0.08365801*estudo -0.0044044*rendPerCapta)) + (exp(0.0682964 - 0.0215672*Idade - 0.11624406*estudo -0.0052503*rendPerCapta)))

. graph twoway mspline pi0 rendPerCapta || pi1 rendPerCapta || pi2 rendPerCapta || pi3 rendPerCapta ||, legend (label (1 "segurança alimentar") label (2 "inseg. leve") label (3 "inseg. moderada") label (4 "inseg. grave"))





. lroc 
*ANALISE DE CENARIOS
**Idade, raça, gênero,
**homem branco
. margins,  predict(outcome(1)) at(Idade=15 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 pesporcomodo=0.568 FEM=0 nbranco=0) atmeans
. margins, at(Idade=30 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 pesporcomodo=0.568 FEM=0 nbranco=0) atmeans
. margins, at(Idade=45 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 pesporcomodo=0.568 FEM=0 nbranco=0) atmeans
. margins, at(Idade=60 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 pesporcomodo=0.568 FEM=0 nbranco=0) atmeans
**homem não branco
. margins, at(Idade=15 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 pesporcomodo=0.568 FEM=0 nbranco=1) atmeans 
. margins, at(Idade=30 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 pesporcomodo=0.568 FEM=0 nbranco=1) atmeans
. margins, at(Idade=45 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 pesporcomodo=0.568 FEM=0 nbranco=1) atmeans
. margins, at(Idade=60 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 pesporcomodo=0.568 FEM=0 nbranco=1) atmeans
**Mulher branca
. margins, at(Idade=15 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 pesporcomodo=0.568 FEM=1 nbranco=0) atmeans
. margins, at(Idade=30 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 pesporcomodo=0.568 FEM=1 nbranco=0) atmeans
. margins, at(Idade=45 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 pesporcomodo=0.568 FEM=1 nbranco=0) atmeans
. margins, at(Idade=60 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 pesporcomodo=0.568 FEM=1 nbranco=0) atmeans
**mulher não branca
. margins, at(Idade=15 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 pesporcomodo=0.568 FEM=1 nbranco=1) atmeans
. margins, at(Idade=30 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 pesporcomodo=0.568 FEM=1 nbranco=1) atmeans
. margins, at(Idade=45 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 pesporcomodo=0.568 FEM=1 nbranco=1) atmeans
. margins, at(Idade=60 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 pesporcomodo=0.568 FEM=1 nbranco=1) atmeans
**Renda per Capta e trabalho
**R$100
. margins, at(rendPerCapta=100 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 funcionariopublicooumilitar=1 semcarteira=0 empregadodomestico=0 empregador=0 contapropria=0 aposentadoriaoupensao=0) atmeans
. margins, at(rendPerCapta=100 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 funcionariopublicooumilitar=0 semcarteira=1 empregadodomestico=0 empregador=0 contapropria=0 aposentadoriaoupensao=0) atmeans
. margins, at(rendPerCapta=100 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 funcionariopublicooumilitar=0 semcarteira=0 empregadodomestico=1 empregador=0 contapropria=0 aposentadoriaoupensao=0) atmeans
. margins, at(rendPerCapta=100 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 funcionariopublicooumilitar=0 semcarteira=0 empregadodomestico=0 empregador=1 contapropria=0 aposentadoriaoupensao=0) atmeans
. margins, at(rendPerCapta=100 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 funcionariopublicooumilitar=0 semcarteira=0 empregadodomestico=0 empregador=0 contapropria=1 aposentadoriaoupensao=0) atmeans
. margins, at(rendPerCapta=100 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 funcionariopublicooumilitar=0 semcarteira=0 empregadodomestico=0 empregador=0 contapropria=0 aposentadoriaoupensao=1) atmeans
**R$400
. margins, at(rendPerCapta=400 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 funcionariopublicooumilitar=1 semcarteira=0 empregadodomestico=0 empregador=0 contapropria=0 aposentadoriaoupensao=0) atmeans
. margins, at(rendPerCapta=400 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 funcionariopublicooumilitar=0 semcarteira=1 empregadodomestico=0 empregador=0 contapropria=0 aposentadoriaoupensao=0) atmeans
. margins, at(rendPerCapta=400 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 funcionariopublicooumilitar=0 semcarteira=0 empregadodomestico=1 empregador=0 contapropria=0 aposentadoriaoupensao=0) atmeans
. margins, at(rendPerCapta=400 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 funcionariopublicooumilitar=0 semcarteira=0 empregadodomestico=0 empregador=1 contapropria=0 aposentadoriaoupensao=0) atmeans
. margins, at(rendPerCapta=400 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 funcionariopublicooumilitar=0 semcarteira=0 empregadodomestico=0 empregador=0 contapropria=1 aposentadoriaoupensao=0) atmeans
. margins, at(rendPerCapta=400 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 funcionariopublicooumilitar=0 semcarteira=0 empregadodomestico=0 empregador=0 contapropria=0 aposentadoriaoupensao=1) atmeans
** R$800
. margins, at(rendPerCapta=800 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 funcionariopublicooumilitar=1 semcarteira=0 empregadodomestico=0 empregador=0 contapropria=0 aposentadoriaoupensao=0) atmeans
. margins, at(rendPerCapta=800 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 funcionariopublicooumilitar=0 semcarteira=1 empregadodomestico=0 empregador=0 contapropria=0 aposentadoriaoupensao=0) atmeans
. margins, at(rendPerCapta=800 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 funcionariopublicooumilitar=0 semcarteira=0 empregadodomestico=1 empregador=0 contapropria=0 aposentadoriaoupensao=0) atmeans
. margins, at(rendPerCapta=800 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 funcionariopublicooumilitar=0 semcarteira=0 empregadodomestico=0 empregador=1 contapropria=0 aposentadoriaoupensao=0) atmeans
. margins, at(rendPerCapta=800 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 funcionariopublicooumilitar=0 semcarteira=0 empregadodomestico=0 empregador=0 contapropria=1 aposentadoriaoupensao=0) atmeans
. margins, at(rendPerCapta=800 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 funcionariopublicooumilitar=0 semcarteira=0 empregadodomestico=0 empregador=0 contapropria=0 aposentadoriaoupensao=1) atmeans
** R$1200
. margins, at(rendPerCapta=1200 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 funcionariopublicooumilitar=1 semcarteira=0 empregadodomestico=0 empregador=0 contapropria=0 aposentadoriaoupensao=0) atmeans
. margins, at(rendPerCapta=1200 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 funcionariopublicooumilitar=0 semcarteira=1 empregadodomestico=0 empregador=0 contapropria=0 aposentadoriaoupensao=0) atmeans
. margins, at(rendPerCapta=1200 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 funcionariopublicooumilitar=0 semcarteira=0 empregadodomestico=1 empregador=0 contapropria=0 aposentadoriaoupensao=0) atmeans
. margins, at(rendPerCapta=1200 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 funcionariopublicooumilitar=0 semcarteira=0 empregadodomestico=0 empregador=1 contapropria=0 aposentadoriaoupensao=0) atmeans
. margins, at(rendPerCapta=1200 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 funcionariopublicooumilitar=0 semcarteira=0 empregadodomestico=0 empregador=0 contapropria=1 aposentadoriaoupensao=0) atmeans
. margins, at(rendPerCapta=1200 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 funcionariopublicooumilitar=0 semcarteira=0 empregadodomestico=0 empregador=0 contapropria=0 aposentadoriaoupensao=1) atmeans
** R$1600
. margins, at(rendPerCapta=1600 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 funcionariopublicooumilitar=1 semcarteira=0 empregadodomestico=0 empregador=0 contapropria=0 aposentadoriaoupensao=0) atmeans
. margins, at(rendPerCapta=1600 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 funcionariopublicooumilitar=0 semcarteira=1 empregadodomestico=0 empregador=0 contapropria=0 aposentadoriaoupensao=0) atmeans
. margins, at(rendPerCapta=1600 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 funcionariopublicooumilitar=0 semcarteira=0 empregadodomestico=1 empregador=0 contapropria=0 aposentadoriaoupensao=0) atmeans
. margins, at(rendPerCapta=1600 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 funcionariopublicooumilitar=0 semcarteira=0 empregadodomestico=0 empregador=1 contapropria=0 aposentadoriaoupensao=0) atmeans
. margins, at(rendPerCapta=1600 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 funcionariopublicooumilitar=0 semcarteira=0 empregadodomestico=0 empregador=0 contapropria=1 aposentadoriaoupensao=0) atmeans
. margins, at(rendPerCapta=1600 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 funcionariopublicooumilitar=0 semcarteira=0 empregadodomestico=0 empregador=0 contapropria=0 aposentadoriaoupensao=1) atmeans

**Tamanho da casa e características da residência
**0.1 pessoa por comodo
. margins, at(RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0  pesporcomodo=0.1 aguacanalizada=1 esgoto=1) atmeans
. margins, at(RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0  pesporcomodo=0.1 aguacanalizada=0 esgoto=0) atmeans
**0.6 pessoa por comodo
. margins, at(RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0  pesporcomodo=0.6 aguacanalizada=1 esgoto=1) atmeans
. margins, at(RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0  pesporcomodo=0.6 aguacanalizada=0 esgoto=0) atmeans
**1.2 pessoa por comodo
. margins, at(RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0  pesporcomodo=1.2 aguacanalizada=1 esgoto=1) atmeans
. margins, at(RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0  pesporcomodo=1.2 aguacanalizada=0 esgoto=0) atmeans
**escolaridade família e setor
**Setor urbano
*1 ano
. margins, at(estudo=1 Idade=60 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 idoso=0 criança=0 rural=0) atmeans
. margins, at(estudo=1 Idade=60 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 idoso=1 criança=0 rural=0) atmeans
. margins, at(estudo=1 Idade=60 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 idoso=0 criança=1 rural=0) atmeans
. margins, at(estudo=1 Idade=60 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 idoso=1 criança=1 rural=0) atmeans
*5 anos
. margins, at(estudo=5 Idade=60 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 idoso=0 criança=0 rural=0) atmeans
. margins, at(estudo=5 Idade=60 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 idoso=1 criança=0 rural=0) atmeans
. margins, at(estudo=5 Idade=60 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 idoso=0 criança=1 rural=0) atmeans
. margins, at(estudo=5 Idade=60 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 idoso=1 criança=1 rural=0) atmeans
*10 anos
. margins, at(estudo=10 Idade=60 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 idoso=0 criança=0 rural=0) atmeans
. margins, at(estudo=10 Idade=60 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 idoso=1 criança=0 rural=0) atmeans
. margins, at(estudo=10 Idade=60 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 idoso=0 criança=1 rural=0) atmeans
. margins, at(estudo=10 Idade=60 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 idoso=1 criança=1 rural=0) atmeans
*15 anos
. margins, at(estudo=15 Idade=60 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 idoso=0 criança=0 rural=0) atmeans
. margins, at(estudo=15 Idade=60 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 idoso=1 criança=0 rural=0) atmeans
. margins, at(estudo=15 Idade=60 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 idoso=0 criança=1 rural=0) atmeans
. margins, at(estudo=15 Idade=60 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 idoso=1 criança=1 rural=0) atmeans
**Setor rural
*1 ano
. margins, at(estudo=1 Idade=60 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 idoso=0 criança=0 rural=1 agricola=1) atmeans
. margins, at(estudo=1 Idade=60 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 idoso=1 criança=0 rural=1 agricola=1) atmeans
. margins, at(estudo=1 Idade=60 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 idoso=0 criança=1 rural=1 agricola=1) atmeans
. margins, at(estudo=1 Idade=60 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 idoso=1 criança=1 rural=1 agricola=1) atmeans
*5 anos
. margins, at(estudo=5 Idade=60 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 idoso=0 criança=0 rural=1 agricola=1) atmeans
. margins, at(estudo=5 Idade=60 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 idoso=1 criança=0 rural=1 agricola=1) atmeans
. margins, at(estudo=5 Idade=60 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 idoso=0 criança=1 rural=1 agricola=1) atmeans
. margins, at(estudo=5 Idade=60 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 idoso=1 criança=1 rural=1 agricola=1) atmeans
*10 anos
. margins, at(estudo=10 Idade=60 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 idoso=0 criança=0 rural=1 agricola=1) atmeans
. margins, at(estudo=10 Idade=60 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 idoso=1 criança=0 rural=1 agricola=1) atmeans
. margins, at(estudo=10 Idade=60 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 idoso=0 criança=1 rural=1 agricola=1) atmeans
. margins, at(estudo=10 Idade=60 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 idoso=1 criança=1 rural=1 agricola=1) atmeans
*15 anos
. margins, at(estudo=15 Idade=60 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 idoso=0 criança=0 rural=1) atmeans
. margins, at(estudo=15 Idade=60 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 idoso=1 criança=0 rural=1) atmeans
. margins, at(estudo=15 Idade=60 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 idoso=0 criança=1 rural=1) atmeans
. margins, at(estudo=15 Idade=60 RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0 idoso=1 criança=1 rural=1) atmeans
**ESTADOS
. margins, at(RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0) atmeans
. margins, at(RO=1 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0) atmeans
. margins, at(RO=0 AM=1 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0) atmeans
. margins, at(RO=0 AM=0 RR=1 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0) atmeans
. margins, at(RO=0 AM=0 RR=0 PA=1 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0) atmeans
. margins, at(RO=0 AM=0 RR=0 PA=0 AP=1 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0) atmeans
. margins, at(RO=0 AM=0 RR=0 PA=0 AP=0 TO=1 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0) atmeans
. margins, at(RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=1 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0) atmeans
. margins, at(RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=1 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0) atmeans
. margins, at(RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=1 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0) atmeans
. margins, at(RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=1 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0) atmeans
. margins, at(RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=1 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0) atmeans
. margins, at(RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=1 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0) atmeans
. margins, at(RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=1 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0) atmeans
. margins, at(RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=1 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0) atmeans
. margins, at(RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=1 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0) atmeans
. margins, at(RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=1 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0) atmeans
. margins, at(RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=1 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0) atmeans
. margins, at(RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=1 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0) atmeans
. margins, at(RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=1 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0) atmeans
. margins, at(RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=1 SC=0 RS=0 MS=0 MT=0 GO=0 DF=0) atmeans
. margins, at(RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=1 RS=0 MS=0 MT=0 GO=0 DF=0) atmeans
. margins, at(RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=1 MS=0 MT=0 GO=0 DF=0) atmeans
. margins, at(RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=1 MT=0 GO=0 DF=0) atmeans
. margins, at(RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=1 GO=0 DF=0) atmeans
. margins, at(RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=1 DF=0) atmeans
. margins, at(RO=0 AM=0 RR=0 PA=0 AP=0 TO=0 MA=0 PI=0 AC=0 CE=0 RN=0 PB=0 PE=0 AL=0 SE=0 BA=0 MG=0 ES=0 RJ=0 PN=0 SC=0 RS=0 MS=0 MT=0 GO=0 DF=1) atmeans
