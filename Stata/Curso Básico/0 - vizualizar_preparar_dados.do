******************************************************************************************************
*********** 	ELABORADO PELO ECONS COMO PARTE DA APOSTILA DE INTRODUÇÃO AO STATA       *************
*******************						IGOR VIEIRA PROCÓPIO			******************************
******************************************************************************************************


/*
! "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" https://www.ssc.wisc.edu/sscc/pubs/stat.htm
! "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" http://tutorials.iq.harvard.edu/Stata/StataIntro/StataIntro.html

*/



/* Este do-file apresenta as ferramentas que possibilitam aos usuários darem os primeiros passos no
STATA em direção à analise de dados. Antes de se iniciar a análise propriamente dita, é necessário
conhecer o funcionamento básico do STATA e as ferramentas para visualizar e manipular os dados.

Portanto, este do-file é composto por 7 blocos:

	- visualizar dados
	- excluir variáveis e observações
	- alterar nomes das variáveis, colocar legendas e rótulos
	- tranformar variáveis texto em variável numérica
	- alterar valores das variáveis
	- criar novas variáveis
	- criar variáveis dummy
	
*/



*********************************************************************************************************
*********************                 1º Bloco - Visualizar dados                  **********************
*********************************************************************************************************



**** Definir diretório de trabalho
*cd "C:\0 - IGOR\Softwares\STATA\Curso STATA\Pos graduação 2017\1º Dia\"

**** Carregar o banco1
use "https://igorprocopio.github.io/Datasets/banco1.dta", clear




*** Listar variáveis
list

*** Listar apenas as cinco primeiras observações
list in 1/5

*** Listar as observações de 5 a 10 das variáveis var1, var3 e var7.
list var1 var3 var7 in 5/10

*** Utilizar o comando describe para descrever o banco de dados
describe

*** Descrever resumidamente o banco utilizando a opção short do comando describe.
describe, sh

*** Apresentar uma tabela resumo das variáveis do banco utilizando o comando summarize.
summarize

sum var5

sum var5, detail

sum var5 if var1 == "MG"

sum var5 if var4 == 1

bys var4: sum var5
	
*** O `inspect' provê algumas informações adicionais em relação ao comando summarize, 
*** como número de valores zeros, negativos, positivos, inteiros e não inteiros, número de
*** valores missing e valores únicos

inspect var10

*** O comando unique apresenta o número de valores únicos encontrados em uma variável. Deve ser
*** usado com o número de valores únicos for alto (limitação do comando inspect) Mais utilizado 
*** em dados em painel

ssc install unique
unique var4

*** O comando codebook examina o nome da variável, label, tipo da variável e algumas informações
*** resumidas da variável
codebook var1

codebook var5


*** O comando edit abre o `Data Editor'
edit

edit var1 var5 var8

edit if var1 == "SP"	


misstable summarize


mark nomiss
markout nomiss var10 var12

*********************************************************************************************************
*********************         2º Bloco - Excluir variáveis e observações           **********************
*********************************************************************************************************



**** Carregar o banco2
use "https://igorprocopio.github.io/Datasets/banco2.dta", clear

/*
Excluir do banco de dados variáveis que não serão utilizadas
*/
list

drop var15 var16

/*
Também é possível escolher as variávies que serão mantidas no banco de dados
*/
keep var1 var2 var3 var4 var5 var6 var7 var8 var9 var10 var11 var12 var13 

/*
Excluir do banco de dados observações que não serão utilizadas
*/
drop if var8 == "TT"

/*
Também é possível manter as observações que serão utilizadas
*/
keep if var2 != "0"

*keep if var4 != .


*********************************************************************************************************
**************    3º Bloco - alterar nomes das variáveis, colocar legendas e rótulos   ******************
*********************************************************************************************************

*** Para verificar o atual nome da variável e se ela já possui alguma legenda, basta olhar a janela 
*** 'Variables' ou utilizar o comando describe.
describe

/*
O comando utilizado para modificar o nome da variável é rename que pode ser abreviado por ren. 
A sintaxe do comando é simples, basta digitar ren nome_antigo nome_novo.
Por exemplo, para alterar o nome da variável var1 para renda utiliza-se a seguinte linha de comando: 
*/	

ren var1 uf

/*
Caso seja necessário renomear um grupo de variáveis, utiliza-se o mesmo comando, apenas colocando o grupo de variáveis entre parênteses.
*/
ren (var2 var3 var4 var5 var6 var7 var8 var9 var10 var11 var12 var13) ///
	(renda renda_2 genero idade idade1 idade2 raca componentes rm luz educ pib)

/*
Como é mais prático utilizar nomes curtos para as variáveis, nem sempre é possível deixar claro o significado da variável. 
Acrescentar uma legenda à variável facilita neste sentido. O comando para realizar esta tarefa é o label variable
que pode ser apreviado por lab var. A sintaxe do comando é: label variable 'nome da variável' "legenda".
*/

label variable renda "Renda do Trabalho"
label variable uf "Unidade da Federação"
label variable renda_2 "Renda nominal familiar"
label variable genero "Gênero do indivíduo"
label variable idade "Idade do indivíduo"
label variable idade1 "Idade do indivíduo"
label variable idade2 "Idade do indivíduo"
label variable raca "Raça do indivíduo"
label variable componentes "Número de pessoas na família"
label variable rm "Indicador de Região Metropolitana"
label variable luz "Valor da conta de luz"
label variable educ "Anos de estudo"
label variable pib "PIB municipal"

/* Variáveis categóricas podem ser expressas em formato texto, onde o texto indica o conteúdo da variável, ou pode ser 
expressa em formato numérico, onde cada número representa uma categoria.
Quando a variável estiver em formato texto, espera-se que o texto seja autoinformativo para identificar a categoria. 
Já no formato numérico, é preciso que se tenha um dicionário dos dados para
que se identifique qual categoria cada número representa. Como exemplo, vamos analisar as variáveis uf e gênero.
*/
codebook uf
codebook genero

/*
É possível notar que a variável uf possui três categorias e que o valor de cada categoria está expresso em formato texto, representando a sigla dos Estados.
Já a variável genero possui duas categorias e está em formato numérico. Os valores das categorias são 1 e 2. Caso não se tenha o dicionário dos dados em mãos
não é possível saber o que cada categoria representa. Para evitar que se tenha que sempre ficar olhando para o dicionário, é possível cria um rótulo 
para cada categoria, informando o que cada número representa. 
Para atribuir um rótulo em uma variável no Stata são realizadas duas etapas. A primeira etapa consiste em criar o rótulo e a segunda etapa em atribuir 
este rótulo a uma variável específica. Vamos criar um rótulo indicando o conteúdo da variável genero. O código 1 representa homens enquanto que o 
código 2 representa mulheres. Para criar um rótulo utiliza-se o comando label define. A sintaxe do comando é label define 'nome do rótulo' 'especificação do rótulo'.
*/
label define gen 1 "Homem" 2 "Mulher"

/*
Após criar o rótulo, o próximo passo é atribuir este rótulo à variável genero. Para isso utiliza-se o comando label values com seguinte sintaxe: 
label values 'nome da variável' 'nome do rótulo'.
*/
label values genero gen

numlabel,add

/*
Para verificar o resultado desse procedimento aplica-se novamente o comando codebook na variável genero. 
*/
codebook genero

/*
Nota-se que ao lado do valor da variável foi acrescentada uma nova coluna com o rótulo da variável, indicando o conteúdo de cada categoria. 
*/



*********************************************************************************************************
**************       4º Bloco - Tranformar variáveis texto em variável numérica        ******************
*********************************************************************************************************


/*
Esta seção mostra como transformar variáveis armazenadas em formato texto para formato numério. Obviamente, para realizar
esta transformação, a variável precisa possuir um conteúdo numérico, e ou foi armazenda de forma errada ou possui juntamente
com o conteúdo numérico caracteres que podem ser eliminados sem perda de informação relevante.
A variável renda no banco de dados está em formato texto, apesar de ter todos os seus caracteres
numéricos. Esta a forma mais simples de utilizar o comando destring. Vamos utilizá-lo de duas maneirais; 
i) criando uma nova variável; e ii) substituindo o formato na própria variável.
*/

list renda

codebook renda

destring renda, gen(renda10)

list renda renda1

destring renda, replace

list renda renda1

/*
Dado que o conteúdo e o formato das variáveis renda e renda1 são idênticos, podemos excluir uma 
das duas.
*/
drop renda1

/*
A variável renda_2 possui algumas observações com caracteres não numéricos. No entanto, estes 
caracteres indicam que a pessoa não tem informação para esta variável, portanto, deve ser transformada em 
missing.
*/
list renda_2

/*
Se o comando for utilizado conforme o exemplo acima, o Stata retornará uma informação de erro: renda_2 
contains nonnumeric characters; no replace. Se acrescentarmos a opção force as observações com caracteres 
não numéricos serão transformadas em missing.
*/
destring renda_2, replace

destring renda_2, replace force

/*
A variável luz que representa o valor pago na conta de luz começa com R$. Se tentarmos utilizar 
o comando destring como no exemplo 1, o Stata retornara a mensagem que não a variável possui caracteres 
não numéricos, e não irá alterar a variável. Se tentarmos utilizar a opção force, como existem caracteres não 
numéricos em todas as observações, todas serão transformadas em missing. Para retirar o R$ e manter 
corretamente os valores numéricos, utiliza-se o opção ignore(R$). No nosso exemplo, além deste problema, a 
variável não está no formato Americano, ou seja, a separação de casa decimal está com vírgula, portanto 
vamos acrescentar a opção dpcomma ao final do comando.
*/

destring luz, replace ignore("R$") dpcomma



*********************************************************************************************************
*********************          5º Bloco - Alterar valores das variáveis           ***********************
*********************************************************************************************************


/*
A variável componentes possui informações com o valor 99. No entanto, este valor indica que esta 
informação não foi preenchida para a respectiva observação. Para evitar problemas com o uso deste valor 
de forma desavisada, vamos substituir este valor por missing. Um dos comandos utilizados para alterar
valores de variáveis é o comando replace.
*/
replace componentes = . if componentes == 99

/*
A primeira observação da variável raca possui apenas a letra B como informação. Esta letra indica a 
raça Branco, no entanto, para padronizar as informações da variável, substituiremos a letra B pela 
palavra BRANCO utilizando o comando abaixo:
*/
replace raca = "BRANCO" if raca == "B"

/*
Podemos usar o comando replace para transformar uma variável contínua em uma variável 
categórica. Imagine que precisemos transformar a variável de idade em uma variável representado alguns 
grupos de idade. Quem tiver 18 anos ou menos de idade irá participar do grupo 1, quem tiver entre 19 e 30 
(inclusive) faz parte *do grupo 2, entre 31 e 50 (inclusive) grupo3, entre 51 e 65 (inclusive) grupo 4 e mais de 65 
grupo 5.  Para isso utilizaremos cinco linhas de comando conforme abaixo:
*/

replace idade2 = 1 if idade2 >=0   & idade2 <= 18
replace idade2 = 2 if idade2 >=19 & idade2 <= 30
replace idade2 = 3 if idade2 >=31 & idade2 <= 50
replace idade2 = 4 if idade2 >=51 & idade2 <= 65
replace idade2 = 5 if idade2 >=66

/*
Outro comando que pode ser utilizado para alterar valores de variáveis é o comando recode.
A variável rm (Região Metropolitana) deveria possuir apenas os códigos 0 e 1, indicando se o
indivíduo vive em uma Região Metropolitana ou não. No entanto, a variável possui uma observação com o 
código 3  e uma com o código 99. Estes valores indicam erro na resposta da variável, e devem ser substituídos por missing.
*/
recode rm (3 99 = .)

/*
Repetir o exemplo do comando replace. Com o comando recode, é possível fazer o mesmo que 
foi feito com o comando replace em apenas uma linha de comando. Como a variável idade já foi modificada, 
realize o procedimento na variável idade1.
*/

recode idade1 (0/18 = 1) (19/30 = 2) (31/50 = 3) (51/65 = 4) (66/max = 5)



*********************************************************************************************************
*************************          6º Bloco - criar novas variáveis               ***********************
*********************************************************************************************************



**** Carregar o banco1
use "https://igorprocopio.github.io/Datasets/banco3.dta", clear


/*
Muitas vezes em pesquisas empíricas é preciso criar variáveis no banco de dados a partir de variáveis já existentes.
Os principais comandos para criar variáveis no Stata são o gen e o egen>. 
Um tipo muito utilizado de variáveis, principalmente em análises de regressão, é a variável dummy. Este tipo de variável
é tratado em um tópico em separado.
Vamos novamente utilizar um banco de dados fictício como base para este tópico. Antes de criar as variáveis,
vamos visualizar o banco de dados e imaginar que tipo de variáveis podem ser criadas. Para visualizar o banco 
pode-se utilizar qualquer dos procedimentos listados no tópico sobre visualização dos dados. Vamos utilizar o comando
list.
*/
list
/*
 Utilizando estas variáveis, primeiro será mostrado o uso do comando gen. A sintaxe básica do comando é: gen 'nome da variável' = 'expressão'.
É possível criar novas variáveis a partir de variáveis texto ou numéricas. 
Vamos primeiro ver alguns exemplos de variáveis numéricas. As variáveis luz e agua representam os valores de conta de água e luz dos domicílios, vamos criar
uma variável chamada conta, que representa a soma dos gastos com água e luz.

*/
gen conta = luz + agua
/*
É importante se ter em mente uma característica deste tipo de soma de variáveis. Quando uma observação possui valor missing em uma das variáveis, o valor da soma também é
missing, mesmo se a outra variável tiver algum valor diferente de missing. É possível fazer com que a soma seja efetuada, fazendo com o que o valor total seja igual ao valor
da variável não missing. Para isso é preciso o comando egen com a função rowtotal conforme será visto mais abaixo. Para ficar claro a limitação desse tipo de soma
é interessante visualizar os dados, utilizando para isso o comando list.
*/

list luz agua conta

/*
Outra possibilidade é dividir uma variável por outra. Como exemplo cria-se a variável per_capita que vai representar a renda per capita do domicílio, ou seja, a divisão da renda
total do domicílio (renda_2 pelo número de componentes (componentes). 
*/
gen per_capita = renda_2 / componentes

/*
Também é possível criar uma variável elevando outra à determinada potência. Basta usar o sinal de acento circunflexo como será mostrado no próximo exemplo. Neste exemplo
é criado uma variável representando a idade ao quadrado, muito utilizado em análises econométricas.    
*/
gen ida2 = idade^2
/*
 O comando gen permite que se crie variáveis com a utilização de funções mais complexas, como por exemplo com o uso de logaritimos. Vamos mostrar como
criar uma variável utilizar o logaritimo neperiano e o logaritimo na base 10.
*/

gen lnrenda = ln(renda)
gen logrenda = log10(renda)

/*
O comando gen também permite criar variáveis texto a partir de outras variáveis texto. Para concatenar duas variáveis, 
basta utilizar o operador de soma
como se tivesse somando as duas variáveis. Como exemplo vamos utilizar uma concatenação das variáveis mes e ano.
*/

gen data = mes + ano
/*
 Para visualizar o resultado vamos usar o comando list.
*/
list mes ano data
/*
Note que a concatenação foi realizada de forma correta, no entanto, é possível fazer melhor. É possível fazer com a nova 
variável contenha um espaço entre as informações de mês e ano. É possível ainda, acrescentar a preposição "de". 
Para isso, basta acrescentar entre as variáveis a informação que queremos acrescentar dentro de aspas duplas, conforme o exemplo abaixo.
*/
gen data1 = mes + " de " + ano

list data1
/*
É possível também fazer o processo inverso,ou seja, separar uma variável texto em mais de uma parte. O comando split
permite separar a variável de acordo com uma regra especificada. Vamos voltar a variável data1 para duas variáveis, mês e ano. Para
isso define-se a palavra de como regra de separação da variável..
*/
split data1, parse("de")

list data*

/*
Outra possibilidade é extrair parte de uma variável texto. Imagine que se queira ter uma abreviação do nome do mês, contendo
apenas os três primeiros caracteres. Utiliza-se o comando substr juntamente com o comando gen.
*/
gen mes_abr = substr(mes,1,3)

/*
 O comando egen possui um maior número de funções vinculadas a ele para a criação de novas variáveis. 
Vamos mostrar alguns exemplos para ilustrar a funcionalidade e 
a forma de se utilizar este comando. Para conhecer todas as funções basta entrar no help do comando.
Os dois primeiros exemplos a serem mostrado são com o uso da função max, que calcula o máximo de determinada variável.
 O primeiro exemplo cria uma variável constante representado a renda máxima da população. Já o segundo exemplo cria a 
 renda máxima por raça do indivíduo. Para isso, acrescenta-se ao comando do primeiro exemplo o prefixo by.
*/

egen renda_max = max( renda)

by raca, sort: egen renda_raca = max(renda)  
/*
A função group realiza uma combinação das categorias de duas ou mais variáveis. Pode ser utilazada em variáveis texto e/ou numéricas.  Como exemplo, vamos criar um grupo que indica
simulataneamente a condição de gênero e raça do indivíduo.
*/

egen grupo = group(genero raca), label
codebook grupo
/*
A função rowtotal funciona de forma parecida com a soma de variáveis com o uso do comando gen. A principal diferença é no tratamento de observações missing em uma das variáveis.
Lembre que no comando gen quando existia uma observação missing em uma das variáveis o resultado da soma era missing, mesmo quando o conteúdo da outra variável era diferente de 
missing. Vamos utilizar como exemplo as mesmas variáveis do caso da soma de variáveis, ou seja, luz e agua. 
*/

egen total = rowtotal(agua luz)
/*
Para visualizar a diferença entre os dois procedimentos vamos listar os dois resultados
*/
list agua luz conta total
/*
O útlimo exemplo deste tópico vai utilizar um outro comando, o recode. O comando recode para alterar o conteúdo da variável ou criar uma nova variável através de uma
regra especificada. Vamos mostrar um exemplo criando uma variável categórica a partir de uma variável contínua. Vamos criar uma nova variável representando grupos de idade. Quem tiver 18 anos ou menos de idade irá 
participar do grupo 1, quem tiver entre 19 e 30 (inclusive) faz parte do grupo 2, entre 31 e 50  (inclusive) grupo3, 
entre 51 e 65 (inclusive) grupo 4 e mais de 65 grupo 5.
*/

recode idade (0/18 = 1) (19/30 = 2) (31/50 = 3) (51/65 = 4) (66/max = 5), gen(idade_grupo)

list idade idade_grupo


pctile conta4 = total, nquantiles(4)

xtile conta_4 = total, nquantiles(4)


*********************************************************************************************************
*************************          7º Bloco - criar variáveis dummy               ***********************
*********************************************************************************************************


/*
Variáveis dummy são variáveis binárias (0 ou 1) em que o valor 1 indica que a observação atende à determinada característica e 0 que não atende. Devido ao seu grande uso em trabalhos
empíricos, este tópico trata exclusivamente da criação de variáveis dummy. Existem diversas formas de construir uma variável dummy no Stata. A melhor forma a ser utilizada
depende das características das variáveis. Vamos mostrar alguns exemplos.
 O primeiro exemplo será criar dummies de gênero usando o comando gen. Vamos criar 
duas variáveis, uma para indicar se a pessoa é do sexo masculino e outra para indicar que a pessoa é do sexo feminino. Antes de criar a variável, é preciso visualizar a variável genero.
Vamos utilizar o comando codebook.
*/


gen caro = agua >=30
list caro agua
drop caro

inspect agua
gen caro = agua >=30 if !missing(agua)
list caro agua


replace raca = "" in -1

gen tratado = idade>= 18 & raca == "BRANCO" if !missing(idade) & !missing(raca)
drop tratado


*gen tratado = idade>= 18 & raca == "BRANCO" if !missing(idade) & raca !=""

/*
Uma outra maneira de criar variáveis dummy no Stata é com o uso do comando tab com a opção gen. O comando tab é visto em mais detalhes na parte 
de análise de dados, no momento basta saber que o comando lista a frequeência de todas as categorias de determinada variável. E com a opção gen, o comando cria uma variável dummy 
para cada categoria. Essa opção é muito útil quando a variável tiver mais de 2 categorias e o objetivo for criar uma dummy para cada uma das categorias. Como exemplo vamos criar uma
dummy para cada categoria da varíável raca. A sintaxe do comando é simples, basta digitar: tab 'variável', gen('prefixo da nova variável').
*/
tab raca, g(draca)

/*
Note que foram criadas três variáveis, uma para cada categoria de raça existente no banco de dados, sendo que as variáveis possuem o prefixo determinado no comando (draca) acrescido de um 
número sequencial.
*/
list raca draca1 draca2 draca3


