read_ <- function(key, cloud_interface, disk_interface, params,
          use_session_cache = getOption("csmpi.use_session_cache", TRUE),
          use_disk_cache = getOption("csmpi.use_disk_cache", FALSE),
          num_retries = getOption("csmpi.num_retries", 3),
          session_cache_key, disk_cache_filename,
          cloud_name_, storage_format_) {

  if (isTRUE(use_session_cache) && isTRUE(use_disk_cache)) {
    stop("Both 'use_session_cache' and 'use_disk_cache' are TRUE - we currently do not allow this.")
  }

  session_cache_key   <- get_session_cache_key(key, cloud_name_, storage_format_)
  disk_cache_filename <- get_disk_cache_filename(key, cloud_name_, storage_format_)

  if (missing(session_cache_key)) {
    session_cache_key <- get_session_cache_key(key, cloud_name_, storage_format_)
  }

  if (missing(disk_cache_filename)) {
    disk_cache_filename <- get_disk_cache_filename(key, cloud_name_, storage_format_)
  }

  if (isTRUE(use_session_cache) && `in_session_cache?`(session_cache_key)) {
    message("reading ", key, " from session cache")
    return(read_from_session_cache(session_cache_key))
  }

  if (isTRUE(use_disk_cache)) {
    filename <- disk_cache_filename
  } else {
    filename <- tempfile(); on.exit(unlink(filename))
  }

  if (`fetch_from_cloud?`(use_disk_cache, disk_cache_filename)) {
    message("reading ", key, " from ", cloud_name_)
    handlr::with_retries({
      cloud_interface$get(key, filename, params)
    }, num_tries = num_retries, sleep = getOption("csmpi.sleep_time", 0.001))
  }

  obj <- use_read_hook(disk_interface$read(filename, params))

  if (isTRUE(use_session_cache)) {
    message("writing ", key, " to session cache")
    write_to_session_cache(obj, session_cache_key)
  }
  obj
}

read <- function(key, cloud_interface, disk_interface, params,
          use_session_cache = getOption("csmpi.use_session_cache", TRUE),
          use_disk_cache = getOption("csmpi.use_disk_cache", FALSE),
          num_retries = getOption("csmpi.num_retries", 3),
          session_cache_key, disk_cache_filename, cloud_name_, storage_format_) {

  if (missing(cloud_name_)) {
    cloud_name_ <- deparse(substitute(cloud_interface))
  }
  if (missing(storage_format_)) {
    storage_format_ <- deparse(substitute(disk_interface))
  }

  # escape hatch for NSE
  read_(key, cloud_interface, disk_interface, params, use_session_cache, use_disk_cache,
        num_retries, session_cache_key, disk_cache_filename, cloud_name_, storage_format_)
}

csmpi_read <- function(key, cloud_name, storage_format, params,
                use_session_cache = getOption("csmpi.use_session_cache", TRUE),
                use_disk_cache = getOption("csmpi.use_disk_cache", FALSE),
                num_retries = getOption("csmpi.num_retries", 3)) {
  cloud_interface     <- DEFAULT_CLOUD_INTERFACES[[cloud_name]]
  disk_interface      <- DEFAULT_DISK_INTERFACES[[storage_format]]

  read(key, cloud_interface, disk_interface, params, use_session_cache, use_disk_cache,
         num_retries, session_cache_key, disk_cache_filename, cloud_name, storage_format)
}

