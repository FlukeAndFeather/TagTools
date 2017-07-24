#' Measure tortuousity index of a regularly sampled horizontal track. 
#' 
#' @description Tortuosity can be measured in a number of ways. This function compares the stretched-out track length (STL) over an interval of time with the distance made good (DMG, i.e., the distance actually covered in the interval). The index returned is (STL-DMG)/STL which is 0 for straightline movement and 1 for extreme circular movement.
#' @param T Contains the animal positions in a local horizontal plane. T has a row for each position and two columns: northing and easting. The positions can be in any consistent spatial unit, e.g., metres, km, nautical miles, and are referenced to an arbitrary 0,0 location. T cannot be in degrees as the distance equivalent to a degree latitude is not the same as for a degree longitude.
#' @param fs The sampling rate of the positions in Hertz (samples per second).
#' @param intvl The time interval in seconds over which tortuosity is calculated. This should be chosen according to the scale of interest, e.g., the typical length of a foraging bout.
#' @return t The tortuosity index which is between 0 and 1 as described above. t contains a value for each period of intvl seconds.
#' @note This tortuosity index is fairly insensitive to speed so if T is produced by dead-reckoning (e.g., using ptrack or htrack), the speed estimate is not important. Also the frame of T is not important as long as the two axes (nominally called northing and easting) used to describe the positions are perpendicular.
#' @example t <- tortuosity(T, fs, 90)
#' @export

tortuosity <- function(T, fs, intvl) {
  k <- round(fs * intvl) 
  N <- buffer_nodelay(T[, 1], k, 0)
  E <- buffer_nodelay(T[, 2], k, 0)
  lmg <- t(sqrt((E[length(E), ] - E[1, ])^2 + (N[length(N), ] - N[1, ])^2))
  stl <- t(sum(sqrt(diff(E)^2 + diff(N)^2)))
  t <- (stl - lmg) / stl 
  t[, 2] <- t(sqrt(mean((N - repmat(mean(N), nrow(N),1))^2 + (E - pracma::repmat(mean(E), nrow(E), 1))^2)))
  return(t)
}