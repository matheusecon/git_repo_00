*************************************************************
* PREPARACAO DE DADOS PNAD 2013
*************************************************************

cd "C:\Users\Rafael Curi\Dropbox\Economia\Mestrado - UFV 2017\PNAD\PNAD_2013\Dados"

set more off
set memory 512m
 
* LEITURA DAS INFORMACOES DO DESENHO DA AMOSTRA NO ARQUIVO DE DOMICILIOS
*ESSAS LINHAS PERMANECEM FIXAS
clear
#delimit;
infix ano 1-4 UF 5-6 controle 5-12 serie 13-15  tipo 16-17   
strat 178-184 psu 185-191 
using "C:\Users\Rafael Curi\Dropbox\Economia\Mestrado - UFV 2017\PNAD\PNAD_2013\Dados\DOM2013.txt",clear;
#delimit cr


************ORDENAR OS DADOS*************

#delimit;
sort controle serie, stable;
format controle %15.0g;
format serie %15.0g;
replace controle = float(controle);
replace serie = float(serie);
#delimit cr

save dom2013, replace

**comando sort organiza as observaçoes dos dados atuais em ordem ascendente baseado nos valores das variaveis em varlist
*** neste caso controle e serie sao as variaveis usadas como referencia

* LEITURA DOS DADOS DAS PESSOAS 2013

clear
#delimit;
infix ano 1-4 UF 5-6 controle 5-12 serie 13-15 

ordem 16-17 Sexo 18-18 DiaNasc 19-20 MesNasc 21-22 AnoNasc 23-26 Idade 27-29

SePessRef 30-30 CondFam 31-31 Cor 33-33 MoracMae 35-35 EstCiv 43-43 

LugNasc 47-48 TempMoraUF 51-51 TempMoraMun 63-63 

Alfabet 69-69 Estud 70-70 

AcesNet3m 86-86

******VARIÁVEIS ESPECÍFICAS REFERENTES A EMPREGO*********
SeTrabDom 150-150
*TrabSemRef 154-154 TrabRoçaAuto 156-156 TrabObraAuto 157-157 NumdeTrabEx 158-158 CodOcupTrabPrim 159-162 CodAtivPrinc 163-167 CargTrabPrinAgric 168-169 ParcePatraoAgric 171-171 RespDomTrabAgric 172-172 RespIntTrabAgrig 173-173 PatraoAgric 233-233 CargTrabPrin 302-302 
*TrabDia 303-303 TrabNoite 304-304 PrivPubl 305-305 AreaEst 306-306 Milico 307-307 FuncPubl 308-308 Domes 309-309 Domes1xSem 310-310 DomesNumDiasSem 311-311 DomesNumDiasMes 312-312 DomVulnerav 314-314 DomesCartAssin 315-315 PatraoNAgric 321-321 RendDinPatrao 327-338 
*RendMercPatrao 340-351 EmpTrabCNPJ 353-353 EmpTrabContrChq 355-355 TrabEstab 356-356 TempoAteTrab 359-359 HorasTrabSem 360-361 ContrPrev 362-362 AnosTrabPrinc 364-365 MesesTrabPrinc 366-367 DesempAnoCapt 368-368 NumTrabSaiuAnoCapt 369-369 CartAssinUltTrab 372-372 
*SegDesempUltTrab 373-373 DesempSemCaptTrabAno 374-374 NumTrabSaiuAnoCapt 377-377 TipoTrabAntNAgric 392-392 SetUltEmp 393-393 AreaUltEmp 394-394 MilicoUltEmp 395-395 FunPublicUltEmp 396-396 DomUltEmp 
*EmpSindic 405-405 IdadeComTrab 408-408 RendTrabSec 426-437 Rend3Trab 470-481 DesempTrabRoca 489-489 DesempTrabObra 490-490 AnosDesemp 491-492 MesesDesemp 493-494 DesempProvTrab 511-511 DonaDeCasa 513-513 DesempAposent 516-516 DesempPensio 517-517 
Pensao 518-518 
*ValorPensao 535-546 ValorOutraAposent 549-560 RendOutraPensao 563-574 RendPerman 577-588 RendAlug 591-602 RendDoacao 605-616 JurosPoup 619-630 
SeRendFinanc 617-618
*******************************************

NFilhosM 633-634 NFilhosF 635-636 
*MesNascFilho 650-651 AnoNascFilho 652-655

TempoEstudo 669-670
*CartAssin 673-674 (não é certeza)
RendMensDom 727-738


**IMPORTANTE (VARIÁVEL DEPENDENTE)
EconAtiva 671-671
Desempreg 672-672



 



pesopes 757-761 pesofam 762-766

using "C:\Users\Rafael Curi\Dropbox\Economia\Mestrado - UFV 2017\PNAD\PNAD_2013\Dados\PES2013.txt",clear;
#delimit cr 


*****JUNÇÃO DAS INFORMAÇÕES DE DESENHO DA AMOSTRA AO ARQUIVO DE PESSOAS DA PNAD 2013*********
**********Joinby
#delimit;
sort controle serie, stable;
joinby controle serie using dom2013;
#delimit cr

save pes2013, replace

* DECLARANDO/SETANDO O CONJUNTO DE DADOS COMO SENDO DE AMOSTRA COMPLEXA

clear
use pes2013, clear

svyset psu [pweight=pesopes], strata(strat) vce(linearized) || _n

svydes, single

save pes2013, replace


* ROTINA DE ALOCACAO DE ESTRATOS COM UM UNICO PSU EM ESTRATOS COM MAIOR NUMERO
* DE OBSERVACOES UTILIZANDO O DO.FILE idonepsu - ANO DE 2013

use pes2013, clear

*findit idonepsu (primeira vez que usar)
* Instalar o idonepsu (primeira vez que usar
*o comando: findit idonepsu 

#delimit;
idonepsu, strata(strat) psu(psu) generate(new);
drop strat psu;
rename newstr strat;
rename newpsu psu;
#delimit cr

svyset psu [pweight=pesopes], strata(strat) vce(linearized) || _n

svydes, single

save pes2013, replace


*OBSERVAÇÕES QUE AINDA ESTÃO COM PSU ÚNICO MESMO APÓS UTILIZAÇÃO DO IDONEPSU
svydes, finalstage

*tem-se que eliminar obs=1, sendo unit = PSU

#delimit;
drop if strat == 230006  & psu == 115;
drop if strat == 290003  & psu == 35;
drop if strat == 330026  & psu == 326;
drop if strat == 350027  & psu == 186;
drop if strat == 350034  & psu == 238 
#delimit cr

*convém rodar idonepsu de novo para checar se ao apagar um estrato surgiram outros de psu único.



*ANÁLISE DE REGRESSÃO
drop if VRTP > 5000000 & VRTP!=.
svy: regress VRTP Idade
estat effects, meff // para analisar o efeito do plano amostral!

* Para comparação

regress VRTP Idade

* Efeitos marginais com MFX 
mfx compute, dydx at(mean)

* Elasticidades com MFX
mfx compute, eyex at(mean)





  











