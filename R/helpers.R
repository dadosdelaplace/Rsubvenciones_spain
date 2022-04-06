#' Extrae CIF del beneficiario
#'
#' @details
#' Permite extraer el CIF y el nombre del beneficiario (sin el CIF) de
#' un registro en concreto
#'
#' @return
#'
#' Un `tibble` con las columnas `cif_beneficiario` y `nombre_beneficiario`.
#' Con la opción `append = TRUE` se devuelve el objeto `x` inicial con ambas
#' columnas añadidas.
#'
#' @param x Objeto inicial sobre el que se quiere ejecutar el split por CIF
#'   (Obtenido o derivado de [carga_subvenciones()]).
#' @param col_benef Nombre de la columna donde se almacena el valor de
#'   `beneficiario`.
#' @param append Variable lógica para añadir las nuevas columnas a `x` (`TRUE`)
#'  u obtener simplemente las columnas por separado (`FALSE`).
#'
#' @seealso [carga_subvenciones()]
#'
#' @rdname extrae_cif
#'
#' @family helpers
#'
#' @export
#' @examples
#'
#' # Carga dataset ejemplo
#' sub <- carga_datasets_ejemplo("subvenciones")
#'
#' # Para carga completa usar:
#' # sub <- carga_subvenciones()
#'
#' # Extrae CIF
#'
#' library(dplyr)
#'
#' extrae_cif(sub) %>%
#'   select(IDConv, fechaconc, importe, cif_beneficiario, nombre_beneficiario)
extrae_cif <- function(x, col_benef = "beneficiario", append = TRUE) {

  # Extrae columna de nombres
  names_benef <- dplyr::pull(x, col_benef)

  # Regex de extracción
  regex <- "([ABCDEFGHJKLMNPQRSUVW])(\\d{7})([0-9A-J])"

  cif <- stringr::str_extract_all(
    names_benef,
    regex,
    simplify = TRUE
  )[, 1]


  # Nombre limpio
  names_clean <- trimws(stringr::str_remove(names_benef, cif))

  # Preparamos resultados
  result <- dplyr::tibble(
    cif_beneficiario = cif,
    nombre_beneficiario = names_clean
  )

  if (isTRUE(append)) {
    result <- dplyr::bind_cols(x, result)
    return(result)
  }

  return(result)
}


#' Valida CIFs
#'
#' @description
#'
#' Valida CIFs españoles.
#'
#' @references <https://es.wikipedia.org/wiki/Código_de_identificación_fiscal>
#'
#' @return Un vector lógico `TRUE/FALSE`
#'
#' @rdname valida_cif
#'
#' @family helpers
#'
#' @export
#'
#' @param cif Vector de Códigos CIF a validar.
#'
#' @examples
#'
#' # Carga dataset ejemplo
#' sub <- carga_datasets_ejemplo("subvenciones")
#'
#' # Para carga completa usar:
#' # sub <- carga_subvenciones()
#'
#'
#' library(dplyr)
#'
#' nifs <- sub %>%
#'   extrae_cif(append = FALSE) %>%
#'   mutate(valid = valida_cif(cif_beneficiario))
#'
#'
#' nifs
#'
valida_cif <- function(cif) {
  x <- purrr::map_lgl(
    as.character(cif),
    valida_cif_single
  )

  return(x)
}


valida_cif_single <- function(cif) {

  # 1. Pattern matching
  pattern <- stringr::str_detect(
    cif,
    "^([ABCDEFGHJKLMNPQRSUVW])(\\d{7})([0-9A-J])$"
  )

  if (isFALSE(pattern)) {
    return(FALSE)
  }

  # 2. Dígito de control
  letra <- stringr::str_sub(cif, 1, 1)
  dc <- stringr::str_sub(cif, 9, 9)

  numbers <-
    stringr::str_split(stringr::str_sub(cif, 2, 8), "",
      simplify = TRUE
    )


  # Numeros par
  par <- sum(as.integer(numbers[, seq(2, 7, 2)]))

  # Trata impares
  impar <- as.integer(numbers[, seq(1, 7, 2)]) * 2

  impar_end <- unlist(lapply(impar, function(x) {
    if (x > 9) {
      x <- sum(as.double((stringr::str_split(x, "", simplify = TRUE))))
    }
    return(x)
  }))

  # Une
  end_sum <- sum(par, impar_end)
  dc_computed <- (10 - (end_sum %% 10)) %% 10

  # Comprueba si corresponde una letra
  if (stringr::str_detect(letra, "[NPQRSW]")) {
    if (dc_computed == 0) {
      dc_computed <- "J"
    } else {
      dc_computed <- LETTERS[dc_computed]
    }
  }

  # Valida
  if (as.character(dc_computed) == as.character(dc)) {
    return(TRUE)
  }

  return(FALSE)
}


#' Carga datasets de ejemplo
#'
#' @description
#' Función para cargar datasets de ejemplo almacenados en el paquete.
#'
#' **Estos datos son un subconjunto reducido de la base de datos usados en
#' ejemplos y tests**. No deben ser usados para análisis.
#'
#' @return
#' Ver [carga_subvenciones()]
#'
#' @seealso [carga_subvenciones()], [carga_convocatorias()].
#'
#' @param name Nombre del dataset de ejemplo a cargar (`"subvenciones"`
#'   o `"convocatorias"`).
#'
#' @export
#' @rdname carga_dataset_ejemplo
#'
#' @keywords internal
#'

carga_datasets_ejemplo <- function(name = "subvenciones") {
  packdir <- system.file(package = "subvencionesES")
  testdir <- file.path(packdir, "extdata", "test")

  if (!name %in% c("subvenciones", "convocatorias")) {
    stop("'name' debe ser 'subvenciones' o  'convocatorias'")
  }

  message(
    "ATENCION: Cargando datasets de ejemplo. ",
    "No usar en produccion.\n"
  )

  if (name == "subvenciones") {
    x <- carga_subvenciones(
      cache_dir = testdir,
      update = FALSE
    )

    message("\nPara cargar la informacion completa usar 'carga_subvenciones()'")
    return(x)
  } else {
    x <- carga_convocatorias(
      cache_dir = testdir,
      update = FALSE
    )
    message("\nPara cargar la informacion completa usar 'carga_convocatorias()'")
    return(x)
  }
}
