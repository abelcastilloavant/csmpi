#' Class of objects for interacting with objects in a cloud storage system.
#'
#' A CloudInterface object holds the methods to read, write, and check
#' for existence of objects in some external resource. We assume that
#' objects are stored in some kind of key/value structure with one-to-one
#' correspondence. We also assume that you are using disk space as an intermediary
#' between the cloud storage system and your R session.
#'
#' @param get_fn function. Used to get an object from the cloud.
#' @param put_fn function. Used to put an object to the cloud.
#' @param exists_fn function. Used to check if an object exists in the cloud.
#'
#' @export
CloudInterface <- R6::R6Class("CloudInterface",
  public = list(
    initialize = function(get_fn, put_fn, exists_fn) {
      private$get_fn    <- get_fn
      private$put_fn    <- put_fn
      private$exists_fn <- exists_fn
    },
    get = function(key, filename, params) {
      private$get_fn(key, filename, params)
    },
    put = function(key, filename, params) {
      private$put_fn(key, filename, params)
    },
    exists = function(key, params) {
      private$exists_fn(key, params)
    }
  ),
  private = list(
    get_fn    = "",
    put_fn    = "",
    exists_fn = ""
  )
)



#' Class of objects for interacting with objects downloaded to disk from the cloud.
#'
#' A DiskInterface objects holds methods for reading and writing objects from disk in
#' a particular format.  We assume that your "disk" is your local disk, as we use
#' base R functions such as \code{file.exists} to interact with objects.
#'
#' @param read_fn function. Used to read objects from disk to R.
#' @param write_fn function. Used to write objects from R to disk.
#'
#' @export
DiskInterface <- R6::R6Class("DiskInterface",
  public = list(
    initialize = function(read_fn, write_fn) {
      private$read_fn  <- read_fn
      private$write_fn <- write_fn
    },
    read = function(filename, params) {
      private$read_fn(filename, params)
    },
    write = function(obj, filename, params) {
      private$write_fn(obj, filename, params)
    }
  ),
  private = list(
    read_fn = "",
    write_fn = ""
  )
)
