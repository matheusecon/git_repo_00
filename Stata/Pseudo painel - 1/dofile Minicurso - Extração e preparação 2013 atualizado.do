*************************************************************
* PREPARACAO DE DADOS PNAD 2013
*************************************************************

cd "C:\Users\Fransuellen\Desktop\Professor Jader\PNAD 2013"

set more off
set memory 512m
 
* LEITURA DAS INFORMACOES DO DESENHO DA AMOSTRA NO ARQUIVO DE DOMICILIOS

clear
#delimit;
infix ano 1-4 UF 5-6 controle 5-12 serie 13-15  tipo 16-17 
espdom 22-22 sitcen 100 probmun 112-123 probsetor 127-138 intervalo 139-144
strat 178-184 psu 185-191 using "C:\Users\Fransuellen\Desktop\Professor Jader\PNAD 2013\DOM2013.txt",clear;
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
infix ano 1-4 UF 5-6 controle 5-12 serie 13-15 ordem 16-17  
Sexo 18-18 Idade 27-29 CondDom 30-30 CondF 31-31 Cor 33-33 horastp 360-361 ContPrev 362-362
PosOcupSec 419-419 HorasTS 454-455  OT1 456-456 OT2 469-469 OT3 482-482 Proc 507-507 Escol 669-670 Atividade 671-671 Ocupac 672-672 PosOcup 673-674
Setor 677-678 GrOcT 679-680 VRTP 691-702 vrtt 703-714 vrtf 715-726
vrud 727-738 vrfam 739-750 Filhopeq 751-752 membrosf 753-754 RM 755-755
CodSC 756-756 pesopes 757-761 pesofam 762-766 crian5a17 769-769 membrosd 770-771
rendompercapita 772-783 renfampercapita 791-802 using "C:\Users\Fransuellen\Desktop\Professor Jader\PNAD 2013\PES2013.txt",clear;
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
* Instalar o idonepsu (primeira vez que usar)
findit idonepsu

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
drop if VRTP > 5000000 & VRTP!=.
svy: regress VRTP Idade
estat effects, meff // para analisar o efeito do plano amostral!

* Para comparação

regress VRTP Idade

* Efeitos marginais com MFX 
mfx compute, dydx at(mean)

* Elasticidades com MFX
mfx compute, eyex at(mean)





  











