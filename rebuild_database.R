# See README.md

if(!require(pacman))install.packages("pacman")
pacman::p_load(doBy, RefManageR, stringi, Hmisc)

source("R/functions.R")

# Tidied database with only species, gmin, datasource and citation.
# For each data directory, the prepare.R script is run, which usually
# takes only control treatments (and other 'control'-like conditions).
# Also average by species within study.
gmindat <- rebuild_database()

# Number of species / study combinations
message("Number of measurements (filtered):", nrow(gmindat))

# Number of unique species
message("Number of species:", length(unique(gmindat$species)))


# Database with crops only, keeping also the genotype for each study.
# New column 'crop' for high-level name of the crop (Maize, Soybean, etc.).
cropgmin <- read_crops_genotype()


