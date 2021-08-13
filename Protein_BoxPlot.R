# library & datset
library(tidyverse)
library (tidyr)
library(ggplot2)
library(reshape2)
library(dplyr)

#Read data
proteins=read.table("MS5504_MCap_Protein_Abundances.csv",h=T, row.names=1, sep=",", check.names=F)
samplesInfo=read.table("Genotype289_Proteomics_Info.csv",h=T,row.names=1,sep=",")

samplesInfo$Sample<-rownames(samplesInfo)

#Combining normalized data and transposing
Normalized_data<-proteins[,rownames(samplesInfo)]
Normalized_data$names<-rownames(Normalized_data)
Normalized_data.melt <- melt(Normalized_data)
colnames(Normalized_data.melt)<-c("Genes","Sample","Protein_count")

Input_Table=merge(Normalized_data.melt,samplesInfo,by="Sample")


# Generate a figure for each protein automatically
ProteinList <- unique(Input_Table$Genes)

#Produce faceted box plot figures
for (i in ProteinList) {
  plot <- Input_Table %>% filter(Genes==i) %>% ggplot(aes(x=TP,y=Protein_count))  + 
    geom_boxplot() +
    geom_dotplot(binaxis='y', stackdir='center', dotsize = 0.5,aes(fill=TP)) +
    facet_grid(. ~ Treatment,scales = "free") +
    xlab("Timepoint") +
    ylab("Protein Count") +
    ggtitle(paste(i,sep=""))
  ggsave(plot,filename=paste("MC_DotBox_",i,".png",sep=""),dpi=600)
}