*Limpando a memória
clear

*Indicando tamanho da memória
set mem 100m

*Abrindo o arquivo de log
log using "C:\curso\Caps03-04.log", replace text

*Instalando o módulo do F-test
*http://ideas.repec.org/c/boc/bocode/s456944.html
do "C:\curso\ftest.ado"

************************************
*Exemplo das páginas 137-139
use "C:\curso\mlb1.dta", clear

*lsalary = log do salário total do jogador em 1993
*years = anos do jogador na liga
*gamesyr = média de partidas jogadas por ano
*bavg = média de rebatidas na carreira do jogador
*hrunsyr = rebatidas que redundaram em pontos (home run) por ano
*rbisyr = rebatidas que redundaram em corrida até a próxima base por ano

************************************
*Modelo restrito (pág. 139)
reg lsalary years gamesyr
estimates store modelo1

*Modelo irrestrito (pág. 138)
reg lsalary years gamesyr bavg hrunsyr rbisyr
estimates store modelo2

*Teste de restrições de exclusão
ftest modelo1 modelo2

*H0 é rejeitada, mesmo test-t não sendo significativo
*Há multicolinearidade entre "hrunsyr" e "rbisyr"

*Teste F é útil para testar exclusão de variáveis
*quando essas variáveis são correlacionadas

*Excluindo "rbisyr"
reg lsalary years gamesyr bavg hrunsyr
estimates store modelo3
ftest modelo2 modelo3

*Excluindo "hrunsyr"
reg lsalary years gamesyr bavg rbisyr
estimates store modelo4
ftest modelo2 modelo4

*Excluindo "rbisyr" e "bavg"
reg lsalary years gamesyr hrunsyr
estimates store modelo5
ftest modelo3 modelo5

*Análise fatorial entre "rbisyr" e "hrunsyr"
factor rbisyr hrunsyr
predict fator1
sum fator1
reg lsalary years gamesyr bavg fator1

************************************
*VARIANCE INFLATION FACTOR (VIF)
************************************
*É um fator que estima o aumento da variância,
*devido à multicolinearidade na regressão de MQO.
*Colinearidade aumenta a variância dos betas, ou seja,
*diminui significância estatística (t-teste menor).
*VIF >  5 indica multicolinearidade
*VIF > 10 indica colinearidade que tende à perfeita

*Modelo com multicolinearidade
reg lsalary years gamesyr hrunsyr rbisyr
estat vif

*Sabemos que variância é o erro padrão ao quadrado, então
*VIF de 16,63 de "rbisyr" significa que o erro padrão do
*coeficiente desta variável é 4,08 vezes maior (raiz de 16,63)
*do que se esta variável não fosse correlacionada com
*outras variáveis independentes.

*Modelo sem multicolinearidade
reg lsalary years gamesyr rbisyr
estat vif

************************************
*CRIANDO GRÁFICOS
************************************
*Regressão escolhida
reg lsalary years gamesyr hrunsyr

*Criando variável com média de "years"
gen yearsa=years
egen yearsb=mean(years)
drop years
gen years=yearsb

*Criando variável com média de "gamesyr"
gen gamesyra=gamesyr
egen gamesyrb=mean(gamesyr)
drop gamesyr
gen gamesyr=gamesyrb

*Valor predito com média de "years" e "gamesyr"
predict lsalary1, xb
gen salary1=exp(lsalary1)

*Valor predito com "years" igual a 1 e média de "gamesyr"
drop years
gen years=1
predict lsalary2, xb
gen salary2=exp(lsalary2)

*Valor predito com "years" igual a 10 e média de "gamesyr"
drop years
gen years=10
predict lsalary3, xb
gen salary3=exp(lsalary3)

*Gráfico com valores observados e preditos
twoway (scatter salary hrunsyr) (scatter salary1 hrunsyr) (scatter salary2 hrunsyr) (scatter salary3 hrunsyr)

*Gráfico com valores preditos
twoway (scatter salary1 hrunsyr) (scatter salary2 hrunsyr) (scatter salary3 hrunsyr)

*Voltando "years" ao normal
drop years
gen years=yearsa

*Voltando "gamesyr" ao normal
drop gamesyr
gen gamesyr=gamesyra

************************************
*PNAD 2007 - MINAS GERAIS
************************************
use "C:\curso\pes2007MG.dta", clear

************************************
*SEXO
************************************
*EXPLICAR CATEGORIA DE REFERÊNCIA!!!
gen mulher=.
replace mulher=0 if v0302==2
replace mulher=1 if v0302==4
tab mulher v0302, missing

************************************
*RENDIMENTO
************************************
*Rendimento mensal em dinheiro que recebia normalmente,
*no mês de referência,
*no trabalho principal da semana de referência
sum v9532, detail

*OLHAR DICIONÁRIO DE DADOS!!!
*Recodificando rendimento
gen renpri=.
replace renpri=v9532 if v9532!=999999999999
sum renpri, d
hist renpri

*Criando logaritmo de rendimento
gen lnrenpri=ln(renpri)
hist lnrenpri

************************************
*ANOS DE ESTUDO
************************************
sum v4803, d

*OLHAR DICIONÁRIO DE DADOS!!!
*Recodificando anos de estudo
gen anest=.
replace anest=v4803-1 if v4803!=17
tab v4803 anest, missing

************************************
*IDADE DO MORADOR
************************************
sum v8005, d

*OLHAR DICIONÁRIO DE DADOS!!!
*Recodificando idade do morador
gen idpia=.
replace idpia=v8005 if v8005>=15 & v8005<=64
sum idpia, d

************************************
*PESO DA PESSOA
************************************
sum v4729, d

************************************
*USO DE PESOS NAS TABELAS
************************************
*Tabulação sem peso
tab mulher

*Tabulação com peso populacional
tab mulher [fweight=v4729]

*Tabulação com peso populacional
*Não aconselhável
tab mulher [iweight=v4729]

*Tabulação com peso amostral
tab mulher [aweight=v4729]

*Tentativa de tabulação com peso amostral
*ERRO!!!
tab mulher [pweight=v4729]

************************************
*USO DE PESOS NAS REGRESSÕES
************************************
*Observações na regressão
tab v0101 if lnrenpri!=. & anest!=. & idpia!=. & mulher!=.

*População na regressão
tab v0101 [fweight=v4729] if lnrenpri!=. & anest!=. & idpia!=. & mulher!=.

*Regressão linear múltipla
reg lnrenpri anest idpia mulher

*Regressão linear mútlipla com peso populacional
*ERRO!!!
reg lnrenpri anest idpia mulher [fweight=v4729]

*Regressão linear múltipla com peso amostral
reg lnrenpri anest idpia mulher [pweight=v4729]

************************************
*MODELO SEM CONSTANTE
************************************
*Menores valores são: Anos de estudo(0); Idade(15); Mulher(0)
reg lnrenpri anest idpia mulher [pweight=v4729], nocons

************************************
*SALVANDO O LOG
************************************
log close
