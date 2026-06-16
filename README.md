# Modelación Estadística — Notas del Curso

<div align="center">

![Logo CIMAT](imagenes/logo-cimat.png)

**Maestría en Optimización y Modelación de Procesos**  
Centro de Investigación en Matemáticas, A.C. — Unidad Aguascalientes

[![Publicar libro](https://github.com/mop-cimat-ags/NotasModelacionEstadistica/actions/workflows/publish.yml/badge.svg)](https://github.com/mop-cimat-ags/NotasModelacionEstadistica/actions/workflows/publish.yml)
[![Libro en línea](https://img.shields.io/badge/Libro-En%20l%C3%ADnea-006341)](https://mop-cimat-ags.github.io/NotasModelacionEstadistica)

</div>

---

## Descripción

Notas del curso **Modelación Estadística** de la Maestría OMP del CIMAT Aguascalientes, publicadas como libro interactivo con [Quarto](https://quarto.org). El libro está disponible en tres formatos:

- **HTML** (libro en línea): https://mop-cimat-ags.github.io/NotasModelacionEstadistica
- **PDF**: descargable desde la página de inicio del libro
- **Word (.docx)**: descargable desde la página de inicio del libro

---

## Catedráticos colaboradores

| Nombre | Correo |
|---|---|
| Dr. Sergio M. Nava Muñoz | nava@cimat.mx |
| Dr. Magin Zúñiga Estrada | magin.zuniga@cimat.mx |
| Dr. Humberto Martínez Bautista | humberto.martinez@cimat.mx |

**Compilación y edición del repositorio:** Vladimir Jiménez Pérez (alumno) — vladimir.jimenez@cimat.mx

---

## Estructura del proyecto

```
NotasModelacionEstadistica/
│
├── 📄 _quarto.yml              # Configuración principal del libro
├── 📄 _quarto-pdf.yml          # Perfil para renderizar solo PDF
├── 📄 _quarto-docx.yml         # Perfil para renderizar solo Word
├── 📄 index.qmd                # Página de inicio del libro
├── 📄 referencias.qmd          # Capítulo de bibliografía
├── 📄 referencias.bib          # Referencias en formato BibTeX
├── 📄 estilos-cimat.css        # Estilos visuales del libro (HTML)
├── 📄 GUIA_COLABORADORES.md    # Guía para catedráticos colaboradores
│
├── 📁 imagenes/
│   └── logo-cimat.png
│
├── 📁 latex/                   # Archivos para el formato PDF
│   ├── preamble.tex            # Preámbulo LaTeX (colores, macros)
│   ├── portada.tex             # Portada del PDF
│   └── portada-docx.md         # Portada del Word (OpenXML)
│
├── 📁 capitulos/
│   ├── parte1/                 # Parte I — Probabilidad y Distribuciones
│   │   ├── cap01-intro-estadistica.qmd
│   │   ├── cap02-distribuciones.qmd
│   │   └── cap03-distribucion-conjunta.qmd
│   └── parte2/                 # Parte II — Inferencia Estadística
│       └── cap04-inferencia.qmd
│
├── 📁 libreria/                # Paquete R: modelEstCIMAT
│   ├── DESCRIPTION
│   ├── NAMESPACE
│   ├── LICENSE
│   ├── README.md               # Documentación de la librería
│   ├── R/
│   │   ├── estadisticas.R      # Funciones descriptivas
│   │   ├── inferencia.R        # IC, pruebas, EMV
│   │   ├── simulacion.R        # Bootstrap, Monte Carlo
│   │   └── datos.R             # Documentación de datasets
│   ├── data/                   # Datasets compilados (.rda)
│   ├── data-raw/
│   │   └── generar_datos.R     # Script para generar los datasets
│   └── tests/testthat/         # Pruebas unitarias
│
└── 📁 .github/
    └── workflows/
        └── publish.yml         # CI/CD — publica automáticamente en Pages
```

---

## Contenido del libro

### Parte I — Probabilidad y Distribuciones

| Capítulo | Tema |
|---|---|
| Cap. 1 | Introducción a la Estadística |
| Cap. 2 | Distribuciones de Probabilidad |
| Cap. 3 | Distribución Conjunta |

### Parte II — Inferencia Estadística

| Capítulo | Tema |
|---|---|
| Cap. 4 | Inferencia Estadística |

---

## Requisitos

| Herramienta | Versión mínima | Descarga |
|---|---|---|
| R | 4.1 | https://cran.r-project.org |
| Quarto | 1.4 | https://quarto.org/docs/get-started |
| Git | cualquiera | https://git-scm.com/download/win |
| TinyTeX (para PDF) | — | se instala automáticamente con Quarto |

### Paquetes de R necesarios

```r
install.packages(c("knitr", "rmarkdown", "devtools"),
                 repos = "https://cloud.r-project.org")
```

---

## Inicio rápido

### 1. Clonar el repositorio

```bash
git clone https://github.com/mop-cimat-ags/NotasModelacionEstadistica.git
cd NotasModelacionEstadistica
```

### 2. Generar los datasets de la librería (solo la primera vez)

```r
setwd("libreria")
source("data-raw/generar_datos.R")
setwd("..")
```

### 3. Previsualizar el libro

```bash
quarto preview
```

### 4. Renderizar todos los formatos

```bash
quarto render
```

El resultado queda en `_book/`.

### Renderizar un formato específico

```bash
quarto render --profile pdf   # solo PDF  → _book-pdf/
quarto render --profile docx  # solo Word → _book-docx/
```

---

## Librería R: modelEstCIMAT

El proyecto incluye un paquete de R con funciones y datasets de apoyo
para los capítulos del curso. Se carga sin necesidad de instalación:

```r
devtools::load_all("libreria")
```

### Funciones disponibles

```r
# Estadística descriptiva
resumen_estadistico(x)
tabla_frecuencias(x, k = 6)
curtosis(x)
asimetria(x)

# Inferencia
ic_media(x, nivel = 0.95)
ic_proporcion(x = 30, n = 100)
emv_normal(x)
prueba_z(x, mu0 = 0, sigma = 1)

# Simulación
simular_distribucion("normal", n = 500, mean = 0, sd = 1)
simular_bootstrap(x, FUN = mean, B = 1000)
monte_carlo_integral(function(x) x^2, a = 0, b = 1)
graficar_densidad("t", df = 10, cola = "bilateral", alpha = 0.05)
```

### Datasets disponibles

```r
data(alturas_estudiantes)   # n = 80  — altura y peso de estudiantes
data(tiempos_falla)         # n = 60  — tiempos de falla (Exponencial)
data(calificaciones_curso)  # n = 35  — tres exámenes correlacionados
data(conteos_defectos)      # n = 50  — defectos por lote (Poisson)
data(temperaturas_mensual)  # n = 365 — temperaturas diarias Guanajuato
```

Consulta `libreria/README.md` para documentación completa.

---

## Publicación automática

Cada vez que se hace `git push` a la rama `main`, GitHub Actions:

1. Instala R, Quarto y TinyTeX
2. Renderiza el libro en HTML, PDF y Word
3. Publica el HTML en GitHub Pages automáticamente

El estado del último build se muestra en el badge al inicio de este README.  
Logs detallados: https://github.com/mop-cimat-ags/NotasModelacionEstadistica/actions

---

## Cómo colaborar

Para agregar o editar contenido, revisa la **[Guía para Colaboradores](GUIA_COLABORADORES.md)**, que cubre:

- Instalación de herramientas
- Clonar el repositorio y configurar Git
- Editar y crear capítulos en Quarto
- Sintaxis básica de Quarto (ecuaciones, código R, figuras, teoremas)
- Agregar funciones y datasets a la librería
- Flujo de trabajo con ramas (branches) y Pull Requests

---

## Colores institucionales

| Color | HEX | Uso |
|---|---|---|
| Verde CIMAT | `#006341` | Gráficos, elementos destacados |
| Verde oscuro | `#004D31` | Títulos, encabezados |
| Dorado CIMAT | `#C8962E` | Acentos, estimadores |

---

## Licencia

MIT © Dr. Sergio M. Nava Muñoz, Dr. Magin Zúñiga Estrada, Dr. Humberto Martínez Bautista — Maestría OMP, CIMAT Unidad Aguascalientes
