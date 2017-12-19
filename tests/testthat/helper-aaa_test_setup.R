.mock_cloud_env <- new.env()
.mock_disk_env  <- new.env()

clear_test_environments <- function() {
  rm(list = ls(.mock_cloud_env), envir = .mock_cloud_env)
  rm(list = ls(.mock_disk_env),  envir = .mock_disk_env)
}


mock_cloud_interface <- CloudInterface$new(
  get_fn = function(key, filename, params) {
    .mock_disk_env[[filename]] <- .mock_cloud_env[[key]]
  },
  put_fn = function(key, filename, params) {
    .mock_cloud_env[[key]] <- .mock_disk_env[[filename]]
  },
  exists_fn = function(key, params) {
    isTRUE(key %in% ls(.mock_cloud_env))
  }
)

mock_disk_interface <- DiskInterface$new(
    read_fn = function(filename, params) {
    .mock_disk_env[[filename]]
  },
    write_fn = function(obj, filename, params) {
    .mock_disk_env[[filename]] <- obj
  }
)

with_mocked_disk_interface <- function(expr) {
	with_mock(
		`base::unlink` = function(filename) {
      remaining_filenames <- setdiff(ls(.mock_disk_env), filename)
      remaining_files     <- lapply(remaining_filenames, function(x) { .mock_disk_env[[x]] })
      .mock_disk_env      <<- as.environment(remaining_files)
		},
      `base::file.exists` = function(filename) {
      isTRUE(filename %in% ls(.mock_disk_env))
    }, {
   eval(expr, envir = parent.frame())
  })
}

remove_from_in_session_cache <- function(key, cloud_name = "mock_cloud_interface", storage_format = "mock_disk_interface") {
  session_cache$forget(get_session_cache_key(key, cloud_name, storage_format))
}
