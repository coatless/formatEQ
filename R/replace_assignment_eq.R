#' @details 
#' The objective of this package is to write a short patch to Yihui Xie's 
#' formatR package that inverts the behavior of arrow replacement formatting
#' rule so that instead of replacing \code{=} with \code{<-} the reverse occurs.
"_PACKAGE"

replace_assignment_eq = function(exp) {
  wc = codetools::makeCodeWalker(
    call = function(e, w) {
      cl = codetools::walkCode(e[[1]], w)
      arg = lapply(as.list(e[-1]), function(a) if (missing(a)) NA else {
        codetools::walkCode(a, w)
      })
      as.call(c(list(cl), arg))
    },
    leaf = function(e, w) {
      if (length(e) == 0 || inherits(e, "srcref")) return(NULL)
      # x = 1 is actually `=`(x, 1), i.e. `=` is a function
      if (identical(e, as.name("<-"))) e <- as.name("=")
      e
    })
  lapply(as.list(exp), codetools::walkCode, w = wc)
}

#' Modify the Definition of a Package Function
#' 
#' Places a new definition inside the body of an old function within
#' a package that is loaded either in the namespace or body.
#' @param fname   function name
#' @param fdef    function body definition
#' @param package name of package environment
#' @details 
#' The implementation of this function is based off of a list serv
#' conversation response by Henrik Bengtsson.
#' @references 
#' \url{https://stat.ethz.ch/pipermail/r-help/2008-August/171217.html}
modify_pkg_function = function(fname, fdef, package){
  env = getNamespace(package)
  unlockBindingO = unlockBinding
  unlockBindingO(fname, env)
  utils::assignInNamespace(fname, fdef, ns = package, envir = env)
  assign(fname, fdef, envir = env) 
  lockBinding(fname, env) 
}

.onLoad = function(libname, pkgname){
  modify_pkg_function("replace_assignment", replace_assignment_eq, "formatR")
}

#' Reformat R code while preserving blank lines and comments
#'
#' This function returns reformatted source code; it tries to preserve blank
#' lines and comments, which is different with \code{\link{parse}} and
#' \code{\link{deparse}}. It can also replace \code{=} with \code{<-} where
#' \code{=} means assignments, and reindent code by a specified number of spaces
#' (default is 4).
#' @param source a character string: location of the source code (default to be
#'   the clipboard; this means we can copy the code to clipboard and use
#'   \code{tidy_source()} without specifying the argument \code{source})
#' @param comment whether to keep comments (\code{TRUE} by default)
#' @param blank whether to keep blank lines (\code{TRUE} by default)
#' @param arrow whether to replace the assign operator \code{=} with \code{<-}
#' @param brace.newline whether to put the left brace \code{\{} to a new line
#'   (default \code{FALSE})
#' @param indent number of spaces to indent the code (default 4)
#' @param output output to the console or a file using \code{\link{cat}}?
#' @param text an alternative way to specify the input: if it is \code{NULL},
#'   the function will read the source code from the \code{source} argument;
#'   alternatively, if \code{text} is a character vector containing the source
#'   code, it will be used as the input and the \code{source} argument will be
#'   ignored
#' @param width.cutoff passed to \code{\link{deparse}}: integer in [20, 500]
#'   determining the cutoff at which line-breaking is tried (default to be
#'   \code{getOption("width")})
#' @param ... other arguments passed to \code{\link{cat}}, e.g. \code{file}
#'   (this can be useful for batch-processing R scripts, e.g.
#'   \code{tidy_source(source = 'input.R', file = 'output.R')})
#' @return A list with components \item{text.tidy}{the reformatted code as a
#'   character vector} \item{text.mask}{the code containing comments, which are
#'   masked in assignments or with the weird operator}
#' @note Be sure to read the reference to know other limitations.
#' @author Yihui Xie <\url{http://yihui.name}> with substantial contribution
#'   from Yixuan Qiu <\url{http://yixuan.cos.name}> and a very very very miniscule
#'   change from James Balamuta <\url{http://thecoatlessprofessor.com}> to
#'   enable a reverse equation clean.
#' @seealso \code{\link{parse}}, \code{\link{deparse}}
#' @references \url{http://yihui.name/formatR} (an introduction to this package,
#'   with examples and further notes)
#' @import utils
#' @export
#' @examples 
#' messy = system.file("format", "messy.R", package = "formatR")
#' tidy_source(messy)
#' 
#' # if you've copied R code into the clipboard
#' if (interactive()) {
#'   tidy_source("clipboard")
#'   
#'   # write into clipboard again
#'   tidy_source("clipboard", file = "clipboard")
#' }
tidy_source <- formatR::tidy_source
