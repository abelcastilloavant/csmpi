context("test setup")
test_that("mock environments were generated correctly", {
  expect_is(.mock_cloud_env, "environment")
  expect_is(.mock_disk_env, "environment")
})

describe("tool to clear mock environments was generated correctly", {
  test_that("it is a function", {
    expect_is(clear_test_environments, "function")
  })
  test_that("it clears the mock cloud environment", {
    expect_equal(length(ls(.mock_cloud_env)), 0)
    .mock_cloud_env[["a"]] <- 1
    expect_equal(length(ls(.mock_cloud_env)), 1)
    clear_test_environments()
    expect_equal(length(ls(.mock_cloud_env)), 0)
  })
  test_that("it clears the mock disk environment", {
    expect_equal(length(ls(.mock_disk_env)), 0)
    .mock_disk_env[["a"]] <- 1
    expect_equal(length(ls(.mock_disk_env)), 1)
    clear_test_environments()
    expect_equal(length(ls(.mock_disk_env)), 0)
  })

})

test_that("mock interfaces were generated correctly", {
  expect_is(mock_cloud_interface, "CloudInterface")
  expect_is(mock_disk_interface, "DiskInterface")
})
