use_read_hook <- function(obj) {
  check_object_size(obj)
  (attr(obj, "csmpi.hooks")$read %||% identity)(obj)
}

use_write_hook <- function(obj) {
  check_object_size(obj)
  (attr(obj, "csmpi.hooks")$read %||% identity)(obj)
}

check_object_size <- function(obj) {
  if (utils::object.size(obj) == 0) {
    warning("In csmpi package: object is of size 0, this is probably bad", call. = TRUE)
    NULL
  }
}
