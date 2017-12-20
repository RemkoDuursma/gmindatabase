control <- function(raw){

	# data contain droughted plants, and well-watered.
	# For consistency, use well-watered plants only.
	subset(raw, treatment == "w")

}
