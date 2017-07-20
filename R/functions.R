read_data_dir <- function(path){
  
  raw <- read.csv(file.path(path, "data.csv"), stringsAsFactors = FALSE)  
  
  studyname <- basename(path)
  
  prepscript <- file.path(path, "prepare.R")
  if(file.exists(prepscript)){
    source(prepscript, local=TRUE)
    raw <- prepare(raw)
    
    # Drop missing values (some may be generated in the prepare functions)
    raw <- raw[!is.na(raw$gmin),]
  }
  
  raw$source <- studyname

  # Unit conversions.
  raw$gmin <- mapply(convert_gmin_units, x=raw$gmin, units=raw$units, area=raw$area)
  
  # Average across measurements for a species.
  # (Genotypes, dates, locations, etc.)
  raw <- summaryBy(. ~ species, data=raw, FUN=mean, keep.names=TRUE, id=~source, na.rm=TRUE)
  
raw[,c("species","gmin","source")]
}


# Convert from one of several options to mmol m-2 s-1.
# Assume mol m-3 = 41 (T 20C, Patm=101).
convert_gmin_units <- function(x, units, areabase){
  
  x * 
    switch(units,
             `10^5 ms-1` = 41 * 10^-5 * 10^3,
             `mmol m-2 s-1` = 1,
			       `cm s-1` = 10^-2 * 41 * 10^3,
             `mm s-1` = 41  
           ) *
    switch(tolower(areabase),
           allsided = 2,
           projected = 1)
  
  
}


rebuild_database <- function(){
  
  paths <- dir("data", full.names=TRUE)
               
  l <- list()
  for(i in seq_along(paths)){
    message(sprintf("Adding %s", basename(paths[i])))
    l[[i]] <- read_data_dir(paths[i])  
  }
  
  dfr <- do.call(rbind, l)
  
  write.csv(dfr, "combined/gmindatabase.csv", row.names=FALSE)
  
return(invisible(dfr))
}



