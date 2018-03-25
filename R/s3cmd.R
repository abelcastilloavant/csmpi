#' Tooling for s3cmd interface.
#'
#' @param key simple string. The key to read/write to in S3.
#' @param filename simple string. The file to read/write to on
#'   disk when reading/writing from S3.
#' @param params list. Addiitonal parameters to pass to read/write functions.
#'
#' @name s3cmd

#' @rdname s3cmd
get_using_s3cmd <- function(key, filename, params) {
  system(pp('#{which_s3cmd()} get "#{params$bucket_name}/#{key}" ',
    ' #{filename} #{options_for_s3cmd_get(params)} '))
}

#' @rdname s3cmd
put_using_s3cmd <- function(key, filename, params) {
  system(pp('#{which_s3cmd()} put #{filename} "#{params$bucket_name}/#{key}" ',
    '#{options_for_s3cmd_put(params)}'))
}

#' @rdname s3cmd
exists_using_s3cmd <- function(key, params) {
  result <- system(pp('#{which_s3cmd()} ls "#{params$bucket_name}/#{key}" '), intern = TRUE)
  sum(grepl(paste(key, "(/[0-9A-Za-z]+)*/?$", sep = ""), result)) > 0
}

s3cmd_interface <- CloudInterface$new(get_using_s3cmd, put_using_s3cmd, exists_using_s3cmd)
