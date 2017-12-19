context("exists")

clear_test_environments()

test_that("it can call an interface's `exists` method", {
  expect_false(exists("x", mock_cloud_interface))
  .mock_cloud_env[["x"]] <- 7
  expect_true(exists("x", mock_cloud_interface))
})
