***SATISFAÇÃO NO TRABALHO: COMPARAÇÃO ENTRE TRABALHADORES FORMAIS E INFORMAIS NO MERCADO DE TRABALHO BRASILEIRO***
***baixar Datazoom***
net from http://www.econ.puc-rio.br/datazoom/portugues

*** trabalhando a base de dados com Datazoom (merged) ***
db datazoom_pnad


use "C:\Users\Caio\OneDrive\mestrado\pnad2015.dta", clear


** DEFINIR AMOSTRA COMO COMPLEXA**

svyset v4618[pweight=v4729], strata(v4617) vce(linearized) || _n
svydes, single

** COMANDO IDONEPSU **

#delimit;
idonepsu, strata(v4617) psu(v4618) generate(new);
drop v4617 v4618 ;
rename newstr strat;
rename newpsu psu;
#delimit cr

svyset psu [pweight=v4729], strata(strat) vce(linearized) || _n
svydes, single

*** OBSERVACOES QUE AINDA ESTAO COM PSU UNICO MESMO APOSS A UTILIZACAO DO IDONEPSU ***

svydes, finalstage


*** ESPECIFICANDO O LOCAL QUE O ARQUIVO SERA SALVO ***

cd "C:\Users\Caio\OneDrive\mestrado\"

*** TEMOS QUE ELIMINAR OBS=1, SENDO UNIT = PSU ***

#delimit;
drop if strat == 230006 & psu == 170;
drop if strat == 350009 & psu == 68;
drop if strat == 140001	& psu == 32;
drop if strat == 230003	& psu == 21;
drop if strat == 260014	& psu == 376;
drop if strat == 330030	& psu == 599;
drop if strat == 350016	& psu == 107;
drop if strat == 350016	& psu == 108;
drop if strat == 420006	& psu == 50;

#delimit cr


save "C:\Users\Caio\OneDrive\mestrado\Artigo33"

** DROPAR MISSINGS **
drop if v3703==. 

***drop rendimento***
drop if v4718>80000

**Dropando individuos com menos de 16 anos **
drop if v8005<16


**CRIAR DUMMIES**
gen Branco=.
replace Branco=1 if v0404 == 2
replace Branco=0 if (v0404==4 | v0404==6 | v0404==8 | v0404 == 0 | v0404 == 9)

gen AnosEstudo = v4803

gen CarteiraTrab=.
replace CarteiraTrab=1 if v9042==2
replace CarteiraTrab=0 if (v9042==4)

gen Rendimento = v4718

gen HorasTrab = v4707 

gen Idade2 = v8005^2
gen Idade = v8005

gen AnosServi= v9611

gen Casado=.
replace Casado=1 if v4011 == 1
replace Casado=0 if (v4011==3 | v4011==5 | v4011==7 | v4011==0)

gen Sindicato=.
replace Sindicato=1 if v9087 == 1
replace Sindicato=0 if v9087 == 3 

gen Feminino=.
replace Feminino=1 if v0302 == 4
replace Feminino=0 if v0302 == 2

gen uf_n = real(uf)
gen sul=(40<uf_n) & (uf_n<44)
gen sudeste=(30<uf_n) & (uf_n<36)
gen nordeste=(20<uf_n) & (uf_n<30)
gen centro_oeste=(49<uf_n) & (uf_n<54)
gen norte=(uf_n<18)


**definindo variavel independente**
rename v3703 Satisf

***dropando missing carteira de trabalho****
drop if CarteiraTrab==.

**dropando trabalhadores com mais de 65 anos de idade***
drop if Idade > 65

save "C:\Users\Caio\OneDrive\mestrado\Artigo333"


**analise descritiva Carteira de trabalho - Satisfacao**
**para fazer a análise descritiva é necessário dropar alguns missings**

drop if Casado ==.

tab CarteiraTrab Satisf, cel

tab CarteiraTrab Feminino, cel

***analisar se há trabalhadores do setor público na amostra (v9032)***
tab v9032

sum Feminino Idade AnosServi Branco CarteiraTrab Sindicato AnosEstudo HorasTrab Rendimento Casado norte nordeste sudeste centro_oeste sul

** rodando o Probit Ordenado **

oprobit Satisf Feminino Idade Idade2 AnosServi Branco CarteiraTrab Sindicato AnosEstudo HorasTrab Rendimento Casado norte nordeste centro_oeste sul [pweight = v4729], vce(robust)

mfx, predict (outcome(1))
mfx, predict (outcome(2))
mfx, predict (outcome(3))
mfx, predict (outcome(4))
mfx, predict (outcome(5))

**salvar tabela no word***
ssc install logout

logout, save (Resultados2) word replace:oprobit Satisf Feminino Idade Idade2 AnosServi Branco CarteiraTrab Sindicato AnosEstudo HorasTrab Rendimento Casado norte nordeste centro_oeste sul [pweight = v4729], vce(robust)


