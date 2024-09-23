*/////////////////////////////////////////////////////////////////////////////////////
* Este programa tem por objetivo a obtenção de indicadores de pobreza multidimensional dos
* municípios do Ceará a partir dos microdados da Amostra dos Censos Demográficos de
* 1991, 2000 e 2010.
* Elaborado por: Francisco Diniz Bezerra – Doutorando PRODEMA/UFC
* Data: abril/2015
* Base de dados: microdados da Amostra dos Censos Demográficos
* de 1991, 2000 e 2010
* Software Stata Versão 12
*/////////////////////////////////////////////////////////////////////////////////////
*/////////////////////////////////////////////////////////////////////////////////////
* CONCEITO DE POBREZA MULTIDIMENSIONAL UTILIZADO NESTE TRABALHO:
* O conceito de pobreza adotado neste programa consiste na insatisfação do atendimento
* das necessidades humanas básicas que priva o indivíduo de desenvolver e expandir as
* suas capacitações, gerando prejuízos ao seu bem-estar e à sua realização como ser
* humano.
* Considerando este enfoque, uma pessoa pode ser pobre por não ter tido atendidas as
* suas necessidades de acesso à educação, à saúde, à alimentação, ao trabalho, à moradia,
* à infraestrutura básica domiciliar, a plano de previdência etc. privando-a do direito
* e da capacidade de saber ler e escrever e ter conhecimento, de escapar da morbidade
* evitável e dispor de assistência médica, de nutrir-se adequadamente, de ter renda pelo
* trabalho, de abrigar-se condignamente e de estar amparada na velhice ou pela
* impossibilidade de trabalhar.
* Conforme metodologia definada pelo PNUD (2010), a pontuação de privação ponderada,
* representada por c, corresponde à soma de cada privação multiplicada pelo seu peso.
* São consideradas pobres as famílias (e os seus respectivos membros) cuja soma das
* privações ponderadas pelos seus pesos seja superior a 1/3 dos indicadores.
* Desta forma, no presente trabalho, este valor corresponde a c > 6 (isto é, 18/3).
* Na mesma linha de raciocínio, as famílias com uma pontuação de privação
* ponderada entre 1/5 e 1/3 dos indicadores (ou seja, 3,6 < c ≤ 6) estão vulneráveis
* ou em risco de se tornarem multidimensionalmente pobres.
* DEFINIÇÃO DE FAMÍLIA:
* Nesta pesquisa foi adotada a definição de FAMÍLIA do Censo de 1991 (IBGE, 1996, p. 22):
* a) o conjunto de pessoas ligadas por laços de parentesco, dependência doméstica ou
* normas de convivência que morassem no mesmo domicílio.
* Entende-se como dependência doméstica a situação de subordinação dos
* empregados domésticos e agregados em relação ao chefe da família.
* Entende-se por norma de convivência o cumprimento de regras estabelecidas
* para convivência de pessoas que residem no mesmo domicílio e não estão
* ligadas por laços de parentesco ou dependência doméstica.
* b) a pessoa sozinha que morasse em domicílio particular.
* c) o conjunto de, no máximo, 5 (cinco) pessoas que morassem em um 
* domicílio particular, embora não estivessem ligadas por laços de
* parentesco e ou dependência doméstica.
*/////////////////////////////////////////////////////////////////////////////////////
*/////////////////////////////////////////////////////////////////////////////////////
* DIRETÓRIOS DE TRABALHO
* Foram criados os seguintes subdiretórios para armazenamento de dados:
* C:\...\banco_de_dados\bd_orig1991
* C:\...\banco_de_dados\bd_orig2000
* C:\...\banco_de_dados\bd_orig2010
* C:\...\banco_de_dados\censo1991
* C:\...\banco_de_dados\censo2000
* C:\...\banco_de_dados\censo2010
* C:\...\Programa_IPM
*/////////////////////////////////////////////////////////////////////////////////////
*/////////////////////////////////////////////////////////////////////////////////////
********************************************************************
* ROTINA 1
* LEITURA DOS MICRODADOS DO CENSO DEMOGRÁFICO DE 1991
********************************************************************
* Acessando o diretório da base de dados original
* cd "C:\...\banco_de_dados\bd_orig1991"
********************************************************************
* Leitura dos microdados do Censo 1991 - Variáveis do Arquivo de Domicílios
clear
infix C0099 1-1 C1101 2-3 C0102 4-12 C0098 13-14 C7001 15-16 C7002 17-19 ///
C1102 20-23 C0109 24-27 C1061 28-28 C7003 29-29 C0111 30-31 C0112 32-33 ///
C0201 34-34 C2012 35-44 C2013 45-46 C2014 47-48 C0202 49-49 C0203 50-50 ///
C0204 51-51 C0205 52-52 C0206 53-53 C0207 54-54 C0208 55-55 C0209 56-61 ///
C2094 62-62 C0210 63-63 C0211 64-65 C2111 66-69 C2112 70-70 C0212 71-71 ///
C2121 72-75 C2122 76-76 C0213 77-77 C0214 78-78 C0216 79-79 C0217 80-80 ///
C0218 81-81 C0219 82-82 C0220 83-83 C0221 84-84 C0222 85-85 C0223 86-86 ///
C0224 87-87 C0225 88-88 C0226 89-89 C0227 90-90 C7300 91-100 using ///
CD102U23.txt if C0099 == 1
* obs.: C0099 - Tipo de registro: 1 = domicílio; 2 = pessoas.
* Filtrando apenas os registros de código 1 da variável C0201 - "Espécie do domicílio,
* opção 1 - particular permanente". Obs.: a pesquisa concernente aos domicílios foi
* restrita aos domicílios ocupados (IBGE, 1996, p.6).
keep if C0201 == 1
* C0201 - Espécie do domicílio:
* 1 Particular Permanente
* 2 Particular Improvisado
* 3 Coletivo
* Salvando dados
save bd_domicilios_original_1991, replace
* Obs.: para uso nesta tese, o arquivo bd_domicilios_original_1991 foi
* obtido a partir da leitura no SPSS do arquivo original (.txt), gerando
* um arquivo .sav, transformado em seguida para .dta por meio do
* Software Stat/Transfer. Procedeu-se desta forma para o Censo de 1991,
* em virtude de ocorrência de erros na leitura dos microdados, quando
* realizada diretamente no Stata.
********************************************************************
* Leitura dos microdados do Censo 1991 - Variáveis do Arquivo de Pessoas
clear
infix C0099 1-1 C1101 2-3 C0102 4-12 C0098 13-14 C0301 15-15 C0302 16-17 ///
C0303 18-19 C0304 20-20 C2011 21-21 C3041 22-23 C3042 24-25 C3043 26-33 ///
C3044 34-35 C3045 36-45 C3046 46-47 C3047 48-49 C3049 50-51 C3005 52-53 ///
C3071 54-54 C3072 55-57 C3073 58-59 C0309 60-60 C0311 61-61 C0312 62-62 ///
C0313 63-64 C0314 65-65 C3151 66-66 C3152 67-68 C0316 69-70 C0317 71-72 ///
C0318 73-74 C0319 75-76 C3191 77-80 C0320 81-81 C0321 82-83 C3211 84-87 ///
C0322 88-88 C0323 89-89 C0324 90-90 C0325 91-91 C0326 92-92 C0327 93-93 ///
C0328 94-94 C3241 95-96 C0329 97-98 C0330 99-99 C3311 100-101 C3312 102-103 ///
C0332 104-104 C0333 105-105 C3341 106-107 C3342 108-109 C0345 110-110 ///
C0346 111-113 C3461 114-115 C0347 116-118 C3471 119-120 C0349 121-122 ///
C0350 123-123 C0351 124-124 C0352 125-125 C0353 126-126 C0354 127-128 ///
C0355 129-130 C0356 131-137 C3561 138-145 C3562 146-147 C3563 148-149 ///
C3564 150-151 C0357 152-158 C3574 159-160 C0358 161-161 C0359 162-162 ///
C0360 163-169 C3604 170-171 C0361 172-178 C3614 179-180 C3351 181-182 ///
C3352 183-184 C3353 185-186 C3354 187-188 C3355 189-190 C3356 191-192 ///
C3360 193-194 C3361 195-196 C3362 197-198 C0335 199-200 C0336 201-202 ///
C0337 203-204 C0338 205-206 C0339 207-208 C0340 209-210 C3357 211-212 ///
C0341 213-214 C0342 215-216 C0343 217-217 C3443 218-219 C3444 220-220 ///
C0310 221-222 C7301 223-232 using CD102U23.txt if C0099 == 2
* Salvando dados
save bd_pessoas_original_1991, replace
* Obs.: para uso nesta tese, o arquivo bd_pessoas_original_1991 foi
* obtido a partir da leitura no SPSS do arquivo original (.txt), gerando
* um arquivo .sav, transformado em seguida para .dta por meio do
* Software Stat/Transfer. Procedeu-se desta forma para o Censo de 1991,
* em virtude de ocorrência de erros na leitura dos microdados, quando
* realizada diretamente no Stata.
********************************************************************
*/////////////////////////////////////////////////////////////////////////////////////
*/////////////////////////////////////////////////////////////////////////////////////
********************************************************************
* ROTINA 2
* CRIAÇÃO DO ARQUIVO DE TRABALHO UNIFICADO DE PESSOAS E
* DOMICÍLIOS E PADRONIZAÇÃO DAS VARIÁVEIS DO CENSO DE 1991
********************************************************************
********************************************************************
* Acessando o diretório da base de dados original
* cd "C:\...\banco_de_dados\Censo1991"
********************************************************************
* Combinando os arquivos "pessoas" e "domicilios"
clear
use bd_pessoas_original_1991
merge m:1 C0102 using bd_domicilios_original_1991
drop _merge
* C0102 - Identificação do Questionário
* Filtrando apenas os registros de código 1 da variável C0201 - "Espécie do domicílio,
* opção 1 - particular permanente". Obs.: a pesquisa concernente aos domicílios foi
* restrita aos domicílios ocupados (IBGE, 1996, p.6).
keep if C0201 == 1
* C0201 - Espécie do domicílio:
* 1 Particular Permanente
* 2 Particular Improvisado
* 3 Coletivo
* Salvando arquivo unificado de pessoas e domicílios
save bd_dom_pes_original_1991, replace
********************************************************************
* Padronização de variáveis do Censo de 1991
********************************************************************
* Variáveis geográficas
rename C1101 uf
rename C7001 mesorregiao
rename C7002 microrregiao
rename C7003 regiaometropolitana
rename C1102 municipio
rename C1061 sitdom
* Adequando variável sitdom:
replace sitdom = 1 if sitdom ≤ 3
replace sitdom = 2 if sitdom > 3
* 1 - Domicílio urbano; 2 - Domicílio rural
* Variáveis de identificação dos inquéritos (questionários)
rename C0102 domicilio
* Obs.: a variável C0102 refere-se ao número de questionário. Ela
* identifica o domicílio.
* As pessoas são identificadas pelo número da família (C0304)
* e pela ordem da pessoa na família (C0098)
rename C0304 familia
rename C0098 ordem_pessoa
rename C0201 especie_domicilio
rename C2011 especie_familia
* Variáveis das características das pessoas

rename C3072 idade
rename C0301 sexo
* 1 Masculino 2 Feminino
rename C0309 cor_raca
* 1 Branca; 2 Preta; 3 Amarela; 4 Parda; 5 Indígena; 9 Ignorado
rename C3354 filhos_nascvivos
rename C3360 filhos_vivos
* Obs.: C3354 e C3360 referem-se às mães que tiveram filhos
gen respdom = .
replace respdom = 1 if C0303 == 1
replace respdom = 0 if C0303 ~= 1
gen conjuge = .
replace conjuge = 1 if C0303 == 2
replace conjuge = 0 if C0303 ~= 2
gen filho_men21_naoemanc = .
replace filho_men21_naoemanc = 1 if idade < 21 & (C0303 == 3 | C0303 == 4) & C3342 == 5
replace filho_men21_naoemanc = 0 if idade < 21 & (C0303 ~= 3 & C0303 ~= 4) | C3342 ~= 5
* Variável peso
rename C7300 pesocenso
gen fator_exp_am = .
replace fator_exp_am = pesocenso/(10^8)
* Variáveis relativas à educação e à qualificação
gen sabelerescrever = .
replace sabelerescrever = 1 if C0323 == 1
replace sabelerescrever = 0 if C0323 == 2
rename C0324 serieqfreq
rename C0325 grauqfreq_ser
rename C0326 grauqfreq_naoser
rename C3241 anos_estudo
gen estudante = .
replace estudante = 1 if serieqfreq > 0 | grauqfreq_ser > 0 | grauqfreq_naoser > 0
replace estudante = 0 if serieqfreq == 0 & grauqfreq_ser == 0 & grauqfreq_naoser == 0
gen nivelinstrucao = .
* 0 - sem instrução (não sabe ler nem escrever (analfabeto)
* 1 - Fundamental incompleto
* 2 - Fundamental completo e nível médio incompleto
* 3 - Nível médio completo e superior incompleto
* 4 - Superior completo
* 5 - Não determinado
replace nivelinstrucao = 0 if anos_estudo == 0
replace nivelinstrucao = 1 if anos_estudo >= 1 & anos_estudo <= 7 | anos_estudo == 30
replace nivelinstrucao = 2 if anos_estudo >= 8 & anos_estudo <= 10
replace nivelinstrucao = 3 if anos_estudo >= 11 & anos_estudo <= 14
replace nivelinstrucao = 4 if anos_estudo >= 15 & anos_estudo ~= 20 & anos_estudo ~= 30
replace nivelinstrucao = 5 if anos_estudo == 20
* Anos de Estudo (VAR3241) - A classificação de anos de estudo foi obtida em função
* da série e do grau mais elevados concluídos com aprovação, dos
* moradores de 5 anos ou mais de idade que estavam freqüentando ou que haviam
* freqüentado escola. A correspondência foi feita do seguinte
* modo: 1 A 3 anos - Primário ou Elementar e 1º grau (incompletos);
* 4 A 7 anos - Primário ou Elementar (completos), 1º grau, Ginasial ou Médio
* 1º ciclo (incompletos); 8 a 10 anos - 1º grau, Ginasial ou Médio 1º ciclo (completos),
* 2º grau, Colegial ou Médio 2º ciclo (incompletos);
* 11 A 14 anos - 2º grau, Colegial ou Médio 2º ciclo (completos) e Superior (incompleto);
* 15 anos ou mais - Superior (completo), Mestrado ou Doutorado.
*****
* Variáveis relativas à deficiência física
gen deficiente_visual = 1 if C0311 == 1
gen deficiente_auditivo = 1 if C0311 == 2
gen deficiente_motor = 1 if C0311 == 4 | C0311 == 5
gen deficiente_mental = 1 if C0311 == 7
gen maisde1_defic = 1 if C0311 == 8
* Variáveis relativas ao trabalho e à seguridade social
gen trab_semanaref = .
replace trab_semanaref = 1 if C0345 == 1 | C0345 == 2
replace trab_semanaref = 0 if C0345 ~= 1 & C0345 ~= 2
* Obs.: No Censo de 1991, é indagado se a pessoa trabalhou em parte ou no total dos
* 12 meses precedentes à data do recenseamento
gen trabalho_seg = .
replace trabalho_seg = 1 if C0350 == 1 | C0349 == 7 | C0349 == 8
replace trabalho_seg = 0 if C0350 > 1 & C0349 ~= 7 & C0349 ~= 8
* A variável trabalho_seg compreende os trabalhadores com carteira de trabalho assinada,
* os funcionários públicos e os militares.
rename C0346 ocupacao
gen segespecial = .
replace segespecial = 1 if idade > 14 & (ocupacao >= 301 & ocupacao <= 336)
replace segespecial = 0 if idade > 14 & (ocupacao < 301 | ocupacao > 336)
gen apos_pens = .
replace apos_pens = 1 if C0359 > 0
replace apos_pens = 0 if C0359 == 0
gen contribprevoficial = .
replace contribprevoficial = 1 if C0353 == 1
replace contribprevoficial = 0 if C0353 > 1
gen trab_qual = .
replace trab_qual = 1 if ocupacao == 452 | ocupacao == 161 | ///
ocupacao == 30 | ocupacao == 32 | ocupacao == 1 | ocupacao == 612 | ///
ocupacao == 423 | ocupacao == 470 | ocupacao == 54 | ocupacao == 450 | ///
ocupacao == 336 | ocupacao == 911 | ocupacao == 511 | ocupacao == 801 | ///
ocupacao == 272 | ocupacao == 276 | ocupacao == 277 | ocupacao == 842 | ///
ocupacao == 815 | ocupacao == 471 | ocupacao == 3 | ocupacao == 802 | ///
ocupacao == 926 | ocupacao == 822 | ocupacao == 727 | ocupacao == 616 | ///
ocupacao == 912 | ocupacao == 479 | ocupacao == 913 | ///
ocupacao == 474 | ocupacao == 574 | ///
ocupacao == 821 | ocupacao == 321 | ocupacao == 520 | ocupacao == 472 | //
ocupacao == 519 | ocupacao == 428 | ocupacao == 812 | ocupacao == 345 | ///
ocupacao == 914 | ocupacao == 867 | ocupacao == 441 | ocupacao == 482 | ///
ocupacao == 753 | ocupacao == 333 | ocupacao == 562 | ocupacao == 490 | ///
ocupacao == 475 | ocupacao == 476 | ocupacao == 532 | ocupacao == 580 | ///
ocupacao == 280 | ocupacao == 488 | ocupacao == 10 | ocupacao == 601 | ///
ocupacao == 742 | ocupacao == 845 | ocupacao == 446 | ocupacao == 461 | ///
ocupacao == 803 | ocupacao == 813 | ocupacao == 2 | ocupacao == 4 | ///
ocupacao == 462 | ocupacao == 273 | ocupacao == 915 | ocupacao == 535 | ///
ocupacao == 613 | ocupacao == 506 | ocupacao == 584 | ocupacao == 807 | ///
ocupacao == 7 | ocupacao == 6 | ocupacao == 8 | ocupacao == 12 | ///
ocupacao == 556 | ocupacao == 517 | ocupacao == 162 | ocupacao == 826 | ///
ocupacao == 335 | ocupacao == 271 | ocupacao == 419 | ///
ocupacao == 451 | ocupacao == 732 | ocupacao == 487 | ocupacao == 515 | ///
ocupacao == 55 | ocupacao == 538 | ocupacao == 804 | ocupacao == 14 | ///
ocupacao == 418 | ocupacao == 429 | ocupacao == 443 | ocupacao == 576 | ///
ocupacao == 583 | ocupacao == 724 | ocupacao == 744 | ocupacao == 411 | ///
ocupacao == 274 | ocupacao == 421 | ocupacao == 430 | ocupacao == 415 | ///
ocupacao == 814 | ocupacao == 371 | ocupacao == 806 | ocupacao == 816 | ///
ocupacao == 916 | ocupacao == 917 | ocupacao == 866 | ocupacao == 869 | ///
ocupacao == 731 | ocupacao == 11 | ocupacao == 811 | ocupacao == 554 | ///
ocupacao == 222 | ocupacao == 571 | ocupacao == 918 | ocupacao == 508 | ///
ocupacao == 507 | ocupacao == 919 | ocupacao == 831 | ocupacao == 833 | ///
ocupacao == 516 | ocupacao == 412 | ocupacao == 431 | ocupacao == 573 | ///
ocupacao == 805 | ocupacao == 825 | ocupacao == 332 | ocupacao == 531 | ///
ocupacao == 551 | ocupacao == 920 | ocupacao == 921 | ocupacao == 489 | ///
ocupacao == 832 | ocupacao == 442 | ocupacao == 536 | ocupacao == 331 | ///
ocupacao == 533 | ocupacao == 817 | ocupacao == 818 | ocupacao == 824 | ///
ocupacao == 746 | ocupacao == 823 | ocupacao == 723 | ocupacao == 743 | ///
ocupacao == 481 | ocupacao == 725 | ocupacao == 578 | ocupacao == 424 | ///
ocupacao == 425 | ocupacao == 404 | ocupacao == 722 | ocupacao == 341 | ///
ocupacao == 20 | ocupacao == 414 | ocupacao == 473 | ocupacao == 504 | ///
ocupacao == 501 | ocupacao == 502 | ocupacao == 751 | ocupacao == 275 | ///
ocupacao == 587 | ocupacao == 539 | ocupacao == 586 | ocupacao == 540 | ///
ocupacao == 543 | ocupacao == 534 | ocupacao == 544 | ocupacao == 541 | ///
ocupacao == 585 | ocupacao == 542 | ocupacao == 545 | ocupacao == 564 | ///
ocupacao == 582 | ocupacao == 281 | ocupacao == 923 | ocupacao == 61 | ///
ocupacao == 521 | ocupacao == 351 | ocupacao == 484 | ocupacao == 420 | ///
ocupacao == 922 | ocupacao == 283 | ocupacao == 164 | ocupacao == 572 | ///
ocupacao == 113 | ocupacao == 557 | ocupacao == 589 | ocupacao == 808 | ///
ocupacao == 617 | ocupacao == 927 | ocupacao == 645 | ocupacao == 282 | ///
ocupacao == 15 | ocupacao == 304 | ocupacao == 537 | ocupacao == 166 | ///
ocupacao == 512 | ocupacao == 322 | ocupacao == 581 | ocupacao == 563 | ///
ocupacao == 514 | ocupacao == 417 | ocupacao == 841 | ocupacao == 772 | ///
ocupacao == 631 | ocupacao == 486 | ocupacao == 579 | ocupacao == 301 | ///
ocupacao == 215 | ocupacao == 217 | ocupacao == 218 | ocupacao == 633 | ///
ocupacao == 5 | ocupacao == 852 | ocupacao == 167 | ocupacao == 614 | ///
ocupacao == 427 | ocupacao == 63 | ocupacao == 449 | ocupacao == 252 | ///
ocupacao == 444 | ocupacao == 505 | ocupacao == 503 | ocupacao == 604 | ///
ocupacao == 381 | ocupacao == 477 | ocupacao == 928 | ocupacao == 334 | ///
ocupacao == 485 | ocupacao == 844 | ocupacao == 513 | ocupacao == 426 | ///
ocupacao == 391 | ocupacao == 726 | ocupacao == 448 | ocupacao == 447 | ///
ocupacao == 774 | ocupacao == 552 | ocupacao == 422 | ocupacao == 924 | ///
ocupacao == 762 | ocupacao == 925 | ocupacao == 305 | ocupacao == 478 | ///
ocupacao == 303 | ocupacao == 615 | ocupacao == 752 | ocupacao == 445 | ///
ocupacao == 577 | ocupacao == 602 | ocupacao == 13 | ocupacao == 621 | ///
ocupacao == 518 | ocupacao == 561 | ocupacao == 843 | ocupacao == 575
replace trab_qual = 2 if ocupacao == 38 | ocupacao == 36 | ocupacao == 31 | ///
ocupacao == 34 | ocupacao == 33 | ocupacao == 35 | ocupacao == 37 | ///
ocupacao == 193 | ocupacao == 741 | ocupacao == 771 | ocupacao == 103 | ///
ocupacao == 173 | ocupacao == 62 | ocupacao == 52 | ocupacao == 204 | ///
ocupacao == 64 | ocupacao == 60 | ocupacao == 644 | ocupacao == 711 | ///
ocupacao == 291 | ocupacao == 775 | ocupacao == 104 | ocupacao == 40 | ///
ocupacao == 553 | ocupacao == 712 | ocupacao == 646 | ocupacao == 182 | ///
ocupacao == 642 | ocupacao == 641 | ocupacao == 643 | ocupacao == 56 | ///
ocupacao == 868 | ocupacao == 864 | ocupacao == 605 | ocupacao == 111 | ///
ocupacao == 21 | ocupacao == 9 | ocupacao == 261 | ocupacao == 242 | ///
ocupacao == 51 | ocupacao == 761 | ocupacao == 865 | ocupacao == 278 | ///
ocupacao == 405 | ocupacao == 401 | ocupacao == 402 | ocupacao == 403 | ///
ocupacao == 861 | ocupacao == 243 | ocupacao == 863 | ocupacao == 721 | ///
ocupacao == 603 | ocupacao == 165 | ocupacao == 509 | ocupacao == 58 | ///
ocupacao == 57 | ocupacao == 221 | ocupacao == 244 | ocupacao == 293 | ///
ocupacao == 39 | ocupacao == 125 | ocupacao == 406 | ocupacao == 53 | ///
ocupacao == 862 | ocupacao == 132 | ocupacao == 279 | ocupacao == 214 | ///
ocupacao == 216 | ocupacao == 213 | ocupacao == 219 | ocupacao == 194 | ///
ocupacao == 632 | ocupacao == 555 | ocupacao == 251 | ocupacao == 59 | ///
ocupacao == 588 | ocupacao == 241 | ocupacao == 183 | ocupacao == 302 | ///
ocupacao == 191 | ocupacao == 112 | ocupacao == 834 | ocupacao == 192 | ///
ocupacao == 133 | ocupacao == 163 | ocupacao == 50 | ocupacao == 168 | ///
ocupacao == 131 | ocupacao == 773 | ocupacao == 361
replace trab_qual = 3 if ocupacao == 233 | ocupacao == 141 | ///
ocupacao == 102 | ocupacao == 142 | ocupacao == 152 | ocupacao == 181 | ///
ocupacao == 153 | ocupacao == 101 | ocupacao == 172 | ocupacao == 122 | ///
ocupacao == 143 | ocupacao == 203 | ocupacao == 124 | ocupacao == 231 | ///
ocupacao == 171 | ocupacao == 151 | ocupacao == 205 | ocupacao == 154 | ///
ocupacao == 232 | ocupacao == 212 | ocupacao == 211 | ocupacao == 202 | ///
ocupacao == 121 | ocupacao == 201 | ocupacao == 144
* Observações:
* Baixa qualificação: qualprof = 1 = atividades em que mais de 50% das pessoas
* ocupadas não tinham nenhum grau de instrução ou no máximo o 1o. grau completo,
* de acordo com o Censo de 1991;
* Média qualificação: qualprof = 2 = quando não enquadrado em baixa
* qualificação ou em alta qualificação;
* Alta qualificação: qualprof = 3 = atividades em que 80% ou mais das pessoas
* ocupadas possuíam nível superior completo, de acordo com o Censo de 1991.
********************************************************************
* Variáveis relativas ao padrão de vida
gen posse_moradia = .
replace posse_moradia = 1 if C0208 < 3
replace posse_moradia = 0 if C0208 >= 3
gen wc_priv = .
replace wc_priv = 1 if C0213 > 0
replace wc_priv = 0 if C0213 == 0
gen esg_sanit_adeq = .
replace esg_sanit_adeq = 1 if C0206 == 1 | C0206 == 2 | C0206 == 3
replace esg_sanit_adeq = 0 if C0206 == 0 | (C0206 >= 4 & C0206 <= 6)
gen supr_agua_adeq = .
replace supr_agua_adeq = 1 if C0205 == 1 | C0205 == 2 | C0205 == 4 | C0205 == 5
replace supr_agua_adeq = 0 if C0205 == 3 | C0205 == 6
gen agua_canal = .
replace agua_canal = 1 if C0205 < 4
replace agua_canal = 0 if C0205 >= 4
gen coleta_lixo = .
replace coleta_lixo = 1 if C0214 < 3
replace coleta_lixo = 0 if C0214 >= 3
gen energia_elet = .
replace energia_elet = 1 if C0221 == 1 | C0221 == 2
replace energia_elet = 0 if C0221 == 3 | C0221 == 4
gen radio = .
replace radio = 1 if C0220 == 1
replace radio = 0 if C0220 == 0 | C0220 == .
gen tv = .
replace tv = 1 if C0223 == 1 | C0224 >= 1
replace tv = 0 if (C0223 == 0 & C0224 == 0) | (C0223 == . & C0224 == .)
gen maq_lavar = .
replace maq_lavar = 1 if C0226 == 1
replace maq_lavar = 0 if C0226 == 0 | C0226 == .
gen gelfrez = .
replace gelfrez = 1 if C0222 >= 1 | C0225 == 1
replace gelfrez = 0 if (C0222 == 0 & C0225 == 0) | (C0222 == . & C0225 == .)
gen telefone = .
replace telefone = 1 if C0217 > 0
replace telefone = 0 if C0217 == 0 | C0217 == .
gen autom_part = .
replace autom_part = 1 if C0218 > 0 | C0219 == 1
replace autom_part = 0 if C0219 == 0 & C0219 ~= 1
gen nreletrod = radio + tv + maq_lavar + gelfrez + telefone
* OBS.: no cálculo da variável "nreletrod" foram considerados apenas
* itens comuns aos três censos.
destring C2121, replace
gen dens_mor_dorm_adeq = .
replace dens_mor_dorm_adeq = 1 if C2121/100 <= 2
replace dens_mor_dorm_adeq = 0 if C2121/100 > 2
* Variáveis auxiliares
gen nrpesfam = 1
gen populacao = 1
********************************************************************
* Substituindo código do município por código padronizado para os três censos
replace municipio = 2300101 if municipio == 10
replace municipio = 2300150 if municipio == 15
replace municipio = 2300200 if municipio == 20
replace municipio = 2300309 if municipio == 30
replace municipio = 2300408 if municipio == 40
replace municipio = 2300507 if municipio == 50
replace municipio = 2300606 if municipio == 60
replace municipio = 2300705 if municipio == 70
replace municipio = 2300754 if municipio == 75
replace municipio = 2300804 if municipio == 80
replace municipio = 2300903 if municipio == 90
replace municipio = 2301000 if municipio == 100
replace municipio = 2301109 if municipio == 110
replace municipio = 2301208 if municipio == 120
replace municipio = 2301307 if municipio == 130
replace municipio = 2301406 if municipio == 140
replace municipio = 2301505 if municipio == 150
replace municipio = 2301604 if municipio == 160
replace municipio = 2301703 if municipio == 170
replace municipio = 2301802 if municipio == 180
replace municipio = 2301851 if municipio == 185
replace municipio = 2301901 if municipio == 190
replace municipio = 2301950 if municipio == 195
replace municipio = 2302008 if municipio == 200
replace municipio = 2302057 if municipio == 205
replace municipio = 2302107 if municipio == 210
replace municipio = 2302206 if municipio == 220
replace municipio = 2302305 if municipio == 230
replace municipio = 2302404 if municipio == 240
replace municipio = 2302503 if municipio == 250
replace municipio = 2302602 if municipio == 260
replace municipio = 2302701 if municipio == 270
replace municipio = 2302800 if municipio == 280
replace municipio = 2302909 if municipio == 290
replace municipio = 2303006 if municipio == 300
replace municipio = 2303105 if municipio == 310
replace municipio = 2303204 if municipio == 320
replace municipio = 2303303 if municipio == 330
replace municipio = 2303402 if municipio == 340
replace municipio = 2303501 if municipio == 350
replace municipio = 2303600 if municipio == 360
replace municipio = 2303709 if municipio == 370
replace municipio = 2303808 if municipio == 380
replace municipio = 2303907 if municipio == 390
replace municipio = 2303956 if municipio == 395
replace municipio = 2304004 if municipio == 400
replace municipio = 2304103 if municipio == 410
replace municipio = 2304202 if municipio == 420
replace municipio = 2304236 if municipio == 423
replace municipio = 2304251 if municipio == 425
replace municipio = 2304269 if municipio == 426
replace municipio = 2304277 if municipio == 427
replace municipio = 2304285 if municipio == 428
replace municipio = 2304301 if municipio == 430
replace municipio = 2304350 if municipio == 435
replace municipio = 2304400 if municipio == 440
replace municipio = 2304509 if municipio == 450
replace municipio = 2304608 if municipio == 460
replace municipio = 2304657 if municipio == 465
replace municipio = 2304707 if municipio == 470
replace municipio = 2304806 if municipio == 480
replace municipio = 2304905 if municipio == 490
replace municipio = 2304954 if municipio == 495
replace municipio = 2305001 if municipio == 500
replace municipio = 2305100 if municipio == 510
replace municipio = 2305209 if municipio == 520
replace municipio = 2305233 if municipio == 523
replace municipio = 2305266 if municipio == 526
replace municipio = 2305308 if municipio == 530
replace municipio = 2305332 if municipio == 533
replace municipio = 2305357 if municipio == 535
replace municipio = 2305407 if municipio == 540
replace municipio = 2305506 if municipio == 550
replace municipio = 2305605 if municipio == 560
replace municipio = 2305654 if municipio == 565
replace municipio = 2305704 if municipio == 570
replace municipio = 2305803 if municipio == 580
replace municipio = 2305902 if municipio == 590
replace municipio = 2306009 if municipio == 600
replace municipio = 2306108 if municipio == 610
replace municipio = 2306207 if municipio == 620
replace municipio = 2306306 if municipio == 630
replace municipio = 2306405 if municipio == 640
replace municipio = 2306504 if municipio == 650
replace municipio = 2306553 if municipio == 655
replace municipio = 2306603 if municipio == 660
replace municipio = 2306702 if municipio == 670
replace municipio = 2306801 if municipio == 680
replace municipio = 2306900 if municipio == 690
replace municipio = 2307007 if municipio == 700
replace municipio = 2307106 if municipio == 710
replace municipio = 2307205 if municipio == 720
replace municipio = 2307304 if municipio == 730
replace municipio = 2307403 if municipio == 740
replace municipio = 2307502 if municipio == 750
replace municipio = 2307601 if municipio == 760
replace municipio = 2307635 if municipio == 763
replace municipio = 2307650 if municipio == 765
replace municipio = 2307700 if municipio == 770
replace municipio = 2307809 if municipio == 780
replace municipio = 2307908 if municipio == 790
replace municipio = 2308005 if municipio == 800
replace municipio = 2308104 if municipio == 810
replace municipio = 2308203 if municipio == 820
replace municipio = 2308302 if municipio == 830
replace municipio = 2308351 if municipio == 835
replace municipio = 2308377 if municipio == 837
replace municipio = 2308401 if municipio == 840
replace municipio = 2308500 if municipio == 850
replace municipio = 2308609 if municipio == 860
replace municipio = 2308708 if municipio == 870
replace municipio = 2308807 if municipio == 880
replace municipio = 2308906 if municipio == 890
replace municipio = 2309003 if municipio == 900
replace municipio = 2309102 if municipio == 910
replace municipio = 2309201 if municipio == 920
replace municipio = 2309300 if municipio == 930
replace municipio = 2309409 if municipio == 940
replace municipio = 2309458 if municipio == 945
replace municipio = 2309508 if municipio == 950
replace municipio = 2309607 if municipio == 960
replace municipio = 2309706 if municipio == 970
replace municipio = 2309805 if municipio == 980
replace municipio = 2309904 if municipio == 990
replace municipio = 2310001 if municipio == 1000
replace municipio = 2310100 if municipio == 1010
replace municipio = 2310209 if municipio == 1020
replace municipio = 2310258 if municipio == 1025
replace municipio = 2310308 if municipio == 1030
replace municipio = 2310407 if municipio == 1040
replace municipio = 2310506 if municipio == 1050
replace municipio = 2310605 if municipio == 1060
replace municipio = 2310704 if municipio == 1070
replace municipio = 2310803 if municipio == 1080
replace municipio = 2310852 if municipio == 1085
replace municipio = 2310902 if municipio == 1090
replace municipio = 2310951 if municipio == 1095
replace municipio = 2311009 if municipio == 1100
replace municipio = 2311108 if municipio == 1110
replace municipio = 2311207 if municipio == 1120
replace municipio = 2311231 if municipio == 1123
replace municipio = 2311264 if municipio == 1126
replace municipio = 2311306 if municipio == 1130
replace municipio = 2311355 if municipio == 1135
replace municipio = 2311405 if municipio == 1140
replace municipio = 2311504 if municipio == 1150
replace municipio = 2311603 if municipio == 1160
replace municipio = 2311702 if municipio == 1170
replace municipio = 2311801 if municipio == 1180
replace municipio = 2311900 if municipio == 1190
replace municipio = 2311959 if municipio == 1195
replace municipio = 2312007 if municipio == 1200
replace municipio = 2312106 if municipio == 1210
replace municipio = 2312205 if municipio == 1220
replace municipio = 2312304 if municipio == 1230
replace municipio = 2312403 if municipio == 1240
replace municipio = 2312502 if municipio == 1250
replace municipio = 2312601 if municipio == 1260
replace municipio = 2312700 if municipio == 1270
replace municipio = 2312809 if municipio == 1280
replace municipio = 2312908 if municipio == 1290
replace municipio = 2313005 if municipio == 1300
replace municipio = 2313104 if municipio == 1310
replace municipio = 2313203 if municipio == 1320
replace municipio = 2313252 if municipio == 1325
replace municipio = 2313302 if municipio == 1330
replace municipio = 2313351 if municipio == 1335
replace municipio = 2313401 if municipio == 1340
replace municipio = 2313500 if municipio == 1350
replace municipio = 2313559 if municipio == 1355
replace municipio = 2313609 if municipio == 1360
replace municipio = 2313708 if municipio == 1370
replace municipio = 2313757 if municipio == 1375
replace municipio = 2313807 if municipio == 1380
replace municipio = 2313906 if municipio == 1390
replace municipio = 2313955 if municipio == 1395
replace municipio = 2314003 if municipio == 1400
replace municipio = 2314102 if municipio == 1410
********************************************************************
* Eliminando variáveis que não serão utilizadas nas rotinas seguintes
drop C0302 C0303 C3041 C3042 C3043 C3044 C3045 C3046 C3047 C3049 C3005 C3071 ///
C3073 C0311 C0312 C0313 C0314 C3151 C3152 C0316 C0317 C0318 C0319 C3191 ///
C0320 C0321 C3211 C0322 C0323 C0327 C0328 C0329 C0330 C3311 C3312 C0332 ///
C0333 C3341 C3342 C0345 C3461 C0347 C3471 C0349 C0350 C0351 C0352 C0353 ///
C0354 C0355 C0356 C3561 C3562 C3563 C3564 C0357 C3574 C0358 C0359 C0360 ///
C3604 C0361 C3614 C3351 C3352 C3353 C3355 C3356 C3361 C3362 C0335 C0336 ///
C0337 C0338 C0339 C0340 C3357 C0341 C0342 C0343 C3443 C3444 C0310 C7301 ///
C0109 C0111 C0112 C2012 C2013 C2014 C0202 C0203 C0204 C0205 C0206 C0207 ///
C0208 C0209 C2094 C0210 C0211 C2111 C2112 C0212 C2121 C2122 C0213 C0214 ///
C0216 C0217 C0218 C0219 C0220 C0221 C0222 C0223 C0224 C0225 C0226 C0227
********************************************************************
* Acessando o diretório das bases de dados de trabalho
* cd "C:\...\banco_de_dados\censo1991"
* Gravando arquivo mesclado de pessoas-domicílios no diretório de trabalho
save bd_dom_pes_censo1991, replace
********************************************************************
*/////////////////////////////////////////////////////////////////////////////////////
*/////////////////////////////////////////////////////////////////////////////////////
********************************************************************
* ROTINA 3
* LEITURA DOS MICRODADOS DO CENSO DEMOGRÁFICO DE 2000
********************************************************************
* Acessando o diretório da base de dados original
* cd "C:\...\banco_de_dados\bd_orig2000"
cd "C:\Users\FDiniz\Documents\Programa_IPM\banco_de_dados\bd_orig2000"
********************************************************************
* Leitura dos microdados do Censo 2000 - Variáveis do Arquivo de Domicílios
clear
infix V0102 1-2 V1002 3-6 V1003 7-11 V0103 12-18 V0104 19-27 V0105 28-38 ///
V0300 39-46 V0400 47-48 V1001 49-49 V1004 50-51 AREAP 52-64 V1005 65-65 ///
V1006 66-66 V1007 67-67 V0110 68-69 V0111 70-71 V0201 72-72 M0201 73-73 ///
V0202 74-74 M0202 75-75 V0203 76-77 M0203 78-78 V0204 79-79 M0204 80-80 ///
V0205 81-81 M0205 82-82 V0206 83-83 M0206 84-84 V0207 85-85 M0207 86-86 ///
V0208 87-87 M0208 88-88 V0209 89-89 M0209 90-90 V0210 91-91 M0210 92-92 ///
V0211 93-93 M0211 94-94 V0212 95-95 M0212 96-96 V0213 97-97 M0213 98-98 ///
V0214 99-99 M0214 100-100 V0215 101-101 M0215 102-102 V0216 103-103 ///
M0216 104-104 V0217 105-105 M0217 106-106 V0218 107-107 M0218 108-108 ///
V0219 109-109 M0219 110-110 V0220 111-111 M0220 112-112 V0221 113-113 ///
M0221 114-114 V0222 115-115 M0222 116-116 V0223 117-117 M0223 118-118 ///
V7100 119-120 V7203 121-123 V7204 124-126 V7401 127-128 V7402 129-130 ///
V7403 131-132 V7404 133-134 V7405 135-136 V7406 137-138 V7407 139-140 ///
V7408 141-142 V7409 143-144 V7616 145-150 V7617 151-156 P001 157-167 ///
V1111 168-168 V1112 169-169 V1113 170-170 ///
using bd_domicilios_2000.txt if V0400 == 00
* Obs.: identificação do registro de domicílio (V0400 = 00)
* Filtrando apenas os registros de código 1 da variável V0201 - "Domicílio, espécie".
* Opção 1 - particular permanente".
keep if V0201 == 1
* V0201 - Espécie do domicílio:
* 1 Particular Permanente
* 2 Particular Improvisado
* 3 Coletivo
* Salvando dados
save bd_domicilios_original_2000, replace
********************************************************************
* Leitura dos dados do Censo 2000 - Variáveis do Arquivo de Pessoas
clear
infix V0102 1-2 V1002 3-6 V1003 7-11 V0103 12-18 V0104 19-27 V0105 28-38 ///
V0300 39-46 V0400 47-48 V1004 49-50 AREAP 51-63 V1001 64-64 V1005 65-65 ///
V1006 66-66 V1007 67-67 MARCA 68-68 V0401 69-69 M0401 70-70 V0402 71-72 ///
M0402 73-73 V0403 74-75 M0403 76-76 V0404 77-77 M0404 78-78 V4752 79-81 ///
M4752 82-82 V4754 83-84 M4754 85-85 V4070 86-86 V0408 87-87 M0408 88-88 ///
V4090 89-91 M4090 92-92 V0410 93-93 M0410 94-94 V0411 95-95 M0411 96-96 ///
V0412 97-97 M0412 98-98 V0413 99-99 M0413 100-100 V0414 101-101 ///
M0414 102-102 V0415 103-103 M0415 104-104 V0416 105-106 M0416 107-107 ///
V0417 108-108 M0417 109-109 V0418 110-110 M0418 111-111 V0419 112-112 ///
M0419 113-113 V0420 114-117 M0420 118-118 V4210 119-120 M4210 121-121 ///
V0422 122-123 M0422 124-124 V4230 125-126 M4230 127-127 V0424 128-128 ///
M0424 129-129 V4250 130-136 M4250 137-137 V4260 138-139 M4260 140-140 ///
V4276 141-147 M4276 148-148 V0428 149-149 M0428 150-150 V0429 151-151 ///
M0429 152-152 V0430 153-154 M0430 155-155 V0431 156-156 M0431 157-157 ///
V0432 158-158 M0432 159-159 V0433 160-161 M0433 162-162 V0434 163-163 ///
M0434 164-164 V4355 165-166 M4355 167-167 V4300 168-169 V0436 170-170 ///
M0436 171-171 V0437 172-172 M0437 173-173 V0438 174-174 M0438 175-175 ///
V0439 176-176 M0439 177-177 V0440 178-178 M0440 179-179 V0441 180-180 ///
M0441 181-181 V0442 182-182 M0442 183-183 V0443 184-184 M0443 185-185 ///
V0444 186-186 M0444 187-187 V4452 188-191 M4452 192-192 V4462 193-197 ///
M4462 198-198 V0447 199-199 M0447 200-200 V0448 201-201 M0448 202-202 ///
V0449 203-203 M0449 204-204 V0450 205-205 M0450 206-206 V4511 207-207 ///
M4511 208-208 V4512 209-214 M4512 215-215 V4513 216-221 V4514 222-227 ///
V4521 228-228 M4521 229-229 V4522 230-235 M4522 236-236 V4523 237-242 ///
V4524 243-248 V4525 249-254 V4526 255-260 V0453 261-262 M0453 263-263 ///
V0454 264-265 M0454 266-266 V4534 267-269 V0455 270-270 M0455 271-271 ///
V0456 272-272 M0456 273-273 V4573 274-279 M4573 280-280 V4583 281-286 ///
M4583 287-287 V4593 288-293 M4593 294-294 V4603 295-300 M4603 301-301 ///
V4613 302-307 M4613 308-308 V4614 309-314 V4615 315-320 V4620 321-322 ///
M4620 323-323 V0463 324-325 V4654 326-327 M4654 328-328 V4670 329-330 ///
M4670 331-331 V4690 332-333 M0463 334-334 P001 335-345 ESTR 346-347 ///
ESTRP 348-349 V4621 350-351 M4621 352-352 V4622 353-354 M4622 355-355 ///
V4631 356-357 M4631 358-358 V4632 359-360 M4632 361-361 V0464 362-362 ///
M0464 363-363 V4671 364-365 V4672 367-368 V4354 370-372 V4219 373-375 ///
V4239 376-378 V4269 379-381 V4279 382-384 V4451 385-387 V4461 388-390 ///
using bd_pessoas_2000.txt if V0400 ~= 00
* Salvando dados
save bd_pessoas_original_2000, replace
********************************************************************
*/////////////////////////////////////////////////////////////////////////////////////
*/////////////////////////////////////////////////////////////////////////////////////
********************************************************************
* ROTINA 4
* CRIAÇÃO DO ARQUIVO DE TRABALHO UNIFICADO DE PESSOAS
* E DOMICÍLIOS E PADRONIZAÇÃO DAS VARIÁVEIS DO
* CENSO DE 2000
********************************************************************
********************************************************************
* Acessando o diretório da base de dados original
* cd "C:\...\banco_de_dados\bd_orig2000"
********************************************************************
* Combinando os arquivos "pessoas" e "domicilios"
clear
use bd_pessoas_original_2000, clear
merge m:1 V0300 using bd_domicilios_original_2000
drop _merge
********************************************************************
* Filtrando apenas os registros de código 1 da variável V0201 -
* "Espécie do domicílio, opção 1 - particular permanente"
* obs.: a pesquisa concernente aos domicílios foi restrita
* aos domicílios ocupados.
keep if V0201 == 1
* V0201 "Espécie do Domicílio"
* 1 Particular Permanente
* 2 Particular Improvisado
* 3 Coletivo
* Salvando arquivo unificado de pessoas e domicílios
save bd_dom_pes_original_2000, replace
* Padronização de variáveis do Censo de 2000
********************************************************************
* Variáveis geográficas
rename V0102 uf
rename V1002 mesorregiao
rename V1003 microrregiao
rename V1004 regiaometropolitana
rename V0103 municipio
rename V1006 sitdom
* 1 domicílio urbano; 2 domicílio rural
* gen aglom_subnormal = .
* replace aglom_subnormal = 1 if V1007 == 1
* replace aglom_subnormal = 0 if C0202 ~= 1
* Variáveis de identificação dos inquéritos (questionários)
rename V0300 domicilio
rename V0404 familia
rename V0400 ordem_pessoa
* Não existe no Censo 2000 a variável "Espécie de Família" que consta no Censo de 1991
* Variáveis das características das pessoas
rename V4752 idade
rename V0401 sexo
* 1 Masculino 2 Feminino
rename V0408 cor_raca
* 1 Branca; 2 Preta; 3 Amarela; 4 Parda; 5 Indígena; 9 Ignorado
rename V4620 filhos_nascvivos
rename V0463 filhos_vivos
* Obs.: V4620 e V0463 referem-se às mães que tiveram filhos
gen respdom = .
replace respdom = 1 if V0402 == 1
replace respdom = 0 if V0402 ~= 1
gen conjuge = .
replace conjuge = 1 if V0402 == 2
replace conjuge = 0 if V0402 ~= 2
gen filho_men21_naoemanc = .
replace filho_men21_naoemanc = 1 if idade < 21 & V0402 == 3 & V0438 == 5
replace filho_men21_naoemanc = 0 if idade < 21 | V0402 ~= 3 | V0438 ~= 5
* Variável peso
rename P001 pesocenso
gen fator_exp_am = .
replace fator_exp_am = pesocenso/(10^8)
* Variáveis relativas à educação e à qualificação
gen sabelerescrever = .
replace sabelerescrever = 1 if V0428 == 1
replace sabelerescrever = 0 if V0428 == 2
rename V0431 serieqfreq
rename V0430 cursoqfreq
rename V4300 anos_estudo
gen estudante = .
replace estudante = 1 if V0429 == 1 | V0429 == 2
replace estudante = 0 if V0429 == 3 | V0429 == 4
gen nivelinstrucao = .
* 0 - Sem instrução (não sabe ler nem escrever - analfabeto)
* 1 - Fundamental incompleto
* 2 - Fundamental completo e nível médio incompleto
* 3 - Nível médio completo e superior incompleto
* 4 - Superior completo
* 5 - Não determinado
replace nivelinstrucao = 0 if anos_estudo == 0
replace nivelinstrucao = 1 if anos_estudo >= 1 & anos_estudo <= 7 | anos_estudo == 30
replace nivelinstrucao = 2 if anos_estudo >= 8 & anos_estudo <= 10
replace nivelinstrucao = 3 if anos_estudo >= 11 & anos_estudo <= 14
replace nivelinstrucao = 4 if anos_estudo >= 15 & anos_estudo ~= 20 & anos_estudo ~= 30
replace nivelinstrucao = 5 if anos_estudo == 20
* Classificação de acordo com orientação existente nas notas metodológicas do
* Censo de 1991 (IBGE, 1996, pág. 28-29)
* V4300 - Anos de estudo (Número de anos de estudo calculado para a pessoa
* recenseada em função do último curso e série concluídos)
* 00 - Sem instrução ou menos de 1 ano
* 01 - 1 ano
* ...
* 16 - 16 anos
* 17 - 17 anos ou mais
* 20 - Não determinado
* 30 - Alfabetização de adultos
*****
* Variáveis originais utilizadas:
* Variável V0428 - Sabe ler e escrever
* 1 Sabe ler e escrever
* 2 Não sabe
* Variável V0430 - Curso que frequenta
* 01 - Creche
* 02 - Pré-escolar
* 03 - Classe de alfabetização
* 04 - Alfabetização de adultos
* 05 - Ensino fundamental ou 1º grau - regular seriado
* 06 - Ensino fundamental ou 1º grau - regular não seriado
* 07 - Supletivo(ensino fundamental ou 1º grau)
* 08 - Ensino médio ou 2º grau - regular seriado
* 09 - Ensino médio ou 2º grau - regular não-seriado
* 10 - Supletivo (ensino médio ou 2º grau)
* 11 - Pré-vestibular
* 12 - Superior – graduação
* 13 - Superior – mestrado ou doutorado
* Branco - para os não estudantes
* Variável V0431 - Série que freqüenta
* 1 - Primeira Série
* 2 - Segunda Série
* 3 - Terceira Série
* 4 - Quarta Série
* 5 - Quinta Série
* 6 - Sexta Série
* 7 - Sétima Série
* 8 - Oitava Série
* 9 - Curso não-seriado
* Branco - para os não estudantes
* V0432 - Curso mais elevado que frequentou, concluindo pelo menos uma série
* 1 - Alfabetização de adultos
* 2 - Antigo primário
* 3 - Antigo ginásio
* 4 - Antigo clássico, científico, etc
* 5 - Ensino fundamental ou 1º grau
* 6 - Ensino médio ou 2º grau
* 7 - Superior - graduação
* 8 - Mestrado ou doutorado
* 9 - Nenhum
* Branco - para os estudantes
* Variável V0433 - Última série concluída com aprovação
* 01 - Primeira Série
* 02 - Segunda Série
* 03 - Terceira Série
* 04 - Quarta Série
* 05 - Quinta Série
* 06 - Sexta Série
* 07 - Sétima Série
* 08 - Oitava Série
* 09 - Curso não-seriado
* 10 - Nenhuma
* Branco - para os estudantes
* Variável V0434 - Concuiu o curso no qual estudou
* 1 - Sim
* 2 - Não
* Branco - para os estudantes
* V0439 - Na semana de 23 a 29 de Julho de 2000, Trabalhou remunerado
* 1 - Sim
* 2 - Não
* Branco - para as pessoas com menos de 10 anos de idade
* Variável V4300 - Anos de estudo
* 00 - Sem instrução ou menos de 1 ano
* 01 - 1 ano
* 02 - 2 anos
* ...
* 15 - 15 anos
* 16 - 16 anos
* 17 - 17 anos ou mais
* 20 - Não determinado
* 30 - Alfabetização de adultos
* Variáveis relativas à deficiência física
gen deficiente_visual = .
replace deficiente_visual = 1 if V0411 == 1 & (V0410 > 1 & V0412 > 1 & V0413 > 1)
replace deficiente_visual = 0 if V0411 > 1
gen deficiente_auditivo = .
replace deficiente_auditivo = 1 if V0412 == 1 & (V0410 > 1 & V0411 > 1 & V0413 > 1)
replace deficiente_auditivo = 0 if V0412 > 1
gen deficiente_motor = .
replace deficiente_motor = 1 if V0413 == 1 & (V0410 > 1 & V0411 > 1 & V0412 > 1)
replace deficiente_motor = 0 if V0413 > 1
gen deficiente_mental = .
replace deficiente_mental = 1 if V0410 == 1 & (V0411 > 1 & V0412 > 1 & V0413 > 1)
replace deficiente_mental = 0 if V0410 > 1
gen maisde1_defic = .
replace maisde1_defic = 1 if deficiente_visual + deficiente_auditivo + ///
deficiente_motor + deficiente_mental > 1
replace maisde1_defic = 0 if deficiente_visual + deficiente_auditivo + ///
deficiente_motor + deficiente_mental <= 1
*****
* Variáveis originais utilizadas:
* Variável V4752 - Idade calculada em anos completos - a partir de 1 ano
* Variável V0463 - Total de filhos nascidos vivos que estavam vivos
* Variável V4620 - Total de filhos nascidos vivos
* Variável V4615 - Total de rendimentos, em salários mínimos
* V0410 - Problema mental permanente
* 1 - Sim
* 2 - Não
* 9 - Ignorado
* V0411 - Capacidade de enxergar
* 1 - Incapaz
* 2 - Grande dificuldade permanente
* 3 - Alguma dificuldade permanente
* 4 - Nenhuma dificuldade
* 9 - Ignorado
* V0412 - Capacidade de ouvir
* 1 - Incapaz
* 2 - Grande dificuldade permanente
* 3 - Alguma dificuldade permanente
* 4 - Nenhuma dificuldade
* 9 - Ignorado
* Variável V0413 - Capacidade de caminhar / Subir escadas
* 1 - Incapaz
* 2 - Grande dificuldade permanente
* 3 - Alguma dificuldade permanente
* 4 - Nenhuma dificuldade
* 9 - Ignorado
* Variável V0414 - Deficiências
* 1 - Paralisia permanente total
* 2 - Paralisia permanente das pernas
* 3 - Paralisia permanente de um dos lados do corpo
* 4 - Falta de perna, braço, mão, pé ou dedo polegar
* 5 - Nenhuma das enumeradas
* 9 - Ignorado
* Variável V0404 - Número da família
* OBSERVAÇÃO IMPORTANTE: O censo de 2000 não permite saber se o
* filho com menos de 1 ano morreu ou está vivo.
********************************************************************
* Variáveis relativas ao trabalho e à seguridade social
rename V0439 trabalhoremunerado
rename V0440 trabrem_afastado
rename V0441 trabnaoremunerado
gen trabnaoremunerado_agric = .
replace trabnaoremunerado_agric = 1 if V0442 == 1 | V0443 == 1
replace trabnaoremunerado_agric = 2 if V0442 == 2 & V0443 == 2
gen trab_semanaref = .
replace trab_semanaref = 1 if trabalhoremunerado == 1 | trabrem_afastado == 1 | ///
trabnaoremunerado == 1 | trabnaoremunerado_agric == 1
replace trab_semanaref = 0 if trabalhoremunerado == 2 & trabrem_afastado == 2 & ///
trabnaoremunerado == 2 & trabnaoremunerado_agric == 2
gen trabalho_seg = .
replace trabalho_seg = 1 if (V0447 == 1 | V0447 == 3) | V0448 == 1
replace trabalho_seg = 0 if (V0447 ~= 1 & V0447 ~= 3) & V0448 == 2
* A variável trabalho_seg compreende os trabalhadores com carteira de trabalho
* assinada, os funcionários públicos e os militares.
rename V4452 ocupacao
gen segespecial = .
replace segespecial = 1 if idade > 14 & (ocupacao >= 6110 & ocupacao <= 6430)
replace segespecial = 0 if idade > 14 & (ocupacao < 6110 | ocupacao > 6430)
gen apos_pens = .
replace apos_pens = 1 if V0456 == 1 | V4573 > 0
replace apos_pens = 0 if V0456 == 2 | V4573 == 0 | V4573 == .
gen contribprevoficial = .
replace contribprevoficial = 1 if V0450 == 1 | (V0447 == 1 | V0447 == 3) | V0448 == 1
replace contribprevoficial = 0 if V0450 == 2 & (V0447 ~= 1 & V0447 ~= 3) & V0448 == 2
gen trab_qual = .
replace trab_qual = 1 if ocupacao == 1111 | ocupacao == 1140 | ocupacao == 2011 | ///
ocupacao == 2021 | ocupacao == 2140 | ocupacao == 2148 | ocupacao == 2514 | ///
ocupacao == 2614 | ocupacao == 2622 | ocupacao == 2624 | ocupacao == 2625 | ///
ocupacao == 3113 | ocupacao == 3117 | ocupacao == 3123 | ocupacao == 3131 | ///
ocupacao == 3132 | ocupacao == 3134 | ocupacao == 3141 | ocupacao == 3143 | ///
ocupacao == 3144 | ocupacao == 3146 | ocupacao == 3191 | ocupacao == 3201 | ///
ocupacao == 3212 | ocupacao == 3214 | ocupacao == 3221 | ocupacao == 3224 | ///
ocupacao == 3225 | ocupacao == 3231 | ocupacao == 3250 | ocupacao == 3252 | ///
ocupacao == 3281 | ocupacao == 3313 | ocupacao == 3412 | ocupacao == 3421 | ///
ocupacao == 3522 | ocupacao == 3524 | ocupacao == 3531 | ocupacao == 3542 | ///
ocupacao == 3712 | ocupacao == 3721 | ocupacao == 3722 | ocupacao == 3723 | ///
ocupacao == 3741 | ocupacao == 3742 | ocupacao == 3751 | ocupacao == 3761 | ///
ocupacao == 3762 | ocupacao == 3763 | ocupacao == 3764 | ocupacao == 3765 | ///
ocupacao == 3772 | ocupacao == 3912 | ocupacao == 4123 | ocupacao == 4141 | ///
ocupacao == 4213 | ocupacao == 4214 | ocupacao == 4231 | ocupacao == 5101 | ///
ocupacao == 5102 | ocupacao == 5121 | ocupacao == 5131 | ocupacao == 5132 | ///
ocupacao == 5133 | ocupacao == 5134 | ocupacao == 5141 | ocupacao == 5142 | ///
ocupacao == 5161 | ocupacao == 5162 | ocupacao == 5165 | ocupacao == 5166 | ///
ocupacao == 5169 | ocupacao == 5171 | ocupacao == 5173 | ocupacao == 5174 | ///
ocupacao == 5191 | ocupacao == 5192 | ocupacao == 5198 | ocupacao == 5199 | ///
ocupacao == 5211 | ocupacao == 5221 | ocupacao == 5231 | ocupacao == 5241 | ///
ocupacao == 5242 | ocupacao == 5243 | ocupacao == 6110 | ocupacao == 6129 | ///
ocupacao == 6139 | ocupacao == 6201 | ocupacao == 6210 | ocupacao == 6229 | ///
ocupacao == 6239 | ocupacao == 6301 | ocupacao == 6319 | ocupacao == 6329 | ///
ocupacao == 6410 | ocupacao == 6420 | ocupacao == 6430 | ocupacao == 7101 | ///
ocupacao == 7102 | ocupacao == 7111 | ocupacao == 7112 | ocupacao == 7114 | ///
ocupacao == 7121 | ocupacao == 7122 | ocupacao == 7151 | ocupacao == 7152 | ///
ocupacao == 7153 | ocupacao == 7154 | ocupacao == 7155 | ocupacao == 7156 | ///
ocupacao == 7157 | ocupacao == 7161 | ocupacao == 7162 | ocupacao == 7163 | ///
ocupacao == 7164 | ocupacao == 7165 | ocupacao == 7166 | ocupacao == 7170 | ///
ocupacao == 7201 | ocupacao == 7202 | ocupacao == 7211 | ocupacao == 7212 | ///
ocupacao == 7213 | ocupacao == 7214 | ocupacao == 7221 | ocupacao == 7222 | ///
ocupacao == 7223 | ocupacao == 7224 | ocupacao == 7231 | ocupacao == 7232 | ///
ocupacao == 7233 | ocupacao == 7241 | ocupacao == 7242 | ocupacao == 7243 | ///
ocupacao == 7244 | ocupacao == 7245 | ocupacao == 7246 | ocupacao == 7250 | ///
ocupacao == 7251 | ocupacao == 7252 | ocupacao == 7254 | ocupacao == 7255 | ///
ocupacao == 7256 | ocupacao == 7257 | ocupacao == 7311 | ocupacao == 7321 | ///
ocupacao == 7411 | ocupacao == 7421 | ocupacao == 7502 | ocupacao == 7519 | ///
ocupacao == 7521 | ocupacao == 7522 | ocupacao == 7523 | ocupacao == 7524 | ///
ocupacao == 7601 | ocupacao == 7604 | ocupacao == 7605 | ocupacao == 7606 | ///
ocupacao == 7610 | ocupacao == 7611 | ocupacao == 7612 | ocupacao == 7613 | ///
ocupacao == 7614 | ocupacao == 7618 | ocupacao == 7620 | ocupacao == 7621 | ///
ocupacao == 7622 | ocupacao == 7623 | ocupacao == 7630 | ocupacao == 7631 | ///
ocupacao == 7632 | ocupacao == 7633 | ocupacao == 7640 | ocupacao == 7641 | ///
ocupacao == 7642 | ocupacao == 7643 | ocupacao == 7650 | ocupacao == 7651 | ///
ocupacao == 7652 | ocupacao == 7653 | ocupacao == 7654 | ocupacao == 7660 | ///
ocupacao == 7661 | ocupacao == 7662 | ocupacao == 7663 | ocupacao == 7664 | ///
ocupacao == 7681 | ocupacao == 7682 | ocupacao == 7683 | ocupacao == 7686 | ///
ocupacao == 7687 | ocupacao == 7701 | ocupacao == 7711 | ocupacao == 7721 | ///
ocupacao == 7731 | ocupacao == 7732 | ocupacao == 7733 | ocupacao == 7734 | ///
ocupacao == 7741 | ocupacao == 7751 | ocupacao == 7764 | ocupacao == 7771 | ///
ocupacao == 7772 | ocupacao == 7817 | ocupacao == 7820 | ocupacao == 7821 | ///
ocupacao == 7822 | ocupacao == 7823 | ocupacao == 7824 | ocupacao == 7825 | ///
ocupacao == 7826 | ocupacao == 7827 | ocupacao == 7828 | ocupacao == 7832 | ///
ocupacao == 7841 | ocupacao == 7842 | ocupacao == 8102 | ocupacao == 8111 | ///
ocupacao == 8112 | ocupacao == 8114 | ocupacao == 8116 | ocupacao == 8117 | ///
ocupacao == 8118 | ocupacao == 8121 | ocupacao == 8211 | ocupacao == 8212 | ///
ocupacao == 8213 | ocupacao == 8214 | ocupacao == 8231 | ocupacao == 8232 | ///
ocupacao == 8233 | ocupacao == 8281 | ocupacao == 8311 | ocupacao == 8321 | ///
ocupacao == 8339 | ocupacao == 8401 | ocupacao == 8411 | ocupacao == 8412 | ///
ocupacao == 8413 | ocupacao == 8417 | ocupacao == 8421 | ocupacao == 8423 | ///
ocupacao == 8429 | ocupacao == 8484 | ocupacao == 8485 | ocupacao == 8491 | ///
ocupacao == 8492 | ocupacao == 8493 | ocupacao == 8601 | ocupacao == 8621 | ///
ocupacao == 8622 | ocupacao == 8623 | ocupacao == 8624 | ocupacao == 8625 | ///
ocupacao == 8711 | ocupacao == 9101 | ocupacao == 9109 | ocupacao == 9111 | ///
ocupacao == 9112 | ocupacao == 9113 | ocupacao == 9131 | ocupacao == 9142 | ///
ocupacao == 9143 | ocupacao == 9144 | ocupacao == 9152 | ocupacao == 9191 | ///
ocupacao == 9192 | ocupacao == 9193 | ocupacao == 9501 | ocupacao == 9511 | ///
ocupacao == 9513 | ocupacao == 9531 | ocupacao == 9541 | ocupacao == 9542 | ///
ocupacao == 9543 | ocupacao == 9911 | ocupacao == 9912 | ocupacao == 9913 | ///
ocupacao == 9914 | ocupacao == 9921 | ocupacao == 9922
replace trab_qual = 2 if ocupacao == 100 | ocupacao == 200 | ocupacao == 300 | ///
ocupacao == 401 | ocupacao == 402 | ocupacao == 403 | ocupacao == 411 | ///
ocupacao == 412 | ocupacao == 413 | ocupacao == 502 | ocupacao == 503 | ///
ocupacao == 512 | ocupacao == 513 | ocupacao == 1112 | ocupacao == 1122 | ///
ocupacao == 1123 | ocupacao == 1210 | ocupacao == 1219 | ocupacao == 1220 | ///
ocupacao == 1230 | ocupacao == 1310 | ocupacao == 1320 | ocupacao == 2111 | ///
ocupacao == 2112 | ocupacao == 2121 | ocupacao == 2122 | ocupacao == 2123 | ///
ocupacao == 2124 | ocupacao == 2125 | ocupacao == 2131 | ocupacao == 2132 | ///
ocupacao == 2133 | ocupacao == 2141 | ocupacao == 2144 | ocupacao == 2147 | ///
ocupacao == 2149 | ocupacao == 2151 | ocupacao == 2152 | ocupacao == 2153 | ///
ocupacao == 2211 | ocupacao == 2237 | ocupacao == 2311 | ocupacao == 2312 | ///
ocupacao == 2313 | ocupacao == 2321 | ocupacao == 2330 | ocupacao == 2391 | ///
ocupacao == 2392 | ocupacao == 2394 | ocupacao == 2512 | ocupacao == 2516 | ///
ocupacao == 2521 | ocupacao == 2522 | ocupacao == 2523 | ocupacao == 2524 | ///
ocupacao == 2525 | ocupacao == 2531 | ocupacao == 2611 | ocupacao == 2612 | ///
ocupacao == 2615 | ocupacao == 2616 | ocupacao == 2617 | ocupacao == 2621 | ///
ocupacao == 2623 | ocupacao == 2627 | ocupacao == 2631 | ocupacao == 3003 | ///
ocupacao == 3011 | ocupacao == 3111 | ocupacao == 3115 | ocupacao == 3116 | ///
ocupacao == 3121 | ocupacao == 3122 | ocupacao == 3135 | ocupacao == 3136 | ///
ocupacao == 3142 | ocupacao == 3161 | ocupacao == 3162 | ocupacao == 3163 | ///
ocupacao == 3171 | ocupacao == 3172 | ocupacao == 3189 | ocupacao == 3210 | ///
ocupacao == 3211 | ocupacao == 3222 | ocupacao == 3223 | ocupacao == 3241 | ///
ocupacao == 3242 | ocupacao == 3251 | ocupacao == 3253 | ocupacao == 3311 | ///
ocupacao == 3312 | ocupacao == 3321 | ocupacao == 3322 | ocupacao == 3331 | ///
ocupacao == 3341 | ocupacao == 3411 | ocupacao == 3413 | ocupacao == 3422 | ///
ocupacao == 3423 | ocupacao == 3424 | ocupacao == 3425 | ocupacao == 3426 | ///
ocupacao == 3511 | ocupacao == 3512 | ocupacao == 3513 | ocupacao == 3514 | ///
ocupacao == 3515 | ocupacao == 3516 | ocupacao == 3517 | ocupacao == 3518 | ///
ocupacao == 3523 | ocupacao == 3525 | ocupacao == 3532 | ocupacao == 3541 | ///
ocupacao == 3543 | ocupacao == 3544 | ocupacao == 3545 | ocupacao == 3546 | ///
ocupacao == 3547 | ocupacao == 3548 | ocupacao == 3711 | ocupacao == 3713 | ///
ocupacao == 3731 | ocupacao == 3732 | ocupacao == 3771 | ocupacao == 3773 | ///
ocupacao == 3911 | ocupacao == 4101 | ocupacao == 4102 | ocupacao == 4110 | ///
ocupacao == 4121 | ocupacao == 4122 | ocupacao == 4131 | ocupacao == 4132 | ///
ocupacao == 4142 | ocupacao == 4151 | ocupacao == 4152 | ocupacao == 4201 | ///
ocupacao == 4211 | ocupacao == 4212 | ocupacao == 4221 | ocupacao == 4222 | ///
ocupacao == 4223 | ocupacao == 4241 | ocupacao == 5103 | ocupacao == 5111 | ///
ocupacao == 5112 | ocupacao == 5114 | ocupacao == 5151 | ocupacao == 5152 | ///
ocupacao == 5167 | ocupacao == 5172 | ocupacao == 5201 | ocupacao == 7113 | ///
ocupacao == 7253 | ocupacao == 7301 | ocupacao == 7313 | ocupacao == 7801 | ///
ocupacao == 7831 | ocupacao == 8101 | ocupacao == 8110 | ocupacao == 8115 | ///
ocupacao == 8181 | ocupacao == 8201 | ocupacao == 8202 | ocupacao == 8221 | ///
ocupacao == 8301 | ocupacao == 8416 | ocupacao == 8611 | ocupacao == 8612 | ///
ocupacao == 9102 | ocupacao == 9141 | ocupacao == 9151 | ocupacao == 9153 | ///
ocupacao == 9154 | ocupacao == 9503
replace trab_qual = 3 if ocupacao == 501 | ocupacao == 2134 | ocupacao == 2142 | ///
ocupacao == 2143 | ocupacao == 2145 | ocupacao == 2146 | ocupacao == 2221 | ///
ocupacao == 2231 | ocupacao == 2232 | ocupacao == 2233 | ocupacao == 2234 | ///
ocupacao == 2235 | ocupacao == 2236 | ocupacao == 2340 | ocupacao == 2410 | ///
ocupacao == 2412 | ocupacao == 2421 | ocupacao == 2422 | ocupacao == 2423 | ///
ocupacao == 2511 | ocupacao == 2513 | ocupacao == 2515
* Variáveis relativas ao padrão de vida
gen posse_moradia = .
replace posse_moradia = 1 if V0205 < 3 | V0206 == 1
replace posse_moradia = 0 if V0205 >= 3 & V0206 ~= 1
gen wc_priv = .
replace wc_priv = 1 if V0209 > 0
replace wc_priv = 0 if V0209 == 0
gen esg_sanit_adeq = .
replace esg_sanit_adeq = 1 if V0211 == 1 | V0211 == 2
replace esg_sanit_adeq = 0 if V0211 > 2
gen supr_agua_adeq = .
replace supr_agua_adeq = 1 if V0207 == 1 | V0207 == 2
replace supr_agua_adeq = 0 if V0207 > 2
gen agua_canal = .
replace agua_canal = 1 if V0208 == 1
replace agua_canal = 0 if V0208 == 2 | V0208 == 3
gen coleta_lixo = .
replace coleta_lixo = 1 if V0212 == 1 | V0210 == 2
replace coleta_lixo = 0 if V0212 > 2
gen energia_elet = .
replace energia_elet = 1 if V0213 == 1
replace energia_elet = 0 if V0213 == 2
gen radio = .
replace radio = 1 if V0214 == 1
replace radio = 0 if V0214 == 2
gen tv = .
replace tv = 1 if V0221 >= 1
replace tv = 0 if V0221 == 0
gen maq_lavar = .
replace maq_lavar = 1 if V0217 == 1
replace maq_lavar = 0 if V0217 == 2
gen gelfrez = .
replace gelfrez = 1 if V0215 == 1
replace gelfrez = 0 if V0215 == 2
gen telefone = .
replace telefone = 1 if V0219 == 1
replace telefone = 0 if V0219 == 2
gen autom_part = .
replace autom_part = 1 if V0222 >= 1
replace autom_part = 0 if V0222 == 0
gen nreletrod = radio + tv + maq_lavar + gelfrez + telefone
* OBS.: no cálculo da variável "nreletrod" foram considerados apenas itens
* comuns aos três censos.
gen dens_mor_dorm_adeq = .
replace dens_mor_dorm_adeq = 1 if V7204/10 <= 2
replace dens_mor_dorm_adeq = 0 if V7204/10 > 2
*****
********************************************************************
* Variáveis originais utilizadas no cálculo de P1, P2, P3, P4, P5, P6, P7 e P8:
* V0207 - Forma de abastecimento de água
* 1 - Rede geral
* 2 - Poço ou nascente(na propriedade)
* 3 - Outra
* V0211 - Tipo de escoadouro
* 1- Rede geral de esgoto ou pluvial
* 2- Fossa séptica
* 3- Fossa rudimentar
* 4- Vala
* 5- Rio, lago ou mar
* 6- Outro escoadouro
* V0212 - Coleta de lixo
* 1- Coletado por serviço de limpeza
* 2- Colocado em caçamba de serviço de limpeza
* 3- Queimado(na propriedade)
* 4- Enterrado(na propriedade)
* 5- Jogado em terreno baldio ou logradouro
* 6- Jogado em rio, lago ou mar
* 7- Tem outro destino
* V0213 - Iluminação elétrica
* 1 - Sim
* 2 - Não
* V0203 - Total de cômodos
* V7204 - Densidade de moradores por dormitório
* V0205 - Condição de ocupação do domicílio
* 1 - Próprio, já pago
* 2 - Próprio, ainda pagando
* 3 - Alugado
* 4 - Cedido por empregador
* 5 - Cedido de outra forma
* 6 - Outra Condição
* V0208 - Tipo de canalização
* 1 - Canalizada em pelo menos um cômodo
* 2 - Canalizada só na propriedade ou terreno
* 3 - Não canalizada
* V0209 - Total de banheiros
* 0 - Não tem
* 1 - 1 banheiro
* 2 - 2 banheiros
* 3 - 3 banheiros
* 4 - 4 banheiros
* 5 - 5 banheiros
* 6 - 6 banheiros
* 7 - 7 banheiros
* 8 - 8 banheiros
* 9 - 9 ou mais banheiros
* OBS.: Foram considerados apenas itens comuns aos três censos.
* V0214 - Existência de rádio
* 1 - Sim
* 2 - Não
* V0215 - Geladeira ou freezer, existência
* 1 - Sim
* 2 - Não
* V0217 - Existência de máquina de lavar roupa
* 1 - Sim
* 2 - Não
* V0219 - Existência de linha telefônica instalada
* 1 - Sim
* 2 - Não
* V0221 - Quantidade existente de televisores
* 0 - Não tem
* 1 - 1 televisor
* 2 - 2 televisores
* 3 - 3 televisores
* 4 - 4 televisores
* 5 - 5 televisores
* 6 - 6 televisores
* 7 - 7 televisores
* 8 - 8 televisores
* 9 - 9 ou mais televisores
* V0222 - Quantidade existente de automóveis para uso particular
* 0 - Não tem
* 1 - 1 automóvel
* 2 - 2 automóveis
* 3 - 3 automóveis
* 4 - 4 automóveis
* 5 - 5 automóveis
* 6 - 6 automóveis
* 7 - 7 automóveis
* 8 - 8 automóveis
* 9 - 9 ou mais automóveis
* Variáveis auxiliares
gen nrpesfam = 1
gen populacao = 1
********************************************************************
* Acessando o diretório das bases de dados de trabalho
* cd "C:\...\banco_de_dados\censo2000"
* Gravando arquivo mesclado de pessoas-domicílios no diretório de trabalho
save bd_dom_pes_censo2000, replace
********************************************************************
*/////////////////////////////////////////////////////////////////////////////////////
*/////////////////////////////////////////////////////////////////////////////////////
********************************************************************
* ROTINA 5
* LEITURA DOS MICRODADOS DO CENSO DEMOGRÁFICO DE 2010
********************************************************************
* Acessando o diretório da base de dados original
* cd "C:\...\banco_de_dados\bd_orig2010"
********************************************************************
* Leitura dos microdados do Censo 2010 - Variáveis do Arquivo de Domicílios
clear
infix V0001 1-2 V0002 3-7 V0011 8-20 V0300 21-28 V0010 29-44 V1001 45-45 ///
V1002 46-47 V1003 48-50 V1004 51-52 V1006 53-53 V4001 54-55 V4002 56-57 ///
V0201 58-58 V2011 59-64 V2012 65-73 V0202 74-74 V0203 75-76 V6203 77-79 ///
V0204 80-81 V6204 82-84 V0205 85-85 V0206 86-86 V0207 87-87 V0208 88-89 ///
V0209 90-90 V0210 91-91 V0211 92-92 V0212 93-93 V0213 94-94 V0214 95-95 ///
V0215 96-96 V0216 97-97 V0217 98-98 V0218 99-99 V0219 100-100 V0220 101-101 ///
V0221 102-102 V0222 103-103 V0301 104-104 V0401 105-106 V0402 107-107 ///
V0701 108-108 V6529 109-115 V6530 116-125 V6531 126-133 V6532 134-142 ///
V6600 143-143 V6210 144-144 M0201 145-145 M2011 146-146 M0202 147-147 ///
M0203 148-148 M0204 149-149 M0205 150-150 M0206 151-151 M0207 152-152 ///
M0208 153-153 M0209 154-154 M0210 155-155 M0211 156-156 M0212 157-157 ///
M0213 158-158 M0214 159-159 M0215 160-160 M0216 161-161 M0217 162-162 ///
M0218 163-163 M0219 164-164 M0220 165-165 M0221 166-166 M0222 167-167 ///
M0301 168-168 M0401 169-169 M0402 170-170 M0701 171-171 ///
using Amostra_Domicilios_23.txt
* Salvando arquivo de domicilios_2010
save bd_domicilios_original_2010, replace
* Leitura dos microdados do Censo 2010 - Variáveis do Arquivo de Pessoas
clear
infix V0001 1-2 V0002 3-7 V0011 8-20 V0300 21-28 V0010 29-44 V1001 45-45 ///
V1002 46-47 V1003 48-50 V1004 51-52 V1006 53-53 V0502 54-55 V0504 56-57 ///
V0601 58-58 V6033 59-61 V6036 62-64 V6037 65-66 V6040 67-67 V0606 68-68 ///
V0613 69-69 V0614 70-70 V0615 71-71 V0616 72-72 V0617 73-73 V0618 74-74 ///
V0619 75-75 V0620 76-76 V0621 77-80 V0622 81-81 V6222 82-88 V6224 89-95 ///
V0623 96-98 V0624 99-101 V0625 102-102 V6252 103-109 V6254 110-116 ///
V6256 117-123 V0626 124-124 V6262 125-131 V6264 132-138 V6266 139-145 ///
V0627 146-146 V0628 147-147 V0629 148-149 V0630 150-151 V0631 152-152 ///
V0632 153-153 V0633 154-155 V0634 156-156 V0635 157-157 V6400 158-158 ///
V6352 159-161 V6354 162-164 V6356 165-167 V0636 168-168 V6362 169-175 ///
V6364 176-182 V6366 183-189 V0637 190-190 V0638 191-192 V0639 193-193 ///
V0640 194-194 V0641 195-195 V0642 196-196 V0643 197-197 V0644 198-198 ///
V0645 199-199 V6461 200-203 V6471 204-208 V0648 209-209 V0649 210-210 ///
V0650 211-211 V0651 212-212 V6511 213-218 V6513 219-224 V6514 225-230 ///
V0652 231-231 V6521 232-237 V6524 238-246 V6525 247-253 V6526 254-262 ///
V6527 263-269 V6528 270-278 V6529 279-285 V6530 286-295 V6531 296-303 ///
V6532 304-312 V0653 313-315 V0654 316-316 V0655 317-317 V0656 318-318 ///
V0657 319-319 V0658 320-320 V0659 321-321 V6591 322-327 V0660 328-328 ///
V6602 329-335 V6604 336-342 V6606 343-349 V0661 350-350 V0662 351-351 ///
V0663 352-352 V6631 353-354 V6632 355-356 V6633 357-358 V0664 359-359 ///
V6641 360-361 V6642 362-363 V6643 364-365 V0665 366-366 V6660 367-369 ///
V6664 370-370 V0667 371-371 V0668 372-372 V6681 373-374 V6682 375-378 ///
V0669 379-379 V6691 380-381 V6692 382-383 V6693 384-385 V6800 386-387 ///
V0670 388-388 V0671 389-390 V6900 391-391 V6910 392-392 V6920 393-393 ///
V6930 394-394 V6940 395-395 V6121 396-398 V0604 399-399 V0605 400-401 ///
V5020 402-403 V5060 404-405 V5070 406-413 V5080 414-422 V6462 423-426 ///
V6472 427-431 V5110 432-432 V5120 433-433 V5030 434-434 V5040 435-435 ///
V5090 436-436 V5100 437-437 V5130 438-439 M0502 440-440 M0601 441-441 ///
M6033 442-442 M0606 443-443 M0613 444-444 M0614 445-445 M0615 446-446 ///
M0616 447-447 M0617 448-448 M0618 449-449 M0619 450-450 M0620 451-451 ///
M0621 452-452 M0622 453-453 M6222 454-454 M6224 455-455 M0623 456-456 ///
M0624 457-457 M0625 458-458 M6252 459-459 M6254 460-460 M6256 461-461 ///
M0626 462-462 M6262 463-463 M6264 464-464 M6266 465-465 M0627 466-466 ///
M0628 467-467 M0629 468-468 M0630 469-469 M0631 470-470 M0632 471-471 ///
M0633 472-472 M0634 473-473 M0635 474-474 M6352 475-475 M6354 476-476 ///
M6356 477-477 M0636 478-478 M6362 479-479 M6364 480-480 M6366 481-481 ///
M0637 482-482 M0638 483-483 M0639 484-484 M0640 485-485 M0641 486-486 ///
M0642 487-487 M0643 488-488 M0644 489-489 M0645 490-490 M6461 491-491 ///
M6471 492-492 M0648 493-493 M0649 494-494 M0650 495-495 M0651 496-496 ///
M6511 497-497 M0652 498-498 M6521 499-499 M0653 500-500 M0654 501-501 ///
M0655 502-502 M0656 503-503 M0657 504-504 M0658 505-505 M0659 506-506 ///
M6591 507-507 M0660 508-508 M6602 509-509 M6604 510-510 M6606 511-511 ///
M0661 512-512 M0662 513-513 M0663 514-514 M6631 515-515 M6632 516-516 ///
M6633 517-517 M0664 518-518 M6641 519-519 M6642 520-520 M6643 521-521 ///
M0665 522-522 M6660 523-523 M0667 524-524 M0668 525-525 M6681 526-526 ///
M6682 527-527 M0669 528-528 M6691 529-529 M6692 530-530 M6693 531-531 ///
M0670 532-532 M0671 533-533 M6800 534-534 M6121 535-535 M0604 536-536 ///
M0605 537-537 M6462 538-538 M6472 539-539 using Amostra_Pessoas_23.txt
* Salvando arquivo de pessoas_2010
save bd_pessoas_original_2010, replace
*/////////////////////////////////////////////////////////////////////////////////////
*/////////////////////////////////////////////////////////////////////////////////////
********************************************************************
* ROTINA 6
* CRIAÇÃO DO ARQUIVO DE TRABALHO UNIFICADO DE PESSOAS E DOMICÍLIOS
* E PADRONIZAÇÃO DAS VARIÁVEIS DO CENSO DE 2010
********************************************************************
********************************************************************
* Acessando o diretório da base de dados original
* cd "C:\...\banco_de_dados\bd_orig2010"
********************************************************************
* Combinando os arquivos "pessoas" e "domicilios"
clear
use bd_pessoas_original_2010, clear
merge m:1 V0300 using bd_domicilios_original_2010
drop _merge
********************************************************************
* Filtrando apenas os registros de código 1 da variável V4001 - "Espécie do domicílio,
* opção 01 - Domicílio particular permanente ocupado" ***
* obs.: a pesquisa concernente aos domicílios foi restrita aos domicílios ocupados
keep if V4001 == 1
* V4001 "Espécie do Domicílio"
* 1 Particular Permanente
* 2 Particular Improvisado
* 3 Coletivo
* Salvando arquivo unificado de pessoas e domicílios
save bd_dom_pes_original_2010, replace
* Padronização de variáveis do Censo de 2010
********************************************************************
rename V0001 uf
rename V1002 mesorregiao
rename V1003 microrregiao
rename V1004 regiaometropolitana
rename V0002 municipio
rename V1006 sitdom
* 1 domicílio urbano; 2 domicílio rural
rename V0300 domicilio
rename V5020 familia
rename V5130 ordem_pessoa
rename V5040 especie_familia
* 1 Arranjo familiar 2 Arranjo não familiar
rename V6036 idade
rename V0601 sexo
* 1 Masculino 2 Feminino
rename V0606 cor_raca
* 1 Branca; 2 Preta; 3 Amarela; 4 Parda; 5 Indígena; 9 Ignorado
rename V6633 filhos_nascvivos
rename V6643 filhos_vivos
* Obs.: V6633 e V6641 referem-se às mães que tiveram filhos
gen respdom = .
replace respdom = 1 if V0502 == 1
replace respdom = 0 if V0502 ~= 1
gen conjuge = .
replace conjuge = 1 if V0502 == 2
replace conjuge = 0 if V0502 ~= 2
gen filho_men21_naoemanc = .
replace filho_men21_naoemanc = 1 if idade < 21 & V0640 == 5 & ///
(V0502 == 4 | V0502 == 5 | V0502 == 6)
replace filho_men21_naoemanc = 0 if idade < 21 & V0640 ~= 5 & ///
(V0502 ~= 4 & V0502 ~= 5 & V0502 ~= 6)
* Variável peso
rename V0010 pesocenso
gen fator_exp_am = .
replace fator_exp_am = pesocenso/(10^13)
* Variáveis relativas à educação e à qualificação
gen sabelerescrever = .
replace sabelerescrever = 1 if V0627 == 1
replace sabelerescrever = 0 if V0627 == 2
gen estudante = .
replace estudante = 1 if V0628 == 1 | V0628 == 2
replace estudante = 0 if V0628 == 3 | V0628 == 4
rename V6400 nivelinstrucao
replace nivelinstrucao = 0 if sabelerescrever == 0
* Variável V6400 - Nível de instrução
* 0 - Sem instrução (não sabe ler nem escrever - analfabeto)
* 1 - Fundamental incompleto
* 2 - Fundamental completo e nível médio incompleto
* 3 - Nível médio completo e superior incompleto
* 4 - Superior completo
* 5 - Não determinado
*****
* Variáveis originais utilizadas:
* Variável V0627 - Sabe ler e escrever
* 1 Sim
* 2 Não
* Variável V0628 - Frequenta escola ou creche
* 1- Sim, pública
* 2- Sim, particular
* 3- Não, já frequentou
* 4- Não, nunca frequentou
* Variável V0629 - Curso que frequenta
* 01- Creche
* 02- Pré-escolar (maternal e jardim da infância)
* 03- Classe de alfabetização - CA
* 04- Alfabetização de jovens e adultos
* 05- Regular do ensino fundamental
* 06- Educação de jovens e adultos - EJA - ou supletivo do ensino fundamental
* 07- Regular do ensino médio
* 08- Educação de jovens e adultos - EJA - ou supletivo do ensino médio
* 09- Superior de graduação
* 10- Especialização de nível superior ( mínimo de 360 horas )
* 11- Mestrado
* 12- Doutorado
* Branco
* V0633 - Curso mais elevado que frequentou
* 01- Creche, pré-escolar (maternal e jardim de infância), classe de alfabetização - CA
* 02- Alfabetização de jovens e adultos
* 03- Antigo primário (elementar)
* 04- Antigo ginásio (médio 1º ciclo)
* 05- Ensino fundamental ou 1º grau (da 1ª a 3ª série/ do 1º ao 4º ano)
* 06- Ensino fundamental ou 1º grau (4ª série/ 5º ano)
* 07- Ensino fundamental ou 1º grau (da 5ª a 8ª série/ 6º ao 9º ano)
* 08- Supletivo do ensino fundamental ou do 1º grau
* 09- Antigo científico, clássico, etc.....(médio 2º ciclo)
* 10- Regular ou supletivo do ensino médio ou do 2º grau
* 11- Superior de graduação
* 12- Especialização de nível superior (mínimo de 360 horas)
* 13- Mestrado
* 14- Doutorado
* Branco
* Variável V6400 - Nível de instrução
* 1- Sem instrução e fundamental incompleto
* 2- Fundamental completo e médio incompleto
* 3- Médio completo e superior incompleto
* 4- Superior completo
* 5- Não determinado
* Variáveis relativas à saúde
gen deficiente_visual = 0
replace deficiente_visual = 1 if V0614 == 1 & (V0615 > 1 & V0616 > 1 & V0617 > 1)
* Obs.: Para evitar duplicidade na contagem, manteve-se nessa variável apenas
* as pessoas com dificiência visual total.
* Idem para os demais tipos de deficiência.
gen deficiente_auditivo = 0
replace deficiente_auditivo = 1 if V0615 == 1 & (V0614 > 1 & V0616 > 1 & V0617 > 1)
gen deficiente_motor = 0
replace deficiente_motor = 1 if V0616 == 1 & (V0614 > 1 & V0615 > 1 & V0617 > 1)
gen deficiente_mental = 0
replace deficiente_mental = 1 if V0617 == 1 & (V0614 > 1 & V0615 > 1 & V0616 > 1)
gen maisde1_defic = 0
replace maisde1_defic = 1 if deficiente_visual + deficiente_auditivo + ///
deficiente_motor + deficiente_mental > 1
*****
* Variáveis originais utilizadas:
* V0614 - Dificuldade permanente de enxergar
* 1- Sim, não consegue de modo algum
* 2- Sim, grande dificuldade
* 3- Sim, alguma dificuldade
* 4- Não, nenhuma dificuldade
* 9- Ignorado
* V0615 - Dificuldade permanente de ouvir
* 1- Sim, não consegue de modo algum
* 2- Sim, grande dificuldade
* 3- Sim, alguma dificuldade
* 4- Não, nenhuma dificuldade
* 9- Ignorado
* V0616 - Dificuldade permanente de caminhar ou subir degraus
* 1- Sim, não consegue de modo algum
* 2- Sim, grande dificuldade
* 3- Sim, alguma dificuldade
* 4- Não, nenhuma dificuldade
* 9- Ignorado
* V0617 - Deficiência mental/intelectual permanente
* 1- Sim
* 2- Não
* 9- Ignorado
* V6633 – Total de filhos nascidos vivos que teve até 31 de julho de 2010
* V6643 – Total de filhos que teve e que estavam vivos em 31 de Julho de 2010
* Variáveis relativas ao trabalho e à seguridade social
rename V0641 trabalhoremunerado
rename V0642 trabrem_afastado
rename V0643 trabnaoremunerado
rename V0644 trabnaoremunerado_agric
gen trab_semanaref = .
replace trab_semanaref = 1 if (trabalhoremunerado == 1 | trabrem_afastado == 1 | ///
trabnaoremunerado == 1 | trabnaoremunerado_agric == 1)
replace trab_semanaref = 0 if (trabalhoremunerado == 2 & trabrem_afastado == 2 & ///
trabnaoremunerado == 2 & trabnaoremunerado_agric == 2)
rename V6461 ocupacao
gen trabalho_seg = .
replace trabalho_seg = 1 if V0648 <= 3
replace trabalho_seg = 0 if V0648 > 3
* A variável trabalho_seg compreende os trabalhadores com carteira de trabalho
* assinada, os funcionários públicos e os militares.
gen segespecial = .
replace segespecial = 1 if idade > 14 & ((ocupacao >= 6111 & ocupacao <= 6225) | ///
(ocupacao >= 9211 & ocupacao <= 9216))
replace segespecial = 0 if idade > 14 & (ocupacao < 6111 | (ocupacao > 6225 & ///
ocupacao < 9211) | ocupacao > 9216)
gen apos_pens = .
replace apos_pens = 1 if V0656 == 1
replace apos_pens = 0 if V0656 == 0 | V0656 == 9
gen contribprevoficial = .
replace contribprevoficial = 1 if V0650 == 1 | V0650 == 2 | V0648 <= 3
replace contribprevoficial = 0 if V0650 == 3 & V0648 > 3
gen trab_qual = .
replace trab_qual = 1 if ocupacao == 5132 | ocupacao == 9321 | ocupacao == 5162 | ///
ocupacao == 3312 | ocupacao == 6114 | ocupacao == 6111 | ocupacao == 6112 | ///
ocupacao == 9412 | ocupacao == 7531 | ocupacao == 7215 | ocupacao == 6123 | ///
ocupacao == 7122 | ocupacao == 7317 | ocupacao == 7318 | ocupacao == 7319 | ///
ocupacao == 2659 | ocupacao == 2651 | ocupacao == 3421 | ocupacao == 6122 | ///
ocupacao == 5246 | ocupacao == 5411 | ocupacao == 7126 | ocupacao == 5141 | ///
ocupacao == 6224 | ocupacao == 7113 | ocupacao == 3152 | ocupacao == 7115 | ///
ocupacao == 9333 | ocupacao == 9624 | ocupacao == 7314 | ocupacao == 7213 | ///
ocupacao == 3434 | ocupacao == 9612 | ocupacao == 4214 | ocupacao == 4212 | ///
ocupacao == 9611 | ocupacao == 5221 | ocupacao == 8322 | ocupacao == 8332 | ///
ocupacao == 8321 | ocupacao == 8331 | ocupacao == 9331 | ocupacao == 9332 | ///
ocupacao == 7312 | ocupacao == 7111 | ocupacao == 3133 | ocupacao == 3135 | ///
ocupacao == 7533 | ocupacao == 512 | ocupacao == 6121 | ocupacao == 5164 | ///
ocupacao == 5311 | ocupacao == 7542 | ocupacao == 1311 | ocupacao == 1312 | ///
ocupacao == 7411 | ocupacao == 5142 | ocupacao == 7221 | ocupacao == 2633 | ///
ocupacao == 3431 | ocupacao == 7544 | ocupacao == 5131 | ocupacao == 1412 | ///
ocupacao == 7123 | ocupacao == 5414 | ocupacao == 7322 | ocupacao == 7124 | ///
ocupacao == 7313 | ocupacao == 9121 | ocupacao == 9122 | ocupacao == 7132 | ///
ocupacao == 7511 | ocupacao == 7522 | ocupacao == 835 | ocupacao == 7412 | ///
ocupacao == 7311 | ocupacao == 7233 | ocupacao == 7231 | ocupacao == 7421 | ///
ocupacao == 8211 | ocupacao == 7127 | ocupacao == 0 | ocupacao == 9621 | ///
ocupacao == 8111 | ocupacao == 7211 | ocupacao == 8212 | ocupacao == 7214 | ///
ocupacao == 8219 | ocupacao == 2652 | ocupacao == 8343 | ocupacao == 8121 | ///
ocupacao == 8112 | ocupacao == 8181 | ocupacao == 8131 | ocupacao == 8171 | ///
ocupacao == 8172 | ocupacao == 8341 | ocupacao == 8154 | ocupacao == 8153 | ///
ocupacao == 8183 | ocupacao == 8157 | ocupacao == 7523 | ocupacao == 8342 | ///
ocupacao == 8182 | ocupacao == 8189 | ocupacao == 816 | ocupacao == 8156 | ///
ocupacao == 8114 | ocupacao == 8141 | ocupacao == 8142 | ocupacao == 8143 | ///
ocupacao == 8159 | ocupacao == 8152 | ocupacao == 9629 | ocupacao == 6129 | ///
ocupacao == 3435 | ocupacao == 9129 | ocupacao == 7119 | ocupacao == 7512 | ///
ocupacao == 7112 | ocupacao == 6225 | ocupacao == 9622 | ocupacao == 7131 | ///
ocupacao == 7224 | ocupacao == 5153 | ocupacao == 9411 | ocupacao == 613 | ///
ocupacao == 3222 | ocupacao == 2433 | ocupacao == 7316 | ocupacao == 7223 | ///
ocupacao == 7234 | ocupacao == 9334 | ocupacao == 7536 | ocupacao == 7212 | ///
ocupacao == 3123 | ocupacao == 3121 | ocupacao == 7534 | ocupacao == 3214 | ///
ocupacao == 324 | ocupacao == 3114 | ocupacao == 3117 | ocupacao == 3433 | ///
ocupacao == 7121 | ocupacao == 95 | ocupacao == 6221 | ocupacao == 7514 | ///
ocupacao == 7515 | ocupacao == 7513 | ocupacao == 5322 | ocupacao == 9112 | ///
ocupacao == 5168 | ocupacao == 9111 | ocupacao == 9211 | ocupacao == 9213 | ///
ocupacao == 9216 | ocupacao == 9313 | ocupacao == 9329 | ocupacao == 9214 | ///
ocupacao == 9212 | ocupacao == 9311 | ocupacao == 9312 | ocupacao == 7114 | ///
ocupacao == 9215 | ocupacao == 621 | ocupacao == 7532 | ocupacao == 7516 | ///
ocupacao == 7535 | ocupacao == 7541 | ocupacao == 9613 | ocupacao == 5243 | ///
ocupacao == 952 | ocupacao == 5212 | ocupacao == 5211 | ocupacao == 5244 | ///
ocupacao == 7125
replace trab_qual = 2 if ocupacao == 3256 | ocupacao == 299 | ocupacao == 2522 | ///
ocupacao == 3359 | ocupacao == 3352 | ocupacao == 3323 | ocupacao == 3333 | ///
ocupacao == 3321 | ocupacao == 3339 | ocupacao == 3353 | ocupacao == 3311 | ///
ocupacao == 3334 | ocupacao == 3258 | ocupacao == 5312 | ocupacao == 2421 | ///
ocupacao == 2511 | ocupacao == 2413 | ocupacao == 2161 | ocupacao == 2162 | ///
ocupacao == 2621 | ocupacao == 2412 | ocupacao == 2635 | ocupacao == 5161 | ///
ocupacao == 2655 | ocupacao == 5111 | ocupacao == 3413 | ocupacao == 3315 | ///
ocupacao == 2653 | ocupacao == 5223 | ocupacao == 2622 | ocupacao == 599 | ///
ocupacao == 4211 | ocupacao == 523 | ocupacao == 2165 | ocupacao == 7543 | ///
ocupacao == 9623 | ocupacao == 3313 | ocupacao == 2411 | ocupacao == 3154 | ///
ocupacao == 3324 | ocupacao == 7315 | ocupacao == 5242 | ocupacao == 3251 | ///
ocupacao == 2163 | ocupacao == 3432 | ocupacao == 3118 | ocupacao == 2166 | ///
ocupacao == 2513 | ocupacao == 2512 | ocupacao == 2519 | ocupacao == 3331 | ///
ocupacao == 2265 | ocupacao == 2654 | ocupacao == 112 | ocupacao == 1219 | ///
ocupacao == 1324 | ocupacao == 1323 | ocupacao == 1322 | ocupacao == 1321 | ///
ocupacao == 1114 | ocupacao == 1213 | ocupacao == 1222 | ocupacao == 1212 | ///
ocupacao == 1344 | ocupacao == 1343 | ocupacao == 1341 | ocupacao == 1345 | ///
ocupacao == 1342 | ocupacao == 133 | ocupacao == 1221 | ocupacao == 1349 | ///
ocupacao == 1211 | ocupacao == 1112 | ocupacao == 2631 | ocupacao == 2352 | ///
ocupacao == 3113 | ocupacao == 7323 | ocupacao == 2146 | ocupacao == 2151 | ///
ocupacao == 2141 | ocupacao == 2144 | ocupacao == 2149 | ocupacao == 4227 | ///
ocupacao == 2641 | ocupacao == 411 | ocupacao == 2529 | ocupacao == 2351 | ///
ocupacao == 2423 | ocupacao == 2262 | ocupacao == 7222 | ocupacao == 5112 | ///
ocupacao == 2111 | ocupacao == 5245 | ocupacao == 1431 | ocupacao == 142 | ///
ocupacao == 1411 | ocupacao == 1439 | ocupacao == 1346 | ocupacao == 5152 | ///
ocupacao == 8312 | ocupacao == 5413 | ocupacao == 5113 | ocupacao == 3355 | ///
ocupacao == 3257 | ocupacao == 7413 | ocupacao == 7422 | ocupacao == 5165 | ///
ocupacao == 3423 | ocupacao == 2356 | ocupacao == 2642 | ocupacao == 2612 | ///
ocupacao == 1111 | ocupacao == 9123 | ocupacao == 2656 | ocupacao == 8311 | ///
ocupacao == 7232 | ocupacao == 999 | ocupacao == 2112 | ocupacao == 2636 | ///
ocupacao == 5241 | ocupacao == 3151 | ocupacao == 8344 | ocupacao == 4132 | ///
ocupacao == 3132 | ocupacao == 3131 | ocupacao == 8151 | ocupacao == 8155 | ///
ocupacao == 4131 | ocupacao == 8132 | ocupacao == 8122 | ocupacao == 2267 | ///
ocupacao == 3332 | ocupacao == 4414 | ocupacao == 2355 | ocupacao == 2353 | ///
ocupacao == 2354 | ocupacao == 7549 | ocupacao == 8113 | ocupacao == 3153 | ///
ocupacao == 5412 | ocupacao == 232 | ocupacao == 2341 | ocupacao == 2342 | ///
ocupacao == 2133 | ocupacao == 2431 | ocupacao == 2263 | ocupacao == 2269 | ///
ocupacao == 2221 | ocupacao == 2359 | ocupacao == 3259 | ocupacao == 3221 | ///
ocupacao == 323 | ocupacao == 3314 | ocupacao == 3411 | ocupacao == 2222 | ///
ocupacao == 2432 | ocupacao == 2434 | ocupacao == 2619 | ocupacao == 2523 | ///
ocupacao == 2514 | ocupacao == 2113 | ocupacao == 4224 | ocupacao == 4226 | ///
ocupacao == 3322 | ocupacao == 412 | ocupacao == 3344 | ocupacao == 3343 | ///
ocupacao == 3342 | ocupacao == 3122 | ocupacao == 5222 | ocupacao == 5151 | ///
ocupacao == 3341 | ocupacao == 3142 | ocupacao == 3514 | ocupacao == 3522 | ///
ocupacao == 3212 | ocupacao == 3521 | ocupacao == 3513 | ocupacao == 3213 | ///
ocupacao == 3255 | ocupacao == 3141 | ocupacao == 3211 | ocupacao == 3512 | ///
ocupacao == 3119 | ocupacao == 3111 | ocupacao == 3139 | ocupacao == 3112 | ///
ocupacao == 3115 | ocupacao == 3511 | ocupacao == 3254 | ocupacao == 3116 | ///
ocupacao == 3155 | ocupacao == 4223 | ocupacao == 3253 | ocupacao == 7321 | ///
ocupacao == 4221 | ocupacao == 4415 | ocupacao == 4411 | ocupacao == 4222 | ///
ocupacao == 4311 | ocupacao == 4321 | ocupacao == 5321 | ocupacao == 5329 | ///
ocupacao == 5163 | ocupacao == 4322 | ocupacao == 4412 | ocupacao == 4229 | ///
ocupacao == 4323 | ocupacao == 4312 | ocupacao == 4416 | ocupacao == 511 | ///
ocupacao == 4225 | ocupacao == 5419 | ocupacao == 3412 | ocupacao == 4213 | ///
ocupacao == 4313 | ocupacao == 2643 | ocupacao == 3422 | ocupacao == 2164 | ///
ocupacao == 5249 | ocupacao == 225
replace trab_qual = 3 if ocupacao == 2611 | ocupacao == 2132 | ///
ocupacao == 2131 | ocupacao == 2261 | ocupacao == 2521 | ///
ocupacao == 1223 | ocupacao == 2142 | ocupacao == 2143 | ///
ocupacao == 2152 | ocupacao == 2153 | ocupacao == 2145 | ///
ocupacao == 2424 | ocupacao == 2264 | ocupacao == 2266 | ///
ocupacao == 2114 | ocupacao == 212 | ocupacao == 2212 | ///
ocupacao == 2211 | ocupacao == 224 | ocupacao == 231 | ///
ocupacao == 233 | ocupacao == 2634 | ocupacao == 2632
*****
* Variáveis originais utilizadas:
* V0639 – Natureza da união
* 1 – Casamento civil e religioso
* 2 – Só casamento civil
* 3 – Só casamento religioso
* 4 – União consensual
* V0641 - Na semana de 25 a 31/07/10, durante pelo menos 1 hora, trabalhou
* ganhando em dinheiro, produtos, mercadorias ou benefícios:
* 1- Sim
* 2- Não
* V0642 - Na semana de 25 a 31/07/10, tinha trabalho remunerado do
* qual estava temporariamente afastado(a):
* 1- Sim
* 2- Não
* V0644 - Na semana de 25 a 31/07/10, durante pelo menos 1 hora,
* trabalhou na plantação, criação de animais ou pesca, somente
* para alimentação dos moradores do domicílio (inclusive caça e
* extração vegetal):
* 1- Sim
* 2- Não
* V0648 - Nesse trabalho era:
* 1- Empregado com carteira de trabalho assinada
* 2- Militar do exército, marinha, aeronáutica, policia militar ou corpo de bombeiros
* 3- Empregado pelo regime jurídico dos funcionários públicos
* 4- Empregado sem carteira de trabalho assinada
* 5- Conta própria
* 6- Empregador
* 7- Não remunerado
* branco:
* V0650 - Era contribuinte de instituto de previdência oficial em
* algum trabalho que tinha na semana de 25 a 31 de Julho de 2010:
* 1- Sim, no trabalho principal
* 2- Sim, em outro trabalho
* 3- Não
* Branco: para quem, na semana de 25 a 31 de julho de 2010:
* - era menor de 10 anos de idade; ou
* - não trabalhou ganhando em dinheiro, produtos, mercadorias ou benefícios; e
* - não tinha algum trabalho remunerado do qual estava temporariamente afastado(a); e
* - não ajudou sem qualquer pagamento no trabalho remunerado de morador do domicílio; e
* - trabalhou ou não na plantação, criação de animais ou pesca, somente para alimentação
* dos moradores do domicílio; ou
* - era Empregado com carteira de trabalho assinada; ou Militar do Exército, Marinha,
* Aeronáutica, Polícia Militar ou Corpo de
* Bombeiros; ou empregado pelo regime jurídico dos funcionários públicos; ou
* - trabalhou como “não remunerado” e tinha apenas um trabalho.
* V6461 - Ocupação – código
********************************************************************
* Variáveis relativas ao padrão de vida
gen posse_moradia = .
replace posse_moradia = 1 if V0201 < 3
replace posse_moradia = 0 if V0201 >= 3
gen wc_priv = .
replace wc_priv = 1 if V0205 > 0
replace wc_priv = 0 if V0205 == 0
gen esg_sanit_adeq = .
replace esg_sanit_adeq = 1 if V0207 == 1 | V0207 == 2
replace esg_sanit_adeq = 0 if V0207 > 2
gen supr_agua_adeq = .
replace supr_agua_adeq = 1 if V0208 == 1 | V0208 == 2
replace supr_agua_adeq = 0 if V0208 > 2
gen agua_canal = .
replace agua_canal = 1 if V0209 == 1
replace agua_canal = 0 if V0209 == 2 | V0209 == 3
gen coleta_lixo = .
replace coleta_lixo = 1 if V0210 == 1 | V0210 == 2
replace coleta_lixo = 0 if V0210 > 2
gen energia_elet = .
replace energia_elet = 1 if V0211 == 1 | V0211 == 2
replace energia_elet = 0 if V0211 == 3
gen radio = .
replace radio = 1 if V0213 == 1
replace radio = 0 if V0213 == 2
gen tv = .
replace tv = 1 if V0214 == 1
replace tv = 0 if V0214 == 2
gen maq_lavar = .
replace maq_lavar = 1 if V0215 == 1
replace maq_lavar = 0 if V0215 == 2
gen gelfrez = .
replace gelfrez = 1 if V0216 == 1
replace gelfrez = 0 if V0216 == 2
gen telefone = .
replace telefone = 1 if V0218 == 1 | V0217 == 1
replace telefone = 0 if V0218 == 2 & V0217 == 2
gen autom_part = .
replace autom_part = 1 if V0222 == 1
replace autom_part = 0 if V0222 == 2
gen nreletrod = radio + tv + maq_lavar + gelfrez + telefone
* OBS.: no cálculo da variável "nreletrod" foram considerados
* apenas itens comuns aos três censos.
gen dens_mor_dorm_adeq = .
replace dens_mor_dorm_adeq = 1 if V6204/10 <= 2
replace dens_mor_dorm_adeq = 0 if V6204/10 > 2
*****
* Variáveis originais utilizadas:
* V0201 - Domicílio, condição de ocupação:
* 1- Próprio de algum morador - já pago
* 2- Próprio de algum morador - ainda pagando
* 3- Alugado
* 4- Cedido por empregador
* 5- Cedido de outra forma
* 6- Outra condição
* V0205 - Banheiros de uso exclusivo, número:
* 0- Zero banheiros
* 1- Um banheiro
* 2- Dois banheiros
* 3- Três banheiros
* 4- Quatro banheiros
* 5- Cinco banheiros
* 6- Seis banheiros
* 7- Sete banheiros
* 8- Oito banheiros
* 9- Nove ou mais banheiros
* V0207 - Esgotamento sanitário, tipo:
* 1- Rede geral de esgoto ou pluvial
* 2- Fossa séptica
* 3- Fossa rudimentar
* 4- Vala
* 5- Rio, lago ou mar
* 6- Outro
* V0208 - Abastecimento de água, forma:
* 01- Rede geral de distribuição
* 02- Poço ou nascente na propriedade
* 03- Poço ou nascente fora da propriedade
* 04- Carro-pipa
* 05- Água da chuva armazenada em cisterna
* 06- Água da chuva armazenada de outra forma
* 07- Rios, açudes, lagos e igarapés
* 08- Outra
* 09- Poço ou nascente na aldeia
* 10- Poço ou nascente fora da aldeia
* V0209 - Abastecimento de água, canalização:
* 1- Sim, em pelo menos um cômodo
* 2- Sim, só na propriedade ou terreno
* 3- Não
* V0210 - Lixo, destino:
* 1- Coletado diretamente por serviço de limpeza
* 2- Colocado em caçamba de serviço de limpeza
* 3- Queimado (na propriedade)
* 4- Enterrado (na propriedade)
* 5- Jogado em terreno baldio ou logradouro
* 6- Jogado em rio, lago ou mar
* 7- Tem outro destino
* V0211 - Energia elétrica, existência:
* 1- Sim, de companhia distribuidora
* 2- Sim, de outras fontes
* 3- Não existe energia elétrica
* V0213 - Existência de rádio
* 1 - Sim
* 2 - Não
* V0216 - Existência de geladeira/freezer
* 1 - Sim
* 2 - Não
* V0214 - Existência de televisão
* 1 - Sim
* 2 - Não
* V0215 - Existência de máquina de lavar roupa
* 1 - Sim
* 2 - Não
* V0217 Existência de telefone celular
* 1- Sim
* 2- Não
* V0218 - Existência de telefone fixo
* 1 - Sim
* 2 - Não
* V0222 - Existência de automóvel para uso particular
* 1 - Sim
* 2 - Não
* V6204 - Densidade de morador / dormitório
* Variáveis auxiliares
gen nrpesfam = 1
gen populacao = 1
********************************************************************
* Substituindo código do município por código padronizado para os três censos
replace municipio = 2300200 if municipio == 200
replace municipio = 2302057 if municipio == 2057
replace municipio = 2302305 if municipio == 2305
replace municipio = 2302602 if municipio == 2602
replace municipio = 2303907 if municipio == 3907
replace municipio = 2304251 if municipio == 4251
replace municipio = 2304707 if municipio == 4707
replace municipio = 2306553 if municipio == 6553
replace municipio = 2307254 if municipio == 7254
replace municipio = 2307809 if municipio == 7809
replace municipio = 2307908 if municipio == 7908
replace municipio = 2308906 if municipio == 8906
replace municipio = 2303402 if municipio == 3402
replace municipio = 2304236 if municipio == 4236
replace municipio = 2305001 if municipio == 5001
replace municipio = 2305308 if municipio == 5308
replace municipio = 2312304 if municipio == 12304
replace municipio = 2313401 if municipio == 13401
replace municipio = 2313609 if municipio == 13609
replace municipio = 2314102 if municipio == 14102
replace municipio = 2304004 if municipio == 4004
replace municipio = 2304509 if municipio == 4509
replace municipio = 2308807 if municipio == 8807
replace municipio = 2313906 if municipio == 13906
replace municipio = 2300507 if municipio == 507
replace municipio = 2308203 if municipio == 8203
replace municipio = 2303105 if municipio == 3105
replace municipio = 2304350 if municipio == 4350
replace municipio = 2304657 if municipio == 4657
replace municipio = 2304905 if municipio == 4905
replace municipio = 2306108 if municipio == 6108
replace municipio = 2308005 if municipio == 8005
replace municipio = 2308377 if municipio == 8377
replace municipio = 2309003 if municipio == 9003
replace municipio = 2309904 if municipio == 9904
replace municipio = 2312007 if municipio == 12007
replace municipio = 2312809 if municipio == 12809
replace municipio = 2312908 if municipio == 12908
replace municipio = 2305803 if municipio == 5803
replace municipio = 2305902 if municipio == 5902
replace municipio = 2310951 if municipio == 10951
replace municipio = 2311009 if municipio == 11009
replace municipio = 2311702 if municipio == 11702
replace municipio = 2313955 if municipio == 13955
replace municipio = 2303659 if municipio == 3659
replace municipio = 2305209 if municipio == 5209
replace municipio = 2312205 if municipio == 12205
replace municipio = 2300754 if municipio == 754
replace municipio = 2306405 if municipio == 6405
replace municipio = 2313500 if municipio == 13500
replace municipio = 2310209 if municipio == 10209
replace municipio = 2310258 if municipio == 10258
replace municipio = 2312403 if municipio == 12403
replace municipio = 2306306 if municipio == 6306
replace municipio = 2313559 if municipio == 13559
replace municipio = 2313757 if municipio == 13757
replace municipio = 2313807 if municipio == 13807
replace municipio = 2300903 if municipio == 903
replace municipio = 2304608 if municipio == 4608
replace municipio = 2310704 if municipio == 10704
replace municipio = 2312601 if municipio == 12601
replace municipio = 2313351 if municipio == 13351
replace municipio = 2302800 if municipio == 2800
replace municipio = 2303006 if municipio == 3006
replace municipio = 2306603 if municipio == 6603
replace municipio = 2310407 if municipio == 10407
replace municipio = 2300150 if municipio == 150
replace municipio = 2301208 if municipio == 1208
replace municipio = 2301406 if municipio == 1406
replace municipio = 2302107 if municipio == 2107
replace municipio = 2302909 if municipio == 2909
replace municipio = 2305100 if municipio == 5100
replace municipio = 2306504 if municipio == 6504
replace municipio = 2309102 if municipio == 9102
replace municipio = 2309805 if municipio == 9805
replace municipio = 2310100 if municipio == 10100
replace municipio = 2311603 if municipio == 11603
replace municipio = 2301950 if municipio == 1950
replace municipio = 2303956 if municipio == 3956
replace municipio = 2309458 if municipio == 9458
replace municipio = 2302206 if municipio == 2206
replace municipio = 2303501 if municipio == 3501
replace municipio = 2310852 if municipio == 10852
replace municipio = 2301000 if municipio == 1000
replace municipio = 2303709 if municipio == 3709
replace municipio = 2304285 if municipio == 4285
replace municipio = 2304400 if municipio == 4400
replace municipio = 2304954 if municipio == 4954
replace municipio = 2306256 if municipio == 6256
replace municipio = 2307650 if municipio == 7650
replace municipio = 2307700 if municipio == 7700
replace municipio = 2309706 if municipio == 9706
replace municipio = 2305233 if municipio == 5233
replace municipio = 2309607 if municipio == 9607
replace municipio = 2301257 if municipio == 1257
replace municipio = 2304103 if municipio == 4103
replace municipio = 2305605 if municipio == 5605
replace municipio = 2305654 if municipio == 5654
replace municipio = 2308609 if municipio == 8609
replace municipio = 2309300 if municipio == 9300
replace municipio = 2309409 if municipio == 9409
replace municipio = 2311264 if municipio == 11264
replace municipio = 2313203 if municipio == 13203
replace municipio = 2301851 if municipio == 1851
replace municipio = 2302404 if municipio == 2404
replace municipio = 2303931 if municipio == 3931
replace municipio = 2305266 if municipio == 5266
replace municipio = 2307635 if municipio == 7635
replace municipio = 2311306 if municipio == 11306
replace municipio = 2311405 if municipio == 11405
replace municipio = 2300408 if municipio == 408
replace municipio = 2301505 if municipio == 1505
replace municipio = 2303600 if municipio == 3600
replace municipio = 2310308 if municipio == 10308
replace municipio = 2311900 if municipio == 11900
replace municipio = 2313302 if municipio == 13302
replace municipio = 2300309 if municipio == 309
replace municipio = 2304269 if municipio == 4269
replace municipio = 2308351 if municipio == 8351
replace municipio = 2308500 if municipio == 8500
replace municipio = 2310506 if municipio == 10506
replace municipio = 2310902 if municipio == 10902
replace municipio = 2312700 if municipio == 12700
replace municipio = 2313005 if municipio == 13005
replace municipio = 2301109 if municipio == 1109
replace municipio = 2304459 if municipio == 4459
replace municipio = 2305357 if municipio == 5357
replace municipio = 2306207 if municipio == 6207
replace municipio = 2300705 if municipio == 705
replace municipio = 2305332 if municipio == 5332
replace municipio = 2307007 if municipio == 7007
replace municipio = 2307601 if municipio == 7601
replace municipio = 2308708 if municipio == 8708
replace municipio = 2310001 if municipio == 10001
replace municipio = 2311504 if municipio == 11504
replace municipio = 2311801 if municipio == 11801
replace municipio = 2312502 if municipio == 12502
replace municipio = 2313104 if municipio == 13104
replace municipio = 2306702 if municipio == 6702
replace municipio = 2306801 if municipio == 6801
replace municipio = 2306900 if municipio == 6900
replace municipio = 2304277 if municipio == 4277
replace municipio = 2306009 if municipio == 6009
replace municipio = 2310803 if municipio == 10803
replace municipio = 2311231 if municipio == 11231
replace municipio = 2303808 if municipio == 3808
replace municipio = 2305407 if municipio == 5407
replace municipio = 2305506 if municipio == 5506
replace municipio = 2309508 if municipio == 9508
replace municipio = 2311355 if municipio == 11355
replace municipio = 2300804 if municipio == 804
replace municipio = 2303303 if municipio == 3303
replace municipio = 2307403 if municipio == 7403
replace municipio = 2313252 if municipio == 13252
replace municipio = 2314003 if municipio == 14003
replace municipio = 2301802 if municipio == 1802
replace municipio = 2305704 if municipio == 5704
replace municipio = 2307502 if municipio == 7502
replace municipio = 2313708 if municipio == 13708
replace municipio = 2301307 if municipio == 1307
replace municipio = 2301604 if municipio == 1604
replace municipio = 2302701 if municipio == 2701
replace municipio = 2311207 if municipio == 11207
replace municipio = 2311959 if municipio == 11959
replace municipio = 2300606 if municipio == 606
replace municipio = 2303204 if municipio == 3204
replace municipio = 2304301 if municipio == 4301
replace municipio = 2304806 if municipio == 4806
replace municipio = 2301703 if municipio == 1703
replace municipio = 2302008 if municipio == 2008
replace municipio = 2308104 if municipio == 8104
replace municipio = 2301901 if municipio == 1901
replace municipio = 2304202 if municipio == 4202
replace municipio = 2307106 if municipio == 7106
replace municipio = 2307304 if municipio == 7304
replace municipio = 2308401 if municipio == 8401
replace municipio = 2309201 if municipio == 9201
replace municipio = 2311108 if municipio == 11108
replace municipio = 2312106 if municipio == 12106
replace municipio = 2300101 if municipio == 101
replace municipio = 2302503 if municipio == 2503
replace municipio = 2307205 if municipio == 7205
replace municipio = 2308302 if municipio == 8302
replace municipio = 2310605 if municipio == 10605
********************************************************************
* Eliminando variáveis originais não utilizadas no programa
drop V0011 V1001 V6033 V6037 V6040 V0613 V0615 V0618 V0619 V0620 V0621 ///
V0622 V6222 V6224 V0623 V0624 V0625 V6252 V6254 V6256 V0626 V6262 V6264 ///
V6266 V0631 V0632 V0634 V6352 V6354 V6356 V0636 V6362 V6364 V6366 V0637 ///
V0639 V0640 V0645 V0649 V0651 V6511 V6513 V6514 V0652 V6521 V6524 V6526 ///
V6527 V6528 V6529 V6530 V6531 V6532 V0653 V0654 V0655 V0659 V6591 V0660 ///
V6602 V6604 V6606 V0661 V0662 V0663 V6631 V6632 V0664 V6642 V0665 V6660 ///
V0668 V6681 V6682 V0669 V6691 V6692 V6693 V6800 V0670 V0671 V6900 V6910 ///
V6920 V6930 V6940 V6121 V0605 V5080 V5110 V5120 V5090 V5100 M0502 M0601 ///
M6033 M0606 M0613 M0614 M0615 M0616 M0617 M0618 M0619 M0620 M0621 M0622 ///
M6222 M6224 M0623 M0624 M0625 M6252 M6254 M6256 M0626 M6262 M6264 M6266 ///
M0627 M0628 M0629 M0630 M0631 M0632 M0633 M0634 M0635 M6352 M6354 M6356 ///
M0636 M6362 M6364 M6366 M0637 M0638 M0639 M0640 M0641 M0642 M0643 M0644 ///
M0645 M6461 M6471 M0648 M0649 M0650 M0651 M6511 M0652 M6521 M0653 M0654 ///
M0655 M0656 M0657 M0658 M0659 M6591 M0660 M6602 M6604 M6606 M0661 M0662 ///
M0663 M6631 M6632 M6633 M0664 M6641 M6642 M6643 M0665 M6660 M0667 M0668 ///
M6681 M6682 M0669 M6691 M6692 M6693 M0670 M0671 M6800 M6121 M0604 M0605 ///
M6462 M6472 V2012 V6203 V0206 V0212 V0219 V0220 V0221 V0301 V0401 V0402 ///
V0701 V6600 V6210 M0201 M2011 M0202 M0203 M0204 M0205 M0206 M0207 M0208 ///
M0209 M0210 M0211 M0212 M0213 M0214 M0215 M0216 M0217 M0218 M0219 M0220 ///
M0221 M0222 M0301 M0401 M0402 M0701 V6664 V0667 V0502 V0504 V0614 V0616 ///
V0617 V0627 V0628 V0629 V0630 V0633 V0635 V0638 V6471 V0648 V6525 V0656 ///
V0657 V6641 V0604 V5060 V5070 V6462 V6472 V4001 V4002 V0201 V2011 V0202 ///
V0203 V0204 V6204 V0205 V0207 V0208 V0209 V0210 V0211 V0213 V0214 V0215 ///
V0216 V0217 V0218 V0222 V0650 V0658 V5030
********************************************************************
* Acessando o diretório das bases de dados de trabalho
* cd "C:\...\banco_de_dados\censo2010"
* Gravando arquivo mesclado de pessoas-domicílios no diretório de trabalho
save bd_dom_pes_censo2010, replace
********************************************************************
*/////////////////////////////////////////////////////////////////////////////////////
* OBS.: ALTERAR O ANO DO CENSO (censoXXXX, ONDE XXXX = 1991,
* 2000 OU 2010) NO NOME DO DIRETÓRIO E NOS ARQUIVOS DE
* ARMAZENAMENTO DE DADOS EM CADA UMA DAS ROTINAS SEGUINTES
* PARA OBTER OS INDICADORES DO ANO DESEJADO
*/////////////////////////////////////////////////////////////////////////////////////
* ROTINA 7
* CRIANDO VARIÁVEIS E ARQUIVO RELATIVOS ÀS PESSOAS
*/////////////////////////////////////////////////////////////////////////////////////
********************************************************************
* Acessando o diretório das bases de dados de trabalho
* cd "C:\...\banco_de_dados\censo_XXXX"
use bd_dom_pes_censo_XXXX, clear
********************************************************************
* Variáveis relacionadas à idade
gen nrpes_10m = 1 if idade >= 10
gen crianca7_17 = .
replace crianca7_17 = 1 if idade >= 7 & idade <= 17
replace crianca7_17 = 0 if idade < 7 | idade > 17
* criança7_17 é a variável utilizada nos Censos de 1991 e 2000,
* que corresponde à idade apropriada do ensino fundamental e médio.
* Para 2010, manteve-se o mesmo nome, embora tenha sido considerado
* o início do fundamental a idade de 6 anos, de acordo com a
* legislação atual.
gen adulto15 = .
replace adulto15 = 1 if idade >= 15
replace adulto15 = 0 if idade < 15
gen adulto18 = .
replace adulto18 = 1 if idade >= 18
replace adulto18 = 0 if idade < 18
gen adulto21 = .
replace adulto21 = 1 if idade >= 21
replace adulto21 = 0 if idade < 21
gen adulto25 = .
replace adulto25 = 1 if idade >= 25
replace adulto25 = 0 if idade < 25
gen idade_ativa = .
replace idade_ativa = 1 if idade >= 15 & idade < 60
replace idade_ativa = 0 if idade < 15 | idade >= 60
gen jovem = .
replace jovem = 1 if idade >= 15 & idade <= 29
replace jovem = 0 if idade < 15 & idade > 29
********************************************************************
* Variáveis de escolaridade
gen analfabeto = .
replace analfabeto = 1 if sabelerescrever == 0
replace analfabeto = 0 if sabelerescrever == 1
gen analfabeto_10m = .
replace analfabeto_10m = 1 if idade >= 10 & sabelerescrever == 0
replace analfabeto_10m = 0 if idade >= 10 & sabelerescrever == 1
gen analfabeto_15m = .
replace analfabeto_15m = 1 if idade >= 15 & sabelerescrever == 0
replace analfabeto_15m = 0 if idade >= 15 & sabelerescrever == 1
gen analfabeto_18m = .
replace analfabeto_18m = 1 if idade >= 18 & sabelerescrever == 0
replace analfabeto_18m = 0 if idade >= 18 & sabelerescrever == 1
gen analfabeto_25m = .
replace analfabeto_25m = 1 if idade >= 25 & sabelerescrever == 0
replace analfabeto_25m = 0 if idade >= 25 & sabelerescrever == 1
gen baixa_instr_18m = .
replace baixa_instr_18m = 1 if idade >= 18 & nivelinstrucao == 1
replace baixa_instr_18m = 0 if idade >= 18 & nivelinstrucao ~= 1
* Obs.: a variável baixa_instr_18m compreende as pessoas com
* 18 anos ou mais que sabem ler e escrever, mas que não tenham
* concluído o ensino fundamental ou equivalente, refletindo
* um baixo nível de instrução.
gen nivel_medio = .
replace nivel_medio = 1 if nivelinstrucao == 3
replace nivel_medio = 0 if nivelinstrucao ~= 3
gen nivel_superior = .
replace nivel_superior = 1 if nivelinstrucao == 4
replace nivel_superior = 0 if nivelinstrucao ~= 4
********************************************************************
* Variáveis de saúde
gen pessoa_com_limitacao = .
replace pessoa_com_limitacao = 1 if deficiente_visual == 1 | ///
deficiente_auditivo == 1 | deficiente_motor == 1 | ///
deficiente_mental == 1 | maisde1_defic == 1
replace pessoa_com_limitacao = 0 if deficiente_visual ~= 1 & ///
deficiente_auditivo ~= 1 & deficiente_motor ~= 1 & ///
deficiente_mental ~= 1 & maisde1_defic ~= 1
* Obs.: o Censo de 1991 não informa no item 6 da variável
* C0311 quais os membros (superiores ou inferiores) que faltam.
* Desta forma, não foi computada. No entanto, foi computada o
* item 8 que se refere a mais de uma deficiência.
gen mae_com_obito = .
replace mae_com_obito = 1 if idade < 25 & filhos_nascvivos ~= . & ///
filhos_nascvivos ~= 0 & filhos_nascvivos ~= 99 & ///
(filhos_nascvivos - filhos_vivos) > 0
replace mae_com_obito = 0 if idade < 25 & filhos_nascvivos ~= . & ///
filhos_nascvivos ~= 0 & filhos_nascvivos ~= 99 & ///
(filhos_nascvivos - filhos_vivos) == 0
* OBSERVAÇÃO IMPORTANTE: o censo de 1991 não permite saber qual a
* idade do filho que faleceu. Assim, optou-se por limitar a idade
* da mãe até 24 anos para assegurar que o filho faleceu ainda criança,
* embora não se possa saber qual a idade da criança. Neste caso, se
* uma mãe < 25 anos teve um filho que já falecera, essa criança muito
* provavelmente não alcançou 10 anos de idade.
********************************************************************
* Variáveis de trabalho e seguidade social
gen ocupado = .
replace ocupado = 1 if idade >= 10 & trab_semanaref == 1
replace ocupado = 0 if idade >= 10 & trab_semanaref == 0
* Rotina para definir as pessoas com direito à previdência social
gen segurado = .
gen paioumae_segnaoesp = .
replace paioumae_segnaoesp = 1 if (respdom == 1 | conjuge == 1) & ///
(trabalho_seg == 1 | contribprevoficial == 1)
replace paioumae_segnaoesp = 0 if (respdom == 1 | conjuge == 1) & ///
(trabalho_seg == 0 & contribprevoficial == 0)
gen outras_pes_segnaoesp = .
replace outras_pes_segnaoesp = 1 if (respdom == 0 & conjuge == 0) & ///
(trabalho_seg == 1 | contribprevoficial == 1)
replace outras_pes_segnaoesp = 0 if (respdom == 0 & conjuge == 0) & ///
(trabalho_seg == 0 & contribprevoficial == 0)
gen paioumae_segesp = .
replace paioumae_segesp = 1 if (respdom == 1 | conjuge == 1) & ///
segespecial == 1
replace paioumae_segesp = 0 if (respdom == 1 | conjuge == 1) & ///
segespecial == 0
gen outras_pes_segesp = .
replace outras_pes_segesp = 1 if (respdom == 0 & conjuge == 0) & ///
(trabalho_seg == 1 | contribprevoficial == 1)
replace outras_pes_segesp = 0 if (respdom == 0 & conjuge == 0) & ///
(trabalho_seg == 0 & contribprevoficial == 0)
gen paioumae_seg = .
replace paioumae_seg = 1 if (respdom == 1 | conjuge == 1) & ///
(paioumae_segnaoesp == 1 | paioumae_segesp == 1 | apos_pens == 1)
replace paioumae_seg = 0 if (respdom == 1 | conjuge == 1) & ///
(paioumae_segnaoesp == 0 & paioumae_segesp == 0 & apos_pens == 0)
gen outras_pes_seg = .
replace outras_pes_seg = 1 if (respdom == 0 & conjuge == 0) & ///
(outras_pes_segnaoesp == 1 | outras_pes_segesp == 1 | apos_pens == 1)
replace outras_pes_seg = 0 if (respdom == 0 & conjuge == 0) & ///
(outras_pes_segnaoesp == 0 & outras_pes_segesp == 0 & apos_pens == 0)
save bd_pessoas_censoXXXX, replace
************
* Rotina para atribuir ao cônjuge e aos filhos a proteção assegurada pela lei:
gen conjuge_filhos_seg = .
keep if conjuge == 1 | filho_men21_naoemanc == 1 | paioumae_seg == 1
collapse (max) conjuge_filhos_seg = paioumae_seg, by(domicilio familia)
save bd_auxiliar, replace
use bd_pessoas_censoXXXX, clear
merge m:1 domicilio familia using bd_auxiliar
drop _merge
erase bd_auxiliar.dta
save bd_pessoas_censoXXXX, replace
* Observações:
* Se pai ou mãe é segurado especial, o cônjuge e os filhos menores
* de 21 anos também são.
* Considerou-se neste trabalho de tese apenas a situação de
* dependência presumida.
* A dependência econômica de cônjuges, companheiros e filhos é presumida.
* Nos demais casos deve ser comprovada por documentos, como declaração
* do Imposto de Renda e outros.
* Para ser considerado(a) companheiro(a) é preciso comprovar união
* estável com o(a) segurado(a).
* Fontes: BRASIL (1991), BRASIL (2015b).
************
replace segurado = 1 if paioumae_seg == 1 | outras_pes_seg == 1 | ///
conjuge_filhos_seg == 1
replace segurado = 0 if (paioumae_seg == 0 | paioumae_seg == .) & ///
(outras_pes_seg == 0 | outras_pes_seg == .) & (conjuge_filhos_seg == 0 | ///
conjuge_filhos_seg == .)
gen nenem = .
replace nenem = 1 if estudante == 0 & ocupado == 0
replace nenem = 0 if estudante == 1 | ocupado == 1
gen trab_inf = .
replace trab_inf = 1 if (idade >= 10 & idade <= 17) & ocupado == 1
replace trab_inf = 0 if (idade >= 10 & idade <= 17) & ocupado == 0
********************************************************************
********************************************************************
* CRIAÇÃO E CÁLCULO DE INDICADORES DE PESSOAS DA DIMENSÃO
* TER CONHECIMENTO
********************************************************************
* Definições:
* Componente: analfabetismo
* C1_pes: infanto-juvenil em idade escolar (6/7 <= anos <= 17) não
* matriculado na escola, exceto menor de 18 anos que já tenha
* concluído o ensino médio.
* C2_pes: adulto (>= 18 anos) analfabeto ou com baixa instrução (que
* não tenha concluído sequer o ensino fundamental ou equivalente).
* Componente: escolaridade / Qualificação Profissional
* C3_pes: adulto (>= 21 anos) sem nível médio completo
* C4_pes: trabalhador adulto (> 21 anos) com qualificação baixa
********************************************************************
* OBSERVAÇÃO:
* IDENTIFICAÇÃO DAS PESSOAS QUE APRESENTAM AS CARACTERÍSTICAS
* DOS INDICADORES DA DIMENSÃO ACESSO AO CONHECIMENTO (IDEM
* PARA AS OUTRAS DIMENSÕES):
* Ci_pes = 1 quando a pessoa se enquadra no indicador i;
* Ci_pes = 0 quando a pessoa NÃO se enquadra no indicar i;
* Ci_pes = . quando o indicador não se aplica à pessoa.
********************************************************************
* Gerando indicadores da dimensão acesso ao conhecimento:
gen C1_pes = .
gen C2_pes = .
gen C3_pes = .
gen C4_pes = .
********************************************************************
* Calculando indicadores do componente analfabetismo
replace C1_pes = 1 if crianca7_17 == 1 & (estudante == 0 & nivel_medio == 0)
replace C1_pes = 0 if crianca7_17 == 1 & (estudante == 1 | nivel_medio == 1)
replace C2_pes = 1 if adulto18 == 1 & (analfabeto == 1 | baixa_instr_18m == 1)
replace C2_pes = 0 if adulto18 == 1 & (analfabeto == 0 & baixa_instr_18m == 0)
* Observações:
* Para os dados dos anos 1991 e 2000, foram definidas como crianças
* as pessoas cuja idade era igual ou superior a 7 anos
* e inferior a 14 anos. Esse corte foi fundamentado na Lei de Diretrizes
* e Bases da Educação (Lei 9.394/1996), que estabeleceu o acesso ao ensino
* fundamental obrigatório e gratuito a partir dos 7 anos de idade.
* No entanto, em 2005 essa lei foi modificada pela Lei 11.114, alterando a
* obrigatoriedade e gratuidade do acesso ao ensino fundamental para os
* maiores de 6 anos de idade. Isso exigiu uma alteração na definição das
* crianças para o ano de 2010. (LACERDA, 2009, p. 117).
* Embora a Lei Nº 9.394/96 assegure a educação a patir dos 4 anos de idade
* (pré-escola), adotou-se como idade mínima de 7 anos para 1991 e 2000 e de
* 6 anos para 2010, idade que coincide com o início do ensino fundamental.
* A Lei anterior não tornava obrigatória a pré-escola.
********************************************************************
* Calculando indicadores do componente escolaridade / qualificação
* profissional
replace C3_pes = 1 if adulto21 == 1 & nivel_medio == 0 & nivel_superior == 0
replace C3_pes = 0 if adulto21 == 1 & nivel_medio == 1 | nivel_superior == 1
replace C4_pes = 1 if adulto21 == 1 & (trab_qual == 1 | (trab_qual >= 2 & ///
nivel_medio == 0 & nivel_superior == 0))
replace C4_pes = 0 if adulto21 == 1 & ((trab_qual >= 2 & nivel_medio == 1) ///
| nivel_superior == 1)
* Observações:
* Considerou-se trabalhador qualificado aquele que tinha pelo menos
* o nível médio completo e estava ocupado em atividades características de
* pessoas de nível médio em 1991 (ocupações com pelo menos 80% de
* trabalhadores com nível médio ou superior) ou que estava desocupada mas
* que possuía nível superior completo.
* Os dados do Censo de 2000 não possibilitam saber qual o curso
* técnico de nível médio que a pessoa concluiu.
* Os indicadores, compultados neste momento para cada membro da
* família, serão posteriormente agregados por família.
********************************************************************
********************************************************************
* CRIAÇÃO E CÁLCULO DE INDICADORES DE PESSOAS DA
* DIMENSÃO TER SAÚDE
********************************************************************
* Definições:
* Componente: saúde da família
* S1_pes: mãe jovem (< 25 anos na data do Censo) com ocorrência de17
* óbito de criança nascida viva.
* S2_pes: pessoa incapacitada física ou mentalmente (reflete negligências
* em campanhas de vacinação, falta de atendimento médico-hospitalar
* adequado, nutrição inadequada, práticas produtivas inadequadas
* (ex.: máquina desfibriladora de sisal) etc. Esses fatores podem
* contribuir para aumentar a proporção de pessoas incapacitadas
* na sociedade).
********************************************************************
* Gerando indicadores da dimensão saúde:
gen S1_pes = .
gen S2_pes = .
********************************************************************
* Calculando indicadores do componente saúde da família:
replace S1_pes = 1 if mae_com_obito == 1
replace S1_pes = 0 if mae_com_obito == 0
replace S2_pes = 1 if pessoa_com_limitacao == 1
replace S2_pes = 0 if pessoa_com_limitacao == 0
********************************************************************
********************************************************************
* CRIAÇÃO E CÁLCULO DE INDICADORES DE PESSOAS DA DIMENSÃO
* TER TRABALHO DIGNO E PREVIDÊNCIA SOCIAL
********************************************************************
********************************************************************
* Definições:
* Componente: desemprego
* T1_pes: pessoa em idade ativa ([15, 60[) não ocupada
* T2_pes: pessoa jovem [15, 29] sem trabalho e que não esteja
* estudando (nem-nem).
* Componente: trabalho infantil (trab_inf)
* T3_pes: criança com idade igual ou inferior a 14 anos trabalhando
* Componente: direito à previdência social (prevsocial).
* T4_pes: pessoa não coberta por previdência social (inclusive trabalho
* precário: sem direitos previdenciários).
* Obs.: considera-se coberta por previdência social a pessoa ocupante
* de trabalho formal, os aposentados e pensionistas, os enquadrados
* como segurados especiais, amparados na Lei Nº 8.212, de 24/07/1991
* e suas alterações feitas pela Lei Nº 11.718, de 20/06/2008) e seus
* filhos menores, cônjuges e outros, conforme previsto na lei.
********************************************************************
* Gerando indicadores da dimensão trabalho e previdência social:
gen T1_pes = .
gen T2_pes = .
gen T3_pes = .
gen T4_pes = .
********************************************************************
* Calculando indicadores do componente desemprego:
replace T1_pes = 1 if idade_ativa == 1 & ocupado == 0
replace T1_pes = 0 if idade_ativa == 1 & ocupado == 1
replace T2_pes = 1 if jovem == 1 & nenem == 1
replace T2_pes = 0 if jovem == 1 & nenem == 0
********************************************************************
* Calculando indicadores do componente trabalho infantil:
replace T3_pes = 1 if trab_inf == 1
replace T3_pes = 0 if trab_inf == 0
********************************************************************
* Calculando indicadores do componente previdência social:
replace T4_pes = 1 if segurado == 0
replace T4_pes = 0 if segurado == 1
********************************************************************
********************************************************************
* CRIAÇÃO E CÁLCULO DE INDICADORES DE PESSOAS DA DIMENSÃO
* TER PADRÃO DE VIDA DIGNO
********************************************************************
* Definições:
* Componente: saneamento básico
* P1_pes: pessoa morando em domicílio não ligado à rede de esgoto
* (ou de água pluviais) e que não possua fossa séptica e que não
* tenha banheiro privativo.
* P2_pes: pessoa morando em domicílio não ligado à rede geral de água
* ou a poço ou nascente na propriedade e que não tenha água
* canalizada em pelo menos 1 cômodo.
* P3_pes: pessoa morando em domicílio não provido por coleta de lixo regular
* Componente: energia elétrica
* P4_pes: pessoa morando em domicílio sem energia elétrica (da rede ou
* de outras fontes).
* Componente: condições de ocupação e qualidade do domicílio
* P5_pes: pessoa residindo em moradia/terreno cuja posse não é de
* nenhum membro da família, exceto quando houver financiamento
* habitacional vigente.
* P6_pes: pessoa morando em domicílio cuja densidade de moradores
* por dormitório seja superior a 2.
* Componente: disponibilidade de bens duráveis
* P7_pes: Pessoa morando em domicílio que não possua pelo menos três
* dos seguintes itens: rádio, televisor, máquina de lavar roupa,
* geladeira/freezer e telefone (fixo ou celular)
* Obs.: embora existam outros eletrodomésticos nos censos, eles não são
* comuns aos três censos analisados, razão pela qual foram escolhidos
* apenas esses.
* P8_pes: Pessoa morando em domicílio que não possui automóvel para
* uso particular
********************************************************************
* Gerando indicadores da dimensão padrão de vida digno:
gen P1_pes = .
gen P2_pes = .
gen P3_pes = .
gen P4_pes = .
gen P5_pes = .
gen P6_pes = .
gen P7_pes = .
gen P8_pes = .
********************************************************************
* Calculando indicadores do componente saneamento básico:
replace P1_pes = 1 if esg_sanit_adeq == 0 | wc_priv == 0
replace P1_pes = 0 if esg_sanit_adeq == 1 & wc_priv == 1
replace P2_pes = 1 if supr_agua_adeq == 0 | agua_canal == 0
replace P2_pes = 0 if supr_agua_adeq == 1 & agua_canal == 1
replace P3_pes = 1 if coleta_lixo == 0
replace P3_pes = 0 if coleta_lixo == 1
********************************************************************
* Calculando indicadores do componente energia elétrica
replace P4_pes = 1 if energia_elet == 0
replace P4_pes = 0 if energia_elet == 1
********************************************************************
* Calculando indicadores do componente condições de ocupação e
* qualidade do domicílio
replace P5_pes = 1 if posse_moradia == 0
replace P5_pes = 0 if posse_moradia == 1
replace P6_pes = 1 if dens_mor_dorm_adeq == 0
replace P6_pes = 0 if dens_mor_dorm_adeq == 1
********************************************************************
* Calculando indicadores do componente disponibilidade de bens duráveis
replace P7_pes = 1 if nreletrod < 3
replace P7_pes = 0 if nreletrod >= 3
replace P8_pes = 1 if autom_part == 0
replace P8_pes = 0 if autom_part == 1
********************************************************************
* Salvando arquivo de dados de pessoas da Amostra
save bd_pessoas_ censoXXXX, replace
********************************************************************
*/////////////////////////////////////////////////////////////////////////////////////
*/////////////////////////////////////////////////////////////////////////////////////
********************************************************************
* ROTINA 8
* CRIANDO VARIÁVEIS E ARQUIVO RELATIVOS ÀS FAMÍLIAS
********************************************************************
* Acessando base de dados pessoas para gerar os dados das famílias
* cd "C:\...\banco_de_dados\Censo_XXXX"
use bd_pessoas_ censoXXXX, clear
********************************************************************
* Agregando dados das pessoas por cada família
collapse (sum) C1_pes C2_pes C3_pes C4_pes S1_pes S2_pes T1_pes T2_pes ///
T3_pes T4_pes P1_pes P2_pes P3_pes P4_pes P5_pes P6_pes P7_pes P8_pes ///
populacao nrpesfam idade_ativa jovem adulto18 adulto21 adulto25 ///
fator_exp_am, by(uf mesorregiao microrregiao municipio sitdom ///
domicilio familia)
* Corrigindo fator de expansão da amostra (foi somado em função do número
* de pessoas da família)
replace fator_exp_am = fator_exp_am / nrpesfam
replace populacao = (populacao * fator_exp_am) / nrpesfam
gen nrfamilias = fator_exp_am
********************************************************************
* Atribuindo peso a todos os indicadores e criando variáveis auxiliares
gen qde_dimensoes = 4
gen qde_indic = 18
gen peso_dimensao = qde_indic/qde_dimensoes
gen pesoC1 = 1.1250
gen pesoC2 = 1.1250
gen pesoC3 = 1.1250
gen pesoC4 = 1.1250
gen pesoS1 = 2.2500
gen pesoS2 = 2.2500
gen pesoT1 = 0.7500
gen pesoT2 = 0.7500
gen pesoT3 = 1.5000
gen pesoT4 = 1.5000
gen pesoP1 = 0.3750
gen pesoP2 = 0.3750
gen pesoP3 = 0.3750
gen pesoP4 = 1.1250
gen pesoP5 = 0.5625
gen pesoP6 = 0.5625
gen pesoP7 = 0.5625
gen pesoP8 = 0.5625
********************************************************************
********************************************************************
* CRIAÇÃO E CÁLCULO DE INDICADORES DE FAMÍLIAS DA DIMENSÃO TER
* CONHECIMENTO
********************************************************************
* Definições:
* Componente: Analfabetismo
* C1: presença de infanto-juvenil na família em idade escolar
*(6/7 <= anos <= 17) não matriculado na escola, exceto menor de 18
* anos que já tenha concluído o ensino médio.
* C2: todos adultos (>= 18 anos) da família são analfabetos ou
* possuem baixo nível de instrução, não tendo concluído sequer o
* ensino fundamental).
* Componente: Escolaridade / Qualificação Profissional
* C3: ausência de adulto (>= 21 anos) na família com nível
* médio completo
* C4: ausência na família de trabalhador adulto (> 21 anos)
* com qualificação média ou alta.
********************************************************************
* Gerando e atribuindo pesos aos indicadores das famílias
* da Amostra na dimensão TER CONHECIMENTO
gen C1 = 0
gen C2 = 0
gen C3 = 0
gen C4 = 0
replace C1 = pesoC1 if C1_pes > 0
replace C2 = pesoC2 if C2_pes == adulto18
replace C3 = pesoC3 if C3_pes == adulto21
replace C4 = pesoC4 if C4_pes == adulto21
********************************************************************
********************************************************************
* CRIAÇÃO E CÁLCULO DE INDICADORES DE FAMÍLIAS DA
* DIMENSÃO TER SAÚDE
********************************************************************
* Definições:
* Componente: Saúde da família
* S1: ocorrência de pelo menos um óbito de criança nascida
* viva de mulheres jovens (idade entre 15 e 25 anos na data do Censo)
* da família.
* S2: presença na família de pessoa incapacitada física
* ou mentalmente.
********************************************************************
* Gerando e atribuindo pesos aos indicadores das famílias da Amostra
* na dimensão TER SAÚDE
gen S1 = 0
gen S2 = 0
replace S1 = pesoS1 if S1_pes > 0
replace S2 = pesoS2 if S2_pes > 0
********************************************************************
********************************************************************
* CRIAÇÃO E CÁLCULO DE INDICADORES DE FAMÍLIAS DA DIMENSÃO TER
* TRABALHO DIGNO E SEGURANÇA PREVIDENCIÁRIA
********************************************************************
* Definições:
* Componente: desemprego (desemprego)
* T1: nenhum membro da família em idade ativa ([15, 60[) se
* encontra ocupado
* T2: presença na família de jovem [15, 29] sem trabalho e que
* não esteja estudando (Nem-Nem)
* Componente: trabalho infantil (trab_inf)
* T3: presença na família de trabalho infantil (presença de
* criança com idade igual ou inferior a 14 anos trabalhando)
* Componente: direito à previdência social (prevsocial)
* T4: presença de pessoa na família não coberta por previdência social
* (inclusive trabalho precário: sem direitos previdenciários)
* Obs.: considera-se coberta por previdência social a pessoa ocupante
* de trabalho formal, os aposentados e pensionistas,
* os enquadrados como segurados especiais, amparados na Lei Nº 8.212,
* de 24/07/1991 e suas alterações
* feitas pela Lei Nº 11.718, de 20/06/2008) e seus filhos menores,
* cônjuges e outros, conforme previsto na lei.
********************************************************************
* Gerando e atribuindo pesos aos indicadores das famílias da
* Amostra na dimensão TER TRABALHO DIGNO E PREVIDÊNCIA SOCIAL
gen T1 = 0
gen T2 = 0
gen T3 = 0
gen T4 = 0
replace T1 = pesoT1 if T1_pes == idade_ativa
replace T2 = pesoT2 if T2_pes > 0
replace T3 = pesoT3 if T3_pes > 0
replace T4 = pesoT4 if T4_pes > 0
********************************************************************
********************************************************************
* CRIAÇÃO E CÁLCULO DE INDICADORES DE FAMÍLIAS DA DIMENSÃO TER
* PADRÃO DE VIDA DIGNO
********************************************************************
* Definições:
* Componente: saneamento básico
* P1: família vivendo em domicílio não ligado à rede de esgoto
*(ou de água pluviais) e não possui fossa séptica ou que não tenha
* banheiro privativo.
* P2: família vivendo em domicílio não ligado à rede geral de
* água ou a poço ou nascente ou que não tenha água canalizada em
* pelo menos 1 cômodo.
* P3: família vivendo em domicílio não provido por coleta de
* lixo regular.
* Componente: energia elétrica (energelet)
* P4: família vivendo em domicílio não ligado à rede de
* energia elétrica.
* Componente: condições de ocupação e qualidade do domicílio
* (condocup_qualdom)
* P5: família sem a posse da moradia/terreno, exceto quando
* houver financiamento habitacional vigente.
* P6: família vivendo em domicílio com densidade de moradores
* por dormitório superior a 2.
* Componente: disponibilidade de bens duráveis (bensdur)
* P7: família vivendo em domicílio que não possui pelo menos três
* dos seguintes itens: rádio, televisor, máquina de lavar roupa,
* geladeira/freezer e telefone (fixo ou celular).
* Obs.: embora existam outros eletrodomésticos nos censos, eles não
* são comuns aos três anos censitários analisados, razão pela qual
* foram escolhidos apenas esses.
* P8: família vivendo em domicílio que não tem automóvel para
* uso particular
********************************************************************
* Gerando e atribuindo pesos aos indicadores das famílias da
* Amostra na dimensão TER PADRÃO DE VIDA DIGNO
gen P1 = 0
gen P2 = 0
gen P3 = 0
gen P4 = 0
gen P5 = 0
gen P6 = 0
gen P7 = 0
gen P8 = 0
replace P1 = pesoP1 if P1_pes > 0
replace P2 = pesoP2 if P2_pes > 0
replace P3 = pesoP3 if P3_pes > 0
replace P4 = pesoP4 if P4_pes > 0
replace P5 = pesoP5 if P5_pes > 0
replace P6 = pesoP6 if P6_pes > 0
replace P7 = pesoP7 if P7_pes > 0
replace P8 = pesoP8 if P8_pes > 0
********************************************************************
********************************************************************
* CÁLCULO DAS PRIVAÇÕES DAS FAMÍLIAS NOS COMPONENTES
* E NAS DIMENSÕES (AMOSTRA)
********************************************************************
* Dimensão TER CONHECIMENTO
gen privfam_analf = .
gen privfam_esc_qualprof = .
gen privfam_acesconh = .
replace privfam_analf = C1 + C2
replace privfam_esc_qualprof = C3 + C4
replace privfam_acesconh = privfam_analf + privfam_esc_qualprof
********************************************************************
* Dimensão TER SAÚDE
gen privfam_saudefam = .
gen privfam_saude = .
replace privfam_saudefam = S1 + S2
replace privfam_saude = privfam_saudefam
********************************************************************
* Dimensão TER TRABALHO DIGNO E PREVIDÊNCIA SOCIAL
gen privfam_emprego = T1 + T2
gen privfam_trabinf = T3
gen privfam_segsocial = T4
gen privfam_trabsegsocial = .
replace privfam_trabsegsocial = privfam_emprego + privfam_trabinf + ///
privfam_segsocial
********************************************************************
* Dimensão TER PADRÃO DE VIDA DIGNO
gen privfam_sanbas = .
gen privfam_energelet = .
gen privfam_condocup_qualdom = .
gen privfam_bens_dur = .
gen privfam_padraovida = .
replace privfam_sanbas = P1 + P2 + P3
replace privfam_energelet = P4
replace privfam_condocup_qualdom = P5 + P6
replace privfam_bens_dur = P7 + P8
replace privfam_padraovida = privfam_sanbas + privfam_energelet + ///
privfam_condocup_qualdom + privfam_bens_dur
********************************************************************
* Calculando a privação ponderada de cada família da AMOSTRA
* (totprivfam corresponde à variável c = soma de cada privação
* multiplicada pelo seu peso, na metodologia do IPM do PNUD
gen totprivfam = privfam_acesconh + privfam_saude + privfam_trabsegsocial ///
+ privfam_padraovida
********************************************************************
* Classificando as famílias da AMOSTRA em pobres, não pobres e vulneráveis
* OBS.: família multidimensionalmente pobre é aquela cuja soma dos
* indicadores é superior ao valor de 1/3 da quantidade de indicadores.
* Família multidimensionalmente vulnerável é aquela cuja soma dos indicadores é
* superior a 1/5 e inferior ou igual a 1/3 da quantidade de indicadores
gen fampobre = .
gen nfampobre = .
replace fampobre = fator_exp_am if totprivfam > (qde_indic)/3
replace fampobre = 0 if totprivfam <= (qde_indic)/3
replace nfampobre = fator_exp_am if totprivfam <= (qde_indic)/3
replace nfampobre = 0 if totprivfam > (qde_indic)/3
gen famvuln = fator_exp_am if totprivfam > (qde_indic)/5 & totprivfam <= (qde_indic)/3
gen totalfam = fampobre + nfampobre
********************************************************************
* Calculando o número de pessoas de cada família do UNIVERSO enquadrada
* como pobre, não pobre e vulnerável (corresponde à variável q na
* metodologia do PNUD).
* OBS.: se a família é pobre, todos os seus membros também são pobres.
gen pespobre = fampobre * nrpesfam
* pespobre corresponde à variável q = número de pessoas pobres,
* na metodologia do PNUD).
gen npespobre = nfampobre * nrpesfam
gen pesvuln = famvuln * nrpesfam
gen totalpes = pespobre + npespobre
* totalpes corresponde à variável n = população total,
* na metodologia do PNUD).
********************************************************************
* Gerando variáveis por família para calcular a intensidade
* (amplitude) da pobreza (corresponde a A, na metodologia do IPM do PNUD).
* Obs.: este indicador por família será agregado por município para
* calcular a intensidade da pobreza:
* A = soma(privpondpesfam) / [soma(nrpesfam) * nr. indicadores]
gen privpondpesfam = 0
replace privpondpesfam = totprivfam * nrpesfam * fator_exp_am if fampobre > 0
********************************************************************
* Salvando as novas variáveis no banco de dados das famílias
save bd_familias_ censoXXXX, replace
********************************************************************
*/////////////////////////////////////////////////////////////////////////////////////
* ROTINA 9
* AGREGAÇÃO DE DADOS DAS FAMÍLIAS POR REGIÕES DE
* INTERESSE - UNIVERSO
*/////////////////////////////////////////////////////////////////////////////////////
********************************************************************
********************************************************************
* Cálculo dos indicadores de pobreza dos municípios
********************************************************************
* Acessando base de dados das famílias
* cd "C:\...\banco_de_dados\censoXXXX"
use bd_familias_ censoXXXX, clear
* Agregando dados de privações e pobreza das pessoas e famílias
collapse (sum) privpondpesfam pespobre npespobre pesvuln ///
totalpes famvuln fampobre nfampobre totalfam, by(municipio)
*****
gen qde_indic = 18
* Cálculo da proporção de pessoas multidimensionalmente pobres da população
*(corresponde ao valor de H na metodologia do IPM do PNUD):
* Obs: H = q/n; onde q = número de pessoas pobres multidimensionalmente
* e n = população total
gen prop_pobres = pespobre/totalpes
* Cálculo da intensidade (amplitude) da pobreza (representado por
* A na metodologia do IPM do PNUD)
gen intens_pobreza = privpondpesfam/(pespobre * qde_indic)
* Cálculo da Índice de Pobreza Multidimensional (IPM) (é igual
* ao produto de H.A, na metodologia do IPM do PNUD).
gen ipm = prop_pobres * intens_pobreza
drop qde_indic privpondpesfam
*****
* Salvando informações no banco de dados
save bd_indic_munic_censoXXXX, replace
********************************************************************
* Cálculo dos indicadores de pobreza dos municípios por situação de domicílio
********************************************************************
* Acessando base de dados das famílias
* cd "C:\...\banco_de_dados\censoXXXX"
use bd_familias_ censoXXXX, clear
* Agregando dados de privações e pobreza das pessoas e famílias
collapse (sum) privpondpesfam pespobre npespobre pesvuln ///
totalpes famvuln fampobre nfampobre totalfam, by(municipio sitdom)
*****
gen qde_indic = 18
* Cálculo da proporção de pessoas multidimensionalmente pobres da população
*(corresponde ao valor de H na metodologia do IPM do PNUD):
* Obs: H = q/n; onde q = número de pessoas pobres multidimensionalmente
* e n = população total
gen prop_pobres = pespobre/totalpes
* Cálculo da intensidade (amplitude) da pobreza (representado por
* A na metodologia do IPM do PNUD)
gen intens_pobreza = privpondpesfam/(pespobre * qde_indic)
* Cálculo da Índice de Pobreza Multidimensional (IPM) (é igual
* ao produto de H.A, na metodologia do IPM do PNUD).
gen ipm = prop_pobres * intens_pobreza
drop qde_indic privpondpesfam
*****
* Salvando informações no banco de dados
save bd_indic_munic_sitdom_ censoXXXX, replace
********************************************************************
* * Cálculo dos indicadores de pobreza do Estado do Ceará
********************************************************************
* Acessando base de dados das famílias
* cd "C:\...\banco_de_dados\censoXXXX"
use bd_familias_ censoXXXX, clear
* Agregando dados de privações e pobreza das pessoas e famílias
collapse (sum) privpondpesfam pespobre npespobre pesvuln ///
totalpes famvuln fampobre nfampobre totalfam, by(uf)
*****
gen qde_indic = 18
* Cálculo da proporção de pessoas multidimensionalmente pobres da população
*(corresponde ao valor de H na metodologia do IPM do PNUD):
* Obs: H = q/n; onde q = número de pessoas pobres multidimensionalmente
* e n = população total
gen prop_pobres = pespobre/totalpes
* Cálculo da intensidade (amplitude) da pobreza (representado por
* A na metodologia do IPM do PNUD)
gen intens_pobreza = privpondpesfam/(pespobre * qde_indic)
* Cálculo da Índice de Pobreza Multidimensional (IPM) (é igual
* ao produto de H.A, na metodologia do IPM do PNUD).
gen ipm = prop_pobres * intens_pobreza
drop qde_indic privpondpesfam
*****
* Salvando informações no banco de dados
save bd_indic_uf_ censoXXXX, replace
********************************************************************
* * Cálculo dos indicadores de pobreza do Estado por situação de domicílio
********************************************************************
* Acessando base de dados das famílias18
* cd "C:\...\banco_de_dados\censoXXXX"
use bd_familias_censoXXXX, clear
* Agregando dados de privações e pobreza das pessoas e famílias
collapse (sum) privpondpesfam pespobre npespobre pesvuln ///
totalpes famvuln fampobre nfampobre totalfam, by(uf sitdom)
*****
gen qde_indic = 18
* Cálculo da proporção de pessoas multidimensionalmente pobres da população
*(corresponde ao valor de H na metodologia do IPM do PNUD):
* Obs: H = q/n; onde q = número de pessoas pobres multidimensionalmente
* e n = população total
gen prop_pobres = pespobre/totalpes
* Cálculo da intensidade (amplitude) da pobreza (representado por
* A na metodologia do IPM do PNUD)
gen intens_pobreza = privpondpesfam/(pespobre * qde_indic)
* Cálculo da Índice de Pobreza Multidimensional (IPM) (é igual
* ao produto de H.A, na metodologia do IPM do PNUD).
gen ipm = prop_pobres * intens_pobreza
drop qde_indic privpondpesfam
*****
* Salvando informações no banco de dados
save bd_indic_uf_sitdom_censoXXXX, replace
