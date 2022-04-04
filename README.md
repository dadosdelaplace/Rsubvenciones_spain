[![License:
GPLv3](https://img.shields.io/badge/license-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
<a href="https://github.com/dadosdelaplace/Rsubvenciones_spain/graphs/contributors" alt="Contributors"> <img src="https://img.shields.io/github/contributors/dadosdelaplace/Rsubvenciones_spain" /></a>
<a href="https://discord.gg/r2ytSa782D">
        <img src="https://img.shields.io/discord/308323056592486420?logo=discord"
            alt="chat on Discord"></a>
            

# Rsubvenciones_spain

Aportación desde la **comunidad de R** para la extracción, limpieza y visualización de los datos del volcado de la Base de Datos Nacional de Subvenciones (BDNS). Github del proyecto global y comunitario puesto en marcha por [**Jaime Gómez-Obregón**](https://github.com/JaimeObregon/subvenciones)

|              |                                                                    |
| ------------ | ------------------------------------------------------------------ |
| GitHub       | <https://github.com/JaimeObregon/subvenciones>                       |
| Discord      | <https://discord.gg/r2ytSa782D>                                      |
| Idea inicial | <https://twitter.com/JaimeObregon/status/1507693311422877697> (hilo) |

## Ser colaborador/a del repositorio

Para serlo debes entrar en el [**Discord**](https://discord.gg/r2ytSa782D) del proyecto de Jaime y enviarme el nick de Github por privado (@javieralvarezliebana) para poder añadirte como colaborador/a del repositorio

**IMPORTANTE**: nunca hacer un pull request o commit a la rama main. Siempre crear una rama paralela y al hacer pull request **mencionar en la pull** a @dieghernan y @dadosdelaplace para validar y hacer merge sobre la rama.

## Proyecto final

La idea final es **elaborar un paquete de R** con la filosofía de [**R Open Spain**](https://ropenspain.es/paquetes/), para facilitar el acceso a los datos y sus visuaizaciones de la comunidad estadística, del periodismo de datos y, en general, a toda la comunidad de R.

## Estado actual

En la carpeta `scripts` hay dos scripts en R:

- `convocatorias.R`, que crea la función `carga_convocatorias()`.
- `subvenciones.R` que crea la función `carga_subvenciones()`.

Estas funciones pueden ser usadas según las necesidades del usuario:

```r

# Carga las funciones 

source("scripts/subvenciones.R")
source("scripts/convocatorias.R")

# Obtiene los datos 

sub <- carga_subvenciones()


```

Los resultados se proporcionan en formato [`tibble`](https://tibble.tidyverse.org/). Los nombres de las
columnas se proporcionan según lo comentado en https://github.com/JaimeObregon/subvenciones/issues/11.

## Colaboradores/as actuales (inserta nombre y si quieres redes)

* Javier Álvarez Liébana ([@dadosdelaplace](https://twitter.com/dadosdelaplace))
* Diego Hernangómez ([@dhernangomez](https://twitter.com/dhernangomez))
* Lucía Pascual Martínez

**IMPORTANTE**: nunca hacer un pull request o commit a la rama main. Siempre crear una rama paralela y al hacer pull request **mencionar en la pull** a @dieghernan y @dadosdelaplace para validar y hacer merge sobre la rama.
