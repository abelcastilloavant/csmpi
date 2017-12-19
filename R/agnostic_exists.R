exists <- function(key, cloud_interface, params) {
  cloud_interface$exists(key, params)
}

csmpi_exists <- function(key, cloud_name, params) {
  cloud_interface <- DEFAULT_CLOUD_INTERFACES[[cloud_name]]
  exists(key, cloud_interface, params)
}
