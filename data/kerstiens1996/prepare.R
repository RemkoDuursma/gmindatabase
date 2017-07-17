prepare <- function(raw){


	# The datafile contains the Table 1 from Kerstiens1996, with methods:

	# A - astomatous cuticle, removed from leaf (permeance)
	# B - detached leaves, stomatal side sealed
	# C - whole leaves, stomatal side sealed (not clear when B or C, so all sealed leaves = C)
	# D - mass loss of detached leaves (gmin)
	# E1 - gnight / gdark
	# E2 - minimum conductance measured during the day (vague!)
	# E3 - presumed stomatal closure (v high CO2, ABA, drought, VPD) (vague!)

	# Here we are only interested in method D.
	# One value is very high - cannot be right.
	raw <- subset(raw, method == "D" & gmin < 100)
	
	# Number for Picea from Cowling & Kedrowski is definitely wrong (see its abstract)
	raw$gmin[raw$gmin == 44] <- NA
	
	# Number for Picea rubens is not really measured with proper weight loss method
	raw$gmin[raw$species == "Picea rubens" & raw$gmin == 24] <- NA
	
	# Much too high.
	raw$gmin[raw$species == "Glycine max" & raw$gmin > 100] <- NA
	
raw	
}
