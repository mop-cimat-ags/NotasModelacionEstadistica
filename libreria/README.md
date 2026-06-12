# modelEstCIMAT

Paquete de R de apoyo para el curso **Modelacion Estadistica** de la
Maestria en Optimizacion y Modelacion de Procesos del CIMAT.

## Instalacion y uso en el libro

Desde la raiz del proyecto `NotasModelacionEstadistica/`, carga el
paquete sin instalarlo:

```r
devtools::load_all("libreria")
```

Agrega esta linea al inicio de cualquier capitulo `.qmd` que necesite
las funciones:

```r
devtools::load_all(here::here("libreria"))
```

O mas sencillo, en el `setup` chunk de cada capitulo:

```r
pkgload::load_all(file.path(rprojroot::find_root("_quarto.yml"), "libreria"),
                  quiet = TRUE)
```

## Generar los datasets (una sola vez)

```r
setwd("libreria")
source("data-raw/generar_datos.R")
```

Esto crea los archivos `.rda` en `libreria/data/`.

## Correr los tests

```r
setwd("libreria")
devtools::test()
```

## Funciones incluidas

### Estadisticas descriptivas (`R/estadisticas.R`)
- `resumen_estadistico(x)` — resumen completo: media, mediana, moda, var, CV, asimetria, curtosis
- `tabla_frecuencias(x, k)` — tabla con frecuencias absolutas, relativas y acumuladas
- `coef_variacion(x)` — coeficiente de variacion en %
- `momento_central(x, r)` — momento central de orden r
- `curtosis(x)` — curtosis en exceso (Fisher)
- `asimetria(x)` — coeficiente de asimetria

### Inferencia estadistica (`R/inferencia.R`)
- `ic_media(x, nivel, sigma)` — IC para la media (t de Student o Normal)
- `ic_proporcion(x, n, nivel, metodo)` — IC para proporcion (Wald o Wilson)
- `ic_varianza(x, nivel)` — IC para la varianza (chi-cuadrada)
- `prueba_z(x, mu0, sigma, alternativa)` — prueba Z con varianza conocida
- `emv_normal(x)` — EMV de mu y sigma para distribucion Normal
- `emv_exponencial(x)` — EMV de lambda para distribucion Exponencial
- `emv_poisson(x)` — EMV de lambda para distribucion Poisson
- `graficar_ic(ic)` — grafica un intervalo de confianza

### Simulacion (`R/simulacion.R`)
- `simular_bootstrap(x, FUN, B)` — bootstrap no parametrico
- `simular_ic_bootstrap(x, FUN, B, metodo)` — IC bootstrap (percentil o BCa)
- `monte_carlo_integral(f, a, b, N)` — integracion por Monte Carlo
- `simular_distribucion(dist, n, ...)` — simular + histograma con curva teorica
- `graficar_densidad(dist, ..., cola, alpha)` — densidad con zonas de rechazo

## Datasets incluidos

| Dataset                | n   | Descripcion                          | Distribucion aprox. |
|------------------------|-----|--------------------------------------|---------------------|
| `alturas_estudiantes`  | 80  | Altura y peso de estudiantes         | Normal              |
| `tiempos_falla`        | 60  | Tiempos de falla de componentes      | Exponencial         |
| `calificaciones_curso` | 35  | Calificaciones en 3 examenes         | Normal multivariada |
| `conteos_defectos`     | 50  | Defectos por lote de manufactura     | Poisson             |
| `temperaturas_mensual` | 365 | Temp. max/min diaria en Guanajuato   | Normal + estacional |
