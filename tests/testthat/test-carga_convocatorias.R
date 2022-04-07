test_that("test download", {
  conv <- carga_convocatorias(cache_dir = tempdir())
  t <- suppressMessages(carga_datasets_ejemplo("convocatorias"))

  expect_equal(
    names(conv),
    names(t)
  )
})
