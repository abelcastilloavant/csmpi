read_using_rds <- function(filename, params) {
  readRDS(filename)
}

write_using_rds <- function(obj, filename, params) {
  saveRDS(obj, filename)
}

rds_interface <- DiskInterface$new(read_using_rds, write_using_rds)
