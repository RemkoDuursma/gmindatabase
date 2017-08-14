# Database of minimum leaf conductance values

This repository is a collection of minimum leaf conductance (gmin) data from the literature, measured with the "weight-loss of detached leaves" method.

The `data` folder contains the raw data for each study (in file `data.csv`), including mandatory columns `units` (allowed are `10^5 ms-1`, `mmol m-2 s-1`, `mm s-1`, `cm s-1`) and `area` ("allsided" or "projected"). The data file can also include other columns, as many as you like. Typical columns are 'treatment', 'comments'. 

Each data folder can also include a file called `prepare.R`, which defines a single function `prepare`, that takes the raw data and does modifications or subsetting. Mostly this is used to select only the control treatment.

The file `combined/gmindatabase.csv` contains the combined dataset, which includes all control values for all species (for *projected* leaf area, in units of mmol m^-2^ s^-1^). In this dataset, all values are averaged by species within a study (not across studies).

To rebuild the database, simply run the script `rebuild_database.R`.
Required packages (`RefManageR`, `doBy`) will be installed when needed (using `pacman`).
