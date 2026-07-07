# ==============================================================================
# Evaluación 18.7 - Fundamentos Raster
# Programación SIG: Julia

# ==============================================================================

using Rasters
using ArchGDAL

# ------------------------------------------------------------------------------
# Ruta del Modelo Digital de Elevación (MDE)
#
# Se asume un archivo GeoTIFF denominado "data/heavy/raster/bogota.tif".
# La apertura del archivo no implica cargar inmediatamente todos los píxeles
# en memoria RAM.
# ------------------------------------------------------------------------------

ruta_raster = "data/heavy/raster/bogota.tif"

# ------------------------------------------------------------------------------
# APERTURA DEL RASTER
# ------------------------------------------------------------------------------
#
# Raster() implementa lectura diferida (lazy loading).
#
# Durante esta operación únicamente se crea un objeto Raster que mantiene una
# referencia al archivo físico y almacena sus metadatos.
#
# Los valores de elevación continúan almacenados en disco hasta que sean
# solicitados explícitamente mediante read().
# ------------------------------------------------------------------------------

mde = Raster(ruta_raster)

println("\n========== METADATOS DEL RASTER ==========\n")

println("Dimensiones:")
println(dims(mde))

println("\nSistema de referencia:")
println(crs(mde))

println("\nExtensión:")
println(extent(mde))

# ------------------------------------------------------------------------------
# IMPORTANTE
#
# Hasta este punto únicamente se han leído metadatos.
#
# Los valores del raster permanecen almacenados en disco y solamente serán
# leídos cuando se soliciten explícitamente.
# ------------------------------------------------------------------------------

# Ejemplo (NO ejecutar con archivos muy grandes)
#
# valores = read(mde)

# ------------------------------------------------------------------------------
# REPROYECCIÓN DEL RASTER
# ------------------------------------------------------------------------------
#
# Si el raster estuviera en Datum Bogotá 1941 y fuera necesario combinarlo con
# cartografía oficial en MAGNA-SIRGAS Origen Nacional (EPSG:9377), sería
# obligatorio reproyectarlo previamente.
#
# Para variables continuas como la elevación se recomienda remuestreo bilineal.
# ------------------------------------------------------------------------------

# mde_magna = resample(
#     mde;
#     crs = EPSG(9377)
# )

# write(
#     "data/mde_bogota_magna.tif",
#     mde_magna
# )

# ------------------------------------------------------------------------------
# FIN DEL SCRIPT
#
# Este ejemplo demuestra dos conceptos fundamentales:
#
# 1. Raster() implementa lectura diferida, por lo que únicamente carga
#    metadatos durante la apertura del archivo.
#
# 2. Antes de realizar operaciones espaciales entre capas con distintos
#    sistemas de referencia es indispensable realizar una reproyección
#    acompañada de la correspondiente transformación geodésica.
# ------------------------------------------------------------------------------