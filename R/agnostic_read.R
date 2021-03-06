#' Non-NSE version of \code{csmpi_custom_read}.
#' @inheritParams csmpi_custom_read
#' @inheritParams csmpi_read
#' @inheritParams csmpi_write
csmpi_custom_read_ <- function(key, cloud_interface, disk_interface, params,
          use_session_cache = getOption("csmpi.use_session_cache", FALSE),
          use_disk_cache = getOption("csmpi.use_disk_cache", FALSE),
          num_retries = getOption("csmpi.num_retries", 3),
          cloud_name_, storage_format_) {

  if (isTRUE(use_session_cache) && !requireNamespace("cacher")) {
    warning("Cannot use session cache unless you install 'cacher' package from Github")
    use_session_cache <- FALSE
  }

  if (isTRUE(use_session_cache) && isTRUE(use_disk_cache)) {
    stop("Both 'use_session_cache' and 'use_disk_cache' are TRUE - we currently do not allow this.")
  }

  if (isTRUE(use_session_cache) && `in_session_cache?`(session_cache_key)) {
    session_cache_key <- get_session_cache_key(key, cloud_name_, storage_format_)
    message("reading ", key, " from session cache")
    return(read_from_session_cache(session_cache_key))
  }

  if (isTRUE(use_disk_cache)) {
    filename <- get_disk_cache_filename(key, cloud_name_, storage_format_)
  } else {
    filename <- tempfile(); on.exit(unlink(filename))
  }

  if (`fetch_from_cloud?`(use_disk_cache, disk_cache_filename)) {
    message("reading ", key, " from ", cloud_name_)
    with_retries({
      cloud_interface$get(key, filename, params)
    }, num_tries = num_retries, sleep = getOption("csmpi.sleep_time", 0.001))
  }

  obj <- use_read_hook(disk_interface$read(filename, params))

  if (isTRUE(use_session_cache)) {
    message("writing ", key, " to session cache")
    write_to_session_cache(obj, get_session_cache_key(key, cloud_name_, storage_format_))
  }
  obj
}

#' Read from the cloud using custom cloud and disk interfaces.
#'
#' @param cloud_interface CloudInterface object. The cloud interface to use.
#' @param disk_interface DiskInterface object. The disk interface to use.
#' @param cloud_name_ simple_string. The name of the cloud interface, used to
#'   create unique file names for caching. If not provided, will be computed
#'   from the cloud interface using non-standard evaluation.
#' @param storage_format_ simple_string. The name of the disk interface, used to
#'   create unique file names for caching. If not provided, will be computed
#'   from the disk interface using non-standard evaluation.
#' @inheritParams csmpi_read
#' @inheritParams csmpi_write
#'
#' @export
csmpi_custom_read <- function(key, cloud_interface, disk_interface, params,
          use_session_cache = getOption("csmpi.use_session_cache", TRUE),
          use_disk_cache = getOption("csmpi.use_disk_cache", FALSE),
          num_retries = getOption("csmpi.num_retries", 3),
          cloud_name_, storage_format_) {

  if (missing(cloud_name_)) {
    cloud_name_ <- deparse(substitute(cloud_interface))
  }
  if (missing(storage_format_)) {
    storage_format_ <- deparse(substitute(disk_interface))
  }

  csmpi_custom_read_(key, cloud_interface, disk_interface, params, use_session_cache, use_disk_cache,
        num_retries, cloud_name_, storage_format_)
}

#' Read an R object to the cloud.
#'
#' @param use_session_cache logical. Whether or not to cache the object in memory.
#'   Defaults to the option \code{csmpi.use_session_cache}, or \code{FALSE} if
#'   the option is not set.
#' @inheritParams csmpi_write
#' @export
csmpi_read <- function(key, cloud_name, storage_format, params,
                use_session_cache = getOption("csmpi.use_session_cache", TRUE),
                use_disk_cache = getOption("csmpi.use_disk_cache", FALSE),
                num_retries = getOption("csmpi.num_retries", 3)) {
  cloud_interface     <- DEFAULT_CLOUD_INTERFACES[[cloud_name]]
  disk_interface      <- DEFAULT_DISK_INTERFACES[[storage_format]]

  csmpi_custom_read(key, cloud_interface, disk_interface, params, use_session_cache, use_disk_cache,
         num_retries, cloud_name, storage_format)
}

