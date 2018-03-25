read_plaintext <- function(filename, params) {
  collapse <- params$collapse
  params <- subset_by_function(readLines, params)
  txt <- do.call(readLines, c(list(filename), params))
  if (collapse) {
    paste0(txt, collapse = "\n")
  } else { txt }
}

write_plaintext <- function(obj, filename, params) {
  if (!is.character(obj)) {
    stop("You're trying to write a non-character object as plaintext. Please coerce your object to character first")
  }
  params <- subset_by_function(write, params)
  do.call(write, c(list(obj, file = filename), params))
}

plaintext_interface <- DiskInterface$new(read_plaintext, write_plaintext)
