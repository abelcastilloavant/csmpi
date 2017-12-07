DiskInterface <- R6::R6Class("DiskInterface",
  public = list()
    initialize = function(read_fn, write_fn) {
      private$read_fn  <- read_fn
      private$write_fn <- write_fn
    },
    read = function(...) {
      do.call(private$read_fn, I(...))
    },
    write = function(...) {
      do.call(private$write_fn, I(...))
    }
  private = list(
    read_fn = "",
    write_fn = ""
  )
)
