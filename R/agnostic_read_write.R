read_from_cloud_storage <- function(key, cloud_name, storage_format, params,
                                      session_cache = getOption("csmpi.session_cache", TRUE)) {
  if (isTRUE(session_cache) && `in_session_cache?`(key, cloud_name, storage_format)) {
    return(read_from_session_cache(key, cloud_name, storage_format))
  }

  cloud_interface <- CLOUD_INTERFACES[[cloud_name]]
  disk_interface  <- DISK_INTERFACES[[storage_format]]
  tmpfile         <- tempfile(); on.exit(unlink(tmpfile))

  cloud_interface$get(key, tmpfile, params)
  obj <- disk_interface$read(tmpfile, params)

  if (isTRUE(session_cache)) {
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
