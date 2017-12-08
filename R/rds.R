read_using_rds <- function(filename, params) {
  args <- c(list(filename), params)
  do.call(readRDS, args)
}

write_using_rds <- function(obj, filename, params) {
  args <- c(list(obj, filename), params)
  do.call(writeRDS, args)
}

rds_interface <- DiskInterface$new(read_using_rds, write_using_rds)
