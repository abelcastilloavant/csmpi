disk_cache_filename <- function(key, cloud_name, storage_format) {
  file.path(getOption("csmpi.disk_cache_dir", "~/.csmpicache"), cloud_name, storage_format,
    digest::digest(key))
}

`in_disk_cache?` <- function(key, cloud_name, storage_format) {
  file.exists(disk_cache_filename(key, cloud_name, storage_format))
}

`fetch_from_cloud?` <- function(use_disk_cache, key, cloud_name, storage_format) {
  !(isTRUE(use_disk_cache) && `in_disk_cache?`(key, cloud_name, storage_format))
}
