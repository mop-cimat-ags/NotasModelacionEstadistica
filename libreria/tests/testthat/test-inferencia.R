test_that("ic_media cubre el verdadero parametro con alta probabilidad", {
  # Test de cobertura empirica
  set.seed(1)
  cubre <- replicate(1000, {
    x  <- rnorm(30, mean = 5, sd = 2)
    ic <- ic_media(x)
    ic$limite_inferior <= 5 && 5 <= ic$limite_superior
  })
  expect_gt(mean(cubre), 0.93)  # debe ser ~0.95
})

test_that("ic_media con sigma conocida usa distribucion Normal", {
  set.seed(2)
  x  <- rnorm(20)
  ic <- ic_media(x, sigma = 1)
  expect_equal(ic$distribucion, "Normal")
})

test_that("ic_proporcion limites entre 0 y 1", {
  ic <- ic_proporcion(x = 30, n = 100)
  expect_gte(ic$limite_inferior, 0)
  expect_lte(ic$limite_superior, 1)
})

test_that("emv_normal recupera parametros", {
  set.seed(5)
  x   <- rnorm(5000, mean = 10, sd = 3)
  emv <- emv_normal(x)
  expect_lt(abs(emv$mu_emv - 10), 0.1)
  expect_lt(abs(emv$sigma_emv - 3), 0.1)
})

test_that("emv_exponencial recupera lambda", {
  set.seed(8)
  x   <- rexp(5000, rate = 0.25)
  emv <- emv_exponencial(x)
  expect_lt(abs(emv$lambda_emv - 0.25), 0.01)
})

test_that("prueba_z rechaza H0 falsa con muestra grande", {
  set.seed(11)
  x   <- rnorm(200, mean = 12, sd = 2)
  res <- prueba_z(x, mu0 = 10, sigma = 2)
  expect_equal(res$decision, "Rechazar H0")
})
