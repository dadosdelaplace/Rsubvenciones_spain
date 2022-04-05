
# Limpiamos
rm(list = ls())

# Paquetes
library(tidyverse)
library(purrr)

# Funciones de carga
source("./scripts/funciones_carga.R")

# Archivo convocatoria (solo con nombres) sin guardar
conv <- carga_convocatorias()

# Archivo convocatoria (solo con nombres) guardando en local
conv <- carga_convocatorias(save_conv = TRUE)

# Archivo subvenciones (solo con nombres) sin guardar
subven <- carga_subvenciones()

# Archivo subvenciones (solo con nombres) guardando en local
subven <- carga_subvenciones(save_subven = TRUE)