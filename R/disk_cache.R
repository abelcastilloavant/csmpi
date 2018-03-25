get_disk_cache_filename <- function(key, cloud_name, storage_format) {
  file.path(getOption("csmpi.disk_cache_dir", "~/.csmpicache"), cloud_name, storage_format,
    digest::digest(key))
}

`fetch_from_cloud?` <- function(use_disk_cache, filename) {
  !isTRUE(use_disk_cache) && !file.exists(filename)
}

`disk_cache_available?` <- function(use_disk_cache, disk_cache_filename, overwrite_disk_cache) {
  if (!isTRUE(use_disk_cache)) { return(FALSE) }
  if (!file.exists(disk_cache_filename)) { return(TRUE) }
  if (!isTRUE(overwrite_disk_cache)) {
    warning("File exists in disk cache, but `overwrite_disk_cache` is "
            "FALSE. Using a temp file instead.")
    return(FALSE)
  }
  unlink(disk_cache_filename)
  TRUE
}
