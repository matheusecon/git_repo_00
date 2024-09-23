***AULA PRATICA 1 (ECO 450)***

***O próximo passo é recodificar as variáveis. A variável cor, por exemplo, 
*** assume valor 2 para branco, 4 preto, 6 amarelo, 8 parda, 0 indigena e 9 sem declaração.
***Para isso é utilizado o comando "replace"***

replace cor=1 if cor==2
replace cor=0 if (cor==4 | cor==6 | cor==8 | cor==0 | cor==9)
replace ref=0 if (ref==2 | ref==3 | ref==4 | ref==5 | ref==6 | ref==7 | ref==8)

***Para a variável sexo vamos definir 1 como sendo do sexo masculino e 0 como sendo do sexo feminino***

replace sexo=1 if sexo==2
replace sexo=0 if sexo==4

*** Com isso podemos trabalhar com brancos e não brancos pessoas de referência e não-referência***
***O comando | indica "ou"***

***os dados agora estão prontos para serem utilizados***

 save "C:\Documents and Settings\Chico\Meus documentos\Exrcicio1_450_total.dta"


***Agora vamos trabalhar para demostrar a relação que há entre a renda proveniente do trabalho principal com a escolaridade
*** do chefe de familia. Para isso, é interessante dropar todas as observações dos individuos que não são considerados 
*** as pessoas de referencia nas famílias***

drop if ref==0

***É imprtante trabalhar em um intervalo de observações que façam parte da realidade. Vamos limitar o intervalo de renda
***proveniente do trabalho principal a (R$400,00;R$20.000,000***

drop if renda_prin<=400

drop if renda_prin>=20000

***Vamos inicialmente solicitar um sumário das estatisticas das variáveis analisadas. o comando "sum se encarrega disso***

sum renda_prin estudo

***O comando "sum" pode ser realizado solicitando alguns detalhes***

sum renda_prin estudo, detail

***Nós podemso solicitar estatiticas descritivas especificando as estaticas desejadas. Isso é feito pelo comando "tab"***

 tabstat renda_prin, stats (mean sd n min max)
 
 ***o comando "tab" isoladamente nos fornece a frequencia das observações***
 
 tab renda_prin
 
 *** Vamos agora gerar uma nova variável. A equação minceriana de rendimento relaciona o nível educacional dos individuos com
 *** o logaritmo natural de sua renda.
 
 gen lrp = ln(renda_prin)
 
 ***Nós também podemos plotar gráficos contendo as observações da amostra. Vamos começar com
 ***gráficos de dispersão. O comando "twoway scatter" se encarrega disso.***
 
 twoway scatter renda_prin estudo
 
 ***A combinação do gráfico de dispersão com o e tendência linear pode ser analisado utilizando
 ***o comando lfit.***
 
 twoway scatter lrp estudo || lfit lrp estudo
 
 ***Vamos agora estimar a correlação entre o logaritmo da renda principal e os anos de estudo***
 
 pwcorr lrp estudo, sig
 
 ***A função de regressão, representando a equação minceriana, pode ser estimado pelo comando "reg"***
 
 reg lrp estudo
 
 reg renda_prin estudo
 
 ***Os efeitos marginais e as elasticidades podem ser definidos pelos comandos "mfx" e "mfx compute, eyex.
 *** os efeitos marginais podem ser solicitados para o ponto médio da amostra ou para um deteminado ponto específico***
 *** no caso do ponto médio basta dar o seguinte comando***
 
 mfx
 
 ***para especificar um determinado ponto é nessário o seguinte comando***
 
 mfx, at(estudo=15)
 
 ***O comando de efeito marginal pode ser dado para um intervalo da amostra***
 
 mfx if estudo<11
 
 mfx compute, eyex
 
 mfx compute, eyex at(estudo=15)
 
 *** no caso da elasticidade tem-se. Para o caso de formas funcionais não lineares pode-se especificar
 ***as formas funcionais via barra de menus. Basta ir em: Statistics>Postestimation>Marginal effects> 
 ***e fazer a escolha da forma funcional adequada***
 
 *** Vamos agora proceder com a estmação do logaritmo da renda principal e dos resíduos da regressão***
 
 predict lrpf, xb
 
 predict residuo, residuals
 
 ***Vamos agora plotar o grafico de dispersão das observações juntamente com a reta de regressão estimada
 ***O comando é o "twoway (scatter lrp estudo) (line estimat estudo, sort)"***

twoway (scatter lrp estudo) (line lrpf estudo, sort)
 
