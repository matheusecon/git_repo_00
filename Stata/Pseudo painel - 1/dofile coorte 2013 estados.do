

***NOVO DOFILE 2013 CONSIDERANDO TODOS OS INDIVÍDUOS DOS ESTADOS, E NÃO MAIS AS RM´S***

**** dropando observações que não correspondem aos estados referentes às regiões metropolitanas de bh (MG), brasília (DF), são paulo (SP), recife (PE), porto alegre (RS) e salvador (BA)***

 drop if UF <26
 drop if UF ==27
 drop if UF ==28
 drop if UF ==32
 drop if UF ==33
 drop if UF ==41
 drop if UF ==42
 drop if UF ==50
 drop if UF ==51
 drop if UF ==52

 **** recodificando as demais variáveis binárias***
 
 **cor**
 recode Cor (4=0) (2=1) (6=0) (8=0) (0=0) (9=0)
 
 **sexo**
 recode Sexo (2=1) (4=0)
 
 **mãe residente no domicílio**
 recode maeres (2=1) (4=0)
 
 ** trabalho na semana de referência**
 recode trabalhosemref (3=0)
 
 **procurou trabalho nos ultimos 30 dias**
 recode proctrab30 (3=0)
 
 **procurou trabalho nos ultimos 305 dias**
 recode proctrab305 (2=1) (4=0)
 
 ** frequenta escola ***
 recode freqesc (2=1) (4=0)
 
 ** já frequentou escola? ***
 recode jafreqesc (2=1) (4=0)
 
 ** total dos anos de estudo ***
 recode Escol (1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6) (8=7) (9=8) (10=9) (11=10) (12=11) (13=12) (14=13) (15=14) (16=15)
 drop if Escol ==17
 
 **CRIANDO VARIÁVEL DESEMPREGO**
 
 gen desemprego =.
 ** desemprego na região metropolitana de bh para homens e mulheres**
 replace desemprego= 5.9 if UF ==31 & Sexo ==1 
 replace desemprego= 7.8 if UF ==31 & Sexo ==0 
 
 ** desemprego na região metropolitana de brasília para homens e mulheres**
 
 replace desemprego= 10.1 if UF ==53 & Sexo ==1
 replace desemprego= 14.9 if UF ==53 & Sexo ==0 
 
 ** desemprego na região metropolitana de são paulo para homens e mulheres**
 replace desemprego= 9.2 if UF ==35 & Sexo ==1
 replace desemprego= 11.8 if UF ==35 & Sexo ==0
 
 ** desemprego na região metropolitana de porto alegre para homens e mulheres **
 replace desemprego= 5.4 if UF ==43 & Sexo ==1
 replace desemprego= 7.5 if UF ==43 & Sexo ==0
 
 ** desemprego na região metropolitana de recife para homens e mulheres **
 replace desemprego= 10.8 if UF ==26 & Sexo ==1
 replace desemprego= 15.8 if UF ==26 & Sexo ==0
 
 ** desemprego na região metropolitana de salvador para homens e mulheres **
 replace desemprego= 14.7 if UF ==29 & Sexo ==1
 replace desemprego= 22.3 if UF ==29 & Sexo ==0
 
 ** CRIANDO A VARIÁVEL PESSOA DE REFERÊNCIA NA FAMÍLIA **
 #delimit
gen ref =.;
replace ref = 1 if CondF==1;
replace ref = 0 if ref==.;
egen float fam = group(UF controle serie num_fam)
bysort fam: egen float referencia_fam = mean(ref)
#delimit cr
 ** CRIANDO A VARIÁVEL SEXO DA PESSOA DE REFERÊNCIA DA FAMÍLIA***
 gen sexchefe =.
 replace sexchefe =1 if Sexo ==1 & referencia_fam ==1
 replace sexchefe =0 if Sexo ==0 & referencia_fam ==1
 bysort fam: egen float sexochefe = mean(sexchefe)
 
 *** CRIANDO A VARIÁVEL ESCOLARIDADE DO CHEFE DE FAMÍLIA ***
 gen escolref =.
 replace escolref =Escol if sexochefe ==1
 replace escolref =Escol if sexochefe ==0
 bysort fam: egen float escol_ref = mean(escolref)
 drop if escol_ref ==17
 
 **CRIANDO FAIXAS EDUCACIONAIS ***
 ** nenhuma ou quase nenhuma instrução**
 gen seminstrucao =.
 replace seminstrucao =0 if cursoelevado ==2|3|4|5|6|7|8|9
 replace seminstrucao =1 if jafreqesc ==0
 replace seminstrucao =1 if cursoelevado ==1
 replace seminstrucao =1 if cursoelevado ==10
 replace seminstrucao =1 if cursoelevado ==11
 replace seminstrucao =1 if cursoelevado ==12
 replace seminstrucao =1 if cursoelevado ==13
 
 **instrução fundamental **
 gen instrucaofun =.
  replace instrucaofun =0 if cursoelevado ==1|3|5|7|8|9|10|11|12|13
 replace instrucaofun =1 if cursoelevado ==2
 replace instrucaofun =1 if cursoelevado ==4
 replace instrucaofun =1 if cursoelevado ==6


 ** instrução média ***
 gen instrucaomed =.
 replace instrucaomed =0 if cursoelevado ==1|2|4|6|8|9|10|11|12|13
 replace instrucaomed =1 if cursoelevado ==3
 replace instrucaomed =1 if cursoelevado ==5
 replace instrucaomed =1 if cursoelevado ==7
 
 
 ** instrução superior **
 gen instrucaosup =.
 replace instrucaosup =0 if cursoelevado ==1|2|3|4|5|6|7|10|11|12|13
 replace instrucaosup =1 if cursoelevado ==8
 replace instrucaosup =1 if cursoelevado ==9

 
 ** CRIANDO FAIXA EDUCACIONAL DO CHEFE DE FAMÍLIA DO SEXO MASCULINO ***
 **chefe de família do sexo masculino que não possui nenhuma ou quase nenhuma instrução **
 gen chefemseminstrucao =.
 replace chefemseminstrucao =1 if seminstrucao ==1 & Sexo ==1 & ref ==1
 replace chefemseminstrucao =0 if chefemseminstrucao ==.
 bysort fam: egen float chefem_seminstrucao = mean(chefemseminstrucao)
 
 ** chefe de família do sexo masculino que possui instrução fundamental **
 gen chefeminstrucaofun =.
 replace chefeminstrucaofun =1 if instrucaofun ==1 & Sexo ==1 & ref ==1
 replace chefeminstrucaofun =0 if chefeminstrucaofun ==.
 bysort fam: egen float chefem_instrucaofun = mean(chefeminstrucaofun)
 
 ** chefe de família do sexo masculino que possui instrução média **
 gen chefeminstrucaomed =.
 replace chefeminstrucaomed =1 if instrucaomed ==1 & Sexo ==1 & ref ==1
 replace chefeminstrucaomed =0 if chefeminstrucaomed ==.
 bysort fam: egen float chefem_instrucaomed = mean(chefeminstrucaomed)
 
 ** chefe de família do sexo masculino que possui instrução superior **
 gen chefeminstrucaosup =.
 replace chefeminstrucaosup =1 if instrucaosup ==1 & Sexo ==1 & ref ==1
 replace chefeminstrucaosup =0 if chefeminstrucaosup ==.
 bysort fam: egen float chefem_instrucaosup = mean(chefeminstrucaosup)
 
 ** CRIANDO FAIXA EDUCACIONAL DO CHEFE DE FAMÍLIA DO SEXO FEMININO **
 ** chefe de família do sexo feminino que não possui nenhuma ou quase nenhuma instrução **
 gen chefefseminstrucao =.
 replace chefefseminstrucao =1 if seminstrucao ==1 & Sexo ==0 & ref ==1
 replace chefefseminstrucao =0 if chefefseminstrucao ==.
 bysort fam: egen float chefef_seminstrucao = mean(chefefseminstrucao)
 
 ** chefe de família do sexo feminino que possui instrução fundamental **
 gen chefefinstrucaofun =.
 replace chefefinstrucaofun =1 if instrucaofun ==1 & Sexo ==0 & ref ==1
 replace chefefinstrucaofun =0 if chefefinstrucaofun ==.
 bysort fam: egen float chefef_instrucaofun = mean(chefefinstrucaofun)
 
 ** chefe de família do sexo feminino que possui instrução média **
 gen chefefinstrucaomed =.
 replace chefefinstrucaomed =1 if instrucaomed ==1 & Sexo ==0 & ref ==1
 replace chefefinstrucaomed =0 if chefefinstrucaomed ==.
 bysort fam: egen float chefef_instrucaomed = mean(chefefinstrucaomed)
 
 ** chefe de família do sexo feminino que possui instrução superior **
 gen chefefinstrucaosup =.
 replace chefefinstrucaosup =1 if instrucaosup ==1 & Sexo ==0 & ref ==1
 replace chefefinstrucaosup =0 if chefefinstrucaosup ==.
 bysort fam: egen float chefef_instrucaosup = mean(chefefinstrucaosup)
 

 *** GERANDO VARIÁVEIS DEPENDENTES ***
*** indivíduos que trabalham e estudam não devem participar da amostra, visto que possíveis crises não os afetam ***
 ***gerando variável referente aos indivíduos que trabalham e estudam. procedimento realizado somente para dropar tais indivíduos***
 
 drop if trabalhosemref+freqesc ==2
 drop if trabalhosemref+proctrab30+freqesc ==0
 
 ** proximo procedimento é definir a variável binária se o indivíduo estuda ou não. Ele pode estar tanto trabalhando quanto sem nenhuma ocupação ***
 ***gerando variável dependente referente aos indivíduos que não trabalham e nem estudam***
 
 ***gerando variável dependente referente aos indivíduos que só estudam***
 gen estuda =.
 replace estuda =1 if freqesc ==1 
 replace estuda =0 if estuda ==.
 bysort controle serie
  
 ** GERANDO DUMMIES PARA REGIÕES METROPOLITANAS ***
 *** BELO HORIZONTE ***
 gen bh=.
 replace bh =1 if UF ==31
 replace bh =0 if UF ~=31
 
 *** BRASÍLIA ***
gen bras =.
replace bras =1 if UF ==53
replace bras =0 if UF ~=53

*** SÃO PAULO ***
gen sp =.
replace sp =1 if UF ==35
replace sp =0 if UF ~=35

*** PORTO ALEGRE ***
gen porto =.
replace porto =1 if UF ==43
replace porto =0 if UF ~=43

*** RECIFE ***
gen reci =.
replace reci =1 if UF ==26
replace reci =0 if UF ~=26

***SAlVALDOR ***
gen salva =.
replace salva =1 if UF ==29
replace salva =0 if UF ~=29
 
*** dropando os indivíduos que não tem entre 17 e 25 anos ***

drop if nascdata <1988
drop if nascdata >1996
drop if Idade ==16

**dropando outliers da renda**
geep if inrange (vrfam, 200, 20000)

**criando renda per capta**
gen rendapercapta = vrfam/membrosf

**criando logaritmo da renda**
gen lnrendapercapta = log10(rendapercapta)

************************************************************************************
************************************************************************************
****************************CRIANDO VAR COHORTS*************************************
************************************************************************************
************************************************************************************

gen nascimento=.
replace nascimento = 1 if nascdata >=1988 & nascdata <=1990
replace nascimento = 2 if nascdata >=1991 & nascdata <=1993
replace nascimento = 3 if nascdata >=1994 & nascdata <=1996


egen float cohorts = group(nascimento Sexo Cor UF)


sum cohorts
sum ano
order cohorts nascimento Sexo Cor UF
sort cohorts


collapse (mean) ano estuda Cor Sexo vrfam rendapercapta lnrendapercapta maeres desemprego membrosf sexochefe escol_ref chefem_seminstrucao chefem_instrucaofun chefem_instrucaomed chefem_instrucaosup chefef_seminstrucao chefef_instrucaofun chefef_instrucaomed chefef_instrucaosup bh bras sp porto reci salva nascimento pesopes [fw=pesopes], by(cohorts)
