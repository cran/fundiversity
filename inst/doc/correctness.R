## ----vignette-setup, include = FALSE------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----load-pkg-----------------------------------------------------------------
library(fundiversity)

## ----panel-a------------------------------------------------------------------
data_a <- matrix(byrow = TRUE, ncol = 2,
  c(
    0.0, 1.0,
    0.5, 1.0,
    1.0, 1.0,
    1.5, 1.0,
    2.0, 1.0,
    1.0, 0.0,
    1.0, 0.5,
    1.0, 1.5,
    1.0, 2.0
  )
)
rownames(data_a) <- paste0("species", seq_len(nrow(data_a)))
print(data_a)

## ----plot-data-a, out.width = '100%', fig.width=7, fig.asp=1------------------
plot(data_a, pch = 19, asp = 1, xlab = "Trait 1", ylab = "Trait 2")

## ----compute-a----------------------------------------------------------------
fric_a <- fd_fric(data_a)[["FRic"]]
feve_a <- fd_feve(data_a)[["FEve"]]
fdiv_a <- fd_fdiv(data_a)[["FDiv"]]
fdis_a <- fd_fdis(data_a)[["FDis"]]
raoq_a <- fd_raoq(data_a)[["Q"]]

## ----data-c-------------------------------------------------------------------
l <- 2 # common species
s <- 1 # rare species

wc <- matrix(c(l, s, l, s, l, l, s, s, l), nrow = 1)
colnames(wc) <- rownames(data_a)
rownames(wc) <- "site"

## ----compute-c----------------------------------------------------------------
fric_c <- fd_fric(data_a)[["FRic"]]
feve_c <- fd_feve(data_a, wc)[["FEve"]]
fdiv_c <- fd_fdiv(data_a, wc)[["FDiv"]]
fdis_c <- fd_fdis(data_a, wc)[["FDis"]]
raoq_c <- fd_raoq(data_a, wc)[["Q"]]

## ----data-b-------------------------------------------------------------------
l <- 2 # common species
s <- 1 # rare species

wb <- matrix(c(l, l, l, l, l, s, s, s, s), nrow = 1)
colnames(wb) <- rownames(data_a)
rownames(wb) <- "site"

## ----compute-b----------------------------------------------------------------
fric_b <- fd_fric(data_a)[["FRic"]]
feve_b <- fd_feve(data_a, wb)[["FEve"]]
fdiv_b <- fd_fdiv(data_a, wb)[["FDiv"]]
fdis_b <- fd_fdis(data_a, wb)[["FDis"]]
raoq_b <- fd_raoq(data_a, wb)[["Q"]]

## ----data-d-------------------------------------------------------------------
shift <- 1/(2*sqrt(2))

data_d <- matrix(c(
  1-shift, 1-shift,
  1-shift, 1+shift,
  1+shift, 1-shift,
  1+shift, 1+shift,
  1.00 , 0.00 ,
  2.00 , 1.00 ,
  1.00 , 2.00 ,
  0.00 , 1.00 ,
  1.00 , 1.00),
  byrow = TRUE,
  ncol = 2
)


## ----compute-d----------------------------------------------------------------
fric_d <- fd_fric(data_d)[["FRic"]]
feve_d <- fd_feve(data_d)[["FEve"]]
fdiv_d <- fd_fdiv(data_d)[["FDiv"]]
fdis_d <- fd_fdis(data_d)[["FDis"]]
raoq_d <- fd_raoq(data_d)[["Q"]]

## ----data-e-------------------------------------------------------------------
data_e <- matrix(c(
  0.0, 1.0,
  0.5, 0.5,
  1.0, 1.0,
  1.5, 0.5,
  2.0, 1.0,
  1.0, 0.0,
  0.5, 1.5,
  1.5, 1.5,
  1.0, 2.0),
  byrow = TRUE,
  ncol = 2
)

## ----compute-e----------------------------------------------------------------
fric_e <- fd_fric(data_e)[["FRic"]]
feve_e <- fd_feve(data_e)[["FEve"]]
fdiv_e <- fd_fdiv(data_e)[["FDiv"]]
fdis_e <- fd_fdis(data_e)[["FDis"]]
raoq_e <- fd_raoq(data_e)[["Q"]]

