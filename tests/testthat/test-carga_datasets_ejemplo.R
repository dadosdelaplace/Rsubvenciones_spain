test_that("Check error", {
  expect_error(
    carga_datasets_ejemplo("otro"),
    "'name' debe ser 'subvenciones' o  'convocatorias'"
  )
})

test_that("Check subvenciones", {
  expect_message(carga_datasets_ejemplo("subvenciones"))


  t <- suppressMessages(carga_datasets_ejemplo("subvenciones"))

  expect_s3_class(t, "tbl_df")
  expect_equal(nrow(t), 5000)
})

test_that("Check convocatorias", {
  expect_message(carga_datasets_ejemplo("convocatorias"))


  t <- suppressMessages(carga_datasets_ejemplo("convocatorias"))

  expect_s3_class(t, "tbl_df")
  expect_equal(nrow(t), 5000)
})
