read_table <- function(filename, params) {
  params <- subset_by_function(read.table, params)
  do.call(read.table, args)
}

write_table <- function(obj, filename, params) {
  if (!is.data.frame(obj)) {
    stop("Object provided is not a dataframe, cannot write to table format.")
  }
  args <- list(obj, filename, params, stringsAsFactors = FALSE)
  do.call(write.table, args)
}

table_interface <- DiskInterface$new(read_table, write_table)
