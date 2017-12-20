#' Tooling for s3cmd interface.
#'
#' @param key simple string. The key to read/write to in S3.
#' @param obj ANY. The object to write to S3.
#' @param filename simple string. The file to read/write to on
#'   disk when reading/writing from S3.
#' @param params list. Addiitonal parameters to pass to read/write functions.
#'
#' @name s3cmd


#' @rdname s3cmd
which_s3cmd <- function() {
  if (isTRUE(nzchar(cmd <- getOption("csmpi.s3cmd_path")))) {
    cmd
  } else {
    as.character(Sys.which("s3cmd"))
  }
}

#' @rdname s3cmd
extract_bucket_location <- function(params) {
  if (!is.null(params$bucket_location)) {
    productivus::pp("--bucket-location #{params$bucket_location}")
  } else { "" }
}

#' @rdname s3cmd
s3cmd_default_path <- function() {
  opt_name <- "csmpi.s3cmd_default_path"
  path <- getOption(opt_name)
  if (is.null(path)) {
    stop(productivus::pp("The option '#{opt_name}' is NULL, but it should have the default path for s3cmd."))
  }
  path
}

#' @rdname s3cmd
get_using_s3cmd <- function(key, filename, params) {
  verbose <- if (isTRUE(params$verbose)) { "--verbose --progress" } else { "--no-progress" }
  debug   <- if (isTRUE(params$debug)) { "--debug" } else { "" }

  system(productivus::pp('#{which_s3cmd()} get "#{params$bucket_name}/#{key}" ',
    ' #{filename} #{extract_bucket_location(params)} #{verbose} #{debug}'))
}

#' @rdname s3cmd
put_using_s3cmd <- function(key, filename, params) {
  debug  <- if (isTRUE(params$debug)) { "--debug" } else { "" }
  bucket <- if (!is.null(params$bucket_location)) {
    productivus::pp("--bucket-location #{params$bucket_location}")
  } else { "" }

  system(productivus::pp('#{which_s3cmd()} put #{filename} "#{params$bucket_name}/#{key}" ',
    '#{extract_bucket_location(params)} #{debug}'))
}

#' @rdname s3cmd
exists_using_s3cmd <- function(key, params) {
  result <- system(productivus::pp('#{which_s3cmd()} ls "#{params$bucket_name}/#{key}" '), intern = TRUE)
  sum(grepl(paste(key, "(/[0-9A-Za-z]+)*/?$", sep = ""), result)) > 0
}

s3cmd_interface <- CloudInterface$new(get_using_s3cmd, put_using_s3cmd, exists_using_s3cmd)
