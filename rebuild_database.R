# See README.md

## Install missing packages
if(!require(pacman))install.packages("pacman")
pacman::p_load(doBy, RefManageR, stringi, Hmisc, crayon, magrittr, dplyr)

# Load custom functions
source("R/functions.R")

# Make gmindat, cropgmin (into output/ and global workspace)
# Also makes 'gminall', a list with each component a separate study.
rebuild_all()
