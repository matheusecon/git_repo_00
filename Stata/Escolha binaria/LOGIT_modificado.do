*********************************
* PREPARACAO DE DADOS PNAD 2014 *
*********************************

*cd "C:<endereço da pasta de saída>"

cd "C:\Users\Adalto\Documents\Trabalho campinas assistencia\saídas"

* apresentar todos os resultados indiferente do numero de linhas:
set more off, perm

clear
 
* LEITURA DAS INFORMACOES DO DESENHO DA AMOSTRA NO ARQUIVO DE DOMICILIOS: infix é o comando que indica ao STATA as variáveis à serem extraídas da PNAD. 
* . infix [nomedavariável1] [posiçãoinicial1-posiçãofinaldavariável1] [nomedavariável2] [posiçãoinicial2-posiçãofinaldavariável2]
*após terminar de indicar as variáveis, inserir o comando using, que indica o endereço da pasta de entrada, onde estão os arquivos .txt com os dados da PNAD no PC.
* a estrutura do comando é 
*using "endereço da pasta de saísa",clear;

#delimit;
infix ano 1-4 UF 5-6 controle 5-12 serie 13-15 sitcen 100 codcens 101 rendamensaldom 162-173
strat 178-184 psu 185-191 numPESDOM 192-193  
using "C:\Users\Adalto\Documents\PNAD\PNAD_2014\dados\DOM2014.txt",clear;
#delimit cr


************ORDENAR OS DADOS*************
**comando sort organiza as observaçoes dos dados atuais em ordem ascendente baseado nos valores das variaveis em varlist
*** neste caso controle e serie sao as variaveis usadas como referencia

#delimit;
sort controle serie, stable;
format controle %15.0g;
format serie %15.0g;
replace controle = float(controle);
replace serie = float(serie);
#delimit cr

save dom2014, replace

* LEITURA DOS DADOS DAS PESSOAS 2014

clear
#delimit;
infix ano 1-4 UF 5-6 controle 5-12 serie 13-15 Sexo 18-18 Idade 27-29 posiocup 119-119
CondDom 30-30 CondF 31-31 Cor 33-33 alfab 69-69 freqescola 70-70 formacaosefreq 73-74 
formacaosenaofreq 79-80 anosDestud 680-681 numcompdomicilio 781-782
pesopes 768-772 rendPerCapta 783-794 ativPrinc 799-799 CredFinan 302-302 
PRONAF 303-303 assistTec 304-304 fonteassist 305-305 condRelEmpr 294-294 comercFutu 297-297 
consProd 300-300 parcCons 301-301 comprador 299-299 PosiOcupTrabPrincAgr 168-169
temempregtemporario 233-233 numempregtemporario 234-234 temempregpermanente 235-235
numempregpermanente 236-236 temajudtrabdodom 174-174 numajudtrabdodom 175-175
area1Empregr 188-194 area2Empregr 207-213 area3Empregr 226-232 area1ContaPropAgr 249-255
area2ContaPropAgr 268-274 area3ContaPropAgr 287-293
using "C:\Users\Adalto\Documents\PNAD\PNAD_2014\dados\PES2014.txt",clear;
#delimit cr 

*****JUNÇÃO DAS INFORMAÇÕES DE DESENHO DA AMOSTRA AO ARQUIVO DE PESSOAS DA PNAD 2014*********
**********Joinby indica ao STATA que a junção das informações devem ser feitas pareando as variáveis 
* controle e serie do banco de dados aberto, que no caso é o de pessoas, usando os dados do outro banco de dados, que é o de domicílios.
#delimit;
sort controle serie, stable;
joinby controle serie using dom2014;
#delimit cr

save pes2014, replace

* DECLARANDO/SETANDO O CONJUNTO DE DADOS COMO SENDO DE AMOSTRA COMPLEXA: como na PNAD a ammostragem é não aleatória, devido a dimensão do país e à intenção de 
*obter dados que representem ao máximo possível a heterogeneidade brasileira, utiliza-se amostragem complexa (estratificada), o que deve ser indicado ao STATA
*utilizando-se o comando svyset, o qual atribui um peso à cada observação. A estrutura do comando é:
* svyset psu [pweight=variáveldepeso], strata[variáveldoestrato] vce(métododeestimaçãodavariância) || informaçõesadicionais
clear
use pes2014, clear

svyset psu [pweight=pesopes], strata(strat) vce(linearized) || _n

*em que vce(linearized) indica que a variância é estimada por linearização de Taylor
* _n indica que a última etapa do processo de amostragem é aleatória

svydes, single
*exibe estratos com uma única observação

save pes2014, replace

* ROTINA DE ALOCACAO DE ESTRATOS COM UM UNICO PSU EM ESTRATOS COM MAIOR NUMERO
* DE OBSERVACOES UTILIZANDO O idonepsu - ANO DE 2014

use pes2014, clear

*primeira vez que usar o idonepsu precisa digitar: findit idonepsu
*o findit encontra um pacote que deve ser instalado no stata clicando em um link azul, para que ele possa ser utilizado.

idonepsu, strata(strat) psu(psu) generate(new)
drop strat psu
rename newstr strat
rename newpsu psu

svyset psu [pweight=pesopes], strata(strat) vce(linearized) || _n

svydes, single

save pes2014, replace


*OBSERVAÇÕES QUE AINDA ESTÃO COM PSU ÚNICO MESMO APÓS UTILIZAÇÃO DO IDONEPSU
*svydes, finalstage
*svydes, finalstage --> é o comando para mostrar as tabelas e identificar estratos com psu único
*tem-se que encontrá-los e depois eliminar obs=1, sendo unit = PSU


drop if strat == 230006  & psu == 170
drop if strat == 350009  & psu == 68
drop if strat == 520004  & psu == 60
drop if strat == 530001  & psu == 33

save pes2014, replace

*convém rodar idonepsu de novo para checar se ao apagar um estrato surgiram outros de psu único.
* DROPAGEM DOS DADOS DE ZONA URBANA E DE OUTRAS PESSOAS QUE NÃO SÃO DE REFERENCIA, 
*DA RENDA PER CAPTA NÃO INFORMADA


drop if sitcen == 1
drop if sitcen == 3
drop if CondDom == 2
drop if CondDom == 3
drop if CondDom == 4
drop if CondDom == 5
drop if CondDom == 6
drop if CondDom == 7
drop if CondDom == 8
drop if rendPerCapta > 5000000
drop if rendPerCapta == 999999999999

save pes2014, replace


*Repetindo idonepsu:

idonepsu, strata(strat) psu(psu) generate(new)
drop strat psu
rename newstr strat
rename newpsu psu

svyset psu [pweight=pesopes], strata(strat) vce(linearized) || _n

svydes, single

save pes2014, replace

*GERANDO AS DUMMIES E OUTRAS VARIÁVEIS DERIVADAS
*Comando gen gera uma nova variável. A estrutura do comando é:
* . gen nomedavariavelnova = valorouexpressãoqueadefine
*Comando replace troca o valor de uma variave já existente por outro.
*RENDA ANUAL DOMICILIAR

gen rendaanualdom = 12*rendamensaldom

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

*MÃO DE OBRA
*_______________EMPREGADO TEMPORARIO___________________________________

gen semempregtemporario = 1 if temempregtemporario == 4
replace semempregtemporario = 0 if temempregtemporario ==2
replace semempregtemporario = 0 if temempregtemporario ==.

gen umempregtemp = 1 if numempregtemporario == 1
replace umempregtemp = 0 if temempregtemporario == 4
replace umempregtemp = 0 if numempregtemporario == 3
replace umempregtemp = 0 if numempregtemporario == 5
replace umempregtemp = 0 if numempregtemporario == 7
replace umempregtemp = 0 if numempregtemporario == 8 
replace umempregtemp = 0 if temempregtemporario ==.

gen doisempregtemp = 1 if numempregtemporario == 3
replace doisempregtemp = 0 if temempregtemporario == 4
replace doisempregtemp = 0 if numempregtemporario == 1
replace doisempregtemp = 0 if numempregtemporario == 5
replace doisempregtemp = 0 if numempregtemporario == 7
replace doisempregtemp = 0 if numempregtemporario == 8
replace doisempregtemp = 0 if temempregtemporario ==.

gen tresempregtemp = 1 if numempregtemporario == 5
replace tresempregtemp = 0 if temempregtemporario == 4
replace tresempregtemp = 0 if numempregtemporario == 1
replace tresempregtemp = 0 if numempregtemporario == 3
replace tresempregtemp = 0 if numempregtemporario == 7
replace tresempregtemp = 0 if numempregtemporario == 8
replace tresempregtemp = 0 if temempregtemporario ==.

gen seisdezempregtemp = 1 if numempregtemporario == 7
replace seisdezempregtemp = 0 if temempregtemporario == 4
replace seisdezempregtemp = 0 if numempregtemporario == 1
replace seisdezempregtemp = 0 if numempregtemporario == 5
replace seisdezempregtemp = 0 if numempregtemporario == 3
replace seisdezempregtemp = 0 if numempregtemporario == 8
replace seisdezempregtemp = 0 if temempregtemporario ==.

gen onzemaisempregtemp = 1 if numempregtemporario == 8
replace onzemaisempregtemp = 0 if temempregtemporario == 4
replace onzemaisempregtemp = 0 if numempregtemporario == 1
replace onzemaisempregtemp = 0 if numempregtemporario == 5
replace onzemaisempregtemp = 0 if numempregtemporario == 7
replace onzemaisempregtemp = 0 if numempregtemporario == 3
replace onzemaisempregtemp = 0 if temempregtemporario ==.

gen temempregtemp = 0
replace temempregtemp=1 if temempregtemporario ==2
*_________________EMPREGADO PERMANENTE_______________________


gen semempregpermanente = 1 if temempregpermanente == 4
replace semempregpermanente = 0 if temempregpermanente == 2
replace semempregpermanente = 0 if temempregpermanente ==.

gen umempregperm = 1 if numempregpermanente == 1
replace umempregperm = 0 if temempregpermanente == 4
replace umempregperm = 0 if numempregpermanente == 3
replace umempregperm = 0 if numempregpermanente == 5
replace umempregperm = 0 if numempregpermanente == 7
replace umempregperm = 0 if numempregpermanente == 8 
replace umempregperm = 0 if temempregpermanente ==.

gen doisempregperm = 1 if numempregpermanente == 3
replace doisempregperm = 0 if temempregpermanente == 4
replace doisempregperm = 0 if numempregpermanente == 1
replace doisempregperm = 0 if numempregpermanente == 5
replace doisempregperm = 0 if numempregpermanente == 7
replace doisempregperm = 0 if numempregpermanente == 8
replace doisempregperm = 0 if temempregpermanente ==.

gen tresempregperm = 1 if numempregpermanente == 5
replace tresempregperm = 0 if temempregpermanente == 4
replace tresempregperm = 0 if numempregpermanente == 1
replace tresempregperm = 0 if numempregpermanente == 3
replace tresempregperm = 0 if numempregpermanente == 7
replace tresempregperm = 0 if numempregpermanente == 8
replace tresempregperm = 0 if temempregpermanente ==.

gen seisdezempregperm = 1 if numempregpermanente == 7
replace seisdezempregperm = 0 if temempregpermanente == 4
replace seisdezempregperm = 0 if numempregpermanente == 1
replace seisdezempregperm = 0 if numempregpermanente == 5
replace seisdezempregperm = 0 if numempregpermanente == 3
replace seisdezempregperm = 0 if numempregpermanente == 8
replace seisdezempregperm = 0 if temempregpermanente ==.

gen onzemaisempregperm = 1 if numempregpermanente == 8
replace onzemaisempregperm = 0 if temempregpermanente == 4
replace onzemaisempregperm = 0 if numempregpermanente == 1
replace onzemaisempregperm = 0 if numempregpermanente == 5
replace onzemaisempregperm = 0 if numempregpermanente == 7
replace onzemaisempregperm = 0 if numempregpermanente == 3
replace onzemaisempregperm = 0 if temempregpermanente ==.

gen temempregperm = 0
replace temempregperm = 1 if temempregpermanente == 2

*RENDA PER CAPTA

*ATIVIDADE PRINCIPAL

gen agricola = 1 if ativPrinc == 1
replace agricola = 0 if ativPrinc ==2
replace agricola = . if ativPrinc ==.

gen nagricola = 1 if ativPrinc == 2
replace nagricola = 0 if ativPrinc ==1
replace nagricola = . if ativPrinc ==.

*UTILIZAÇÃO DO CRÉDITO

gen utilizoucredito = 1 if CredFinan == 2
replace utilizoucredito = 0 if CredFinan == 4
replace utilizoucredito = . if CredFinan == .

*UTILIZAÇÃO DO PRONAF

gen utilizouPRONAF = 1 if PRONAF == 2
replace utilizouPRONAF = 0 if PRONAF == 4
replace utilizouPRONAF = . if PRONAF == .

*UTILIZAÇÃO DO CRÉDITO VIA PRONAF

gen utilPRONAF = 1 if (CredFinan == 2) & (PRONAF == 2)
replace utilPRONAF = 0 if CredFinan ==4
replace utilPRONAF = 0 if PRONAF ==4
replace utilPRONAF = . if CredFinan ==.

save pes2014, replace

*ASSISTÊNCIA TÉCNICA

gen recebeuassistencia = 1 if assistTec == 2
replace recebeuassistencia = 0 if assistTec == 4
replace recebeuassistencia = . if assistTec == .

*CONDIÇÃO EM RELAÇÃO A ROPRIEDADE

gen parceiro = 1 if condRelEmpr == 1
replace parceiro = 0 if condRelEmpr == 2
replace parceiro = 0 if condRelEmpr == 3
replace parceiro = 0 if condRelEmpr == 4
replace parceiro = 0 if condRelEmpr == 5
replace parceiro = 0 if condRelEmpr == 6
replace parceiro = . if condRelEmpr == .

gen arrendatario = 1 if condRelEmpr == 2
replace arrendatario = 0 if condRelEmpr == 1
replace arrendatario = 0 if condRelEmpr == 3
replace arrendatario = 0 if condRelEmpr == 4
replace arrendatario = 0 if condRelEmpr == 5
replace arrendatario = 0 if condRelEmpr == 6
replace arrendatario = . if condRelEmpr == .

gen posseiro = 1 if condRelEmpr == 3
replace posseiro = 0 if condRelEmpr == 1
replace posseiro = 0 if condRelEmpr == 2
replace posseiro = 0 if condRelEmpr == 4
replace posseiro = 0 if condRelEmpr == 5
replace posseiro = 0 if condRelEmpr == 6
replace posseiro = . if condRelEmpr == .

gen cessionario = 1 if condRelEmpr == 4
replace cessionario = 0 if condRelEmpr == 1
replace cessionario = 0 if condRelEmpr == 2
replace cessionario = 0 if condRelEmpr == 3
replace cessionario = 0 if condRelEmpr == 5
replace cessionario = 0 if condRelEmpr == 6
replace cessionario = . if condRelEmpr == .

gen proprietario = 1 if condRelEmpr == 5
replace proprietario = 0 if condRelEmpr == 1
replace proprietario = 0 if condRelEmpr == 2
replace proprietario = 0 if condRelEmpr == 3
replace proprietario = 0 if condRelEmpr == 4
replace proprietario = 0 if condRelEmpr == 6
replace proprietario = . if condRelEmpr == .

gen outracondicao = 1 if condRelEmpr == 6
replace outracondicao = 0 if condRelEmpr == 1
replace outracondicao = 0 if condRelEmpr == 2
replace outracondicao = 0 if condRelEmpr == 3
replace outracondicao = 0 if condRelEmpr == 4
replace outracondicao = 0 if condRelEmpr == 5
replace outracondicao = . if condRelEmpr == .

*COMERCIALIZAÇÃO FUTURA

gen vendafutura = 1 if comercFutu == 2
replace vendafutura = 0 if comercFutu == 4
replace vendafutura = 0 if comercFutu ==.

*CONSUMO DA PRODUÇÃO PARA SUBSISTÊNCIA E PARCELA CONSUMIDA

gen naoconsome = 1 if consProd == 3
replace naoconsome = 0 if consProd == 1
replace naoconsome = . if consProd ==.

gen complemsubsist = 1 if parcCons == 2
replace complemsubsist = 0 if parcCons == 4
replace complemsubsist = 0 if consProd == 3
replace complemsubsist = . if consProd ==.

gen prodsubsist = 1 if parcCons == 4
replace prodsubsist = 0 if parcCons == 2
replace prodsubsist = 0 if consProd == 3
replace prodsubsist = . if consProd ==.

replace consProd = 1 if consProd == 1
replace consProd = 0 if consProd ==3

*PRINCIPAL COMPRADOR

gen compempresa = 1 if comprador == 1
replace compempresa = 0 if comprador == 2
replace compempresa = 0 if comprador == 3
replace compempresa = 0 if comprador == 4
replace compempresa = 0 if comprador == 5
replace compempresa = 0 if comprador == 6
replace compempresa = 0 if comprador == 7
replace compempresa = 0 if comprador ==.

gen compcooperativa = 1 if comprador == 2
replace compcooperativa = 0 if comprador == 1
replace compcooperativa = 0 if comprador == 3
replace compcooperativa = 0 if comprador == 4
replace compcooperativa = 0 if comprador == 5
replace compcooperativa = 0 if comprador == 6
replace compcooperativa = 0 if comprador == 7
replace compcooperativa = 0 if comprador ==.

gen compgoverno = 1 if comprador == 3
replace compgoverno = 0 if comprador == 1
replace compgoverno = 0 if comprador == 2
replace compgoverno = 0 if comprador == 4
replace compgoverno = 0 if comprador == 5
replace compgoverno = 0 if comprador == 6
replace compgoverno = 0 if comprador == 7
replace compgoverno = 0 if comprador ==.

gen compproprietario = 1 if comprador == 4
replace compproprietario = 0 if comprador == 1
replace compproprietario = 0 if comprador == 2
replace compproprietario = 0 if comprador == 3
replace compproprietario = 0 if comprador == 5
replace compproprietario = 0 if comprador == 6
replace compproprietario = 0 if comprador == 7
replace compproprietario = 0 if comprador ==.

gen compintermediario = 1 if comprador == 5
replace compintermediario = 0 if comprador == 1
replace compintermediario = 0 if comprador == 2
replace compintermediario = 0 if comprador == 3
replace compintermediario = 0 if comprador == 4
replace compintermediario = 0 if comprador == 6
replace compintermediario = 0 if comprador == 7
replace compintermediario = 0 if comprador ==.

gen compconsdireto = 1 if comprador == 6
replace compconsdireto = 0 if comprador == 1
replace compconsdireto = 0 if comprador == 2
replace compconsdireto = 0 if comprador == 3
replace compconsdireto = 0 if comprador == 4
replace compconsdireto = 0 if comprador == 5
replace compconsdireto = 0 if comprador == 7
replace compconsdireto = 0 if comprador ==.

gen outrocomprador = 1 if comprador == 7
replace outrocomprador = 0 if comprador == 1
replace outrocomprador = 0 if comprador == 2
replace outrocomprador = 0 if comprador == 3
replace outrocomprador = 0 if comprador == 4
replace outrocomprador = 0 if comprador == 5
replace outrocomprador = 0 if comprador == 6
replace outrocomprador = 0 if comprador ==.

*POSIÇÃO OCUPADA NO TRABALHO PRINCIPAL AGRÍCOLA-> NÃO CONVÉM.

*ÁREA DO EMPREENDIMENTO

gen a1emp = area1Empregr
replace a1emp = 0 if area1Empregr ==.

gen a2emp = area2Empregr
replace a2emp = 0 if area2Empregr ==.

gen a3emp = area3Empregr
replace a3emp = 0 if area3Empregr ==.

gen a1cont = area1Empregr
replace a1cont = 0 if area1ContaPropAgr ==.

gen a2cont = area2Empregr
replace a2cont = 0 if area2ContaPropAgr ==.

gen a3cont = area3Empregr
replace a3cont = 0 if area3ContaPropAgr ==.

gen areatotal1 = a1emp + a2emp + a3emp + a1cont + a2cont + a3cont
replace areatotal1 = 0 if areatotal1 == . 


*Dummie região do país

gen norte = 0
replace norte = 1 if AC == 1
replace norte = 1 if RO == 1
replace norte = 1 if AM == 1
replace norte = 1 if RR == 1
replace norte = 1 if PA == 1
replace norte = 1 if AP == 1
replace norte = 1 if TO == 1

gen nordeste = 0
replace nordeste = 1 if MA == 1
replace nordeste = 1 if PI == 1
replace nordeste = 1 if CE == 1
replace nordeste = 1 if RN == 1
replace nordeste = 1 if PB == 1
replace nordeste = 1 if PE == 1
replace nordeste = 1 if AL == 1
replace nordeste = 1 if SE == 1
replace nordeste = 1 if BA == 1

gen CO = 0
replace CO = 1 if MT == 1
replace CO = 1 if GO == 1
replace CO = 1 if DF == 1
replace CO = 1 if MS == 1

gen sudeste = 0
replace sudeste = 1 if MG == 1
replace sudeste = 1 if ES == 1
replace sudeste = 1 if RJ == 1
replace sudeste = 1 if SP == 1

gen sul = 0
replace sul = 1 if PN == 1
replace sul = 1 if SC == 1
replace sul = 1 if RS == 1

*______________DROPAGEM DE NAO FAMILIARES___________________

drop if posiocup==1
drop if posiocup==2
drop if posiocup==5
drop if posiocup==6
drop if posiocup==7
drop if posiocup==8
drop if areatotal1>4800000
drop if rendamensaldom>30000

*Estatistica descritiva para as regiões
svy linearized : tab recebeuassistencia if norte==1 
svy linearized : tab recebeuassistencia if nordeste==1 
svy linearized : tab recebeuassistencia if CO==1 
svy linearized : tab recebeuassistencia if sudeste==1 
svy linearized : tab recebeuassistencia if sul==1 
*Estatistica descritiva para as condições em relação à propriedade
svy linearized : tab recebeuassistencia if proprietario==1   
svy linearized : tab recebeuassistencia if posseiro==1 
svy linearized : tab recebeuassistencia if cessionario==1 
svy linearized : tab recebeuassistencia if arrendatario==1 
svy linearized : tab recebeuassistencia if parceiro==1 
svy linearized : tab recebeuassistencia if outracondicao==1 
*Estatistica descritiva para a carcterística de consumo
svy linearized : tab recebeuassistencia if prodsubsist==1 
svy linearized : tab recebeuassistencia if complemsubsist==1 
svy linearized : tab recebeuassistencia if naoconsome==1 
*Estatistica descritiva para o principal comprador
svy linearized : tab recebeuassistencia if compconsdireto==1 
svy linearized : tab recebeuassistencia if compempresa==1 
svy linearized : tab recebeuassistencia if compcooperativa==1 
svy linearized : tab recebeuassistencia if compgoverno==1 
svy linearized : tab recebeuassistencia if compproprietario==1 
svy linearized : tab recebeuassistencia if compintermediario==1 
svy linearized : tab recebeuassistencia if outrocomprador==1 

*Composição dos não brancos
svy linearized : tab Cor if nbranco==1
svy linearized : tab Cor if recebeuassistencia==1
svy linearized : tab recebeuassistencia if Cor==0
svy linearized : tab recebeuassistencia if Cor==2
svy linearized : tab recebeuassistencia if Cor==4
svy linearized : tab recebeuassistencia if Cor==6
svy linearized : tab recebeuassistencia if Cor==8

*ANÁLISE DE REGRESSÃO 

*Logit e Probit:

. logit recebeuassistencia Idade rendPerCapta estudo FEM nbranco posseiro cessionario arrendatario parceiro outracondicao prodsubsist naoconsome temempregtemp temempregperm norte nordeste CO sudeste compconsdireto compempresa compcooperativa compproprietario compintermediario outrocomprador [pw = pesopes], nolog 
. lroc [fweight = pesopes]
. estat class [fweight = pesopes]

. probit recebeuassistencia Idade rendPerCapta estudo FEM nbranco posseiro cessionario arrendatario parceiro outracondicao prodsubsist naoconsome temempregtemp temempregperm norte nordeste CO sudeste compconsdireto compempresa compcooperativa compproprietario compintermediario outrocomprador [pw = pesopes], nolog 
. lroc [fweight = pesopes]
. estat class [fweight = pesopes]

. mfx
. mfx, at(FEM=0) 

*______________EFEITO da raça para diferentes idades ________________________________
. margins, at(Idade=20 nbranco=1 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=1 compconsdireto=0 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
. margins, at(Idade=35 nbranco=1 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=1 compconsdireto=0 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
. margins, at(Idade=50 nbranco=1 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=1 compconsdireto=0 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
. margins, at(Idade=65 nbranco=1 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=1 compconsdireto=0 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
. margins, at(Idade=20 nbranco=0 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=1 compconsdireto=0 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
. margins, at(Idade=35 nbranco=0 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=1 compconsdireto=0 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
. margins, at(Idade=50 nbranco=0 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=1 compconsdireto=0 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
. margins, at(Idade=65 nbranco=0 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=1 compconsdireto=0 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans

*______________EFEITO Do principal comprador para diferentes escolaridades ________________________________
*consumidor direto
. margins, at(estudo=1 nbranco=1 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=1 compconsdireto=1 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
. margins, at(estudo=5 nbranco=1 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=1 compconsdireto=1 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
. margins, at(estudo=10 nbranco=1 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=1 compconsdireto=1 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
. margins, at(estudo=15 nbranco=1 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=1 compconsdireto=1 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
*empresa
. margins, at(estudo=1 nbranco=1 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=1 compconsdireto=0 compempresa=1 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
. margins, at(estudo=5 nbranco=1 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=1 compconsdireto=0 compempresa=1 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
. margins, at(estudo=10 nbranco=1 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=1 compconsdireto=0 compempresa=1 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
. margins, at(estudo=15 nbranco=1 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=1 compconsdireto=0 compempresa=1 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
*cooperativa
. margins, at(estudo=1 nbranco=1 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=1 compconsdireto=0 compempresa=0 compcooperativa=1 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
. margins, at(estudo=5 nbranco=1 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=1 compconsdireto=0 compempresa=0 compcooperativa=1 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
. margins, at(estudo=10 nbranco=1 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=1 compconsdireto=0 compempresa=0 compcooperativa=1 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
. margins, at(estudo=15 nbranco=1 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=1 compconsdireto=0 compempresa=0 compcooperativa=1 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
*demais compradores principais
. margins, at(estudo=1 nbranco=1 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=1 compconsdireto=0 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
. margins, at(estudo=5 nbranco=1 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=1 compconsdireto=0 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
. margins, at(estudo=10 nbranco=1 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=1 compconsdireto=0 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
. margins, at(estudo=15 nbranco=1 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=1 compconsdireto=0 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans

*____________Efeito do destino da produção e das regiões_______________________________
*subsistencia
. margins, at(nbranco=1 prodsubsist=1 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=1 nordeste=0 CO=0 sudeste=0 compconsdireto=0 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
. margins, at(nbranco=1 prodsubsist=1 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=1 CO=0 sudeste=0 compconsdireto=0 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
. margins, at(nbranco=1 prodsubsist=1 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=1 sudeste=0 compconsdireto=0 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
. margins, at(nbranco=1 prodsubsist=1 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=1 compconsdireto=0 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
. margins, at(nbranco=1 prodsubsist=1 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=0 compconsdireto=0 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
*complementa subsistencia
. margins, at(nbranco=1 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=1 nordeste=0 CO=0 sudeste=0 compconsdireto=0 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
. margins, at(nbranco=1 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=1 CO=0 sudeste=0 compconsdireto=0 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
. margins, at(nbranco=1 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=1 sudeste=0 compconsdireto=0 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
. margins, at(nbranco=1 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=1 compconsdireto=0 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
. margins, at(nbranco=1 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=0 compconsdireto=0 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
*Não consome parte da produção
. margins, at(nbranco=1 prodsubsist=0 naoconsome=1 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=1 nordeste=0 CO=0 sudeste=0 compconsdireto=0 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
. margins, at(nbranco=1 prodsubsist=0 naoconsome=1 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=1 CO=0 sudeste=0 compconsdireto=0 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
. margins, at(nbranco=1 prodsubsist=0 naoconsome=1 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=1 sudeste=0 compconsdireto=0 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
. margins, at(nbranco=1 prodsubsist=0 naoconsome=1 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=1 compconsdireto=0 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
. margins, at(nbranco=1 prodsubsist=0 naoconsome=1 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=0 compconsdireto=0 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans

*_____________Efeito de ter empregados temporários , ser cessionario, ou outracondição para diferentes rendas__________________
*_____________PROPRIETARIO e demais condições___________________
*Não tem empregado temporario________________
. margins, at(rendPerCapta=200 nbranco=1 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=0 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=1 compconsdireto=0 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
. margins, at(rendPerCapta=800 nbranco=1 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=0 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=1 compconsdireto=0 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
. margins, at(rendPerCapta=1400 nbranco=1 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=0 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=1 compconsdireto=0 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
. margins, at(rendPerCapta=2000 nbranco=1 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=0 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=1 compconsdireto=0 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
*Tem empregado temporário________________
. margins, at(rendPerCapta=200 nbranco=1 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=1 compconsdireto=0 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
. margins, at(rendPerCapta=800 nbranco=1 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=1 compconsdireto=0 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
. margins, at(rendPerCapta=1400 nbranco=1 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=1 compconsdireto=0 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
. margins, at(rendPerCapta=2000 nbranco=1 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=0 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=1 compconsdireto=0 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
*_____________Cessioario___________________
*Não tem empregado temporario________________
. margins, at(rendPerCapta=200 nbranco=1 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=0 posseiro=0 cessionario=1 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=1 compconsdireto=0 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
. margins, at(rendPerCapta=800 nbranco=1 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=0 posseiro=0 cessionario=1 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=1 compconsdireto=0 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
. margins, at(rendPerCapta=1400 nbranco=1 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=0 posseiro=0 cessionario=1 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=1 compconsdireto=0 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
. margins, at(rendPerCapta=2000 nbranco=1 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=0 posseiro=0 cessionario=1 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=1 compconsdireto=0 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
*Tem empregado temporário________________
. margins, at(rendPerCapta=200 nbranco=1 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=1 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=1 compconsdireto=0 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
. margins, at(rendPerCapta=800 nbranco=1 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=1 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=1 compconsdireto=0 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
. margins, at(rendPerCapta=1400 nbranco=1 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=1 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=1 compconsdireto=0 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
. margins, at(rendPerCapta=2000 nbranco=1 prodsubsist=0 naoconsome=0 FEM=0 temempregperm=0 temempregtemp=1 posseiro=0 cessionario=1 arrendatario=0 parceiro=0 outracondicao=0 norte=0 nordeste=0 CO=0 sudeste=1 compconsdireto=0 compempresa=0 compcooperativa=0 compproprietario=0 compintermediario=0 outrocomprador=0) atmeans
