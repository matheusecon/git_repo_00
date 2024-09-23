* DROPAGEM DA RENDA PER CAPTA NÃO INFORMADA E DA QUE NÃO FAZ SENTIDO
drop if rendPerCapta > 5000000
drop if rendPerCapta == 999999999999

 ** total dos anos de estudo ***
 recode TempoEstudo (1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6) (8=7) (9=8) (10=9) (11=10) (12=11) (13=12) (14=13) (15=14) (16=15)
 drop if TempoEstudo ==17
 
 gen numtotalfilho  == NFilhosM + NFilhosF

**cRIANDO A VARÁVEL DEPENDENTE**
**CRIANDO VARIÁVEL DESEMPREGO**

recode EconAtiva (1=0) (2=1)
recode Desempreg (1=0) (2=1)
 
 