## # Sow's ear example

### Lines with three (or more) starting comments at the beginning of a
### line are not included in the compiled version (and emacs/ESS
### helpfully pushes such lines right to the edge).

## Sometimes I find it easier to start with a plain R script, rather
## than a Rnw file, especially when collaborating.  The normal
## noweb-style literate programming pushes the document to the front,
## with the code secondary.  I personally would find literate
## programming easier if it just came from the "usual" way of writing
## code.  This would make it way easier to convert random analysis
## scripts into nice looking analyses.

## This also means that, following Carl Boettiger's lead, I can help
## people by writing and annotating *their* R scripts, and compile
## them into something nice without appearing to have radically
## changed the format.  This style is very lightweight.

## Generate some random numbers
x <- runif(30)
y <- rnorm(30)

## Make a plot:
##+ scatter,fig.width=6,fig.height=3
plot(x, y)

## Lines that begin with `##+` are options; they will be put into
## either Rnw or Rmd format when running `sowsear` on the file.  This
## converts script.R into script.Rnw or script.Rmd, which can then be
## run through `knitr` and `TeX` or `pandoc`, respectively.

## ## Other headings
## Cumulative sum of the random $x$'s
cumsum(x)

## The main drawback of this approach that I can see is that if one is
## to tangle the Rnw/Rmd file, then it would overwrite the source
## file.  I never tangle though, so I'm not personally concerned about
## this.
