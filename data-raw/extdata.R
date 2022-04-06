## code to prepare extdata examples
## Estos son datasets de ejemplo, se usan principalmente
## para tests
library(subvencionesES)
library(dplyr)

# Muestra de ejemplo

subvenciones <- carga_subvenciones(tempdir()) %>%
  slice(1:5000)

convocatorias <- carga_convocatorias(tempdir())

# Une ambos datasets

subvenciones <- subvenciones %>%
  inner_join(convocatorias %>% select(IDConv))

convocatorias <- convocatorias %>%
  inner_join(subvenciones %>% select(IDConv))


save(convocatorias,
  file = "./inst/extdata/test/convocatorias.RData"
)


save(subvenciones,
  file = "./inst/extdata/test/subvenciones.RData"
)

tmstamp <- list.files(tempdir(),
  pattern = "timestamp.txt$",
  full.names = TRUE
)

basenames <- basename(tmstamp)

file.copy(tmstamp,
  to = "./inst/extdata/test/", recursive = TRUE
)


tools::resaveRdaFiles("./inst/extdata/test", compress = "auto")
