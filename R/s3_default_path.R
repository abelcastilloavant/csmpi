s3_default_path <- function() {
  opt_name <- "csmpi.s3_default_path"
  path <- getOption(opt_name)
  if (is.null(path)) {
    stop(pp("The option '#{opt_name}' is NULL, but it should have the default path for s3cmd."))
  }
  path
}
