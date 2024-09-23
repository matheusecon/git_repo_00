****************************************************************************************************************************************************
*****************                 APOSTILA DO MINICURSO MICRODADOS COM O USO DO STATA                   ********************************************
************************                ECONS - FACULDADE DE ECONOMIA UFJF                              ********************************************
*******************************                  IGOR VIEIRA PROCÓPIO                                   ********************************************
****************************************************************************************************************************************************



*! "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" https://www.ssc.wisc.edu/sscc/pubs/sfs/sfs-descriptives.htm#oneway




use "https://igorprocopio.github.io/Datasets/pnad_mod.dta", clear


misstable summarize

mark nomiss
markout nomiss renda educ ativ

************************************************************************************************************************
******************************                  VARIÁVEIS CATEGÓRICAS                 **********************************
************************************************************************************************************************



* Calcular a frequência relativa para cada categoria da variável raca sem considerar o peso amostral e 
*considerando o peso amostral. 
tab raca

tab raca [w=peso]

* Calcular a frequência relativa da variável raca apenas para as mulheres (variável sexo igual a 2) 
*considerando os pesos amostrais.
tab raca [w=peso] if sexo ==2

* Calcular a frequência relativa de cada categoria da variável sexo para as pessoas de cor branca 
*(raca = 2) ou amarela (raca=4) com mais de 5 anos de estudo considerando os pesos amostrais.
tab sexo [w=peso] if (raca == 2 | raca == 4) & educ > 5


* Construir uma tabela com o total e percentual de pessoas com mais de 5 anos de escolaridade 
*para cada subgrupo de sexo e raça considerando os pesos amostrais. 
tab raca sexo [w=peso] if educ>5, cel


***********


** O padrão do Stata é utilizar e apresentar os resultados no formato americano
** (ponto como separador de casas decimais e vírgula como separador
** de milhares), se o objetivo for utilizar o padrão Europeu (o mesmo utilizado 
** no Brasil) basta digitar o comando abaixo:

set dp comma

*** A PNAD é uma pesquisa amostral, portanto, toda estatística deve ser calculada
** utilizando a ponderação. 

tab raca [w=peso]

tab raca [w=peso], sort


** Tabelas cruzadas


tab raca sexo [fw=peso]

tab raca sexo [fw=peso], row nofreq

tab raca sexo [fw=peso], col nofreq

tab raca sexo [fw=peso], cel nofreq



********************************************************************************
************              Variáveis contínuas        	************************   


** O comando sum calcula algumas estatíticas descritivas de variáveis contínuas
sum educ renda  [fw=peso]

** Apesar da simplicidade do comando sum ele não permite a escolha de quais 
** estatísticas devem ser calculadas

tabstat renda [w=peso], statistics(mean sd) columns(variables)

tabstat renda [w=peso], statistics(mean sd) columns(variables)  format(%8,2fc)


tabstat renda [w=peso], statistics( mean sd ) by(sexo) columns(variables)


tabstat renda educ [fweight = peso], statistics( mean sd range median) ///
	columns(statistics) format(%8,2fc)

tabstat renda educ [fweight = peso], statistics( mean sd range median ) ///
	columns(variables) format(%8,2fc)


********************************************************************************
***********     diferenciais de renda e educação por raça e sexo


tab raca [fw=peso], sum(renda)

tab raca [fw=peso], sum(renda) nofreq noobs


table raca [w = peso], contents(mean renda sd renda) row format(%8,2fc)

table raca sexo [w = peso], contents(mean renda sd renda) col row format(%9,2fc)

* Construir uma matriz de correlação com as variáveis educ, renda e ren_fam, considerando os 
*pesos amostrais.
cor educ renda ren_fam [w=peso]





