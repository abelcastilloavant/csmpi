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
