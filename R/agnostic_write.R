write <- function(obj, key, cloud_interface, disk_interface, params,
           use_disk_cache = getOption("csmpi.use_disk_cache", FALSE),
           num_tries = getOption("csmpi.num_tries", 3),
           overwrite_disk_cache = FALSE, disk_cache_filename) {
  if (missing(disk_cache_filename)) {
    disk_cache_filename <- get_disk_cache_filename(key, deparse(substitute(cloud_interface)), deparse(substitute(disk_interface)))
  }

  filename <- disk_cache_filename

  if (!isTRUE(use_disk_cache)) {
    filename <- tempfile(); on.exit(unlink(filename))
  }
  if (file.exists(filename) && !isTRUE(overwrite_disk_cache)) {
    filename <- tempfile(); on.exit(unlink(filename))
  }

  disk_interface$write(obj, filename, params)
  handlr::with_retries({
    cloud_interface$put(key, filename, params)
  }, num_tries = num_tries, sleep = getOption("csmpi.sleep_time", 0.001))
}


write_to_cloud_storage <- function(obj, key, cloud_name, storage_format, params,
                                     use_disk_cache = getOption("csmpi.use_disk_cache", FALSE),
                                     num_tries = getOption("csmpi.num_tries", 3),
                                     overwrite_disk_cache = FALSE) {
  disk_cache_filename <- get_disk_cache_filename (key, cloud_name, storage_format)
  cloud_interface     <- DEFAULT_CLOUD_INTERFACES[[cloud_name]]
  disk_interface      <- DEFAULT_DISK_INTERFACES[[storage_format]]

  write(obj, key, cloud_interface, disk_interface, params, use_disk_cache, num_tries,
          overwrite_disk_cache, disk_cache_filename)
}

