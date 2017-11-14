rebuild_all <- function(){
  
  # Tidied database with only species, gmin, datasource and citation.
  # For each data directory, the prepare.R script is run, which usually
  # takes only control treatments (and other 'control'-like conditions).
  # Also average by species within study.
  gmindat <<- rebuild_database()
  
  cat(paste("\n\nBuilding gmin databases\n\n"))
  
  # Number of species / study combinations
  # !! pipe %+% does not work on this system
  cat(paste(cyan("Number of measurements (filtered):"),
            white(nrow(gmindat) %>% chr)), "\n")
  
  # Number of unique species
  cat(paste(cyan("Number of species:"),
            white(gmindat$species %>% unique %>% length %>% chr)), "\n")
  
  
  # Database with crops only, keeping also the genotype mfor each study.
  # New column 'crop' for high-level name of the crop (Maize, Soybean, etc.).
  cropgmin <<- read_crops_genotype()
  
  cat(paste(cyan("Number of crop measurements:"),
            white(nrow(cropgmin) %>% chr)), "\n")
  
}

  
  

read_data_dir <- function(path, average=TRUE, 
                          run_prepare=TRUE,
                          output=c("database","all"), 
                          cols_database=c("species","gmin","datasource","citation")){
  
  output <- match.arg(output)
  if(output == "all")average <- FALSE
  raw <- read.csv(file.path(path, "data.csv"), stringsAsFactors = FALSE)  
  
  studyname <- basename(path)
  
  refs <- ReadBib("references/references.bib")
  ref_cite <- citation_data(studyname, refs=refs)
  
  prepscript <- file.path(path, "prepare.R")
  if(run_prepare && file.exists(prepscript)){
    source(prepscript, local=TRUE)
    raw <- prepare(raw)
    
    # Drop missing values (some may be generated in the prepare functions)
    raw <- raw[!is.na(raw$gmin),]
  }
  
  raw$datasource <- studyname
  raw$citation <- ref_cite

  # Unit conversions.
  raw$gmin <- mapply(convert_gmin_units, x=raw$gmin, units=raw$units, area=raw$area, species=raw$species)
  
  names(raw) <- tolower(names(raw))
  
  if(output == "all")return(raw)
  
  # Average across measurements for a species.
  # (Genotypes, dates, locations, etc.)
  if(average){
    raw <- summaryBy(. ~ species, data=raw, FUN=mean, keep.names=TRUE, id=~datasource+citation, na.rm=TRUE)
  }
  
select_fill(raw, cols_database)
}


select_fill <- function(dfr, columns){

  dfrout <- dfr[intersect(columns, names(dfr))]
  dfrout[setdiff(columns, names(dfr))] <- NA
  
dfrout
}



citation_data <- function(studyname, refs=NULL){
  
  if(is.null(refs))refs <- ReadBib("references/references.bib")
  
  if(grepl("0000", studyname)){
    auth <- Hmisc::capitalize(gsub("0000","", studyname))
    return(sprintf("%s, unpublished.", auth))
  } else {
    return(suppressMessages(Citet(refs[studyname], .opts=list(max.names=2))))
  }
  
}


# Convert from one of several options to mmol m-2 s-1.
# Assume mol m-3 = 41 (T 20C, Patm=101).
convert_gmin_units <- function(x, units, areabase, species){
  
  x * 
    switch(units,
             `10^5 ms-1` = 41 * 10^-5 * 10^3,
             `mmol m-2 s-1` = 1,
			       `cm s-1` = 10^-2 * 41 * 10^3,
             `mm s-1` = 41  
           ) *
    switch(tolower(areabase),
           allsided = conv_allsided(species),
           projected = 1)
  
  
}


conv_allsided <- function(species){
  
  # lambda1 = projected area / half-total surface area.
  
  # Mean of lambda1 in Barclay & Goodman (2000, Table 3), non-pine.
  nonpine_lambda1 <- mean(c(0.873, 0.92, 0.879, 0.864, 0.839))

  # pine, Barclay & Goodman (2000, Table 3)
  pine_lambda1 <- 0.778
  
  if(grepl("pinus", species, ignore.case = TRUE)){
    return(1 / (pine_lambda1/2))
  }
  con_gen <- c("abies","picea","pseudotsuga","cupressus","larix",
               "juniperus","metasequoia","thuja","tsuga")
  grp <- paste(con_gen, collapse="|")
  if(grepl(grp, species, ignore.case=TRUE)){
    return(1 / (nonpine_lambda1/2))
  }

return(2)
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

read_crops_genotype <- function(){
  
  alldata_files <- dir("data", pattern="data.csv", full.names=TRUE, recursive = TRUE) 
  
  dats <- lapply(alldata_files, read.csv, stringsAsFactors=FALSE)
  
  nm <- lapply(dats, names)
  ii <- sapply(nm, function(x)any(grepl("genotype", x, ignore.case=TRUE)))
  
  dirs <- dirname(alldata_files[ii])
  
  d <- do.call(rbind, lapply(dirs, read_data_dir, average=FALSE,
                             cols_database=c("species","gmin","genotype","datasource","citation"),
                             run_prepare=TRUE))  # usually take control treatments
  
  crop_df <- data.frame(genus = c("Arachis","Triticum","Oryza","Zea","Avena","Glycine max","Sorghum","Gossypium","Pennisetum"),
                        crop = c("Peanut","Wheat","Rice","Maize","Oats","Soybean","Sorghum","Cotton","Millet"),
                        stringsAsFactors = FALSE)
  
  d$crop <- stri_replace_all_regex(d$species, sprintf(".*%s.*", crop_df$genus), crop_df$crop, vectorize_all=FALSE)
  
  d <- subset(d, crop %in% crop_df$crop)
  
  write.csv(d, "combined/cropgmindatabase.csv", row.names=FALSE)
  
  return(invisible(d))
}



