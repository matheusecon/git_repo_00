*Trabalho desenvolvido por Alex Eugênio Altrão de Morais em 10/07/2019

*Os comandos para testes de raiz unitária, cointegração de painel e estimação de longo prazo.

** BASE DE DADOS
use "C:\Users\alex_\Dropbox\Dissertação\ARTIGO\Modelo novo\MODELO COM A SOMA DA CONSTANTE APENAS NAS VARIÁVEIS QUE O LOG VIRA MISSING\BASE DE DADOS.dta", replace


** PARA INÍCIO ABRE-SE A BASE DE DADOS MONTADA NO EXCEL, COM AS SEGUINTES VARIÁVEIS:
*1 - Estados - Nomes das Ufs Brasileiras
*2 - uf - Siglas das Ufs Brasileiras
*3 - id - Número de identificação
*4 - ano - Ano
*5 - emissoes - Emissões de CO2 por Estado
*6 - pib - PIB por Estado
*7 - exp	- Exportação por Estado
*8 - imp	- Importação por Estado
*9 - estpop	- Estimativa populacional IPEADATA
*10 - eletri	- Consumo Residencial de Eletricidade
*11 - petro	- Consumo Residencial de Gás Liquefeito de Petroleo
*12 - pop	- População Total estimada pela PNAD (mil pessoas)
*13 - urb	- População Urbana estimada pela PNAD (mil pessoas)
*14 - rur	- População Rural estimada pela PNAD (mil pessoas)
*15 - popuni	- População Total estimada pela PNAD (pessoas)
*16 - urbuni	- População Urbana estimada pela PNAD (pessoas)
*17 - ruruni	- População Rural estimada pela PNAD (pessoas)
*18 - vabit	- Valor Adicionado Bruto da Industria de Transformação
*19 - vabie	- Valor Adicionado Bruto da Industria de Extração 
*20 – total - Total das Atividades
*21 – aeb - Valor Adicionado Bruto da Agricultura e Produção florestal
*22 – c - Valor Adicionado Bruto da Indústrias extrativas
*23 – d - Valor Adicionado Bruto da Indústrias de transformação
*24 – e - Valor Adicionado Bruto da Eletricidade e gás, água, esgoto, atividades de gestão de resíduos e descontaminação
*25 – f - Valor Adicionado Bruto da Construção
*26 – g - Valor Adicionado Bruto da Comércio e reparação de veículos automotores e motocicletas
*27 – h - Valor Adicionado Bruto da Alojamento e alimentação
*28 – i - Valor Adicionado Bruto da Transporte, Informação e comunicação
*29 – j - Valor Adicionado Bruto das Atividades financeiras, de seguros e serviços relacionados
*30 - k - Valor Adicionado Bruto das Atividades imobiliárias
*31 – l - Valor Adicionado Bruto da Administração Pública
*32 – men - Valor Adicionado Bruto da Educação e saúde privadas
*33 – o - Valor Adicionado Bruto das Atividades científicas e técnicas e da cultura e esporte
*34 – p - Valor Adicionado Bruto da Serviços domésticos
*35 – totaldef - Total das Atividades Deflacionado
*36 – aebdef - Valor Adicionado Bruto da Agricultura e Produção florestal deflacionado
*37 – cdef - Valor Adicionado Bruto da Indústrias extrativas deflacionado
*38 – ddef - Valor Adicionado Bruto da Indústrias de transformação Deflacionado
*39 – edef - Valor Adicionado Bruto da Eletricidade e gás, água, esgoto, atividades de gestão de resíduos e descontaminação Deflacionado
*40 – fdef - Valor Adicionado Bruto da Construção Deflacionado
*41 – gdef - Valor Adicionado Bruto da Comércio e reparação de veículos automotores e motocicletas Deflacionado
*42 – hdef - Valor Adicionado Bruto da Alojamento e alimentação Deflacionado
*43 – idef - Valor Adicionado Bruto da Transporte, Informação e comunicação Deflacionado
*44 – jdef - Valor Adicionado Bruto das Atividades financeiras, de seguros e serviços relacionados deflacionado
*45 – kdef - Valor Adicionado Bruto das Atividades imobiliárias deflacionado
*46 – ldef - Valor Adicionado Bruto da Administração Pública Deflacionado
*47 – mendef - Valor Adicionado Bruto da Educação e saúde privados deflacionado
*48 – odef - Valor Adicionado Bruto das Atividades científicas e técnicas e da cultura e esporte Deflacionado
*49 – pdef - Valor Adicionado Bruto da Serviços domésticos deflacionado


** NOMEANDO AS VARIÁVEIS 
label variable estados "Nomes das Ufs Brasileiras"
label variable siglas "Siglas das Ufs Brasileiras"
label variable id "Número de identificação"
label variable ano "Ano"
label variable emissoes "Emissões de CO2 por Estado"
label variable pib "PIB por Estado"
label variable exp "Exportação por Estado"
label variable imp "Importação por Estado"
label variable eletri "Consumo Residencial de Eletricidade"
label variable petro "Consumo Residencial de Gás Liquefeito de Petroleo"
label variable pop "População Total estimada pela PNAD (mil pessoas)"
label variable urb "População Urbana estimada pela PNAD (mil pessoas)"
label variable rur "População Rural estimada pela PNAD (mil pessoas)"
label variable popuni "População Total estimada pela PNAD (pessoas)"
label variable urbuni "População Urbana estimada pela PNAD (pessoas)"
label variable ruruni "População Rural estimada pela PNAD (pessoas)"
label variable purbuni "Participação da População Urbana"
label variable pruruni "Participação da População Rural"
label variable vabit "Valor Adicionado Bruto da Industria de Transformação"
label variable vabie "Valor Adicionado Bruto da Industria de Extração"
label variable total "Total das Atividades"
label variable aeb "Valor Adicionado Bruto da Agricultura e Produção florestal"
label variable c "Valor Adicionado Bruto da Indústrias extrativas"
label variable d "Valor Adicionado Bruto da Indústrias de transformação"
label variable e "Valor Adicionado Bruto da Eletricidade e gás, água, esgoto, atividades de gestão de resíduos e descontaminação"
label variable f "Valor Adicionado Bruto da Construção"
label variable g "Valor Adicionado Bruto da Comércio e reparação de veículos automotores e motocicletas"
label variable h "Valor Adicionado Bruto da Alojamento e alimentação"
label variable i "Valor Adicionado Bruto da Transporte, Informação e comunicação"
label variable j "Valor Adicionado Bruto das Atividades financeiras, de seguros e serviços relacionados"
label variable k "Valor Adicionado Bruto das Atividades imobiliárias"
label variable l "Valor Adicionado Bruto da Administração Pública"
label variable men "Valor Adicionado Bruto da Educação e saúde privadas"
label variable o "Valor Adicionado Bruto das Atividades científicas e técnicas e da cultura e esporte"
label variable p "Valor Adicionado Bruto da Serviços domésticos"
label variable totaldef "Total das Atividades Deflacionado"
label variable aebdef "Valor Adicionado Bruto da Agricultura e Produção florestal deflacionado"
label variable cdef "Valor Adicionado Bruto da Indústrias extrativas deflacionado"
label variable ddef "Valor Adicionado Bruto da Indústrias de transformação Deflacionado"
label variable edef "Valor Adicionado Bruto da Eletricidade e gás, água, esgoto, atividades de gestão de resíduos e descontaminação Deflacionado"
label variable fdef "Valor Adicionado Bruto da Construção Deflacionado"
label variable gdef "Valor Adicionado Bruto da Comércio e reparação de veículos automotores e motocicletas Deflacionado"
label variable hdef "Valor Adicionado Bruto da Alojamento e alimentação Deflacionado"
label variable idef "Valor Adicionado Bruto da Transporte, Informação e comunicação Deflacionado"
label variable jdef "Valor Adicionado Bruto das Atividades financeiras, de seguros e serviços relacionados deflacionado"
label variable kdef "Valor Adicionado Bruto das Atividades imobiliárias deflacionado"
label variable ldef "Valor Adicionado Bruto da Administração Pública Deflacionado"
label variable mendef "Valor Adicionado Bruto da Educação e saúde privados deflacionado"
label variable odef "Valor Adicionado Bruto das Atividades científicas e técnicas e da cultura e esporte Deflacionado"
label variable pdef "Valor Adicionado Bruto da Serviços domésticos deflacionado"

** INDICANDO UM PAINEL DE DADOS
xtset id ano, yearly

** CRIANDO AS VARIÁVEIS PER CAPITA
// Emissão de CO2
gen epc = emissoes/popuni
label variable epc "Emissões de CO2 per capita"

//Variáveis Econômicas (PIB)
gen pibpc = pib/popuni
label variable pibpc "PIB Estadual per capita"
gen pibpc2 = pibpc^2
label variable pibpc2 "PIB Estadual per capita ao quadrado"
gen pibpc3 = pibpc^3
label variable pibpc3 "PIB Estadual per capita ao cubo"

// Variáveis de Tecnologia (Controles)
* Valor adicionado Bruto da Industria de Transformação
gen vabitpc = vabit/popuni
label variable vabitpc "VAB per capita Transformação"

* Valor adicionado Bruto da Industria de Transformação e Extração
gen vabiepc = vabie/popuni
label variable vabiepc "VAB per capita de Extração"
gen vabpc1 = vabitpc+vabiepc
label variable vabpc1 "VAB per capita de Transformação e Extração"

* Comercio Internacional (Exportação+Importação)
gen comint = exp+imp
label variable comint "Comercio Internacional"
gen comintpc = comint/popuni
label variable comintpc "Comercio Internacional per capita"

* Consumo Residencial de Energia Elétrica
gen eletripc = eletri/popuni
label variable eletripc "Consumo Elétrico per capita"

* Consumo Residencial de Gá Liquefeito de Petróleo
gen petropc = petro/popuni
label variable petropc "Consumo de Gás Liquefeito de Petróleo per capita"



** CRIANDO AS VARIÁVEIS PARA O MODELO STIRPAT
// Variável de Impacto - Emissão de CO2
gen lnepc = ln(epc)
label variable lnepc "Logarítimo das Emissões de CO2 per capita"


//Variáveis de Afluência - Variáveis Econômicas (PIB, PIB² e PIB³)
gen lnpibpc = ln(pibpc)
gen lnpibpc2 = (ln(pibpc))^2
gen lnpibpc3 = (ln(pibpc))^3
label variable lnpibpc "Logarítimo do PIB per capita Estadual"
label variable lnpibpc2 "Logarítimo do PIB per capita Estadual ao Quadrado"
label variable lnpibpc3 "Logarítimo do PIB per capita Estadual ao Cubo"

// Variáveis de População
* População Total
gen lnpopuni = ln(popuni)
label variable lnpopuni "Logarítimo da população total"

*População Urbana
gen lnurbuni = ln(urbuni)
label variable lnurbuni "Logarítimo da população urbana"

* População Rural
gen lnruruni = ln(ruruni+1)
label variable lnruruni "Logarítimo da população rural"

// Variáveis de Tecnologia (Controles)
* Valor adicionado Bruto da Industria de Transformação
gen lnvabitpc = ln(vabitpc+1)
label variable lnvabitpc "Logarítimo do VAB per capita Transformação"
* Valor adicionado Bruto da Industria de Transformação e Extração
gen lnvabpc1 = ln(vabpc1+1)
label variable lnvabpc1 "Logarítimo do VAB per capita de Transformação e Extração"


* Comércio Internacional (Exportação + Importação)
gen lncomintpc = ln(comintpc+1)
label variable lncomintpc "Logarítimo da Comercio Internacional per capita"


* Consumo Residencial de Energia Elétrica
gen lneletripc = ln(eletripc)
label variable lneletripc "Logarítimo do Consumo Elétrico per capita"

* Consumo Residencial de Gá Liquefeito de Petróleo
gen lnpetropc = ln(petropc+1)
label variable lnpetropc "Logarítimo do Consumo de Gás Liquefeito de Petróleo per capita"




** CRIANDO VARIÁVEIS DEFASADAS E PRIMEIRA DIFERENÇA
// DEFASADA (L. lag xt−1)
// Impacto
gen lnepcl = l.lnepc
label variable lnepcl "Logarítimo das Emissões de CO2 per capita defasado no t-1"

//Afluência
gen lnpibpcl = l.lnpibpc
gen lnpibpc2l = l.lnpibpc2
gen lnpibpc3l = l.lnpibpc3
label variable lnpibpcl "Logarítimo do PIB per capita Estadual defasado no t-1"
label variable lnpibpc2l "Logarítimo do PIB per capita Estadual ao Quadrado defasado no t-1"
label variable lnpibpc3l "Logarítimo do PIB per capita Estadual ao Cubo defasado no t-1"

// Tecnologia
gen lnvabitpcl = l.lnvabitpc
label variable lnvabitpcl "Logarítimo do VAB per capita Transformação defasado no t-1"
gen lncomintpcl = l.lncomintpc
label variable lncomintpcl "Logarítimo da Balança Comercial per capita defasado no t-1"
gen lneletripcl = l.lneletripc
label variable lneletripcl "Logarítimo do Consumo Elétrico per capita defasado no t-1"

// População
* População Total
gen lnpopunil = l.lnpopuni
label variable lnpopunil "Logarítimo da população total defasado no t-1"
gen lnurbunil = l.lnurbuni
label variable lnurbunil "Logarítimo da população urbana defasado no t-1"

// PRIMEIRA DIFERENÇA (DELTA) - (D. difference xt − xt−1)
// Impacto
gen lnepcd = d.lnepc
label variable lnepcd "Logarítimo das Emissões de CO2 per capita primemira diferença"

//Afluência
gen lnpibpcd = d.lnpibpc
gen lnpibpc2d = d.lnpibpc2
gen lnpibpc3d = d.lnpibpc3
label variable lnpibpcd "Logarítimo do PIB per capita Estadual primemira diferença"
label variable lnpibpc2d "Logarítimo do PIB per capita Estadual ao Quadrado primemira diferença"
label variable lnpibpc3d "Logarítimo do PIB per capita Estadual ao Cubo primemira diferença"

// Tecnologia
gen lnvabitpcd = d.lnvabitpc
label variable lnvabitpcd "Logarítimo do VAB per capita Transformação primemira diferença"
gen lncomintpcd = d.lncomintpc
label variable lncomintpcd "Logarítimo da Balança Comercial per capita primemira diferença"
gen lneletripcd = d.lneletripc
label variable lneletripcd "Logarítimo do Consumo Elétrico per capita primemira diferença"

// População
* População Total
gen lnpopunid = d.lnpopuni
label variable lnpopunid "Logarítimo da população total primemira diferença"
gen lnurbunid = d.lnurbuni
label variable lnurbunid "Logarítimo da população urbana primemira diferença"

** CRIANDO AS VARIÁVEIS DOS VALORES ADICIONADOS BRUTOS SUGERIDOS APÓS A BANCA
//Variáveis per capitas
gen totaldefpc = totaldef/popuni
gen aebdefpc = aebdef/popuni
gen cdefpc = cdef/popuni
gen ddefpc = ddef/popuni
gen edefpc = edef/popuni
gen fdefpc = fdef/popuni
gen gdefpc = gdef/popuni
gen hdefpc = hdef/popuni
gen idefpc = idef/popuni
gen jdefpc = jdef/popuni
gen kdefpc = kdef/popuni
gen ldefpc = ldef/popuni
gen mendefpc = mendef/popuni
gen odefpc = odef/popuni
gen pdefpc = pdef/popuni
label variable totaldefpc "VAB Total das Atividades Deflacionado per capita"
label variable aebdefpc "VAB da Agricultura e Produção florestal deflacionado per capita"
label variable cdefpc "VAB da Indústrias extrativas deflacionado per capita"
label variable ddefpc "VAB da Indústrias de transformação Deflacionado per capita"
label variable edefpc "VAB da Eletricidade e gás, água, esgoto, atividades de gestão de resíduos e descontaminação Deflacionado per capita"
label variable fdefpc "VAB da Construção Deflacionado per capita"
label variable gdefpc "VAB da Comércio e reparação de veículos automotores e motocicletas Deflacionado per capita"
label variable hdefpc "VAB da Alojamento e alimentação Deflacionado per capita"
label variable idefpc "VAB da Transporte, Informação e comunicação Deflacionado per capita"
label variable jdefpc "VAB das Atividades financeiras, de seguros e serviços relacionados deflacionado per capita"
label variable kdefpc "VAB das Atividades imobiliárias deflacionado per capita"
label variable ldefpc "VAB da Administração Pública Deflacionado per capita"
label variable mendefpc "VAB da Educação e saúde privados deflacionado per capita"
label variable odefpc "VAB das Atividades científicas e técnicas e da cultura e esporte Deflacionado per capita"
label variable pdefpc "VAB da Serviços domésticos deflacionado per capita"

//Variáveis Logaritimas
gen lntotaldefpc = ln(totaldefpc) 
gen lnaebdefpc = ln(aebdefpc) 
gen lncdefpc = ln(cdefpc+1)
gen lnddefpc = ln(ddefpc)
gen lnedefpc = ln(edefpc)
gen lnfdefpc = ln(fdefpc)
gen lngdefpc = ln(gdefpc)
gen lnhdefpc = ln(hdefpc)
gen lnidefpc = ln(idefpc)
gen lnjdefpc = ln(jdefpc)
gen lnkdefpc = ln(kdefpc)
gen lnldefpc = ln(ldefpc) 
gen lnmendefpc = ln(mendefpc)
gen lnodefpc = ln(odefpc)
gen lnpdefpc = ln(pdefpc)
label variable lntotaldefpc "Log do VAB Total das Atividades Deflacionado per capita"
label variable lnaebdefpc "Log do VAB da Agricultura e Produção florestal deflacionado per capita"
label variable lncdefpc "Log do VAB da Indústrias extrativas deflacionado per capita"
label variable lnddefpc "Log do VAB da Indústrias de transformação Deflacionado per capita"
label variable lnedefpc "Log do VAB da Eletricidade e gás, água, esgoto, atividades de gestão de resíduos e descontaminação Deflacionado per capita"
label variable lnfdefpc "Log do VAB Bruto da Construção Deflacionado per capita"
label variable lngdefpc "Log do VAB Bruto da Comércio e reparação de veículos automotores e motocicletas Deflacionado per capita"
label variable lnhdefpc "Log do VAB Bruto da Alojamento e alimentação Deflacionado per capita"
label variable lnidefpc "Log do VAB Bruto da Transporte, Informação e comunicação Deflacionado per capita"
label variable lnjdefpc "Log do VAB Bruto das Atividades financeiras, de seguros e serviços relacionados deflacionado per capita"
label variable lnkdefpc "Log do VAB Bruto das Atividades imobiliárias deflacionado per capita"
label variable lnldefpc "Log do VAB Bruto da Administração Pública Deflacionado per capita"
label variable lnmendefpc "Log do VAB Bruto da Educação e saúde privados deflacionado per capita"
label variable lnodefpc "Log do VAB Bruto das Atividades científicas e técnicas e da cultura e esporte Deflacionado per capita"
label variable lnpdefpc "Log do VAB Bruto da Serviços domésticos deflacionado per capita"

//Variáveis Logaritimas Defasadas
gen lntotaldefpcl = l.lntotaldefpc
gen lnaebdefpcl = l.lnaebdefpc
gen lncdefpcl = l.lncdefpc
gen lnddefpcl = l.lnddefpc
gen lnedefpcl = l.lnedefpc
gen lnfdefpcl = l.lnfdefpc
gen lngdefpcl = l.lngdefpc
gen lnhdefpcl = l.lnhdefpc
gen lnidefpcl = l.lnidefpc
gen lnjdefpcl = l.lnjdefpc
gen lnkdefpcl = l.lnkdefpc
gen lnldefpcl = l.lnldefpc
gen lnmendefpcl = l.lnmendefpc
gen lnodefpcl = l.lnodefpc
gen lnpdefpcl = l.lnpdefpc
label variable lntotaldefpc "Log do VAB Total das Atividades Deflacionado per capita defasado no t-1"
label variable lnaebdefpc "Log do VAB da Agricultura e Produção florestal deflacionado per capita defasado no t-1"
label variable lncdefpc "Log do VAB da Indústrias extrativas deflacionado per capita defasado no t-1"
label variable lnddefpc "Log do VAB da Indústrias de transformação Deflacionado per capita defasado no t-1"
label variable lnedefpc "Log do VAB da Eletricidade e gás, água, esgoto, atividades de gestão de resíduos e descontaminação Deflacionado per capita defasado no t-1"
label variable lnfdefpc "Log do VAB da Construção Deflacionado per capita defasado no t-1"
label variable lngdefpc "Log do VAB do Comércio e reparação de veículos automotores e motocicletas Deflacionado per capita defasado no t-1"
label variable lnhdefpc "Log do VAB da Alojamento e alimentação Deflacionado per capita defasado no t-1"
label variable lnidefpc "Log do VAB da Transporte, Informação e comunicação Deflacionado per capita defasado no t-1"
label variable lnjdefpc "Log do VAB das Atividades financeiras, de seguros e serviços relacionados deflacionado per capita defasado no t-1"
label variable lnkdefpc "Log do VAB das Atividades imobiliárias deflacionado per capita defasado no t-1"
label variable lnldefpc "Log do VAB da Administração Pública Deflacionado per capita defasado no t-1"
label variable lnmendefpc "Log do VAB da Educação e saúde privados deflacionado per capita defasado no t-1"
label variable lnodefpc "Log do VAB das Atividades científicas e técnicas e da cultura e esporte Deflacionado per capita defasado no t-1"
label variable lnpdefpc "Log do VAB da Serviços domésticos deflacionado per capita defasado no t-1"

//Variáveis Logaritimas de Primeira Diferença
gen lntotaldefpcd = d.lntotaldefpc
gen lnaebdefpcd = d.lnaebdefpc
gen lncdefpcd = d.lncdefpc
gen lnddefpcd = d.lnddefpc
gen lnedefpcd = d.lnedefpc
gen lnfdefpcd = d.lnfdefpc
gen lngdefpcd = d.lngdefpc
gen lnhdefpcd = d.lnhdefpc
gen lnidefpcd = d.lnidefpc
gen lnjdefpcd = d.lnjdefpc
gen lnkdefpcd = d.lnkdefpc
gen lnldefpcd = d.lnldefpc
gen lnmendefpcd = d.lnmendefpc
gen lnodefpcd = d.lnodefpc
gen lnpdefpcd = d.lnpdefpc
label variable lntotaldefpc "Log do VAB Total das Atividades Deflacionado per capita primeira Diferença"
label variable lnaebdefpc "Log do VAB da Agricultura e Produção florestal deflacionado per capita primeira Diferença"
label variable lncdefpc "Log do VAB da Indústrias extrativas deflacionado per capita primeira Diferença"
label variable lnddefpc "Log do VAB da Indústrias de transformação Deflacionado per capita primeira Diferença"
label variable lnedefpc "Log do VAB da Eletricidade e gás, água, esgoto, atividades de gestão de resíduos e descontaminação Deflacionado per capita primeira Diferença"
label variable lnfdefpc "Log do VAB da Construção Deflacionado per capita primeira Diferença"
label variable lngdefpc "Log do VAB da Comércio e reparação de veículos automotores e motocicletas Deflacionado per capita primeira Diferença"
label variable lnhdefpc "Log do VAB da Alojamento e alimentação Deflacionado per capita primeira Diferença"
label variable lnidefpc "Log do VAB da Transporte, Informação e comunicação Deflacionado per capita primeira Diferença"
label variable lnjdefpc "Log do VAB das Atividades financeiras, de seguros e serviços relacionados deflacionado per capita primeira Diferença"
label variable lnkdefpc "Log do VAB das Atividades imobiliárias deflacionado per capita primeira Diferença"
label variable lnldefpc "Log do VAB da Administração Pública Deflacionado per capita primeira Diferença"
label variable lnmendefpc "Log do VAB da Educação e saúde privados deflacionado per capita primeira Diferença"
label variable lnodefpc "Log do VAB das Atividades científicas e técnicas e da cultura e esporte Deflacionado per capita primeira Diferença"
label variable lnpdefpc "Log do VAB da Serviços domésticos deflacionado per capita primeira Diferença"


log using "C:\Users\alex_\Dropbox\Dissertação\ARTIGO\Modelo novo\MODELO COM A SOMA DA CONSTANTE APENAS NAS VARIÁVEIS QUE O LOG VIRA MISSING\Estatistica Descritiva.log", text replace

** ESTATISTICAS DESCRITIVAS
xtdescribe 
xtsum epc pibpc pibpc2 pibpc3 popuni urbuni vabitpc comintpc eletripc aebdefpc edefpc
** betwwen analise entre os individuos 
** within analise entre os individuos ao longo do tempo

log close

log using "C:\Users\alex_\Dropbox\Dissertação\ARTIGO\Modelo novo\MODELO COM A SOMA DA CONSTANTE APENAS NAS VARIÁVEIS QUE O LOG VIRA MISSING\Testes de Raiz Unitária - testes sem dependência.log", text replace

** TESTES DE RAIZ UNITÁRIA
* O xtunitroot realiza uma variedade de testes para raízes unitárias (ou estacionariedade) nos conjuntos de dados do painel.

** Para o presente trabalho utiliza-se dois pressupostos iniciais: independencia e dependência entre as unidades cross-sections.

/// Sobre a questão de INDEPENDÊNCIA serão usados os testes desenvolvidos por Levin et al. (2002), Breitung (2001) e Hadri (2000) inicialmente, dos quais 
/// considera-se que o painel como um todo apresenta uma raiz unitária e então tende a estacionariedade, comparando com um hipotese alternativa homogênea. 

** Por outro lado os testes desenvolvidos por Im et al. (2003), Manddala e Wu (1999) e Choi (2001), consideram a hipótes alternativa como heterogênea.

//Obs do help STATA: O topo da saída para cada teste explicita as hipóteses nula e alternativa. 
//As opções permitem incluir meios específicos de painel (efeitos fixos) e tendências de tempo no modelo do processo de geração de dados.


** TESTE DE RAIZ UNITÁRIA LEVIN-LIN-CHU (LLC test)
* Testar todas as variáveis da base de dados que serão utilizadas no modelo em formato de logarítmo Natural 
xtunitroot llc lnepc, lags(aic )
xtunitroot llc lnepc, lags(aic ) trend 
xtunitroot llc lnpibpc, lags(aic )
xtunitroot llc lnpibpc , lags(aic ) trend
xtunitroot llc lnpibpc2, lags(aic ) 
xtunitroot llc lnpibpc2, lags(aic ) trend
xtunitroot llc lnpibpc3, lags(aic ) 
xtunitroot llc lnpibpc3, lags(aic ) trend
xtunitroot llc lnpopuni, lags(aic ) 
xtunitroot llc lnpopuni, lags(aic ) trend
xtunitroot llc lnurbuni, lags(aic )
xtunitroot llc lnurbuni, lags(aic ) trend
xtunitroot llc lnvabitpc, lags(aic )
xtunitroot llc lnvabitpc, lags(aic ) trend
xtunitroot llc lncomintpc, lags(aic ) 
xtunitroot llc lncomintpc, lags(aic ) trend
xtunitroot llc lneletripc, lags(aic )
xtunitroot llc lneletripc, lags(aic ) trend
xtunitroot llc lnaebdefpc, lags(aic )
xtunitroot llc lnaebdefpc, lags(aic ) trend 
xtunitroot llc lnedefpc, lags(aic )
xtunitroot llc lnedefpc, lags(aic ) trend

* Testar todas as variáveis da base de dados que serão utilizadas no modelo em formato de logarítmo Natural calculada a primeira diferença
xtunitroot llc lnepcd, lags(aic )
xtunitroot llc lnepcd, lags(aic ) trend 
xtunitroot llc lnpibpcd, lags(aic )
xtunitroot llc lnpibpcd, lags(aic ) trend
xtunitroot llc lnpibpc2d, lags(aic )
xtunitroot llc lnpibpc2d, lags(aic ) trend
xtunitroot llc lnpibpc3d, lags(aic )
xtunitroot llc lnpibpc3d, lags(aic ) trend
xtunitroot llc lnpopunid, lags(aic ) 
xtunitroot llc lnpopunid, lags(aic ) trend
xtunitroot llc lnurbunid, lags(aic ) 
xtunitroot llc lnurbunid, lags(aic ) trend
xtunitroot llc lnvabitpcd, lags(aic )
xtunitroot llc lnvabitpcd, lags(aic )trend
xtunitroot llc lncomintpcd, lags(aic ) 
xtunitroot llc lncomintpcd, lags(aic ) trend
xtunitroot llc lneletripcd, lags(aic )
xtunitroot llc lneletripcd, lags(aic ) trend
xtunitroot llc lnaebdefpcd, lags(aic )
xtunitroot llc lnaebdefpcd, lags(aic ) trend 
xtunitroot llc lnedefpcd, lags(aic )
xtunitroot llc lnedefpcd, lags(aic ) trend


** TESTE DE RAIZ UNITÁRIA BREITUNG (Breitung test)
* Testar todas as variáveis da base de dados que serão utilizadas no modelo em formato de logarítmo Natural 
xtunitroot breitung lnepc
xtunitroot breitung lnepc, trend 
xtunitroot breitung lnpibpc 
xtunitroot breitung lnpibpc , trend
xtunitroot breitung lnpibpc2 
xtunitroot breitung lnpibpc2, trend
xtunitroot breitung lnpibpc3 
xtunitroot breitung lnpibpc3, trend
xtunitroot breitung lnpopuni 
xtunitroot breitung lnpopuni, trend
xtunitroot breitung lnurbuni 
xtunitroot breitung lnurbuni, trend
xtunitroot breitung lnvabitpc 
xtunitroot breitung lnvabitpc, trend
xtunitroot breitung lncomintpc 
xtunitroot breitung lncomintpc, trend
xtunitroot breitung lneletripc
xtunitroot breitung lneletripc, trend
xtunitroot breitung lnaebdefpc
xtunitroot breitung lnaebdefpc, trend 
xtunitroot breitung lnedefpc 
xtunitroot breitung lnedefpc, trend

* Testar todas as variáveis da base de dados que serão utilizadas no modelo em formato de logarítmo Natural calculada a primeira diferença
xtunitroot breitung lnepcd
xtunitroot breitung lnepcd, trend 
xtunitroot breitung lnpibpcd
xtunitroot breitung lnpibpcd, trend
xtunitroot breitung lnpibpc2d 
xtunitroot breitung lnpibpc2d, trend
xtunitroot breitung lnpibpc3d 
xtunitroot breitung lnpibpc3d, trend
xtunitroot breitung lnpopunid 
xtunitroot breitung lnpopunid, trend
xtunitroot breitung lnurbunid 
xtunitroot breitung lnurbunid, trend
xtunitroot breitung lnvabitpcd
xtunitroot breitung lnvabitpcd, trend
xtunitroot breitung lncomintpcd 
xtunitroot breitung lncomintpcd, trend
xtunitroot breitung lneletripcd
xtunitroot breitung lneletripcd, trend
xtunitroot breitung lnaebdefpcd
xtunitroot breitung lnaebdefpcd, trend 
xtunitroot breitung lnedefpcd 
xtunitroot breitung lnedefpcd, trend

** TESTE DE RAIZ UNITÁRIA HADRI (Hadri test)
* Testar todas as variáveis da base de dados que serão utilizadas no modelo em formato de logarítmo Natural 
xtunitroot hadri lnepc
xtunitroot hadri lnepc, trend 
xtunitroot hadri lnpibpc 
xtunitroot hadri lnpibpc , trend
xtunitroot hadri lnpibpc2 
xtunitroot hadri lnpibpc2, trend
xtunitroot hadri lnpibpc3 
xtunitroot hadri lnpibpc3, trend
xtunitroot hadri lnpopuni 
xtunitroot hadri lnpopuni, trend
xtunitroot hadri lnurbuni 
xtunitroot hadri lnurbuni, trend
xtunitroot hadri lnvabitpc 
xtunitroot hadri lnvabitpc, trend
xtunitroot hadri lncomintpc 
xtunitroot hadri lncomintpc, trend
xtunitroot hadri lneletripc
xtunitroot hadri lneletripc, trend
xtunitroot hadri lnaebdefpc
xtunitroot hadri lnaebdefpc, trend 
xtunitroot hadri lnedefpc  
xtunitroot hadri lnedefpc, trend

* Testar todas as variáveis da base de dados que serão utilizadas no modelo em formato de logarítmo Natural calculada a primeira diferença
xtunitroot hadri lnepcd
xtunitroot hadri lnepcd, trend 
xtunitroot hadri lnpibpcd
xtunitroot hadri lnpibpcd, trend
xtunitroot hadri lnpibpc2d 
xtunitroot hadri lnpibpc2d, trend
xtunitroot hadri lnpibpc3d 
xtunitroot hadri lnpibpc3d, trend
xtunitroot hadri lnpopunid 
xtunitroot hadri lnpopunid, trend
xtunitroot hadri lnurbunid 
xtunitroot hadri lnurbunid, trend
xtunitroot hadri lnvabitpcd
xtunitroot hadri lnvabitpcd, trend
xtunitroot hadri lncomintpcd 
xtunitroot hadri lncomintpcd, trend
xtunitroot hadri lneletripcd
xtunitroot hadri lneletripcd, trend
xtunitroot hadri lnaebdefpcd
xtunitroot hadri lnaebdefpcd, trend 
xtunitroot hadri lnedefpcd  
xtunitroot hadri lnedefpcd, trend

** TESTE DE RAIZ UNITÁRIA IPS (Im-Pesaran-Shin test)
* Testar todas as variáveis da base de dados que serão utilizadas no modelo em formato de logarítmo Natural 
xtunitroot ips lnepc, lags (aic )
xtunitroot ips lnepc, lags (aic ) trend 
xtunitroot ips lnpibpc, lags (aic )
xtunitroot ips lnpibpc , lags (aic ) trend
xtunitroot ips lnpibpc2, lags (aic ) 
xtunitroot ips lnpibpc2, lags (aic ) trend
xtunitroot ips lnpibpc3, lags (aic ) 
xtunitroot ips lnpibpc3, lags (aic ) trend
xtunitroot ips lnpopuni, lags (aic ) 
xtunitroot ips lnpopuni, lags (aic ) trend
xtunitroot ips lnurbuni, lags (aic ) 
xtunitroot ips lnurbuni, lags (aic ) trend
xtunitroot ips lnvabitpc, lags (aic ) 
xtunitroot ips lnvabitpc, lags (aic )trend
xtunitroot ips lncomintpc, lags (aic ) 
xtunitroot ips lncomintpc, lags (aic ) trend
xtunitroot ips lneletripc, lags (aic )
xtunitroot ips lneletripc, lags (aic ) trend
xtunitroot ips lnaebdefpc, lags (aic )
xtunitroot ips lnaebdefpc, lags (aic ) trend 
xtunitroot ips lnedefpc, lags (aic )
xtunitroot ips lnedefpc, lags (aic ) trend

* Testar todas as variáveis da base de dados que serão utilizadas no modelo em formato de logarítmo Natural calculada a primeira diferença
xtunitroot ips lnepcd, lags (aic )
xtunitroot ips lnepcd, lags (aic ) trend 
xtunitroot ips lnpibpcd, lags (aic )
xtunitroot ips lnpibpcd, lags (aic ) trend
xtunitroot ips lnpibpc2d, lags (aic ) 
xtunitroot ips lnpibpc2d, lags (aic ) trend
xtunitroot ips lnpibpc3d, lags (aic ) 
xtunitroot ips lnpibpc3d, lags (aic ) trend
xtunitroot ips lnpopunid, lags (aic ) 
xtunitroot ips lnpopunid, lags (aic ) trend
xtunitroot ips lnurbunid, lags (aic ) 
xtunitroot ips lnurbunid, lags (aic ) trend
xtunitroot ips lnvabitpcd, lags (aic )
xtunitroot ips lnvabitpcd, lags (aic ) trend
xtunitroot ips lncomintpcd, lags (aic )
xtunitroot ips lncomintpcd, lags (aic ) trend
xtunitroot ips lneletripcd, lags (aic )
xtunitroot ips lneletripcd, lags (aic ) trend
xtunitroot ips lnaebdefpcd, lags (aic )
xtunitroot ips lnaebdefpcd, lags (aic ) trend 
xtunitroot ips lnedefpcd, lags (aic )
xtunitroot ips lnedefpcd, lags (aic ) trend

** TESTE DE RAIZ UNITÁRIA FISHER-ADF(Maddala e Wu test)
* Testar todas as variáveis da base de dados que serão utilizadas no modelo em formato de logarítmo Natural
xtunitroot fisher lnepc, dfuller lags(1) 
xtunitroot fisher lnepc, dfuller lags(1) trend 
xtunitroot fisher lnpibpc, dfuller lags(1)
xtunitroot fisher lnpibpc , dfuller lags(1) trend
xtunitroot fisher lnpibpc2, dfuller lags(1)
xtunitroot fisher lnpibpc2, dfuller lags(1) trend
xtunitroot fisher lnpibpc3, dfuller lags(1) 
xtunitroot fisher lnpibpc3, dfuller lags(1) trend
xtunitroot fisher lnpopuni, dfuller lags(1)  
xtunitroot fisher lnpopuni, dfuller lags(1) trend
xtunitroot fisher lnurbuni, dfuller lags(1) 
xtunitroot fisher lnurbuni, dfuller lags(1) trend
xtunitroot fisher lnvabitpc, dfuller lags(1) 
xtunitroot fisher lnvabitpc, dfuller lags(1) trend
xtunitroot fisher lncomintpc, dfuller lags(1)
xtunitroot fisher lncomintpc, dfuller lags(1) trend
xtunitroot fisher lneletripc, dfuller lags(1)
xtunitroot fisher lneletripc, dfuller lags(1) trend
xtunitroot fisher lnaebdefpc, dfuller lags(1) 
xtunitroot fisher lnaebdefpc, dfuller lags(1) trend 
xtunitroot fisher lnedefpc, dfuller lags(1)
xtunitroot fisher lnedefpc, dfuller lags(1) trend

* Testar todas as variáveis da base de dados que serão utilizadas no modelo em formato de logarítmo Natural calculada a primeira diferença
xtunitroot fisher lnepcd, dfuller lags(1)
xtunitroot fisher lnepcd, dfuller lags(1) trend 
xtunitroot fisher lnpibpcd, dfuller lags(1)
xtunitroot fisher lnpibpcd, dfuller lags(1) trend
xtunitroot fisher lnpibpc2d, dfuller lags(1)
xtunitroot fisher lnpibpc2d, dfuller lags(1) trend
xtunitroot fisher lnpibpc3d, dfuller lags(1)
xtunitroot fisher lnpibpc3d, dfuller lags(1) trend
xtunitroot fisher lnpopunid, dfuller lags(1) 
xtunitroot fisher lnpopunid, dfuller lags(1) trend
xtunitroot fisher lnurbunid, dfuller lags(1) 
xtunitroot fisher lnurbunid, dfuller lags(1) trend
xtunitroot fisher lnvabitpcd, dfuller lags(1)
xtunitroot fisher lnvabitpcd, dfuller lags(1) trend
xtunitroot fisher lncomintpcd, dfuller lags(1)
xtunitroot fisher lncomintpcd, dfuller lags(1) trend
xtunitroot fisher lneletripcd, dfuller lags(1)
xtunitroot fisher lneletripcd, dfuller lags(1) trend
xtunitroot fisher lnaebdefpcd, dfuller lags(1) 
xtunitroot fisher lnaebdefpcd, dfuller lags(1) trend 
xtunitroot fisher lnedefpcd, dfuller lags(1)
xtunitroot fisher lnedefpcd, dfuller lags(1) trend


** TESTE DE RAIZ UNITÁRIA FISHER-PP(Choi test)
* Testar todas as variáveis da base de dados que serão utilizadas no modelo em formato de logarítmo Natural 
xtunitroot fisher lnepc, pperron lags(1) 
xtunitroot fisher lnepc, pperron lags(1) trend 
xtunitroot fisher lnpibpc, pperron lags(1)
xtunitroot fisher lnpibpc , pperron lags(1) trend
xtunitroot fisher lnpibpc2, pperron lags(1)
xtunitroot fisher lnpibpc2, pperron lags(1) trend
xtunitroot fisher lnpibpc3, pperron lags(1) 
xtunitroot fisher lnpibpc3, pperron lags(1) trend
xtunitroot fisher lnpopuni, pperron lags(1)  
xtunitroot fisher lnpopuni, pperron lags(1) trend
xtunitroot fisher lnurbuni, pperron lags(1) 
xtunitroot fisher lnurbuni, pperron lags(1) trend
xtunitroot fisher lnvabitpc, pperron lags(1) 
xtunitroot fisher lnvabitpc, pperron lags(1) trend
xtunitroot fisher lncomintpc, pperron lags(1)
xtunitroot fisher lncomintpc, pperron lags(1) trend
xtunitroot fisher lneletripc, pperron lags(1)
xtunitroot fisher lneletripc, pperron lags(1) trend
xtunitroot fisher lnaebdefpc, pperron lags(1) 
xtunitroot fisher lnaebdefpc, pperron lags(1) trend 
xtunitroot fisher lnedefpc, pperron lags(1)
xtunitroot fisher lnedefpc, pperron lags(1) trend

* Testar todas as variáveis da base de dados que serão utilizadas no modelo em formato de logarítmo Natural calculada a primeira diferença
xtunitroot fisher lnepcd, pperron lags(1)
xtunitroot fisher lnepcd, pperron lags(1) trend 
xtunitroot fisher lnpibpcd, pperron lags(1)
xtunitroot fisher lnpibpcd, pperron lags(1) trend
xtunitroot fisher lnpibpc2d, pperron lags(1)
xtunitroot fisher lnpibpc2d, pperron lags(1) trend
xtunitroot fisher lnpibpc3d, pperron lags(1)
xtunitroot fisher lnpibpc3d, pperron lags(1) trend
xtunitroot fisher lnpopunid, pperron lags(1) 
xtunitroot fisher lnpopunid, pperron lags(1) trend
xtunitroot fisher lnurbunid, pperron lags(1) 
xtunitroot fisher lnurbunid, pperron lags(1) trend
xtunitroot fisher lnvabitpcd, pperron lags(1)
xtunitroot fisher lnvabitpcd, pperron lags(1) trend
xtunitroot fisher lncomintpcd, pperron lags(1)
xtunitroot fisher lncomintpcd, pperron lags(1) trend
xtunitroot fisher lneletripcd, pperron lags(1)
xtunitroot fisher lneletripcd, pperron lags(1) trend
xtunitroot fisher lnaebdefpcd, pperron lags(1) 
xtunitroot fisher lnaebdefpcd, pperron lags(1) trend 
xtunitroot fisher lnedefpcd, pperron lags(1)
xtunitroot fisher lnedefpcd, pperron lags(1) trend

log close





log using "C:\Users\alex_\Dropbox\Dissertação\ARTIGO\Modelo novo\MODELO COM A SOMA DA CONSTANTE APENAS NAS VARIÁVEIS QUE O LOG VIRA MISSING\Testes de Raiz Unitária - testes de dependência - NÍVEL.log", text replace
/// Sobre a questão de DEPENDÊNCIA, utilizará os testes desenvolvidos por Pesaran (2007) e o desenvolvido por Moon e Perron (2004). 

** No entanto, para que seja necessário mesmo a aplicação destes testes, faz-se necessário a realização de um teste de análise sobre a dependência. Este teste foi proposto
/// por Pesaran (2004), nomeado de CD teste.

** O trabalho de Hoyos e Sarafidis (2006) do The Stata Journal foi utilizado para os comandos do teste de uma regressão EF e EA. VARIÁVEIS EM NÍVEL

**MODELO 1 - SEM VAB
ssc install xtcsd
quietly xtreg lnepc lnpibpc lnpibpc2 lnpibpc3 lnpopuni lnurbuni lnvabitpc lncomintpc lneletripc, fe
xtcsd, pesaran abs

quietly xtreg lnepc lnpibpc lnpibpc2 lnpibpc3 lnpopuni lnurbuni lnvabitpc lncomintpc lneletripc, re
xtcsd, pesaran abs

*Obs.: HO é ausência de dependência nas cross-sections

**MODELO 2
ssc install xtcsd
quietly xtreg lnepc lnpibpc lnpibpc2 lnpibpc3 lnpopuni lnurbuni lnvabitpc lncomintpc lneletripc lnaebdefpc lnedefpc, fe
xtcsd, pesaran abs

quietly xtreg lnepc lnpibpc lnpibpc2 lnpibpc3 lnpopuni lnurbuni lnvabitpc lncomintpc lneletripc lnaebdefpc lnedefpc, re
xtcsd, pesaran abs
*Obs.: HO é ausência de dependência nas cross-sections


** OS TESTES DE FREES E FRIEDMAN não serão analisados na dissertação, no entanto, são indicados por Hoyos e Sarafidis (2006), para confirmar o desenvolvido por Pesaran (2004). Assim; 

**MODELO 1 - SEM VAB
quietly xtreg lnepc lnpibpc lnpibpc2 lnpibpc3 lnpopuni lnurbuni lnvabitpc lncomintpc lneletripc, fe
xtcsd, pesaran abs
xtcsd, frees
xtcsd, friedman

quietly xtreg lnepc lnpibpc lnpibpc2 lnpibpc3 lnpopuni lnurbuni lnvabitpc lncomintpc lneletripc, re
xtcsd, pesaran abs
xtcsd, frees
xtcsd, friedman

*Obs.: HO é ausência de dependência nas cross-sections

**MODELO 2
quietly xtreg lnepc lnpibpc lnpibpc2 lnpibpc3 lnpopuni lnurbuni lnvabitpc lncomintpc lneletripc lnaebdefpc lnedefpc, fe
xtcsd, pesaran abs
xtcsd, frees
xtcsd, friedman

quietly xtreg lnepc lnpibpc lnpibpc2 lnpibpc3 lnpopuni lnurbuni lnvabitpc lncomintpc lneletripc lnaebdefpc lnedefpc, re
xtcsd, pesaran abs
xtcsd, frees
xtcsd, friedman

*Obs.: HO é ausência de dependência nas cross-sections

** Comando para as Variáveis isoladamente para testar PESARAN (2004)
**MODELO 1 - SEM VAB
ssc install xtcdf
global intlist lnepc lnpibpc lnpibpc2 lnpibpc3 lnpopuni lnurbuni lnvabitpc lncomintpc lneletripc 
xtcdf $intlist

**MODELO 2 
ssc install xtcdf
global intlistvab lnepc lnpibpc lnpibpc2 lnpibpc3 lnpopuni lnurbuni lnvabitpc lncomintpc lneletripc lnaebdefpc lnedefpc
xtcdf $intlistvab

log close

log using "C:\Users\alex_\Dropbox\Dissertação\ARTIGO\Modelo novo\MODELO COM A SOMA DA CONSTANTE APENAS NAS VARIÁVEIS QUE O LOG VIRA MISSING\Testes de Raiz Unitária - testes de dependência - PRIMEIRA DIFERENÇA.log", text replace

** O trabalho de Hoyos e Sarafidis (2006) do The Stata Journal foi utilizado para os comandos do teste de uma regressão EF e EA. VARIÁVEIS DEFASADAS
**MODELO 1 - SEM VAB
ssc install xtcsd
quietly xtreg lnepcd lnpibpcd lnpibpc2d lnpibpc3d lnpopunid lnurbunid lnvabitpcd lncomintpcd lneletripcd, fe
xtcsd, pesaran abs

quietly xtreg lnepcd lnpibpcd lnpibpc2d lnpibpc3d lnpopunid lnurbunid lnvabitpcd lncomintpcd lneletripcd, re
xtcsd, pesaran abs

*Obs.: HO é ausência de dependência nas cross-sections

**MODELO 2
ssc install xtcsd
quietly xtreg lnepcd lnpibpcd lnpibpc2d lnpibpc3d lnpopunid lnurbunid lnvabitpcd lncomintpcd lneletripcd lnaebdefpcd lnedefpcd, fe
xtcsd, pesaran abs

quietly xtreg lnepcd lnpibpcd lnpibpc2d lnpibpc3d lnpopunid lnurbunid lnvabitpcd lncomintpcd lneletripcd lnaebdefpcd lnedefpcd, re
xtcsd, pesaran abs

*Obs.: HO é ausência de dependência nas cross-sections


** OS TESTES DE FREES E FRIEDMAN não serão analisados na dissertação, no entanto, são indicados por Hoyos e Sarafidis (2006), para confirmar o desenvolvido por Pesaran (2004). Assim; 

**MODELO 1 - SEM VAB
quietly xtreg lnepcd lnpibpcd lnpibpc2d lnpibpc3d lnpopunid lnurbunid lnvabitpcd lncomintpcd lneletripcd, fe
xtcsd, pesaran abs
xtcsd, frees
xtcsd, friedman

quietly xtreg lnepcd lnpibpcd lnpibpc2d lnpibpc3d lnpopunid lnurbunid lnvabitpcd lncomintpcd lneletripcd, re
xtcsd, pesaran abs
xtcsd, frees
xtcsd, friedman

*Obs.: HO é ausência de dependência nas cross-sections

**MODELO 2
quietly xtreg lnepcd lnpibpcd lnpibpc2d lnpibpc3d lnpopunid lnurbunid lnvabitpcd lncomintpcd lneletripcd lnaebdefpcd lnedefpcd, fe
xtcsd, pesaran abs
xtcsd, frees
xtcsd, friedman

quietly xtreg lnepcd lnpibpcd lnpibpc2d lnpibpc3d lnpopunid lnurbunid lnvabitpcd lncomintpcd lneletripcd lnaebdefpcd lnedefpcd, re
xtcsd, pesaran abs
xtcsd, frees
xtcsd, friedman

*Obs.: HO é ausência de dependência nas cross-sections

** Comando para as Variáveis isoladamente para testar PESARAN (2004)
**MODELO 1 - SEM VAB
ssc install xtcdf
global intlistD lnepcd lnpibpcd lnpibpc2d lnpibpc3d lnpopunid lnurbunid lnvabitpcd lncomintpcd lneletripcd 
xtcdf $intlistD

**MODELO 2
ssc install xtcdf
global intlistDvab lnepcd lnpibpcd lnpibpc2d lnpibpc3d lnpopunid lnurbunid lnvabitpcd lncomintpcd lneletripcd lnaebdefpcd lnedefpcd
xtcdf $intlistDvab

log close

log using "C:\Users\alex_\Dropbox\Dissertação\ARTIGO\Modelo novo\MODELO COM A SOMA DA CONSTANTE APENAS NAS VARIÁVEIS QUE O LOG VIRA MISSING\Testes de Raiz Unitária - testes com dependência.log", text replace
** TESTES DE RAIZ UNITÁRIA PARA PAINEIS COM DEPENDÊNCIA NAS CROSS-SECTIONS

* TESTE DE RAIZ UNITÁRIA CADF (Pesaran test) 
ssc install pescadf

* Testar todas as variáveis da base de dados que serão utilizadas no modelo em formato de logarítmo Natural 
pescadf lnepc, lags(1)
pescadf lnepc, lags(1) trend 
pescadf lnpibpc, lags(1)
pescadf lnpibpc, lags(1) trend
pescadf lnpibpc2, lags(1)
pescadf lnpibpc2, lags(1) trend
pescadf lnpibpc3, lags(1)
pescadf lnpibpc3, lags(1) trend
pescadf lnpopuni, lags(1) 
pescadf lnpopuni, lags(1) trend
pescadf lnurbuni, lags(1) 
pescadf lnurbuni, lags(1) trend
pescadf lnvabitpc, lags(1)
pescadf lnvabitpc, lags(1) trend
pescadf lncomintpc, lags(1)
pescadf lncomintpc, lags(1) trend
pescadf lneletripc, lags(1)
pescadf lneletripc, lags(1) trend
pescadf lnaebdefpc, lags(1)
pescadf lnaebdefpc, lags(1) trend 
pescadf lnedefpc, lags(1)
pescadf lnedefpc, lags(1) trend

pescadf lnepc, lags(2)
pescadf lnepc, lags(2) trend 
pescadf lnpibpc, lags(2)
pescadf lnpibpc, lags(2) trend
pescadf lnpibpc2, lags(2)
pescadf lnpibpc2, lags(2) trend
pescadf lnpibpc3, lags(2)
pescadf lnpibpc3, lags(2) trend
pescadf lnpopuni, lags(2) 
pescadf lnpopuni, lags(2) trend
pescadf lnurbuni, lags(2) 
pescadf lnurbuni, lags(2) trend
pescadf lnvabitpc, lags(2)
pescadf lnvabitpc, lags(2) trend
pescadf lncomintpc, lags(2)
pescadf lncomintpc, lags(2) trend
pescadf lneletripc, lags(2)
pescadf lneletripc, lags(2) trend
pescadf lnaebdefpc, lags(2)
pescadf lnaebdefpc, lags(2) trend 
pescadf lnedefpc, lags(2)
pescadf lnedefpc, lags(2) trend

* Testar todas as variáveis da base de dados que serão utilizadas no modelo em formato de logarítmo Natural calculada a primeira diferença
pescadf lnepcd, lags(1)
pescadf lnepcd, lags(1) trend 
pescadf lnpibpcd, lags(1)
pescadf lnpibpcd, lags(1) trend
pescadf lnpibpc2d, lags(1)
pescadf lnpibpc2d, lags(1) trend
pescadf lnpibpc3d, lags(1)
pescadf lnpibpc3d, lags(1) trend
pescadf lnpopunid, lags(1) 
pescadf lnpopunid, lags(1) trend
pescadf lnurbunid, lags(1) 
pescadf lnurbunid, lags(1) trend
pescadf lnvabitpcd, lags(1)
pescadf lnvabitpcd, lags(1) trend
pescadf lncomintpcd, lags(1)
pescadf lncomintpcd, lags(1) trend
pescadf lneletripcd, lags(1)
pescadf lneletripcd, lags(1) trend
pescadf lnaebdefpcd, lags(1)
pescadf lnaebdefpcd, lags(1) trend 
pescadf lnedefpcd, lags(1)
pescadf lnedefpcd, lags(1) trend

pescadf lnepcd, lags(2)
pescadf lnepcd, lags(2) trend 
pescadf lnpibpcd, lags(2)
pescadf lnpibpcd, lags(2) trend
pescadf lnpibpc2d, lags(2)
pescadf lnpibpc2d, lags(2) trend
pescadf lnpibpc3d, lags(2)
pescadf lnpibpc3d, lags(2) trend
pescadf lnpopunid, lags(2) 
pescadf lnpopunid, lags(2) trend
pescadf lnurbunid, lags(2) 
pescadf lnurbunid, lags(2) trend
pescadf lnvabitpcd, lags(2)
pescadf lnvabitpcd, lags(2) trend
pescadf lncomintpcd, lags(2)
pescadf lncomintpcd, lags(2) trend
pescadf lneletripcd, lags(2)
pescadf lneletripcd, lags(2) trend
pescadf lnaebdefpcd, lags(2)
pescadf lnaebdefpcd, lags(2) trend 
pescadf lnedefpcd, lags(2)
pescadf lnedefpcd, lags(2) trend

* TESTE DE RAIZ UNITÁRIA CPIS (Pesaran test)
ssc install xtcips

* Testar todas as variáveis da base de dados que serão utilizadas no modelo em formato de logarítmo Natural 
xtcips lnepc, maxlags(1) bglags (1) noc
xtcips lnepc, maxlags(1) bglags (1) trend 
xtcips lnpibpc, maxlags(1) bglags (1) noc
xtcips lnpibpc, maxlags(1) bglags (1) trend
xtcips lnpibpc2, maxlags(1) bglags (1) noc
xtcips lnpibpc2, maxlags(1) bglags (1) trend
xtcips lnpibpc3, maxlags(1) bglags (1) noc
xtcips lnpibpc3, maxlags(1) bglags (1) trend
xtcips lnpopuni, maxlags(1) bglags (1) noc 
xtcips lnpopuni, maxlags(1) bglags (1) trend
xtcips lnurbuni, maxlags(1) bglags (1) noc 
xtcips lnurbuni, maxlags(1) bglags (1) trend
xtcips lnvabitpc, maxlags(1) bglags (1) noc
xtcips lnvabitpc, maxlags(1) bglags (1) trend
xtcips lncomintpc, maxlags(1) bglags (1) noc
xtcips lncomintpc, maxlags(1) bglags (1) trend
xtcips lneletripc, maxlags(1) bglags (1) noc
xtcips lneletripc, maxlags(1) bglags (1) trend
xtcips lnaebdefpc, maxlags(1) bglags (1) noc
xtcips lnaebdefpc, maxlags(1) bglags (1) trend 
xtcips lnedefpc, maxlags(1) bglags (1) noc
xtcips lnedefpc, maxlags(1) bglags (1) trend

* Testar todas as variáveis da base de dados que serão utilizadas no modelo em formato de logarítmo Natural calculada a primeira diferença
xtcips lnepcd, maxlags(1) bglags (1) noc
xtcips lnepcd, maxlags(1) bglags (1) trend 
xtcips lnpibpcd, maxlags(1) bglags (1) noc
xtcips lnpibpcd, maxlags(1) bglags (1) trend
xtcips lnpibpc2d, maxlags(1) bglags (1) noc
xtcips lnpibpc2d, maxlags(1) bglags (1) trend
xtcips lnpibpc3d, maxlags(1) bglags (1) noc
xtcips lnpibpc3d, maxlags(1) bglags (1) trend
xtcips lnpopunid, maxlags(1) bglags (1) noc 
xtcips lnpopunid, maxlags(1) bglags (1) trend
xtcips lnurbunid, maxlags(1) bglags (1) noc 
xtcips lnurbunid, maxlags(1) bglags (1) trend
xtcips lnvabitpcd, maxlags(1) bglags (1) noc
xtcips lnvabitpcd, maxlags(1) bglags (1) trend
xtcips lncomintpcd, maxlags(1) bglags (1) noc
xtcips lncomintpcd, maxlags(1) bglags (1) trend
xtcips lneletripcd, maxlags(1) bglags (1) noc
xtcips lneletripcd, maxlags(1) bglags (1) trend
xtcips lnaebdefpcd, maxlags(1) bglags (1) noc
xtcips lnaebdefpcd, maxlags(1) bglags (1) trend 
xtcips lnedefpcd, maxlags(1) bglags (1) noc
xtcips lnedefpcd, maxlags(1) bglags (1) trend

log close

log using "C:\Users\alex_\Dropbox\Dissertação\ARTIGO\Modelo novo\MODELO COM A SOMA DA CONSTANTE APENAS NAS VARIÁVEIS QUE O LOG VIRA MISSING\Testes de Cointegração - NÍVEL.log", text replace

*** TESTES DE COINTEGRAÇÃO DO PAINEL  - VARIÁVEIS NIVEIS 

** Para os testes de cointegração será utilziado o pacote de xtconittest do STATA 15, para estimar os resultados. Primeiro será realizado o teste de 
//PEDRONI (1999, 2004), Kao (1999) e Westernund (2005).

// TESTE DE PEDRONI (1999, 2004)

**MODELO 1 - SEM VAB
global pedronilist lnpibpc lnpibpc2 lnpopuni lnurbuni lnvabitpc lncomintpc lneletripc 
* Pedroni com parametro AR específico de paniel
xtcointtest pedroni lnepc $pedronilist, ar(panelspecific) lags(aic )
xtcointtest pedroni lnepc $pedronilist, ar(panelspecific) lags(aic ) trend

* Pedroni com parametro AR comum do paniel
xtcointtest pedroni lnepc $pedronilist, ar(same) lags(aic )
xtcointtest pedroni lnepc $pedronilist, ar(same) lags(aic ) trend

** O Limite de variáveis para o teste de Pedroni é de 7, o medelo é composto por 8, incluindo a varivável cubica econômica

**MODELO 2
global pedronilistaeb lnpibpc lnpibpc2 lnpopuni lnvabitpc lnaebdefpc lneletripc 
global pedroniliste lnpibpc lnpibpc2 lnpopuni lnvabitpc  lnedefpc lneletripc 
* Pedroni com parametro AR específico de paniel
xtcointtest pedroni lnepc $pedronilistaeb, ar(panelspecific) lags(aic )
xtcointtest pedroni lnepc $pedronilistaeb, ar(panelspecific) lags(aic ) trend

xtcointtest pedroni lnepc $pedroniliste, ar(panelspecific) lags(aic )
xtcointtest pedroni lnepc $pedroniliste, ar(panelspecific) lags(aic ) trend

* Pedroni com parametro AR comum do paniel
xtcointtest pedroni lnepc $pedronilistaeb, ar(same) lags(aic )
xtcointtest pedroni lnepc $pedronilistaeb, ar(same) lags(aic ) trend

xtcointtest pedroni lnepc $pedroniliste, ar(same) lags(aic )
xtcointtest pedroni lnepc $pedroniliste, ar(same) lags(aic ) trend

** O Limite de variáveis para o teste de Pedroni é de 7, o medelo é composto por 8, incluindo a varivável cubica econômica

// TESTE DE KAO (1999)
**MODELO 1 - SEM VAB
global kaolist lnpibpc lnpibpc2 lnpibpc3 lnpopuni lnurbuni lnvabitpc lncomintpc lneletripc 
xtcointtest kao lnepc $kaolist, lags(aic )

**MODELO 2
global kaolist lnpibpc lnpibpc2 lnpibpc3 lnpopuni lnvabitpc lnaebdefpc lnedefpc lncomintpc lneletripc 
xtcointtest kao lnepc $kaolist, lags(aic )


// TESTE DE WESTERLUND (2005)
*MODELO 1 - SEM VAB
global westerlundlist lnpibpc lnpibpc2 lnpopuni lnurbuni lnvabitpc lncomintpc lneletripc
** Westerlund com cointegração de alguns paineis
xtcointtest westerlund lnepc $westerlundlist, somepanels
xtcointtest westerlund lnepc $westerlundlist, somepanels trend

** Westerlund com cointegração de todos os paineis
xtcointtest westerlund lnepc $westerlundlist, allpanels
xtcointtest westerlund lnepc $westerlundlist, allpanels trend
** O Limite de variáveis para o teste de Westerlund (2005) é de 7, o medelo é composto por 8, incluindo
// a varivável cubica econômica

**obs. TESTE DE WESTERLUND (2007)
*Baseado no trabalho de Persyn e Westerlund (2008) do The Stata Journal, com o comando
// xtwest.
global westlist lnpibpc lnpibpc2 lnpopuni lnvabitpc lncomintpc lneletripc 
xtwest lnepc $westlist, lags(1) lrwindow(3) constant bootstrap(400)
xtwest lnepc $westlist, lags(1) lrwindow(3) constant bootstrap(400) trend

** Obs: lrwindow é calculado a partir da seguinte equação 4(T/100)^2/9, no caso da dissertação
// 4(25/100)^2/9 = 2,93 aproximadamente 3.

** O Limite de variáveis para o teste de Westerlund (2007) é de 6, o medelo é composto por 8, incluindo
// a varivável cubica econômica e a população urbana

**MODELO 2
global westerlundlistaeb lnpibpc lnpibpc2 lnpopuni lnvabitpc lnaebdefpc lneletripc
global westerlundliste lnpibpc lnpibpc2 lnpopuni lnvabitpc lnedefpc lneletripc
** Westerlund com cointegração de alguns paineis
xtcointtest westerlund lnepc $westerlundlistaeb, somepanels
xtcointtest westerlund lnepc $westerlundlistaeb, somepanels trend
xtcointtest westerlund lnepc $westerlundliste, somepanels
xtcointtest westerlund lnepc $westerlundliste, somepanels trend

** Westerlund com cointegração de todos os paineis
xtcointtest westerlund lnepc $westerlundlistaeb, allpanels
xtcointtest westerlund lnepc $westerlundlistaeb, allpanels trend
xtcointtest westerlund lnepc $westerlundliste, allpanels
xtcointtest westerlund lnepc $westerlundliste, allpanels trend

** O Limite de variáveis para o teste de Westerlund (2005) é de 7, o medelo é composto por 8, incluindo
// a varivável cubica econômica

**obs. TESTE DE WESTERLUND (2007)
*Baseado no trabalho de Persyn e Westerlund (2008) do The Stata Journal, com o comando
// xtwest.
global westlistaeb lnpibpc lnpibpc2 lnpopuni lnvabitpc lnaebdefpc lneletripc 
xtwest lnepc $westlistaeb, lags(1) lrwindow(3) constant bootstrap(400)
xtwest lnepc $westlistaeb, lags(1) lrwindow(3) constant bootstrap(400) trend

global westliste lnpibpc lnpibpc2 lnpopuni lnvabitpc lnedefpc lneletripc 
xtwest lnepc $westliste, lags(1) lrwindow(3) constant bootstrap(400)
xtwest lnepc $westliste, lags(1) lrwindow(3) constant bootstrap(400) trend


** Obs: lrwindow é calculado a partir da seguinte equação 4(T/100)^2/9, no caso da dissertação
// 4(25/100)^2/9 = 2,93 aproximadamente 3.

** O Limite de variáveis para o teste de Westerlund (2007) é de 6, o medelo é composto por 8, incluindo
// a varivável cubica econômica e a população urbana

log close


log using "C:\Users\alex_\Dropbox\Dissertação\ARTIGO\Modelo novo\MODELO COM A SOMA DA CONSTANTE APENAS NAS VARIÁVEIS QUE O LOG VIRA MISSING\Testes de Cointegração - PRIMEIRA DIFERENÇA.log", text replace

*** TESTES DE COINTEGRAÇÃO DO PAINEL  - VARIÁVEIS COM PRIMEIRA DIFERANÇA

** Para os testes de cointegração será utilziado o pacote de xtconittest do STATA 15, 
*para estimar os resultados. Primeiro será realizado o teste de PEDRONI (1999, 2004), Kao (1999),
*e Westernund (2005).

// TESTE DE PEDRONI (1999, 2004)
**MODELO 1 - SEM VAB
global pedronilistD lnpibpcd lnpibpc2d lnpopunid lnurbunid lnvabitpcd lncomintpcd lneletripcd 
* Pedroni com parametro AR específico de paniel
xtcointtest pedroni lnepcd $pedronilistD, ar(panelspecific) lags(aic )
xtcointtest pedroni lnepcd $pedronilistD, ar(panelspecific) lags(aic ) trend

* Pedroni com parametro AR comum do paniel
xtcointtest pedroni lnepcd $pedronilistD, ar(same) lags(aic )
xtcointtest pedroni lnepcd $pedronilistD, ar(same) lags(aic ) trend

** O Limite de variáveis para o teste de Pedroni é de 7, o medelo é composto por 8, incluindo a varivável cubica econômica

**MODELO 2
global pedronilistDaeb lnpibpcd lnpibpc2d lnpopunid lnvabitpcd lnaebdefpcd lneletripcd 
global pedronilistDe lnpibpcd lnpibpc2d lnpopunid lnvabitpcd  lnedefpcd lneletripcd 
* Pedroni com parametro AR específico de paniel
xtcointtest pedroni lnepcd $pedronilistDaeb, ar(panelspecific) lags(aic )
xtcointtest pedroni lnepcd $pedronilistDaeb, ar(panelspecific) lags(aic ) trend

xtcointtest pedroni lnepcd $pedronilistDe, ar(panelspecific) lags(aic )
xtcointtest pedroni lnepcd $pedronilistDe, ar(panelspecific) lags(aic ) trend

* Pedroni com parametro AR comum do paniel
xtcointtest pedroni lnepcd $pedronilistDaeb, ar(same) lags(aic )
xtcointtest pedroni lnepcd $pedronilistDaeb, ar(same) lags(aic ) trend

xtcointtest pedroni lnepcd $pedronilistDe, ar(same) lags(aic )
xtcointtest pedroni lnepcd $pedronilistDe, ar(same) lags(aic ) trend

** O Limite de variáveis para o teste de Pedroni é de 7, o medelo é composto por 8, incluindo a varivável cubica econômica


// TESTE DE KAO (1999)
**MODELO 1 - SEM VAB
global kaolistD lnpibpcd lnpibpc2d lnpibpc3d lnpopunid lnurbunid lnvabitpcd lncomintpcd lneletripcd 
xtcointtest kao lnepcd $kaolistD, lags(aic )

**MODELO 2
global kaolistD lnpibpcd lnpibpc2d lnpibpc3d lnpopunid lnvabitpcd lnaebdefpcd lnedefpcd lncomintpcd lneletripcd 
xtcointtest kao lnepcd $kaolistD, lags(aic )


// TESTE DE WESTERLUND (2005)
**MODELO 1 - SEM VAB
global westerlundlistD lnpibpcd lnpibpc2d lnpopunid lnurbunid lnvabitpcd lncomintpcd lneletripcd
** Westerlund com cointegração de alguns paineis
xtcointtest westerlund lnepcd $westerlundlistD, somepanels
xtcointtest westerlund lnepcd $westerlundlistD, somepanels trend

** Westerlund com cointegração de todos os paineis
xtcointtest westerlund lnepcd $westerlundlistD, allpanels
xtcointtest westerlund lnepcd $westerlundlistD, allpanels trend
** O Limite de variáveis para o teste de Westerlund (2005) é de 7, o medelo é composto por 8, incluindo
// a varivável cubica econômica

**obs. TESTE DE WESTERLUND (2007)
*Baseado no trabalho de Persyn e Westerlund (2008) do The Stata Journal, com o comando
// xtwest.
global westlistD lnpibpcd lnpibpc2d lnpopunid lnvabitpcd lncomintpcd lneletripcd 
xtwest lnepcd $westlistD, lags(1) lrwindow(3) constant bootstrap(400)
xtwest lnepcd $westlistD, lags(1) lrwindow(3) constant bootstrap(400) trend

** Obs: lrwindow é calculado a partir da seguinte equação 4(T/100)^2/9, no caso da dissertação
// 4(25/100)^2/9 = 2,93 aproximadamente 3.

** O Limite de variáveis para o teste de Westerlund (2007) é de 6, o medelo é composto por 8, incluindo
// a varivável cubica econômica e a população urbana


**MODELO 2
// TESTE DE WESTERLUND (2005)
global westerlundlistDaeb lnpibpcd lnpibpc2d lnpopunid lnvabitpcd lnaebdefpcd lneletripcd
global westerlundlistDe lnpibpcd lnpibpc2d lnpopunid lnvabitpcd lnedefpcd lneletripcd
** Westerlund com cointegração de alguns paineis
xtcointtest westerlund lnepcd $westerlundlistDaeb, somepanels
xtcointtest westerlund lnepcd $westerlundlistDaeb, somepanels trend
xtcointtest westerlund lnepcd $westerlundlistDe, somepanels
xtcointtest westerlund lnepcd $westerlundlistDe, somepanels trend

** Westerlund com cointegração de todos os paineis
xtcointtest westerlund lnepcd $westerlundlistDaeb, allpanels
xtcointtest westerlund lnepcd $westerlundlistDaeb, allpanels trend
xtcointtest westerlund lnepcd $westerlundlistDe, allpanels
xtcointtest westerlund lnepcd $westerlundlistDe, allpanels trend

** O Limite de variáveis para o teste de Westerlund (2005) é de 7, o medelo é composto por 8, incluindo
// a varivável cubica econômica

**obs. TESTE DE WESTERLUND (2007)
*Baseado no trabalho de Persyn e Westerlund (2008) do The Stata Journal, com o comando
// xtwest.
global westlistDaeb lnpibpcd lnpibpc2d lnpopunid lnvabitpcd lnaebdefpcd lneletripcd 
xtwest lnepc $westlistDaeb, lags(1) lrwindow(3) constant bootstrap(400)
xtwest lnepc $westlistDaeb, lags(1) lrwindow(3) constant bootstrap(400) trend

global westlistDe lnpibpcd lnpibpc2d lnpopunid lnvabitpcd lnedefpcd lneletripcd 
xtwest lnepc $westlistDe, lags(1) lrwindow(3) constant bootstrap(400)
xtwest lnepc $westlistDe, lags(1) lrwindow(3) constant bootstrap(400) trend

** Obs: lrwindow é calculado a partir da seguinte equação 4(T/100)^2/9, no caso da dissertação
// 4(25/100)^2/9 = 2,93 aproximadamente 3.

** O Limite de variáveis para o teste de Westerlund (2007) é de 6, o medelo é composto por 8, incluindo
// a varivável cubica econômica e a população urbana

log close


log using "C:\Users\alex_\Dropbox\Dissertação\ARTIGO\Modelo novo\MODELO COM A SOMA DA CONSTANTE APENAS NAS VARIÁVEIS QUE O LOG VIRA MISSING\Testes de Cointegração CAK - NÍVEL.log", text replace
*** TESTES DE COINTEGRAÇÃO PARA VARIÁVES PADRÃO DA CAK - EMISSÕES, PIB, PIB², PIB³
*** VARIÁVEIS NIVEIS 

** Para os testes de cointegração será utilziado o pacote de xtconittest do STATA 15, 
*para estimar os resultados. Primeiro será realizado o teste de PEDRONI (1999, 2004), Kao (1999),
*e Westernund (2005).

// TESTE DE PEDRONI (1999, 2004)
global pedronilistCAK lnpibpc lnpibpc2 lnpibpc3
* Pedroni com parametro AR específico de paniel
xtcointtest pedroni lnepc $pedronilistCAK, ar(panelspecific) lags(aic )
xtcointtest pedroni lnepc $pedronilistCAK, ar(panelspecific) lags(aic ) trend

* Pedroni com parametro AR comum do paniel
xtcointtest pedroni lnepc $pedronilistCAK, ar(same) lags(aic )
xtcointtest pedroni lnepc $pedronilistCAK, ar(same) lags(aic ) trend

** O Limite de variáveis para o teste de Pedroni é de 7, o medelo é composto por 8, incluindo
// a varivável cubica econômica

// TESTE DE KAO (1999)
global kaolistCAK lnpibpc lnpibpc2 lnpibpc3 
xtcointtest kao lnepc $kaolistCAK, lags(aic )

// TESTE DE WESTERLUND (2005)
global westerlundlistCAK lnpibpc lnpibpc2 lnpibpc3
** Westerlund com cointegração de alguns paineis
xtcointtest westerlund lnepc $westerlundlistCAK, somepanels
xtcointtest westerlund lnepc $westerlundlistCAK, somepanels trend

** Westerlund com cointegração de todos os paineis
xtcointtest westerlund lnepc $westerlundlistCAK, allpanels
xtcointtest westerlund lnepc $westerlundlistCAK, allpanels trend
** O Limite de variáveis para o teste de Westerlund (2005) é de 7, o medelo é composto por 8, incluindo
// a varivável cubica econômica

**obs. TESTE DE WESTERLUND (2007)
*Baseado no trabalho de Persyn e Westerlund (2008) do The Stata Journal, com o comando
// xtwest.
global westlistCAK lnpibpc lnpibpc2 lnpibpc3
xtwest lnepc $westlistCAK, lags(1) lrwindow(3) constant bootstrap(400)
xtwest lnepc $westlistCAK, lags(1) lrwindow(3) constant bootstrap(400) trend

** Obs: lrwindow é calculado a partir da seguinte equação 4(T/100)^2/9, no caso da dissertação
// 4(25/100)^2/9 = 2,93 aproximadamente 3.

** O Limite de variáveis para o teste de Westerlund (2007) é de 6, o medelo é composto por 8, incluindo
// a varivável cubica econômica e a população urbana
log close

log using "C:\Users\alex_\Dropbox\Dissertação\ARTIGO\Modelo novo\MODELO COM A SOMA DA CONSTANTE APENAS NAS VARIÁVEIS QUE O LOG VIRA MISSING\Testes de Cointegração CAK - PRIMEIRA DIFERENÇA.log", text replace
*** VARIÁVEIS COM PRIMEIRA DIFERANÇA

** Para os testes de cointegração será utilziado o pacote de xtconittest do STATA 15, 
*para estimar os resultados. Primeiro será realizado o teste de PEDRONI (1999, 2004), Kao (1999),
*e Westernund (2005).

// TESTE DE PEDRONI (1999, 2004)
global pedronilistCAKD lnpibpcd lnpibpc2d lnpibpc3d 
* Pedroni com parametro AR específico de paniel
xtcointtest pedroni lnepcd $pedronilistCAKD, ar(panelspecific) lags(aic )
xtcointtest pedroni lnepcd $pedronilistCAKD, ar(panelspecific) lags(aic ) trend

* Pedroni com parametro AR comum do paniel
xtcointtest pedroni lnepcd $pedronilistCAKD, ar(same) lags(aic )
xtcointtest pedroni lnepcd $pedronilistCAKD, ar(same) lags(aic ) trend

** O Limite de variáveis para o teste de Pedroni é de 7, o medelo é composto por 8, incluindo
// a varivável cubica econômica

// TESTE DE KAO (1999)
global kaolistCAKD lnpibpcd lnpibpc2d lnpibpc3d 
xtcointtest kao lnepcd $kaolistCAKD, lags(aic )

// TESTE DE WESTERLUND (2005)
global westerlundlistCAKD lnpibpcd lnpibpc2d lnpibpc3d
** Westerlund com cointegração de alguns paineis
xtcointtest westerlund lnepcd $westerlundlistCAKD, somepanels
xtcointtest westerlund lnepcd $westerlundlistCAKD, somepanels trend

** Westerlund com cointegração de todos os paineis
xtcointtest westerlund lnepcd $westerlundlistCAKD, allpanels
xtcointtest westerlund lnepcd $westerlundlistCAKD, allpanels trend
** O Limite de variáveis para o teste de Westerlund (2005) é de 7, o medelo é composto por 8, incluindo
// a varivável cubica econômica

**obs. TESTE DE WESTERLUND (2007)
*Baseado no trabalho de Persyn e Westerlund (2008) do The Stata Journal, com o comando
// xtwest.
global westlistCAKD lnpibpcd lnpibpc2d lnpibpc3d
xtwest lnepcd $westlistCAKD, lags(1) lrwindow(3) constant bootstrap(400)
xtwest lnepcd $westlistCAKD, lags(1) lrwindow(3) constant bootstrap(400) trend

** Obs: lrwindow é calculado a partir da seguinte equação 4(T/100)^2/9, no caso da dissertação
// 4(25/100)^2/9 = 2,93 aproximadamente 3.

** O Limite de variáveis para o teste de Westerlund (2007) é de 6, o medelo é composto por 8, incluindo
// a varivável cubica econômica e a população urbana
log close



log using "C:\Users\alex_\Dropbox\Dissertação\ARTIGO\Modelo novo\MODELO COM A SOMA DA CONSTANTE APENAS NAS VARIÁVEIS QUE O LOG VIRA MISSING\ESTIMAÇÕES.log", text replace
**** ESTIMAÇÃO DA RELAÇÃO DE LONGO PRAZO PARA O MODELO 

** Baixando os pacotes de FMOLS
net from http://www.stata-journal.com/software/sj12-3/
* Escolher o pacote para instalar st0272 

net from http://fmwww.bc.edu/RePEc/bocode/x
* Escolher o pacote para instalar xtcointreg

** ESTIMAÇÃO DE PAINEL FMOLS ANTES DA DEFESA
//POPULAÇÃO TOTAL
xtcointreg lnepcd lnpibpcd lnpibpc2d lnpibpc3d lnvabitpcd lncomintpcd lneletripcd lnpopunid, est (fmols) vic(aic) vlag (1) kernel (bartlett) bmeth(nwfixed) xtrend(1) 
test (lnpibpcd=0) (lnpibpc2d=0) (lnpibpc3d=0) (lnvabitpcd=0) (lncomintpcd=0) (lneletripcd=0) (lnpopunid=0) /// Test linear hypotheses after estimation 

// POPULAÇÃO URBANA
xtcointreg lnepcd lnpibpcd lnpibpc2d lnpibpc3d lnvabitpcd lncomintpcd lneletripcd lnurbunid, est (fmols) vic(aic) vlag (1) kernel (bartlett) bmeth(nwfixed) xtrend(1) 
test (lnpibpcd=0) (lnpibpc2d=0) (lnpibpc3d=0) (lnvabitpcd=0) (lncomintpcd=0) (lneletripcd=0) (lnurbunid=0) /// Test linear hypotheses after estimation 

** ESTIMAÇÃO DE PAINEL FMOLS DEPOIS DA DEFESA - INCLUSÃO DA VARIÁVEL DE VAB DA AGRICULTURA E MUDANÇA DO USO DA TERRA E VAB DE ENERGIA
//POPULAÇÃO TOTAL - VAB INDUSTRIA - VAB AGRICULTURA
xtcointreg lnepcd lnpibpcd lnpibpc2d lnpibpc3d lnvabitpcd lnaebdefpcd  lncomintpcd lneletripcd lnpopunid, est (fmols) vic(aic) vlag (1) kernel (bartlett) bmeth(nwfixed) xtrend(1) 
test (lnpibpcd=0) (lnpibpc2d=0) (lnpibpc3d=0) (lnvabitpcd=0) (lnaebdefpcd=0) (lncomintpcd=0) (lneletripcd=0) (lnpopunid=0) /// Test linear hypotheses after estimation 

//POPULAÇÃO TOTAL - VAB INDUSTRIA - VAB ENERGIA
xtcointreg lnepcd lnpibpcd lnpibpc2d lnpibpc3d lnvabitpcd lnedefpcd lncomintpcd lneletripcd lnpopunid, est (fmols) vic(aic) vlag (1) kernel (bartlett) bmeth(nwfixed) xtrend(1) 
test (lnpibpcd=0) (lnpibpc2d=0) (lnpibpc3d=0) (lnvabitpcd=0) (lnedefpcd=0) (lncomintpcd=0) (lneletripcd=0) (lnpopunid=0) /// Test linear hypotheses after estimation 

//POPULAÇÃO TOTAL - VAB AGRICULTURA
xtcointreg lnepcd lnpibpcd lnpibpc2d lnpibpc3d lnaebdefpcd  lncomintpcd lneletripcd lnpopunid, est (fmols) vic(aic) vlag (1) kernel (bartlett) bmeth(nwfixed) xtrend(1) 
test (lnpibpcd=0) (lnpibpc2d=0) (lnpibpc3d=0) (lnaebdefpcd=0) (lncomintpcd=0) (lneletripcd=0) (lnpopunid=0) /// Test linear hypotheses after estimation 

//POPULAÇÃO TOTAL - VAB ENERGIA
xtcointreg lnepcd lnpibpcd lnpibpc2d lnpibpc3d lnedefpcd lncomintpcd lneletripcd lnpopunid, est (fmols) vic(aic) vlag (1) kernel (bartlett) bmeth(nwfixed) xtrend(1) 
test (lnpibpcd=0) (lnpibpc2d=0) (lnpibpc3d=0) (lnedefpcd=0) (lncomintpcd=0) (lneletripcd=0) (lnpopunid=0) /// Test linear hypotheses after estimation 

//POPULAÇÃO TOTAL - VAB INDUSTRIA - VAB AGRICULTURA - VAB ENERGIA
xtcointreg lnepcd lnpibpcd lnpibpc2d lnpibpc3d lnvabitpcd lnaebdefpcd  lnedefpcd lncomintpcd lneletripcd lnpopunid, est (fmols) vic(aic) vlag (1) kernel (bartlett) bmeth(nwfixed) xtrend(1) 
test (lnpibpcd=0) (lnpibpc2d=0) (lnpibpc3d=0) (lnvabitpcd=0) (lnaebdefpcd=0) (lnedefpcd=0) (lncomintpcd=0) (lneletripcd=0) (lnpopunid=0) /// Test linear hypotheses after estimation 

//POPULAÇÃO TOTAL - VAB AGRICULTURA - VAB ENERGIA
xtcointreg lnepcd lnpibpcd lnpibpc2d lnpibpc3d lnaebdefpcd lnedefpcd lncomintpcd lneletripcd lnpopunid, est (fmols) vic(aic) vlag (1) kernel (bartlett) bmeth(nwfixed) xtrend(1) 
test (lnpibpcd=0) (lnpibpc2d=0) (lnpibpc3d=0) (lnaebdefpcd=0) (lnedefpcd=0) (lncomintpcd=0) (lneletripcd=0) (lnpopunid=0) /// Test linear hypotheses after estimation 

//POPULAÇÃO URBANA - VAB INDUSTRIA - VAB AGRICULTURA
xtcointreg lnepcd lnpibpcd lnpibpc2d lnpibpc3d lnvabitpcd lnaebdefpcd  lncomintpcd lneletripcd lnurbunid, est (fmols) vic(aic) vlag (1) kernel (bartlett) bmeth(nwfixed) xtrend(1) 
test (lnpibpcd=0) (lnpibpc2d=0) (lnpibpc3d=0) (lnvabitpcd=0) (lnaebdefpcd=0) (lncomintpcd=0) (lneletripcd=0) (lnurbunid=0) /// Test linear hypotheses after estimation 

//POPULAÇÃO URBANA - VAB INDUSTRIA - VAB ENERGIA
xtcointreg lnepcd lnpibpcd lnpibpc2d lnpibpc3d lnvabitpcd lnedefpcd lncomintpcd lneletripcd lnurbunid, est (fmols) vic(aic) vlag (1) kernel (bartlett) bmeth(nwfixed) xtrend(1) 
test (lnpibpcd=0) (lnpibpc2d=0) (lnpibpc3d=0) (lnvabitpcd=0) (lnedefpcd=0) (lncomintpcd=0) (lneletripcd=0) (lnurbunid=0) /// Test linear hypotheses after estimation 

//POPULAÇÃO URBANA - VAB AGRICULTURA
xtcointreg lnepcd lnpibpcd lnpibpc2d lnpibpc3d lnaebdefpcd  lncomintpcd lneletripcd lnurbunid, est (fmols) vic(aic) vlag (1) kernel (bartlett) bmeth(nwfixed) xtrend(1) 
test (lnpibpcd=0) (lnpibpc2d=0) (lnpibpc3d=0) (lnaebdefpcd=0) (lncomintpcd=0) (lneletripcd=0) (lnurbunid=0) /// Test linear hypotheses after estimation 

//POPULAÇÃO URBANA - VAB ENERGIA
xtcointreg lnepcd lnpibpcd lnpibpc2d lnpibpc3d lnedefpcd lncomintpcd lneletripcd lnurbunid, est (fmols) vic(aic) vlag (1) kernel (bartlett) bmeth(nwfixed) xtrend(1) 
test (lnpibpcd=0) (lnpibpc2d=0) (lnpibpc3d=0) (lnedefpcd=0) (lncomintpcd=0) (lneletripcd=0) (lnurbunid=0) /// Test linear hypotheses after estimation 

//POPULAÇÃO URBANA - VAB INDUSTRIA - VAB AGRICULTURA - VAB ENERGIA
xtcointreg lnepcd lnpibpcd lnpibpc2d lnpibpc3d lnvabitpcd lnaebdefpcd  lnedefpcd lncomintpcd lneletripcd lnurbunid, est (fmols) vic(aic) vlag (1) kernel (bartlett) bmeth(nwfixed) xtrend(1) 
test (lnpibpcd=0) (lnpibpc2d=0) (lnpibpc3d=0) (lnvabitpcd=0) (lnaebdefpcd=0) (lnedefpcd=0) (lncomintpcd=0) (lneletripcd=0) (lnurbunid=0) /// Test linear hypotheses after estimation 

//POPULAÇÃO URBANA- VAB AGRICULTURA - VAB ENERGIA
xtcointreg lnepcd lnpibpcd lnpibpc2d lnpibpc3d lnaebdefpcd lnedefpcd lncomintpcd lneletripcd lnurbunid, est (fmols) vic(aic) vlag (1) kernel (bartlett) bmeth(nwfixed) xtrend(1) 
test (lnpibpcd=0) (lnpibpc2d=0) (lnpibpc3d=0) (lnaebdefpcd=0) (lnedefpcd=0) (lncomintpcd=0) (lneletripcd=0) (lnurbunid=0) /// Test linear hypotheses after estimation 


* ESTIMAÇÃO PAINEL FMOLS DA CAK  PADRÃO ANTES DA BANCA
// CAK QUADRÁTICA
global fmolsCAKquadri lnpibpcd lnpibpc2d 
xtcointreg lnepcd $fmolsCAKquadri, est (fmols) vic(aic) vlag(1) kernel (bartlett) bmeth(nwfixed) xtrend(1)
test (lnpibpcd=0) (lnpibpc2d=0)  /// Test linear hypotheses after estimation

// CAK CÚBICA
global fmolsCAKcub lnpibpcd lnpibpc2d lnpibpc3d
xtcointreg lnepcd $fmolsCAKcub, est (fmols) vic(aic) vlag(1) kernel (bartlett) bmeth(nwfixed) xtrend(1)
test (lnpibpcd=0) (lnpibpc2d=0) (lnpibpc3d=0) /// Test linear hypotheses after estimation


** ESTIMAÇÃO DE PAINEL DOLS 
** DOLS proposto por Pedroni (2001) - COMANDO "XTPEDRONI"
* net from http://www.stata-journal.com/software/sj14-3
* Escolher st0356
*ssc install xtpedroni
*xtpedroni lnepcd lnpibpcd lnpibpc2d lncomintpcd lnvabitpcd, notest  // MÉDIA DO PAINEL
*xtpedroni lnepcd lnpibpcd lnpibpc2d lnpopunid, notest full  // RESULTADO PARA CADA CROSS-SECTION
*global dolsCAK lnpibpcd lnpibpc2d lnpibpc3d
*xtpedroni lnepcd $dolsCAK, notest // MÉDIA DO PAINEL
*xtpedroni lnepcd $dolsCAK, notest full // RESULTADO PARA CADA CROSS-SECTION

** DOLS proposto por Kao e Chiang (2002) - COMANDO "XTDOLSHM"
ssc install xtdolshm
ssc install ltimbimata, replace

** ESTIMAÇÃO DE PAINEL DOLS ANTES DA BANCA
//POPULAÇÃO TOTAL
global dolslistpop lnpibpcd lnpibpc2d lnpibpc3d lnvabitpcd lncomintpcd lneletripcd lnpopunid 
xtdolshm lnepcd $dolslistpop
test (lnpibpcd=0) (lnpibpc2d=0) (lnpibpc3d=0) (lnvabitpcd=0) (lncomintpcd=0) (lneletripcd=0) (lnpopunid=0) 

//POPULAÇÃO URBANA
global dolslisturb lnpibpcd lnpibpc2d lnpibpc3d lnvabitpcd lncomintpcd lneletripcd lnurbunid
xtdolshm lnepcd $dolslisturb
test (lnpibpcd=0) (lnpibpc2d=0) (lnpibpc3d=0) (lnvabitpcd=0) (lncomintpcd=0) (lneletripcd=0) (lnurbunid=0)

** ESTIMAÇÃO DE PAINEL DOLS DEPOIS DA DEFESA - INCLUSÃO DA VARIÁVEL DE VAB DA AGRICULTURA E MUDANÇA DO USO DA TERRA E VAB DE ENERGIA
//POPULAÇÃO TOTAL - VAB INDUSTRIA - VAB AGRICULTURA
global dolslistpop1 lnpibpcd lnpibpc2d lnpibpc3d lnvabitpcd lnaebdefpcd lncomintpcd lneletripcd lnpopunid 
xtdolshm lnepcd $dolslistpop1
test (lnpibpcd=0) (lnpibpc2d=0) (lnpibpc3d=0) (lnvabitpcd=0) (lnaebdefpcd=0) (lncomintpcd=0) (lneletripcd=0) (lnpopunid=0) 

//POPULAÇÃO TOTAL - VAB INDUSTRIA - VAB ENERGIA
global dolslistpop2 lnpibpcd lnpibpc2d lnpibpc3d lnvabitpcd lnedefpcd lncomintpcd lneletripcd lnpopunid 
xtdolshm lnepcd $dolslistpop2
test (lnpibpcd=0) (lnpibpc2d=0) (lnpibpc3d=0) (lnvabitpcd=0) (lnedefpcd=0) (lncomintpcd=0) (lneletripcd=0) (lnpopunid=0) 

//POPULAÇÃO TOTAL - VAB AGRICULTURA
global dolslistpop3 lnpibpcd lnpibpc2d lnpibpc3d lnaebdefpcd lncomintpcd lneletripcd lnpopunid 
xtdolshm lnepcd $dolslistpop3
test (lnpibpcd=0) (lnpibpc2d=0) (lnpibpc3d=0) (lnaebdefpcd=0) (lncomintpcd=0) (lneletripcd=0) (lnpopunid=0) 

//POPULAÇÃO TOTAL - VAB ENERGIA
global dolslistpop4 lnpibpcd lnpibpc2d lnpibpc3d lnedefpcd lncomintpcd lneletripcd lnpopunid 
xtdolshm lnepcd $dolslistpop4
test (lnpibpcd=0) (lnpibpc2d=0) (lnpibpc3d=0) (lnedefpcd=0) (lncomintpcd=0) (lneletripcd=0) (lnpopunid=0) 

//POPULAÇÃO TOTAL - VAB INDUSTRIA - VAB AGRICULTURA - VAB ENERGIA
global dolslistpop5 lnpibpcd lnpibpc2d lnpibpc3d lnvabitpcd lnaebdefpcd lnedefpcd lncomintpcd lneletripcd lnpopunid 
xtdolshm lnepcd $dolslistpop5
test (lnpibpcd=0) (lnpibpc2d=0) (lnpibpc3d=0) (lnvabitpcd=0) (lnaebdefpcd=0) (lnedefpcd=0) (lncomintpcd=0) (lneletripcd=0) (lnpopunid=0) 

//POPULAÇÃO TOTAL - VAB AGRICULTURA - VAB ENERGIA
global dolslistpop6 lnpibpcd lnpibpc2d lnpibpc3d lnaebdefpcd lnedefpcd lncomintpcd lneletripcd lnpopunid 
xtdolshm lnepcd $dolslistpop6
test (lnpibpcd=0) (lnpibpc2d=0) (lnpibpc3d=0) (lnaebdefpcd=0) (lnedefpcd=0) (lncomintpcd=0) (lneletripcd=0) (lnpopunid=0) 

//POPULAÇÃO URBANA - VAB INDUSTRIA - VAB AGRICULTURA
global dolslisturb1 lnpibpcd lnpibpc2d lnpibpc3d lnvabitpcd lnaebdefpcd lncomintpcd lneletripcd lnurbunid
xtdolshm lnepcd $dolslisturb1
test (lnpibpcd=0) (lnpibpc2d=0) (lnpibpc3d=0) (lnvabitpcd=0) (lnaebdefpcd=0) (lncomintpcd=0) (lneletripcd=0) (lnurbunid=0)

//POPULAÇÃO URBANA - VAB INDUSTRIA - VAB ENERGIA
global dolslisturb2 lnpibpcd lnpibpc2d lnpibpc3d lnvabitpcd lnedefpcd lncomintpcd lneletripcd lnurbunid
xtdolshm lnepcd $dolslisturb2
test (lnpibpcd=0) (lnpibpc2d=0) (lnpibpc3d=0) (lnvabitpcd=0) (lnedefpcd=0) (lnedefpcd=0) (lncomintpcd=0) (lneletripcd=0) (lnurbunid=0)

//POPULAÇÃO URBANA - VAB AGRICULTURA
global dolslisturb3 lnpibpcd lnpibpc2d lnpibpc3d lnaebdefpcd lncomintpcd lneletripcd lnurbunid
xtdolshm lnepcd $dolslisturb3
test (lnpibpcd=0) (lnpibpc2d=0) (lnpibpc3d=0) (lnaebdefpcd=0) (lncomintpcd=0) (lneletripcd=0) (lnurbunid=0)

//POPULAÇÃO URBANA - VAB ENERGIA
global dolslisturb4 lnpibpcd lnpibpc2d lnpibpc3d lnedefpcd lncomintpcd lneletripcd lnurbunid
xtdolshm lnepcd $dolslisturb4
test (lnpibpcd=0) (lnpibpc2d=0) (lnpibpc3d=0) (lnedefpcd=0) (lncomintpcd=0) (lneletripcd=0) (lnurbunid=0)

//POPULAÇÃO URBANA - VAB INDUSTRIA - VAB AGRICULTURA - VAB ENERGIA
global dolslisturb5 lnpibpcd lnpibpc2d lnpibpc3d lnvabitpcd lnaebdefpcd lnedefpcd lncomintpcd lneletripcd lnurbunid
xtdolshm lnepcd $dolslisturb5
test (lnpibpcd=0) (lnpibpc2d=0) (lnpibpc3d=0) (lnvabitpcd=0) (lnaebdefpcd=0) (lnedefpcd=0) (lncomintpcd=0) (lneletripcd=0) (lnurbunid=0)

//POPULAÇÃO URBANA- VAB AGRICULTURA - VAB ENERGIA
global dolslisturb6 lnpibpcd lnpibpc2d lnpibpc3d lnaebdefpcd lnedefpcd lncomintpcd lneletripcd lnurbunid
xtdolshm lnepcd $dolslisturb6
test (lnpibpcd=0) (lnpibpc2d=0) (lnpibpc3d=0) (lnaebdefpcd=0) (lnedefpcd=0) (lncomintpcd=0) (lneletripcd=0) (lnurbunid=0)


* ESTIMAÇÃO PAINEL DOLS PARA CAK PADRÃO ANTES DA BANCA
//CAK QUADRÁTICA
global dolsCAKquadri lnpibpcd lnpibpc2d
xtdolshm lnepcd $dolsCAKquadri
test (lnpibpcd=0) (lnpibpc2d=0) 

// CAK CÚBICA
global dolsCAKcub lnpibpcd lnpibpc2d lnpibpc3d
xtdolshm lnepcd $dolsCAKcub
test (lnpibpcd=0) (lnpibpc2d=0) (lnpibpc3d=0) 


** ESTIMAÇÃO CCEMG - Common Correlated Effects Mean Group (Presença de dependência) - APENAS A CAK PADRÃO PODE SER ESTIMADA NESTE MODELO
ssc install xtmg
global ccemglist lnpibpcd lnpibpc2d lnpibpc3d
xtmg lnepcd $ccemglist, cce res(r_cmg)
xtmg lnepcd $ccemglist, cce trend res(r_cmg1)
xtmg lnepcd $ccemglist, cce full res(r_cmg2)
xtmg lnepcd $ccemglist, cce trend full res(r_cmg3)

log close
