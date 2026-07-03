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


#' Precios de vivienda en Aguascalientes (2504_Casas)
#'
#' Precios y caracteristicas de 26 casas en Aguascalientes, Mexico.
#' Usado en el Capitulo 5 para ilustrar regresion lineal multiple,
#' seleccion de variables y diagnostico de residuos.
#'
#' @format Data frame con 26 filas y 13 columnas:
#' \describe{
#'   \item{Id}{Identificador de la casa (entero).}
#'   \item{RECAM}{Numero de recamaras (entero).}
#'   \item{AREA}{Area construida en metros cuadrados (numerico).}
#'   \item{CHIM}{Presencia de chimenea: 0/1 (entero).}
#'   \item{CUARTOS}{Numero total de cuartos (entero).}
#'   \item{CONTRAV}{Numero de contraventanas (entero).}
#'   \item{LONGFR}{Longitud del frente en metros (numerico).}
#'   \item{BANOS}{Numero de banos (numerico).}
#'   \item{CON}{Indicador de construccion especial: 0/1 (entero).}
#'   \item{COCH}{Cochera: 0/1 (entero).}
#'   \item{COND}{Condominios en el conjunto: 0/1 (entero).}
#'   \item{ZONA}{Zona de la ciudad: 1=Norte, 2=Centro, 3=Sur (entero).}
#'   \item{PRECIO}{Precio de venta en miles de pesos (numerico).}
#' }
#' @source Datos reales de proyectos de vinculacion, CIMAT 2025.
#' @examples
#' data(casas)
#' lm(PRECIO ~ AREA + ZONA + COCH, data = casas)
"casas"


#' Especificaciones de automoviles 1993 (Autos)
#'
#' Especificaciones tecnicas y precios de 93 modelos de automoviles
#' del ano 1993. Dataset clasico del paquete MASS de R, usado en el
#' Capitulo 6 para Analisis Exploratorio de Datos (EDA) y correlacion.
#'
#' @format Data frame con 93 filas y 27 columnas: identificacion
#'   (Manufacturer, Model, Type, Origin, Make), precios
#'   (Min.Price, Price, Max.Price), desempeno
#'   (MPG.city, MPG.highway, Horsepower, RPM, EngineSize, Cylinders),
#'   dimensiones (Length, Wheelbase, Width, Weight, Turn.circle,
#'   Rear.seat.room, Luggage.room) y equipamiento
#'   (AirBags, DriveTrain, Man.trans.avail, Fuel.tank.capacity, Passengers).
#' @source Lock et al. (1993). StatLib. Adaptado para el curso de
#'   Modelacion Estadistica, CIMAT 2025.
#' @examples
#' data(autos)
#' cor(autos[, c("Price", "Horsepower", "Weight")], use = "complete.obs")
"autos"


#' Automoviles 1993 sin valores atipicos (transformacion logaritmica)
#'
#' Version del dataset \code{autos} con 90 observaciones tras eliminar
#' valores atipicos detectados visualmente y con tres variables adicionales
#' en escala logaritmica para linealizar relaciones antes de regresion.
#'
#' @format Data frame con 90 filas y 30 columnas: las 27 de \code{autos}
#'   mas:
#' \describe{
#'   \item{log_MPG_city}{Logaritmo natural de MPG.city.}
#'   \item{log_Min.Precio}{Logaritmo natural de Min.Price.}
#'   \item{log_Weight}{Logaritmo natural de Weight.}
#' }
#' @source Derivado de \code{autos}; transformaciones aplicadas para el
#'   Capitulo 6 de Modelacion Estadistica, CIMAT 2025.
#' @examples
#' data(autos_log)
#' lm(log_MPG_city ~ log_Weight, data = autos_log)
"autos_log"
