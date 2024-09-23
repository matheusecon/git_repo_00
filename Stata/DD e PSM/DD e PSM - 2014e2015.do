********************************************************************************
* //////////////// Rodando Dif-em-Dif e PSM ////////////////////////////////// *
********************************************************************************
cd "C:\Users\Matheus\Desktop\matheus\ufv\artigos\politicas publicas - salário mínimo\bases de dados\PME\dados trabalhandos2\2014e2015\pmenova"
/// Na pasta selecionada acima se econtra os dados empilhados da pme de 2010
** e 2011, todos eles ja editados.//

set more off
set memory 512m
clear
/// Este comando espande a memória do software o fazendo ser mais eficiente.//

use pmenova2014e2015, replace
/// Mostrando qual base de dados será usado, lembrado que deve ser a base de da-
** dos extraida do datazoon para os dois anos retiradas no mesmo instante, para
** que os codigos de individuos sejam gerados corretamente.//

************NOVO******************
/// Analise descritive do grupo de tratados e controle. Os grupos devem ser se-
** parados mas não pode-se dropar os indivíduos que não foram pareados.//
*** analise descritiva para o grupo de tratados ***
tab v070 if v070 == 11 & dumieTC == 1
tab v070 if v070 == 12 & dumieTC == 1
tab v070 if v070 == 1 & dumieTC == 1
tab v070 if v070 == 2 & dumieTC == 1

tab Sexo if v070 == 11 & dumieTC == 1
tab Sexo if v070 == 12 & dumieTC == 1
tab Sexo if v070 == 1 & dumieTC == 1
tab Sexo if v070 == 2 & dumieTC == 1

tab Cor if v070 == 11 & dumieTC == 1
tab Cor if v070 == 12 & dumieTC == 1
tab Cor if v070 == 1 & dumieTC == 1
tab Cor if v070 == 2 & dumieTC == 1

tab De1a3AnosEst if v070 == 11 & dumieTC == 1
tab De1a3AnosEst if v070 == 12 & dumieTC == 1
tab De1a3AnosEst if v070 == 1 & dumieTC == 1
tab De1a3AnosEst if v070 == 2 & dumieTC == 1

tab De4a7AnosEst if v070 == 11 & dumieTC == 1
tab De4a7AnosEst if v070 == 12 & dumieTC == 1
tab De4a7AnosEst if v070 == 1 & dumieTC == 1
tab De4a7AnosEst if v070 == 2 & dumieTC == 1

tab De8a10AnosEst if v070 == 11 & dumieTC == 1
tab De8a10AnosEst if v070 == 12 & dumieTC == 1
tab De8a10AnosEst if v070 == 1 & dumieTC == 1
tab De8a10AnosEst if v070 == 2 & dumieTC == 1

tab Maisde11AnosEst if v070 == 11 & dumieTC == 1
tab Maisde11AnosEst if v070 == 12 & dumieTC == 1
tab Maisde11AnosEst if v070 == 1 & dumieTC == 1
tab Maisde11AnosEst if v070 == 2 & dumieTC == 1

/////////////////////////////////
*** analise descritiva para o grupo de controle ***
tab v070 if v070 == 11 & dumieTC == 0
tab v070 if v070 == 12 & dumieTC == 0
tab v070 if v070 == 1 & dumieTC == 0
tab v070 if v070 == 2 & dumieTC == 0

tab Sexo if v070 == 11 & dumieTC == 0
tab Sexo if v070 == 12 & dumieTC == 0
tab Sexo if v070 == 1 & dumieTC == 0
tab Sexo if v070 == 2 & dumieTC == 0

tab Cor if v070 == 11 & dumieTC == 0
tab Cor if v070 == 12 & dumieTC == 0
tab Cor if v070 == 1 & dumieTC == 0
tab Cor if v070 == 2 & dumieTC == 0

tab De1a3AnosEst if v070 == 11 & dumieTC == 0
tab De1a3AnosEst if v070 == 12 & dumieTC == 0
tab De1a3AnosEst if v070 == 1 & dumieTC == 0
tab De1a3AnosEst if v070 == 2 & dumieTC == 0

tab De4a7AnosEst if v070 == 11 & dumieTC == 0
tab De4a7AnosEst if v070 == 12 & dumieTC == 0
tab De4a7AnosEst if v070 == 1 & dumieTC == 0
tab De4a7AnosEst if v070 == 2 & dumieTC == 0

tab De8a10AnosEst if v070 == 11 & dumieTC == 0
tab De8a10AnosEst if v070 == 12 & dumieTC == 0
tab De8a10AnosEst if v070 == 1 & dumieTC == 0
tab De8a10AnosEst if v070 == 2 & dumieTC == 0

tab Maisde11AnosEst if v070 == 11 & dumieTC == 0
tab Maisde11AnosEst if v070 == 12 & dumieTC == 0
tab Maisde11AnosEst if v070 == 1 & dumieTC == 0
tab Maisde11AnosEst if v070 == 2 & dumieTC == 0
************NOVO******************


********************************************************************************
* ///////////////////////////////// PSM ////////////////////////////////////// *
********************************************************************************

/// Deve ser calculado o PSM no ano anterior ao aumento do salário minimo
** ou seja anterior ao tratamento

*** VARIÁVEL DE TRATAMENTO: dumieTC - (tratado=1 e controle=0) ***
*** PSM - 5 VIZINHOS MAIS PRÓXIMOS ***
/// Neste teste deve ser analisado o p-valor de cada variável de controle. Nos 
** revela se uma variável será relevante em relação a probabilidade do indivi-
** duo percentecer ao grupo de tratamento ou não, e o coeficiente nos dirá em 
** que sentido isso ocorre.///
psmatch2 dumieTC Sexo Cor De1a3AnosEst De4a7AnosEst De8a10AnosEst Maisde11AnosEst if v075==2014, n(5) common ties

************NOVO******************
mfx compute, dydx at(mean)
************NOVO******************

*** Calcula-se a porcentagem de acerto do modelo, analisando sua capacidade 
** preditiva ***
/// Buscar explicação sobre como se analisa este teste.//
estat class

*** Teste de médias para verificar a redução do viés ***
/// Este teste é importante para se analisar se o viés de seletividade foi redu-
** zido após a aplicação do teste, ou seja, se as variáveis de controle estão 
** contribuindo para a redução do viés. A hipótese nula (H0) é a de que as mé-
** dias das variáveis são iguais após o matching. Sendo assim uma boa variável
** é a que deixa as médias iguais após o matchig - não rejeitando H0. Para esse 
** primeiro passo se analisa o p-valor de cada variável após o matching (M).//
/// Outra analise importante desse teste é o Teste de Rubim, que nos revela se 
** o modelo estara bem ajustado se os valores R estiverem entre 0,5 e 2 (ver 
** help pstest).//
pstest Sexo Cor De1a3AnosEst De4a7AnosEst De8a10AnosEst Maisde11AnosEst, both

*** PROCURAR O NOME DESSE TESTE ***
/// Para verificar o grau de ajustamento do pareamento, testa-se a hipótese de
** equilíbrio do modelo. O comando irá separar blocos de matching. Entretando
** a unica coisa que nos importa é se a propriedade de quilibrio esta satisfeita
** (The balancing property is satisfied).//
pscore dumieTC Sexo Cor De1a3AnosEst De4a7AnosEst De8a10AnosEst Maisde11AnosEst, pscore(mypscore) logit level(0.001) numblo(10)

********************************************************************************
* ///////////////////////////////// DD /////////////////////////////////////// *
********************************************************************************

*** DEIXAR NA AMOSTRA APENAS AS UNIDADES PAREADAS
/// Com esse comando as unidades de controle que não receberam peso (não foram 
** pareadas) serão excluídas da amostra, apenas as do primeiro ano.//
sort ID _weight 
quietly by ID _weight: gen dup = cond(_N==1,0,_n)
count if dup>0

drop if dup>0

xtset ID v072

*** Criando a Dummy de tratado pra Logit de Pooled, EF e EA ***
by idind, sort: egen tratado = max(_treated)

drop if tratado==.

by idind, sort: egen _weight2 = max (_weight)

*** Criando dummy de periodo ***
gen periodo =.
replace periodo =0 if v075 ==2014
replace periodo =1 if v075 ==2015

*** Criando dummy de tratado para EF e EA ***
gen tratado2 =tratado
recode tratado2 1=0 if v075==2014

*** Criando a variável de impacto ***
gen impacto = tratado*periodo

*** Para declarar que vai usar painel ***
/// Deve-se declarar no programa a variável referente à série de tempo e a refe-
** rente às unidades (individuos) - primeiro ano (no nosso caso meses) e depois 
** individuo.//
tis v072

iis ID


********************************************************************************
* ///////////// Descrição da analise de Diferença em Diferença /////////////// *
********************************************************************************
* 																			   *
* O modelo a ser utilizado será o de Efeitos Fixos com Logit e será utilizado  *
* sem variáveis de controle, para simplificar a análise. Os outros modelos não *
* serão utilizados, sendo apenas o utilimo modelo o analisado.                 *
*																			   *
********************************************************************************

*** Dif em Dif ***
/// Neste caso se analisa o p-valor em Diff (T-C) e o seu coeficiente que nos 
** dirá o efeito da política no grupo de tratado em comparação ao de controle.
*diff Ocupado, t(tratado) p(periodo)

***Dif em Dif com controles ***
/// É a mesma analise porem com controles.//
*diff Ocupado, t(tratado) p(periodo) cov(Recife Salvador BH SP Curitiba PA) kernel id(ID) support addcov(Recife Salvador BH SP Curitiba PA)

*** Logit Pooled ***
/// O que deve ser analisado é a variável tratado e nos dirá se o efeito da po-
** litica foi significativo e qual foi impacto.//
*logit Ocupado tratado periodo impacto [pweight = _weight2], vce(cluster id)

*** Logit Pooled com controles ***
/// A analise é a mesma do modelo anterior, entretanto se insere as variáveis
** de controle que podem impactar a evolução da variável explicada.//
*logit Ocupado tratado periodo impacto Recife Salvador BH SP Curitiba PA [pweight = _weight2]

*** Logit Efeitos Aleatorios ***
/// Neste caso a analise a ser avaliada é tratado2 e a analise é a mesma.//
*xtlogit Ocupado tratado2 periodo, re nolog

*** Logit Efeitos Aleatorio com controles ***
/// Neste caso a analise a ser avaliada é tratado2 e a analise é a mesma.//
*xtlogit Ocupado tratado2 periodo Recife Salvador BH SP Curitiba PA, re nolog

*** Logit Efeitos fixos com controles ***
/// Neste caso a analise a ser avaliada é tratado2 e a analise é a mesma.//
*xtlogit Ocupado tratado2 periodo Recife Salvador BH SP Curitiba PA, fe nolog

*** Logit Efeitos Fixos ***
/// Neste caso a analise a ser avaliada é tratado2 e a analise é a mesma.//
*xtlogit Ocupado tratado2 periodo, re log

*** Modelo de probabilidade linear - probit pooled***
probit Ocupado tratado periodo impacto [pweight = _weight2], vce(cluster id)

************NOVO******************
mfx compute, dydx at(mean)

xtreg Ocupado tratado impacto periodo, re
qui xtreg Ocupado tratado impacto periodo, re
xttest0
qui xtreg Ocupado tratado impacto periodo, fe
estimates store fe
qui xtreg Ocupado tratado impacto periodo, re
estimates store re
hausman fe re
************NOVO******************



******************************************
* ////////////// DUVIDA //////////////// *
******************************************
*										 *
* POR QUE NÃO SE USA PWEIGHT EM EF OU EA *
*										 *
******************************************

**********************************************************
* /////////////// NOTA DE RODAPÉ /////////////////////// *
**********************************************************
*														 *
* ARRUMAR UM TESTE QUE DEFINA QUAL O MELHOR MODELO EF,	 *
* EA, POOLED (no LOGIT) OU DIFF-EM-DIFF. DEVE SER CONFE- *
* RIDO ANTES SE O IMPACTO DO DIFF-EM-DIFF ESTÁ LEVANDO   *
* EM CONSIDERAÇÃO SE A VARIÁVEL DEPENDENTE É QUALITATIVA.*
*														 *	
**********************************************************

********************************************************************************
* //////////////////////// PODE PARAR ATÉ AQUI /////////////////////////////// *
********************************************************************************

/// AS ANALISES A SEGUIR NOS AUXILIARAM A CARATERIZAR MELHOR COMO SÃO COMPOSTOS
** OS GRUPOS DE TRATAMENTO E CONTROLE ANTES E DEPOIS DA POLITICA.//

// *** TESTES E HISTOGRAMAS *** //
tab dumieTC

*** Quantas unidades estão no suporte comum ***
tab _support
tab _support if dumieTC==1

*** Quantas unidades foram pareadas (receberam peso _weight) ***
count if _weight!=. & dumieTC==0
count if _weight==.

*** Análise das distribuições dos escores estimados *** 
tabstat _ps if dumieTC==1, stat (mean sd p10 median p90)
tabstat _ps if dumieTC==1 & _support==1, stat (mean sd p10 median p90)
sum _ps if dumieTC==0
tabstat _ps if dumieTC==0, stat (mean sd p10 median p90)
tabstat _ps if dumieTC==0 &_weight!=., stat (mean sd p10 median p90)
sum _ps if dumieTC==0 &_weight!=.

psgraph, bin(10) /// ESTA DANDO ERRO
histogram _ps if dumieTC==1 & _support==1, bin(10) percent
histogram _ps if dumieTC==0, bin(10) percent
histogram _ps if dumieTC==0 & _weight!=., bin(10) percent


***************************************************************

*** Estatistica descritiva para os indivíduos tratados ***
/// sum nos dará a média, máximo e mínimo e tab a porcentagem dos diferentes
** grupos.//
*** Estatistica descritiva para os individuos de controle ***
sum SalarioPrinc if tratado==1 & periodo==0
sum SalarioPrinc if tratado==1 & periodo==1

sum Idade if tratado==1 & periodo==0
sum Idade if tratado==1 & periodo==1

sum QtdeMoradores if tratado==1 & periodo==0
sum QtdeMoradores if tratado==1 & periodo==1

tab Ocupado if tratado==1 & periodo==0
tab Ocupado if tratado==1 & periodo==1

tab Sexo if tratado==1 & periodo==0
tab Sexo if tratado==1 & periodo==1

tab SemInstrucao if tratado==1 & periodo==0
tab SemInstrucao if tratado==1 & periodo==1

tab Fundamental if tratado==1 & periodo==0
tab Fundamental if tratado==1 & periodo==1

tab Analfabeto if tratado==1 & periodo==0
tab Analfabeto if tratado==1 & periodo==1

tab Temporario if tratado==1 & periodo==0
tab Temporario if tratado==1 & periodo==1

tab Formal if tratado==1 & periodo==0
tab Formal if tratado==1 & periodo==1

tab Chefe if tratado==1 & periodo==0
tab Chefe if tratado==1 & periodo==1

*** Estatistica descritiva para os individuos de controle ***
sum SalarioPrinc if tratado==0 & periodo==0
sum SalarioPrinc if tratado==0 & periodo==1

sum Idade if tratado==0 & periodo==0
sum Idade if tratado==0 & periodo==1

sum QtdeMoradores if tratado==0 & periodo==0
sum QtdeMoradores if tratado==0 & periodo==1

tab Ocupado if tratado==0 & periodo==0
tab Ocupado if tratado==0 & periodo==1

tab Sexo if tratado==0 & periodo==0
tab Sexo if tratado==0 & periodo==1

tab SemInstrucao if tratado==0 & periodo==0
tab SemInstrucao if tratado==0 & periodo==1

tab Fundamental if tratado==0 & periodo==0
tab Fundamental if tratado==0 & periodo==1

tab Analfabeto if tratado==0 & periodo==0
tab Analfabeto if tratado==0 & periodo==1

tab Temporario if tratado==0 & periodo==0
tab Temporario if tratado==0 & periodo==1

tab Formal if tratado==0 & periodo==0
tab Formal if tratado==0 & periodo==1

tab Chefe if tratado==0 & periodo==0
tab Chefe if tratado==0 & periodo==1


///*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*///
*    VARIÁVEL QUE INDICA A região metropolitana é RM    	*
*															*
* recife=26 Salvador=29 Belo Horizonte=31 Rio de Janeiro=33 *
* São Paulo=35 Curitiba=41 Porto Alegre=43                  *
* 															*
///*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*///

*** Porcentagem de ocupados em cada região Metropolitana, para os tratados ***
tab Ocupado if tratado==1 & periodo==0 & RM==26
tab Ocupado if tratado==1 & periodo==1 & RM==26

tab Ocupado if tratado==1 & periodo==0 & RM==29
tab Ocupado if tratado==1 & periodo==1 & RM==29

tab Ocupado if tratado==1 & periodo==0 & RM==31
tab Ocupado if tratado==1 & periodo==1 & RM==31

tab Ocupado if tratado==1 & periodo==0 & RM==33
tab Ocupado if tratado==1 & periodo==1 & RM==33

tab Ocupado if tratado==1 & periodo==0 & RM==35
tab Ocupado if tratado==1 & periodo==1 & RM==35

tab Ocupado if tratado==1 & periodo==0 & RM==41
tab Ocupado if tratado==1 & periodo==1 & RM==41

tab Ocupado if tratado==1 & periodo==0 & RM==43
tab Ocupado if tratado==1 & periodo==1 & RM==43


*** Porcentagem de ocupados em cada região Metropolitana, para os controles ***

tab Ocupado if tratado==0 & periodo==0 & RM==26
tab Ocupado if tratado==0 & periodo==1 & RM==26

tab Ocupado if tratado==0 & periodo==0 & RM==29
tab Ocupado if tratado==0 & periodo==1 & RM==29

tab Ocupado if tratado==0 & periodo==0 & RM==31
tab Ocupado if tratado==0 & periodo==1 & RM==31

tab Ocupado if tratado==0 & periodo==0 & RM==33
tab Ocupado if tratado==0 & periodo==1 & RM==33

tab Ocupado if tratado==0 & periodo==0 & RM==35
tab Ocupado if tratado==0 & periodo==1 & RM==35

tab Ocupado if tratado==0 & periodo==0 & RM==41
tab Ocupado if tratado==0 & periodo==1 & RM==41

tab Ocupado if tratado==0 & periodo==0 & RM==43
tab Ocupado if tratado==0 & periodo==1 & RM==43

*** Evolução da distribuição de tratados e controle de acordo com a RM ***
tab RM if tratado==1 & periodo==0
tab RM if tratado==1 & periodo==1
tab RM if tratado==0 & periodo==0
tab RM if tratado==0 & periodo==1
