context("write")

clear_test_environments()

df  <- 10
df2 <- 20
df3 <- 30

with_mocked_disk_interface({
  describe("writing without caching", {
    expect_null(.mock_cloud_env[["x"]])
    suppressMessages({
      write(
        obj                  = df,
        key                  = "x",
        cloud_interface      = mock_cloud_interface,
        disk_interface       = mock_disk_interface,
        use_disk_cache       = FALSE,
        params               = list(),
        num_retries          = 1,
        overwrite_disk_cache = FALSE
      )
    })
    test_that("it can write to the cloud", {
      expect_equal(.mock_cloud_env[["x"]], df)
    })
    test_that("it doesn't leave anything on disk", {
      expect_equal(length(ls(.mock_disk_env)), 0)
    })
  })
})

clear_test_environments()

with_mocked_disk_interface({
  describe("writing with caching", {

    mock_filename <- get_disk_cache_filename("x", "mock_cloud_interface", "mock_disk_interface")
    expect_null(.mock_cloud_env[["x"]])
    suppressMessages({
      write(
        obj                  = df,
        key                  = "x",
        cloud_interface      = mock_cloud_interface,
        disk_interface       = mock_disk_interface,
        params               = list(),
        use_disk_cache       = TRUE,
        num_retries          = 1
      )
    })
    test_that("it can write to the cloud", {
      expect_equal(.mock_cloud_env[["x"]], df)
    })
    test_that("it leaves a copy of the object on disk", {
      expect_equal(length(ls(.mock_disk_env)), 1)
      expect_equal(.mock_disk_env[[mock_filename]], df)
    })

    suppressMessages({
      write(
        obj                  = df2,
        key                  = "x",
        cloud_interface      = mock_cloud_interface,
        disk_interface       = mock_disk_interface,
        params               = list(),
        use_disk_cache       = TRUE,
        num_retries          = 1,
        overwrite_disk_cache = TRUE
      )
    })
    test_that("it overwrites the value in the cloud", {
      expect_equal(.mock_cloud_env[["x"]], df2)
    })
    test_that("it overwrites the value in disk", {
      expect_equal(length(ls(.mock_disk_env)), 1)
      expect_equal(.mock_disk_env[[mock_filename]], df2)
    })

    suppressMessages({
      write(
        obj                  = df3,
        key                  = "x",
        cloud_interface      = mock_cloud_interface,
        disk_interface       = mock_disk_interface,
        params               = list(),
        use_disk_cache       = TRUE,
        num_retries          = 1,
        overwrite_disk_cache = FALSE
      )
    })
    test_that("it overwrites the value in the cloud", {
      expect_equal(.mock_cloud_env[["x"]], df3)
    })
    test_that("it does not overwrite the value in disk", {
      expect_equal(length(ls(.mock_disk_env)), 1)
      expect_equal(.mock_disk_env[[mock_filename]], df2)
    })
  })
})
