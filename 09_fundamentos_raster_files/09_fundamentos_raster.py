# ==============================================================================
# Evaluación 18.7 - Fundamentos Raster
# Programación SIG: Python

# ==============================================================================

import rasterio
from rasterio.warp import calculate_default_transform
from rasterio.warp import reproject
from rasterio.warp import Resampling

# ------------------------------------------------------------------------------
# Ruta del Modelo Digital de Elevación (MDE)
#
# Se asume un archivo GeoTIFF denominado "data/heavy/raster/bogota.tif".
# Aunque el archivo pueda ocupar varios gigabytes en disco, su apertura no
# implica cargar todos los píxeles en memoria RAM.
# ------------------------------------------------------------------------------

ruta_raster = "data/heavy/raster/bogota.tif"

# ------------------------------------------------------------------------------
# APERTURA DEL RASTER
# ------------------------------------------------------------------------------
#
# rasterio.open() implementa lectura diferida (lazy loading).
#
# Durante esta operación únicamente se abre una conexión con el archivo y se
# leen los metadatos almacenados en el encabezado del GeoTIFF.
#
# Los valores de elevación permanecen almacenados en disco hasta que sean
# solicitados explícitamente mediante src.read().
#
# Por esta razón, abrir un raster de gran tamaño no produce un error
# Out Of Memory (OOM).
# ------------------------------------------------------------------------------

with rasterio.open(ruta_raster) as src:

    print("\n========== METADATOS DEL RASTER ==========\n")

    print("Filas:", src.height)
    print("Columnas:", src.width)
    print("Bandas:", src.count)
    print("Resolución:", src.res)
    print("Extensión:", src.bounds)
    print("CRS:", src.crs)
    print("Tipo de dato:", src.dtypes[0])

    # --------------------------------------------------------------------------
    # IMPORTANTE
    #
    # Hasta este punto únicamente se han leído metadatos.
    # El contenido completo del raster continúa almacenado en disco.
    # --------------------------------------------------------------------------

    # Ejemplo (NO ejecutar con archivos muy grandes)
    #
    # matriz = src.read()

# ------------------------------------------------------------------------------
# REPROYECCIÓN DEL RASTER
# ------------------------------------------------------------------------------
#
# Si el raster estuviera en Datum Bogotá 1941 y fuera necesario utilizarlo
# junto con información en MAGNA-SIRGAS Origen Nacional (EPSG:9377),
# sería obligatorio realizar una reproyección antes de cualquier operación
# espacial.
#
# Para Modelos Digitales de Elevación se recomienda interpolación bilineal.
# ------------------------------------------------------------------------------

crs_destino = "EPSG:9377"

with rasterio.open(ruta_raster) as src:

    transform, width, height = calculate_default_transform(
        src.crs,
        crs_destino,
        src.width,
        src.height,
        *src.bounds
    )

    metadata = src.meta.copy()

    metadata.update({
        "crs": crs_destino,
        "transform": transform,
        "width": width,
        "height": height
    })

    # with rasterio.open(
    #     "data/mde_bogota_magna.tif",
    #     "w",
    #     **metadata
    # ) as dst:
    #
    #     for banda in range(1, src.count + 1):
    #
    #         reproject(
    #             source=rasterio.band(src, banda),
    #             destination=rasterio.band(dst, banda),
    #             src_transform=src.transform,
    #             src_crs=src.crs,
    #             dst_transform=transform,
    #             dst_crs=crs_destino,
    #             resampling=Resampling.bilinear
    #         )

# ------------------------------------------------------------------------------
# FIN DEL SCRIPT
#
# Este ejemplo demuestra dos conceptos fundamentales:
#
# 1. rasterio.open() únicamente carga metadatos durante la apertura.
#
# 2. Antes de combinar información con diferentes sistemas de referencia
#    es obligatorio realizar una reproyección con transformación geodésica.
# ------------------------------------------------------------------------------