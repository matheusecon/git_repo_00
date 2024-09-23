


cd "C:\Nova pasta\Curso Pós Graduação 2018\Dados\"

use exemplo.dta, clear

tostring Código, replace
ren Código CD_GEOCMU 

merge 1:1 CD_GEOCMU using "C:\Nova pasta\Curso Pós Graduação 2018\Dados\mun.dta"


drop if _merge == 1
spset


keep if sigla == "SP"

save sp, replace

spcompress

spset



spmatrix create contiguity Wc, replace normalize(row)
spmatrix summarize Wc

reg rendapercapita2000

estat moran, errorlag(Wc)


/*
Os modelos espaciais a serem estimados seriam esses:

Modelo SAR (com Wy no lado direito da regressão) por máxima verossimilhança e por MQ2E;
Modelo SEM (com Werro no lado direito) por MV e GMM;
Modelo SAC (com Wy e Werro no lado direito) por MV e MQ2E;
Modelo SDM (com Wy e WX) por MV e MQ2E;
Modelo SDEM (com WX e Werro) por MV e GMM.
*/


***** SAR

spregress rendapercapita2000 RendadesigualdadeíndiceLdeTheil2 ///
	pobrezapessoaspobresp02000 ifdmempregorenda2000 IFDMeducação2000 IFDMsaúde2000, gs2sls dvarlag(Wc)

estat impact

spregress rendapercapita2000 RendadesigualdadeíndiceLdeTheil2 ///
	pobrezapessoaspobresp02000 ifdmempregorenda2000 IFDMeducação2000 IFDMsaúde2000, ml dvarlag(Wc)


***** SEM
spregress rendapercapita2000 RendadesigualdadeíndiceLdeTheil2 ///
	pobrezapessoaspobresp02000 ifdmempregorenda2000 IFDMeducação2000 IFDMsaúde2000, gs2sls errorlag(Wc)

spregress rendapercapita2000 RendadesigualdadeíndiceLdeTheil2 ///
	pobrezapessoaspobresp02000 ifdmempregorenda2000 IFDMeducação2000 IFDMsaúde2000, ml errorlag(Wc)

***** SAC 

spregress rendapercapita2000 RendadesigualdadeíndiceLdeTheil2 ///
	pobrezapessoaspobresp02000 ifdmempregorenda2000 IFDMeducação2000 IFDMsaúde2000, gs2sls dvarlag(Wc) errorlag(Wc)

spregress rendapercapita2000 RendadesigualdadeíndiceLdeTheil2 ///
	pobrezapessoaspobresp02000 ifdmempregorenda2000 IFDMeducação2000 IFDMsaúde2000, ml dvarlag(Wc) errorlag(Wc)
	
	
***** SDM

spregress rendapercapita2000 RendadesigualdadeíndiceLdeTheil2 ///
	pobrezapessoaspobresp02000 ifdmempregorenda2000 IFDMeducação2000 IFDMsaúde2000, gs2sls dvarlag(Wc) ivarlag(Wc: ifdmempregorenda2000)

	
spregress rendapercapita2000 RendadesigualdadeíndiceLdeTheil2 ///
	pobrezapessoaspobresp02000 ifdmempregorenda2000 IFDMeducação2000 IFDMsaúde2000, ml dvarlag(Wc) ivarlag(Wc: ifdmempregorenda2000)
	
***** SDEM
spregress rendapercapita2000 RendadesigualdadeíndiceLdeTheil2 ///
	pobrezapessoaspobresp02000 ifdmempregorenda2000 IFDMeducação2000 IFDMsaúde2000, gs2sls errorlag(Wc) ivarlag(Wc: ifdmempregorenda2000)
	
	
spregress rendapercapita2000 RendadesigualdadeíndiceLdeTheil2 ///
	pobrezapessoaspobresp02000 ifdmempregorenda2000 IFDMeducação2000 IFDMsaúde2000, ml errorlag(Wc) ivarlag(Wc: ifdmempregorenda2000)
	
	
	
*******************************************************************************************************

spregress rendapercapita2000 RendadesigualdadeíndiceLdeTheil2 ///
	pobrezapessoaspobresp02000 ifdmempregorenda2000 IFDMeducação2000 IFDMsaúde2000, ml dvarlag(Wc)

 estimates store A

 spregress rendapercapita2000 RendadesigualdadeíndiceLdeTheil2 ///
	pobrezapessoaspobresp02000 ifdmempregorenda2000 IFDMeducação2000 IFDMsaúde2000, ml errorlag(Wc) ivarlag(Wc: ifdmempregorenda2000)

estimates store B

lrtest A B 
