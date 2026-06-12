test_that("resumen_estadistico devuelve los elementos correctos", {
  x <- c(2, 4, 4, 4, 5, 5, 7, 9)
  res <- resumen_estadistico(x)

  expect_equal(res$n, 8)
  expect_equal(res$media, mean(x))
  expect_equal(res$mediana, median(x))
  expect_true(4 %in% res$moda)
  expect_equal(res$varianza, var(x))
})

test_that("tabla_frecuencias suma frecuencias a n", {
  set.seed(1)
  x <- rnorm(100)
  tab <- tabla_frecuencias(x, k = 8)
  expect_equal(sum(tab$frec_abs), 100)
  expect_equal(tail(tab$frec_rel_acum, 1), 1)
})

test_that("coef_variacion lanza error si media es cero", {
  expect_error(coef_variacion(c(-1, 0, 1)), "media es cero")
})

test_that("curtosis de normal aprox 0", {
  set.seed(123)
  expect_lt(abs(curtosis(rnorm(10000))), 0.3)
})

test_that("asimetria de distribucion simetrica aprox 0", {
  set.seed(456)
  expect_lt(abs(asimetria(rnorm(10000))), 0.1)
})
