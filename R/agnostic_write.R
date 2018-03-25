#' Non-NSE version of \code{write}.
#' @inheritParams csmpi_custom_write
#' @inheritParams csmpi_write
csmpi_custom_write_ <- function(obj, key, cloud_interface, disk_interface, params,
            use_disk_cache = getOption("csmpi.use_disk_cache", FALSE),
            num_retries = getOption("csmpi.num_retries", 3),
            overwrite_disk_cache = FALSE, cloud_name_, storage_format_) {

  filename      <- get_disk_cache_filename(key, cloud_name_, storage_format_)
  use_temp_file <- `disk_cache_available?`(use_disk_cache, filename, overwrite_disk_cache)

  if (isTRUE(use_temp_file)) {
    filename <- tempfile(); on.exit(unlink(filename))
  }

  disk_interface$write(use_write_hook(obj), filename, params)
  with_retries({
    cloud_interface$put(key, filename, params)
  }, num_tries = num_retries, sleep = getOption("csmpi.sleep_time", 0.001))
}

#' Write to the cloud using custom cloud and disk interfaces.
#'
#' @param cloud_interface CloudInterface object. The cloud interface to use.
#' @param disk_interface DiskInterface object. The disk interface to use.
#' @param cloud_name_ simple_string. The name of the cloud interface, used to
#'   create unique file names for caching. If not provided, will be computed
#'   from the cloud interface using non-standard evaluation.
#' @param storage_format_ simple_string. The name of the disk interface, used to
#'   create unique file names for caching. If not provided, will be computed
#'   from the disk interface using non-standard evaluation.
#' @inheritParams csmpi_write
#'
#' @export
csmpi_custom_write <- function(obj, key, cloud_interface, disk_interface, params,
           use_disk_cache = getOption("csmpi.use_disk_cache", FALSE),
           num_retries = getOption("csmpi.num_retries", 3),
           overwrite_disk_cache = FALSE, cloud_name_, storage_format_) {

  if (missing(cloud_name_)) {
    cloud_name_ <- deparse(substitute(cloud_interface))
  }
  if (missing(storage_format_)) {
    storage_format_ <- deparse(substitute(disk_interface))
  }

  csmpi_custom_write_(obj, key, cloud_interface, disk_interface, params, use_disk_cache, num_retries,
           overwrite_disk_cache, cloud_name_, storage_format_)
}

#' Write an R object to the cloud.
#'
#' @param obj ANY. The object to write to the cloud.
#' @param key simple string. The key to record the object with.
#' @param cloud_name simple string. The name of the cloud interface to use.
#' @param storage_format simple_string. The name of the disk interface to use.
#' @param params list. Additional arguments to pass to interface methods.
#' @param use_disk_cache logical. Whether or not to cache the object on disk.
#'   Defaults to the option \code{csmpi.use_disk_cache}, or \code{FALSE} if
#'   the option is not set.
#' @param num_retries numeric. How many attempts to write before raising an error.
#'   Defaults to the option \code{csmpi.num_retries}, or \code{3} if
#'   the option is not set.
#' @param overwrite_disk_cache logical. If the object is already cached on disk,
#'   do we want to overwrite the cached copy?
#'
#' @export
csmpi_write <- function(obj, key, cloud_name, storage_format, params,
                 use_disk_cache = getOption("csmpi.use_disk_cache", FALSE),
                 num_retries = getOption("csmpi.num_retries", 3),
                 overwrite_disk_cache = FALSE) {
  cloud_interface     <- DEFAULT_CLOUD_INTERFACES[[cloud_name]]
  disk_interface      <- DEFAULT_DISK_INTERFACES[[storage_format]]

  csmpi_custom_write(obj, key, cloud_interface, disk_interface, params, use_disk_cache, num_retries,
          overwrite_disk_cache, cloud_name, storage_format)
}

