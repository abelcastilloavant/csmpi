.mock_cloud_env <- new.env()
.mock_disk_env  <- new.env()

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
