# See README.md

if(!require(pacman))install.packages("pacman")
pacman::p_load(doBy)


source("R/functions.R")
gmindat <- rebuild_database()


nrow(gmindat)
length(unique(gmindat$species))



