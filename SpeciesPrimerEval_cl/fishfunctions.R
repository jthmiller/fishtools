### fish functions

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
