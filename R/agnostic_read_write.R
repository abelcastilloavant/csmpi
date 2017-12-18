read_from_cloud_storage <- function(key, cloud_name, storage_format, params,
                                      use_session_cache = getOption("csmpi.use_session_cache", TRUE),
                                      use_disk_cache = getOption("csmpi.use_disk_cache", FALSE),
                                      num_tries = getOption("csmpi.num_tries", 3)) {
  if (isTRUE(use_session_cache) && isTRUE(use_disk_cache)) {
    stop("Both 'use_session_cache' and 'use_disk_cache' are TRUE - we currently do not allow this.")
  }

  if (isTRUE(use_session_cache) && `in_session_cache?`(key, cloud_name, storage_format)) {
    message("reading ", key, " from session cache")
    return(read_from_session_cache(key, cloud_name, storage_format))
  }

  if (isTRUE(use_disk_cache)) {
    filename <- disk_cache_filename(key, cloud_name, storage_format)
  } else {
    filename <- tempfile(); on.exit(unlink(filename))
  }

  if (`fetch_from_cloud?`(use_disk_cache, key, cloud_name, storage_format)) {
    message("reading ", key, " from ", cloud_name)
    handlr::with_retries({
      CLOUD_INTERFACES[[cloud_name]]$get(key, filename, params)
    }, num_tries = num_tries, sleep = getOption("csmpi.sleep_time", 0.001))
  }

  obj <- DISK_INTERFACES[[storage_format]]$read(filename, params)

  if (isTRUE(use_session_cache)) {
    message("writing ", key, " to session cache")
    write_to_session_cache(obj, key, cloud_name, storage_format)
  }
  obj
}

write_to_cloud_storage <- function(obj, key, cloud_name, storage_format, params,
                                     use_disk_cache = getOption("csmpi.use_disk_cache", FALSE),
                                     num_tries = getOption("csmpi.num_tries", 3),
                                     overwrite_disk_cache = FALSE) {
  filename <- disk_cache_filename(key, cloud_name, storage_format)

  if (!isTRUE(use_disk_cache)) {
    filename <- tempfile(); on.exit(unlink(filename))
  }
  if (file.exists(filename) && !isTRUE(overwrite_disk_cache)) {
    filename <- tempfile(); on.exit(unlink(tmpfile))
  }

  DISK_INTERFACES[[storage_format]]$write(obj, filename, params)
  handlr::with_retries({
    CLOUD_INTERFACES[[cloud_name]]$put(key, filename, params)
  }, num_tries = num_tries, sleep = getOption("csmpi.sleep_time", 0.001))
}
