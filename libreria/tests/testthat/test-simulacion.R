test_that("simular_bootstrap devuelve B valores", {
  set.seed(1)
  x    <- rnorm(40)
  boot <- simular_bootstrap(x, B = 500, seed = 1)
  expect_length(boot, 500)
})

test_that("simular_ic_bootstrap produce IC valido", {
  set.seed(2)
  x  <- rexp(50, rate = 0.5)
  ic <- simular_ic_bootstrap(x, FUN = mean, B = 1000, seed = 2)
  expect_lt(ic$limite_inferior, ic$limite_superior)
  expect_gt(ic$estadistico_original, 0)
})

test_that("monte_carlo_integral estima pi/4 correctamente", {
  # Integral de sqrt(1-x^2) en [0,1] = pi/4
  res <- monte_carlo_integral(function(x) sqrt(1 - x^2), 0, 1,
                               N = 100000, seed = 99)
  expect_lt(abs(res$estimacion - pi / 4), 0.01)
})

test_that("simular_distribucion devuelve n valores", {
  x <- simular_distribucion("normal", n = 200, mean = 0, sd = 1,
                              seed = 1, graficar = FALSE)
  expect_length(x, 200)
})

test_that("simular_distribucion lanza error con dist desconocida", {
  expect_error(simular_distribucion("desconocida", n = 10, graficar = FALSE),
               "Distribucion no reconocida")
})
