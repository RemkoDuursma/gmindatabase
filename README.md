# Database of minimum leaf conductance values

This repository is a collection of minimum conductance data from the literature, measured with the weight-loss method (leaf dry-down curves) (gmin). 

The `data` folder contains the raw data for each study (in file `data.csv`), including mandatory columns `units` (so far only `10^5 ms-1` and `mmol m-2 s-1` are allowed) and `area` ("allsided" or "projected"). 

The file `combined/gmindatabase.csv` contains the combined dataset (for *projected* leaf area, in units of mmol m^-2^ s^-1^). 

To rebuild the database, simply run the script `rebuild_database.R` (no packaged needed).


## To-do list

- Add references for individual studies
