CloudInterface <- R6::R6Class("CloudInterface",
  public = list(
    initialize = function(get_fn, put_fn, exists_fn) {
      private$get_fn    <- get_fn
      private$put_fn    <- put_fn
      private$exists_fn <- exists_fn
    },
    get = function(...) {
      do.call(private$get_fn, list(...))
    },
    put = function(...) {
      do.call(private$put_fn, list(...))
    },
    exists = function(...) {
      do.call(private$exists_fn, list(...))
    }
  ),
  private = list(
    get_fn    = "",
    put_fn    = "",
    exists_fn = ""
  )
)
