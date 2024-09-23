use "C:\Users\Fran\Desktop\pseudo painel\PNAD2005\coortes2005reg.dta", clear 
append using  "C:\Users\Fran\Desktop\pseudo painel\PNAD2006\coortes2006reg.dta" 
append using  "C:\Users\Fran\Desktop\pseudo painel\PNAD2013\coortes2013reg.dta" 
append using  "C:\Users\Fran\Desktop\pseudo painel\PNAD2014\coortes2014reg.dta" 

save  "C:\Users\Fran\Desktop\pseudo painel\\paineltesteestadosreg.dta", replace 

************************************************************************************
*****************************RODANDO PANEL DATA**************************************
*************************************************************************************

******************************
**PAINEL**
******************************
drop if cohorts ==.
xtset cohort ano

** recodificando a variávei dependente **



**criando dummies de ano
gen D1 =.
replace D1 =1 if ano ==2005
replace D1 =0 if D1 ==.

gen D2=.
replace D2 =1 if ano ==2006
replace D2 =0 if D2 ==.


gen D3 =.
replace D3 =1 if ano ==2013
replace D3 =0 if D3 ==.

gen D4 =.
replace D4 =1 if ano ==2014
replace D4 =0 if D4 ==.

** panel logit***

xtlogit Migracao Cor Sexo Fund Medio Superior filhos_5_17 Urbano Metropole renda_nasc Idade, fe

xtlogit Migracao Cor Sexo Fund Medio Superior filhos_5_17 Urbano Metropole renda_nasc Idade D1 D2 D3 D4, re

xtlogit Migracao Cor Sexo Fund Medio Superior filhos_5_17 Urbano Metropole renda_nasc Idade D1 D2 D3, pa corr (independent) vce(rob)
