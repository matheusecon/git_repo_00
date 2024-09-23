***Extraindo dados da PNAD2015***
***04/04/2018***
***Walquíria Caneschi (85447) e Salime Nadur (82051)*** 

*DEMANDA DE PREVIDÊNCIA PRIVADA*

*Inicialmente, vamos separar a memoria do computador que o stata irá trabalhar com os dados*

set more off
set mem 700m, perm

*Na sequência, vamos importar variáveis do arquivo de pessoas*

*Para discriminar de qual pasta serão extraídos os dados txt da PNAD 2015*

cd "D:\Usuários\Luiz\Área de Trabalho\DADOS"

*Agora vamos realizar a leitura das informações do desenho da amostra no arquivo de pessoas*

#delimit;
infix ano 1-4 uf 5-6 controle 5-12 serie 13-15 ordem 16-17 sexo 18-18 idade 17-19 
cor 33-33 estado_civil 41-41 prev_priv 546-546 empregado 706-706 eco_atv 705-705
escolaridade 703-704 peso 791-795 renda_pcp 806-817 renda_princ 725-736 
using "D:\Usuários\Luiz\Área de Trabalho\DADOS\PES2015.txt";
#delimit cr

*Vamos ordenar os dados*

sort controle serie

*Vamos salvar o arquivo*

save PES2015

*Agora, vamos importar variáveis do arquivo de domicícios*

clear 
set more off
#delimit;
infix ano 1-4 uf 5-6 controle 5-12 serie 13-15 totalmoradores 18-19 totalmoradores10 20-21 psu 185-191 strat 178-184
using "D:\Usuários\Luiz\Área de Trabalho\DADOS\DOM2015.txt";
#delimit cr

*Ordenando os dados*

sort controle serie

*Salvando o arquivo*

save DOM2015

*Agora vamos juntar os dados do arquivo de pessoas e do arquivo de domicílios*

clear
use "D:\Usuários\Luiz\Área de Trabalho\DADOS\PES2015.dta", clear
#delimit
merge m:m controle serie using "D:\Usuários\Luiz\Área de Trabalho\DADOS\DOM2015.dta";
#delimit cr

*É possível ver as observaçõs que coicidem (_merge==3) e as que não coincidem (_merge==1 e _merge==2) entre os dois bancos de dados.*
*Vamos utilizar apenas as que coicidem. Para isso, temos de excluir as demais*

keep if _merge==3
drop _merge

*Agora vamos alocar os extratos com psu único em extratos com maior número de observações utilizando o comando "idonepsu" *

#delimit
idonepsu, strata(strat) psu(psu) generate(new);
drop strat psu;
rename newstr strat;
rename newpsu psu;
#delimit cr

svyset psu [pweight=peso], strata(strat) vce(linearized) || _n

svydes, single

*Para encontrar as informações que ainda contém psu único*

svydes, finalstage

*Dropando as informações que ainda contém psu único*

#delimit
drop if strat==140001 & psu==32;
drop if strat==230003 & psu==21;
drop if strat==260014 & psu==376;
drop if strat==330030 & psu==599;
drop if strat==350016 & psu==107;
drop if strat==350016 & psu==108;
drop if strat==420006 & psu==50;
#delimit cr

*O próximo passo é eliminar os missing*

drop if estado_civil==.
drop if renda_pcp==.
drop if renda_princ==.
drop if totalmoradores==.
drop if totalmoradores10==.

*Para verificar se ainda há algum missing utilizamos o comando "inspect" *

 inspect estado_civil empregado eco_atv renda_pcp renda_princ totalmoradores totalmoradores10
 
 *Agora vamos recodificar as variáveis*
 
 replace sexo=1 if sexo==2
 replace sexo=0 if sexo==4
 replace cor=1 if cor==2
 replace cor=0 if (cor==4 | cor==6 | cor==8 | cor==0 | cor==9)
 replace estado_civil=0 if (estado_civil==3 | estado_civil==5 | estado_civil==7 | estado_civil==0)
 replace empregado=0 if empregado==2
 replace eco_atv=0 if eco_atv==2
 replace prev_priv=1 if prev_priv==2
 replace prev_priv=0 if prev_priv==4
 
 *Os dados estão prontos para serem utilizados*
 
 *Agora vamos estimar as médias das variáveis reconhecendo a amostragem complexa e não reconhecendo a amostragem complexa.*
 *Isso nos dara uma idéia do Efeito do Plano Amostral (EPA)*
 
 mean prev_priv
 
 *Considerando amostragem complexa*

 svy: mean renda_prin
 
 *Agora vamos estimar a regressão*
 
 

