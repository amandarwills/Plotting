# library & datset
library(tidyverse)
library (tidyr)
library(ggplot2)
library(reshape2)

#Read data
metabolites=read.table("Galactitol.csv",warn=FALSE,h=T,sep=",",check.names=F)
samplesInfo=read.table("Pacuta_Sample_Info.csv",h=T,row.names=1,sep=",")

Treatment1="ATAC"
Treatment2="ATHC"

#Normalize Ion Counts
A=samplesInfo[which(samplesInfo$Treatment==Treatment1),]
H=samplesInfo[which(samplesInfo$Treatment==Treatment2),]

A.norm=sweep(metabolites[,rownames(A)],2,as.numeric(A$Weight),FUN='/')
H.norm=sweep(metabolites[,rownames(H)],2,as.numeric(H$Weight),FUN='/')

#Writing normalized values to file
#to.write <- data.frame("Name"=rownames(Normalized_data),Normalized_data)
#write.table(to.write,file=outputfile,quote=FALSE,sep="\t",row.names=F,col.names=T)

#Combining normalized data and transposing
Normalized_data=cbind(A.norm,H.norm)
Normalized_data$names<-rownames(Normalized_data)
Normalized_data.melt <- melt(Normalized_data,id.vars = c("names"))
Input_Table=cbind(Normalized_data.melt,samplesInfo[Normalized_data.melt$variable,])
names(Input_Table)[3] <- "Normalized_Ion_Count"

# Generate a figure for each metabolite automatically
CompoundList <- unique(Input_Table$names)

#Produce faceted box plot figures
for (i in CompoundList) {
  plot <- Input_Table %>% filter(names==i) %>% ggplot(aes(x=TP,y=Normalized_Ion_Count))  + 
    geom_boxplot() +
    geom_dotplot(binaxis='y', stackdir='center', dotsize = 0.5,aes(fill=TP)) +
    facet_grid(. ~ Treatment) +
    ggtitle(paste(i,sep=""))
  ggsave(plot,filename=paste("PA_PoolSize_DotBox_Normalized_",i,".png",sep=""),dpi=600)
}