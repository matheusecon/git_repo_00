*******************
******PNAD 2006****
*******************

****Extração e preparação****
*************************************************************
* PREPARACAO DE DADOS PNAD 2006
*************************************************************

cd "C:\Users\Fran\Desktop\pseudo painel\PNAD2006"

set more off
set memory 512m

* LEITURA DAS INFORMACOES DO DESENHO DA AMOSTRA NO ARQUIVO DE DOMICILIOS

clear
#delimit;
infix ano 1-4 UF 5-6 controle 5-12 serie 13-15  tipo 16-17 
espdom 22-22 sitcen 83 probmun 96-107 probsetor 111-122 intervalo 123-128
strat 161-167 psu 168-174 using "C:\Users\Fran\Desktop\pseudo painel\PNAD2006\DOM2006.txt",clear;
#delimit cr

************ORDENAR OS DADOS*************

#delimit;
sort controle serie, stable;
format controle %15.0g;
format serie %15.0g;
replace controle = float(controle);
replace serie = float(serie);
#delimit cr

save dom2006, replace

* LEITURA DOS DADOS DAS PESSOAS 2006 (OBS EM ULTIMAUF CONFERIR)
clear
#delimit;
infix ano 1-4 UF 5-6 controle 5-12 serie 13-15 ordem 16-17 Sexo 18-18 nascdata 23-26 Idade 27-29 CondDom 30-30 CondF 31-31 Cor 33-33 maev 34-34
nasc 41-42 MoravaUF 50-50 UltimaUF 53-54 Rede 64-64
horastp 376-377 Ultfilho 672-675 Escol 705-706 Atividade 707-707 Ocupac 708-708 PosOcup 709-710 Setor 713-714 GrOcT 715-716
VRTP 727-738 vrtt 739-750 vrtf 751-762 vrud 763-774 vrfam 775-786 Casal 787-788 membrosf 789-790 RM 805-805 CodSC 806-806
pesopes 807-811 pesofam 812-816 crian5a17 819-819 membrosd 822-823 rendapercapita 824-835 using "C:\Users\Fran\Desktop\pseudo painel\PNAD2006\PES2006.txt",clear;
#delimit cr 

*****JUNÇÃO DAS INFORMAÇÕES DE DESENHO DA AMOSTRA AO ARQUIVO DE PESSOAS DA PNAD 2006*********
**********Joinby
#delimit;
sort controle serie, stable;
joinby controle serie using dom2006;
#delimit cr

save pes2006, replace

* DECLARANDO/SETANDO O CONJUNTO DE DADOS COMO SENDO DE AMOSTRA COMPLEXA

clear
use pes2006, clear

svyset psu [pweight=pesopes], strata(strat) vce(linearized) || _n

svydes, single

save pes2006, replace

* ROTINA DE ALOCACAO DE ESTRATOS COM UM UNICO PSU EM ESTRATOS COM MAIOR NUMERO
* DE OBSERVACOES UTILIZANDO O DO.FILE idonepsu - ANO DE 2006

use pes2006, clear

*findit idonepsu (primeira vez que usar)

#delimit;
idonepsu, strata(strat) psu(psu) generate(new);
drop strat psu;
rename newstr strat;
rename newpsu psu;
#delimit cr

svyset psu [pweight=pesopes], strata(strat) vce(linearized) || _n

svydes, single

save pes2006, replace


*OBSERVAÇÕES QUE AINDA ESTÃO COM PSU ÚNICO MESMO APÓS UTILIZAÇÃO DO IDONEPSU
svydes, finalstage

#delimit;
drop if strat == 110008 & psu == 58;
drop if strat == 110008	& psu == 59;
drop if strat == 120006	& psu == 54;
drop if strat == 130002	& psu == 112;
drop if strat == 130002	& psu == 133;
drop if strat == 130002	& psu == 147;
drop if strat == 140002	& psu == 29;	
drop if strat == 150009	& psu == 251;
drop if strat == 150009	& psu == 279;
drop if strat == 150010	& psu == 287;
drop if strat == 150012	& psu == 295;
drop if strat == 160003	& psu == 28;	
drop if strat == 160003	& psu == 43;	
drop if strat == 170006	& psu == 51;	
drop if strat == 170006	& psu == 53;	
drop if strat == 210003	& psu == 29;	
drop if strat == 220002	& psu == 25;	
drop if strat == 220002	& psu == 29;	
drop if strat == 220002	& psu == 30;	
drop if strat == 220002	& psu == 35;	
drop if strat == 220002	& psu == 37;	
drop if strat == 220002	& psu == 49;	
drop if strat == 220002	& psu == 50;
drop if strat == 220002	& psu == 51;
drop if strat == 220002	& psu == 54;
drop if strat == 230018	& psu == 317;
drop if strat == 230018	& psu == 328;
drop if strat == 230018	& psu == 360;
drop if strat == 230018	& psu == 369;
drop if strat == 230018	& psu == 410;
drop if strat == 240004	& psu == 44;	
drop if strat == 240006	& psu == 62;
drop if strat == 260017	& psu == 337;	
drop if strat == 260021	& psu == 351;	
drop if strat == 260024	& psu == 364;	
drop if strat == 260024	& psu == 369;	
drop if strat == 260024	& psu == 382;	
drop if strat == 260024	& psu == 393;	
drop if strat == 260024	& psu == 399;	
drop if strat == 260024	& psu == 400;	
drop if strat == 260024	& psu == 404;	
drop if strat == 260024	& psu == 408;	
drop if strat == 260024	& psu == 409;
drop if strat == 260024	& psu == 419;
drop if strat == 260024	& psu == 422;
drop if strat == 270004	& psu == 49;	
drop if strat == 270004	& psu == 51;	
drop if strat == 270004	& psu == 53;	
drop if strat == 270004	& psu == 63;	
drop if strat == 280004	& psu == 57;
drop if strat == 280004	& psu == 60;	
drop if strat == 280004	& psu == 61;
drop if strat == 280004	& psu == 73;
drop if strat == 280006	& psu == 90;	
drop if strat == 280006	& psu == 91;
drop if strat == 290019	& psu == 379;
drop if strat == 290020	& psu == 383;
drop if strat == 290029	& psu == 411;
drop if strat == 290029	& psu == 433;
drop if strat == 290029	& psu == 447;
drop if strat == 290029	& psu == 454;
drop if strat == 290029	& psu == 457;
drop if strat == 290029	& psu == 466;
drop if strat == 290029	& psu == 470;
drop if strat == 290029	& psu == 487;
drop if strat == 290029	& psu == 498;
drop if strat == 310026	& psu == 352;
drop if strat == 310028	& psu == 379;
drop if strat == 310028	& psu == 380;
drop if strat == 310028	& psu == 383;
drop if strat == 310028	& psu == 385;
drop if strat == 310030	& psu == 391;
drop if strat == 310030	& psu == 392;
drop if strat == 310034	& psu == 404;
drop if strat == 310041	& psu == 419;
drop if strat == 310042	& psu == 423;
drop if strat == 310042	& psu == 424;
drop if strat == 320011	& psu == 82;
drop if strat == 320012	& psu == 89;
drop if strat == 320013	& psu == 103;
drop if strat == 330035	& psu == 574;
drop if strat == 330035	& psu == 577;
drop if strat == 330042	& psu == 604;
drop if strat == 330046	& psu == 620;
drop if strat == 330046	& psu == 639;
drop if strat == 330046	& psu == 640;
drop if strat == 330046	& psu == 646;
drop if strat == 330047	& psu == 657;
drop if strat == 350062	& psu == 696;
drop if strat == 350076	& psu == 741;
drop if strat == 350078	& psu == 761;
drop if strat == 350082	& psu == 780;
drop if strat == 350085	& psu == 794;
drop if strat == 350085	& psu == 796;
drop if strat == 350085	& psu == 802;
drop if strat == 350085	& psu == 807;
drop if strat == 350085	& psu == 824;
drop if strat == 350085	& psu == 834;
drop if strat == 350122	& psu == 919;
drop if strat == 410021	& psu == 233;
drop if strat == 420009	& psu == 72;
drop if strat == 420010	& psu == 75;
drop if strat == 420010	& psu == 78;	
drop if strat == 420011	& psu == 79;
drop if strat == 420012	& psu == 83;
drop if strat == 420012	& psu == 84;
drop if strat == 420029	& psu == 136;
drop if strat == 420029	& psu == 229;
drop if strat == 420029	& psu == 234;
drop if strat == 420029	& psu == 240;
drop if strat == 420029	& psu == 253;
drop if strat == 420029	& psu == 267;
drop if strat == 420029	& psu == 271;
drop if strat == 420029	& psu == 282;
drop if strat == 420029	& psu == 285;
drop if strat == 430034	& psu == 470;
drop if strat == 430038	& psu == 491;
drop if strat == 430038	& psu == 493;
drop if strat == 430044	& psu == 513;
drop if strat == 430047	& psu == 523;
drop if strat == 430049	& psu == 529;
drop if strat == 430049	& psu == 530;
drop if strat == 430051	& psu == 541;
drop if strat == 430051	& psu == 547;
drop if strat == 430051	& psu == 551;
drop if strat == 430051	& psu == 556;
drop if strat == 430051	& psu == 559;
drop if strat == 430051	& psu == 563;
drop if strat == 430051	& psu == 566;
drop if strat == 430051	& psu == 570;
drop if strat == 430051	& psu == 574;
drop if strat == 430051	& psu == 579;
drop if strat == 430051	& psu == 600;
drop if strat == 430058	& psu == 626;
drop if strat == 430058	& psu == 628;
drop if strat == 430062	& psu == 635;
drop if strat == 430062	& psu == 642;
drop if strat == 500005	& psu == 74;
drop if strat == 500005	& psu == 82;
drop if strat == 500005	& psu == 97;
drop if strat == 500005	& psu == 102;
drop if strat == 500016	& psu == 135;
drop if strat == 520017	& psu == 197;
drop if strat == 520017	& psu == 206;
drop if strat == 520017	& psu == 233;
drop if strat == 520017	& psu == 236;
drop if strat == 520018	& psu == 238;
drop if strat == 520022	& psu == 249;
drop if strat == 520023	& psu == 253;
drop if strat == 520025	& psu == 256;
drop if strat == 520037	& psu == 278;
drop if strat == 530002	& psu == 199;
drop if strat == 530002	& psu == 202;
drop if strat == 530002	& psu == 203;
drop if strat == 530002	& psu == 210;
drop if strat == 530002	& psu == 211;
drop if strat == 530002	& psu == 213;
drop if strat == 530002	& psu == 225;
drop if strat == 530002	& psu == 229;
drop if strat == 530002	& psu == 230;
drop if strat == 530002 & psu == 255;
drop if strat == 530002	& psu == 256;
drop if strat == 530002	& psu == 267;
drop if strat == 530002	& psu == 269;
drop if strat == 530002	& psu == 280;
drop if strat == 530002	& psu == 283;
drop if strat == 530002	& psu == 290;
drop if strat == 530002	& psu == 298;
drop if strat == 530002	& psu == 300;
drop if strat == 530002	& psu == 302;
drop if strat == 530002	& psu == 332;
drop if strat == 530002	& psu == 334;
drop if strat == 530002	& psu == 337;
drop if strat == 530002	& psu == 343;
drop if strat == 530002	& psu == 365;
drop if strat == 530002	& psu == 376;
drop if strat == 530002	& psu == 379;
drop if strat == 530002	& psu == 380;
drop if strat == 530002	& psu == 381;
drop if strat == 530002	& psu == 384;
drop if strat == 530002	& psu == 386;
drop if strat == 530002	& psu == 387;
drop if strat == 530002	& psu == 392;
drop if strat == 530002	& psu == 394;
drop if strat == 530002	& psu == 396;
drop if strat == 530002	& psu == 402;
drop if strat == 530002	& psu == 404;
drop if strat == 530002	& psu == 407;
drop if strat == 530002	& psu == 423;
#delimit cr

****Outros psus***
#delimit;
drop if strat==230022;       
drop if strat==230037;
drop if strat==290024;
drop if strat==350079;
drop if strat==350108;
drop if strat==350130;
drop if strat==420011;
drop if strat==430052;
drop if strat==430063;
drop if strat==500006;
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

drop if renda_nasc==0

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
replace nascdata=2006-Idade if nascdata<=60


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

save pes2006, replace

************************************************************************************
************************************************************************************
****************************CRIANDO VAR COHORTS*************************************
************************************************************************************
************************************************************************************
cd "C:\Users\Fran\Desktop\pseudo painel\PNAD2006"
use "C:\Users\Fran\Desktop\pseudo painel\PNAD2006\pes2006.dta", clear

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

save coortes2006, replace
save coortes2006reg, replace
save coortes_2006, replace
save coortes2006UF, replace
clear

clear
