read_data_dir <- function(path){
  
  raw <- read.csv(file.path(path, "data.csv"), stringsAsFactors = FALSE)  
  
  studyname <- basename(path)
  
  prepscript <- file.path(path, "prepare.R")
  if(file.exists(prepscript)){
    source(prepscript, local=TRUE)
    raw <- prepare(raw)
  }
  
  raw$source <- studyname

  # Unit conversions.
  raw$gmin <- mapply(convert_gmin_units, x=raw$gmin, units=raw$units, area=raw$area)
  
raw[,c("species","gmin","source")]
}



convert_gmin_units <- function(x, units, areabase){
  
  x * 
    switch(units,
             `10^5 ms-1` = 10^5 * 10^-3 / 41,
             `mmol m-2 s-1` = 1) *
    switch(areabase,
           allsided = 2,
           projected = 1)
  
  
}


rebuild_database <- function(){
  
  paths <- dir("data", full.names=TRUE)
               
  l <- lapply(paths, read_data_dir)
  
  dfr <- do.call(rbind, l)
  
  write.csv(dfr, "combined/gmindatabase.csv", row.names=FALSE)
  
return(invisible(dfr))
}



