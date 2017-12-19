which_s3cmd <- function() {
  if (isTRUE(nzchar(cmd <- getOption("csmpi.s3cmd_path")))) {
    cmd
  } else {
    as.character(Sys.which("s3cmd"))
  }
}

extract_bucket_location <- function(params) {
  if (!is.null(params$bucket_location)) {
    productivus::pp("--bucket-location #{params$bucket_location}")
  } else { "" }
}

s3cmd_default_path <- function() {
  opt_name <- "csmpi.s3cmd_default_path"
  path <- getOption(opt_name)
  if (is.null(path)) {
    stop(productivus::pp("The option '#{opt_name}' is NULL, but it should have the default path for s3cmd."))
  }
  path
}

get_using_s3cmd <- function(key, filename, params) {
  verbose <- if (isTRUE(params$verbose)) { "--verbose --progress" } else { "--no-progress" }
  debug   <- if (isTRUE(params$debug)) { "--debug" } else { "" }

  system(productivus::pp('#{which_s3cmd()} get "#{params$bucket_name}/#{key}" ',
    ' #{filename} #{extract_bucket_location(params)} #{verbose} #{debug}'))
}

put_using_s3cmd <- function(key, filename, params) {
  debug <- if (isTRUE(params$debug)) { "--debug" } else { "" }
  bucket  <- if (!is.null(params$bucket_location)) {
    productivus::pp("--bucket-location #{params$bucket_location}")
  } else { "" }
  system(productivus::pp('#{which_s3cmd()} put #{filename} "#{params$bucket_name}/#{key}" ',
    '#{extract_bucket_location(params)} #{debug}'))
}

exists_using_s3cmd <- function(...) {
  stop("not implemented yet")
}

s3cmd_interface <- CloudInterface$new(get_using_s3cmd, put_using_s3cmd, exists_using_s3cmd)
