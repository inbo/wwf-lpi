find_valleys <- function(x,
                         leftdepthfactor = 1/3,
                         rightdepthfactor = 1/3) {
  differences <- diff(x, na.pad = FALSE)
  shape <- diff(sign(differences))
  pks_vls <- which(shape != 0)
  pks <- sapply(which(shape < 0), FUN = function(i) {
    z <- ifelse(which(pks_vls == i) == 1,
                1,
                pks_vls[which(pks_vls == i) - 1])
    w <- ifelse(which(pks_vls == i) == length(pks_vls),
                length(x),
                pks_vls[which(pks_vls == i) + 1])
    if (all(x[c(z:i, (i + 2):w)] <= x[i + 1]) &
        diff(range(x[z:i])) >= leftdepthfactor * max(abs(x)) &
        diff(range(x[i:w])) >= rightdepthfactor * max(abs(x)))
      return(i + 1)
    else
      return(numeric(0))
  })
  #returns a vector of indices of local peaks in x
  # or local valleys if x = -x
  pks <- unlist(pks)
  pks
}


closure_periods <- function(df,
                            leftdepthfactor = 1/3,
                            rightdepthfactor = 1/5,
                            first = TRUE) {
  x <- df %>%
    pull(julian_day)

  xd <- density(x)

  #note that the density is estimated at 512 equally spaced points
  #depthfactor is relative to maximum densityvalue
  # the factor asserts that to the left and to the right the valley is at least
  # depthfactor * max(x) in depth (height)
  valley_indices <- find_valleys(x = -xd$y,
                                 leftdepthfactor = leftdepthfactor,
                                 rightdepthfactor = rightdepthfactor)
  valleys <- xd$x[valley_indices]

  # check if valleys are found
  # if not, return q5 and q95 as season_start and season_end

  if (length(valley_indices) == 0) {
    data.frame(number_of_generations = length(valley_indices) + 1,
               valley = NA,
               season_start = quantile(x = x, probs = 0.05),
               season_end = quantile(x = x, probs = 0.95))
  } else {
     if (isTRUE(first)) {
       # if valleys are found => multiple flight periods
       # choose the first flight period
       x <- x[x <= valleys[1]]
       data.frame(number_of_generations = length(valley_indices) + 1,
                  valley = valleys[1],
                  season_start = quantile(x = x, probs = 0.05),
                  season_end = quantile(x = x, probs = 0.95))
     }
    else {
      # alternative: calculate flight period with most observations
      # approx partial areas = partial probability mass
      pareas <- vector(mode = "numeric", length = length(valley_indices) + 1)
      for (i in 1:length(valley_indices)) {
        if (i == 1) {
          pareas[i] <- sum(diff(xd$x[1:valley_indices[i]]) *
                             zoo::rollmean(xd$y[1:valley_indices[i]],2))
        } else {
          pareas[i] <- sum(diff(xd$x[(valley_indices[i - 1] + 1):valley_indices[i]]) *
                             zoo::rollmean(
                               xd$y[(valley_indices[i - 1] + 1):valley_indices[i]],2))
        }
      }
      pareas[length(valley_indices) + 1] <- 1 - sum(diff(xd$x[1:tail(valley_indices, 1)]) *
                                                      zoo::rollmean(xd$y[1:tail(valley_indices, 1)],2))
      which_generation <- which.max(pareas)
      valley_intervals <- c(1, xd$x[valley_indices], 366)
      x <- x[x >= valley_intervals[which_generation] &
               x <= valley_intervals[which_generation + 1]]
      data.frame(number_of_generations = length(valley_indices) + 1,
                 max_generation = which_generation,
                 valley = valleys[1],
                 season_start = quantile(x = x, probs = 0.05),
                 season_end = quantile(x = x, probs = 0.95))
    }
  }
}


lookup_vernacular_names <- function(key, source = "Catalogue of the Lepidoptera of Belgium") {
  names <- rgbif::name_usage(key = key, data = "vernacularNames")$data %>%
    filter(language %in% c("nld", "fra"),
           #preferred == TRUE | is.na(preferred),
           source == source) %>%
    distinct(vernacularName, language)

  nederlands <- names %>%
    filter(language == "nld") %>%
    mutate(vernacularName = tolower(vernacularName)) %>%
    distinct()

  if (nrow(nederlands) >= 1) {
    nederlands <- nederlands$vernacularName[1]
  } else {
    nederlands <- NA
  }

  frans <- names %>%
    filter(language == "fra") %>%
    mutate(vernacularName = tolower(vernacularName)) %>%
    distinct()

  if (nrow(frans) >= 1) {
    frans <- frans$vernacularName[1]
  } else {
    frans <- NA
  }

  return(data.frame(species_name_NL = nederlands, species_name_FR = frans))
}


