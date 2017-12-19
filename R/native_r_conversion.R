to_pure_r_object <- function(obj) {
  check_object_size(obj)
  (attr(obj, "csmpi.normalize")$read %||% identity)(obj)
}

from_pure_r_object <- function(obj) {
  check_object_size(obj)
  (attr(obj, "csmpi.normalize")$read %||% identity)(obj)
}

check_object_size <- function(obj) {
  if (utils::object.size(obj) == 0) {
    warning("In csmpi package: size-0 obj is being normalized", call. = TRUE)
    NULL
  }
}
