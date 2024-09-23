***Vamos iniciar estimando um modelo para explicar o n�vel de atividade econ�mica das 27 UF em fun��o do Capital Humano (KH)
***Inicialmente deve-se reconhecer as unidades de se��o cruzada e de s�rie de tempo. Isso � feito pelo comando "xtset"

xtset uf ano

***uf � a unidade de s�rie de tempo e ano a vari�vel de tempo. O comando solta a seguinte informa��o

panel variable:  uf (strongly balanced)
        time variable:  ano, 2006 to 2010
                delta:  1 unit

***Vamos gerar o logaritmo natural do pib e do kh

gen lpib=ln(pib)
gen lkh=ln(kh)

*** Antes de estimar o modelo � interessante avaliar o desempenho do PIB para as 27 unidades da federa��o ao longo do tempo.
***O comando "xtline mostra isso.

xtline lpib

*** O mesmo pode ser feito para kh

xtline kh

***Pode-se plotar a atividade econ�mica de cada estado ao longo do tempo em um mesmo gr�fico isso pode ser feito pelo comando apresentado a seguir

xtline lpib, overlay legend(off)

***Perce-se que o estado de S�o Paulo se destaca dos demais. O mesmo pode ser feito para capital humano

xtline kh, overlay legend(off)

***Para analisar o ocmportamento, separadamente, da atividade econ�mica de cada estado por regi�o pode ser digitado o seguinte comando

graph twoway scatter lpib ano || lfit lpib ano, by(regiao)

*** O comando a seguir permite que seja calculado a m�dia da atividade econ�mica em cada regi�o

tabstat lpib, by(regiao)

***Os resultados s�o apresentados a seguir:

Summary for variables: lpib
     by categories of: regiao 

  regiao |      mean
---------+----------
       1 |  16.70125
       2 |  17.51831
       3 |  18.07363
       4 |  19.58118
       5 |  19.03959
---------+----------
   Total |  17.84607
--------------------

. 
end of do-file

***A atividade Econ�mica e o KH podem variar ao longo do tempo e entre os individuos. A varia��o ao longo do tempo para um mesmo estado 
***� chamada de within variance. A varia��o entre os estados � chamada de between variance. No modelo de efeitos fixos o coeficiente de
*** regressores com baixa within variance ser� imprecisamente estimado. Isso faz com que as distin��es entre as varia��es seja
*** fundamental para a defini��o do melhor modelo
***A within variance pode ser definida graficamente como

preserve
xtdata, fe
graph twoway scatter lpib ano || lfit lpib ano
restore

***A between variance pode ser definida graficamente como

preserve
xtdata, be
graph twoway scatter lpib ano || lfit lpib ano
restore

***A tabela a seguir nos possibilita verificar se h� causas externas de atividade econ�mica

tabstat lpib, by(estado)

***Vamos apresentar a decomposi��o da vari�ncia para cada uma das vari�veis

xtsum uf ano lpib lkh

Variable         |      Mean   Std. Dev.       Min        Max |    Observations
-----------------+--------------------------------------------+----------------
uf       overall |        14    7.81789          1         27 |     N =     135
         between |             7.937254          1         27 |     n =      27
         within  |                    0         14         14 |     T =       5
                 |                                            |
ano      overall |      2008   1.419481       2006       2010 |     N =     135
         between |                    0       2008       2008 |     n =      27
         within  |             1.419481       2006       2010 |     T =       5
                 |                                            |
lpib     overall |  17.84607   1.265738   15.42636   20.94448 |     N =     135
         between |             1.283222   15.52736   20.85085 |     n =      27
         within  |             .0677255    17.6941   18.00745 |     T =       5
                 |                                            |
lkh      overall | -.3996631   .1350297  -.7271177  -.0895965 |     N =     135
         between |              .124402   -.616104  -.1317052 |     n =      27
         within  |             .0567374  -.5401799  -.2884026 |     T =       5

. 
end of do-file

***Mesmo com a menor within variance n�o � poss�vel afirmar que o modelo de EF seja menos eficiente
***Estimando agora os modelos. Inicialmente testanto entre o pooled e o modelo de EF

xtreg lpib lkh, fe

**************************************************************************************************
Fixed-effects (within) regression               Number of obs      =       135
Group variable: uf                              Number of groups   =        27

R-sq:  within  = 0.7803                         Obs per group: min =         5
       between = 0.3824                                        avg =       5.0
       overall = 0.3367                                        max =         5

                                                F(1,107)           =    380.10
corr(u_i, Xb)  = 0.4982                         Prob > F           =    0.0000

------------------------------------------------------------------------------
        lpib |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
         lkh |   1.054441   .0540845    19.50   0.000     .9472252    1.161658
       _cons |   18.26749   .0218307   836.78   0.000     18.22422    18.31077
-------------+----------------------------------------------------------------
     sigma_u |  1.2065155
     sigma_e |  .03552179
         rho |  .99913394   (fraction of variance due to u_i)
------------------------------------------------------------------------------
F test that all u_i=0:     F(26, 107) =  4336.69             Prob > F = 0.0000

. 
end of do-file

***os diferentes R2 definem como ocorre o ajustamento dentro das unidades de se��o cruzada (estados), entre as unidades
*** e no geral. Os termos sigma_u e sigma_e medem, respectivamente, os erros-padr�o dos componentes n�o observados (alfa)
*** e do termo de erro ale�rio. Rho mede o percentual da vari�ncia total que corresponde � varia��o dos fatores n�o observados.
***Agora testando entre Pooled e EA

qui xtreg lpib lkh, re
xttest0

***Agora testatndo entre EA e EF

qui xtreg lpib lkh, fe
estimates store fe
qui xtreg lpib lkh, re
estimates store re
hausman fe re, sigmamore

***O pr�ximo passo � avaliar a depend�ncia de se��o cruzada

xtcsd, pesaran abs

***Na sequencia deve-se testar a heteroced�sticidade em grupo

qui xtreg lpib lkh, fe
xttest3

***Testando a autocorrela��o serial

xtserial lpib lkh

***O pr�ximo passo � estimar os efeitos fixos

xtreg lpib lkh, fe vce(robust)
predict fe_uf, u 
list fe_uf

***A principal utilidade da modelagem de dados em painel � permitir que sejam analisadas as diferen�as que, por ventura,
***ocorram entre as unidades da federa��o. Podemos analisar a diferen�a na atividade econ�mica de cada um dos estados ao
*** longo do tempo com base na compara��o dos par�metros que seriam estimados caso fosse elaborada uma regress�o para cada um deles.

preserve
statsby, by(uf) clear: xtreg lpib lkh, fe vce(robust)
list, clean
restore

***Para visualizar melhor vamos repetir o comando com a vari�vel estado

preserve
statsby, by(estado) clear: xtreg lpib lkh,fe vce(robust)
list, clean
restore

***Agora podemos plotar um gr�fico considerando os efeitos fixos para cada estado. Inicialmente � necess�rio estimar os valores
*** previstos tendo como base o modelo proposto. Posteriormente, soma-se os valores previstos aos efeitos fixos, plotando o 
***grafico da vari�vel derivada desse procedimento.

qui xtreg lpib lkh, fe vce(robust)
predict lpib_fe

gen lpib_fef = lpib_fe + fe_uf

xtline lpib_fef, overlay legend(off) saving(lpib_fef, replace)

graph twoway scatter lpib_fef ano || lfit lpib_fef ano, by(estado)

