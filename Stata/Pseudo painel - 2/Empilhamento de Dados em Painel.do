******************************************
***Empilhando as bases de dados criadas***
******************************************
*Usando a seguinte pasta:
cd "C:\Users\Rafael Curi\Dropbox\Economia\Mestrado_UFV_2017\Econometria\Artigo Salario minimo\Dados coletados PNAD"
set more off
set memory 512m



***Empilhando os dados 2013 com 2014

use coortes_2013, clear
append using coortes_2014
save EmpPnad1314, replace


***Empilhando os dados 2013 & 2014 com 2015
use EmpPnad1314, clear
append using coortes_2015
save PnadEmp13a15, replace

**Gerando Renda Deflacionada**
gen RendaRealMPC = Deflacionamento * RMDPC

 
 