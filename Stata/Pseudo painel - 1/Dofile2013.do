*******************
******PNAD 2013****
*******************

****Extração e preparação****
*************************************************************
* PREPARACAO DE DADOS PNAD 2013

*************************************************************

cd "C:\Users\Fran\Desktop\pseudo painel\PNAD2013"

set more off
set memory 512m

* LEITURA DAS INFORMACOES DO DESENHO DA AMOSTRA NO ARQUIVO DE DOMICILIOS

clear
#delimit;
infix ano 1-4 UF 5-6 controle 5-12 serie 13-15  tipo 16-17 
espdom 22-22 sitcen 100 probmun 112-123 probsetor 127-138 intervalo 139-144
strat 178-184 psu 185-191 using "C:\Users\Fran\Desktop\pseudo painel\PNAD2013\DOM2013.txt",clear;
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

* LEITURA DOS DADOS DAS PESSOAS 2013 (OBS EM ULTIMAUF CONFERIR)
clear
#delimit;
infix ano 1-4 UF 5-6 controle 5-12 serie 13-15 ordem 16-17 Sexo 18-18 nascdata 23-26 Idade 27-29 CondDom 30-30 CondF 31-31 Cor 33-33 maev 34-34
nasc 47-48 MoravaUF 56-56 UltimaUF 59-60 Rede 71-71
horastp 360-361 Ultfilho 652-655 Escol 669-670 Atividade 671-671 Ocupac 672-672 PosOcup 673-674 Setor 677-678 GrOcT 679-680
VRTP 691-702 vrtt 703-714 vrtf 715-726 vrud 727-738 vrfam 739-750 Casal 751-752 membrosf 753-754 RM 755-755 CodSC 756-756
pesopes 757-761 pesofam 762-766 crian5a17 769-769 membrosd 770-771 rendapercapita 772-783 using "C:\Users\Fran\Desktop\pseudo painel\PNAD2013\PES2013.txt",clear;
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
drop if strat == 350034  & psu == 238; 
#delimit cr

******************************
***********VARIAVEIS**********
******************************

*Exclui as observações com valores muito altos de renda
*Exclui as observações de quem  nasceu em outro país
*Exlui as observações de quem migrou, mas que mora a mais há 5 anos na UF na data de referencia e aqueles que há 5 anos nao tinham nascido
drop if VRTP > 30000
drop if nasc==98
drop if MoravaUF==1|MoravaUF==5
drop if VRTP==0

*Criando a variável mrenda que contém o valor médio da renda para cada estado de origem

*Renda media por UF
egen mrenda=mean(VRTP), by (UF)

*Gerar uma base que terá as UF de nasc e as médias da renda
preserve

rename mrenda renda_merge

keep UF renda_merge

rename UF nasc

save base_teste.dta, replace

clear

restore


*O comando merge pega a base que acabou de ser criada

replace nasc=UF if nasc==.

merge m:m nasc using "base_teste.dta"


*Com o comando bro da para ver essa base
bro UF nasc mrenda renda_merge

*Agora gero a renda do local de nascimento 
g teste = mrenda if nasc==.
egen renda_nasc = rowtotal(teste renda_merge)


*Casal com filhos
gen casalfilho=.
replace casalfilho=0 if Casal==1|Casal==6|Casal==7|Casal==8|Casal==10
replace casalfilho=1 if Casal==2 
replace casalfilho=1 if Casal==3
replace casalfilho=1 if Casal==4

*Condição familiar-Filho
gen filho=.
replace filho=0 if CondF==1|2|4|5|6|7|8
replace filho=1 if CondF==3 

*Possui filho antes de migrar, ou seja considerando a variavel de migração, utiliza-se filhos com mais de 5 anos
gen filho_17=.
gsort+serie+controle-Idade
by serie controle: replace filho_17=1 if filho==1 & Idade>=5 & Idade<=22 & casalfilho==1
by serie controle: egen filhos_5_17= max(filho_17)
recode filhos_5_17 .=0  
des controle
format controle %9.0f

bro (serie)(controle)(Idade)(filhos_5_17)   


****Pessoas com idade entre 23 a 60 anos**** (VER)
drop if Idade<23 | Idade>60
replace nascdata=2013-Idade if nascdata<=60


****NIVEL EDUCACIONAL****
gen AnosEst=Escol-1

drop if AnosEst==16

*De 5 a 8 anos de educação 
gen Fund=.
replace Fund=0 if AnosEst==1|2|3|4|5|6|7|9|10|11|12|13|14|15
replace Fund=1 if AnosEst==8 

*Médio 
gen Medio=.
replace Medio=0 if AnosEst==1|2|3|4|5|6|7|8|9|10|12|13|14|15 
replace Medio=1 if AnosEst==11 

*Superior
gen Superior=.
replace Superior=0 if AnosEst==1|2|3|4|5|6|7|8|9|10|11|12|13|14
replace Superior=1 if AnosEst==15 


**cor**
recode Cor (4=0) (2=1) (6=0) (8=0) (0=0) (9=0)
 
**sexo**
recode Sexo (2=1) (4=0)

*Area urbana ou rural
gen Urbano=.
replace Urbano=1 if CodSC<=3
replace Urbano=0 if CodSC>3

******LOCALIZAÇÃO DO DOMICÍLIO II
gen Metropole=.
replace Metropole=1 if RM==1
replace Metropole=0 if RM>=2

******REGIÕES BRASILEIRAS das regiões de destino
gen Sudeste=UF
gen Sul=UF
gen COeste=UF
gen Norte=UF
gen Nordeste=UF

replace Sudeste=0 if UF<=29
replace Sudeste=0 if UF>=41
replace Sudeste=1 if UF>=31 & UF<=35

replace Sul=0 if UF<=35
replace Sul=0 if UF>=50
replace Sul=1 if UF>=41 & UF<=43

replace COeste=0 if UF<=43
replace COeste=1 if UF>=50

replace Norte=0 if UF>=21
replace Norte=1 if UF<=17

replace Nordeste=0 if UF<=17
replace Nordeste=0 if UF>=31
replace Nordeste=1 if UF>=21 & UF<=29

*****VARIÁVEL DEPENDENTE****
****MIGRAÇÃO**** 
gen Migracao=.
replace Migracao=0 if MoravaUF==.  
replace Migracao=1 if MoravaUF==3 

save pes2013, replace

************************************************************************************
************************************************************************************
****************************CRIANDO VAR COHORTS*************************************
************************************************************************************
************************************************************************************
cd "C:\Users\Fran\Desktop\pseudo painel\PNAD2013"
use "C:\Users\Fran\Desktop\pseudo painel\PNAD2013\pes2013.dta", clear

gen nascimento=.
replace nascimento = 1 if nascdata >=1946 & nascdata <=1948
replace nascimento = 2 if nascdata >=1949 & nascdata <=1951
replace nascimento = 3 if nascdata >=1952 & nascdata <=1954
replace nascimento = 4 if nascdata >=1955 & nascdata <=1957
replace nascimento = 5 if nascdata >=1958 & nascdata <=1960
replace nascimento = 6 if nascdata >=1961 & nascdata <=1963
replace nascimento = 7 if nascdata >=1964 & nascdata <=1966
replace nascimento = 8 if nascdata >=1967 & nascdata <=1969
replace nascimento = 9 if nascdata >=1970 & nascdata <=1972
replace nascimento = 10 if nascdata >=1973 & nascdata <=1975
replace nascimento = 11 if nascdata >=1976 & nascdata <=1978
replace nascimento = 12 if nascdata >=1979 & nascdata <=1981
replace nascimento = 13 if nascdata >=1982 & nascdata <=1984
replace nascimento = 14 if nascdata >=1985 & nascdata <=1987
replace nascimento = 15 if nascdata >=1988 & nascdata <=1990



egen float cohorts = group(nascimento Sexo Cor Metropole)
egen float cohorts = group(nascimento Sexo Cor UF)

egen float cohorts = group(nascimento Sexo Cor)
egen float cohorts = group(nascimento Sexo Cor Sudeste Nordeste Sul Norte COeste)


sum cohorts
sum ano
order cohorts nascimento Sexo Cor Metropole
sort cohorts
tab cohorts

collapse (mean) ano Migracao Cor Sexo Fund Medio Superior filhos_5_17 Urbano Metropole renda_nasc Idade nascimento pesopes [fw=pesopes], by(cohorts)

save coortes2013, replace
save coortes2013reg, replace
save coortes_2013, replace

clear
