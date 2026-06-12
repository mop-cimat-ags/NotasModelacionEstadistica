#' Intervalo de confianza para la media
#'
#' Calcula un intervalo de confianza para la media poblacional usando la
#' distribucion t de Student (varianza desconocida) o normal (varianza conocida).
#'
#' @param x Vector numerico con la muestra.
#' @param nivel Nivel de confianza, entre 0 y 1 (default: 0.95).
#' @param sigma Desviacion estandar poblacional conocida. Si es NULL (default),
#'   se usa la t de Student con varianza estimada.
#'
#' @return Lista con: estimador, error_estandar, margen_error, limite_inferior,
#'   limite_superior, nivel_confianza, n, y distribucion usada.
#'
#' @examples
#' set.seed(42)
#' x <- rnorm(30, mean = 5, sd = 2)
#' ic_media(x)
#' ic_media(x, nivel = 0.99)
#' ic_media(x, sigma = 2)  # varianza conocida
#'
#' @export
ic_media <- function(x, nivel = 0.95, sigma = NULL) {
  x  <- x[!is.na(x)]
  n  <- length(x)
  mu <- mean(x)
  alpha <- 1 - nivel

  if (is.null(sigma)) {
    se <- sd(x) / sqrt(n)
    tc <- qt(1 - alpha / 2, df = n - 1)
    dist <- paste0("t(", n - 1, ")")
  } else {
    se <- sigma / sqrt(n)
    tc <- qnorm(1 - alpha / 2)
    dist <- "Normal"
  }

  me <- tc * se
  list(
    estimador       = mu,
    error_estandar  = se,
    valor_critico   = tc,
    margen_error    = me,
    limite_inferior = mu - me,
    limite_superior = mu + me,
    nivel_confianza = nivel,
    n               = n,
    distribucion    = dist
  )
}


#' Intervalo de confianza para una proporcion
#'
#' Calcula el IC para una proporcion poblacional usando la aproximacion
#' normal (Wilson o Wald).
#'
#' @param x Numero de exitos, o vector logico/0-1.
#' @param n Tamano de muestra (solo si x es un conteo).
#' @param nivel Nivel de confianza (default: 0.95).
#' @param metodo "wald" (default) o "wilson".
#'
#' @return Lista con: p_hat, margen_error, limite_inferior, limite_superior,
#'   nivel_confianza, n, metodo.
#'
#' @examples
#' ic_proporcion(x = 45, n = 100)
#' ic_proporcion(x = c(1,0,1,1,0,1), metodo = "wilson")
#'
#' @export
ic_proporcion <- function(x, n = NULL, nivel = 0.95, metodo = "wald") {
  if (is.null(n)) {
    n <- length(x)
    p <- mean(x)
  } else {
    p <- x / n
  }
  alpha <- 1 - nivel
  z <- qnorm(1 - alpha / 2)

  if (metodo == "wilson") {
    # IC de Wilson
    centro <- (p + z^2 / (2 * n)) / (1 + z^2 / n)
    margen <- z * sqrt(p * (1 - p) / n + z^2 / (4 * n^2)) / (1 + z^2 / n)
    li <- centro - margen
    ls <- centro + margen
    me <- margen
  } else {
    # IC de Wald
    me <- z * sqrt(p * (1 - p) / n)
    li <- p - me
    ls <- p + me
  }

  list(
    p_hat           = p,
    margen_error    = me,
    limite_inferior = max(0, li),
    limite_superior = min(1, ls),
    nivel_confianza = nivel,
    n               = n,
    metodo          = metodo
  )
}


#' Intervalo de confianza para la varianza
#'
#' Calcula el IC para la varianza poblacional usando la distribucion chi-cuadrada,
#' asumiendo normalidad.
#'
#' @param x Vector numerico con la muestra.
#' @param nivel Nivel de confianza (default: 0.95).
#'
#' @return Lista con: s2 (varianza muestral), limite_inferior, limite_superior,
#'   nivel_confianza, n.
#'
#' @examples
#' set.seed(1)
#' x <- rnorm(20, sd = 3)
#' ic_varianza(x)
#'
#' @export
ic_varianza <- function(x, nivel = 0.95) {
  x  <- x[!is.na(x)]
  n  <- length(x)
  s2 <- var(x)
  alpha <- 1 - nivel
  chi_inf <- qchisq(alpha / 2,     df = n - 1)
  chi_sup <- qchisq(1 - alpha / 2, df = n - 1)

  list(
    s2              = s2,
    limite_inferior = (n - 1) * s2 / chi_sup,
    limite_superior = (n - 1) * s2 / chi_inf,
    nivel_confianza = nivel,
    n               = n
  )
}


#' Prueba Z para la media
#'
#' Realiza una prueba de hipotesis Z para la media cuando la varianza
#' poblacional es conocida.
#'
#' @param x Vector numerico con la muestra.
#' @param mu0 Valor hipotetizado de la media bajo H0 (default: 0).
#' @param sigma Desviacion estandar poblacional conocida.
#' @param alternativa "bilateral" (default), "mayor" o "menor".
#' @param alpha Nivel de significancia (default: 0.05).
#'
#' @return Lista con: estadistico_z, valor_p, decision, mu0, x_barra, n.
#'
#' @examples
#' set.seed(7)
#' x <- rnorm(40, mean = 10.5, sd = 2)
#' prueba_z(x, mu0 = 10, sigma = 2)
#'
#' @export
prueba_z <- function(x, mu0 = 0, sigma, alternativa = "bilateral", alpha = 0.05) {
  x     <- x[!is.na(x)]
  n     <- length(x)
  x_bar <- mean(x)
  z     <- (x_bar - mu0) / (sigma / sqrt(n))

  valor_p <- switch(alternativa,
    bilateral = 2 * pnorm(-abs(z)),
    mayor     = pnorm(z, lower.tail = FALSE),
    menor     = pnorm(z)
  )

  list(
    estadistico_z = z,
    valor_p       = valor_p,
    decision      = ifelse(valor_p < alpha, "Rechazar H0", "No rechazar H0"),
    mu0           = mu0,
    x_barra       = x_bar,
    sigma         = sigma,
    n             = n,
    alternativa   = alternativa,
    alpha         = alpha
  )
}


#' Estimador de maxima verosimilitud - Normal
#'
#' Calcula los EMV de mu y sigma para una muestra iid Normal.
#'
#' @param x Vector numerico.
#'
#' @return Lista con mu_emv (media muestral) y sigma_emv (desv. estandar con n).
#'
#' @examples
#' set.seed(5)
#' emv_normal(rnorm(50, mean = 3, sd = 1.5))
#'
#' @export
emv_normal <- function(x) {
  x <- x[!is.na(x)]
  n <- length(x)
  list(
    mu_emv    = mean(x),
    sigma_emv = sqrt(sum((x - mean(x))^2) / n),   # sesgo: divide entre n
    sigma_insesgado = sd(x)                         # para comparacion
  )
}


#' Estimador de maxima verosimilitud - Exponencial
#'
#' Calcula el EMV del parametro de tasa lambda = 1/media para
#' una muestra iid Exponencial.
#'
#' @param x Vector numerico positivo.
#'
#' @return Lista con lambda_emv y media_emv (= 1/lambda).
#'
#' @examples
#' set.seed(3)
#' emv_exponencial(rexp(100, rate = 0.5))
#'
#' @export
emv_exponencial <- function(x) {
  x <- x[x > 0 & !is.na(x)]
  lambda <- 1 / mean(x)
  list(lambda_emv = lambda, media_emv = 1 / lambda)
}


#' Estimador de maxima verosimilitud - Poisson
#'
#' Calcula el EMV del parametro lambda para una muestra iid Poisson.
#' El EMV es simplemente la media muestral.
#'
#' @param x Vector de enteros no negativos.
#'
#' @return Lista con lambda_emv.
#'
#' @examples
#' set.seed(9)
#' emv_poisson(rpois(80, lambda = 3))
#'
#' @export
emv_poisson <- function(x) {
  x <- x[!is.na(x)]
  list(lambda_emv = mean(x))
}


#' Graficar intervalo de confianza
#'
#' Visualiza un IC generado por ic_media() o ic_proporcion() mostrando
#' el estimador, el margen de error y los limites.
#'
#' @param ic Lista devuelta por ic_media() o ic_proporcion().
#' @param parametro Nombre del parametro (para el titulo del grafico).
#'
#' @return Grafico base de R (invisible NULL).
#'
#' @examples
#' set.seed(1)
#' ic <- ic_media(rnorm(30, 5, 2))
#' graficar_ic(ic, parametro = "mu")
#'
#' @export
graficar_ic <- function(ic, parametro = "parametro") {
  est <- ic[[1]]  # primer elemento es siempre el estimador
  li  <- ic$limite_inferior
  ls  <- ic$limite_superior
  niv <- ic$nivel_confianza

  old_par <- par(mar = c(4, 1, 3, 1))
  on.exit(par(old_par))

  plot(NULL, xlim = c(li - (ls - li) * 0.3, ls + (ls - li) * 0.3),
       ylim = c(0.5, 1.5), yaxt = "n", bty = "n",
       xlab = parametro,
       main = paste0("IC ", niv * 100, "% para ", parametro))

  # Linea del IC
  lines(c(li, ls), c(1, 1), lwd = 3, col = "#006341")
  # Extremos
  points(c(li, ls), c(1, 1), pch = "|", cex = 2, col = "#006341")
  # Estimador puntual
  points(est, 1, pch = 19, cex = 1.8, col = "#C8962E")

  # Etiquetas
  text(li,  1, labels = round(li,  3), pos = 3, cex = 0.85)
  text(ls,  1, labels = round(ls,  3), pos = 3, cex = 0.85)
  text(est, 1, labels = round(est, 3), pos = 1, cex = 0.85, col = "#C8962E")

  legend("topright", legend = c("Estimador", "IC"),
         col = c("#C8962E", "#006341"), lty = c(NA, 1),
         pch = c(19, NA), lwd = c(NA, 3), bty = "n", cex = 0.85)
  invisible(NULL)
}
