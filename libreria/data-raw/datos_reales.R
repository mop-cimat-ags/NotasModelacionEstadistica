# ============================================================
# datos_reales.R
# Genera los .rds de datasets reales para el paquete modelEstCIMAT.
# Ejecutar UNA VEZ desde la raiz del proyecto
# (NotasModelacionEstadistica/) con:
#
#   source("libreria/data-raw/datos_reales.R")
#
# Requiere: readxl
# ============================================================

library(readxl)

out <- "libreria/data"

# -- Casas (precios de vivienda) ------------------------------------------
casas <- read_excel("DataSets/2504_Casas/Casas.xlsx")
casas$ZONA <- as.integer(casas$ZONA)
saveRDS(casas, file = file.path(out, "casas.rds"))
cat("casas.rds:", nrow(casas), "x", ncol(casas), "\n")

# -- Autos (especificaciones 1993) ----------------------------------------
autos <- read.csv("DataSets/Autos/autos.csv",
                  check.names = FALSE, encoding = "UTF-8")
names(autos)[1] <- gsub("﻿", "", names(autos)[1])
saveRDS(autos, file = file.path(out, "autos.rds"))
cat("autos.rds:", nrow(autos), "x", ncol(autos), "\n")

# -- Autos sin outliers (log-transformado) --------------------------------
autos_log <- read.csv("DataSets/Autos/Autos_sin_otliersylogs.csv",
                      check.names = FALSE, encoding = "UTF-8")
names(autos_log)[1] <- gsub("﻿", "", names(autos_log)[1])
saveRDS(autos_log, file = file.path(out, "autos_log.rds"))
cat("autos_log.rds:", nrow(autos_log), "x", ncol(autos_log), "\n")

cat("\nListo. Haz commit de libreria/data/*.rds\n")
