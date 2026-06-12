#' Resumen estadistico completo
#'
#' Calcula un resumen de estadisticas descriptivas para un vector numerico,
#' incluyendo medidas de tendencia central, dispersion y forma.
#'
#' @param x Vector numerico.
#' @param na.rm Logical. Si es TRUE (default), ignora valores NA.
#'
#' @return Lista con media, mediana, moda, varianza, desviacion estandar,
#'   coeficiente de variacion, asimetria, curtosis, minimo, maximo y
#'   cuartiles.
#'
#' @examples
#' x <- c(2, 4, 4, 4, 5, 5, 7, 9)
#' resumen_estadistico(x)
#'
#' @export
resumen_estadistico <- function(x, na.rm = TRUE) {
  if (na.rm) x <- x[!is.na(x)]
  n  <- length(x)
  mu <- mean(x)
  s  <- sd(x)

  # Moda (puede haber mas de una)
  freq  <- table(x)
  moda  <- as.numeric(names(freq)[freq == max(freq)])

  list(
    n                   = n,
    media               = mu,
    mediana             = median(x),
    moda                = moda,
    varianza            = var(x),
    desv_estandar       = s,
    coef_variacion      = s / mu * 100,
    asimetria           = asimetria(x),
    curtosis            = curtosis(x),
    minimo              = min(x),
    maximo              = max(x),
    Q1                  = quantile(x, 0.25),
    Q3                  = quantile(x, 0.75),
    rango_intercuartil  = IQR(x)
  )
}


#' Tabla de frecuencias
#'
#' Construye una tabla de frecuencias absolutas, relativas y acumuladas
#' para datos discretos o continuos agrupados en clases.
#'
#' @param x Vector numerico.
#' @param k Numero de clases. Si es NULL (default) se usa la regla de Sturges.
#' @param porcentaje Logical. Si es TRUE agrega columna de porcentaje (default FALSE).
#'
#' @return Data frame con columnas: clase, frec_abs, frec_rel, frec_abs_acum,
#'   frec_rel_acum (y porcentaje si se solicita).
#'
#' @examples
#' set.seed(1)
#' x <- rnorm(50, mean = 10, sd = 2)
#' tabla_frecuencias(x, k = 6)
#'
#' @export
tabla_frecuencias <- function(x, k = NULL, porcentaje = FALSE) {
  if (is.null(k)) k <- ceiling(1 + log2(length(x)))  # Sturges
  breaks <- seq(min(x), max(x), length.out = k + 1)
  cortes <- cut(x, breaks = breaks, include.lowest = TRUE, right = FALSE)
  fa  <- as.vector(table(cortes))
  fr  <- fa / length(x)
  faa <- cumsum(fa)
  fra <- cumsum(fr)

  df <- data.frame(
    clase         = levels(cortes),
    frec_abs      = fa,
    frec_rel      = round(fr,  4),
    frec_abs_acum = faa,
    frec_rel_acum = round(fra, 4),
    stringsAsFactors = FALSE
  )
  if (porcentaje) df$porcentaje <- round(fr * 100, 2)
  df
}


#' Coeficiente de variacion
#'
#' Calcula el coeficiente de variacion (desviacion estandar / media * 100),
#' util para comparar la dispersion relativa entre distintos grupos.
#'
#' @param x Vector numerico con media distinta de cero.
#' @param na.rm Logical. Si es TRUE (default), ignora valores NA.
#'
#' @return Numero: coeficiente de variacion en porcentaje.
#'
#' @examples
#' coef_variacion(c(10, 12, 11, 13, 9))
#'
#' @export
coef_variacion <- function(x, na.rm = TRUE) {
  if (na.rm) x <- x[!is.na(x)]
  mu <- mean(x)
  if (abs(mu) < .Machine$double.eps)
    stop("La media es cero; el coeficiente de variacion no esta definido.")
  sd(x) / mu * 100
}


#' Momento central de orden r
#'
#' Calcula el r-esimo momento central de una muestra: E[(X - mu)^r].
#'
#' @param x Vector numerico.
#' @param r Entero positivo. Orden del momento.
#' @param na.rm Logical. Si es TRUE (default), ignora valores NA.
#'
#' @return Numero: momento central de orden r.
#'
#' @examples
#' x <- c(2, 4, 4, 4, 5, 5, 7, 9)
#' momento_central(x, r = 3)
#'
#' @export
momento_central <- function(x, r, na.rm = TRUE) {
  if (na.rm) x <- x[!is.na(x)]
  mean((x - mean(x))^r)
}


#' Coeficiente de curtosis (Fisher)
#'
#' Devuelve la curtosis en exceso (tipo Fisher): kurt = m4/s^4 - 3.
#' Un valor positivo indica distribucion leptocurtica; negativo, platicurtica.
#'
#' @param x Vector numerico.
#' @param na.rm Logical. Si es TRUE (default), ignora valores NA.
#'
#' @return Numero: curtosis en exceso.
#'
#' @examples
#' curtosis(rnorm(1000))   # aproximadamente 0
#' curtosis(runif(1000))   # aproximadamente -1.2 (platicurtica)
#'
#' @export
curtosis <- function(x, na.rm = TRUE) {
  if (na.rm) x <- x[!is.na(x)]
  n  <- length(x)
  m4 <- mean((x - mean(x))^4)
  s4 <- var(x)^2
  m4 / s4 - 3
}


#' Coeficiente de asimetria (Fisher)
#'
#' Devuelve el coeficiente de asimetria estandarizado: skew = m3/s^3.
#' Valor positivo indica cola larga a la derecha; negativo, a la izquierda.
#'
#' @param x Vector numerico.
#' @param na.rm Logical. Si es TRUE (default), ignora valores NA.
#'
#' @return Numero: coeficiente de asimetria.
#'
#' @examples
#' asimetria(rnorm(1000))          # aprox. 0
#' asimetria(rexp(1000, rate = 1)) # positivo (sesgo derecho)
#'
#' @export
asimetria <- function(x, na.rm = TRUE) {
  if (na.rm) x <- x[!is.na(x)]
  m3 <- mean((x - mean(x))^3)
  s3 <- sd(x)^3
  m3 / s3
}
