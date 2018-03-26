extract_s3cmd_bucket_location <- function(params) {
  if (!is.null(params$bucket_location)) {
    pp("--bucket-location #{params$bucket_location}")
  } else { "" }
}

extract_s3cmd_verbose_flag <- function(params) {
  if (isTRUE(params$verbose)) { "--verbose --progress" } else { "--no-progress" }
}

extract_s3cmd_debug_flag <- function(params) {
  if (isTRUE(params$debug)) { "--debug" } else { "" }
}

#' @rdname s3cmd
options_for_s3cmd_get <- function(params) {
  pp('#{extract_s3cmd_bucket_location(params)} ',
     '#{extract_s3cmd_verbose_flag(params)} ',
     '#{extract_s3cmd_debug_flag(params}')
}

#' @rdname s3cmd
options_for_s3cmd_put <- function(params) {
  pp('#{extract_s3cmd_bucket_location(params)} ',
     '#{extract_s3cmd_debug_flag(params}')
}
