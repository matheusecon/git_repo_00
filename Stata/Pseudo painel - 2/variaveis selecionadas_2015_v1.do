*************************************************************
* PREPARACAO DE DADOS PNAD 2015
*************************************************************

cd "C:\Users\Rafael Curi\Dropbox\Economia\Mestrado_UFV_2017\PNAD\PNAD 2015\Dados"

set more off
set memory 512m
 
* LEITURA DAS INFORMACOES DO DESENHO DA AMOSTRA NO ARQUIVO DE DOMICILIOS
*ESSAS LINHAS PERMANECEM FIXAS
clear
#delimit;
infix ano 1-4 UF 5-6 controle 5-12 serie 13-15  tipo 16-17   
strat 178-184 psu 185-191 
using "C:\Users\Rafael Curi\Dropbox\Economia\Mestrado_UFV_2017\PNAD\PNAD 2015\Dados\DOM2015.txt",clear;
#delimit cr


************ORDENAR OS DADOS*************

#delimit;
sort controle serie, stable;
format controle %15.0g;
format serie %15.0g;
replace controle = float(controle);
replace serie = float(serie);
#delimit cr

save dom2015, replace

**comando sort organiza as observaçoes dos dados atuais em ordem ascendente baseado nos valores das variaveis em varlist
*** neste caso controle e serie sao as variaveis usadas como referencia

* LEITURA DOS DADOS DAS PESSOAS 2015

clear
#delimit;
infix ano 1-4 UF 5-6 controle 5-12 serie 13-15 
ordem 16-17 Sexo 18-18 DiaNasc 19-20 MesNasc 21-22 AnoNasc 23-26 Idade 27-29
SePessRef 30-30 CondFam 31-31 Cor 33-33 MoracMae 35-35 EstCiv 41-41 
LugNasc 45-46 TempMoraUF 49-49 TempMoraMun 61-61 
Alfabet 67-67 Estud 68-68 
AcesNet3m 84-84
SeTrabDom 148-148
Pensao 552-552 
SeRendFinanc 651-652
NFilhosM 667-668 NFilhosF 669-670 
TempoEstudo 703-704
EconAtiva 705-705
Desempreg 706-706
RendMensDom 749-760
pesopes 791-795 pesofam 796-800

using "C:\Users\Rafael Curi\Dropbox\Economia\Mestrado_UFV_2017\PNAD\PNAD 2015\Dados\PES2015.txt",clear;
#delimit cr 


*****JUNÇÃO DAS INFORMAÇÕES DE DESENHO DA AMOSTRA AO ARQUIVO DE PESSOAS DA PNAD 2015*********
**********Joinby
#delimit;
sort controle serie, stable;
joinby controle serie using dom2015;
#delimit cr

save pes2015, replace

* DECLARANDO/SETANDO O CONJUNTO DE DADOS COMO SENDO DE AMOSTRA COMPLEXA

clear
use pes2015, clear

svyset psu [pweight=pesopes], strata(strat) vce(linearized) || _n

svydes, single

save pes2015, replace


* ROTINA DE ALOCACAO DE ESTRATOS COM UM UNICO PSU EM ESTRATOS COM MAIOR NUMERO
* DE OBSERVACOES UTILIZANDO O DO.FILE idonepsu - ANO DE 2015

use pes2015, clear

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

save pes2015, replace


*OBSERVAÇÕES QUE AINDA ESTÃO COM PSU ÚNICO MESMO APÓS UTILIZAÇÃO DO IDONEPSU
svydes, finalstage

*tem-se que eliminar obs=1, sendo unit = PSU

#delimit;
drop if strat == 230006  & psu == 170;
drop if strat == 350009  & psu == 68
#delimit cr

*convém rodar idonepsu de novo para checar se ao apagar um estrato surgiram outros de psu único.



*ANÁLISE DE REGRESSÃO
drop if VRTP > 5000000 & VRTP!=.
svy: regress VRTP Idade
estat effects, meff // para analisar o efeito do plano amostral!

* Para comparação

regress VRTP Idade

* Efeitos marginais com MFX 
mfx compute, dydx at(mean)

* Elasticidades com MFX
mfx compute, eyex at(mean)





  











