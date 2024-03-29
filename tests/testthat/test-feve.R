# Preamble code ----------------------------------------------------------------
data("traits_birds")
simple_site_sp <- matrix(1, nrow = 1, ncol = nrow(traits_birds),
                        dimnames = list("s1", row.names(traits_birds)))


# Tests for valid inputs -------------------------------------------------------

test_that("Functional Evenness output format", {

  feve <- expect_silent(fd_feve(traits_birds, sp_com = simple_site_sp))

  expect_s3_class(feve, "data.frame")
  expect_identical(dim(feve), c(1L, 2L))
  expect_named(feve, c("site", "FEve"))


  feve <- expect_silent(fd_feve(traits_birds))

  expect_s3_class(feve, "data.frame")
  expect_identical(dim(feve), c(1L, 2L))
  expect_named(feve, c("site", "FEve"))

})

test_that("Functional Evenness computation are in line with other packages", {

  # With internal dataset
  expect_equal(fd_feve(traits_birds, simple_site_sp)$FEve, 0.3743341,
               tolerance = 1e-6)

  # With perfectly spread dataset
  test_dissim  <- matrix(c(
    0, 1, 2,
    1, 0, 1,
    2, 1, 0
  ),
  byrow = TRUE, ncol = 3, dimnames = list(letters[1:3], letters[1:3]))

  abund_mat <- matrix(1, ncol = 3, dimnames = list("site1", letters[1:3]))

  expect_identical(fd_feve(sp_com = abund_mat, dist_matrix = test_dissim)$FEve, 1)
})

test_that("Functional Evenness works in 1D", {

  expect_identical(
    fd_feve(traits_birds[, 1], sp_com = simple_site_sp),
    fd_feve(traits_birds[, 1, drop = FALSE], sp_com = simple_site_sp)
  )

})

test_that("Functional Evenness works on subset of site/species", {
  site_sp <- matrix(1, ncol = nrow(traits_birds))
  colnames(site_sp) <-  rownames(traits_birds)
  rownames(site_sp) <- "s1"

  expect_message(fd_feve(traits_birds, site_sp[, 2:ncol(site_sp),
                                               drop = FALSE]),
                 paste0("Differing number of species between trait dataset ",
                        "and site-species matrix\nTaking subset of species"))

  expect_message(fd_feve(traits_birds[2:nrow(traits_birds),], site_sp),
                 paste0("Differing number of species between trait dataset ",
                        "and site-species matrix\nTaking subset of species"))
})

test_that("Functional Evenness edge cases", {

  # n_species = 2 < 3 so not possible to compute FEve
  expect_identical(fd_feve(traits_birds[1:2,],
                       simple_site_sp[, 1:2, drop = FALSE])[["FEve"]],
                   NA_real_)


  # n_species = 0, so no definition of FEve
  data("traits_plants")
  data("site_sp_plants")

  feve <- expect_silent(
    fd_feve(traits_plants, site_sp_plants[10,, drop = FALSE])
  )

  expect_identical(feve$FEve[[1]], NA_real_)
})

test_that("Functional Evenness works on sparse matrices", {

  skip_if_not_installed("Matrix")

  site_sp <- matrix(1, ncol = nrow(traits_birds))
  colnames(site_sp) <-  rownames(traits_birds)
  rownames(site_sp) <- "s1"

  sparse_site_sp <- Matrix(site_sp, sparse = TRUE)

  sparse_dist_mat <- Matrix(as.matrix(dist(traits_birds)), sparse = TRUE)

  # Only site-species matrix is sparse
  expect_silent(fd_feve(traits_birds, sparse_site_sp))

  expect_equal(
    fd_feve(traits_birds, sparse_site_sp),
    fd_feve(traits_birds, site_sp)
  )

  # Only distance matrix is sparse
  expect_silent(fd_feve(sp_com = site_sp, dist_matrix = sparse_dist_mat))

  expect_equal(
    fd_feve(sp_com = site_sp, dist_matrix = sparse_dist_mat),
    fd_feve(sp_com = site_sp, dist_matrix = dist(traits_birds))
  )

  # Both site-species and distance matrix are sparse
  expect_silent(fd_feve(sp_com = sparse_site_sp, dist_matrix = sparse_dist_mat))

  expect_equal(
    fd_feve(sp_com = sparse_site_sp, dist_matrix = sparse_dist_mat),
    fd_feve(sp_com = site_sp, dist_matrix = dist(traits_birds))
  )
})


# Tests for invalid inputs -----------------------------------------------------

test_that("Functional Evenness fails gracefully", {
  # No traits and no dissimilarity
  expect_error(
    fd_feve(NULL, matrix(1), NULL),
    "Please provide either a trait dataset or a dissimilarity matrix",
    fixed = TRUE
  )

  # Both traits AND dissimilarity
  expect_error(
    fd_feve(data.frame(a = 1), matrix(1), matrix(1)),
    "Please provide either a trait dataset or a dissimilarity matrix",
    fixed = TRUE
  )

  # Species matrix doesn't contain species from trait data
  expect_error(
    fd_feve(data.frame(a = 1, row.names = "sp1"), matrix(1)),
    paste0("No species in common found between trait dataset ",
           "and site-species matrix"),
    fixed = TRUE
  )

  ## Categorical trait data
  # Add non-continuous traits
  traits_birds_cat <- as.data.frame(traits_birds)
  traits_birds_cat$cat_trait <- "a"

  expect_error(
    fd_feve(traits_birds_cat, site_sp_birds),
    paste0("Non-continuous trait data found in input traits. ",
           "Please provide only continuous trait data"),
    fixed = TRUE
  )
})
