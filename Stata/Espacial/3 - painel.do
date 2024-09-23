cd "C:\Nova pasta\Curso Pós Graduação 2018\Dados\"

use painel.dta, clear


reshape long renda_ educ_, i(Código) j(ano)

ren renda_ renda
ren educ_ educ

tostring Código, replace
ren Código CD_GEOCMI 

merge m:1 CD_GEOCMI using "C:\Nova pasta\Curso Pós Graduação 2018\Dados\micro.dta"

drop _merge


spmatrix create contiguity Wc, replace normalize(row)


spmatrix create contiguity Wc if ano == 2000, replace normalize(row)

destring CD_GEOCMI, replace

xtset CD_GEOCMI ano

spset

***********  Efeitos aleatórios
xtreg renda educ i.ano, re


***** SAR

spxtregress renda educ i.ano, re dvarlag(Wc) 



***** SEM
spxtregress renda educ i.ano, re errorlag(Wc)

***** SAC 

spxtregress renda educ i.ano, re dvarlag(Wc) errorlag(Wc)

	
	
***** SDM

spxtregress renda educ i.ano, re dvarlag(Wc) ivarlag(Wc: educ)

	
***** SDEM
spxtregress renda educ i.ano, re errorlag(Wc) ivarlag(Wc: educ)
	
estat impact educ
	
	
*spxtregress renda educ i.ano, re sarpanel errorlag(Wc) ivarlag(Wc: educ)
*spxtregress renda c.educ##i.ano, re errorlag(Wc) ivarlag(Wc: educ)
*estat impact educ if ano == 1991
*estat impact educ if ano == 2000
 
  
  
***********  Efeitos fixos
xtreg renda educ i.ano, fe


***** SAR

spxtregress renda educ i.ano, fe dvarlag(Wc) 



***** SEM
spxtregress renda educ i.ano, fe errorlag(Wc)

***** SAC 

spxtregress renda educ i.ano, fe dvarlag(Wc) errorlag(Wc)

	
	
***** SDM

spxtregress renda educ i.ano, fe dvarlag(Wc) ivarlag(Wc: educ)

	
***** SDEM
spxtregress renda educ i.ano, fe errorlag(Wc) ivarlag(Wc: educ)
	
	
estat impact educ
  
  
  
  

	
	
	
	
	
	
