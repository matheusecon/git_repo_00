*************************** Monitoria 1 ****************************************
//**// O impacto das exportações no PIB (ambos em nível) //**//

*** o gráfico de dispersão ***
//**// A linha vermelha é a linha de previsão da regressão e os pontos em azul //
// são as observações da amostra. Graficamente pode-se perceber que a relação 
// entre as variáveis exportação e produto é positivamente inclinada, ou seja, 
// quanto maior as exportações maior tende a ser o pib. A diferença entre os 
// pontos azuis e a linha vermelha são os erros dos modelo, e com o MQO busca-se
// minimizar a soma dos quadrados dos resíduos.
twoway (scatter y x) (lfit y x)

*** Coeficiente de correlação de pearson ***
//**// É uma maneira de intender o grau de associação entre as variáveis. Des-
// creve a forma com que duas variáveis se correlacionam. Varia entre 1 e -1
// (Se for igual a 1 há uma correlação positiva perfeita, e o contrário vdd). 
// Quanto mais próximo de 1 maior é a associação positiva entre as variáveis
// (quando o um aumenta o outro aumenta), sendo o contrário verdadeiro (quando
// um aumento o outro diminui).
corr y x
//*** Há uma correlação quase perfeita entre as variáveis ***

*** a regressão por MQO ***
//**// Estatística de ajustamento do modelo:
///* R2 -> Coeficiente de determinação. Indica qual a porcentagem da variação da 
// variável explicativa explicada pela variação da variável explicativa (ou 
// pelas variáveis embutidas modelo) (fórmula: SQE/SQT)
///* Intervalo de confiança do parâmetro (fórmula) -> indicam a area que o verda
// deiro parâmetro pode estar inserido.
///* Teste de significância individual dos parâmetros
//* t-tabalado (fórmula): se há uma amostra de mais de 20 observações, ao nível
// 5% de significância se o valor do t calculado for maior que 1,96 em módulo 
// pode-se rejeitar a hipótese nula de que o coeficiente é estatísticamente i-
// gual a 0.
//* p-valor: (como se analisa e sua diferença com o nível de significância)
///* Erro padrão dos coeficientes
///* Parâmetros estimados: 
///* inclinação-> o aumento de 1 dollar na quantidade exportada aumenta o pib em 
// aproximadamente 4.42 dollares.
///* SQR -> quanto menor o SQR melhor é o ajustamento do modelo (como o compor-
// mento da variável dependente é explicada pelas variáveis explicativas mais um
// termo de erro na prática isso indica que as variáveis explicativas são mais 
// importantes que o erro aleatório na regressão. (fórmula)
// O MS (é a média da soma dos quadrados) e df é os graus de liberdade do modelo
// A SQR divido pelos graus de liberdade nos dão a variância estimada do erro
// do modelo (sigma2)
///* SQT (fórmula)
///* SQE (fórmula)
reg y x

////////////////////////////////////////////////////////////////////////////////
*** Para se analisar as elasticidades ***
//**// Incialmente deve-se linearizar as variáveis
gen lny = ln(y)
gen lnx = ln(x)

reg lny lnx

///* Parâmetros estimados: 
///* inclinação-> o aumento de 1% na variável explicativa aumenta a variável ex-
// plicada em cerca de X%. O aumento na variável explicada é mais (igual, menor)
// que proporcional o aumento da variável explicativa.

//**// Histograma dos dados
///* Ajuda a analisar a distribuição das frequencias dos dados
histogram y, bin(6) normal
///* os retangulos o histograma dos lados com uma linha com a curva normal com a 
// frequencia dos dados a fim de analisar se os dados acompanham uma distribui-
// ção normal.

//**// Estatisticas pontuais conjuntas (média, desvio padrão, maximo e minimo)
correlate y x, means
