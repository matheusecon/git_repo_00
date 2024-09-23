*************************************************************
* PREPARACAO DE DADOS PNAD 2015
*************************************************************

cd "D:\Meus Documentos\Desktop\Trabalho infantil\Testando"

set more off
set memory 512m

* LEITURA DOS DADOS DAS PESSOAS 2015

clear
#delimit;
infix ano 1-4 serie 13-15 controle 5-12 ordem 16-17 idade 27-29 UF 5-6 infantil 93-93 jovem 152-152 estuda 68-68 rede 69-69 redep 70-70

curso 71-72 integrantes 787-788 ruralurbano 790-790 raca 33-33 chefe 30-30 chefeI 31-31 metropole 789-789 ae 703-704 cia 39-39 estadocivil 41-41 sexo 18-18

iniciotrab 442-443 progama 651-652 peso 791-795 criancas 803-803 numfam 32-32 pesofam 796-800 componentes 804-805 nivel 820-820 rendapcp 806-817  using "D:\Meus Documentos\Desktop\Trabalho infantil\Desemprego\2015\Dados\PES2015.txt",clear;
#delimit cr

* ORDENANDO 

sort controle serie
save "D:\Meus Documentos\Desktop\Trabalho infantil\Testando\Pesso2015.dta"
clear

* LEITURA DOS DADOS DE DOMICILIOS 2015

clear
#delimit;
infix ano 1-4 uf 5-6 controle 5-12 serie 13-15 strat 178-184 psu 185-191 rendapc 194-205 ruralurnano 100-100 metropole 101-101 abastecimento 56-56 comodos 26-27

saneamento 64-64 eletrica 66-66 terreno 55-55 destino 65-65  using "D:\Meus Documentos\Desktop\Trabalho infantil\Desemprego\2015\Dados\DOM2015.txt", clear;
#delimit cr

*ORDENANDO

sort controle serie
save "D:\Meus Documentos\Desktop\Trabalho infantil\Testando\Domi2015.dta"

*JUNÇÃO DOS DADOS

use "D:\Meus Documentos\Desktop\Trabalho infantil\Testando\Pesso2015.dta", clear
#delimit;
merge m:m controle serie using "D:\Meus Documentos\Desktop\Trabalho infantil\Testando\Domi2015.dta";
#delimit cr

* EXCLUINDO OBS N COINCIDENTES

keep if _merge==3
drop _merge


**Tem-se que eliminar psu unico, sendo unit = PSU

#delimit;
drop if strat == 230006  & psu == 170;
drop if strat == 350009  & psu == 68;
drop if strat == 140001	& psu == 32;
drop if strat == 230003	& psu == 21;
drop if strat == 260014	& psu == 376;
drop if strat == 330030	& psu == 599;
drop if strat == 350016	& psu == 107;
drop if strat == 350016	& psu == 108;
drop if strat == 420006	& psu == 50;
#delimit cr


*** Declarando o conjunto de dados como sendo de amostragem complexa ***

set more off

svyset psu [pweight=peso], strata(strat) vce(linearized) || _n

svydes, single


*********************CRIANDO A VARIAVEL DEPENDENTE*******************************

* recodificando as variáveis para 1 e 0
recode infantil (1=1) (3=0)
recode jovem (1=1) (3=0)

* restringindo para as idades de interesse e atribuindo valores 1 e 0
gen jovemI=1 if jovem==1 & idade>=10 & idade<15
replace jovemI=0 if jovem==0 & idade>=10 & idade<15

**** Criando a Variável Dependente **** 

*gerando a variável de trabalho infantil, unindo jovemI e infantil
gen trabinfantil=1 if jovemI==1 | infantil==1
replace trabinfantil=0 if jovemI==0 | infantil==0



****************VARIÁVEIS EXPLICATIVAS PESSOAS**********************

**CHEFE DE FAMILIA

*** Retirando pensionistas, empregados domê´´icos e seus parentes ***

drop if chefeI>=6

***Vamos gerar a varivel pessoa de referencia.

gen p_f=.
replace p_f=1 if chefeI==1
replace p_f=0 if (chefeI==2 |chefeI==3 |chefeI==4 |chefeI==5)

***** O comando egen criará uma variável de agrupamento familiar (fam) que será composta
***por (em cada agrupamento)individuos das mesmas controle, serie e numfam. 
***Nesse caso, iremos separar os individuos por familias que possuem crianças que realizam trabalho infantil


egen float fam = group(UF controle serie numfam)
bysort fam: egen float referencia_fam = mean(p_f)

**Associando as criaças às familias**

bysort fam: egen  float infantil_fam= mean(trabinfantil)


*** Criando uma variÃ¡vel nivel de instruÃ§Ã£o para pessoa de referÃªncia ***

gen nivelinstrucao_PR = nivel if chefeI==1

**Dummy para sem instrução
gen s_inst=.
replace s_inst=1 if nivelinstrucao_PR==1 | nivelinstrucao_PR==2
replace s_inst=0 if nivelinstrucao_PR>=1

drop if s_inst==1

***Não vamos utilizar pois não há ana amostra ninguem sem instrução. Por isso foi dropada do arquivo de dados***

***Criando dummy para fundamental completo***

gen f_completo=.
replace f_completo=1 if nivelinstrucao_PR==3 | nivelinstrucao_PR==4
replace f_completo=0 if nivelinstrucao_PR==1 | nivelinstrucao_PR==2 | nivelinstrucao_PR==5 |nivelinstrucao_PR==6 | nivelinstrucao_PR==7 | nivelinstrucao_PR==8

bysort fam: egen float fundamental_fam = mean(f_completo)

** gerando a dummy para mÃ©dio completo***

gen m_completo=.
replace m_completo=1 if nivelinstrucao_PR==5 | nivelinstrucao_PR==6
replace m_completo=0 if nivelinstrucao_PR==1 | nivelinstrucao_PR==2 | nivelinstrucao_PR==3 |nivelinstrucao_PR==4 | nivelinstrucao_PR==7 | nivelinstrucao_PR==8

bysort fam: egen float medio_fam = mean(m_completo)

**Gerando dummy para superior completo***

gen s_completo=.
replace s_completo=1 if nivelinstrucao_PR==7 
replace s_completo=0 if nivelinstrucao_PR==1 | nivelinstrucao_PR==2 | nivelinstrucao_PR==3 |nivelinstrucao_PR==4 | nivelinstrucao_PR==5 | nivelinstrucao_PR==6| nivelinstrucao_PR==8

bysort fam: egen float superior_fam = mean(s_completo)

**Anos de estudo do chefe de familia**


gen ae_PR= ae if chefeI==1

bysort fam: egen float ae_fam = mean(ae_PR)


**Recodificando sexo e associando Ã  chefe de familia

recode sexo (2=1) (4=0)

gen sexo_PR= sexo if chefeI==1

gen chefmulher=.
replace chefmulher=1 if sexo_PR==0 
replace chefmulher=0 if sexo_PR==1

bysort fam: egen float mulher_fam = mean(chefmulher)


*Recodificando cor e associando Ã  chefe de famÃ­lia

replace raca=1 if raca==2
replace raca=0 if (raca==4 | raca==6 | raca==8 | raca==0 | raca==9)

gen raca_PR= raca if chefeI==1

gen branco=.
replace branco=1 if raca_PR==1
replace branco=0 if raca_PR==0


bysort fam: egen float branco_fam = mean(branco)


**estado civil do chefe**

gen matrim=.
replace matrim=1 if estadocivil==1
replace matrim=0 if (estadocivil==3 | estadocivil==5 | estadocivil==7 | estadocivil==0)

gen casado_PR= matrim if chefe==1

gen casado=.
replace casado=1 if casado_PR==1
replace casado=0 if casado_PR==0

bysort fam: egen float casado_fam = mean(casado)

*Companheiro do chefe** 

replace cia=1 if cia==1
replace cia=0 if (cia==3 | cia==5)

gen cia_PR= cia if chefe==1

gen companheiro=.
replace companheiro=1 if cia_PR==1
replace companheiro=0 if cia_PR==0

bysort fam: egen float companheiro_fam = mean(companheiro)

**Chefe exerceu trabalho infantil**

gen inicio=.
replace inicio=1 if  iniciotrab>=4 & iniciotrab<15
replace inicio=0 if 15<=iniciotrab


gen trabinfanti_PR= inicio if chefeI==1

gen inicio_fam=.
replace inicio_fam=1 if trabinfanti_PR==1
replace inicio_fam=0 if trabinfanti_PR==0

bysort fam: egen float infantil_PR= mean(inicio_fam)


 
**Rural urbana**

gen urbano=.
replace urbano=1 if (ruralurbano==1 | ruralurbano==2 | ruralurbano==3)
replace urbano=0 if (ruralurbano==4 | ruralurbano==5 | ruralurbano==6 | ruralurbano==7 | ruralurbano==8)

**metropole**

gen metrol=.
replace metrol=1 if (metropole==1 | metropole==2)
replace metrol=0 if metropole==3

**rede de ensino**

gen publica=.
replace publica=1 if rede==2
replace publica=0 if rede==4


**Fazendo ln da renda

drop if rendapc<190.80
drop if rendapc>10000

gen lnrendapc= ln(rendapc)




**********************Criando as regiões de estudo****************************

gen Norte=.
replace Norte=1 if UF>=11 & UF<=17
replace Norte=0 if UF>17

gen Nordeste=.
replace Nordeste=1 if UF>= 21 & UF<=29
replace Nordeste=0 if UF>29 | UF<21

gen Sudeste=.
replace Sudeste=1 if UF>=31 & UF<=35
replace Sudeste=0 if UF>35 | UF<31

gen Sul=.
replace Sul=1 if UF>=41 & UF<=43
replace Sul=0 if UF>43 | UF<41

gen CO=.
replace CO=1 if UF>=50 & UF<=53
replace CO=0 if UF>53 | UF<50 

** Domicilio tem energia**
gen energia=.
replace energia=1 if eletrica==1
replace energia=0 if (eletrica==3 | eletrica==5)

** Domicilio tem abastecimento de agua**

gen agua=.
replace agua=1 if abastecimento==1 
replace agua=0 if abastecimento==3

** Domicilio tem esgoto**

gen esgoto=.
replace esgoto=1 if (saneamento==1 | saneamento==2)
replace esgoto=0 if (saneamento==3 | saneamento==4 | saneamento==5 | saneamento==6 | saneamento==7)

** Destino do lixo**

gen coleta=.
replace coleta=1 if (destino==1 | destino==2)
replace coleta=0 if (destino==3 | destino==4 | destino==5 | destino==6)

** terreno**

gen ter=.
replace ter=1 if terreno==2
replace ter=0 if terreno==4

**comodos**

gen com=.
replace com=1 if comodos>=1 & comodos<=3
replace com=0 if comodos>3



**Estimação**

**************INSERINDO VARIAVEIS INDIVIDUO*******************

logit trabinfantil sexo idade if urbano==1

logit trabinfantil sexo idade if urbano==0


*********INSERINDO VARIÁVEIS DA FAMÍLIA***********************

logit trabinfantil sexo idade lnrendapc infantil_PR casado_fam medio_fam superior_fam if urbano==1 [pweight=peso], vce (robust)

logit trabinfantil sexo idade lnrendapc infantil_PR casado_fam medio_fam superior_fam if urbano==0 [pweight=peso], vce (robust) 

**************INSERINDO VARIÁVEL DE REGIÃO*********************************BASE: SUL

logit trabinfantil sexo idade lnrendapc infantil_PR casado_fam medio_fam superior_fam Norte Sudeste Nordeste CO if urbano==1 [pweight=peso], vce (robust) 


logit trabinfantil sexo idade lnrendapc infantil_PR  casado_fam medio_fam superior_fam Norte Sudeste Nordeste CO if urbano==0 [pweight=peso], vce (robust) 

****Modelo final e Razão de chances****

logit trabinfantil sexo idade lnrendapc infantil_PR casado_fam medio_fam superior_fam Norte Sudeste Nordeste CO if urbano==1, vce(robust) or

logit trabinfantil sexo idade lnrendapc infantil_PR casado_fam medio_fam superior_fam Norte Sudeste Nordeste CO if urbano==0, vce(robust) or










