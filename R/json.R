read_json <- function(filename, params) {
  params <- subset_by_function(jsonlite::fromJSON, params)
  do.call(jsonlite::fromJSON, list(filename, params))
}

write_json <- function(obj, filename, params) {
  write_params <- subset_by_function(write, params)
  json_params  <- subset_by_function(jsonlite::toJSON, params)
  if (is.data.frame(obj) && isTRUE(params$by_rows)) {
    write_params$append    <- TRUE
    json_params$auto_unbox <- TRUE
    apply(obj, 1, function(rw) {
      json <- do.call(jsonlite::toJSON, list(as.list(rw), json_params))
      do.call(write, list(json, write_params))
    })
  } else {
    json <- do.call(jsonlite::toJSON, list(obj, json_params))
    do.call(write, list(json, write_params))
  }
}

json_interface <- DiskInterface$new(read_json, write_json)
