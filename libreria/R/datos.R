#' Alturas y pesos de estudiantes
#'
#' Dataset simulado con medidas antropometricas de 80 estudiantes de
#' posgrado. Util para practicar estadistica descriptiva, intervalos de
#' confianza para la media y comparacion entre grupos.
#'
#' @format Data frame con 80 filas y 5 columnas:
#' \describe{
#'   \item{id}{Identificador del estudiante (entero).}
#'   \item{altura}{Altura en centimetros (numerico).}
#'   \item{peso}{Peso en kilogramos (numerico).}
#'   \item{genero}{Genero: "M" o "F" (caracter).}
#'   \item{programa}{Programa de maestria: "OMP", "Estadistica" o "Computo".}
#' }
#' @source Datos simulados para el curso de Modelacion Estadistica, CIMAT.
#' @examples
#' data(alturas_estudiantes)
#' resumen_estadistico(alturas_estudiantes$altura)
"alturas_estudiantes"


#' Tiempos de falla de componentes electronicos
#'
#' Tiempos hasta la falla (en horas) de 60 componentes electronicos.
#' Siguen aproximadamente una distribucion exponencial con media 500 horas.
#' Util para ajuste de distribucion exponencial y calculo de EMV.
#'
#' @format Data frame con 60 filas y 3 columnas:
#' \describe{
#'   \item{componente}{Codigo del componente (caracter).}
#'   \item{horas}{Tiempo hasta la falla en horas (numerico).}
#'   \item{lote}{Lote de produccion: "A", "B" o "C" (caracter).}
#' }
#' @source Datos simulados para el curso de Modelacion Estadistica, CIMAT.
#' @examples
#' data(tiempos_falla)
#' emv_exponencial(tiempos_falla$horas)
"tiempos_falla"


#' Calificaciones de examenes
#'
#' Calificaciones de 35 estudiantes en tres examenes parciales.
#' Las calificaciones estan correlacionadas entre si. Util para analisis
#' de distribucion conjunta, correlacion y regresion simple.
#'
#' @format Data frame con 35 filas y 4 columnas:
#' \describe{
#'   \item{alumno}{Codigo del alumno (caracter).}
#'   \item{examen1}{Calificacion del primer examen, escala 0-100 (entero).}
#'   \item{examen2}{Calificacion del segundo examen, escala 0-100 (entero).}
#'   \item{examen3}{Calificacion del tercer examen, escala 0-100 (entero).}
#' }
#' @source Datos simulados para el curso de Modelacion Estadistica, CIMAT.
#' @examples
#' data(calificaciones_curso)
#' cor(calificaciones_curso[, 2:4])
"calificaciones_curso"


#' Conteos de defectos en manufactura
#'
#' Numero de defectos encontrados en 50 lotes de 100 piezas cada uno.
#' Los conteos siguen aproximadamente una distribucion Poisson(2.3).
#' Util para el ajuste de la distribucion Poisson y EMV.
#'
#' @format Data frame con 50 filas y 3 columnas:
#' \describe{
#'   \item{lote}{Numero de lote (entero).}
#'   \item{defectos}{Numero de defectos encontrados (entero).}
#'   \item{turno}{Turno de produccion: "matutino", "vespertino" o "nocturno".}
#' }
#' @source Datos simulados para el curso de Modelacion Estadistica, CIMAT.
#' @examples
#' data(conteos_defectos)
#' emv_poisson(conteos_defectos$defectos)
"conteos_defectos"


#' Temperaturas diarias en Guanajuato
#'
#' Temperatura maxima y minima diaria (en grados Celsius) durante 365 dias
#' en Guanajuato. Presenta una tendencia estacional sinusoidal con ruido
#' aleatorio. Util para estadistica descriptiva por mes y visualizacion.
#'
#' @format Data frame con 365 filas y 4 columnas:
#' \describe{
#'   \item{dia}{Dia del anio (1 a 365).}
#'   \item{mes}{Mes (1 a 12).}
#'   \item{temp_max}{Temperatura maxima del dia en grados C (numerico).}
#'   \item{temp_min}{Temperatura minima del dia en grados C (numerico).}
#' }
#' @source Datos simulados para el curso de Modelacion Estadistica, CIMAT.
#' @examples
#' data(temperaturas_mensual)
#' tapply(temperaturas_mensual$temp_max, temperaturas_mensual$mes, mean)
"temperaturas_mensual"
