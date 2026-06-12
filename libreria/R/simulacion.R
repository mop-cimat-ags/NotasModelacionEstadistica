#' Bootstrap no parametrico
#'
#' Realiza B remuestras bootstrap de un vector x y aplica una funcion
#' estadistica a cada remuestra.
#'
#' @param x Vector numerico original.
#' @param FUN Funcion estadistica a aplicar (default: mean).
#' @param B Numero de remuestras bootstrap (default: 1000).
#' @param seed Semilla aleatoria (default: NULL).
#'
#' @return Vector de longitud B con los valores bootstrap del estadistico.
#'
#' @examples
#' set.seed(42)
#' x <- rexp(30, rate = 0.5)
#' boot_medias <- simular_bootstrap(x, FUN = mean, B = 2000)
#' hist(boot_medias, main = "Distribucion Bootstrap de la Media")
#'
#' @export
simular_bootstrap <- function(x, FUN = mean, B = 1000, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  n      <- length(x)
  resultado <- numeric(B)
  for (i in seq_len(B)) {
    muestra_boot    <- x[sample(n, n, replace = TRUE)]
    resultado[i]    <- FUN(muestra_boot)
  }
  resultado
}


#' Intervalo de confianza bootstrap
#'
#' Calcula un IC bootstrap usando el metodo de percentiles o el metodo
#' BCa (bias-corrected accelerated).
#'
#' @param x Vector numerico original.
#' @param FUN Funcion estadistica (default: mean).
#' @param B Numero de remuestras (default: 2000).
#' @param nivel Nivel de confianza (default: 0.95).
#' @param metodo "percentil" (default) o "bca".
#' @param seed Semilla aleatoria.
#'
#' @return Lista con: estadistico_original, limite_inferior, limite_superior,
#'   nivel_confianza, B, metodo, y distribucion_bootstrap.
#'
#' @examples
#' set.seed(10)
#' x <- rchisq(40, df = 3)
#' simular_ic_bootstrap(x, FUN = median)
#'
#' @export
simular_ic_bootstrap <- function(x, FUN = mean, B = 2000,
                                  nivel = 0.95, metodo = "percentil",
                                  seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  theta_obs <- FUN(x)
  boot_vals <- simular_bootstrap(x, FUN = FUN, B = B)

  alpha <- 1 - nivel
  if (metodo == "bca") {
    # Sesgo
    z0   <- qnorm(mean(boot_vals < theta_obs))
    # Aceleracion (jackknife)
    n      <- length(x)
    jack   <- sapply(seq_len(n), function(i) FUN(x[-i]))
    jack_m <- mean(jack)
    a      <- sum((jack_m - jack)^3) / (6 * sum((jack_m - jack)^2)^1.5)
    # Percentiles ajustados
    alpha1 <- pnorm(z0 + (z0 + qnorm(alpha / 2))     / (1 - a * (z0 + qnorm(alpha / 2))))
    alpha2 <- pnorm(z0 + (z0 + qnorm(1 - alpha / 2)) / (1 - a * (z0 + qnorm(1 - alpha / 2))))
    li <- quantile(boot_vals, alpha1)
    ls <- quantile(boot_vals, alpha2)
  } else {
    li <- quantile(boot_vals, alpha / 2)
    ls <- quantile(boot_vals, 1 - alpha / 2)
  }

  list(
    estadistico_original  = theta_obs,
    limite_inferior        = unname(li),
    limite_superior        = unname(ls),
    nivel_confianza        = nivel,
    B                      = B,
    metodo                 = metodo,
    distribucion_bootstrap = boot_vals
  )
}


#' Integracion por Monte Carlo
#'
#' Estima la integral de una funcion f sobre el intervalo [a, b]
#' usando el metodo de Monte Carlo de muestreo uniforme.
#'
#' @param f Funcion a integrar. Debe aceptar un vector numerico.
#' @param a Limite inferior de integracion.
#' @param b Limite superior de integracion.
#' @param N Numero de puntos Monte Carlo (default: 100000).
#' @param seed Semilla aleatoria.
#'
#' @return Lista con: estimacion, error_estandar, IC_95 (vector con [li, ls]),
#'   N, e intervalo [a, b].
#'
#' @examples
#' # Integral de x^2 en [0, 1] = 1/3
#' monte_carlo_integral(function(x) x^2, a = 0, b = 1, N = 50000, seed = 1)
#'
#' # Integral de sin(x) en [0, pi] = 2
#' monte_carlo_integral(sin, a = 0, b = pi, N = 100000, seed = 2)
#'
#' @export
monte_carlo_integral <- function(f, a, b, N = 100000, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  u    <- runif(N, a, b)
  vals <- f(u)
  est  <- (b - a) * mean(vals)
  se   <- (b - a) * sd(vals) / sqrt(N)

  list(
    estimacion    = est,
    error_estandar = se,
    IC_95         = c(est - 1.96 * se, est + 1.96 * se),
    N             = N,
    intervalo     = c(a, b)
  )
}


#' Simular de una distribucion y graficar
#'
#' Genera n muestras de una distribucion especificada y muestra un
#' histograma con la curva teorica superpuesta.
#'
#' @param dist Nombre de la distribucion: "normal", "exponencial",
#'   "uniforme", "gamma", "beta", "poisson", "binomial", "t", "chisq".
#' @param n Tamano de muestra (default: 1000).
#' @param ... Parametros de la distribucion (pasados a la funcion r*()).
#' @param seed Semilla aleatoria.
#' @param graficar Logical. Si es TRUE (default) produce un histograma.
#'
#' @return Vector de n valores simulados (invisible si graficar = TRUE).
#'
#' @examples
#' simular_distribucion("normal", n = 500, mean = 5, sd = 2, seed = 1)
#' simular_distribucion("exponencial", n = 300, rate = 0.5, seed = 2)
#' simular_distribucion("gamma", n = 400, shape = 2, rate = 1, seed = 3)
#'
#' @export
simular_distribucion <- function(dist, n = 1000, ..., seed = NULL,
                                  graficar = TRUE) {
  if (!is.null(seed)) set.seed(seed)
  args  <- list(...)

  x <- switch(dist,
    normal      = do.call(rnorm,   c(list(n = n), args)),
    exponencial = do.call(rexp,    c(list(n = n), args)),
    uniforme    = do.call(runif,   c(list(n = n), args)),
    gamma       = do.call(rgamma,  c(list(n = n), args)),
    beta        = do.call(rbeta,   c(list(n = n), args)),
    poisson     = do.call(rpois,   c(list(n = n), args)),
    binomial    = do.call(rbinom,  c(list(n = n), args)),
    t           = do.call(rt,      c(list(n = n), args)),
    chisq       = do.call(rchisq,  c(list(n = n), args)),
    stop("Distribucion no reconocida: ", dist)
  )

  if (graficar) {
    es_discreta <- dist %in% c("poisson", "binomial")
    titulo      <- paste0("Muestra n=", n, " - Distribucion ", dist)

    if (es_discreta) {
      barplot(table(x) / n, col = "#006341", border = "white",
              main = titulo, xlab = "x", ylab = "Frecuencia relativa")
    } else {
      hist(x, prob = TRUE, col = "#006341", border = "white",
           main = titulo, xlab = "x", ylab = "Densidad")

      # Curva teorica superpuesta
      xs <- seq(min(x), max(x), length.out = 300)
      dens <- switch(dist,
        normal      = do.call(dnorm,  c(list(x = xs), args)),
        exponencial = do.call(dexp,   c(list(x = xs), args)),
        uniforme    = do.call(dunif,  c(list(x = xs), args)),
        gamma       = do.call(dgamma, c(list(x = xs), args)),
        beta        = do.call(dbeta,  c(list(x = xs), args)),
        t           = do.call(dt,     c(list(x = xs), args)),
        chisq       = do.call(dchisq, c(list(x = xs), args)),
        NULL
      )
      if (!is.null(dens)) lines(xs, dens, col = "#C8962E", lwd = 2)
    }
    return(invisible(x))
  }
  x
}


#' Graficar densidad con areas de probabilidad
#'
#' Dibuja la funcion de densidad de una distribucion y sombrea opcionalmente
#' el area correspondiente a P(a <= X <= b).
#'
#' @param dist Distribucion: "normal", "t", "chisq", "f", "exponencial",
#'   "gamma", "beta", "uniforme".
#' @param ... Parametros de la distribucion.
#' @param a Limite inferior del area sombreada (default: NULL = sin sombreado).
#' @param b Limite superior del area sombreada (default: NULL = sin sombreado).
#' @param cola "ninguna" (default), "izquierda", "derecha" o "bilateral"
#'   para definir rapido el area de rechazo en pruebas de hipotesis.
#' @param alpha Nivel de significancia para cola (default: 0.05).
#'
#' @return Invisible NULL.
#'
#' @examples
#' graficar_densidad("normal", mean = 0, sd = 1, cola = "bilateral", alpha = 0.05)
#' graficar_densidad("chisq", df = 5, a = 0, b = 7)
#' graficar_densidad("t", df = 10, cola = "derecha", alpha = 0.05)
#'
#' @export
graficar_densidad <- function(dist, ..., a = NULL, b = NULL,
                               cola = "ninguna", alpha = 0.05) {
  args <- list(...)

  # Rango de graficacion
  rango <- switch(dist,
    normal      = do.call(qnorm,  c(list(p = c(0.001, 0.999)), args)),
    t           = do.call(qt,     c(list(p = c(0.001, 0.999)), args)),
    chisq       = c(0, do.call(qchisq, c(list(p = 0.999), args))),
    f           = c(0, do.call(qf,     c(list(p = 0.999), args))),
    exponencial = c(0, do.call(qexp,   c(list(p = 0.999), args))),
    gamma       = c(0, do.call(qgamma, c(list(p = 0.999), args))),
    beta        = c(0.001, 0.999),
    uniforme    = do.call(qunif,  c(list(p = c(0, 1)), args)),
    stop("Distribucion no soportada: ", dist)
  )

  xs    <- seq(rango[1], rango[2], length.out = 500)
  dens_fn <- switch(dist,
    normal      = dnorm, t = dt, chisq = dchisq, f = df,
    exponencial = dexp,  gamma = dgamma, beta = dbeta, uniforme = dunif
  )
  ys <- do.call(dens_fn, c(list(x = xs), args))

  # Determinar cola si se especifica
  if (cola == "izquierda") {
    quant_fn <- switch(dist, normal = qnorm, t = qt, chisq = qchisq,
                       f = qf, exponencial = qexp, gamma = qgamma,
                       beta = qbeta, uniforme = qunif)
    b <- do.call(quant_fn, c(list(p = alpha), args))
    a <- rango[1]
  } else if (cola == "derecha") {
    quant_fn <- switch(dist, normal = qnorm, t = qt, chisq = qchisq,
                       f = qf, exponencial = qexp, gamma = qgamma,
                       beta = qbeta, uniforme = qunif)
    a <- do.call(quant_fn, c(list(p = 1 - alpha), args))
    b <- rango[2]
  } else if (cola == "bilateral") {
    quant_fn <- switch(dist, normal = qnorm, t = qt, chisq = qchisq,
                       f = qf, exponencial = qexp, gamma = qgamma,
                       beta = qbeta, uniforme = qunif)
    c1 <- do.call(quant_fn, c(list(p = alpha / 2), args))
    c2 <- do.call(quant_fn, c(list(p = 1 - alpha / 2), args))
  }

  # Grafico
  plot(xs, ys, type = "l", lwd = 2, col = "#006341",
       xlab = "x", ylab = "f(x)",
       main = paste("Densidad:", dist))

  # Sombrear area
  if (!is.null(a) && !is.null(b) && cola != "bilateral") {
    mask <- xs >= a & xs <= b
    polygon(c(xs[mask][1], xs[mask], xs[mask][sum(mask)]),
            c(0, ys[mask], 0), col = adjustcolor("#C8962E", 0.4), border = NA)
    prob <- diff(do.call(switch(dist,
      normal = pnorm, t = pt, chisq = pchisq, f = pf,
      exponencial = pexp, gamma = pgamma, beta = pbeta, uniforme = punif),
      c(list(q = c(a, b)), args)))
    mtext(paste0("P = ", round(prob, 4)), side = 3, line = 0, cex = 0.9,
          col = "#C8962E")
  }
  if (cola == "bilateral") {
    for (lim in list(c(rango[1], c1), c(c2, rango[2]))) {
      mask <- xs >= lim[1] & xs <= lim[2]
      polygon(c(xs[mask][1], xs[mask], xs[mask][sum(mask)]),
              c(0, ys[mask], 0), col = adjustcolor("#C8962E", 0.4), border = NA)
    }
    mtext(paste0("Zona de rechazo: alpha = ", alpha), side = 3, line = 0,
          cex = 0.9, col = "#C8962E")
  }
  invisible(NULL)
}
