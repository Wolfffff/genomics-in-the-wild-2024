
add.alpha <- function(col, alpha=1){apply(sapply(col, col2rgb)/255, 2, function(x) rgb(x[1], x[2], x[3], alpha=alpha))}
library(vegan)

taxonomic_levels = c("domain","phylum","class","order","family","genus")
projects<-c("hyrax","zebra","soil","rhino")

sample_file <- function(project,taxonomic_level){
  return(paste(c("data_for_students/project_data/16S/",project,"_",taxonomic_level,".txt"),collapse=""))
}

plot_reads_per_sample <- function(project,taxonomic_level,save=F){
  read_counts = read.table(sample_file(project,taxonomic_level),
                           header=T,stringsAsFactors=F,sep="\t")
  par(mar=c(5,10,5,4))
  barplot(rowSums(read_counts),horiz=T,col=add.alpha("#006699",0.6),las=1,main=paste("Taxonomic level:",taxonomic_level,sep=" "),
          xlab=paste(c("Number of reads for which\n taxonomic level is identified"),collapse=""))
  par(mar=c(5,4,4,1))
}

composition_barplot <- function(sample,taxonomic_level,save=F){
  read_counts = read.table(sample_file(sample,taxonomic_level),header=T,stringsAsFactors=F,sep="\t")
  read_counts_normalized_per_sample = apply(read_counts,1,function(x){if(sum(x)==0){x}else{x/sum(x)}})
  read_counts_normalized_per_sample = read_counts_normalized_per_sample[order(rowSums(read_counts_normalized_per_sample)),]
  colors = rep(c("#66c2a5","#fc8d62","#8da0cb","#e78ac3","#a6d854","#ffd92f","#e5c494","#b3b3b3"),nrow(read_counts_normalized_per_sample))[1:nrow(read_counts_normalized_per_sample)]
  par(mar=c(10,5,2,15))
  barplot(read_counts_normalized_per_sample,col=colors,las=2,ylab="Fraction of reads",
          names=paste(row.names(read_counts),paste("n=",rowSums(read_counts),sep=""),sep="\n"))
  units_to_include_in_legend = which(rowSums(read_counts_normalized_per_sample) > 0.01)
  legend(x=0.1+1.2*ncol(read_counts_normalized_per_sample),y=1,
         xpd=T,rev(row.names(read_counts_normalized_per_sample)[units_to_include_in_legend]),fill=rev(colors[units_to_include_in_legend]),
         bty="n")
  par(mar=c(5,4,4,1))
}

downsample2 <- function(vec,n){
  u = unlist(lapply(1:length(vec),function(i){rep(i,vec[i])}))
  v = sample(u,n,replace=F)
  w = unlist(lapply(1:length(vec),function(i){sum(v==i)}))
  return(w)
}

downsample <- function(x,downsampling_number){
  
  total_read_counts_per_sample = rowSums(x)
  
  read_counts_downsampled = x[total_read_counts_per_sample >= downsampling_number,]
  for(j in 1:nrow(read_counts_downsampled)){
    read_counts_downsampled[j,] = downsample2(as.numeric(read_counts_downsampled[j,]),downsampling_number)
  }
  return(read_counts_downsampled)
}

unique_taxa <- function(read_counts){
  apply(read_counts,1,function(x){sum(x>0)})
}


