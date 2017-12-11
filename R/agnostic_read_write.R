read_from_cloud_storage <- function(key, cloud_name, storage_format, params,
                                      use_session_cache = getOption("csmpi.use_session_cache", TRUE),
                                      use_disk_cache = getOption("csmpi.use_disk_cache", FALSE)) {
  if (isTRUE(use_session_cache) && isTRUE(use_disk_cache)) {
    stop("Both 'use_session_cache' and 'use_disk_cache' are TRUE - we currently do not allow this.")
  }

  if (isTRUE(use_session_cache) && `in_session_cache?`(key, cloud_name, storage_format)) {
    return(read_from_session_cache(key, cloud_name, storage_format))
  }

  if (isTRUE(use_disk_cache) && `in_disk_cache?`(key, cloud_name, storage_format)) {
    filename <- disk_cache_filename(key, cloud_name, storage_format)
  } else {
    filename <- tempfile(); on.exit(unlink(filename))
  }

  cloud_interface <- CLOUD_INTERFACES[[cloud_name]]
  disk_interface  <- DISK_INTERFACES[[storage_format]]

  cloud_interface$get(key, filename, params)
  obj <- disk_interface$read(filename, params)

  if (isTRUE(use_session_cache)) {
    write_to_session_cache(obj, key, cloud_name, storage_format)
  }
  obj
}

write_to_cloud_storage <- function(obj, key, cloud_name, storage_format, params) {
  cloud_interface <- CLOUD_INTERFACES[[cloud_name]]
  disk_interface  <- DISK_INTERFACES[[storage_format]]
  tmpfile         <- tempfile(); on.exit(unlink(tmpfile))

  disk_interface$write(obj, tmpfile, params)
  cloud_interface$put(key, tmpfile, params)
}
