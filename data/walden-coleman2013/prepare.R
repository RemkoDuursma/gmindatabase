prepare <- function(raw){

  # Average across genotypes
  summaryBy(. ~ species, data=raw, FUN=mean, keep.names=T, id=~area+units)
  
}
