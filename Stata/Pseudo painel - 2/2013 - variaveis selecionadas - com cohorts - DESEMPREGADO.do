*************************************************************
* PREPARACAO DE DADOS PNAD 2013
*************************************************************

cd "C:\Users\Rafael Curi\Dropbox\Economia\Mestrado_UFV_2017\PNAD\PNAD_2013\Dados"

set more off
set memory 512m
 
* LEITURA DAS INFORMACOES DO DESENHO DA AMOSTRA NO ARQUIVO DE DOMICILIOS
*ESSAS LINHAS PERMANECEM FIXAS
clear
#delimit;
infix ano 1-4 UF 5-6 controle 5-12 serie 13-15  tipo 16-17   
strat 178-184 psu 185-191 
using "C:\Users\Rafael Curi\Dropbox\Economia\Mestrado_UFV_2017\PNAD\PNAD_2013\Dados\DOM2013.txt",clear;
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
infix ano 1-4 UF 5-6 controle 5-12 serie 13-15 

ordem 16-17 Sexo 18-18 DiaNasc 19-20 MesNasc 21-22 AnoNasc 23-26 Idade 27-29

SePessRef 30-30 CondFam 31-31 Cor 33-33 MoracMae 35-35 EstCiv 43-43 

LugNasc 47-48 TempMoraUF 51-51 TempMoraMun 63-63 

Alfabet 69-69 Estud 70-70 

AcesNet3m 86-86

SeTrabDom 150-150

TrabSemRef 154-154

militar 307-307

funpublico 308-308

Pensao 518-518 

SeRendFinanc 617-618

NFilhosM 633-634 NFilhosF 635-636 

TempoEstudo 669-670

EconAtiva 671-671

desocupado 672-672

procuroutrabNosult7d 507-507

procuroutrabNosult23d 508-508

procuroutrabNosult30d 509-509

RMDPC 772-783

FRMDPC 784-785

pesopes 757-761 pesofam 762-766

using "C:\Users\Rafael Curi\Dropbox\Economia\Mestrado_UFV_2017\PNAD\PNAD_2013\Dados\PES2013.txt",clear;
#delimit cr 


*****JUNÇÃO DAS INFORMAÇÕES DE DESENHO DA AMOSTRA AO ARQUIVO DE PESSOAS DA PNAD 2013*********
**********Joinby
#delimit;
sort controle serie, stable;
joinby controle serie using dom2013;
#delimit cr

save pes2013, replace

* DECLARANDO/SETANDO O CONJUNTO DE DADOS COMO SENDO DE AMOSTRA COMPLEXA

clear
use pes2013, clear

svyset psu [pweight=pesopes], strata(strat) vce(linearized) || _n

svydes, single

save pes2013, replace


* ROTINA DE ALOCACAO DE ESTRATOS COM UM UNICO PSU EM ESTRATOS COM MAIOR NUMERO
* DE OBSERVACOES UTILIZANDO O DO.FILE idonepsu - ANO DE 2013

use pes2013, clear

*findit idonepsu (primeira vez que usar)
* Instalar o idonepsu (primeira vez que usar
*o comando: findit idonepsu 

#delimit;
idonepsu, strata(strat) psu(psu) generate(new);
drop strat psu;
rename newstr strat;
rename newpsu psu;
#delimit cr

svyset psu [pweight=pesopes], strata(strat) vce(linearized) || _n

svydes, single

save pes2013, replace


*OBSERVAÇÕES QUE AINDA ESTÃO COM PSU ÚNICO MESMO APÓS UTILIZAÇÃO DO IDONEPSU
svydes, finalstage

*tem-se que eliminar obs=1, sendo unit = PSU

#delimit;
drop if strat == 230006  & psu == 115;
drop if strat == 290003  & psu == 35;
drop if strat == 330026  & psu == 326;
drop if strat == 350027  & psu == 186;
drop if strat == 350034  & psu == 238 
#delimit cr

*convém rodar idonepsu de novo para checar se ao apagar um estrato surgiram outros de psu único.


*ANÁLISE DE REGRESSÃO
drop if RMDPC > 200000 & RMDPC!=.
svy: regress RMDPC Idade
estat effects, meff // para analisar o efeito do plano amostral!

* Para comparação

regress RMDPC Idade

* Efeitos marginais com MFX 
mfx compute, dydx at(mean)

* Elasticidades com MFX
mfx compute, eyex at(mean)


*******************************************
*********GERAÇÃO DE DUMMIES****************
*******************************************

****************GERANDO DUMMIES DE ANO
gen D3 =.
replace D3 =1 if ano ==2013
replace D3 =0 if D3 ==.

gen D4=.
replace D4 =1 if ano ==2014
replace D4 =0 if D4 ==.


gen D5 =.
replace D5 =1 if ano ==2015
replace D5 =0 if D5 ==.

****************RECODIFICANDO DUMMIES 
**Sexo**
 recode Sexo (2=1) (4=0)

**Cor**
 recode Cor (4=0) (2=1) (6=0) (8=0) (0=0) (9=0)
 
**mãe residente no domicílio**
 recode MoracMae (2=1) (4=0)

**Estado Civil**
 recode EstCiv (1=1) (3=0) (5=0) (7=0) (0=0)
 
**Tempo na UF**
 recode TempMoraUF (2=1) (.=0)
 
**Tempo no Município**
 recode TempMoraMun (2=1) (.=0)
 
**Sabe Ler ou Escrever**
 recode Alfabet (1=1) (3=0)
 
**Frequenta Escola ou Creche**
 recode Estud (2=1) (4=0) 
 
**Acesso a Internet nos Ultimos 3 Meses**
 recode AcesNet3m (1=1) (3=0)
 
**Cuidava dos afazeres domésticos na semana de referência**
 recode SeTrabDom (2=1) (4=0)

**Recebia normalmente rendimento que não era proveniente de trabalho**
 recode Pensao (2=1) (4=0)
 
**Recebia normalmente juros de caderneta de poupança ou de outras aplicações financeiras**
 recode SeRendFinanc (08=1) (.=0)
 
**Numero de Filhos**
  recode NFilhosM (.=0)
  recode NFilhosF (.=0)
  gen numtotalfilho = NFilhosM + NFilhosF
  
  
** total dos anos de estudo ***
 recode TempoEstudo (1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6) (8=7) (9=8) (10=9) (11=10) (12=11) (13=12) (14=13) (15=14) (16=15)
 drop if TempoEstudo ==17

** empregado na semana de referencia que era militar ***
 recode militar (2=1) (4=0)
 drop if militar ==1
 
** empregado na semana de referencia que era funcionario publico ***
 recode funpublico (1=1) (3=0) 
 drop if funpublico ==1
 
** desocupado que tomou alguma providencia para arrumar trabalho nos ultimos 30 dias (achamaos mais logico que apenas na semana de referencia) ***
 recode procuroutrabNosult7d (1=1) (3=0) 
 recode procuroutrabNosult23d (2=1) (4=0) 
 recode procuroutrabNosult30d (1=1) (3=0) 
 
 gen procuroutrab =.
 replace procuroutrab =1 if procuroutrabNosult7d == 1 | procuroutrabNosult23d == 1 | procuroutrabNosult30d == 1
 replace procuroutrab =0 if procuroutrab ==.
 
** se faz parte da populacao economicamente ativa ***
 recode EconAtiva (1=1) (2=0)
 drop if EconAtiva ==0
 
**Variáveis Dependentes**
 recode desocupado (1=0) (2=1)
 
 **Se trabalhou na semana de referencia**
 recode TrabSemRef (3=1) (1=0)

 ** CRIANDO A VARIÁVEL DE DESEMPREGO (ESTAVA DESOCUPADO E PROCUROU TRABALHO NOS ULTIMOS 30 DIAS) **
#delimit
gen desempregado =0;
replace desempregado = 1 if desocupado==1 & procuroutrab ==1;
#delimit cr
*replace desempregado=. if desocupado ==0; 
*replace desempregado =. if procuroutrab ==0;

 
 ** CRIANDO A VARIÁVEL PESSOA DE REFERÊNCIA NO DOMICÍLIO **
#delimit
gen ref =0;
replace ref = 1 if SePessRef==1;
egen float fam = group(UF controle serie num_fam)
bysort fam: egen float referencia_fam = mean(ref)
#delimit cr

******REGIÕES BRASILEIRAS
*gen Reg1=UF
*gen Reg2=UF
*gen Reg3=UF
*gen Reg4=UF

*replace Reg1=0 if UF<=29
*replace Reg1=0 if UF>=41
*replace Reg1=1 if UF>=31 & UF<=35

*replace Reg2=0 if UF<=35
*replace Reg2=0 if UF>=50
*replace Reg2=1 if UF>=41 & UF<=43

*replace Reg3=0 if UF<=43
*replace Reg3=1 if UF>=50

*replace Reg4=0 if UF>=21
*replace Reg4=1 if UF<=17

**************************************************************************************************
*DROPAGEM DA RENDA PER CAPTA NÃO INFORMADA E DA QUE NÃO FAZ SENTIDO*******************************
**************************************************************************************************
drop if RMDPC > 200000
drop if RMDPC ==.
drop if FRMDPC == 01
drop if FRMDPC == 00

**dropando outliers da renda**
*geep if inrange (RendMensDom, 200, 20000)

**criando renda per capta**
**gen rendapercapta = vrfam/membrosf

**criando logaritmo da renda**
*gen lnRendMensDom = log10(RendMensDom)

*Dropando os individuos que têm menos de 17 anos e mais de 65 anos**
drop if AnoNasc < 1948
drop if AnoNasc > 1997

 
************************************************************************************
************************************************************************************
****************************CRIANDO VAR COHORTS*************************************
************************************************************************************
************************************************************************************

gen nascimento=.
replace nascimento = 1 if AnoNasc >=1960 & AnoNasc <=1962
replace nascimento = 2 if AnoNasc >=1963 & AnoNasc <=1965
replace nascimento = 3 if AnoNasc >=1966 & AnoNasc <=1968
replace nascimento = 4 if AnoNasc >=1969 & AnoNasc <=1971
replace nascimento = 5 if AnoNasc >=1972 & AnoNasc <=1974
replace nascimento = 6 if AnoNasc >=1975 & AnoNasc <=1977
replace nascimento = 7 if AnoNasc >=1979 & AnoNasc <=1981
replace nascimento = 8 if AnoNasc >=1982 & AnoNasc <=1984
replace nascimento = 9 if AnoNasc >=1985 & AnoNasc <=1987
replace nascimento = 10 if AnoNasc >=1988 & AnoNasc <=1990
replace nascimento = 11 if AnoNasc >=1991 & AnoNasc <=1993
replace nascimento = 12 if AnoNasc >=1994 & AnoNasc <=1996
replace nascimento = 13 if AnoNasc >=1997 & AnoNasc <=1998

egen float cohorts = group(nascimento Sexo Cor)


sum cohorts
sum ano
order cohorts nascimento Sexo Cor
sort cohorts


collapse (mean) ano controle serie ref ordem FRMDPC RMDPC militar funpublico Sexo DiaNasc MesNasc AnoNasc Idade CondFam Cor MoracMae EstCiv LugNasc TempMoraUF TempMoraMun Alfabet Estud AcesNet3m SeTrabDom Pensao SeRendFinanc numtotalfilho TempoEstudo EconAtiva desempregado D3 D4 D5 pesopes [fw=pesopes], by(cohorts)

** Gerando a inflacao acumulada de outubro a agosto de cada ano**
** A deflacao foi construindo em cima do ano base (inflacao corrente/inflacao base (2013))
gen Deflacionamento =.
replace Deflacionamento =1 if ano ==2013
replace Deflacionamento =0 if Deflacionamento ==.

save coortes_2013, replace
  
**Para analisar se a variavel dependente está balanceada ou não***
tab desocupado

**Verificando o balanceamento do modelo**
xtset cohorts ano










