parse.sowsear <- function(script) {
  lines <- readLines(script)

  ## 1. exclude all lines with three or more hashes; these are
  ## meta comments and are removed (a bit similar to '%' comments in
  ## Rnw files)
  lines <- lines[!grepl("^\\#{3}", lines)]

  type <- sowsear.classify(lines)

  obj <- rle(type)
  contents <- split(lines, rep(seq_along(obj$lengths), obj$lengths))
  blocks <- mapply(list, type=obj$values, contents=contents,
                   SIMPLIFY=FALSE)
  names(blocks) <- NULL

  ## Strip off comments from marked up sections...
  for ( i in which(obj$values == "markup") )
    blocks[[i]]$contents <- sub("^## ?", "", blocks[[i]]$contents)

  ## And from options:
  for ( i in which(obj$values == "option") )
    blocks[[i]]$contents <-
      paste(sub("^##\\+ *", "", blocks[[i]]$contents),
            collapse=" ")

  blocks
}

process.sowsear <- function(blocks, type) {
  pat <- list(Rnw=c(chunk.begin="<<%s>>=", chunk.end="@ "),
              Rmd=c(chunk.begin="``` {r %s}",   chunk.end="```"))
  str <- pat[[type]]
         
  out <- character()
  option <- ""
  for ( b in blocks ) {
    type <- b$type
    if ( type == "option" ) {
      option <- b$contents
      next # avoids setting option below
    } else if ( type == "code" ) {
      out <- c(out, sprintf(str[["chunk.begin"]], option),
               b$contents,
               str[["chunk.end"]])
    } else if ( type == "markup" ) {
      out <- c(out, b$contents)
    }
    option <- ""
  }
  out
}

sowsear <- function(script, type="Rmd", output=NULL) {
  types <- c("Rnw", "Rmd")
  if ( is.null(type) ) {
    if ( is.null(output) )
      stop("At least one of output or type must be specified")
    type <- tools::file_ext(output)
    if ( !(type %in% types) )
      stop("Extension must be one of: ", paste(types, collapse=", "))
  } else {
    if ( is.null(output) )
      output <- paste(tools::file_path_sans_ext(script),
                      type, sep=".")
  }

  blocks <- parse.sowsear(script)
  out <- process.sowsear(blocks, type)
  writeLines(out, output)
  invisible(TRUE)
}

sowsear.classify <- function(lines) {
  ## Everything is code by default.
  type <- rep("code", length(lines))

  ## 2a: Determine which lines are markup; these begin with exactly
  ## two hashes, and then perhaps whitespace.
  type[grepl("^\\#{2}[[:space:]]?", lines)] <- "markup"
  ##  b: ...lines that are chunk options ( '##+')
  type[grepl("^\\#{2}\\+", lines)] <- "option"
  ##  c: ...blank lines
  type[grepl("^[[:space:]]*$", lines)] <- "blank"

  ## Collapse some basic types:
  obj <- rle(type)
  tmp <- paste(substr(obj$values, 1, 1), collapse="")
  ## Replace blanks in code blocks
  ##   code   / blank / code
  ##   option / blank / code
  ## with code:
  ##   orig   / code  / code
  tmp <- gsub("(?<=[co])b(?=c)", "c", tmp, perl=TRUE)
  ## Remaining blanks are markup
  tmp <- gsub("b",   "m",   tmp)
  ## Quick sanity check:
  if ( grepl("ob?m", tmp) )
    stop("Detected nonsensical option before markup")

  ## Put it back together:
  tr <- sort(unique(obj$values))
  names(tr) <- substr(tr, 1, 1)
  obj$values <- tr[strsplit(tmp, NULL)[[1]]]
  inverse.rle(obj)
}
