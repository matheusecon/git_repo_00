
*** IMPORTAR DADOS DE PESSOAS ***

#delimit;
infix ano 1-4 uf 5-6 areacensitaria 789-789 controle 5-12 serie 13-15 sexo 18-18 idade 27-29 condicaofamilia 31-31 cor 33-33 estadocivil 41-41 setor 305-305 tempo_servico 364-365 ocupacao 707-708
sindicalizado 405-405 anosestudo 703-704 rendimento 725-736 horastrab 709-709 satisfacao_cond_prometidas 853-853 satisfsalario 862-862 satisfjornadatrab 864-864 satisfseguranca 868-868
peso 791-795
using "C:\Users\Isabella\Desktop\ARTIGOS 1º SEMESTRE - MESTRADO\ARTIGO ECONOMETRIA - GRAU DE SATISFAÇÃO\Pnad\Dados\PES2015.txt";
#delimit cr


sort controle serie 
  
save "C:\Users\Isabella\Desktop\ARTIGOS 1º SEMESTRE - MESTRADO\ARTIGO ECONOMETRIA - GRAU DE SATISFAÇÃO\Pnad\artigo_PES2015.dta"

clear
   
set more off

*** IMPORTAR DADOS DE DOMICÍLIOS ***

#delimit;
infix uf 5-6 controle 5-12 serie 13-15 pesofam 157-161 renddompercapita 194-205 strat 178-184 psu 185-191
using "C:\Users\Isabella\Desktop\ARTIGOS 1º SEMESTRE - MESTRADO\ARTIGO ECONOMETRIA - GRAU DE SATISFAÇÃO\Pnad\Dados\DOM2015.txt";
#delimit cr

sort controle serie
  
save "C:\Users\Isabella\Desktop\ARTIGOS 1º SEMESTRE - MESTRADO\ARTIGO ECONOMETRIA - GRAU DE SATISFAÇÃO\Pnad\artigo_DOM2015.dta"

clear

*** AGORA FAREMOS UMA JUNÇÃO DOS ARQUIVOS DE PESSOAS E DOMICÍLIOS ***
 
use "C:\Users\Isabella\Desktop\ARTIGOS 1º SEMESTRE - MESTRADO\ARTIGO ECONOMETRIA - GRAU DE SATISFAÇÃO\Pnad\artigo_PES2015.dta", clear
#delimit;
merge m:m controle serie using "C:\Users\Isabella\Desktop\ARTIGOS 1º SEMESTRE - MESTRADO\ARTIGO ECONOMETRIA - GRAU DE SATISFAÇÃO\Pnad\artigo_DOM2015.dta";
#delimit cr

*** VAMOS ELIMINAR AS OBSERVAÇÕES QUE NÃO COINCIDEM NOS DOIS ARQUIVOS ***

keep if _merge==3
drop _merge

*** RECONHECENDO A AMOSTRA COMO COMPLEXA ***

svyset psu [pweight=peso], strata(strat) vce(linearized) || _n
svydes, single

*** UTILIZANDO O COMANDO IDONEPSU ***

#delimit;
idonepsu, strata(strat) psu(psu) generate(new);
drop strat psu;
rename newstr strat;
rename newpsu psu;
#delimit cr

svyset psu [pweight=peso], strata(strat) vce(linearized) || _n
svydes, single

*** OBSERVAÇÕES QUE AINDA ESTÃO COM PSU ÚNICO MESMO APÓS A UTILIZAÇÃO DO IDONEPSU ***

svydes, finalstage


*** ESPECIFICANDO O LOCAL QUE O ARQUIVO SERÁ SALVO ***

cd "C:\Users\Isabella\Desktop\ARTIGOS 1º SEMESTRE - MESTRADO\ARTIGO ECONOMETRIA - GRAU DE SATISFAÇÃO\Pnad"


*** TEMOS QUE ELIMINAR OBS=1, SENDO UNIT = PSU ***

#delimit;
drop if strat == 230006 & psu == 170;
drop if strat == 350009 & psu == 68
#delimit cr


save

*** VAMOS DROPAR OS MISSINGS ***

drop if satisfacao_cond_prometidas==.
drop if rendimento>80000

*** VAMOS DROPAR OS INDIVÍDUOS COM IDADE MENOR QUE 16 ***

drop if idade<16

*** CRIANDO AS VARIÁVEIS DUMMIES ***
gen Branco=.
replace Branco=1 if cor==2
replace Branco=0 if (cor==4 | cor==6 | cor==8 | cor==0 | cor==9)

gen Masculino=.
replace Masculino=1 if sexo==2
replace Masculino=0 if sexo==4

gen Casado=.
replace Casado=1 if estadocivil==1
replace Casado=0 if (estadocivil==3 | estadocivil==5 | estadocivil==7 | estadocivil==0)

gen Sindicato=.
replace Sindicato=1 if sindicalizado==1
replace Sindicato=0 if sindicalizado==3

*gen Seguranca=.
*replace Seguranca=1 if (satisfseguranca==4 | satisfseguranca==5)
*replace Seguranca=0 if (satisfseguranca==1 | satisfseguranca==2 | satisfseguranca==3)

*gen Jornada=.
*replace Jornada=1 if (satisfjornadatrab==4 | satisfjornadatrab==5)
*replace Jornada=0 if (satisfjornadatrab==1 | satisfjornadatrab==2 | satisfjornadatrab==3)

*gen Salario=.
*replace Salario=1 if (satisfsalario==4 | satisfsalario==5)
*replace Salario=0 if (satisfsalario==1 | satisfsalario==2 | satisfsalario==3)

gen Carteira_Assinada=.
replace Carteira_Assinada=1 if (ocupacao==01 | ocupacao==02 | ocupacao==03 | ocupacao==06)
replace Carteira_Assinada=0 if (ocupacao==04 | ocupacao==07 | ocupacao==09 | ocupacao==10 | ocupacao==11 | ocupacao==12 | ocupacao==13)

*gen Ensino_ate_4anos=.
*replace Ensino_ate_4anos=1 if (anosestudo==01 | anosestudo==02 | anosestudo==03 | anosestudo==04 | anosestudo==05)
*replace Ensino_ate_4anos=0 if (anosestudo==06 | anosestudo==07 | anosestudo==08 | anosestudo==09 | anosestudo==10 | anosestudo==11 | anosestudo==12 | anosestudo==13 | anosestudo==14 | anosestudo==15 | anosestudo==16 | anosestudo==17)

*gen Ensino_5a8anos=.
*replace Ensino_5a8anos=1 if (anosestudo==06 | anosestudo==07 | anosestudo==08 | anosestudo==09)
*replace Ensino_5a8anos=0 if (anosestudo==01 | anosestudo==02 | anosestudo==03 | anosestudo==04 | anosestudo==05 | anosestudo==10 | anosestudo==11 | anosestudo==12 | anosestudo==13 | anosestudo==14 | anosestudo==15 | anosestudo==16 | anosestudo==17)

*gen Ensino_9a11anos=.
*replace Ensino_9a11anos=1 if (anosestudo==10 | anosestudo==11 | anosestudo==12)
*replace Ensino_9a11anos=0 if (anosestudo==01 | anosestudo==02 | anosestudo==03 | anosestudo==04 | anosestudo==05 | anosestudo==06 | anosestudo==07 | anosestudo==08 | anosestudo==09 | anosestudo==13 | anosestudo==14 | anosestudo==15 | anosestudo==16 | anosestudo==17)

*gen Ensino_maisde11anos=.
*replace Ensino_maisde11anos=1 if (anosestudo==13 | anosestudo==14 | anosestudo==15 | anosestudo==16)
*replace Ensino_maisde11anos=0 if (anosestudo==01 | anosestudo==02 | anosestudo==03 | anosestudo==04 | anosestudo==05 | anosestudo==06 | anosestudo==07 | anosestudo==08 | anosestudo==09 | anosestudo==10 | anosestudo==11 | anosestudo==12 | anosestudo==17)

gen idade2=idade^2

*gen Lnrenda=ln(rendimento)

gen Insatisfeito=.
replace Insatisfeito=1 if (satisfacao_cond_prometidas==1)
replace Insatisfeito=0 if (satisfacao_cond_prometidas==2 | satisfacao_cond_prometidas==3 | satisfacao_cond_prometidas==4 |satisfacao_cond_prometidas==5)

gen Pouco_Satisfeito=.
replace Pouco_Satisfeito=1 if (satisfacao_cond_prometidas==2)
replace Pouco_Satisfeito=0 if (satisfacao_cond_prometidas==1 | satisfacao_cond_prometidas==3 | satisfacao_cond_prometidas==4 |satisfacao_cond_prometidas==5)

*gen Indiferente=.
*replace Indiferente=1 if (satisfacao_cond_prometidas==3)
*replace Indiferente=0 if (satisfacao_cond_prometidas==1 | satisfacao_cond_prometidas==2 | satisfacao_cond_prometidas==4 |satisfacao_cond_prometidas==5)

gen Satisfeito=.
replace Satisfeito=1 if (satisfacao_cond_prometidas==3 | satisfacao_cond_prometidas==4)
replace Satisfeito=0 if (satisfacao_cond_prometidas==1 | satisfacao_cond_prometidas==2 |satisfacao_cond_prometidas==5)

gen Muito_Satisfeito=.
replace Muito_Satisfeito=1 if (satisfacao_cond_prometidas==5)
replace Muito_Satisfeito=0 if (satisfacao_cond_prometidas==1 | satisfacao_cond_prometidas==2 | satisfacao_cond_prometidas==3 |satisfacao_cond_prometidas==4)

**gen Satisfacao_Trabalho=.
**replace Satisfacao_Trabalho=1 if Muito_Satisfeito==1
**replace Satisfacao_Trabalho=2 if Satisfeito==1 
*replace Satisfacao_Trabalho=3 if Indiferente==1
**replace Satisfacao_Trabalho=3 if Pouco_Satisfeito==1
**replace Satisfacao_Trabalho=4 if Insatisfeito==1

gen Satisfacao_Trabalho=.
replace Satisfacao_Trabalho=1 if (Muito_Satisfeito==1 | Satisfeito==1)
replace Satisfacao_Trabalho=0 if (Pouco_Satisfeito==1 | Insatisfeito==1)


gen sul=(40<uf) & (uf<44)
gen sudeste=(30<uf) & (uf<36)
gen nordeste=(20<uf) & (uf<30)
gen centro_oeste=(49<uf) & (uf<54)
gen norte=(uf<18)

*** ESTIMANDO O MODELO PROBIT ORDENADO ***

oprobit Satisfacao_Trabalho Masculino idade idade2 Casado Branco Carteira_Assinada Sindicato anosestudo setor rendimento horastrab tempo_servico [pw=peso], nolog

mfx

*** CRIANDO CENÁRIOS ***

*** CENÁRIO DE REFERÊNCIA ***

margins,  predict(outcome(1)) at(Casado=1 Branco=1 Carteira_Assinada=1 anosestudo=10 idade=33) atmeans

*** CENÁRIO 1 *** ESTADO CIVIL

margins,  predict(outcome(1)) at(Casado=0 Branco=1 Carteira_Assinada=1 anosestudo=10 idade=33) atmeans

*** CENÁRIO 2 *** COR

margins,  predict(outcome(1)) at(Casado=1 Branco=0 Carteira_Assinada=1 anosestudo=10 idade=33) atmeans

*** CENÁRIO 3 *** CARTEIRA ASSINADA

margins,  predict(outcome(1)) at(Casado=1 Branco=1 Carteira_Assinada=0 anosestudo=10 idade=33) atmeans

*** CENÁRIO 4 *** ANOS DE ESTUDO

margins,  predict(outcome(1)) at(Casado=1 Branco=1 Carteira_Assinada=1 anosestudo=16 idade=33) atmeans

*** CENÁRIO 5 *** ANOS DE ESTUDO

margins,  predict(outcome(1)) at(Casado=1 Branco=1 Carteira_Assinada=1 anosestudo=8 idade=33) atmeans

*** CENÁRIO 6 *** IDADE

margins,  predict(outcome(1)) at(Casado=1 Branco=1 Carteira_Assinada=1 anosestudo=10 idade=43) atmeans


save

