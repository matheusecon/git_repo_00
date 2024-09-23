****************************************************************************************************************************************************
*****************                 APOSTILA DO MINICURSO MICRODADOS COM O USO DO STATA                   ********************************************
************************                ECONS - FACULDADE DE ECONOMIA UFJF                              ********************************************
*******************************                  Outubro de 2017                                        ********************************************
****************************************************************************************************************************************************



/*

! "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" https://www.stata.com/features/example-graphs/

! "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" https://www.stata.com/support/faqs/graphics/gph/stata-graphs/

! "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" https://www.surveydesign.com.au/tipsgraphs.html

! "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" https://www.ssc.wisc.edu/sscc/pubs/4-24.htm

! "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" https://stats.idre.ucla.edu/stata/modules/graph8/intro/introduction-to-graphs-in-stata/

! "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" http://www.stata-press.com/books/visual-guide-to-stata-graphics/index.html#ebook

*/



use "https://igorprocopio.github.io/Datasets/pnad_mod.dta", clear


********************************************************************************************************




histogram renda [w = peso]

histogram lnrenda [w = peso] 


lookup lean2
set scheme lean2


histogram lnrenda if lnrenda < 20 [w = peso], title("Histograma") note("Fonte: Elaborado pelo Econs")

histogram educ [w = peso] if idade >=25, discrete addlabels xlabel(, valuelabel angle(45))


set scheme s2color

**********************************************************************************************************

tab raca, g(draca)
graph bar (mean) draca* [w = peso] , blabel(bar) legend(order(1 "Indígena" 2 "Branca" 3 "Preta" 4 "Amarela" ///
	5 "Parda" 6 "Sem declaração")) title(Distribuição de raça) ///
	note("Fonte: Elaborado pelo Econs a partir dos dados da PNAD 2008")


graph pie [pweight = peso], over(raca) plabel(_all percent, format(%5,2fc)) title(Distribuição de raça) ///
	note("Fonte: Elaborado pelo Econs a partir dos dados da PNAD 2008")


**************************************************************************************************************
graph box lnrenda [w = peso]

graph box lnrenda [w = peso], by(sexo) noout



***************************************************************************************************************

graph bar (mean) renda [w = peso], over(educ)

graph bar (sum) renda [w = peso], over(educ)

graph bar (mean) renda [w = peso], over(uf)  ytitle (Renda) title("Renda por UF")


graph bar (sum) renda [w = peso], over(sexo)


**************************************************************************************************************

graph dot renda, over(raca)

sum renda
local media = r(mean)
graph dot renda, over(raca) yline(`media')


***************************************************************************************************************


scatter horas renda, msize(.4)

scatter horas lnrenda [w = peso], msize(.2)


scatter horas lnrenda if lnrenda <20 [w = peso], msize(.2)


scatter lnrenda idade if lnrenda <20 [w = peso], msize(.2)
 



tw lfit lnrenda idade if lnrenda < 20 [w = peso]

tw lfitci lnrenda idade if lnrenda < 20 [w = peso]

graph matrix renda horas idade [w = peso], msize(.2) msymbol(p)


twoway (scatter horas lnrenda if lnrenda <20 [w = peso], msize(.2)) ///
 (lfit horas lnrenda if lnrenda <20 [w = peso]) 


twoway (scatter horas lnrenda if lnrenda <20 [w = peso], msize(.2)) (lfitci horas lnrenda if lnrenda <20 [w = peso]) 

tw lfitci horas lnrenda if lnrenda <20 [w = peso]

********************************************************************************************************************

kdensity lnrenda if lnrenda < 20 [w = peso]
 
kdensity lnrenda if lnrenda < 20 & sexo == 2 [w = peso]

kdensity lnrenda if lnrenda < 20 & sexo == 2 [w = peso], addplot(kdensity lnrenda if lnrenda < 20 & sexo == 4 [w = peso]) ///
	legend(order(1 "Homem" 2 "Mulher")) title("Densidade") note("Fonte: Elaborado pelo Econs")

*graph export "Graficos\densidade.png", replace

