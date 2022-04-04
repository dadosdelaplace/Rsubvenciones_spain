#' Carga el fichero de convocatorias
#'
#'
#' @description
#' Carga la información de convocatorias. Este script crea la función que luego
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
#' source("scripts/convocatorias.R")
#'
#' conv <- carga_convocatorias()
carga_convocatorias <- function(dir = getwd(),
                                update = FALSE) {

  # B. Función ----

  dir_expand <- path.expand(dir)

  if (!dir.exists(dir_expand)) dir.create(dir_expand, recursive = TRUE)

  urlconv <- "https://github.com/JaimeObregon/subvenciones/raw/main/files/convocatorias.csv.gz"
  basename <- basename(urlconv)

  # Mira si hay copia local y la carga. O bien vuelve a descargarla

  filedest <- file.path(dir_expand, basename)

  if (isTRUE(update) | !file.exists(filedest)) {
    message("Descargando ultima version del archivo ", basename)
    download.file(
      url = urlconv,
      destfile = filedest,
      mode = "wb"
    )
    message("Descargado en ", filedest)

  } else {
    message("Cargando la version local ", filedest)
  }


  # Carga con readr

  convocatorias <- readr::read_csv(filedest,
    col_names = FALSE,
    col_types = readr::cols(
      X1 = readr::col_character(),
      X2 = readr::col_character()
    )
  )

  # Añade nombres, según https://github.com/JaimeObregon/subvenciones/issues/11

  nombres_columnas <- c(
    "IDConv", # 0
    "id", # 1
    "mrr", # 2
    "convocanteN1", # 3
    "convocanteN2", # 4
    "convocanteN3", # 5
    "fechareg", # 6
    "titulo", # 7
    "bbreguladoras", # 8 - nombre tomado de los ficheros de jurídicas
    "tituloleng", # 9
    "verConcesiones", # 10 - valores nulos
    "dummy1", # 11 - valor 350078 fijo
    "dummy2" # 12 - valor igual a IDConv +1
  )

  names(convocatorias) <- nombres_columnas


  return(convocatorias)
}
