*******************************************
*********GERAÇÃO DE DUMMIES****************
*******************************************

******ESCOLARIDADE

gen AnosEst=Escol-1
gen E1=AnosEst
gen E2=AnosEst
gen E3=AnosEst
gen E4=AnosEst

replace E1=0 if AnosEst>4
replace E1=1 if AnosEst>0 & AnosEst<=4

replace E2=0 if AnosEst<5
replace E2=0 if AnosEst>8
replace E2=1 if AnosEst>=5 & AnosEst<=8


replace E3=0 if AnosEst<9
replace E3=0 if AnosEst>11
replace E3=1 if AnosEst>=9 & AnosEst<=11


replace E4=0 if AnosEst<=11
replace E4=0 if AnosEst==16
replace E4=1 if AnosEst>11

******POSIÇÃO NO DOMÍCILIO

gen CD1=CondDom
gen CD2=CondDom
gen CD3=CondDom


replace CD1=0 if CondDom==1
replace CD1=0 if CondDom>=3
replace CD1=1 if CondDom==2

replace CD2=0 if CondDom<=2
replace CD2=0 if CondDom>3
replace CD2=1 if CondDom==3

replace CD3=0 if CondDom<=3
replace CD3=1 if CondDom>3

******COR

gen R1=Cor
gen R2=Cor

replace R1=0 if Cor==2
replace R1=0 if Cor>=6
replace R1=1 if Cor==4

replace R2=0 if Cor<8
replace R2=0 if Cor==9
replace R2=1 if Cor==8



******LOCALIZAÇÃO DO DOMICÍLIO I

gen URB=CodSC

replace URB=1 if CodSC<=3
replace URB=0 if CodSC>3

******LOCALIZAÇÃO DO DOMICÍLIO II

gen Metropole=RM

replace Metropole=1 if RM==1
replace Metropole=0 if RM>=2

******REGIÕES BRASILEIRAS
gen Reg1=UF
gen Reg2=UF
gen Reg3=UF
gen Reg4=UF

replace Reg1=0 if UF<=29
replace Reg1=0 if UF>=41
replace Reg1=1 if UF>=31 & UF<=35

replace Reg2=0 if UF<=35
replace Reg2=0 if UF>=50
replace Reg2=1 if UF>=41 & UF<=43

replace Reg3=0 if UF<=43
replace Reg3=1 if UF>=50

replace Reg4=0 if UF>=21
replace Reg4=1 if UF<=17

********FILHOS PEQUENOS 
gen Filho=Filhopeq

replace Filho=0 if Filhopeq==1
replace Filho=1 if Filhopeq==2
replace Filho=0 if Filhopeq==3
replace Filho=1 if Filhopeq==4
replace Filho=0 if Filhopeq==5
replace Filho=1 if Filhopeq==6
replace Filho=0 if Filhopeq==7
replace Filho=1 if Filhopeq==8
replace Filho=0 if Filhopeq==9
replace Filho=0 if Filhopeq==10


******POSIÇÃO NA OCUPAÇÃO
gen Poc1=PosOcup
gen Poc2=PosOcup
gen Poc3=PosOcup
gen Poc4=PosOcup
gen Poc5=PosOcup
gen Poc6=PosOcup
gen Poc7=PosOcup

replace Poc1=1 if PosOcup==4
replace Poc1=0 if PosOcup<4
replace Poc1=0 if PosOcup>4

replace Poc2=0 if PosOcup==1
replace Poc2=1 if PosOcup>=2 & PosOcup<=3
replace Poc2=0 if PosOcup>3

replace Poc3=1 if PosOcup==6 
replace Poc3=0 if PosOcup<6
replace Poc3=0 if PosOcup>6

replace Poc4=1 if PosOcup==7 
replace Poc4=0 if PosOcup<7
replace Poc4=0 if PosOcup>7

replace Poc5=1 if PosOcup==9
replace Poc5=0 if PosOcup<9
replace Poc5=0 if PosOcup>9

replace Poc6=1 if PosOcup==10
replace Poc6=0 if PosOcup<10
replace Poc6=0 if PosOcup>10

replace Poc7=1 if PosOcup>=11
replace Poc7=0 if PosOcup<11

 

*************SETORES DE ATIVIDADE
gen S1=Setor
gen S2=Setor
gen S3=Setor
gen S4=Setor

replace S1=1 if Setor==1
replace S1=0 if Setor>=2

replace S2=1 if Setor==4
replace S2=0 if Setor<4
replace S2=0 if Setor>4

replace S3=1 if Setor==5
replace S3=0 if Setor<5
replace S3=0 if Setor>5

replace S4=1 if Setor>=6
replace S4=0 if Setor<6


**************GRUPOS OCUPACIONAIS
gen GOcup1=GrOcT
gen GOcup2=GrOcT
gen GOcup3=GrOcT


replace GOcup1=1 if GrOcT==1
replace GOcup1=0 if GrOcT>=2

replace GOcup2=1 if GrOcT==2
replace GOcup2=0 if GrOcT>2
replace GOcup2=0 if GrOcT<2


replace GOcup3=1 if GrOcT==3
replace GOcup3=0 if GrOcT<3
replace GOcup3=0 if GrOcT>3

****************GERANDO Outra DUMMY PARA A EQUAÇÃO DE SELEÇÃO
gen L1=Atividade
replace L1=1 if Atividade==1
replace L1=1 if Ocupac==1
replace L1=0 if Ocupac==1 & VRTP==0
replace L1=0 if Ocupac==2 
replace L1=0 if Atividade==2 

****************GERANDO DUMMIES DE SEXO
gen Masc=Sexo
replace Masc=1 if Sexo==2
replace Masc=0 if Sexo==4

gen Fem=Sexo
replace Fem=1 if Sexo==4
replace Fem=0 if Sexo==2


**********GERANDO VARIÁVEL DE RENDIMENTO
gen W=VRTP/(horastp*4.2)
gen w=ln(W)
drop if VRTP > 5000000 & VRTP!=.
drop if rendompercapita > 5000000 & rendompercapita!=.

*********GERANDO IDADE AO QUADRADO
gen Idade2 = Idade^2 


****************ANÁLISE DESCRITIVA
******Brasil
*Homens

svy, subpop(Masc if L1==1 & Idade>=16 & Idade<=65 ) vce(linearized): mean W
svy, subpop(if Masc==1 & Idade>=16 & Idade<=65)vce(linearized): proportion AnosEst


***************PROGRAMA PARA CÁLCULO DE MÉDIAS

******MERCADO DE TRABALHO DO BRASIL
****ESTIMADOR DE MÉDIA POR SEXO
******
*Escolaridade
svy, subpop(if Idade>=16 & Idade<=65 & AnosEst<16 & Ocupac==1) vce(linearized): mean AnosEst, over (Sexo)
lincom [AnosEst]2-[AnosEst]4

*Idade
svy, subpop(if Idade>=16 & Idade<=65 & Ocupac==1) vce(linearized): mean Idade, over (Sexo)
lincom [Idade]2-[Idade]4

*Horas Trabalho Principal
svy, subpop(if Idade>=16 & Idade<=65 & horastp<99 & Ocupac==1) vce(linearized): mean horastp, over (Sexo)
lincom [horastp]2-[horastp]4

*Rendimento Trabalho Principal
svy, subpop(if Idade>=16 & Idade<=65 & VRTP>0 & Ocupac==1) vce(linearized): mean VRTP, over (Sexo)
lincom [VRTP]2-[VRTP]4

*Rendimento Trabalho Principal/Hora
svy, subpop(if Idade>=16 & Idade<=65 & VRTP>0 & horastp<99 & Ocupac==1) vce(linearized): mean W, over (Sexo)
lincom [W]2-[W]4


*******************************************************
****************************MODELOS DE SELEÇÃO AMOSTRAL
*******************************************************

************BRASIL

****HOMENS
svy, subpop(if Masc==1 & Idade>=16 & Idade<=65)vce(linearized): heckman w E1 E2 E3 E4 Idade Idade2 R1 R2 URB Metropole Reg1 Reg2 Reg3 Reg4  Poc1 Poc2 Poc3 Poc4 Poc5 Poc6 S1 S2 S3 S4 GOcup1 GOcup2 GOcup3, select(L1 = rendompercapita E1 E2 E3 E4 Idade Idade2  CD1 CD2 CD3 Filho R1 R2  URB Metropole Reg1 Reg2 Reg3 Reg4)
mfx compute, dydx at(mean)
mfx compute, predict(psel) dydx at(mean)
estat effects, meff 


****MULHERES
svy, subpop(if Fem==1 & Idade>=16 & Idade<=65)vce(linearized): heckman w E1 E2 E3 E4 Idade Idade2 R1 R2 URB Metropole Reg1 Reg2 Reg3 Reg4  Poc1 Poc2 Poc3 Poc4 Poc5 Poc6 S1 S2 S3 S4 GOcup1 GOcup2 GOcup3, select(L1 = rendompercapita E1 E2 E3 E4 Idade Idade2  CD1 CD2 CD3 Filho R1 R2  URB Metropole Reg1 Reg2 Reg3 Reg4)
mfx compute, dydx at(mean)
mfx compute, predict(psel) dydx at(mean)
estat effects, meff 





