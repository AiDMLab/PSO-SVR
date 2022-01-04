rm(list = ls())
getwd()
setwd("F:\\pythonWork\\TCGA-LIHC\\LIHCdataCompute")
options(stringsAsFactors = F)
load(file = 'input.Rdata')
Y[1:4,1:4]
X[1:4,1:4]
dim(X)
dim(Y)
library(preprocessCore)
library(parallel)
library(e1071)
load(file = 'output_obj.Rdata')


library(dplyr)
library(tidyr)
library(tidyverse)
psosvr_raw <- read.table("psosvr-Results-LIHC.txt",header = T,sep = '\t') %>%
  rename("Patients" = "Mixture") %>%
  select(-c("P.value","Correlation","RMSE"))


psosvr_tidy <- psosvr_raw %>%
  remove_rownames() %>%
  column_to_rownames("Patients")
。

flag <- apply(psosvr_tidy,2,function(x) sum(x == 0) < 
                dim(psosvr_tidy)[1]/2)

psosvr_tidy <- psosvr_tidy[,which(flag)] %>%
  as.matrix() %>%
  t()


bk <- c(seq(0,0.2,by = 0.01),seq(0.21,0.85,by=0.01))




library(pheatmap)
library(RColorBrewer)
p1<-pheatmap(
  psosvr_tidy,
  breaks = bk,
  cluster_cols = T,
  scale = "row",
  cluster_row = T,
  border_color = NA,
  show_colnames = F,
  show_rownames = T,
  color = c(colorRampPalette(colors = c("blue","white"))(length(bk)/2),
            colorRampPalette(colors = c("white","red"))(length(bk)/2)
  ))

library(RColorBrewer)
mypalette <- colorRampPalette(brewer.pal(8,"Set1"))
psosvr_barplot <- psosvr_raw %>%
  gather(key = Cell_type,value = Proportion,2:23)
psosvr_barplot

          

p2<-ggplot(psosvr_barplot,aes(Patients,Proportion,fill = Cell_type)) + 
  geom_bar(position = "stack",stat = "identity") +
  labs(fill = "Cell Type",x = "",y = "Estiamted Proportion") + theme_bw() +
  theme(axis.text.x = element_blank()) + theme(axis.ticks.x = element_blank()) +
  theme(axis.title.x =element_text(size=8), axis.title.y=element_text(size=8))+
  scale_y_continuous(expand = c(0.01,0)) +
  scale_fill_manual(values = mypalette(23))

p3<-ggplot(psosvr_barplot,aes(Cell_type,Proportion,fill = Cell_type)) + 
  geom_boxplot(outlier.shape = 21,coulour = "black") + theme_bw() + 
  labs(x = "", y = "Estimated Proportion") +
  theme(axis.title.x =element_text(size=8), axis.title.y=element_text(size=8))+
  theme(axis.text.x = element_blank()) + theme(axis.ticks.x = element_blank()) +
  scale_fill_manual(values = mypalette(23))



P<-ggarrange(p2,p3,nrow  = 2,labels = c("A","B"),common.legend = TRUE,legend = "right",label.x = 0, label.y = 1,
          font.label = list(size = 14, face = "bold"))
plot(P)
