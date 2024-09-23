################################################################################
###                                                                          ### 
###                          VARIÁVEIS DUMMY NO r                            ###
###                             econometria 1                                ###
###                            MATHEUS RIBEIRO                               ###
###                                                                          ###    
################################################################################
################################################################################
##////////////////////////////////////////////////////////////////////////////##
################################################################################
################################################################################

install_packages <- function(pkg) { 
  
  # Install package if it is not already
  if (!(pkg %in% installed.packages()[, "Package"])){ 
    
    install.packages(pkg, repos='http://cran.us.r-project.org')
  }
  
  library(pkg, character.only = TRUE)
  
} # end installPackages()

pkg_list = c("tidyverse", "modelr", "carData", "car")
lapply(pkg_list, install_packages)



# remover objetos
rm("") ## remove objetos específicos: colocar objeto em parenteses
rm(list= ls()) ## remove todos os objetos
rm(list=ls(pattern="^model")) #remove objetos que começam com o padrão model

#carregar a base de dados
### Mudar o diretório para onde a base esta localizada
setwd("C:/Users/ribei/OneDrive/PDM/Papers/economia internacional/base de dados")

# IMPORTAR BANCO DE DADOS
df <- Salaries

# Ver seis primeiras linhas
head(df)

# Ver as variáveis disponíveis
colnames(df)
# Ver o número de observações
nrow(df)
#**# No total, são 397 observações e 6 variáveis (n = 367, p = 6).

# VARIÁVEIS QUALITATIVAS
rank_sum <- summary(df$rank)
discpl_sum <- summary(df$discipline)
sex_sum <- summary(df$sex)

rank_sum
#**# A maioria das observações registradas vem de Professores (n = 266) com cerca do mesmo 
#* número de pontos de dados de Professores Assistentes (n = 67) e Professores Associados (n = 64).
discpl_sum
#**# Menos membros do corpo docente no conjunto de dados trabalham em departamentos "Teóricos" (A) em 
#* comparação com os departamentos "Aplicados" (B).
sex_sum
#**# A maioria do corpo docente é do sexo masculino (n = 358) em comparação com os membros do corpo docente 
#* do sexo feminino (n = 39).

# VARIÁVEIS QUANTITATIVAS
salary_hist <- ggplot() +
  geom_histogram(aes(x = df$salary), color = "black", fill = "blue", bins = 50) +
  labs(x = "Nine-Month Salary (in dollars)", y = "Count", 
       title = "Nine-Month Salary Distribution")

salary_hist
summary(df$salary)
#**# A distribuição para a variável salario parece estar distorcida. 

yrs.since.phd_hist <- ggplot() +
  geom_histogram(aes(x = df$yrs.since.phd), color = "black", fill = "green", bins = 50) +
  labs(x = "Years since Ph.D.", y = "Count", 
       title = "Years since Ph.D. Distribution")

yrs.since.phd_hist
summary(df$yrs.since.phd)
#**# Os anos desde a obtenção de doutorado parecem assumir uma 
#* distribuição relativamente normal, talvez mostrando leve assimetria para a direita.

yrs.service_hist <- ggplot() +
  geom_histogram(aes(x = df$yrs.service), color = "black", fill = "orange", bins = 50) +
  labs(x = "Years of Service", y = "Count", 
       title = "Years of Service Distribution")

yrs.service_hist
summary(df$yrs.service)
#**# A distribuição de anos de serviço parece estar ligeiramente distorcida, 
#* semelhante à distribuição de anos desde o doutorado.

# TRATAMENTO DOS DADOS
#Excluindo variáveis ilógicas
exclude_service <- nrow(filter(df, yrs.service < 1))  
exclude_service
#**# 11 pessoas têm menos de 1 ano de serviço por que elas acabaram de começar a trabalhar 
#* na Universidade quando esses dados foram coletados, porém, como apenas 11 pessoas seriam
#* removidas da analise não se espera que elas afetem em demasia os resultados

# ANÁLISES GRÁFICAS
phd_discipl_rank <-  ggplot() + 
  geom_point(aes(x = df$yrs.since.phd, y = df$salary, color = df$rank)) +
  labs(x = "Years since Ph.D.", y = "Salary (in Dollars)",
       title = "Salary vs. Years since Ph.D.")

phd_discipl_rank

# REGRESSÕES
#Regressões univariadas

mod_rank_slr <- lm(salary~rank, data = df)
summary(mod_rank_slr)
#**# Professores e Professores Associados tendem a ser mais experientes do que 
#* professores assistentes e, portanto, pagam mais de acordo com seus 
#*cargos de docente. O grupo de base neste caso é professor assistente. Enquanto professores 
#*assistentes nesta faculdade têm um salário médio de nove meses de US $ 80.776, professores 
#*associados ganham um adicional de US $ 13.100 em comparação com professores assistentes. 
#*Da mesma forma, os professores ganham um adicional de US $ 45.996 em comparação com o 
#*salário de professores assistentes. O valor da variação salarial explicado 
#*por classificação neste modelo é de cerca de 39% (R2 ajustado).

mod_sex_slr <- lm(salary~sex, data =df)
summary(mod_sex_slr)
#**# Embora o coeficiente para o sexo preditor seja considerado significativo no modelo, 
#* o sexo só explica cerca de 2% da variação salarial neste modelo. As professoras nesta 
#* faculdade ganham um salário médio de US$ 101.002, enquanto os professores do sexo masculino
#* ganham mais US$ 14.088 em cima disso.

mod_discpl_slr <- lm(salary~discipline, data = df)
summary(mod_discpl_slr)
#**# O coeficiente de disciplina é considerado significativo, mas só explica cerca de 2% da
#* variação salarial. O grupo de base é teóricos (A) ganham em média US$ 108.548, enquanto 
#* os aplicados (B) ganham um adicional de US$ 9.480 além do dos membros em departamentos teóricos.

# Regressões multivariadas
full_mod <- lm(salary~., data = df)
summary(full_mod)
#**# Sexo passa a não ser significativo (com um valor p de ~0,22). O efeito de anos de serviço não é o esperado. 
#* Isso pode ser um sinal de collinearidade.

# Correlação entre as variáveis
install.packages("corrr")
library(corrr)
#correlate(df$yrs.service,df$yrs.since.phd)
#mtcars %>% correlate() ##### AVISO: AS VARIÁVEIS DEVEM SER NUMÉRICAS E NÃO TEXTOS

# Teste de multicolinearidade
car::vif(mod = full_mod)
#**# Um valor VIF >5 ou >10 é um sinal de collinearidade que pode afetar consideravelmente os resultados.
#* VIF >  5 indica multicolinearidade
#* VIF > 10 indica colinearidade que tende à perfeita 

# Sem anos desde o doutorado
mod_no_phd <- lm(salary~discipline+yrs.service+rank+sex,
                 data = df)
summary(mod_no_phd)

car::vif(mod = mod_no_phd)
#**# Em vez de remover uma das variáveis collineares do modelo, uma solução alternativa 
#* é combinar as variáveis que são collineares entre si em uma única variável para executar no modelo.
#* (não faremos)

# Resolve-se a multicolinearidade, mas não resolve-se o problema de do sinal de anos de serviço.

mod_no_service <-lm(salary~discipline+yrs.since.phd+rank+sex,
                    data = df)
summary(mod_no_service)

## CRIANDO DUMMIES
# Dummy binária
df$dummy.sex <- ifelse(df$sex == 'Male', 1, 0)

sex_sum <- summary(df$sex)
sex_sum

dummy.sex_sum <- summary(df$dummy.sex)
dummy.sex_sum

# Dummy com varias classificações
install.packages('fastDummies')
library('fastDummies')

df <- dummy_cols(df, select_columns = c('rank', 'discipline')) #no lugar de 'rank' pode-se colocar c('rank', 'discipline')
# o que irá criar dummies para mais de uma coluna.
head(df)

modelo <- lm(salary~rank_AssocProf+rank_Prof+rank_AsstProf-1, data=df)
summary(modelo)
# O MODELO OFICIAL
### MQO
mod_no_service <-lm(salary~discipline+yrs.since.phd+rank+sex,
                    data = df)
summary(mod_no_service)

# Análise de outlyers
plot(mod_no_service, las = 1)
#**# Observa-se que 44, 351 e 318 são possíveis outlyers ou tem grandes respiduos. 
df[c(44, 351, 318), 1:6]

# Distância de Cook
#**# Um ponto de corte convencional é 4/n, onde n é o número de observações no conjunto de dados.
#* Vamos listar os dados com grandes numeros de cook
install.packages('MASS')
library(MASS)
dcooks <- cooks.distance(mod_no_service)
r <- stdres(mod_no_service)
a <- cbind(df, dcooks, r)
a[dcooks > 4/nrow(df), ]
#**# Parece que há muitos outlyers, o que pode distorcer os resultados


## Testes de heterocedasticidade
# Teste Breush-Pagan (H0: Homocedasticidade)
install.packages('lmtest')
library(lmtest)
bptest(mod_no_service)
#**# Como o p-valor é menor do que 0.1 então rejeita-se a hipóse de homocedasticidade,
#* o que implica que há indicios de presença de heterocedasticidade na regressão.


# Teste de White (H0: homocedasticidade)
install.packages('skedastic')
library(skedastic)
white_lm(mod_no_service)

## Teste de autocorrelação dos resíduos
# Teste de Durbin-Watson (H0: ausência de autocorreção)
dwtest(mod_no_service)

#**# Devido a esses problemas iremos rodas uma regressão robusta

### MQG usando repesado de minimos quadrados.
mod_no_service_robust.huber <- rlm(salary~discipline+yrs.since.phd+rank+sex,
                                   data = df)
summary(mod_no_service_robust.huber)

mod_no_service_robust.bisquare <- rlm(salary~discipline+yrs.since.phd+rank+sex,
                                      data = df, psi = psi.bisquare)
summary(mod_no_service_robust.bisquare)

# Estimando uma matriz VARCOV consiteste
install.packages('sandwich')
library(sandwich)
mod_no_service.robust1 <- coeftest(mod_no_service, vcov = vcovHC(mod_no_service))
mod_no_service.robust1

# Da pra alterar o método de estimação da varcov
mod_no_service.robust2 <- coeftest(mod_no_service, vcov = vcovHC(mod_no_service, type = "HC0"))
mod_no_service.robust2

# Outra forma de tratar a heterocedasticidade
install.packages('robustbase')
library(robustbase)
mod_no_service.robust3 <- lmrob(salary~discipline+yrs.since.phd+rank+sex,
                                data = df)

summary(mod_no_service.robust3)

# Com erros robustos gerados por bootstrap
install.packages('simpleboot')
library(simpleboot)

lboot <- lm.boot(mod_no_service, R = 1000)
summary(lboot)
lboot
