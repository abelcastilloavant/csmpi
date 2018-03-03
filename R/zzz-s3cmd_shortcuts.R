#' Read an object from S3 into an R session using s3cmd.
#'
#' This function will read an object from AWS S3 using
#' s3cmd, download it to disk, and read it into the current
#' R session.
#'
#' To use this effectively, make sure that you are reading in
#' objects in the same format as you write them! (As of version 0.0.8,
#' the only storage format is RDS, but expect there to be more of them later)
#'
#' @param name simple string. The key used to store the object.
#' @param path simple string. The s3 bucket where the object is stored.
#' @param storage_format simple string. The name of the disk interface in
#'   /code{DEFAULT_DISK_INTERFACES} to use to read the object from disk into
#'   the R session.
#' @param ... additional parameters to pass to interface objects via \code{params}.
#'
#' @export
s3cmd_read <- function(name, path = s3cmd_default_path(), storage_format = "RDS", ...) {
  params <- list(...)
  params$bucket_name <- path
  csmpi_read(name, "s3cmd", storage_format, params)
}

#' Store an object from an R session to S3 using s3cmd.
#'
#' This function will write an object to a file on disk, and upload
#' the file to AWS S3 using s3cmd.
#'
#' To use this effectively, make sure that you are reading in
#' objects in the same format as you write them! (As of version 0.0.8,
#' the only storage format is RDS, but expect there to be more of them later)
#'
#' @param obj ANY. The R object to store.
#' @param force logical. Whether or not to overwrite the object in disk cache
#' @inheritParams s3cmd_read
#'
#' @export
s3cmd_store <- function(obj, name, path = s3cmd_default_path(), storage_format = "RDS", ..., force = FALSE) {
  params <- list(...)
  params$bucket_name <- path
  csmpi_write(obj, name, "s3cmd", storage_format, params, use_disk_cache = force, overwrite_disk_cache = force)
}

#' Check if an object exists in S3 using s3cmd.
#'
#' This function will check if there is an object in AWS S3 with the given key.
#' It will not check the integrity of the object - it will use s3cmd to check
#' if there is an object with that name.
#'
#' @inheritParams s3cmd_read
#'
#' @export
s3cmd_exists <- function(name, path = s3cmd_default_path(), ...) {
  params <- list(...)
  params$bucket_name <- path
  csmpi_exists(name, "s3cmd", params)
}
