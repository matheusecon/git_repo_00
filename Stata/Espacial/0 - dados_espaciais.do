/*

*********   Mapas para todo o território brasileiro

ftp://geoftp.ibge.gov.br/organizacao_do_territorio/malhas_territoriais/malhas_municipais/municipio_2017/Brasil/BR/


*********   Mapas para cada estado

ftp://geoftp.ibge.gov.br/organizacao_do_territorio/malhas_territoriais/malhas_municipais/municipio_2017/UFs/


********* Mapas para divisões intramunicipais

ftp://geoftp.ibge.gov.br/organizacao_do_territorio/malhas_territoriais/malhas_de_setores_censitarios__divisoes_intramunicipais/


*/


cd "C:\Users\Economia.LAB01-21\Desktop\Curso Pós Graduação 2018\Dados"



************************     Municípios       **********************************
/*
clear

spshape2dta BRMUE250GC_SIR, saving(mun) replace

use mun, clear

spset
*/
********************************************************************************

****************************     Estados     ***********************************

clear

spshape2dta BRUFE250GC_SIR, saving(uf) replace

use uf

spset

gen n = _n

grmap, activate
grmap n

********************************************************************************

****************************     Mesorregiões      *****************************

*clear

*spshape2dta BRMEE250GC_SIR, saving(meso) replace


*use meso

*spset


********************************************************************************

****************************     Microrregiões       ***************************

*clear

*spshape2dta BRMIE250GC_SIR, saving(micro) replace


*use micro

*spset

********************************************************************************

****** Transformar um shape de Estado em um shape de Regiões

use uf, clear

mergepoly using uf_shp.dta, by(NM_REGIAO) coor(regiao_shp.dta) replace

spset _ID

spset , shpfile(regiao_shp.dta) modify
save regiao, replace


gen teste= _n

grmap teste





********************************************************************************
***** Transformar um shape com todos os Estados do Brasil em um shape apenas 
***** com os Estados do Sudeste

use uf, clear
keep if NM_REGIAO == "SUDESTE"
save sudeste, replace

spcompress


 gen teste = _n
 
 grmap teste
********************************************************************************
***** Merge do shape com a base de dados

use uf, clear


codebook CD_GEOCUF
destring CD_GEOCUF, replace
ren CD_GEOCUF cod_uf

merge 1:1 cod_uf using pnad

drop _merge

save pnad_espacial, replace

spset



