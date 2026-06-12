# Script para generar y guardar los datasets del paquete modelEstCIMAT
# Ejecutar una vez con: source("data-raw/generar_datos.R")
# Requiere que el directorio de trabajo sea la raiz del paquete (libreria/)

# ── 1. alturas_estudiantes ────────────────────────────────────────────────────
# Alturas simuladas de estudiantes de maestria (en cm)
# Util para: estadistica descriptiva, IC para la media, pruebas de normalidad
set.seed(2024)
n_est <- 80
alturas_estudiantes <- data.frame(
  id       = 1:n_est,
  altura   = round(rnorm(n_est, mean = 168, sd = 8), 1),
  peso     = round(rnorm(n_est, mean = 68,  sd = 12), 1),
  genero   = sample(c("M", "F"), n_est, replace = TRUE, prob = c(0.55, 0.45)),
  programa = sample(c("OMP", "Estadistica", "Computo"), n_est,
                    replace = TRUE, prob = c(0.5, 0.3, 0.2))
)
save(alturas_estudiantes, file = "data/alturas_estudiantes.rda")
cat("Dataset 'alturas_estudiantes' guardado.\n")


# ── 2. tiempos_falla ──────────────────────────────────────────────────────────
# Tiempos hasta la falla de componentes electronicos (horas)
# Distribucion exponencial; util para: EMV, IC, distribucion exponencial
set.seed(42)
n_falla <- 60
tiempos_falla <- data.frame(
  componente = paste0("C", sprintf("%03d", 1:n_falla)),
  horas      = round(rexp(n_falla, rate = 1 / 500), 2),  # media = 500 h
  lote       = sample(c("A", "B", "C"), n_falla, replace = TRUE)
)
save(tiempos_falla, file = "data/tiempos_falla.rda")
cat("Dataset 'tiempos_falla' guardado.\n")


# ── 3. calificaciones_curso ───────────────────────────────────────────────────
# Calificaciones de 3 examenes en un grupo de 35 estudiantes
# Util para: correlacion, distribucion conjunta, pruebas de hipotesis
set.seed(7)
n_cal <- 35
mu    <- c(75, 78, 80)
Sigma <- matrix(c(100, 60, 50,
                   60, 81, 55,
                   50, 55, 64), nrow = 3)
# Simular con correlacion usando Cholesky
L   <- chol(Sigma)
Z   <- matrix(rnorm(n_cal * 3), nrow = n_cal)
cal <- sweep(Z %*% L, 2, mu, "+")
cal <- pmax(pmin(round(cal), 100), 40)  # truncar a [40, 100]
calificaciones_curso <- data.frame(
  alumno  = paste0("A", sprintf("%02d", 1:n_cal)),
  examen1 = cal[, 1],
  examen2 = cal[, 2],
  examen3 = cal[, 3]
)
save(calificaciones_curso, file = "data/calificaciones_curso.rda")
cat("Dataset 'calificaciones_curso' guardado.\n")


# ── 4. conteos_defectos ───────────────────────────────────────────────────────
# Numero de defectos por lote de 100 piezas en un proceso de manufactura
# Distribucion Poisson; util para: EMV Poisson, pruebas de bondad de ajuste
set.seed(15)
conteos_defectos <- data.frame(
  lote     = 1:50,
  defectos = rpois(50, lambda = 2.3),
  turno    = sample(c("matutino", "vespertino", "nocturno"),
                    50, replace = TRUE, prob = c(0.4, 0.35, 0.25))
)
save(conteos_defectos, file = "data/conteos_defectos.rda")
cat("Dataset 'conteos_defectos' guardado.\n")


# ── 5. temperaturas_mensual ───────────────────────────────────────────────────
# Temperatura maxima diaria (grados C) durante 365 dias en Guanajuato
# Util para: series de tiempo sencillas, estadistica descriptiva, histogramas
set.seed(99)
dia_del_anio <- 1:365
temp_base <- 20 + 8 * sin(2 * pi * (dia_del_anio - 80) / 365)
temperaturas_mensual <- data.frame(
  dia        = dia_del_anio,
  mes        = as.integer(ceiling(dia_del_anio / 30.44)),
  temp_max   = round(temp_base + rnorm(365, 0, 2.5), 1),
  temp_min   = round(temp_base - 8 + rnorm(365, 0, 2), 1)
)
temperaturas_mensual$mes <- pmin(temperaturas_mensual$mes, 12)
save(temperaturas_mensual, file = "data/temperaturas_mensual.rda")
cat("Dataset 'temperaturas_mensual' guardado.\n")


cat("\nTodos los datasets generados correctamente en data/\n")
