#' Carga ficheros del Volcado de la Base de Datos Nacional de Subvenciones
#' (BDNS).
#'
#' @description
#' Carga un objeto la información correspondiente. Se puede cargar una versión
#' previamente almacenada o bien descargar la última versión disponible.
#' - [carga_convocatorias()] carga información de convocatorias.
#' - [carga_subvenciones()] carga información de subvenciones.
#'
#' La información se descarga en la carpeta especificada con el parámetro
#' `cache_dir`. Además, almacena una copia ya procesada de cada archivo en
#' formato .RData para reducir los tiempos de carga de datos en cada sesión
#' independiente.
#'
#' @family carga_datos
#'
#' @return Un objeto en formato `tibble` con las cabeceras correctas.
#'
#' @author Diego Hernangómez, Javier Álvarez-Liébana.
#'
#' @rdname carga_datos
#'
#' @references
#' Github repo: <https://github.com/JaimeObregon/subvenciones>.
#' @export
#'
#' @param cache_dir Directorio donde se quiere almacenar los datos. Por
#'   defecto `rappdirs::user_data_dir("subvencionesES")`. En este directorio
#'   se almacena tambíén la copia procesada en formato .RData
#' @param update Variable lógica para descargar (`TRUE`) la versión más
#'   actual o cargar la copia local. Por defecto carga copia local (`FALSE`).
#'   Con la opción `update = TRUE` el paquete reescribe también el archivo
#'   .RData asociado.
#' @param rebuild_db Vuelve a generar la base de datos local .RData a partir
#'   de los archivos csv ya descargados.
#'
#' @details
#'
#' Las funciones devuelven las columnas según los nombres explicados en el
#' issue [#11](https://github.com/JaimeObregon/subvenciones/issues/11).
#'
#' ## Resultados de `carga_convocatorias()`
#'
#' ```{r, echo=FALSE}
#'
#' df <- data.frame(
#'   nombres_columnas = c(
#'     "IDConv", # 0
#'     "id", # 1
#'     "mrr", # 2
#'     "convocanteN1", # 3
#'     "convocanteN2", # 4
#'     "convocanteN3", # 5
#'     "fechareg", # 6
#'     "titulo", # 7
#'     "bbreguladoras", # 8 - nombre tomado de los ficheros de jurídicas
#'     "tituloleng", # 9
#'     "verConcesiones", # 10 - valores nulos
#'     "dummy1", # 11 - valor 350078 fijo
#'     "dummy2"
#'   ),
#'   etiquetas_columnas = c(
#'     "IDConv",
#'     "Código BDNS",
#'     "MRR",
#'     "Administración",
#'     "Departamento",
#'     "Órgano",
#'     "Fecha de registro",
#'     "Título de la convocatoria",
#'     "URL de las BBRR",
#'     "Título cooficial",
#'     "Ver concesiones",
#'     "dummy1",
#'     "dummy2"
#'   )
#' )
#'
#' knitr::kable(df, col.names = paste0("**", names(df), "**"))
#'
#' ```
#'
#' ## Resultados de `carga_subvenciones()`
#'
#' ```{r, echo=FALSE}
#' df <- data.frame(
#'   nombres_columnas = c(
#'     "ID", #0
#'     "IDConv", #1
#'     "convocanteN1", #2
#'     "convocanteN2", #3
#'     "convocanteN3", #4
#'     "convocatoria", #5
#'     "bbreguladoras", #6
#'     "programa", #7
#'     "fechaconc", #8
#'     "beneficiario", #9
#'     "importe", #10
#'     "instrumento", #11
#'     "ayudaequiv", #12
#'     "detalles", #13
#'     "proyecto", #14
#'     "sancion", #15
#'     "numcov" #16
#'   ),
#'   etiquetas_columnas = c(
#'     "ID",
#'     "IDConvocatoria",
#'     "Administración",
#'     "Departamento",
#'     "Órgano",
#'     "Convocatoria",
#'     "URL de las BBRR",
#'     "Aplicación presupuestaria",
#'     "Fecha de concesión",
#'     "Beneficiario",
#'     "Importe",
#'     "Instrumento",
#'     "Ayuda Equivalente",
#'     "Detalles",
#'     "proyecto",
#'     "sancion",
#'     "numcov"
#'   )
#' )
#'
#' knitr::kable(df, col.names = paste0("**", names(df), "**"))
#'
#' ```
#'
#' @examples
#' \dontrun{
#' conv <- carga_convocatorias()
#' sub <- carga_subvenciones()
#' }
carga_convocatorias <- function(cache_dir = rappdirs::user_data_dir("subvencionesES"),
                                update = FALSE,
                                rebuild_db = FALSE) {

  # Creamos paths

  local_rda <- file.path(cache_dir, "convocatorias.RData")
  local_timestamp <- file.path(cache_dir, "convocatorias_timestamp.txt")

  # En primer lugar comprobamos si hay copia local almacenada en Rdata y
  # la cargamos si no se ha pedido actualización

  if (all(isFALSE(update), file.exists(local_rda), isFALSE(rebuild_db))) {
    x <- cache_load(local_rda, local_timestamp)
    return(x$convocatorias)
  }

  # Si no tenemos copia .RData
  url_raw <- file.path(
    "https://github.com/JaimeObregon/subvenciones/raw",
    "main/files/convocatorias.csv.gz"
  )

  # Descarga de datos
  file_dest <- purrr::map_chr(
    url_raw,
    function(x) {
      descarga_datos(
        url_raw = x,
        dir_raw = cache_dir,
        update = update
      )
    }
  )

  # Creamos un timestamp
  # Si ya tenemos la base de datos no actualizamos el timestamp
  # Caso de actualización de bbdd
  if (!file.exists(local_rda)) {
    time <- format(Sys.time(), usetz = TRUE)

    writeLines(time,
      con = local_timestamp
    )
  }

  # Carga con readr (tidyverse) sin nombre de columnas
  # dos primeras columnas --> códigos id
  convocatorias <- purrr::map_dfr(
    file_dest,
    function(x) {
      readr::read_csv(x,
        col_names = FALSE,
        col_types = readr::cols(
          X1 = readr::col_character(),
          X2 = readr::col_character(),
          X7 = readr::col_date(format = "%d/%m/%Y")
        )
      )
    }
  )

  # Añade nombres, según https://github.com/JaimeObregon/subvenciones/issues/11
  col_names_conv <- c(
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
  names(convocatorias) <- col_names_conv

  # Modifica el campo mrr a logico
  convocatorias$mrr <- purrr::map_lgl(
    convocatorias$mrr, function(x) {
      switch(x,
        NO = FALSE,
        SI = TRUE,
        NA
      )
    }
  )

  # Guardamos en local con nombres cambiados
  message("Creando copia local en ", local_rda)
  save(convocatorias, file = local_rda)

  if (isFALSE(update)) {
    time <- readLines(local_timestamp)
    message("Timestamp de datos csv en local: ", time)
  }
  # Output
  return(convocatorias)
}

#' @export
#' @rdname carga_datos
carga_subvenciones <- function(cache_dir = rappdirs::user_data_dir("subvencionesES"),
                               update = FALSE,
                               rebuild_db = FALSE) {
  # Creamos paths

  local_rda <- file.path(cache_dir, "subvenciones.RData")
  local_timestamp <- file.path(cache_dir, "subvenciones_timestamp.txt")

  # En primer lugar comprobamos si hay copia local almacenada en Rdata y
  # la cargamos si no se ha pedido actualización

  if (all(isFALSE(update), file.exists(local_rda), isFALSE(rebuild_db))) {
    x <- cache_load(local_rda, local_timestamp)
    return(x$subvenciones)
  }

  # Si no tenemos copia .RData
  url_raw <- file.path(
    "https://github.com/JaimeObregon/subvenciones/raw",
    c("main/files/juridicas_1.csv.gz", "main/files/juridicas_2.csv.gz")
  )

  # Descarga de datos
  file_dest <- purrr::map_chr(
    url_raw,
    function(x) {
      descarga_datos(
        url_raw = x,
        dir_raw = cache_dir,
        update = update
      )
    }
  )

  # Creamos un timestamp
  # Si ya tenemos la base de datos no actualizamos el timestamp
  # Caso de actualización de bbdd
  if (!file.exists(local_rda)) {
    time <- format(Sys.time(), usetz = TRUE)

    writeLines(time,
      con = local_timestamp
    )
  }

  subvenciones <- purrr::map_dfr(
    file_dest,
    function(x) {
      readr::read_csv(x,
        col_names = FALSE,
        col_types = readr::cols(
          X1 = readr::col_character(),
          X2 = readr::col_character(),
          X9 = readr::col_date(format = "%d/%m/%Y")
        )
      )
    }
  )

  # Añade nombres, según https://github.com/JaimeObregon/subvenciones/issues/11
  col_names_subven <- c(
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
  names(subvenciones) <- col_names_subven


  # Guardamos en local con nombres cambiados
  message("Creando copia local en ", local_rda)

  save(subvenciones, file = local_rda)

  if (isFALSE(update)) {
    time <- readLines(local_timestamp)
    message("Timestamp de datos csv en local: ", time)
  }

  # Output
  return(subvenciones)
}
