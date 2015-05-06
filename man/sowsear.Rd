\name{sowsear}
\alias{sowsear}
\title{Generate Knitr File from an R Script}
\description{
  Generate a Knitr file (silk) from an R script (a sow's ear, usually).
  This takes a R script and generates a Rnw (R + LaTeX) or Rmd (R +
  Markdown) file.  Sections of the file with exactly two leading hashes
  are converted to "markup" (documentation sections), code is evaluated,
  and sections beginning "##+" are options for code chunks.  Sections
  with three or more hashes ("###") are ignored.
}
\usage{
sowsear(script, type="Rmd", output=NULL)
}
\arguments{
  \item{script}{An R script file.}

  \item{type}{If specified, either "Rnw" or "Rmd", indicating the
    required conversion target.  If not specified, this is guessed from
    the extension of \code{output}.}

  \item{output}{An output file name.  If not given, it is constructed
    from the input file name and the conversion type.  If neither 
    \code{output} nor \code{type} are given, output will be an Rmd file
    with the same base name as \code{script}.}
}
\value{
  Invisible \code{TRUE} on success.
}
\note{
  Currently, the Sweave version assumes your document is standalone.  It
  probably should offer a template, like \code{knitr}'s \code{stitch}.
}
\seealso{
  knit
}
\examples{
\dontrun{
file.copy(system.file("sowsear-example.R", package="sowsear"),
          ".", overwrite=FALSE)

sowsear("sowsear-example.R", "Rmd")

knit("sowsear-example.Rmd")

system("pandoc -s -S -i -o sowsear-example.html sowsear-example.md")

file.remove(sprintf("sowsear-example.%s", c("R", "Rmd", "md")))
}
}
\author{Richard G. FitzJohn}
%\keyword{}
