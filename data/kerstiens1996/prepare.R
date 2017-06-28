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
	subset(raw, method == "D")
	
}
