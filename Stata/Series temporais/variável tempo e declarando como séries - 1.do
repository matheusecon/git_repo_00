***Gerando a variável de tempo no stata***
 
***Anualizada com inicio em 2002. Apenas cria a variável com nome tempo com início em 2002.
gen tempo = y(2002) + _n-1

***Defina o formato da variável para o período anual***
format tempo %ty

***Na sequencia você pode "Setar" a variável tempo como tempo da regressão

tsset tempo

***Agora com dados mensais.

gen tempo = m(2002m3) + _n-1

***Formate a variável de tempo para o período mensaç.

format tempo %tm

***E finalmente "Seta" os dados para dados de séries temporais.

tsset tempo

***No caso de dados trimestrais basta substituir o "m" pelo "q" nos comando 
***anteriores. Agora, fazendo para dados semanais.

gen tempo = q(2002q1) + _n-1

***Formate o período para o tempo trimestral.

format tempo %tq

***E finalmente "Seta" para dados de séries temporais trimestrais.

tsset tempo

*** Agora fazendo para a primeira semana. A título de exemplo vamos admitir
*** que os dados se iniciem na primeira semana de 2002.

gen tempo = w(2002w1) + _n-1

***Formate o período para o tempo semanal.

format tempo %tw

***E finalmente "Seta" para dados de séries temporais semanais.

tsset tempo
