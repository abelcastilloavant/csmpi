`%||%` <- function(x, y) { if (is.null(x)) { y } else { x } }

#' Try evaluating an expression multiple times before erroring.
#'
#' Lifted from \code{https://github.com/peterhurford/handlr/blob/master/R/try_stack.R}
#'
#' @param num_tries numeric. The number of attempts.
#' @param sleep numeric. How long to wait between attempts.
#' @param expr expression. The expression to evaluate with retries.
#' @return TRUE if the expression gets evaluated successfully on some attempt.
with_retries <- function(expr, num_tries = 1, sleep= 0.001) {
  num_tries <- max(num_tries, 1L)
  current_try <- 0
  while (current_try < num_tries) {
    out <- evaluate::try_capture_stack(expr, env = parent.frame())
    if (!methods::is(out, "error")) break
    current_try <- current_try + 1
    message(paste0("Attempt ", current_try, " failed."))
    if (current_try < num_tries) {
      cat("Sleeping for ", sleep, "seconds\n")
      Sys.sleep(sleep)
    }
  }
  if (methods::is(out, "error")) {
    stop(out)
  } else {
    out
  }
}

#' Ruby-style string interpolation
#'
#' Writing strings for messages with variable content often involves a mess of
#' nested calls to \code{paste}. Use this function to reduce the clutter created by these.
#' Lifted from https://github.com/robertzk/productivus/blob/master/R/pp.R
#'
#' @examples
#' \dontrun{
#'   x <- 5
#'   pp("we assigned ${x} to x")
#'   x <- "this time we'll use a string"
#'   pp("we assigned ${x} to x, and the value of x changed")
#'   .small_env <- new.env()
#'   .small_env$x <- "this is inside an environment"
#'   pp("if we declare an environment, we see that x is ${x} there", envir = .small_env)
#' }
#' @param ... a character vector, or a (possibly nested) list of character vectors.
#' @param envir environment. The environment to fetch values to use in interpolation.
#' @param sep character. Passed into the \code{collapse} argument of \code{base::paste}.
#' @param collapse character. Passed into the \code{collapse} argument of \code{base::paste}.
pp <- function(..., envir = parent.frame(), sep = '', collapse = '') {
  string <- list(...)
  if (length(string) > 1)
    return(paste(sapply(string,
      function(s) { pp(s, envir = envir, sep = sep, collapse = collapse) }
    ), collapse = sep))
  string <- string[[1]]
  if (length(string) > 1)
    return(paste(sapply(string,
      function(s) { pp(s, envir = envir, sep = sep, collapse = collapse) }
    ), collapse = collapse))
  regex <- gregexpr('#\\{([^\\}]+)\\}', string, perl=TRUE)
  starts <- attr(regex[[1]], 'capture.start')
  lengths <- attr(regex[[1]], 'capture.length')
  buildstr <- ''
  last <- 1
  for(i in 1:length(attr(regex[[1]], 'capture.start'))) {
    buildstr <- append(buildstr,
      c(substr(string, last, starts[i] - 3),
        eval(parse(text = substr(string, starts[i], starts[i] + lengths[i] - 1)),
        envir = envir)
       ))

    last <- starts[i] + lengths[i] + 1
  }
  buildstr <- append(buildstr, substr(string, last, nchar(string)))
  paste(buildstr, collapse = '')
}

get_function_arguments <- function(fn) {
  names(as.list(args(fn)))
}

subset_by_function <- function(fn, lst) {
  lst[intersect(names(lst), get_function_arguments(fn))]
}

which_command <- function(cmd_name) {
  option_name <- pp("csmpi.#{cmd_name}_executable_path")
  cmd         <- getOption(option_name)
  if (isTRUE(nzchar(cmd))) { return(cmd) }
  as.character(Sys.which(cmd_name))
}
