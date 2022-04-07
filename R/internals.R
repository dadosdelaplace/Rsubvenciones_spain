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
