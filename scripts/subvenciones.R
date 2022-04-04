#' Carga los ficheros de subvenciones
#'
#'
#' @description
#' Carga la información de subvenciones. Este script crea la función que luego
#' se puede llamar según las necesidades de usuario:
#'
#'
#'
#' @param dir: Directorio donde se almacenan los datos. Por defecto el working
#'   directory.
#' @param update TRUE/FALSE. Para descargar la versión mas actual (TRUE) o
#'   cargar la copia local.
#'
#' @examples
#'
#' # Ejecutar el script
#' source("scripts/subvenciones.R")
#'
#' sub <- carga_subvenciones()
carga_subvenciones <- function(dir = getwd(),
                               update = FALSE) {

  # B. Función ----

  dir_expand <- path.expand(dir)

  if (!dir.exists(dir_expand)) dir.create(dir_expand, recursive = TRUE)


  # Función de ayuda

  auxfun <- function(url,
                     d = dir_expand,
                     u = update) {
    basename <- basename(url)

    # Mira si hay copia local y la carga. O bien vuelve a descargarla

    filedest <- file.path(d, basename)

    if (isTRUE(u) | !file.exists(filedest)) {
      message("Descargando ultima version del archivo ", basename)
      download.file(
        url = url,
        destfile = filedest,
        mode = "wb"
      )
      message("Descargado en ", filedest)
    } else {
      message("Cargando la version local ", filedest)
    }


    # Carga con readr

    x <- readr::read_csv(filedest,
      col_names = FALSE,
      col_types = readr::cols(
        X1 = readr::col_character(),
        X2 = readr::col_character()
      )
    )

    return(x)
  }


  sub1 <- auxfun(url = "https://github.com/JaimeObregon/subvenciones/raw/main/files/juridicas_1.csv.gz")
  sub2 <- auxfun(url = "https://github.com/JaimeObregon/subvenciones/raw/main/files/juridicas_2.csv.gz")


  # Crea objeto final

  sub <- dplyr::bind_rows(sub1, sub2)


  # Añade nombres, según https://github.com/JaimeObregon/subvenciones/issues/11

  nombres_columnas <- c(
    "ID", # 0
    "IDConv", # 1
    "convocanteN1", # 2
    "convocanteN2", # 3
    "convocanteN3", # 4
    "convocatoria", # 5
    "bbreguladoras", # 6
    "programa", # 7
    "fechaconc", # 8
    "beneficiario", # 9
    "importe", # 10
    "instrumento", # 11
    "ayudaequiv", # 12
    "detalles", # 13
    "proyecto", # 14
    "sancion", # 15
    "numcov" # 16
  )

  names(sub) <- nombres_columnas


  return(sub)
}
