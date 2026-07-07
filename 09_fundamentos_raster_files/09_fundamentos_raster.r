# ==============================================================================
# Evaluación 18.7 - Fundamentos Raster
# Programación SIG: R
# ==============================================================================

# ------------------------------------------------------------------------------
# Cargar la biblioteca principal para procesamiento raster
# ------------------------------------------------------------------------------

library(terra)

# ------------------------------------------------------------------------------
# Ruta del Modelo Digital de Elevación (MDE)
#

# ------------------------------------------------------------------------------

ruta_raster <- "data/heavy/raster/bogota.tif"

# ------------------------------------------------------------------------------
# APERTURA DEL RASTER
# ------------------------------------------------------------------------------
#
# La función rast() implementa un modelo de lectura diferida (lazy loading).
#
# Durante esta instrucción terra NO carga los millones de valores del raster.
# Solamente crea un objeto SpatRaster que mantiene una referencia al archivo
# físico y almacena los metadatos necesarios para interpretarlo.
#
# Por esta razón, abrir un raster de varios gigabytes no genera un error
# Out Of Memory (OOM), incluso cuando la memoria RAM disponible es menor que
# el tamaño del archivo.
# ------------------------------------------------------------------------------

mde <- rast(ruta_raster)

# Mostrar un resumen del objeto
print(mde)

# ------------------------------------------------------------------------------
# CONSULTA DE METADATOS
# ------------------------------------------------------------------------------
#
# Las siguientes funciones únicamente leen información del encabezado
# (header) del archivo GeoTIFF.
#
# Ninguna de ellas carga los valores de elevación almacenados en cada píxel.
# ------------------------------------------------------------------------------

# Dimensiones del raster
dimensiones <- dim(mde)

# Número de filas
filas <- nrow(mde)

# Número de columnas
columnas <- ncol(mde)

# Número de bandas
bandas <- nlyr(mde)

# Resolución espacial
resolucion <- res(mde)

# Extensión espacial (Bounding Box)
extension <- ext(mde)

# Sistema de referencia espacial
crs_texto <- crs(mde)

# Tipo de dato almacenado
tipo_dato <- datatype(mde)

# ------------------------------------------------------------------------------
# Mostrar resultados
# ------------------------------------------------------------------------------

cat("\n========== METADATOS DEL RASTER ==========\n\n")

cat("Filas:", filas, "\n")
cat("Columnas:", columnas, "\n")
cat("Bandas:", bandas, "\n\n")

cat("Resolución espacial:", resolucion[1], "x", resolucion[2], "\n\n")

cat("Extensión:\n")
print(extension)

cat("\nSistema de referencia:\n")
cat(crs_texto, "\n\n")

cat("Tipo de dato:", tipo_dato, "\n")

# ------------------------------------------------------------------------------
# IMPORTANTE
# ------------------------------------------------------------------------------
#
# Hasta este punto únicamente se han leído metadatos.
#
# Los valores de cada celda continúan almacenados en el disco.
# El consumo de memoria RAM sigue siendo muy pequeño (normalmente algunos
# kilobytes), independientemente del tamaño total del archivo.
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# CUÁNDO SE LEEN LOS PÍXELES
# ------------------------------------------------------------------------------
#
# El contenido completo del raster solo comienza a leerse cuando se solicitan
# explícitamente sus valores.
#
# Dependiendo del tamaño del archivo, esta operación puede consumir una gran
# cantidad de memoria RAM.
#
# Ejemplo (NO ejecutar con archivos muy grandes):
#
# valores <- values(mde)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# REPROYECCIÓN DEL RASTER
# ------------------------------------------------------------------------------
#
# Si el raster estuviera en Datum Bogotá 1941 y fuera necesario utilizarlo
# junto con cartografía oficial en MAGNA-SIRGAS Origen Nacional (EPSG:9377),
# sería obligatorio reproyectarlo antes de realizar cualquier operación
# espacial como Intersect, Clip o Zonal Statistics.
#
# La función project() realiza la transformación del sistema de referencia
# y remuestrea automáticamente la matriz raster.
#
# Para Modelos Digitales de Elevación se recomienda el método bilinear,
# ya que la elevación es una variable continua.
# ------------------------------------------------------------------------------

# mde_magna <- project(
#   mde,
#   "EPSG:9377",
#   method = "bilinear"
# )

# Guardar el resultado
#
# writeRaster(
#   mde_magna,
#   "data/mde_bogota_magna.tif",
#   overwrite = TRUE
# )

# ------------------------------------------------------------------------------
# FIN DEL SCRIPT
# ------------------------------------------------------------------------------
#
# Este ejemplo demuestra dos conceptos fundamentales:
#
# 1. La función rast() utiliza lectura diferida, por lo que únicamente carga
#    los metadatos del raster durante su apertura.
#
# 2. Antes de combinar información geográfica con diferentes sistemas de
#    referencia es indispensable realizar una reproyección completa,
#    incluyendo la transformación geodésica correspondiente.
# ------------------------------------------------------------------------------