***Para estimar a equação Minceria, que define os fatores importantes para 
***explicar os rendimentos do trabalho, foi utilizado os dados da PNAD 2014. 
*** Nesse caso, não levou-se em consideração o fato da amostra ser complexa pelo
*** fato de isso ainda não fazer parte do conteúdo do curso. O rendimentos do 
***trabalho (renda_prin) foram regredidos em função do número de anos de estudo
*** (estudo), do sexo (sexo), da experiência (idade e idade2) e da cor (cor) dos 
***indivíduos. Inicialmente estimou-se a regressão:

reg renda_prin estudo sexo cor idade idade2 if idade>=18 & idade<=65 & renda_prin>=800 & renda_prin<=20000

***Os comandos if idade>=18 & idade<=65 & renda_prin>=800 & renda_prin<=20000,
*** servem para delimitar os intervalos de idade e renda utilizados na 
***estimação. Eles poderiam não ser utilizados.
***Na sequência foi analisada a presença de multicolinearidade. Para isso,
*** utilizou-se a matriz de autocorrelações simples e o Fator de Inflacionamento
*** de Variância (VIF).

pwcorr estudo sexo cor idade idade2

estat vif

***Correlações superiores a |0,70| e significativamente maiores do que zero e
*** VIF maiores do que 10 indicariam multicolinearidade. Os resultados apontam 
***para ausência de Multicolinearidade. O próximo passo é analisar a presença
*** de heterocedásticidade. O teste de Breusch-Pagan é apresentado a seguir
*** (cuja hipótese nula é ausência de Heterocedásticidade ou erros homocedásticos).

hettest

***Como visto, deve-se rejeitar a hipótese nula o que indica que os erros são
*** heterocedásticos. O modelo deve então ser estimado obtendo erros padrão 
***robustos a heterocedásticidade. O modelo a ser analisado é apresentado a seguir:

reg renda_prin estudo sexo cor idade idade2 if idade>=18 & idade<=65 & renda_prin>=800 & renda_prin<=20000, vce(robust)

***O comando vce(robust) gera erros robustos a heterocedásticidade. Perceba que
*** os parâmetros estimados são os mesmos do modelo anterior, mas os
*** erros-padrão se alteram para poder trabalhar com resíduos heterocedásticos.
	
***Podemos estimar as elasticidades no ponto médio da amostra ou em um ponto
*** específico, por exemplo, quando todas as demais variáveis são definidas:

mfx compute, eyex at(mean)

***Perceba que para indivíduos que estão no ponto médio da amostra sua renda
*** proveniente do trabalho principal é de R$2.201,34 e que o aumento de 1% 
***nos anos de estudo eleva sua renda em 0,87%. Admita um homem (sexo=1),
*** branco (cor=1) que tenha 50 anos de idade (idade2=2500) e 18 anos de estudo.

mfx compute, eyex at(sexo=1 cor=1 idade=50 idade2=2500 estudo=18)

***Perceba que a renda estimada para este individuo é de R$4265,98 e que um
*** aumento 1% nos anos de estudo elevaria sua renda em 0,0,79%. Admita agora
*** um indivíduo do sexo feminino (sexo=0) não branco (cor=0) que tenha 50 anos
*** de idade (idade2=2500) e 18 anos de estudo.


mfx compute, eyex at(sexo=0 cor=1 idade=50 idade2=2500 estudo=18)

***E assim vamos alterando as configurações do individuo.

mfx compute, eyex at(sexo=0 cor=0 idade=50 idade2=2500 estudo=18)

mfx compute, eyex at(sexo=1 cor=1 idade=50 idade2=2500 estudo=11)

mfx compute, eyex at(sexo=1 cor=1 idade=50 idade2=2500 estudo=8)

mfx compute, eyex at(sexo=1 cor=1 idade=25 idade2=625 estudo=18)



