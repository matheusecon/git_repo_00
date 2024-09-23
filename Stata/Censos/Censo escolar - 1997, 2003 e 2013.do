*/////////////////////////////////////////////////////////////////////////////////////
* Este programa tem por objetivo a obtenção do indicador de infraestrutura escolar dos
* municípios do Ceará a partir dos microdados dos Censos Escolares de 1997, 2003 e 2013,
* que foram utilizados na tese como proxy dos anos de 1991, 2000 e 2010.
* Elaborado por: Francisco Diniz Bezerra - Doutorando PRODEMA/UFC
* Data: junho/2015
* Base de dados: microdados dos Censos Escolares de 1997, 2003 e 2013
* Software Stata Versão 12
*/////////////////////////////////////////////////////////////////////////////////////
*/////////////////////////////////////////////////////////////////////////////////////
**********************************************************************
* ROTINA 1
* INFRAESTRUTURA ESCOLAR DOS MUNICÍPIOS DO CEARÁ - 1997
* (PROXY PARA 1991)
**********************************************************************
* Leitura dos microdados a partir do arquivo .txt original
cd "C:\Users\FDiniz\Documents\Programa_IPM\Inep\Censo_Escolar_1997"
clear
infix MASCARA 1-8 ANO 9-16 str SIGLA 79-80 str MUNIC 81-130 ///
str CODFUNC 151-161 str AGUA_INE 359-359 ///
str ESG_INEX 362-362 str ENER_INE 344-344 str SANI_DEN 236-236 ///
str SANI_FOR 237-237 str SANI_PRE 238-238 str SANI_ESP 239-239 ///
str PRED_ESC 184-184 str BIBLIO 225-225 str DIRETORI 223-223 ///
str LAB_CIEN 226-226 str LAB_INFO 227-227 str COZINHA 228-228 ///
str QUADRA 232-232 COMPPEN 246-253 PC486386 254-261 COMPOUTR 262-269 ///
VPE221 619-626 VPE225 627-634 VPE226 635-642 VEF221 1059-1066 ///
VEF222 1067-1074 VEF223 1075-1082 VEF224 1083-1090 VEF225 1091-1098 ///
VEF226 1099-1106 VEF227 1107-1114 VEF228 1115-1122 VEM221 1843-1850 ///
VEM222 1851-1858 VEM223 1859-1866 VEM224 1867-1874 VEM225 1875-1882 ///
VES711 2443-2450 VES712 2451-2458 VES713 2459-2466 VES714 2467-2474 ///
VES715 2475-2482 VES911 2507-2514 VES912 2515-2522 VES913 2523-2530 ///
using DADOS_CENSOESC_1997.txt
**********************************************************************
* Seleção de dados do Estado do Ceará e escolas em funcionamento
keep if SIGLA == "CE"
keep if CODFUNC == "Ativo"
**********************************************************************
* Transformando missing em zero (programa não aceita somar missing)
replace VPE221 = 0 if VPE221 == .
replace VPE225 = 0 if VPE225 == .
replace VPE226 = 0 if VPE226 == .
replace VEF221 = 0 if VEF221 == .
replace VEF222 = 0 if VEF222 == .
replace VEF223 = 0 if VEF223 == .
replace VEF224 = 0 if VEF224 == .
replace VEF225 = 0 if VEF225 == .
replace VEF226 = 0 if VEF226 == .
replace VEF227 = 0 if VEF227 == .
replace VEF228 = 0 if VEF228 == .
replace VEM221 = 0 if VEM221 == .
replace VEM222 = 0 if VEM222 == .
replace VEM223 = 0 if VEM223 == .
replace VEM224 = 0 if VEM224 == .
replace VEM225 = 0 if VEM225 == .
replace VES711 = 0 if VES711 == .
replace VES712 = 0 if VES712 == .
replace VES713 = 0 if VES713 == .
replace VES714 = 0 if VES714 == .
replace VES715 = 0 if VES715 == .
replace VES911 = 0 if VES911 == .
replace VES912 = 0 if VES912 == .
replace VES913 = 0 if VES913 == .
**********************************************************************
* Adequando variáveis para o cálculo do indicador de infraestrutura
gen TEM_AGUA = .
replace TEM_AGUA = 1 if AGUA_INE == "n"
replace TEM_AGUA = 0 if AGUA_INE == "s"
gen TEM_ESGOTO = .
replace TEM_ESGOTO = 1 if ESG_INEX == "n"
replace TEM_ESGOTO = 0 if ESG_INEX == "s"
gen TEM_ENERGIA_ELET = .
replace TEM_ENERGIA_ELET = 1 if ENER_INE == "n"
replace TEM_ENERGIA_ELET = 0 if ENER_INE == "s"
gen TEM_SANITARIO = .
replace TEM_SANITARIO = 1 if SANI_DEN == "s" | SANI_FOR == "s" | ///
SANI_PRE == "s" | SANI_ESP == "s"
replace TEM_SANITARIO = 0 if SANI_DEN == "n" & SANI_FOR == "n" & ///
SANI_PRE == "n" & SANI_ESP == "n"
gen TEM_PRED_ESC = .
replace TEM_PRED_ESC = 1 if PRED_ESC == "s"
replace TEM_PRED_ESC = 0 if PRED_ESC == "n"
gen TEM_BIBL_SALA_LEIT = .
replace TEM_BIBL_SALA_LEIT = 1 if BIBLIO == "s"
replace TEM_BIBL_SALA_LEIT = 0 if BIBLIO == "n"
gen TEM_DIRETORIA = .
replace TEM_DIRETORIA = 1 if DIRETORI == "s"
replace TEM_DIRETORIA = 0 if DIRETORI == "n"
gen TEM_LAB_CIEN = .
replace TEM_LAB_CIEN = 1 if LAB_CIEN == "s"
replace TEM_LAB_CIEN = 0 if LAB_CIEN == "n"
gen TEM_LAB_INFO = .
replace TEM_LAB_INFO = 1 if LAB_INFO == "s"
replace TEM_LAB_INFO = 0 if LAB_INFO == "n"
gen TEM_COZINHA = .
replace TEM_COZINHA = 1 if COZINHA == "s"
replace TEM_COZINHA = 0 if COZINHA == "n"
gen TEM_QUADRA = .
replace TEM_QUADRA = 1 if QUADRA == "s"
replace TEM_QUADRA = 0 if QUADRA == "n"
gen TEM_COMPUTADOR = .
replace TEM_COMPUTADOR = 1 if COMPPEN + PC486386 + COMPOUTR > 0
replace TEM_COMPUTADOR = 0 if COMPPEN + PC486386 + COMPOUTR == 0
gen ACESSO_INTERNET = 0
**********************************************************************
* Cálculo do indicador de infraestrutura das escolas (cada item = 1 ponto)
gen infra_servbas_esc = .
replace infra_servbas_esc = TEM_AGUA + TEM_ESGOTO + ///
TEM_ENERGIA_ELET + TEM_SANITARIO
gen infra_escola = .
replace infra_escola = TEM_PRED_ESC + TEM_BIBL_SALA_LEIT + ///
TEM_DIRETORIA + TEM_LAB_CIEN + TEM_LAB_INFO + TEM_COZINHA + ///
TEM_QUADRA + TEM_COMPUTADOR + ACESSO_INTERNET
gen total_infra_escola = .
replace total_infra_escola = infra_servbas_esc + infra_escola
**********************************************************************
* Obtendo totais de alunos em cada série da escola
gen total_alu_escola = .
replace total_alu_escola = VPE221 + VPE225 + VPE226 + VEF221 + ///
VEF222 + VEF223 + VEF224 + VEF225 + VEF226 + VEF227 + VEF228 + ///
VEM221 + VEM222 + VEM223 + VEM224 + VEM225 + VES711 + VES712 + ///
VES713 + VES714 + VES715 + VES911 + VES912 + VES913
**********************************************************************
* Obtendo de número auxiliar para ponderação
gen auxiliar_infra = total_alu_escola * total_infra_escola
**********************************************************************
* Salvando arquivo de trabalho
save censo_escolar_1997_ceara, replace
**********************************************************************
* Agregando dados das escolas por município
collapse (sum) total_alu_escola auxiliar_infra, by(MUNIC)
**********************************************************************
* Cálculo do indicador de infra-estrutura escolar municipal
gen infra_esc_mun = auxiliar_infra / total_alu_escola
drop total_alu_escola auxiliar_infra
**********************************************************************
* Salvando arquivo de dados dos município
save infra_escolas_1997_mun, replace
**********************************************************************
*/////////////////////////////////////////////////////////////////////////////////////
*/////////////////////////////////////////////////////////////////////////////////////
**********************************************************************
* ROTINA 2
* INFRAESTRUTURA ESCOLAR DOS MUNICÍPIOS DO CEARÁ - 2003
* (PROXY PARA 2000)
**********************************************************************
* Leitura dos microdados a partir do arquivo .txt original
cd "C:\Users\FDiniz\Documents\Programa_IPM\Inep\Censo_Escolar_2003"
clear
infix MASCARA 1-8 ANO 9-13 str CODMUNIC 14-25 str UF 26-75 ///
str SIGLA 76-77 str MUNIC 78-127 str CODFUNC 148-158 ///
str PRED_ESC 188-188 str DIRETORI 203-203 str BIBLIOTE 206-206 ///
str SALA_LEI 209-209 str COZINHA 210-210 str LAB_INFO 215-215 ///
str LAB_CIEN 216-216 str QUAD_DES 221-221 str QUAD_COB 222-222 ///
str SANI_FOR 224-224 str SANI_DEN 225-225 str SANI_PRE 226-226 ///
str SANI_ESP 227-227 COMPPENT 328-334 PC486386 335-341 ///
COMPOUTR 342-348 str INTERNET 357-357 str ENER_INE 367-367 ///
str AGUA_INE 382-382 str ESG_INEX 385-385 ///
DPE119 1313-1319 DPE11D 1327-1333 NPE119 1341-1347 ///
NPE11D 1355-1361 DCA114 1579-1585 NCA114 1593-1599 ///
DEM118 5772-5778 DEM119 5779-5785 DEM11A 5786-5792 ///
DEM11B 5793-5799 DEM11C 5800-5806 NEM118 5842-5848 ///
NEM119 5849-5855 NEM11A 5856-5862 NEM11B 5863-5869 ///
NEM11C 5870-5876 DCN118 7508-7514 DCN119 7515-7521 ///
DCN11A 7522-7528 DCN11B 7529-7535 DCN11C 7536-7542 ///
NCN118 7578-7584 NCN119 7585-7591 NCN11A 7592-7598 ///
NCN11B 7599-7605 NCN11C 7606-7612 DES1017 11302-11308 ///
DES1018 11309-11315 DES1019 11316-11322 DES101A 11323-11329 ///
NES1017 11330-11336 NES1018 11337-11343 NES1019 11344-11350 ///
NES101A 11351-11357 DEF11C 1808-1814 DEF11D 1815-1821 ///
DEF11E 1822-1828 DEF11F 1829-1835 DEF11G 1836-1842 ///
DEF11H 1843-1849 DEF11I 1850-1856 DEF11J 1857-1863 ///
NEF11C 1934-1940 NEF11D 1941-1947 NEF11E 1948-1954 ///
NEF11F 1955-1961 NEF11G 1962-1968 NEF11H 1969-1975 ///
NEF11I 1976-1982 NEF11J 1983-1989 using DADOS_CENSOESC_2003.txt
**********************************************************************
* Seleção de dados do Estado do Ceará e escolas em funcionamento
keep if SIGLA == "CE"
keep if CODFUNC == "Ativo"
**********************************************************************
* Transformando missing em zero (programa não aceita somar missing)
replace DPE119 = 0 if DPE119 == .
replace DPE11D = 0 if DPE11D == .
replace NPE119 = 0 if NPE119 == .
replace NPE11D = 0 if NPE11D == .
replace DCA114 = 0 if DCA114 == .
replace NCA114 = 0 if NCA114 == .
replace DEF11C = 0 if DEF11C == .
replace DEF11D = 0 if DEF11D == .
replace DEF11E = 0 if DEF11E == .
replace DEF11F = 0 if DEF11F == .
replace DEF11G = 0 if DEF11G == .
replace DEF11H = 0 if DEF11H == .
replace DEF11I = 0 if DEF11I == .
replace DEF11J = 0 if DEF11J == .
replace NEF11C = 0 if NEF11C == .
replace NEF11D = 0 if NEF11D == .
replace NEF11E = 0 if NEF11E == .
replace NEF11F = 0 if NEF11F == .
replace NEF11G = 0 if NEF11G == .
replace NEF11H = 0 if NEF11H == .
replace NEF11I = 0 if NEF11I == .
replace NEF11J = 0 if NEF11J == .
replace DEM118 = 0 if DEM118 == .
replace DEM119 = 0 if DEM119 == .
replace DEM11A = 0 if DEM11A == .
replace DEM11B = 0 if DEM11B == .
replace DEM11C = 0 if DEM11C == .
replace NEM118 = 0 if NEM118 == .
replace NEM119 = 0 if NEM119 == .
replace NEM11A = 0 if NEM11A == .
replace NEM11B = 0 if NEM11B == .
replace NEM11C = 0 if NEM11C == .
replace DCN118 = 0 if DCN118 == .
replace DCN119 = 0 if DCN119 == .
replace DCN11A = 0 if DCN11A == .
replace DCN11B = 0 if DCN11B == .
replace DCN11C = 0 if DCN11C == .
replace NCN118 = 0 if NCN118 == .
replace NCN119 = 0 if NCN119 == .
replace NCN11A = 0 if NCN11A == .
replace NCN11B = 0 if NCN11B == .
replace NCN11C = 0 if NCN11C == .
replace DES1017 = 0 if DES1017 == .
replace DES1018 = 0 if DES1018 == .
replace DES1019 = 0 if DES1019 == .
replace DES101A = 0 if DES101A == .
replace NES1017 = 0 if NES1017 == .
replace NES1018 = 0 if NES1018 == .
replace NES1019 = 0 if NES1019 == .
replace NES101A = 0 if NES101A == .
**********************************************************************
* Adequando variáveis para o cálculo do indicador de infraestrutura
gen TEM_AGUA = .
replace TEM_AGUA = 1 if AGUA_INE == "n"
replace TEM_AGUA = 0 if AGUA_INE == "s"
gen TEM_ESGOTO = .
replace TEM_ESGOTO = 1 if ESG_INEX == "n"
replace TEM_ESGOTO = 0 if ESG_INEX == "s"
gen TEM_ENERGIA_ELET = .
replace TEM_ENERGIA_ELET = 1 if ENER_INE == "n"
replace TEM_ENERGIA_ELET = 0 if ENER_INE == "s"
gen TEM_SANITARIO = .
replace TEM_SANITARIO = 1 if SANI_DEN == "s" | SANI_FOR == "s" | ///
SANI_PRE == "s" | SANI_ESP == "s"
replace TEM_SANITARIO = 0 if SANI_DEN == "n" & SANI_FOR == "n" & ///
SANI_PRE == "n" & SANI_ESP == "n"
gen TEM_PRED_ESC = .
replace TEM_PRED_ESC = 1 if PRED_ESC == "s"
replace TEM_PRED_ESC = 0 if PRED_ESC == "n"
gen TEM_BIBL_SALA_LEIT = .
replace TEM_BIBL_SALA_LEIT = 1 if BIBLIOTE == "s" | SALA_LEI == "s"
replace TEM_BIBL_SALA_LEIT = 0 if BIBLIOTE == "n" & SALA_LEI == "n"
gen TEM_DIRETORIA = .
replace TEM_DIRETORIA = 1 if DIRETORI == "s"
replace TEM_DIRETORIA = 0 if DIRETORI == "n"
gen TEM_LAB_CIEN = .
replace TEM_LAB_CIEN = 1 if LAB_CIEN == "s"
replace TEM_LAB_CIEN = 0 if LAB_CIEN == "n"
gen TEM_LAB_INFO = .
replace TEM_LAB_INFO = 1 if LAB_INFO == "s"
replace TEM_LAB_INFO = 0 if LAB_INFO == "n"
gen TEM_COZINHA = .
replace TEM_COZINHA = 1 if COZINHA == "s"
replace TEM_COZINHA = 0 if COZINHA == "n"
gen TEM_QUADRA = .
replace TEM_QUADRA = 1 if QUAD_DES == "s" | QUAD_COB == "s"
replace TEM_QUADRA = 0 if QUAD_DES == "n" & QUAD_COB == "n"
gen TEM_COMPUTADOR = .
replace COMPPEN = 0 if COMPPEN == .
replace PC486386 = 0 if PC486386 == .
replace COMPOUTR = 0 if COMPOUTR == .
replace TEM_COMPUTADOR = 1 if COMPPEN + PC486386 + COMPOUTR > 0
replace TEM_COMPUTADOR = 0 if COMPPEN + PC486386 + COMPOUTR == 0
gen ACESSO_INTERNET = 0
replace ACESSO_INTERNET = 1 if INTERNET == "s"
**********************************************************************
* Cálculo do indicador de infraestrutura das escolas
* (cada item = 1 ponto)
gen infra_servbas_esc = .
replace infra_servbas_esc = TEM_AGUA + TEM_ESGOTO + ///
TEM_ENERGIA_ELET + TEM_SANITARIO
gen infra_escola = .
replace infra_escola = TEM_PRED_ESC + TEM_BIBL_SALA_LEIT + ///
TEM_DIRETORIA + TEM_LAB_CIEN + TEM_LAB_INFO + TEM_COZINHA + ///
TEM_QUADRA + TEM_COMPUTADOR + ACESSO_INTERNET
gen total_infra_escola = .
replace total_infra_escola = infra_servbas_esc + infra_escola
**********************************************************************
* Obtendo totais de alunos em cada série da escola
gen total_alu_escola = DPE119 + DPE11D + NPE119 + NPE11D + ///
DCA114 + NCA114 + DEF11C + DEF11D + DEF11E + DEF11F + DEF11G + ///
DEF11H + DEF11I + DEF11J + NEF11C + NEF11D + NEF11E + NEF11F + ///
NEF11G + NEF11H + NEF11I + NEF11J + DEM118 + DEM119 + DEM11A + ///
DEM11B + DEM11C + NEM118 + NEM119 + NEM11A + NEM11B + NEM11C + ///
DCN118 + DCN119 + DCN11A + DCN11B + DCN11C + NCN118 + NCN119 + ///
NCN11A + NCN11B + NCN11C + DES1017 + DES1018 + DES1019 + ///
DES101A + NES1017 + NES1018 + NES1019 + NES101A
**********************************************************************
* Obtendo de número auxiliar para ponderação
gen auxiliar_infra = total_alu_escola * total_infra_escola
**********************************************************************
* Salvando arquivo de trabalho
save censo_escolar_2003_ceara, replace
**********************************************************************
* Agregando dados das escolas por município
collapse (sum) total_alu_escola auxiliar_infra, by(MUNIC)
**********************************************************************
* Cálculo do indicador de infra-estrutura escolar municipal
gen infra_esc_mun = auxiliar_infra / total_alu_escola
drop total_alu_escola auxiliar_infra
**********************************************************************
* Salvando arquivo de dados dos município
save infra_escolas_2003_mun, replace
**********************************************************************
*/////////////////////////////////////////////////////////////////////////////////////
*/////////////////////////////////////////////////////////////////////////////////////
**********************************************************************
* ROTINA 3
* INFRAESTRUTURA ESCOLAR DOS MUNICÍPIOS DO CEARÁ - 2013
* (PROXY PARA 2010)
**********************************************************************
* Leitura dos microdados a partir do arquivo txt original
* Nota: o Censo Escolar de 2013 disponibiza "inputs" para
* leitura no SPSS dos microdados em formato .txt dos arquivos:
* ESCOLAS, TURMAS, MATRÍCULAS E DOCENTES.
* Os arquivos no formato .sav (SPSS) foram transformados para
* o formato .dta (Stata) por meio do software Stat/Transfer.
**********************************************************************
* Acessando arquivo com dados das escolas
cd "C:\Users\FDiniz\Documents\Programa_IPM\Inep\Censo_Escolar_2013"
clear
use TS_ESCOLA_CENSO_ESCOLAR_2013
**********************************************************************
* Seleção de dados do Estado do Ceará e escolas em funcionamento
keep if sigla == "CE"
destring DESC_SITUACAO_FUNCIONAMENTO, replace
keep if DESC_SITUACAO_FUNCIONAMENTO == 1
**********************************************************************
* Adequando variáveis para o cálculo do indicador de infraestrutura
gen TEM_AGUA = .
destring ID_AGUA_INEXISTENTE, replace
replace TEM_AGUA = 1 if ID_AGUA_INEXISTENTE == 0
replace TEM_AGUA = 0 if ID_AGUA_INEXISTENTE == 1
gen TEM_ESGOTO = .
destring ID_ESGOTO_INEXISTENTE, replace
replace TEM_ESGOTO = 1 if ID_ESGOTO_INEXISTENTE == 0
replace TEM_ESGOTO = 0 if ID_ESGOTO_INEXISTENTE == 1
gen TEM_ENERGIA_ELET = .
destring ID_ENERGIA_INEXISTENTE, replace
replace TEM_ENERGIA_ELET = 1 if ID_ENERGIA_INEXISTENTE == 0
replace TEM_ENERGIA_ELET = 0 if ID_ENERGIA_INEXISTENTE == 1
gen TEM_SANITARIO = .
destring ID_SANITARIO_DENTRO_PREDIO ID_SANITARIO_FORA_PREDIO ///
ID_SANITARIO_EI ID_SANITARIO_PNE, replace
replace TEM_SANITARIO = 1 if ID_SANITARIO_DENTRO_PREDIO == 1 | ///
ID_SANITARIO_FORA_PREDIO == 1 | ID_SANITARIO_EI == 1 | ///
ID_SANITARIO_PNE == 1
replace TEM_SANITARIO = 0 if ID_SANITARIO_DENTRO_PREDIO == 0 & ///
ID_SANITARIO_FORA_PREDIO == 0 & ID_SANITARIO_EI == 0 & ///
ID_SANITARIO_PNE == 0
gen TEM_PRED_ESC = .
destring ID_LOCAL_FUNC_PREDIO_ESCOLAR, replace
replace TEM_PRED_ESC = 1 if ID_LOCAL_FUNC_PREDIO_ESCOLAR == 1
replace TEM_PRED_ESC = 0 if ID_LOCAL_FUNC_PREDIO_ESCOLAR == 0
gen TEM_BIBL_SALA_LEIT = .
destring ID_BIBLIOTECA ID_SALA_LEITURA, replace
replace TEM_BIBL_SALA_LEIT = 1 if ID_BIBLIOTECA == 1 | ///
ID_SALA_LEITURA == 1
replace TEM_BIBL_SALA_LEIT = 0 if ID_BIBLIOTECA == 0 & ///
ID_SALA_LEITURA == 0
gen TEM_DIRETORIA = .
destring ID_SALA_DIRETORIA, replace
replace TEM_DIRETORIA = 1 if ID_SALA_DIRETORIA == 1
replace TEM_DIRETORIA = 0 if ID_SALA_DIRETORIA == 0
gen TEM_LAB_CIEN = .
destring ID_LABORATORIO_CIENCIAS, replace
replace TEM_LAB_CIEN = 1 if ID_LABORATORIO_CIENCIAS == 1
replace TEM_LAB_CIEN = 0 if ID_LABORATORIO_CIENCIAS == 0
gen TEM_LAB_INFO = .
destring ID_LABORATORIO_INFORMATICA, replace
replace TEM_LAB_INFO = 1 if ID_LABORATORIO_INFORMATICA == 1
replace TEM_LAB_INFO = 0 if ID_LABORATORIO_INFORMATICA == 0
gen TEM_COZINHA = .
destring ID_COZINHA, replace
replace TEM_COZINHA = 1 if ID_COZINHA == 1
replace TEM_COZINHA = 0 if ID_COZINHA == 0
gen TEM_QUADRA = .
destring ID_QUADRA_ESPORTES_DESCOBERTA ///
ID_QUADRA_ESPORTES_COBERTA, replace
replace TEM_QUADRA = 1 if ID_QUADRA_ESPORTES_DESCOBERTA == 1 | ///
ID_QUADRA_ESPORTES_COBERTA == 1
replace TEM_QUADRA = 0 if ID_QUADRA_ESPORTES_DESCOBERTA == 0 & ///
ID_QUADRA_ESPORTES_COBERTA == 0
gen TEM_COMPUTADOR = .
replace TEM_COMPUTADOR = 1 if NUM_COMPUTADORES > 0
replace TEM_COMPUTADOR = 0 if NUM_COMPUTADORES == 0
gen ACESSO_INTERNET = 0
destring ID_INTERNET, replace
replace ACESSO_INTERNET = 1 if ID_INTERNET == 1
replace ACESSO_INTERNET = 0 if ID_INTERNET == 0
**********************************************************************
* Cálculo do indicador de infraestrutura das escolas
* (cada item = 1 ponto)
gen infra_servbas_esc = .
replace infra_servbas_esc = TEM_AGUA + TEM_ESGOTO + ///
TEM_ENERGIA_ELET + TEM_SANITARIO
gen infra_escola = .
replace infra_escola = TEM_PRED_ESC + TEM_BIBL_SALA_LEIT + ///
TEM_DIRETORIA + TEM_LAB_CIEN + TEM_LAB_INFO + TEM_COZINHA + ///
TEM_QUADRA + TEM_COMPUTADOR + ACESSO_INTERNET
gen total_infra_escola = .
replace total_infra_escola = infra_servbas_esc + infra_escola
**********************************************************************
* Salvando arquivo de trabalho
save censo_escolar_2013_ceara, replace
**********************************************************************
* Acessando arquivo de matrículas
clear
use TS_MATRICULA_CE_CENSO_ESCOLAR_2013
**********************************************************************
* Contanto número de alunos por escola
destring ID_DEPENDENCIA_ADM_ESC, replace
collapse (count) total_alu_escola = FK_COD_ALUNO, by(PK_COD_ENTIDADE)
**********************************************************************
* Juntando a variável "total_alunos_escola" ao arquivo de trabalho
* "censo_escolar_2013_ceara"
merge 1:1 PK_COD_ENTIDADE using censo_escolar_2013_ceara
drop _merge
**********************************************************************
* Cálculo do indicador de infraestutura escolar ponderado do município
gen auxiliar_infra = total_alu_escola * total_infra_escola
**********************************************************************
* Salvando arquivo de trabalho
save censo_escolar_2013_ceara, replace
**********************************************************************
* Agregando dados das escolas por município
collapse (sum) total_alu_escola auxiliar_infra, by(FK_COD_MUNICIPIO)
**********************************************************************
* Cálculo do indicador de infra-estrutura escolar municipal
gen infra_esc_mun = auxiliar_infra / total_alu_escola
drop total_alu_escola auxiliar_infra
**********************************************************************
* Salvando arquivo de dados dos município
save infra_escolas_2013_mun, replace
**********************************************************************
*/////////////////////////////////////////////////////////////////////////////////////
