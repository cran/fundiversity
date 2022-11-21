## ----vignette-setup, include = FALSE------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library("fundiversity")

## ----see-data-----------------------------------------------------------------
data(package = "fundiversity")

## ----load-data-traits---------------------------------------------------------
data("traits_birds", package = "fundiversity")

head(traits_birds)

data("traits_plants", package = "fundiversity")

head(traits_plants)

## ----load-data-site-sp--------------------------------------------------------
# Site-species matrix for birds
data("site_sp_birds", package = "fundiversity")

head(site_sp_birds)[, 1:5]

# Site-species matrix for plants
data("site_sp_plants", package = "fundiversity")

head(site_sp_plants)[, 1:5]

## ----not-enough-species, error=TRUE-------------------------------------------
# Fewer species in trait dataset than species in the site-species matrix
fd_fric(traits_birds[2:217,], site_sp_birds)

# Fewer species in the site-species matrix than in the traits
fd_fric(traits_birds, site_sp_birds[, 1:60])

# No species in common between both dataset
fd_fric(traits_birds[1:5,], site_sp_birds[, 6:10])

## ----fric-1d------------------------------------------------------------------
# Range of bill width in the birds dataset
diff(range(traits_birds[, "Bill.width..mm."]))

# Using fundiversity::fd_fric()
fd_fric(traits_birds)

## ----fric-nd------------------------------------------------------------------
fd_fric(traits_birds)

## ----fric-nd-sites------------------------------------------------------------
fd_fric(traits_birds, site_sp_birds)

## ----fric-stand---------------------------------------------------------------
fd_fric(traits_birds, stand = TRUE)

## ----fric-stand-sites---------------------------------------------------------
fd_fric(traits_birds, site_sp_birds, stand = TRUE)

## ----fric-intersect-intro-----------------------------------------------------
fd_fric_intersect(traits_birds)

## ----fric-intersect-all-------------------------------------------------------
fd_fric_intersect(traits_birds, site_sp_birds[1:2,])

## ----fric-intersect-stand-----------------------------------------------------
fd_fric_intersect(traits_birds, site_sp_birds[1:2,], stand = TRUE)

## ----fdiv-intro---------------------------------------------------------------
# One-dimension FDiv
fd_fdiv(traits_birds[, 1, drop = FALSE])

# Multiple dimension FDiv
fd_fdiv(traits_birds)

## ----fdiv-sites---------------------------------------------------------------
fd_fdiv(traits_birds, site_sp_birds)

## ----feve-intro---------------------------------------------------------------
# One-dimension FEve
fd_feve(traits_birds[, 1, drop = FALSE])

# Multiple dimension FEve
fd_feve(traits_birds)

## ----feve-sites---------------------------------------------------------------
fd_feve(traits_birds, site_sp_birds)

## ----fdis-intro---------------------------------------------------------------
fd_fdis(traits_birds)

## ----fdis-sites---------------------------------------------------------------
fd_fdis(traits_birds, site_sp_birds)

## ----raoq-intro---------------------------------------------------------------
fd_raoq(traits_birds)

## ----raoq-sites---------------------------------------------------------------
fd_raoq(traits_birds, site_sp_birds)

## ----raoq-dissim--------------------------------------------------------------
# Compute dissimilarity between species with the Manhattan distance
trait_dissim <- dist(traits_birds, method = "manhattan")

fd_raoq(dist_matrix = trait_dissim)

fd_raoq(sp_com = site_sp_birds, dist_matrix = as.matrix(trait_dissim))

## ----sparse-matrix-example----------------------------------------------------
# Convert site-species matrix to sparse matrix
sparse_site_sp <- Matrix::Matrix(site_sp_birds, sparse = TRUE)

fd_raoq(traits_birds, site_sp_birds)

## ----scale_traits-------------------------------------------------------------
traits_birds_sc <- scale(traits_birds)
summary(traits_birds_sc)

# Unscaled
fd_fric(traits_birds)

# Scaled
fd_fric(traits_birds_sc)

## ----minmax_traits------------------------------------------------------------
min_values <- as.numeric(lapply(as.data.frame(traits_birds), min))
max_values <- as.numeric(lapply(as.data.frame(traits_birds), max))

traits_birds_minmax <- apply(traits_birds, 1, function(x) {
  (x - min_values)/(max_values - min_values)
})
traits_birds_minmax <- t(traits_birds_minmax)
summary(traits_birds_minmax)

