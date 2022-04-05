
#' @title Descarga el fichero de convocatorias del Volcado de la Base 
#' de Datos Nacional de Subvenciones (BDNS).
#'
#' @description
#' Carga la información relativa a convocatorias. Este script crea la función que luego
#' se puede llamar según las necesidades de usuario.
#'
#' @param dir_raw directorio donde se quiere almacenar los datos en bruto.
#' Por defecto el directorio raw_data.
#' @param url_raw vector con las rutas de los archivos de datos en bruto.
#' @param update variable lógica para descargar (TRUE) la versión mas
#' actual o cargar la copia local. Por defecto carga copia local (FALSE).
#' @param save_conv,save_subven guardar o no los archivos de convocatorias
#' y subvenciones con nombres de columnas cambiados (FALSE por defecto).
#' @param dir_save_conv,dir_save_subven directorio donde guardar los archivos 
#' (siempre que \code{save_conv = TRUE}, \code{save_subven = TRUE})
#' @return Argumentos de salida:
#' \item{\code{file_dest}}{ruta del archivo en bruto (si no existía la crea).}
#' \item{\code{convocatorias}}archivo de las convocatorias con cabecera correcta.}
#' \item{\code{subvenciones}}{archivo de las subvenciones con cabecera correcta.}
#' @details
#' \itemize{
#'   \item{\code{descarga_datos} función auxiliar que descarga los
#'   datos en bruto a nuestro local.}
#'   \item{\code{carga_convocatorias} función para la descarga del archivo
#'   de las convocatorias, editando una cabecera de tabla correcta.}
#'   \item{\code{carga_subvenciones} función para la descarga del archivo
#'   de las subvenciones, editando una cabecera de tabla correcta.}
#' }
#' 
#' @examples
#'
#' # Ejecutar el script (para generar la función)
#' source("./scripts/funciones_carga.R")
#'
#' # Uso de la función por defecto
#' conv <- carga_convocatorias()
#' 
#' @author Diego Hernangómez, Javier Álvarez-Liébana.
#' @references
#' Github repo: \url{https://github.com/JaimeObregon/subvenciones}
#' @name funciones-carga

#' @rdname funciones-carga
#' @export
descarga_datos <-
  function(url_raw, dir_raw = "./raw_data", update = FALSE) {
    
    # Ruta expandida
    dir_expand <- path.expand(dir_raw)
    
    # Si directorio no existe --> se crea
    if (!dir.exists(dir_expand)) {
      
      dir.create(dir_expand, recursive = TRUE)
      
    }    
    
    # Nombre archivo
    base_name <- basename(url_raw)
    
    # Construye ruta donde debería estar la copia local si existe
    file_dest <- file.path(dir_expand, base_name)
    
    # Mira si hay copia local y la carga. O bien vuelve a descargarla
    if (isTRUE(update) | !file.exists(file_dest)) {
      
      message("Descargando ultima version del archivo ", base_name)
      download.file(
        url = url_raw,
        destfile = file_dest,
        mode = "wb"
      )
      message("Descargado en ", file_dest)
      
    } else {
      
      message("Cargando la version local ", file_dest)
      
    }
    
    # Output
    return(file_dest)
}

#' @rdname funciones-carga
#' @export
carga_convocatorias <-
  function(dir_raw = "./raw_data",
           url_raw = "https://github.com/JaimeObregon/subvenciones/raw/main/files/convocatorias.csv.gz",
           update = FALSE, save_conv = FALSE, dir_save_conv = "./data") {
    
    # Descarga de datos
    file_dest <-
      descarga_datos(url_raw = url_raw, dir_raw = dir_raw,
                     update = update)
    
    # Carga con readr (tidyverse) sin nombre de columnas
    # dos primeras columnas --> códigos id
    convocatorias <- readr::read_csv(file_dest,
      col_names = FALSE,
      col_types = readr::cols(
        X1 = readr::col_character(),
        X2 = readr::col_character()
      )
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

    # Guardamos en local con nombres cambiados
    if (save_conv) {
      
      # Si directorio no existe --> se crea
      dir_save <- path.expand(dir_save_conv)
      if (!dir.exists(dir_save)) {
        
        dir.create(dir_save, recursive = TRUE)
        
      }   
      
      # Guarda en .csv y RData
      readr::write_csv(convocatorias,
                       file = paste0(dir_save_conv, "/convocatorias.csv"))
      save(convocatorias,
           file = paste0(dir_save_conv, "/convocatorias.RData"))
      
    }
  
    # Output
    return(convocatorias)
}

#' @rdname funciones-carga
#' @export
carga_subvenciones <-
  function(dir_raw = "./raw_data",
           url_raw = c("https://github.com/JaimeObregon/subvenciones/raw/main/files/juridicas_1.csv.gz",
                       "https://github.com/JaimeObregon/subvenciones/raw/main/files/juridicas_2.csv.gz"),
           update = FALSE, save_subven = FALSE, dir_save_subven = "./data") {
  
    # Descarga de datos
    file_dest <-
      url_raw %>%
      purrr::map_chr(function(x) { descarga_datos(url_raw = x,
                                                  dir_raw = dir_raw,
                                                  update = update) })
    
    # Carga con readr (tidyverse) sin nombre de columnas
    # dos primeras columnas --> códigos id
    # Crea objeto final (apila filas)
    subvenciones <-
      file_dest %>%
      purrr::map_dfr(
        function(x) {
          readr::read_csv(x, col_names = FALSE,
                          col_types = readr::cols(
                            X1 = readr::col_character(),
                            X2 = readr::col_character()
                            ))
          })

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
    if (save_subven) {
      
      # Si directorio no existe --> se crea
      dir_save <- path.expand(dir_save_subven)
      if (!dir.exists(dir_save)) {
        
        dir.create(dir_save, recursive = TRUE)
        
      }   
      
      # Guarda en .csv y RData
      readr::write_csv(subvenciones,
                       file = paste0(dir_save_subven, "/subvenciones.csv"))
      save(subvenciones,
           file = paste0(dir_save_subven, "/subvenciones.RData"))
      
    }
    
    # Output
    return(subvenciones)
}

