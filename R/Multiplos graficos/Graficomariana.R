base <- read.csv2("C:/Users/ribei/OneDrive/PDM/scripts/R/Multiplos graficos/data3.csv")

install.packages("ggplot2")
install.packages("gtable")
install.packages("grid")
install.packages("gridExtra")
library(ggplot2)
library(gtable)
library(grid)
library(gridExtra)

install.packages("ggpubr")
library(ggpubr)
theme_set(theme_pubr())


g1 <- ggplot(base,aes(x=as.numeric(Depth),y=as.numeric(Sus)))+geom_line(color='black')+
  xlab("Depth") + 
  theme(plot.margin = unit(c(0,0,0,0), "lines"),
        plot.background = element_blank()) + ggtitle("Sus") + scale_x_continuous(limits = c(1947, 2241)) + 
  scale_y_continuous(limits = c(0, 0.5)) +
  coord_flip() + theme_bw() + 
  theme(axis.title.x = element_blank()) + scale_x_reverse()
g1
g2 <- ggplot(base,aes(x=as.numeric(Depth),y=as.numeric(Cond)))+geom_line(color='blue')+
  xlab("Depth") + theme_bw() +
  theme(axis.text.y = element_blank(), 
        axis.ticks.y = element_blank(), 
        axis.title.y = element_blank(),
        plot.margin = unit(c(0,0,0,0), "lines"),
        plot.background = element_blank()) + ggtitle("Cond") + scale_x_continuous(limits = c(1947, 2241)) + 
  scale_y_continuous(limits = c(0, 2.5)) + 
  coord_flip() +
  theme(axis.title.x = element_blank()) + scale_x_reverse()
g2
g3 <- ggplot(base,aes(x=as.numeric(Depth),y=as.numeric(Auppm)))+geom_line(color='orange')+
  xlab("Depth") + theme_bw() +
  theme(axis.text.y = element_blank(), 
        axis.ticks.y = element_blank(), 
        axis.title.y = element_blank(),
        plot.margin = unit(c(0,0,0,0), "lines"),
        plot.background = element_blank()) + ggtitle("Auppm") + xlim(1947, 2241) + ylim(0, 2) + 
  coord_flip() +
  theme(axis.title.x = element_blank()) + scale_x_reverse()
g3
g4 <- ggplot(base,aes(x=as.numeric(Depth),y=as.numeric(Sperc)))+geom_line(color='red') +
  xlab("Depth") + theme_bw() +
  theme(axis.text.y = element_blank(), 
        axis.ticks.y = element_blank(), 
        axis.title.y = element_blank(),
        plot.margin = unit(c(0,1,0,0), "lines"),
        plot.background = element_blank()) + ggtitle("Sperc") + xlim(1947, 2241) + ylim(0, 2) + 
  coord_flip() +
  theme(axis.title.x = element_blank()) + scale_x_reverse()
g4
grid.newpage()
grid.draw(cbind(ggplotGrob(g1), ggplotGrob(g2), ggplotGrob(g3), ggplotGrob(g4), size = "last"))

