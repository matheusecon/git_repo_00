****************************************************************************************************************
***************************************** AULA 05 - MONITORIA STATA ********************************************
****************************************************************************************************************

******************************** Modelagem em Painel - Comandos Básicos ****************************************
****************************************************************************************************************

clear all
cap log close
set dp comma
set more off

cd "C:\Users\Matheus\Desktop"
use mus08psidextract.dta, clear

/*
DADOS EM PAINEL

Dados em painel possuem informação tanto em termos de observações (cross-section) quanto em termos de tempo. Por 
esse motivo, os comandos utilizados devem levar em consideração esta característica, e os estimadores de painel
tentam captar todas essas informações para gerar estimativas e parâmetros mais consistentes e eficientes/precisos.

MODELO POOLED: é o modelo mais básico de painel. Com ele, consideramos as observações e os períodos de tempo
			independentes entre si. Tomamos uma constante comum, não permitindo para um efeito fixo específico de
			indivíduo. 
MODELO DE EFEITOS FIXOS E ALEATÓRIOS: são modelos em que se permitem haver certa heteogeneidade entre observações.
			Dessa forma, temos um intercepto único para cada indivíduo. No caso de EF, consideramos que este 
			intercepto é formado por uma constante mais um termo aleatório invariante no tempo. Através de 
			estimadores que tratem esse efeito fixo, conseguimos estimar o modelo sem demais problemas. Já no caso 
			de RE, postulamos certas premissas sobre a distribuição desse intercepto e estimamos por outros meios.


O comando básico para estimações com painel é o 'xtreg'. Porém, antes de iniciarmos quaisquer trabalhos em dados 
de painel, precisamos declarar os identificadores de indivíduo e tempo da seguinte forma:
*/

* Declarando os dados em painel
xtset id t, yearly
*** se quiser outro periodo de tempo o yearly deve ser trocado.

***********************************************************************************************
********************************* ANÁLISE DOS DADOS *******************************************

* Estudando a base
sum
des

/* Boa parte dos comandos 'xt' do Stata requerem que o formato da base seja o formato 'long', com cada linha sendo 
um conjunto indivíduo-tempo. Se cada linha for um indivíduo com info sobre todos os anos (formato 'wide'), então
precisaremos ajustar a base para o formato 'long' com o comando 'reshape'
*/

* Descrição específica do painel
xtdescribe

* Este último comando nos fornece a info sobre o balanceamento do painel

* Preservando a base (fazendo uma cópia-backup da base na memória)
preserve

* Restaurando a base (salva na memória com o comando 'preserve')
* IMPORTANTE: Os comandos 'preserve' ... 'restore'  precisam ser aplicados juntos (ao mesmo tempo), 
* do contrário, o Stata não preservará a base de dados. Assim, precisamos selecionar todo o bloco
* de comandos entre estes dois e rodar tudo de uma vez só
restore

xtdescribe

/* Variações Within e Between
Os dados em painel podem variar tanto no tempo quanto nas observações
As variações no tempo são conhecidas como variações 'WITHIN'
AS variações nas observações são conhecidas como variações 'BETWEEN'

Estas duas formas de variações são importantes porque ditam a consistência  ou precisão dos estimadores
*/

* Analisando as variações within e between dos dados
xtsum

/*
Um efeito 'within' é uma medida de quanto um indivíduo em sua amostra tende a mudar (ou variar) ao longo do tempo. 
Em outras palavras, é a média da alteração para o caso individual médio em sua amostra.

Um efeito 'between', por contraste, examina as diferenças entre os indivíduos.

* Atenção: Regressores invariantes no tempo têm variação 'within' igual a zero
* Atenção: Regressores invariantes nas observações têm variação 'between' igual a zero
*/


* Outra forma de estudarmos as variações no tempo e no cross-section é com o comando 'xttab'
xttab south
* No entanto, este comando é mais útil quando a variável (south) assume poucos valores possíveis
* Exemplo de variável com variação within zero:
xttab ed

* O comando 'xttrans' informa as "probabilidades de transição" entre um valor e outro
xttrans  south


***********************************************************************************************
********************************* MODELAGEM ECONOMÉTRICA **************************************

* Modelo Pooled OLS controlado para cluster de indivíduo
reg lwage exp exp2 wks ed, cluster(id)

/* Lembrando que para aceitarmos uma modelagem por POOLED OLS, temos de assumir que as observações são
independentes entre indivíduos e entre períodos distintos de tempo. 
Este modelo utiliza-se tanto de variações 'within' quanto de variações 'between'
*/

/* Uso de operadores de Lag e Diferença
No Stata, podemos definir lags de variáveis com o operador 'L.' ('L ponto'). Assim, se quisermos incluir
no modelo alguma defasagem de alguma variável explicativa, podemos simplesmente fazer L.X para criarmos 
a variável X em (t-1). Se quisermos dois lags de tempo, podemos fazer com L2.X
De forma semelhante, podemos trabalhar com o operador diferença: D.X para criarmos (X - L.X) de primeira
diferença, ou então D2.X para criarmos a segunda diferença da variável X
*/

* Medindo a autocorrelação do modelo
quietly reg lwage exp exp2 wks ed, cluster(id)
predict uhat, residuals
forvalues j = 1/6 {
	quietly corr uhat L`j'.uhat
	display "Autocorrelação no lag `j' = " %6.3f r(rho)
}
*

* Modelo de Efeitos Fixos (com estimador 'wihtin')
xtreg lwage exp exp2 wks ed, fe cluster(id)

* Neste caso, somente as variações 'within' estão sendo utilizadas no modelo
* Este estimador é consistente se houver a presença de Efeitos Fixos

* Estimador Between
* Podemos estimar um modelo usando apenas as variações 'between', colocando 'be' como opção no lugar de 'fe'.
* No entanto, este esimador nos gerará info próximas de um OLS, e  perderemos info de variáveis invariantes 
* no indivíduo (e.g. dummies de tempo). Esta opção é raramente utilizada.

* Modelo de Efeitos Aleatórios
xtreg lwage exp exp2 wks ed, re cluster(id) theta

* Neste caso, as variações 'within' e algumas 'between'  estão sendo utilizadas no modelo
* Este estimador é consistente se houver o modelo de Efeitos Aleatórios for correto

/*
Algumas informações:

sigma_u é o desvio-padrão do efeito fixo de indivíduo
sigma_e é o desvio-padrão do erro idiossincrático
rho fornece info sobre a correlação intra-classe do erro 
theta fornece a estimativa do theta_hat (que é igual a 0 se for OLS, igual a 1 se for 'within', e entre 0 e 1
se theta for uma mistura de ambos os estiamdores 'within' e 'between'. Aqui, theta é a ponderação.

*/

* Comparações 

* Criando uma variável global para "alocar" todas as variáveis independentes
global xlist exp exp2 wks ed
* Estimando por OLS (Pooled)
qui reg lwage $xlist, vce(cluster id)
estimates store ols01
* Estimando por Between
qui xtreg lwage $xlist, be
estimates store between01
* Estimando por Efeitos Fixos
qui xtreg lwage $xlist, fe 
estimates store fixed01
* Estimando por Efeitos Aleatórios
qui xtreg lwage $xlist, re 
estimates store random01

estimates table ols01 between01 fixed01 random01, b se stats(N r2 r2_o r2_b r2_w sigma_u sigma_e rho) b(%7.4f) 


* Segunda opção de Tabela (com asterisco para indicar significância)
* Atenção: esta opção não permite mostrar o desvio-padrão junto
estimates table ols01 between01 fixed01 random01, b stats(N r2 r2_o r2_b r2_w sigma_u sigma_e rho) b(%7.4f) star(0.10 0.05 0.01) 

* Teste de Hausman para Efeitos Fixos
hausman fixed01 random01, sigmamore
* Neste caso, o resultado indica forte rejeição da hipórtese nula: os coeficientes são distintos e, portanto
* é necessário considerar o efeito fixo (modelo RE é inconsistente)


