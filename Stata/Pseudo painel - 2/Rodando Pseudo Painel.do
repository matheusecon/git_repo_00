******************************************
***Empilhando as bases de dados criadas***
******************************************
*Usando a seguinte pasta:
cd "C:\Users\Rafael Curi\Dropbox\Economia\Mestrado_UFV_2017\Econometria\Artigo Salario minimo\Dados coletados PNAD"
set more off
set memory 512m



***Empilhando os dados 2013 com 2014

use pes2013, clear
append using pes2014
save EmpPnad1314, replace


***Empilhando os dados 2013 & 2014 com 2015
use EmpPnad1314, clear
append using pes2015
save PnadEmp13a15, replace

**************************************************************************************************
*DROPAGEM DA RENDA PER CAPTA NÃO INFORMADA E DA QUE NÃO FAZ SENTIDO*******************************
**************************************************************************************************

drop if RendMensDom > 5000000
drop if RendMensDom == 999999999999

**dropando outliers da renda**
*geep if inrange (RendMensDom, 200, 20000)

**criando renda per capta**
**gen rendapercapta = vrfam/membrosf

**criando logaritmo da renda**
*gen lnRendMensDom = log10(RendMensDom)

*Dropando os individuos que têm menos de 17 anos e mais de 65 anos**
drop if AnoNasc < 1960 
drop if AnoNasc > 1998

*******************************************
*********GERAÇÃO DE DUMMIES****************
*******************************************

****************GERANDO DUMMIES DE ANO
gen D3 =.
replace D3 =1 if ano ==2013
replace D3 =0 if D3 ==.

gen D4=.
replace D4 =1 if ano ==2014
replace D4 =0 if D4 ==.


gen D5 =.
replace D5 =1 if ano ==2015
replace D5 =0 if D5 ==.

****************RECODIFICANDO DUMMIES 
**Sexo**
recode Sexo (2=1) (4=0)

**Cor**
 recode Cor (4=0) (2=1) (6=0) (8=0) (0=0) (9=0)
 
**mãe residente no domicílio**
 recode MoracMae (2=1) (4=0)

**Estado Civil**
 recode EstCiv (1=1) (3=0) (5=0) (7=0) (0=0)
 
**Tempo na UF**
 recode TempMoraUF (2=1) (.=0)
 
**Tempo no Município**
 recode TempMoraMun (2=1) (.=0)
 
**Sabe Ler ou Escrever**
 recode Alfabet (1=1) (3=0)
 
**Frequenta Escola ou Creche**
 recode Estud (2=1) (4=0) 
 
**Acesso a Internet nos Ultimos 3 Meses**
 recode AcesNet3m (1=1) (3=0)
 
**Cuidava dos afazeres domésticos na semana de referência**
 recode SeTrabDom (2=1) (4=0)

**Recebia normalmente rendimento que não era proveniente de trabalho**
 recode Pensao (2=1) (4=0)
 
**Recebia normalmente juros de caderneta de poupança ou de outras aplicações financeiras**
 recode SeRendFinanc (08=1) (.=0)
 
 **Numero de Filhos**
  recode NFilhosM (.=0)
  recode NFilhosF (.=0)
  gen numtotalfilho = NFilhosM + NFilhosF
  
  
 ** total dos anos de estudo ***
 recode TempoEstudo (1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6) (8=7) (9=8) (10=9) (11=10) (12=11) (13=12) (14=13) (15=14) (16=15)
 drop if TempoEstudo ==17
 
**Variáveis Dependentes**
recode EconAtiva (1=0) (2=1)
recode Desempreg (1=0) (2=1)


 ** CRIANDO A VARIÁVEL PESSOA DE REFERÊNCIA NO DOMICÍLIO **
 #delimit
gen ref =.;
replace ref = 1 if SePessRef==1;
replace ref = 0 if ref==.;
egen float fam = group(UF controle serie num_fam)
bysort fam: egen float referencia_fam = mean(ref)
#delimit cr

******REGIÕES BRASILEIRAS
*gen Reg1=UF
*gen Reg2=UF
*gen Reg3=UF
*gen Reg4=UF

*replace Reg1=0 if UF<=29
*replace Reg1=0 if UF>=41
*replace Reg1=1 if UF>=31 & UF<=35

*replace Reg2=0 if UF<=35
*replace Reg2=0 if UF>=50
*replace Reg2=1 if UF>=41 & UF<=43

*replace Reg3=0 if UF<=43
*replace Reg3=1 if UF>=50

*replace Reg4=0 if UF>=21
*replace Reg4=1 if UF<=17

 
************************************************************************************
************************************************************************************
****************************CRIANDO VAR COHORTS*************************************
************************************************************************************
************************************************************************************



gen nascimento=.
replace nascimento = 1 if AnoNasc >=1960 & AnoNasc <=1962
replace nascimento = 2 if AnoNasc >=1963 & AnoNasc <=1965
replace nascimento = 3 if AnoNasc >=1966 & AnoNasc <=1968
replace nascimento = 4 if AnoNasc >=1969 & AnoNasc <=1971
replace nascimento = 5 if AnoNasc >=1972 & AnoNasc <=1974
replace nascimento = 6 if AnoNasc >=1975 & AnoNasc <=1977
replace nascimento = 7 if AnoNasc >=1979 & AnoNasc <=1981
replace nascimento = 8 if AnoNasc >=1982 & AnoNasc <=1984
replace nascimento = 9 if AnoNasc >=1985 & AnoNasc <=1987
replace nascimento = 10 if AnoNasc >=1988 & AnoNasc <=1990
replace nascimento = 11 if AnoNasc >=1991 & AnoNasc <=1993
replace nascimento = 12 if AnoNasc >=1994 & AnoNasc <=1996
replace nascimento = 13 if AnoNasc >=1997 & AnoNasc <=1998

egen float cohorts = group(nascimento Sexo Cor UF)


sum cohorts
sum ano
order cohorts nascimento Sexo Cor UF
sort cohorts


collapse (mean) ano UF controle serie ordem Sexo DiaNasc MesNasc AnoNasc Idade ref CondFam Cor MoracMae EstCiv LugNasc TempMoraUF TempMoraMun Alfabet Estud AcesNet3m SeTrabDom Pensao SeRendFinanc numtotalfilho TempoEstudo RendMensDom EconAtiva Desempreg D3 D4 D5 pesopes [fw=pesopes], by(cohorts)

xtset cohorts ano
**Para analisar se a variavel dependente está balanceada ou não***

tab Desempreg
 

**Verificando o balanceamento do modelo**






