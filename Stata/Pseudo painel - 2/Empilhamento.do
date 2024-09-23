**************PROGRAMA PARA EMPILHAMENTO DE DADOS DE DIFERENTES PNADS
cd "C:\Users\Jader F. Cirino\Desktop\Jader W8\Mini Curso PNAD Jader"
set more off
set memory 512m

****Extraindo dados de 2011
clear
#delimit;
infix ano 1-4 UF 5-6 controle 5-12 serie 13-15 using "C:\Users\Jader F. Cirino\Desktop\Jader W8\Mini Curso PNAD Jader\PES2011.txt",clear; 
#delimit cr
save emp2011, replace


****Extraindo dados de 2012
clear
#delimit;
infix ano 1-4 UF 5-6 controle 5-12 serie 13-15 using "C:\Users\Jader F. Cirino\Desktop\Jader W8\Mini Curso PNAD Jader\PES2012.txt",clear;
#delimit cr
save emp2012, replace

****Extraindo dados de 2013
clear
#delimit;
infix ano 1-4 UF 5-6 controle 5-12 serie 13-15 using "C:\Users\Jader F. Cirino\Desktop\Jader W8\Mini Curso PNAD Jader\Dados 2013 atualizados\PES2013.txt",clear; 
#delimit cr
save emp2013, replace


***Empilhando os dados 2011 com 2012

use emp2011, clear
append using emp2012
save pnademp, replace


***Empilhando os dados 2011 & 2012 com 2013
use pnademp, clear
append using emp2013
save pnademp2, replace






  

