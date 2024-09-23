


use "https://igorprocopio.github.io/Datasets/lakisha_aer.dta", clear



***********************      Tabela 1      *************************************

ttest call, by(race)
di r(mu_2)/r(mu_1)

******  Mostrar que o resultado do teste de médias é igual ao coeficiente da
** regressão
tab race, g(drace)
reg call drace1
********************

ttest call if city == "c", by(race)
di r(mu_2)/r(mu_1)

reg call drace1 if city == "c" // mesmo resultado usando regressão

ttest call if city == "b", by(race)
di r(mu_2)/r(mu_1)

reg call drace1 if city == "b"  // mesmo resultado usando regressão

ttest call if sex == "f", by(race)
di r(mu_2)/r(mu_1)

reg call drace1 if sex == "f"  // mesmo resultado usando regressão


ttest call if sex == "m", by(race)
di r(mu_2)/r(mu_1)

reg call drace1 if sex == "m"  // mesmo resultado usando regressão



***********************      Tabela 2      *************************************

gen w = race == "w" & call == 1
gen b = race == "b" & call == 1

*preserve
collapse (sum) w b, by(adid)

**** Equal treatment
gen equal = (b==0 & w == 0) | (b==1 & w == 1) | (b==2 & w == 2)
gen equalno = (b==0 & w == 0)
gen equalwb = (b==1 & w == 1)
gen equalwwbb = (b==2 & w == 2)

tabstat equal equalno equalwb equalwwbb, statistics( mean sum )


**** Whites favored (WF)
gen wf= (w==1 & b == 0) | (w==2 & b ==0) | (w==2 & b == 1)
gen wf_w= (w==1 & b == 0) 
gen wf_ww= (w==2 & b ==0) 
gen wf_wwb=  (w==2 & b == 1)

tabstat wf wf_w wf_ww wf_wwb, statistics( mean sum )



**** African-Americans favored (BF)
gen bf = (w==0 & b == 1) | (w==0 & b ==2) | (w==1 & b == 2)
gen bf_b = (w==0 & b == 1)
gen bf_bb = (w==0 & b ==2)
gen bf_bbw= (w==1 & b == 2)

tabstat bf bf_b bf_bb bf_bbw, statistics( mean sum )


**** Teste de hipótese para verificar se a proporção WF = BF
prtest wf = bf














***********************      Tabela 3      *************************************

*** Coluna 1
tabstat col yearsexp volunteer military email empholes workinschool ///
	honors computerskills specialskills fracdropout fraccolp fracwhite fracblack linc, ///
	statistics( mean sd ) varwidth(30) columns(statistics) longstub format(%9.2f)


*** Coluna 2 e 3 
by race, sort : tabstat col yearsexp volunteer military email empholes workinschool ///
	honors computerskills specialskills fracdropout fraccolp fracwhite fracblack linc, ///
	statistics( mean sd ) varwidth(30) columns(statistics) longstub format(%9.2f)

	
*** Coluna 4 e 5
by h, sort : tabstat col yearsexp volunteer military email empholes workinschool ///
	honors computerskills specialskills fracdropout fraccolp fracwhite fracblack linc, ///
	statistics( mean sd ) varwidth(30) columns(statistics) longstub format(%9.2f)
	
	
	
***********************      Tabela 4      *************************************

*** Panel A

ttest call if race == "w", by(h)
di r(mu_2)/r(mu_1)

ttest call if race == "b", by(h)
di r(mu_2)/r(mu_1)

*** Panel B
tab sex, g(dsex)
tab city, g(dcity)

cap drop sample third panelb high

gen sample = runiform()
xtile third = sample, nq(3)

probit call col yearsexp volunteer military email empholes workinschool ///
	honors computerskills specialskills fracdropout fraccolp fracwhite fracblack linc dsex1 ///
	dcity1 manager supervisor secretary ///
	offsupport salesrep retailsales req expreq comreq educreq compreq orgreq if third == 1

predict panelb if third != 1
	
xtile high = panelb, nq(2)

ttest call if race == "w", by(high)
di r(mu_2)/r(mu_1)

ttest call if race == "b", by(high)
di r(mu_2)/r(mu_1)


***********************      Tabela 5      *************************************

** Para estimar o modelo econométrico é preciso construir algumas variáveis antes:

gen yearsexp_sq = yearsexp^2
gen boston = city == "b"

codebook yearsexp
gen yearsexp_more10 = yearsexp >= 10

** Coluna 1 - All resumes

probit call yearsexp yearsexp_sq volunteer military email empholes workinschool ///
	honors computerskills specialskills boston manager supervisor secretary ///
	offsupport salesrep retailsales req expreq comreq educreq compreq orgreq, ///
	vce(cluster adid)
mfx compute	
*outreg2 using "Resultados\table5", mfx ctitle("All resumes")  excel sd(2) bd(4) replace

test  yearsexp = yearsexp_sq = volunteer = military = email = empholes = workinschool ///
	= honors = computerskills = specialskills =0 
	
predict y_hat
sum y_hat


** Coluna 2 - White names

probit call yearsexp yearsexp_sq volunteer military email empholes workinschool ///
	honors computerskills specialskills boston manager supervisor secretary ///
	offsupport salesrep retailsales req expreq comreq educreq compreq orgreq if race == "w", ///
	vce(cluster adid)
mfx compute	
*outreg2 using "Resultados\table5", mfx ctitle("White names")excel sd(2) bd(4) 

predict y_hat_w
sum y_hat_w


** Coluna 3 - African-American names

probit call yearsexp yearsexp_sq volunteer military email empholes workinschool ///
	honors computerskills specialskills boston manager supervisor secretary ///
	offsupport salesrep retailsales req expreq comreq educreq compreq orgreq if race == "b", ///
	vce(cluster adid)
mfx compute	
*outreg2 using "Resultados\table5", mfx ctitle("African-American names") excel sd(2) bd(4) 

predict y_hat_b
sum y_hat_b



***********************      Tabela 6      *************************************

*** É preciso criar uma variável dummy para raça e uma para cidade

ren drace1 black
ren drace2 white

*tab city, g(dcity)

*** Criar variável de interação entre as dummies recém criadas
egen grupo = group(city race)
tab grupo, g(dgr)

*** Criar variável de interação entre a característica analisada a dummy de raça
gen inter1= fracwhite*black


**********  Colunas 1 e 2 - Fraction whites

dprobit call fracwhite dcity1 , 	vce(cluster adid)

dprobit call fracwhite inter1 black dcity1 dgr2-dgr4, vce(cluster adid)


**********  Colunas 3 e 4 - Fraction college or more

gen inter2= fraccolp*black

dprobit call fraccolp  dcity1, vce(cluster adid)

dprobit call fraccolp inter2 black dcity1 dgr2-dgr4, vce(cluster adid)


**********  Colunas 5 e 6 - Log (per capital income)

gen inter3= linc*black

dprobit call linc  dcity1, vce(cluster adid)

dprobit call linc inter3 black dcity1 dgr2-dgr4, vce(cluster adid)



***********************      Tabela 7      *************************************

*** Panel Job requirement

egen total = rowtotal(expreq compreq comreq orgreq educreq)

*** Coluna 1 - Sample mean and standard deviation
sum req expreq compreq comreq orgreq educreq total


*** Coluna 2 - 

** Any requirement
cap drop inter
gen inter = black*req
probit call black req inter, 	vce(cluster adid)
mfx compute

** Experience
cap drop inter
gen inter = black*expreq
probit call black expreq inter, 	vce(cluster adid)
mfx compute

** Computer skills
cap drop inter
gen inter = black*compreq
probit call black compreq inter, 	vce(cluster adid)
mfx compute

** Comunication skills
cap drop inter
gen inter = black*comreq
probit call black comreq inter, 	vce(cluster adid)
mfx compute

** Organization skills
cap drop inter
gen inter = black*orgreq
probit call black orgreq inter, 	vce(cluster adid)
mfx compute

** Education
cap drop inter
gen inter = black*educreq
probit call black educreq inter, 	vce(cluster adid)
mfx compute

** Total number of requirements
cap drop inter
gen inter = black*total
probit call black total inter, 	vce(cluster adid)
mfx compute



*** Panel Employer characteristic

*** Coluna 1 - Sample mean and standard deviation

sum eoe fed

gen log = ln(parent_emp)
sum log

tab ownership
sum fracblack_empzip



*** Coluna 2 - 

** Equal opportunity employer
cap drop inter
gen inter = black*eoe
probit call black eoe inter, 	vce(cluster adid)
mfx compute

** Federal contractor
cap drop inter
gen inter = black*fed
probit call black fed inter, 	vce(cluster adid)
mfx compute

** Log(employment)
cap drop inter
gen inter = black*log
probit call black log inter, 	vce(cluster adid)
mfx compute

** Ownership status

tab ownership, g(downer)
ren downer1 nonprofit
ren downer2 private
ren downer3 public

* Privately held
cap drop inter
gen inter = black*private
probit call black private inter, 	vce(cluster adid)
mfx compute

* Publicly traded
cap drop inter
gen inter = black*public
probit call black public inter, 	vce(cluster adid)
mfx compute

* Not-for-profit
cap drop inter
gen inter = black*nonprofit
probit call black nonprofit inter, 	vce(cluster adid)
mfx compute


* Fraction African-Americans in employer's zip code
cap drop inter
gen inter = black*fracblack_empzip
probit call black fracblack_empzip inter, 	vce(cluster adid)
mfx compute




