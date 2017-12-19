write_ <- function(obj, key, cloud_interface, disk_interface, params,
            use_disk_cache = getOption("csmpi.use_disk_cache", FALSE),
            num_retries = getOption("csmpi.num_retries", 3),
            overwrite_disk_cache = FALSE, cloud_name_, storage_format_) {

  filename <- get_disk_cache_filename(key, cloud_name_, storage_format_)

  if (!isTRUE(use_disk_cache)) {
    filename <- tempfile(); on.exit(unlink(filename))
  }
  if (file.exists(filename) && !isTRUE(overwrite_disk_cache)) {
    filename <- tempfile(); on.exit(unlink(filename))
  }

  disk_interface$write(use_write_hook(obj), filename, params)
  handlr::with_retries({
    cloud_interface$put(key, filename, params)
  }, num_tries = num_retries, sleep = getOption("csmpi.sleep_time", 0.001))
}

write <- function(obj, key, cloud_interface, disk_interface, params,
           use_disk_cache = getOption("csmpi.use_disk_cache", FALSE),
           num_retries = getOption("csmpi.num_retries", 3),
           overwrite_disk_cache = FALSE, cloud_name_, storage_format_) {

  if (missing(cloud_name_)) {
    cloud_name_ <- deparse(substitute(cloud_interface))
  }
  if (missing(storage_format_)) {
    storage_format_ <- deparse(substitute(disk_interface))
  }

  # escape hatch for NSE
  write_(obj, key, cloud_interface, disk_interface, params, use_disk_cache, num_retries,
           overwrite_disk_cache, cloud_name_, storage_format_)
}

csmpi_write <- function(obj, key, cloud_name, storage_format, params,
                 use_disk_cache = getOption("csmpi.use_disk_cache", FALSE),
                 num_retries = getOption("csmpi.num_retries", 3),
                 overwrite_disk_cache = FALSE) {
  cloud_interface     <- DEFAULT_CLOUD_INTERFACES[[cloud_name]]
  disk_interface      <- DEFAULT_DISK_INTERFACES[[storage_format]]

  write(obj, key, cloud_interface, disk_interface, params, use_disk_cache, num_retries,
          overwrite_disk_cache, cloud_name, storage_format)
}

