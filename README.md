# sowsear: Make Silk (knitr files) from a sow's ear (an R script)

[![Build Status](https://travis-ci.org/richfitz/sowsear.png?branch=master)](https://travis-ci.org/richfitz/sowsear)

Make silk from a sow's ear by converting a plain R script into
something that can be knit()'ed with knitr!

Basically, convert an R script from something like this:

```
## # Heading
## Description
some.code()
```

To this

    # Heading
    Description
    ``` {r }
    some.code()
    ```

which can then be run through `knit`.
