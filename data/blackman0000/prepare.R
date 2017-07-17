prepare <- function(raw){

	# Only ambient-grown plants (but all measurement temperatures)
	subset(raw, growth_T == "amb")

}