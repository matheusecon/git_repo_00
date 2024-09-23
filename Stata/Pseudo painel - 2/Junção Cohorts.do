use "C:\Users\Rafael Curi\Dropbox\Economia\Mestrado_UFV_2017\PNAD\PNAD_2013\Dados\pes2013.dta", clear 
append using  "C:\Users\Rafael Curi\Dropbox\Economia\Mestrado_UFV_2017\PNAD\PNAD_2014\Dados\pes2014.dta" 
append using  "C:\Users\Rafael Curi\Dropbox\Economia\Mestrado_UFV_2017\PNAD\PNAD 2015\Dados\pes2015.dta" 




save  "C:\Users\Rafael Curi\Dropbox\Economia\Mestrado_UFV_2017\PNAD\paineltesteSalárioMínimo.dta", replace 



*************************************************************************************
*****************************RODANDO PANEL DATA**************************************
*************************************************************************************

******************************
**PAINEL**
******************************
xtset cohort ano

** recodificando a variávei dependente **


**somente estuda ***
replace estuda =1 if estuda >=0.5
replace estuda =0 if estuda <0.5
drop if cohort ==.

**recodificando nascimento***
recode nascimento (4=2) (7=3)
gen idade17_19=.
replace idade17_19 =1 if nascimento ==3
replace idade17_19 =0 if idade17_19 ==.

gen idade20_22 =.
replace idade20_22 =1 if nascimento ==2
replace idade20_22 =0 if idade20_22 ==.

gen idade23_25 =.
replace idade23_25 =1 if nascimento ==1
replace idade23_25 =0 if idade23_25 ==.

**criando dummies de ano
gen D1 =.
replace D1 =1 if ano ==98
replace D1 =0 if D1 ==.

gen D2=.
replace D2 =1 if ano ==99
replace D2 =0 if D2 ==.


gen D3 =.
replace D3 =1 if ano ==2001
replace D3 =0 if D3 ==.

gen D4 =.
replace D4 =1 if ano ==2002
replace D4 =0 if D4 ==.

gen D5 =.
replace D5 =1 if ano ==2003
replace D5 =0 if D5 ==.

gen D6 =.
replace D6 =1 if ano ==2004
replace D6 =0 if D6 ==.

gen D7 =.
replace D7 =1 if ano ==2005
replace D7 =0 if D7 ==.

gen D8 =.
replace D8 =1 if ano ==2006
replace D8 =0 if D8 ==.

gen D9 =.
replace D9 =1 if ano ==2007
replace D9 =0 if D9 ==.

gen D10 =.
replace D10 =1 if ano ==2008
replace D10 =0 if D10 ==.

gen D11 =.
replace D11 =1 if ano ==2009
replace D11 =0 if D11 ==.

gen D12 =.
replace D12 =1 if ano ==2011
replace D12 =0 if D12 ==.

gen D13 =.
replace D13 =1 if ano ==2012
replace D13 =0 if D13 ==.

gen D14 =.
replace D14 =1 if ano ==2013
replace D14 =0 if D14 ==.



*** panel logit***

xtlogit estuda Cor Sexo vrfam maeres desemprego sexochefe membrosf escol_ref bh bras sp porto reci idade17_19  idade23_25, fe

xtlogit estuda Cor Sexo lnrendapercapta maeres membrosf desemprego sexochefe escol_ref bh bras sp porto reci D1 D2 D3 D4 D5 D6 D7 D8 D9 D10 D11 D12 D13, re

xtlogit estuda Cor Sexo rendapercapta maeres desemprego sexochefe escol_ref bh bras sp porto reci idade17_19 idade20_22 idade23_25, pa corr (independent) vce(rob)
