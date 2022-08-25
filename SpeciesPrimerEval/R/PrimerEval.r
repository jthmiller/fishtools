
#!/bin/r
## primer <- 'mifish'
## seq <- '/home/unhAW/jtmiller/watts/ref-database/MiFish/mitohelper/QIIME-compatible/12S-seqs-derep-teleo-seqs.qza'
## tax <- '/home/unhAW/jtmiller/watts/ref-database/MiFish/mitohelper/QIIME-compatible/12S-tax-derep-uniq.qza'
## 
## tag <- 'herring'
## species <- 'herring.txt'
## species <- c('Clupea pallasii','Alosa pseudoharengus','Alosa aestivalis','Clupea harengus','Sprattus sprattus')
## species <- 'Clupeidae'



parseMiFishTaxNames <- function(taxa){
    taxa <- strsplit(taxa,';')
    taxa <- lapply(taxa, gsub, pattern = "^__$", replacement=NA )
    taxa <- lapply(taxa, gsub, pattern = "^$", replacement=NA)
    taxa <- lapply(taxa,trimws)
    taxa <- lapply(taxa, function(X){
                    if(all(X == 'NA')){ 'Unassigned'} else { X[max(which(!X == 'NA'))] }
                        
    })
    taxa <- lapply(taxa, gsub, pattern = ".__", replacement="")
    taxa <- unlist(taxa)
    return(taxa)
}


main <- function(){
  
  args <- commandArgs(trailingOnly = TRUE)

  primer <- args[1]
  seq <- args[2]
  tax <- args[3]
  tag <- args[4]
  species <- args[5]

  process(primer,seq,tax,species,tag)

}


process <- function(primer,seq,tax,species,tag){

  seq <- read_qza(seq)$data
  tax <- read_qza(tax)$data 

  species <- readLines(species)

  matches <- lapply(species, grep, x = tax$Taxon)

  species_out <- parseMiFishTaxNames(unique(tax[unlist(matches),'Taxon']))  
  ### write species list out

  matches <- as.list(species_out)

  # grep twice so that user can provide any taxonomic level
  matches <- lapply(matches, grep, x = tax$Taxon)

  matches <- lapply(matches,function(X){
      tax[X,'Feature.ID']
  })

  matches <- lapply(matches,function(X){
      
      if(any(X %in% names(seq))){ 
        unique(seq[X]) 
      } else { 
        NA
      } 
  })
  names(matches) <- species_out

  n_entries <- lapply(matches, function(X){ sum(!is.na(X))})
  n_entries <- data.frame(unique_seq = unlist(  n_entries))
  write.table(n_entries, 'unique_seq_found.tsv', quote = F)


  idx <- rownames(n_entries)[which(n_entries$unique_seq > 0)]
  matches <- matches[idx]


  matches <-  mapply(function(matches,species){
      names(matches) <- paste(names(matches),species, sep = '_')
      return(matches)
  }, matches, names(matches))

  matches <- do.call(c,unname(matches))
  algn.length <- length(matches[[1]])

  msa <- msa(matches)
  msa@unmasked@ranges@NAMES <- gsub(".*_",'',msa@unmasked@ranges@NAMES)

  file <- paste0(primer,tag,'.tex')
  alFile <- paste0(primer,tag,'.fasta')
  msaPrettyPrint(msa, output="tex", file = file, alFile =  alFile, showNames="left", showLogo="none", askForOverwrite=FALSE, verbose=FALSE)


  alngnmt <- msaConvert(msa,type="seqinr::alignment")
  alngnmt <- as.matrix(dist.alignment(alngnmt, gap = T))
  rownames(alngnmt) <- gsub(".*_",'',rownames(alngnmt))
  colnames(alngnmt) <- gsub(".*_",'',colnames(alngnmt))


  file <- paste0(primer,'_',tag,'_distance.pdf')
  pdf(file, width = ncol(nedit)/4, height = ncol(nedit)/4))
  heatmap.2(alngnmt, col=Colors, margins=c(10,10), trace="none")
  dev.off()

  

  #make the pairwise edit distance matrix
  D = combn(names(matches),2)
  nedit = matrix(NA,ncol=length(matches),nrow=length(matches))
  rownames(nedit) = names(matches)
  colnames(nedit) = names(matches)

  for(idx in 1:ncol(D)){
         i <- D[1,idx]
         j <- D[2,idx]
         dist<-stringDist(matches[c(i,j)], substitutionMatrix = BLOSUM62)                        
         nedit[i,j]<-dist
         nedit[j,i]<-dist
  }
  rownames(nedit) <- gsub(".*_",'',rownames(nedit))
  colnames(nedit) <- gsub(".*_",'',colnames(nedit))


  file <- paste0(primer,'_',tag,'_edits.pdf')
  pdf(file, width = ncol(nedit)/3, height = ncol(nedit)/3)
  heatmap.2(nedit,col=Colors,margins=c(10,10),trace="none", cellnote = nedit, notecol= 'black')
  dev.off()


}

main()
