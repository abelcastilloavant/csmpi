extract_awscli_profile <- function(params) {
  if (!is.null(params$profile)) {
    pp('--profile #{params$profile}')
  } else {""}
}

extract_awscli_region <- function(params) {
  if (!is.null(params$region)) {
    pp('--region #{params$region}')
  } else {""}
}

#' Tooling for awscli interface.
#'
#' @param key simple string. The key to read/write to in S3.
#' @param filename simple string. The file to read/write to on
#'   disk when reading/writing from S3.
#' @param params list. Addiitonal parameters to pass to read/write functions.
#'
#' @name awscli

#' @rdname awscli
options_for_awscli_command <- function(params) {
  pp("#{extract_awscli_profile(params)} "
     "#{extract_awscli_region(params)}")
}

#' @rdname awscli
get_using_awscli <- function(key, filename, params) {
  cmd <- paste(which_command("awscli"), "s3", "cp")
  system(pp('#{cmd} #{key} #{filename}',
    '#{options_for_awscli_command(params)'))
}

#' @rdname awscli
put_using_awscli <- function(key, filename, params) {
  cmd <- paste(which_command("awscli"), "s3", "cp")
  system(pp('#{cmd} #{filename} #{key}',
    '#{options_for_awscli_command(params)'))
}

#' @rdname awscli
exists_using_awscli <- function(key, params) {
  cmd <- paste(which_command("awscli"), "s3", "ls")
  result <- system(pp('#{cmd} #{filename}',
              '#{options_for_awscli_command(params)'))
  sum(grepl(paste0(basename(name), "$"), results)) > 0
}

awscli_interface <- CloudInterface$new(get_using_awscli, put_using_awscli, exists_using_awscli)
