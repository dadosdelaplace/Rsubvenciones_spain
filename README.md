
<!-- README.md is generated from README.Rmd. Please edit that file -->

# subvencionesES

<!-- badges: start -->

[![R-CMD-check](https://github.com/dadosdelaplace/Rsubvenciones_spain/actions/workflows/check-pak.yaml/badge.svg?branch=rpak)](https://github.com/dadosdelaplace/Rsubvenciones_spain/actions/workflows/check-pak.yaml)
[![License:
GPLv3](https://img.shields.io/badge/license-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Contributors](https://img.shields.io/github/contributors/dadosdelaplace/Rsubvenciones_spain)](https://github.com/dadosdelaplace/Rsubvenciones_spain/graphs/contributors)
[![chat on
Discord](https://img.shields.io/discord/308323056592486420?logo=discord)](https://discord.com/invite/r2ytSa782D)

<!-- badges: end -->

Aportación desde la **comunidad de R** para la extracción, limpieza y
visualización de los datos del volcado de la Base de Datos Nacional de
Subvenciones (BDNS). Github del proyecto global y comunitario puesto en
marcha por [**Jaime
Gómez-Obregón**](https://github.com/JaimeObregon/subvenciones).

|              |                                                                      |
|--------------|----------------------------------------------------------------------|
| GitHub       | <https://github.com/JaimeObregon/subvenciones>                       |
| Discord      | <https://discord.com/invite/r2ytSa782D>                              |
| Idea inicial | <https://twitter.com/JaimeObregon/status/1507693311422877697> (hilo) |

## Instalación

Puedes instalar el paquete desde [GitHub](https://github.com/) con:

``` r
# install.packages("devtools")
devtools::install_github("dadosdelaplace/Rsubvenciones_spain",
                         ref = "rpak")
```

## Ejemplo

Carga convocatorias:

``` r
library(subvencionesES)

convocatorias <- carga_convocatorias()

convocatorias
```

Carga subvenciones (archivos jurídicas):

``` r
subvenciones <- carga_subvenciones()

subvenciones
```
