read_from_cloud_storage <- function(key, cloud_name, storage_format, params) {
  cloud_interface <- CLOUD_INTERFACES[[cloud_name]]
  disk_interface  <- DISK_INTERFACES[[storage_format]]

  tmpfile <- tempfile(); on.exit(unlink(tmpfile))
  cloud_interface$get(key, tmpfile, params)
  disk_interface$read(tmpfile, params)
}

write_to_cloud_storage <- function(obj, key, cloud_name, storage_format, params) {
  cloud_interface <- CLOUD_INTERFACES[[cloud_name]]
  disk_interface  <- DISK_INTERFACES[[storage_format]]

  tmpfile <- tempfile(); on.exit(unlink(tmpfile))
  disk_interface$write(obj, tmpfile, params)
  cloud_interface$put(key, tmpfile, params)
}
