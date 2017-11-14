# See README.md

## Install missing packages
if(!require(pacman))install.packages("pacman")
pacman::p_load(doBy, RefManageR, stringi, Hmisc)

# Load custom functions
source("R/functions.R")

# Make gmindat, cropgmin (into output/ and global workspace)
rebuild_all()



