s3cmdread <- function(name, path = s3cmd_default_path(), storage_format = "RDS", ...) {
  params <- list(...)
  params$bucket_name <- path
  csmpi_read(name, "s3cmd", storage_format, params)
}

s3cmdstore <- function(obj, name, path = s3cmd_default_path(), storage_format = "RDS", ..., force = FALSE) {
  params <- list(...)
  params$bucket_name <- path
  csmpi_write(obj, name, "s3cmd", storage_format, params, use_disk_cache = force, overwrite_disk_cache = force)
}

