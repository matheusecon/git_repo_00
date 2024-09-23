****************************************************************************************************************************************************
*****************                 APOSTILA DO MINICURSO MICRODADOS COM O USO DO STATA                   ********************************************
************************                ECONS - FACULDADE DE ECONOMIA UFJF                              ********************************************
*******************************                  IGOR VIEIRA PROCÓPIO                                   ********************************************
****************************************************************************************************************************************************




**************************** SEÇÃO 8 – UMA APLICAÇÃO À PNAD **********************************

* Utilizar o banco de dados da PNAD 2008 para esta seção
use "https://igorprocopio.github.io/Datasets/pnad.dta", clear



desc, sh



* Exercício 1: Mantenha no banco de dados apenas as seguintes variáveis, UF V0302 V8005 V0404 V4803 V4718 
*V4729 V4722 V4724 V0501 V0601 V0701 V4704 V480, que serão utilizadas nos próximos exercícios.
keep UF V0302 V8005 V0404 V4803 V4718 V4729 V4722 V4724 V0501 V0601 V0701 V4704 V4805 V4618 V4617 V9058

* Exercício 2: Renomear as variáveis UF V0302 V8005 V0404 V4803 V4718 V4729 V4722 V4724 V0501 V0601 
*V0701 V4704 V4805 para uf sexo idade raca educ renda peso ren_fam componentes migra analfabeto infantil *ativ ocup:

ren (UF V0302 V8005 V0404 V4803 V4718 V4729 V4722 V4724 V0501 V0601 V0701 V4704 V4805 V9058) ///
	(uf sexo idade raca educ renda peso ren_fam componentes migra analfabeto infantil ativ ocup horas)
 	

* Exercício 3: Acrescentar rótulos para as variáveis sexo, raca, migra, analfabeto, infantil, ativ e  ocup de acordo
 *com o dicionário de variáveis da PNAD. Ao final utilizar o comando numlabel, 
* add para deixar junto com os rótulos os valores das variáveis:

label define codsexo 2 "Homem" 4 "Mulher" 
label values sexo codsexo

label define codraca 2 "Branca" 4 "Preta" 6 "Amarela" 8 "Parda" 0 "Indígena" 9 "Sem declaração"
label values raca codraca

label define migrante 1 "Não migrante" 3 "Migrante"
label values migra migrante

label define analf 1 "Sabe ler" 3 "Analfabeto"
label values analfabeto analf

label define trab 1 "Trabalha" 3 "Não trabalha"
label values infantil trab

label define atividade 1 "Economicamente ativo" 2 "Não economicamente ativo"
label values ativ atividade

label define ocupação 1 "Ocupado" 2 "Desocupado"
label values ocup ocupacao

numlabel, add


* Exercício 4: Gerar variáveis novas com as seguintes informações: idade ao quadrado, logaritmo natural da renda 
*e renda familiar per capita:
* Idade ao quadrado
gen ida2 = idade^2
* Logaritmo natural da renda
gen lnrenda = ln(renda)
* Renda familiar per capita
gen per_capita = ren_fam / componentes
 
* Exercício 5: A variável renda na PNAD possui o valor 999999999999 para as pessoas que não responderam a 
*esta pergunta na pesquisa. Este valor influencia nas estatísticas da variáel renda, puxando os resultados para 
*cima.  Substitua estes valores por missing. Calcule a renda média antes e depois da substituição para comparar 
*os resultados.
sum renda

replace renda = . if renda == 999999999999

sum renda


* Exercício 6: Veja no dicionário de variáveis as categorias da variável de anos de estudo (V4803). Note que o
*código 1 se refere às pessoas sem instrução, o código 2 às pessoas com 1 ano de escolaridade e assim por 
*diante.  Desta maneira, calcular informações relativas aos anos de estudo estarão enviesadas para cima. Além 
*disto, a categoria 17 se refere às pessoas que não declaram a escolaridade. Corrija esta variável para que os 
*valores  das categorias se refiram corretamente aos anos de estudo. Calcule a média antes e depois da correção 
*dos valores.

sum educ

replace educ = . if educ == 17
replace educ = educ - 1

sum educ





