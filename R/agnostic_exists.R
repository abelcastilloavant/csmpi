#' Check if an object exits in the cloud with a custom cloud interface.
#'
#' @param key simple string. The key under which the object is stored.
#' @param cloud_interface CloudInterface object. The cloud interface to use.
#' @param params list. Additional params for the cloud interface's \code{exists}
#'   method.
#'
#' @export
exists <- function(key, cloud_interface, params) {
  cloud_interface$exists(key, params)
}

#' Check if an object exits in the cloud.
#'
#' @param key simple string. The key under which the object is stored.
#' @param cloud_name simple string. The name of the cloud interface to use.
#' @param params list. Additional params for the cloud interface's \code{exists}
#'   method.
#'
#' @export
csmpi_exists <- function(key, cloud_name, params) {
  cloud_interface <- DEFAULT_CLOUD_INTERFACES[[cloud_name]]
  exists(key, cloud_interface, params)
}
