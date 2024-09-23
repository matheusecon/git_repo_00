
***PNAD 2005***
**************

****Extração e preparação****
*************************************************************
* PREPARACAO DE DADOS PNAD 2005
*************************************************************

cd "C:\Users\Fran\Desktop\pseudo painel\PNAD2005"

set more off
set memory 512m

* LEITURA DAS INFORMACOES DO DESENHO DA AMOSTRA NO ARQUIVO DE DOMICILIOS

clear
#delimit;
infix ano 1-4 UF 5-6 controle 5-12 serie 13-15  tipo 16-17 
espdom 22-22 sitcen 83 probmun 96-107 probsetor 111-122 intervalo 123-128
strat 161-167 psu 168-174 using "C:\Users\Fran\Desktop\pseudo painel\PNAD2005\DOM2005.txt",clear;
#delimit cr

************ORDENAR OS DADOS*************

#delimit;
sort controle serie, stable;
format controle %15.0g;
format serie %15.0g;
replace controle = float(controle);
replace serie = float(serie);
#delimit cr

save dom2005, replace

* LEITURA DOS DADOS DAS PESSOAS 2005 (OBS EM ULTIMAUF CONFERIR)
clear
#delimit;
infix ano 1-4 UF 5-6 controle 5-12 serie 13-15 ordem 16-17 Sexo 18-18 nascdata 23-26 Idade 27-29 CondDom 30-30 CondF 31-31 Cor 33-33 maev 34-34
nasc 41-42 MoravaUF 50-50 UltimaUF 53-54 Rede 64-64
horastp 359-360 Ultfilho 655-658 Escol 696-697 Atividade 698-698 Ocupac 699-699 PosOcup 700-701 Setor 704-705 GrOcT 706-707
VRTP 718-729 vrtt 730-741 vrtf 742-753 vrud 754-765 vrfam 766-777 Casal 778-779 membrosf 780-781 RM 796-796 CodSC 797-797
pesopes 798-802 pesofam 803-807 crian5a17 810-810 membrosd 813-814 rendapercapita 815-826 using "C:\Users\Fran\Desktop\pseudo painel\PNAD2005\PES2005.txt",clear;
#delimit cr 

*****JUNÇÃO DAS INFORMAÇÕES DE DESENHO DA AMOSTRA AO ARQUIVO DE PESSOAS DA PNAD 2004*********
**********Joinby
#delimit;
sort controle serie, stable;
joinby controle serie using dom2005;
#delimit cr

save pes2005, replace

* DECLARANDO/SETANDO O CONJUNTO DE DADOS COMO SENDO DE AMOSTRA COMPLEXA

clear
use pes2005, clear

svyset psu [pweight=pesopes], strata(strat) vce(linearized) || _n

svydes, single

save pes2005, replace

* ROTINA DE ALOCACAO DE ESTRATOS COM UM UNICO PSU EM ESTRATOS COM MAIOR NUMERO
* DE OBSERVACOES UTILIZANDO O DO.FILE idonepsu - ANO DE 2004

use pes2005, clear

*findit idonepsu (primeira vez que usar)

#delimit;
idonepsu, strata(strat) psu(psu) generate(new);
drop strat psu;
rename newstr strat;
rename newpsu psu;
#delimit cr

svyset psu [pweight=pesopes], strata(strat) vce(linearized) || _n

svydes, single

save pes2005, replace


*OBSERVAÇÕES QUE AINDA ESTÃO COM PSU ÚNICO MESMO APÓS UTILIZAÇÃO DO IDONEPSU
svydes, finalstage

#delimit;
drop if strat ==120002  & psu ==35;
drop if strat ==130002	 & psu ==99;
drop if strat ==140002	 & psu ==29;
drop if strat ==150008	 & psu ==230;
drop if strat ==150008	 & psu ==233;
drop if strat ==150009	 & psu ==251;
drop if strat ==150009	 & psu ==267;
drop if strat ==160003	 & psu ==39;
drop if strat ==170004	 & psu ==32;
drop if strat ==170006	 & psu ==44;
drop if strat ==170006	 & psu ==52;
drop if strat ==210003	 & psu ==30;
drop if strat ==210003	 & psu ==34;
drop if strat ==210003	 & psu ==35;
drop if strat ==220002	 & psu ==27;
drop if strat ==220002	 & psu ==28;
drop if strat ==220002	 & psu ==32;
drop if strat ==220002	 & psu ==38;
drop if strat ==220002	 & psu ==47;
drop if strat ==230018	 & psu ==304;
drop if strat ==230018	 & psu ==365;
drop if strat ==230018	 & psu ==388;
drop if strat ==230018	 & psu ==390;
drop if strat ==230018	 & psu ==391;
drop if strat ==230022	 & psu ==398;
drop if strat ==240006	 & psu ==62;
drop if strat ==250004	 & psu ==54;
drop if strat ==250010	 & psu ==81;
drop if strat ==250010	 & psu ==83;
drop if strat ==250010	 & psu ==93;
drop if strat ==250010	 & psu ==120;
drop if strat ==250010	 & psu ==149;
drop if strat ==250010	 & psu ==155;
drop if strat ==250010	 & psu ==203;
drop if strat ==250010	 & psu ==214;
drop if strat ==250010	 & psu ==222;
drop if strat ==250010	 & psu ==238;
drop if strat ==260019	 & psu ==343;
drop if strat ==260022	 & psu ==356;
drop if strat ==260022	 & psu ==373;
drop if strat ==260022	 & psu ==380;
drop if strat ==260022	 & psu ==386;
drop if strat ==260022	 & psu ==389;
drop if strat ==260022	 & psu ==391;
drop if strat ==260041	 & psu ==440;
drop if strat ==280004	 & psu ==44;
drop if strat ==280004	 & psu ==48;
drop if strat ==280004	 & psu ==49;
drop if strat ==280004	 & psu ==50;
drop if strat ==280004	 & psu ==51;
drop if strat ==280004	 & psu ==54;
drop if strat ==280004	 & psu ==59;
drop if strat ==280004	 & psu ==60;
drop if strat ==280004	 & psu ==65;
drop if strat ==280004	 & psu ==67;
drop if strat ==280004	 & psu ==68;
drop if strat ==280004	 & psu ==69;
drop if strat ==290027	 & psu ==419;
drop if strat ==290027	 & psu ==425;
drop if strat ==290027	 & psu ==427;
drop if strat ==290027	 & psu ==444;
drop if strat ==290027	 & psu ==452;
drop if strat ==290027	 & psu ==467;
drop if strat ==290027	 & psu ==470;
drop if strat ==310026	 & psu ==341;
drop if strat ==310026	 & psu ==349;
drop if strat ==310028	 & psu ==369;
drop if strat ==310028	 & psu ==373;
drop if strat ==310028	 & psu ==374;
drop if strat ==310040	 & psu ==404;
drop if strat ==320009	 & psu ==79;
drop if strat ==320009	 & psu ==81;
drop if strat ==320009	 & psu ==82;
drop if strat ==320009	 & psu ==83;
drop if strat ==320010	 & psu ==89;
drop if strat ==330046	 & psu ==604;
drop if strat ==330046	 & psu ==605;
drop if strat ==350056	 & psu ==675;
drop if strat ==350062	 & psu ==683;
drop if strat ==350062	 & psu ==688;
drop if strat ==350062	 & psu ==691;
drop if strat ==350072	 & psu ==720;
drop if strat ==350077	 & psu ==736;
drop if strat ==350078	 & psu ==746;
drop if strat ==350078	 & psu ==748;
drop if strat ==350083	 & psu ==766;
drop if strat ==350085	 & psu ==777;
drop if strat ==350085	 & psu ==784;
drop if strat ==350085	 & psu ==793;
drop if strat ==410021	 & psu ==230;
drop if strat ==410036	 & psu ==276;
drop if strat ==410059	 & psu ==317;
drop if strat ==420009	 & psu ==72;
drop if strat ==420010	 & psu ==74;
drop if strat ==430034	 & psu ==469;
drop if strat ==430036	 & psu ==474;
drop if strat ==430038	 & psu ==491;
drop if strat ==430041	 & psu ==495;
drop if strat ==430041	 & psu ==496;
drop if strat ==430047	 & psu ==510;
drop if strat ==430051	 & psu ==526;
drop if strat ==430051	 & psu ==531;
drop if strat ==430051	 & psu ==544;
drop if strat ==430051	 & psu ==547;
drop if strat ==430051	 & psu ==550;
drop if strat ==430051	 & psu ==554;
drop if strat ==430051	 & psu ==571;
drop if strat ==430051	 & psu ==579;
drop if strat ==430056	 & psu ==598;
drop if strat ==430062	 & psu ==613;
drop if strat ==500005	 & psu ==69;
drop if strat ==500005	 & psu ==90;
drop if strat ==500005	 & psu ==97;
drop if strat ==500007	 & psu ==104;
drop if strat ==510007	 & psu ==81;
drop if strat ==510007	 & psu ==82;
drop if strat ==510009	 & psu ==96;
drop if strat ==520017	 & psu ==196;
drop if strat ==520019	 & psu ==230;
drop if strat ==530002	 & psu ==207;
drop if strat ==530002	 & psu ==215;
drop if strat ==530002	 & psu ==238;
drop if strat ==530002	 & psu ==242;
drop if strat ==530002	 & psu ==245;
drop if strat ==530002	 & psu ==260;
drop if strat ==530002	 & psu ==265;
drop if strat ==530002	 & psu ==283;
drop if strat ==530002	 & psu ==290;
drop if strat ==530002	 & psu ==292;
drop if strat ==530002	 & psu ==328;
drop if strat ==530002	 & psu ==331;
drop if strat ==530002	 & psu ==342;
drop if strat ==530002	 & psu ==357;
drop if strat ==530002	 & psu ==359;
drop if strat ==530002	 & psu ==360;
drop if strat ==530002	 & psu ==364;
drop if strat ==530002	 & psu ==369;
drop if strat ==530002	 & psu ==370;
drop if strat ==530002	 & psu ==374;
drop if strat ==530002	 & psu ==376;
drop if strat ==530002	 & psu ==377;
drop if strat ==530002	 & psu ==384;
drop if strat ==530002	 & psu ==395;
#delimit cr

***Outras psus
#delimit;
drop if strat== 170004;
drop if strat==250003;         
drop if strat== 260041;         
drop if strat== 280006;         
drop if strat== 280010;         
drop if strat== 310057; 
drop if strat== 310086;         
drop if strat== 350072;         
drop if strat== 350083;         
drop if strat== 410059;         
drop if strat== 430041;        
drop if strat== 520019;  
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

****Pessoas com idade entre 23 a 60 anos****
drop if Idade<23 | Idade>60
replace nascdata=2005-Idade if nascdata<=60


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

save pes2005, replace
************************************************************************************
************************************************************************************
****************************CRIANDO VAR COHORTS*************************************
************************************************************************************
************************************************************************************
cd "C:\Users\Fran\Desktop\pseudo painel\PNAD2005"
use "C:\Users\Fran\Desktop\pseudo painel\PNAD2005\pes2005.dta", clear

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

save coortes2005, replace
save coortes2005reg, replace
save coortes_2005, replace
save coortes2005UF, replace

clear 
