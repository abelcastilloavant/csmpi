context("read")

clear_test_environments()

with_mocked_disk_interface({
  describe("read without caching", {
    .mock_cloud_env[["x"]] <- 7
    suppressMessages({
      actual_value <- read(
        key               = "x",
        cloud_interface   = mock_cloud_interface,
        disk_interface    = mock_disk_interface,
        params            = list(),
        use_session_cache = FALSE,
        use_disk_cache    = FALSE,
        num_retries       = 1
      )
    })
    test_that("it retrieves the value in the cloud", {
      expect_equal(actual_value, 7)
    })
    test_that("it doesn't leave behind a file on disk", {
      expect_equal(length(ls(.mock_disk_env)), 0)
    })
  })
})

clear_test_environments()

with_mocked_disk_interface({
  describe("read using in-session caching", {
    .mock_cloud_env[["x"]] <- 7
    suppressMessages({
      actual_value <- read(
        key = "x",
        cloud_interface   = mock_cloud_interface,
        disk_interface    = mock_disk_interface,
        params            = list(),
        use_session_cache = TRUE,
        use_disk_cache    = FALSE,
        num_retries       = 1
      )
    })
    test_that("it retrieves the value in the cloud", {
      expect_equal(actual_value, 7)
    })
    test_that("it doesn't leave behind a file on disk", {
      expect_equal(length(ls(.mock_disk_env)), 0)
    })
    .mock_cloud_env[["x"]] <- 8
    suppressMessages({
      actual_value <- read(
        key               = "x",
        cloud_interface   = mock_cloud_interface,
        disk_interface    = mock_disk_interface,
        params            = list(),
        use_session_cache = TRUE,
        use_disk_cache    = FALSE,
        num_retries       = 1
      )
    })
    test_that("it retrieves the value from session cache", {
      expect_equal(actual_value, 7)
    })
    test_that("it doesn't leave behind a file on disk", {
      expect_equal(length(ls(.mock_disk_env)), 0)
    })
    write_to_session_cache(9, get_session_cache_key("x", "mock_cloud_interface", "mock_disk_interface"))
    suppressMessages({
      actual_value <- read(
        key               = "x",
        cloud_interface   = mock_cloud_interface,
        disk_interface    = mock_disk_interface,
        params            = list(),
        use_session_cache = TRUE,
        use_disk_cache    = FALSE,
        num_retries       = 1
      )
    })
    test_that("it retrieves the value in cache", {
      expect_equal(actual_value, 9)
    })
    test_that("it leaves behind a file on disk", {
      expect_equal(length(ls(.mock_disk_env)), 0)
    })
  })
})

clear_test_environments()
remove_from_in_session_cache("x")

with_mocked_disk_interface({
  describe("read using disk caching", {
    .mock_cloud_env[["x"]] <- 7
    suppressMessages({
      actual_value <- read(
        key               = "x",
        cloud_interface   = mock_cloud_interface,
        disk_interface    = mock_disk_interface,
        params            = list(),
        use_session_cache = FALSE,
        use_disk_cache    = TRUE,
        num_retries       = 1
      )
    })
    test_that("it retrieves the value in the cloud", {
      expect_equal(actual_value, 7)
    })
    test_that("it leaves behind a file on disk", {
      expect_equal(length(ls(.mock_disk_env)), 1)
    })
    .mock_cloud_env[["x"]] <- 8
    write_to_session_cache(9, get_session_cache_key("x", "mock_cloud_interface", "mock_disk_interface"))
    suppressMessages({
      actual_value <- read(
        key               = "x",
        cloud_interface   = mock_cloud_interface,
        disk_interface    = mock_disk_interface,
        params            = list(),
        use_session_cache = FALSE,
        use_disk_cache    = TRUE,
        num_retries       = 1
      )
    })
    test_that("it retrieves the value in the cloud", {
      expect_equal(actual_value, 7)
    })
    test_that("it leaves behind a file on disk", {
      expect_equal(length(ls(.mock_disk_env)), 1)
    })
  })
})

clear_test_environments()
remove_from_in_session_cache("x")
