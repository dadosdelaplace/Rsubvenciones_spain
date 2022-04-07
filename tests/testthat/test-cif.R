test_that("Crea y valida cifs", {
  t <- suppressMessages(carga_datasets_ejemplo("subvenciones"))

  cif <- extrae_cif(t)
  expect_equal(ncol(cif), ncol(t) + 2)

  # Comprueba la extracción
  expect_equal(
    paste(cif$cif_beneficiario, cif$nombre_beneficiario),
    cif$beneficiario
  )

  # Rename
  t$otro <- t$beneficiario
  cif_otro <- extrae_cif(t, "otro")

  expect_identical(cif, cif_otro[names(cif)])

  # No append
  cif2 <- extrae_cif(t, append = FALSE)
  expect_equal(ncol(cif2), 2)
  expect_equal(names(cif2), c("cif_beneficiario", "nombre_beneficiario"))
})

test_that("Valida CIFs", {
  err1 <- "012345678C"
  expect_false(valida_cif(err1))

  err2 <- "P4407400F"
  expect_false(valida_cif(err2))

  # Full validation
  t <- suppressMessages(carga_datasets_ejemplo("subvenciones"))
  cif <- extrae_cif(t, append = FALSE)

  expect_true(all(valida_cif(cif$cif_beneficiario)))
})
