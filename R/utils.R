descarga_datos <- function(url_raw, dir_raw = "./raw_data", update = FALSE) {

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

cache_load <- function(file, local_tmstamp) {
  message(
    "Cargando informacion almacenada en ",
    file
  )
  # Timestamp del rda
  if (file.exists(local_tmstamp)) {
    time <- readLines(local_tmstamp)
    message("Timestamp de la copia local: ", time)
  }

  # Carga en nuevo env para evitar errores en check
  cached_copy <- new.env()

  load(file, envir = cached_copy)
  return(cached_copy)
}
