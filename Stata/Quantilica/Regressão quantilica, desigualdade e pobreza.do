////////////////////////////////////////////////////////////////////////////////
//*/*/                                                                    /*/*//
//*/*  ******************************************************************  */*//
// *********** ESTRUTURA FAMILIAR E DISTRIBUIÇÃO DE RENDA ******************* //
//*/*  ******************************************************************  */*//
//*/*/ 																	  /*/*//												   
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
/******************************************************************************/
/**                        PREPARANDO OS DADOS                               **/
/******************************************************************************/
////////////////////////////////////////////////////////////////////////////////

*** PARA DESCRIMINAR EM QUAL PASTA SERÃO EXTRAIDOS OS DADPS TXT DA PNAD ***
cd "C:\Users\Matheus\Desktop\matheus\ufv\artigos\econometria - estrutura familiar e distribuição de renda domiciliar per capta\base de dados\PNAD_2015\Dados"

*** PARA EXPANDIR A MEMÓRIA DO STATA ***
set more off
set memory 512m

*** LEITURA DAS INFORMACOES DO DESENHO DA AMOSTRA NO ARQUIVO DE DOMICILIOS ***
clear
#delimit;
infix ano 1-4 UF 5-6 controle 5-12 serie 13-15 id 7-15 tipo 16-17   
intervalo 139-144 strat 178-184 psu 185-191 TotalMoradores 18-19
TotalAdultos10 20-21 Urbano 100-100 CodAreaCensitaria 101-101
using "C:\Users\Matheus\Desktop\matheus\ufv\artigos\econometria - estrutura familiar e distribuição de renda domiciliar per capta\base de dados\PNAD_2015\Dados\DOM2015.txt",clear;
#delimit cr

*** ORDENANDO OS DADOS ***
/// O comando sort organiza as observações dos dados atuais em ordem ascendente 
** baseado nos valores das variaveis em varlist, neste caso controle e serie sao
** as variaveis usadas como referência.//
#delimit;
sort controle serie, stable;
format controle %15.0g;
format serie %15.0g;
replace controle = float(controle);
replace serie = float(serie);
#delimit cr

save dom2015, replace

*** LEITURA DAS INFORMACOES DO DESENHO DA AMOSTRA NO ARQUIVO DE PESSOAS ***
clear
#delimit;
infix ano 1-4 UF 5-6 controle 5-12 serie 13-15 ordem 16-17
Sexo 18-18
DiaNasc 19-20 MesNasc 21-22 AnoNasc 23-26 Idade 27-29
CondDom 30-30 CondFam 31-31
num_fam 32-32
Cor 33-33
MoracomConjuge 39-39
EstCiv 41-41
Analfabeto 67-67 Estudante 68-68
TrabInf 96-96 RendaTrabInf 132-143
EmpregDomestic 302-302 Militar 307-307 FuncPublic 308-308 Diarista 309-309
CerteiraAss 315-315
RendaProdTrabPrinc 340-351 RendaTrabSecun 460-471 RendaProdTrabSecun 373-384
RendaTrabTerce 491-502 RendaProdTrabTerce 504-515 Pensao 552-552
RendaAposen 555-566 RendaPensao 569-580 RendaAponse2 583-592
RendaPensao2 597-608 RendaSegDesemp 611-622 RendaAlug 625-636
RendaDoacao 639-650 RendaPoupanca 653-664
NFilhosMV 667-668 NFilhosFV 669-670 NFilhosMFora 671-672 NFilhosFFora 673-674
TempoEstudo 703-704
EconAtiva 705-705 Ocupado 706-706
RendaTrabPrinc 725-736 RendaTodosTrab 737-748 RendaTodasFontes 749-760
TipodeFam 785-786 TotalPessoasFam 787-788
pesopes 791-795 pesofam 796-800
ControleFecundidade 801-801
TotalPessoasDom 804-805
RMDPC 806-817 FaixaRMDPC 818-819 RMFPC 825-836 
using "C:\Users\Matheus\Desktop\matheus\ufv\artigos\econometria - estrutura familiar e distribuição de renda domiciliar per capta\base de dados\PNAD_2015\Dados\PES2015.txt",clear;
#delimit cr 

*** JUNÇÃO DAS INFORÇÕESS DE DESENHO DA AMOSTRAL (DADO PELO ARQUIVO DE DOMMICÍLIOS) AO ARQUIVO DE PESSOAS DA PNAD ***
/// O comando sort organiza os dados enquanto o comando joinby realiza a jun-
** ção.//
#delimit;
sort controle serie, stable;
joinby controle serie using dom2015;
#delimit cr

save dados2015, replace

*** DECLARANDO/SETANDO O CONJUNTO DE DADOS COMO SENDO UMA AMOSTRA COMPLEXA ***
clear
use dados2015, clear

svyset psu [pweight=pesopes], strata(strat) vce(linearized) || _n

svydes, single

save dados2015, replace

*** ALOCAÇAO DE ESTRATOS COM UM UNICO PSU EM ESTRATOS COM MAIOR NUMERO DE OBSERVACÕES ***
/// O comando idonepsu realiza tal rotina.//
use dados2015, clear

#delimit;
idonepsu, strata(strat) psu(psu) generate(new);
drop strat psu;
rename newstr strat;
rename newpsu psu;
#delimit cr

svyset psu [pweight=pesopes], strata(strat) vce(linearized) || _n

svydes, single

save dados2015, replace

*** PARA ENCONTRAR AS OBSERVAÇÕES QUE AINDA ESTÃO COM PSU ÚNICO ***
svydes, finalstage

*** DROPANDO AS INFORMAÇÕES QUE AINDA CONTÉM PSU ÚNICO
/// tem-se que eliminar obs=1, sendo unit = PSU (LEMBRAR QUE OS PSU'S VARIAM DE
** ANO PARA ANO).//
#delimit;
drop if strat == 230006 & psu == 170;
drop if strat == 350009 & psu == 68;
drop if strat == 140001	& psu == 32;
drop if strat == 230003	& psu == 21;
drop if strat == 260014	& psu == 376;
drop if strat == 330030	& psu == 599;
drop if strat == 350016	& psu == 107;
drop if strat == 350016	& psu == 108;
drop if strat == 420006	& psu == 50;
#delimit cr

*** ANÁISE DE REGRESSÃO ***
/// Para analisar o efeito do plano amostral.//
drop if RMDPC > 200000 & RMDPC!=.
svy: regress RMDPC Idade
estat effects, meff 

/// Para comparar os resultados do efeito do plano amostral com os resultaods
** que não levam em compensação o efeito do plano amostral.//
regress RMDPC Idade

*** Efeitos marginal ***
mfx compute, dydx at(mean)

*** Elasticidade ***
mfx compute, eyex at(mean)

save dados2015, replace


////////////////////////////////////////////////////////////////////////////////
/******************************************************************************/
/**                 RECODIFICANDO E GERANDO CARIÁVEIS                        **/
/******************************************************************************/
////////////////////////////////////////////////////////////////////////////////

/// Regiões brasileira: sul, sudeste, norte, nordeste e centro-oeste.//

*** Norte (UF = 11, 12, 13, 14, 15, 16 e 17) ***
gen norte =.
replace norte=1 if UF==11 | UF==12 | UF==13 | UF==14 | UF==15 | UF==16 | UF==17
replace norte=0 if norte==.

*** Nordeste (UF = 21, 22, 23, 24, 25, 26, 27, 28 e 29) ***
gen nordeste=.
replace nordeste=1 if UF==21 | UF==22 | UF==23 | UF==24 | UF==25 | UF==26 | UF==27 | UF==28 | UF==29
replace nordeste=0 if nordeste==.

*** Sul (UF = 41, 42 e 43) ***
gen sul=.
replace sul=1 if UF==41 | UF==42 | UF==43
replace sul=0 if sul==.

***Sudeste (UF = 31, 32, 33 e 35) ***
gen sudeste=.
replace sudeste=1 if UF==31 | UF==32 | UF==33 | UF==35
replace sudeste=0 if sudeste==.

****Centro-Oeste (UF = 50, 51, 52 e 53) ***
gen centro_oeste=.
replace centro_oeste=1 if UF==50 | UF==51 | UF==52 | UF==53
replace centro_oeste=0 if centro_oeste==.

********************************************************************************

*** criando a variável rural***
 gen Rural=.
 replace Rural=1 if Urbano ==4 | Urbano ==5 | Urbano ==6 | Urbano ==7
 replace Rural=0 if Urbano ==1 | Urbano ==2 | Urbano ==3

*** Sexo ***
/// Se refere ao sexo (1 se masculino e 0 caso contrário).//
 recode Sexo (2=1) (4=0)
 
********************************************************************************
/// Cortes em relação a descriminação da idade no mercado de trabalho.//
// se idade >=10 & <29 se enquadra como GrupoIdade1.//
// se idade >=29 & <40 se enquadra como GrupoIdade2.//
// se idade >=40 & <65 se enquadra como GrupoIdade3.//

gen GrupoIdade1 =.
replace GrupoIdade1 = 1 if Idade >=10 & Idade <29
replace GrupoIdade1 = 0 if GrupoIdade1 ==.

gen GrupoIdade2 =.
replace GrupoIdade2 = 1 if Idade >=29 & Idade <40
replace GrupoIdade2 = 0 if GrupoIdade2 ==.

gen GrupoIdade3 =.
replace GrupoIdade3 = 1 if Idade >=40 & Idade <65
replace GrupoIdade3 = 0 if GrupoIdade3 ==.

********************************************************************************
/// Variáveis ligadas a chefia da casa.//

*** Chefe ***
#delimit
gen chefe =0;
replace chefe = 1 if CondDom==1;
egen float fam = group(UF controle serie num_fam)
bysort fam: egen float referencia_fam = mean(chefe)
#delimit cr

*** Chefe do sexo masculino (1 se masculino) ***

gen ChefeMasc =.
replace ChefeMasc =1 if Sexo ==1 & chefe ==1
replace ChefeMasc =0 if Sexo ==0 & chefe ==1

******************************************************************************** 
*** Cor ***
 recode Cor (4=0) (2=1) (6=0) (8=0) (0=0) (9=0)

*** Se mora com o conjuge (1 se mora) ***
 recode MoracomConjuge (1=1) (3=0) (5=0)

********************************************************************************
/// Estado Civil: Casado ou solteiro (Separado, Divorciado, Viuvo e Solteiro).//

*** Casado ***
gen Casado =.
replace Casado =1 if EstCiv ==1
replace Casado =0 if Casado ==.

*** Solteiro ***
gen  Solteiro =.
replace Solteiro =1 if EstCiv == 3 | EstCiv == 5 | EstCiv ==7 | EstCiv ==0
replace Solteiro =0 if Solteiro ==. 

********************************************************************************

*** Analfabeto ***
 recode Analfabeto (1=1) (3=0)

*** Estudante (1 se estuda) ***
 recode Estudante (2=1) (4=0)
 
*** Se era trabalhador infantil (1 se a pessoa de 5 a 9 anos de idade trabalhou na semana de referencia) ***
 recode TrabInf (2=1) (4=0)
 
*** Empregada Doméstica ***
 recode EmpregDomestic (2=1) (1=0) (3=0) (4=0) (5=0) (6=0) (7=0)
 
*** Militar ***
 recode Militar (2=1) (4=0)

*** Funcionario Publico ***
 recode FuncPublic (1=1) (3=0)
 
*** Diarista ***
/// Se refere apenas as funcionárias domésticas.//
 recode Diarista (2=1) (4=0)
 
*** Mercado de trabalho formal e informal (1 se possui carteira assinada) ***
 rename CerteiraAss Formal
 recode Formal (2=1) (4=0)
 
*** Numero total de filhos vivos ***
 recode NFilhosMV (.=0)
 recode NFilhosFV (.=0)
 gen numtotalfilhoV = NFilhosMV + NFilhosFV
 
*** Numero total de filhos vivos que moram fora ***
 recode NFilhosMFora (.=0)
 recode NFilhosFFora (.=0)
 gen numtotalfilhoF = NFilhosMFora + NFilhosFFora
 
*** Pessoa com filhos ***
 gen PessoacomFilho =.
 replace PessoacomFilho =1 if numtotalfilhoV >0
 replace PessoacomFilho =0 if PessoacomFilho ==.
 
********************************************************************************
/// Variáveis ligadas ao tempo de estudo.//

*** Tempo de estudo ***
 recode TempoEstudo (1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6) (8=7) (9=8) (10=9) (11=10) (12=11) (13=12) (14=13) (17=.)
 drop if TempoEstudo ==17
 
*** Mais de quize anos de estudo (1 se possui mais de 15 anos de estudo) ***
 gen Maisde15anosEst =.
 replace Maisde15anosEst =1 if TempoEstudo ==16
 replace Maisde15anosEst =0 if Maisde15anosEst ==.
 
********************************************************************************

*** Economicamente Ativa (1 se faz parte da população economicamente ativa) ***
 recode EconAtiva (1=1) (2=0)
 drop if EconAtiva ==0
 
*** Ocupado/Desempregado (1 se ocupado) ***
 recode Ocupado (1=1) (2=0)

******************************************************************************** 
/// Tipo de família: casal sem filhos; casal com apenas filhos pequenos;//

*** Casal sem filhos ***
 gen CasalSemFilhos =.
 replace CasalSemFilhos =1 if TipodeFam ==1
 replace CasalSemFilhos =0 if CasalSemFilhos ==.
 
*** Casal com filhos pequenos ***
 gen  CasalFilhoPno =.
 replace CasalFilhoPno =1 if TipodeFam ==2
 replace CasalFilhoPno =0 if CasalFilhoPno ==.
 
*** Casal com filhos maiores ***
 gen CasalFilhoGde =.
 replace CasalFilhoGde =1 if TipodeFam ==3
 replace CasalFilhoGde =0 if CasalFilhoGde ==.
 
*** Casal com filhos menores e maiores ***
 gen CasalFilhoPnoGde =.
 replace CasalFilhoPnoGde =1 if TipodeFam ==4
 replace CasalFilhoPnoGde =0 if CasalFilhoPnoGde ==.
 
*** Casal com filhos ***
 gen CasalcomFilho =.
 replace CasalcomFilho =1 if CasalFilhoPno ==1 | CasalFilhoGde ==1 | CasalFilhoPnoGde ==1
 replace CasalcomFilho =0 if CasalcomFilho ==.
 
*** Mãe com filhos pequanos ***
 gen MaeFilhoPno =.
 replace MaeFilhoPno =1 if TipodeFam ==6
 replace MaeFilhoPno =0 if MaeFilhoPno ==.
 
*** Mãe com filhos maiores ***
 gen MaeFilhoGde =.
 replace MaeFilhoGde =1 if TipodeFam ==7
 replace MaeFilhoGde =0 if MaeFilhoGde ==.
 
*** Mãe com filhos menores e maiores ***
 gen MaeFilhoPqnoGde =.
 replace MaeFilhoPqnoGde =1 if TipodeFam ==8
 replace MaeFilhoPqnoGde =0 if MaeFilhoPqnoGde ==.

*** Mãe com filhos ***
 gen MaecomFilho =.
 replace MaecomFilho =1 if MaeFilhoPno ==1 | MaeFilhoGde ==1 | MaeFilhoPqnoGde ==1
 replace MaecomFilho =0 if MaecomFilho ==.
 
*** Outros Tipos de Família ***
 gen OutrosTipFam =.
 replace OutrosTipFam =1 if TipodeFam ==10
 replace OutrosTipFam =0 if OutrosTipFam ==.
********************************************************************************

********************************************************************************
***                    Variáveis Explicativas                                ***
********************************************************************************

*** Porcentalgem de adultos em relação ao total de membros de uma família ***
 gen ProporcaoAdultos = TotalAdultos10 / TotalMoradores

 gen ProporcaoAdultos2 = ProporcaoAdultos^2
********************************************************************************
/// Chefes de família.//

*** Chefe de família do genero feminino solteira com filhos ***
gen ChefeMulherSoltCF =.
replace ChefeMulherSoltCF =1 if MaecomFilho ==1 & ChefeMasc ==0
replace ChefeMulherSoltCF =0 if ChefeMulherSoltCF ==.

*** Chefe de família do genero masculino solteiro com filhos ***
/// Há 0 pessoas na amostra com essas características.//
gen ChefeHomemSoltCF =.
replace ChefeHomemSoltCF =1 if PessoacomFilho ==1 & MoracomConjuge ==1 & ChefeMasc ==1
replace ChefeHomemSoltCF =0 if ChefeHomemSoltCF ==.

*** Chefe de familia do genero feminino casada com filhos ***
gen ChefeMulherCasCF =.
replace ChefeMulherCasCF =1 if CasalcomFilho ==1 & ChefeMasc ==0
replace ChefeMulherCasCF =0 if ChefeMulherCasCF ==.

*** Chefe de família do genero masculino casado com filhos ***
gen ChefeHomemCasCF =.
replace ChefeHomemCasCF =1 if  CasalcomFilho ==1 & ChefeMasc ==1
replace ChefeHomemCasCF =0 if ChefeHomemCasCF ==.

*** Chefe de Família do genero feminino casada sem filhos ***
gen ChefeMulherCasSF =.
replace ChefeMulherCasSF =1 if CasalSemFilhos ==1 & ChefeMasc ==0
replace ChefeMulherCasSF =0 if ChefeMulherCasSF ==.

*** Chefe de família do genero masculino casado sem filhos ***
gen ChefeHomemCasSF =.
replace ChefeHomemCasSF =1 if CasalSemFilhos ==1 & ChefeMasc ==1
replace ChefeHomemCasSF =0 if ChefeHomemCasSF ==.

*** Idade do chefe de família ***
gen IdadeChefe= Idade if chefe==1

*** Idade do chefe de família do sexo feminino ***
gen IdadeChefeFem= Idade if chefe==1 & Sexo==0

*** Chefe de Família do grupo de idade 1 ***
gen ChefeGropoIdade1 =.
replace ChefeGropoIdade1 =1 if chefe==1 & GrupoIdade1 ==1
replace ChefeGropoIdade1 =0 if ChefeGropoIdade1 ==.

*** Chefe de Família do grupo de idade 2 ***
gen ChefeGropoIdade2 =.
replace ChefeGropoIdade2 =1 if chefe==1 & GrupoIdade2 ==1
replace ChefeGropoIdade2 =0 if ChefeGropoIdade2 ==.

*** Chefe de Família do grupo de idade 3 ***
gen ChefeGropoIdade3 =.
replace ChefeGropoIdade3 =1 if chefe==1 & GrupoIdade3 ==1
replace ChefeGropoIdade3 =0 if ChefeGropoIdade3 ==.


save dados2015, replace

********************************************************************************
***                      Variáveis Explicada                                 ***
********************************************************************************

*** ln da renda mensal domiciliar per capta ***
gen lnRMDPC = ln(RMDPC)

*** ln do salário principal ***
gen lnRTP = ln(RendaTrabPrinc)

/// As variaáveis explivativas serão RMDPC ou RendaTrabPrinc (visto que a RG
** corrige a presença de outlyers).//

save dados2015, replace


*** Deflacionando a Renda ***
/// A deflacao foi construindo em cima do ano base:
** (inflacao acumulada/inflacao base (2005)).//

gen Deflacionamento =0.8646
gen RMDPCReal = Deflacionamento * RMDPC
drop if RMDPCReal > 200000
drop if RMDPCReal ==.

save dados2015, replace

////////////////////////////////////////////////////////////////////////////////
/******************************************************************************/
/**                         REGRESSÃO QUANTILICA                             **/
/******************************************************************************/
////////////////////////////////////////////////////////////////////////////////
cd "C:\Users\Matheus\Dropbox\PDM\studies\ufv\artigos\econometria - estrutura familiar e distribuição de renda domiciliar per capta\base de dados\PNAD_2015\Dados"

set more off
set memory 1024m

use dados2015, clear

*** Minimos Quadrados Ordinários - MQO ***
/// Após estimar a regressão por MQO devemos encontrar o valor crítico para se
** comparar as distâncias de leverage. Tal distância nos possibilita analisar a
** a presença de outliers. Se houverem outlyers na amostra seria um bom indicio
** para a utilização da RG, um método robusto a presença de tal disturbio.//
/// O comando predict irá extrair os resíduos da regressão, o que nos auxiliará
** a analisar a normalidade dos residuos. Caso a normalidade seja rejeitada tam-
** bém proporcionará a sugestão de que a RG é um bom método para o problema em
** questão.//
reg RMDPCReal ProporcaoAdultos ChefeMulherSoltCF ChefeMulherCasCF ChefeHomemCasCF ChefeMulherCasSF ChefeHomemCasSF ChefeGropoIdade2 ChefeGropoIdade3

*** Teste de multicolineariedade ***
/// Se FIV é inferior a 10 indicando, portanto, a ausência de multicolinearida-
** de entre as variáveis explicativas.//
estat vif

*** Teste de heterocedasticidade ***
/// hipótese nula é de variância constante.//
/// Se o teste for significante abaixo de 10% rejeitamos a hipótese nula com 90%
** de confiança.//
hettest

*** Valor crítico ***
/// Uma observação seria considerada um outliers se a distância de leverage for 
** superior a 2*(k/N), onde k é o número de parâmetros estimados e N o número de
** observações.//
reg RMDPCReal ProporcaoAdultos ChefeMulherSoltCF ChefeMulherCasCF ChefeHomemCasCF ChefeMulherCasSF ChefeHomemCasSF ChefeGropoIdade2 ChefeGropoIdade3

predict lev, leverage 
display 2*10/227452

*** Listagem dos possíveis valores superiores a 0.00005697 /// *** ATENÇÃO *** \\\ ESSE VALOR SE ALTERA ***
/// Se houver valores superiores a 2*(k/N) indica a presença de outlyers.//
list RMDPCReal ProporcaoAdultos ChefeMulherSoltCF ChefeMulherCasCF ChefeHomemCasCF ChefeMulherCasSF ChefeHomemCasSF ChefeGropoIdade2 ChefeGropoIdade3 if lev>0.00008793 

*** Teste Shapiro-Francia ***
/// Hipótese nula: normalidade dos resíduos.//
/// Deve também ser testada a hipótese de normalidade dos resíduos. Se os erros
** não se distribuírem normalmente também o seria um bom indício para a utiliza-
** ção da RG.//
reg RMDPCReal ProporcaoAdultos ChefeMulherSoltCF ChefeMulherCasCF ChefeHomemCasCF ChefeMulherCasSF ChefeHomemCasSF ChefeGropoIdade2 ChefeGropoIdade3
predict resid, residuals

sfrancia resid

/// Assim podemos concluir se os resíduos não se distribuem normalmente.

********************************************************************************
***                   Estatística descritiva                                 ***
********************************************************************************
*** Numero de observações, média, desvio padrão, minimo e maximo ***
sum RMDPCReal // outro comando: tabstat RMDPC, s(count min max mean sd cv sk p25 p50 p75)

*** Percentis, variância, assimetria (skewness) e curtose ***
sum RMDPCReal, detail
/// O Percentil 75% (ou terceiro quartil) da variavel é igual a XXXX, o que sig-
** nifica que 75% das observaçÕes são menores ou iguais a este valor. Já o per-
** centil 10 (ou primeiro decil) é igual a XXXX indicando que 10% das observa-
** ções são menores ou iguais a este valor.
/// A assimetria da variavel é igual a um numero positivo (negativo) indicando
** que a distribuição de tal variável tem uma assimetria positiva (negativa), o
** que quer dizer que temos uma concentraçao de frequência individuos com RMDPC
** mais reduzida (elevada).//

*** Histograma ***
histogram RMDPCReal, width(10) start(0) frequency
/// Observa-se no histograma como se dá a concentraçao de frequência. Isto con-
** firma o valor positivo (negativo) para o coeficiente de assimetria, se a con-
** centração da variável se der de forma reduzida (elevada).//

*** Distribuição dos quantis ***
qplot RMDPCReal, recast(line) xline(.25) xline(.50) xline(.75)

*** Inversa da Função de Distribuição Populacional Normal Quantílica ***
qnorm RMDPCReal, recast(line)

********************************************************************************
***                     Regressão Quantilica                                 ***
********************************************************************************

*** Teste de Heterocedásticidade ***
/// Hipótese nula: homocedásticidade.//
quietly reg RMDPCReal ProporcaoAdultos ChefeMulherSoltCF ChefeMulherCasCF ChefeHomemCasCF ChefeMulherCasSF ChefeHomemCasSF ChefeGropoIdade2 ChefeGropoIdade3
estat hettest ProporcaoAdultos ChefeMulherSoltCF ChefeMulherCasCF ChefeHomemCasCF ChefeMulherCasSF ChefeHomemCasSF ChefeGropoIdade2 ChefeGropoIdade3

*** Modelo quantílico com erros-padrão robustos ***
/// Mantém a suposição de erros independentes, mas relaxa as suposições de erros
** identicamente distribuídos. São semelhantes a erros-padrão robustos em regre-
** ssões lineares. Esse comando gera erros-padrão através do método de bootstrap
** que seria mais eficiente, mesmo considerando pequenas amostras.//
/// Regressão levando em consideração os quantis referentes a tau = (0.25, 0.50
** e 0,75), e as Elasticidades no ponto médio da amostra. //
*** Regressão para o quantil tau = 0.25 ***
bsqreg RMDPCReal ProporcaoAdultos ChefeMulherSoltCF ChefeMulherCasCF ChefeHomemCasCF ChefeMulherCasSF ChefeHomemCasSF ChefeGropoIdade2 ChefeGropoIdade3, q(0.25)

*** Elasticidade para o quantil tau = 0.25 ***
mfx compute, eyex at (mean)

*** Regressão para o quantil tau = 0.5 ***
bsqreg RMDPCReal ProporcaoAdultos ChefeMulherSoltCF ChefeMulherCasCF ChefeHomemCasCF ChefeMulherCasSF ChefeHomemCasSF ChefeGropoIdade2 ChefeGropoIdade3, q(0.5)

*** Elasticidade para o quantil tau = 0.5 ***
mfx compute, eyex at (mean)

*** Regressão para o quantil tau = 0.75 ***
bsqreg RMDPCReal ProporcaoAdultos ChefeMulherSoltCF ChefeMulherCasCF ChefeHomemCasCF ChefeMulherCasSF ChefeHomemCasSF ChefeGropoIdade2 ChefeGropoIdade3, q(0.75)

*** Elasticidade para o quantil tau = 0.75 ***
mfx compute, eyex at (mean)

*** Estimativas em conjunto ***
/// Possibilita a posterior análise se estas estimativas são estatisticamente
** diferentes entre os quantis. Os erros-padrão produzidos são robustos (através
** de Bootstrap).//
sqreg RMDPCReal ProporcaoAdultos ChefeMulherSoltCF ChefeMulherCasCF ChefeHomemCasCF ChefeMulherCasSF ChefeHomemCasSF ChefeGropoIdade2 ChefeGropoIdade3, nolog q(0.25 0.5 0.75)

*** Testes para ver se estimativas são estatisticamente diferentes entre os quantis ***
test [q25=q50=q75]: ProporcaoAdultos
test [q25=q50=q75]: ChefeMulherSoltCF
test [q25=q50=q75]: ChefeMulherCasCF
test [q25=q50=q75]: ChefeHomemCasCF
test [q25=q50=q75]: ChefeMulherCasSF
test [q25=q50=q75]: ChefeHomemCasSF
test [q25=q50=q75]: ChefeGropoIdade2
test [q25=q50=q75]: ChefeGropoIdade3

test [q25=q50]: ProporcaoAdultos
test [q25=q50]: ChefeMulherSoltCF
test [q25=q50]: ChefeMulherCasCF
test [q25=q50]: ChefeHomemCasCF
test [q25=q50]: ChefeMulherCasSF
test [q25=q50]: ChefeHomemCasSF
test [q25=q50]: ChefeGropoIdade2
test [q25=q50]: ChefeGropoIdade3

test [q50=q75]: ProporcaoAdultos
test [q50=q75]: ChefeMulherSoltCF
test [q50=q75]: ChefeMulherCasCF
test [q50=q75]: ChefeHomemCasCF
test [q50=q75]: ChefeMulherCasSF
test [q50=q75]: ChefeHomemCasSF
test [q50=q75]: ChefeGropoIdade2
test [q50=q75]: ChefeGropoIdade3

/// No caso dos quantis diferenciados podemos estimar intervalos de confiança
** para os testes realizados através do comando lincom.//
lincom [q25]ProporcaoAdultos - [q50]ProporcaoAdultos
lincom [q50]ProporcaoAdultos - [q75]ProporcaoAdultos
lincom [q25]ProporcaoAdultos - [q75]ProporcaoAdultos

lincom [q25]ChefeMulherSoltCF - [q50]ChefeMulherSoltCF
lincom [q50]ChefeMulherSoltCF - [q75]ChefeMulherSoltCF
lincom [q25]ChefeMulherSoltCF - [q75]ChefeMulherSoltCF

lincom [q25]ChefeMulherCasCF - [q50]ChefeMulherCasCF
lincom [q50]ChefeMulherCasCF - [q75]ChefeMulherCasCF
lincom [q25]ChefeMulherCasCF - [q75]ChefeMulherCasCF

lincom [q25]ChefeHomemCasCF - [q50]ChefeHomemCasCF
lincom [q50]ChefeHomemCasCF - [q75]ChefeHomemCasCF
lincom [q25]ChefeHomemCasCF - [q75]ChefeHomemCasCF

lincom [q25]ChefeMulherCasSF - [q50]ChefeMulherCasSF
lincom [q50]ChefeMulherCasSF - [q75]ChefeMulherCasSF
lincom [q25]ChefeMulherCasSF - [q75]ChefeMulherCasSF

lincom [q25]ChefeHomemCasSF - [q50]ChefeHomemCasSF
lincom [q50]ChefeHomemCasSF - [q75]ChefeHomemCasSF
lincom [q25]ChefeHomemCasSF - [q75]ChefeHomemCasSF

lincom [q25]ChefeGropoIdade2 - [q50]ChefeGropoIdade2
lincom [q50]ChefeGropoIdade2 - [q75]ChefeGropoIdade2
lincom [q25]ChefeGropoIdade2 - [q75]ChefeGropoIdade2

lincom [q25]ChefeGropoIdade3 - [q50]ChefeGropoIdade3
lincom [q50]ChefeGropoIdade3 - [q75]ChefeGropoIdade3
lincom [q25]ChefeGropoIdade3 - [q75]ChefeGropoIdade3

*** Para verificar como os parâmetros evoluem ao longo dos quantis ***
/// Inicialmente deve-se estimar a regressão quantílica (pode ser para a mediana
** mesmo) e posteriormente entrar com o comando grqreg.//
bsqreg RMDPCReal ProporcaoAdultos ChefeMulherSoltCF ChefeMulherCasCF ChefeHomemCasCF ChefeMulherCasSF ChefeHomemCasSF ChefeGropoIdade2 ChefeGropoIdade3, q(0.5)
grqreg, cons ci ols olsci reps(20)

/// Os gráfico mostram como os efeitos das variáveis explicativas variam ao lon-
** go dos quantis e compara a evolução dos parâmetros entre os quantis com o pa-
** râmetro de MQO.//

*** Mostrar como um resultado varia de um quantil para outro ***
/// Gera erros-padrão robustos (por Bootstrap) e foca na diferença entre os
** quantis. Os resultados possibilitariam verificar o quanto as variáveis expli-
** cativas poderiam contribuir para a redução das desigualdades de renda signi-
** ficativamente verdadeiras entre os quantis. Na seqüência, foi calculada a di-
** ferença entre os quantis 0,25 e 0,50 e entre os quantis 0,50 e 0,75.//
iqreg RMDPCReal ProporcaoAdultos ChefeMulherSoltCF ChefeMulherCasCF ChefeHomemCasCF ChefeMulherCasSF ChefeHomemCasSF ChefeGropoIdade2 ChefeGropoIdade3, nolog q(0.25 0.5)

iqreg RMDPCReal ProporcaoAdultos ChefeMulherSoltCF ChefeMulherCasCF ChefeHomemCasCF ChefeMulherCasSF ChefeHomemCasSF ChefeGropoIdade2 ChefeGropoIdade3, nolog q(0.5 0.75)

/// Nesse sentido, a regressão interquantil pode ser entendida como um teste de
** hipótese sobre as diferenças dos coeficientes de regressão estimados, consi-
** derando os respectivos quantis. Se os parâmetros estimados são significativa-
** mente diferentes de zero, os quantis analisados seriam estatisticamente dife-
** rentes.//

*** Coeficiente de determinação ***
/// Pode-se medir o relativo sucesso dos modelos para um quantíl específico uti-
** lizando o coeficiente de determinação R1. Através do comando sqreg foi esti-
** mada as regressões quantílicas para os quantis 0,05 até 0,95, com intervalos
** de 0,05.//
sqreg RMDPCReal ProporcaoAdultos ChefeMulherSoltCF ChefeMulherCasCF ChefeHomemCasCF ChefeMulherCasSF ChefeHomemCasSF ChefeGropoIdade2 ChefeGropoIdade3, nolog q(.05 .10 .15 .20 .25 .30 .35 .40 .45 .50 .55 .60 .65 .70 .75 .80 .85 .90 .95)

/// Regressão levando em consideração os quantis referentes a tau = (0.25, 0.50
** e 0,75), e as Elasticidades no ponto médio da amostra. //
*** Regressão para o quantil tau = 0.25 ***
*qreg RMDPC ProporcaoAdultos ProporcaoAdultos2 ChefeMulherSoltCF ChefeMulherCasCF ChefeHomemCasCF ChefeMulherCasSF ChefeHomemCasSF ChefeGropoIdade2 ChefeGropoIdade3, nolog q(0.25)

*** Elasticidade para o quantil tau = 0.25 ***
*mfx compute, eyex at (mean)

*** Regressão para o quantil tau = 0.5 ***
*qreg RMDPC ProporcaoAdultos ProporcaoAdultos2 ChefeMulherSoltCF ChefeMulherCasCF ChefeHomemCasCF ChefeMulherCasSF ChefeHomemCasSF ChefeGropoIdade2 ChefeGropoIdade3, nolog q(0.5)

*** Elasticidade para o quantil tau = 0.5 ***
*mfx compute, eyex at (mean)

*** Regressão para o quantil tau = 0.75 ***
*qreg RMDPC ProporcaoAdultos ProporcaoAdultos2 ChefeMulherSoltCF ChefeMulherCasCF ChefeHomemCasCF ChefeMulherCasSF ChefeHomemCasSF ChefeGropoIdade2 ChefeGropoIdade3, nolog q(0.75)

*** Elasticidade para o quantil tau = 0.75 ***
*mfx compute, eyex at (mean)


////////////////////////////////////////////////////////////////////////////////
/******************************************************************************/
/**                        ESTATÍSTICA DESCRITIVA                            **/
/******************************************************************************/
////////////////////////////////////////////////////////////////////////////////

********************************************************************************
***                   Calculando a desigualdade                              ***
********************************************************************************

*** Para instalar comando que calcula a desigualdade ***
findit inequality
findit ainequal

*** Para calcular indices de desigualdade ***
/// Podemos introduzir no comando condicionantes do tipo if ou do tipo in, para
** restringir o calculo do indicador a uma sub-amostra. A opção [fweights], in-
** dica que este comando somente permite  ponderação utilizando um tipo de peso
** chamado frequency weights (pesos de freqüência). Este peso deve ter obrigato-
** riamente valores inteiros e são pesos de expansão da amostra para o universo.
** No caso da PNAD temos justamente disponíveis este tipo de peso e por este mo-
** tivo não teremos problemas de estimar os indicadores.
ainequal RMDPCReal [fw=pesopes]

/// Quando o Indice de Gini é igual a 1, significa que um único individuo recebe
** toda a renda da sociedade, ouseja que praticamente poucos individuos acumula-
** riam quase a totalidade da renda enquanto a maioriafica. Sendo o contrário
** também verdadeiro.//

********************************************************************************
*** Para instalar comando que calcula a pobreza e a distribuição de renda***
*findit povdeco

*** Para gerar uma variável referente a linha de pobreza (lp)
/// Executamos os comandos para a definição da situação de pobreza de cada pes-
** soa na amostra. Em primeiro lugar geramos uma variável (LP) que conterá os 
** valores das linhas de pobreza de acordo com p tipo de família.  

*gen lp = 10.33*31


*** Para analisar a pobreza e a distribuição de renda ***
*label define TipodeFam 1 "Casal sem filhos"
*label define TipodeFam 2 "Casal com todos os filhos menores de 14 anos", add
*label define TipodeFam 3 "Casal com todos os filhos de 14 anos ou mais", add
*label define TipodeFam 4 "Casal com filhos menores de 14 anos e de 14 anos ou mais", add
*label define TipodeFam 6 "Mãe com todos os filhos menores de 14 anos", add
*label define TipodeFam 7 "Mãe com todos os filhos de 14 anos ou mais", add
*label define TipodeFam 8 "Mãe com filhos menores de 14 anos e de 14 anos ou mais", add
*label define TipodeFam 10 "Outros tipos de família", add
*label values TipodeFam TipodeFam 

*povdeco RMDPCReal, pl(320.03) bygroup(TipodeFam)
********************************************************************************

********************************************************************************
***                           Grupos familiares                              ***
********************************************************************************
* ChefeMulherSoltCF ChefeMulherCasCF ChefeHomemCasCF ChefeMulherCasSF ChefeHomemCasSF ChefeGropoIdade2 ChefeGropoIdade3

*** Renda per capta dado o grupo familiar ***
sum RMDPCReal if ChefeMulherSoltCF==1
sum RMDPCReal if ChefeMulherCasCF==1
sum RMDPCReal if ChefeHomemCasCF==1
sum RMDPCReal if ChefeMulherCasSF==1
sum RMDPCReal if ChefeHomemCasSF==1
sum RMDPCReal if ChefeGropoIdade1==1
sum RMDPCReal if ChefeGropoIdade2==1
sum RMDPCReal if ChefeGropoIdade3==1
sum RMDPCReal if OutrosTipFam==1

sum RMDPCReal if ChefeMulherSoltCF==1, detail
sum RMDPCReal if ChefeMulherCasCF==1, detail
sum RMDPCReal if ChefeHomemCasCF==1, detail
sum RMDPCReal if ChefeMulherCasSF==1, detail
sum RMDPCReal if ChefeHomemCasSF==1, detail
sum RMDPCReal if ChefeGropoIdade1==1, detail
sum RMDPCReal if ChefeGropoIdade2==1, detail
sum RMDPCReal if ChefeGropoIdade3==1, detail
sum RMDPCReal if OutrosTipFam==1, detail
/// O Percentil 75% (ou terceiro quartil) da variavel é igual a XXXX, o que sig-
** nifica que 75% das observaçÕes são menores ou iguais a este valor. Já o per-
** centil 10 (ou primeiro decil) é igual a XXXX indicando que 10% das observa-
** ções são menores ou iguais a este valor.
/// A assimetria da variavel é igual a um numero positivo (negativo) indicando
** que a distribuição de tal variável tem uma assimetria positiva (negativa), o
** que quer dizer que temos uma concentraçao de frequência individuos com RMDPC
** mais reduzida (elevada).//

*** Tabela de proporções ***
tab ChefeMulherSoltCF
tab ChefeMulherCasCF
tab ChefeHomemCasCF
tab ChefeMulherCasSF
tab ChefeHomemCasSF
tab ChefeGropoIdade1
tab ChefeGropoIdade2
tab ChefeGropoIdade3
tab OutrosTipFam

*** Tabela de proporções ***
tab Ocupado if ChefeMulherSoltCF==1
tab Ocupado if ChefeMulherCasCF==1
tab Ocupado if ChefeHomemCasCF==1
tab Ocupado if ChefeMulherCasSF==1
tab Ocupado if ChefeHomemCasSF==1
tab Ocupado if ChefeGropoIdade1==1
tab Ocupado if ChefeGropoIdade2==1
tab Ocupado if ChefeGropoIdade3==1
tab Ocupado if OutrosTipFam==1

*** Proporção ***
/// Vantagem que há o intervalo de confiança.//
proportion ChefeMulherSoltCF
proportion ChefeMulherCasCF
proportion ChefeHomemCasCF
proportion ChefeMulherCasSF
proportion ChefeHomemCasSF
proportion ChefeGropoIdade1
proportion ChefeGropoIdade2
proportion ChefeGropoIdade3

*** Em relação as pessoas no lar ***
sum TotalMoradores
sum ProporcaoAdultos
sum numtotalfilhoV if numtotalfilhoV>0
tab numtotalfilhoV

svy: tab numtotalfilhoV

*** Controle de Fecundidade das mulheres ***
tab ControleFecundidade if Sexo==0
