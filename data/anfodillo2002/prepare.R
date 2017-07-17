prepare <- function(raw){

  # Average across sites, months
  summaryBy(. ~ species, data=raw, FUN=mean, keep.names=TRUE, id=~area+units)
  
}
