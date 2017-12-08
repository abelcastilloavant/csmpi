DiskInterface <- R6::R6Class("DiskInterface",
  public = list(
    initialize = function(read_fn, write_fn) {
      private$read_fn  <- read_fn
      private$write_fn <- write_fn
    },
    read = function(tmpfile, params) {
      private$read_fn(tmpfile, params)
    },
    write = function(obj, tmpfile, params) {
      private$write_fn(obj, tmpfile, params)
    }
  ),
  private = list(
    read_fn = "",
    write_fn = ""
  )
)
