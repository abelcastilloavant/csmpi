disk_cache_filename <- function(key, cloud_name, storage_format) {
  file.path(getOption("csmpi.disk_cache_dir", "~/.csmpicache"), cloud_name, storage_format,
    digest::digest(key))
}

`in_disk_cache?` <- function(key, cloud_name, storage_format) {
  file.exists(disk_cache_filename(key, cloud_name, storage_format))
}

