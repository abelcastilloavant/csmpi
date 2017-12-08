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
    exists = function(key) {
      private$exists_fn(key)
    }
  ),
  private = list(
    get_fn    = "",
    put_fn    = "",
    exists_fn = ""
  )
)
