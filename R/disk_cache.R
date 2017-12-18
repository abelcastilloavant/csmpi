get_disk_cache_filename <- function(key, cloud_name, storage_format) {
  file.path(getOption("csmpi.disk_cache_dir", "~/.csmpicache"), cloud_name, storage_format,
    digest::digest(key))
}

`fetch_from_cloud?` <- function(use_disk_cache, filename) {
  !(isTRUE(use_disk_cache) && file.exists(filename))
}
