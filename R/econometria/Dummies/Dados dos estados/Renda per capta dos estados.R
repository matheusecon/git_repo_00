################################################################################
################################################################################
##////////////////////////////////////////////////////////////////////////////##
################################################################################
################################################################################
###                                                                          ### 
###                          Renda per capta no R                            ###
###                             econometria 1                                ###
###                            MATHEUS RIBEIRO                               ###
###                                                                          ###    
################################################################################
################################################################################
##////////////////////////////////////////////////////////////////////////////##
################################################################################
################################################################################

install.packages("dplyr")
library(dplyr) #é necessário para utilizar a função %>%
library(RColorBrewer) 
library(leaflet) #é uma paleta de cores

# remover objetos
rm("") ## remove objetos específicos: colocar objeto em parenteses
rm(list= ls()) ## remove todos os objetos
rm(list=ls(pattern="^model")) #remove objetos que começam com o padrão model

#carregar a base de dados
### Mudar o diretório para onde a base esta localizada
setwd("C:/Users/ribei/OneDrive/PDM/Scripts/R/econometria/Dummies/Dados dos estados") #MUDAR PARA O SEU DIRETÓRIO

### Ler a base
library("readxl")
base <- read_excel("data.xlsx")

### Saber o tipo da base de dados]
typeof(base)
class(base)

### Transforma lista em data frame
base <- data.frame(base)

### Ver seis primeiras linhas
head(base)

##### MAPA DA RENDA PER CAPTA

### Shape dos estados
install.packages("rgdal")
library(rgdal)
shp <- readOGR("Mapa\\.", "BRUFE250GC_SIR", stringsAsFactors=FALSE, encoding="UTF-8")

### Códigos dos estados
ibge <- read_excel("ibge.xlsx")
ibge <- ibge[order(ibge$estado),]

### Merge com da base com os códigos
df <- merge(base,ibge, by.x = "estado", by.y = "estado")

### Merge shape e a base
dfespacial <- merge(shp,df, by.x = "CD_GEOCUF", by.y = "CD_GEOCUF")

### Converter o nome do estado para UFT-8
proj4string(dfespacial) <- CRS("+proj=longlat +datum=WGS84 +no_defs")
Encoding(dfespacial$NM_ESTADO) <- "UTF-8"

### Mapa dos estados brasileiros
pal <- colorBin("Blues",domain = NULL,n=5) #cores do mapa

state_popup <- paste0("<strong>Estado: </strong>", 
                      dfespacial$NM_ESTADO, 
                      "<br><strong>Pontos: </strong>", 
                      dfespacial$rendapercapta)
leaflet(data = dfespacial) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(fillColor = ~pal(dfespacial$rendapercapta), 
              fillOpacity = 0.8, 
              color = "#BDBDC3", 
              weight = 1, 
              popup = state_popup) %>%
  addLegend("bottomright", pal = pal, values = ~dfespacial$rendapercapta,
            title = "Renda per capta",
            opacity = 1)

#####

#### Dummies de Regiões do brasil
regiao <- read_excel("regioes.xlsx")

df <- merge(df,regiao, by.x = "sigla", by.y = "sigla")


### Estatísticas descritivas por região
tapply(df$rendapercapta, df$região, summary)

# Criando Dummy de região
library('fastDummies')

#Primeiro forma de criar
df <- dummy_cols(df, select_columns = 'região')

#Segunda forma de criar
df$NORTENORDESTE = 0
df$NORTENORDESTE[df$região == 'SUDESTE'] <- 1
df$NORTENORDESTE[df$região == 'SUL'] <- 1
df$NORTENORDESTE[df$região == 'CENTRO-OESTE'] <- 1

head(df)

### MQO
model1 <-lm(rendapercapta~NORTENORDESTE,
           data = df)
summary(model1)

### Com outras variáveis
model2 <-lm(rendapercapta ~ NORTENORDESTE + saneamento.inadequado + analfabetismo,
            data = df)
summary(model2)

### Variável de interação
model3 <-lm(log(rendapercapta) ~ NORTENORDESTE + saneamento.inadequado + analfabetismo + NORTENORDESTE*analfabetismo,
            data = df)
summary(model3)




