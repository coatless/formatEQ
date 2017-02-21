
`formatEQ` correcting assignment styling in [`formatR`](https://cran.r-project.org/package=formatR)
===================================================================================================

The objective of this package is to write a short patch to Yihui Xie's [`formatR`](https://cran.r-project.org/package=formatR) package that inverts the default behavior of the assignment operator replacement formatting rule so that whenever `<-` is present it is replaced with `=`.

Download Instructions
---------------------

Presently, the package is only available on GitHub. It may eventually matriculate to CRAN if there is interest.

``` r
# install.packages("devtools")
devtools::install_github("coatless/formatEQ")
```

How was this accomplished?
--------------------------

To accomplish this, an [override function trick](https://stat.ethz.ch/pipermail/r-help/2008-August/171217.html) developed by [Henrik Bengtsson](https://github.com/HenrikBengtsson) is employed. The trick allows for a very minimal change to occur to the [`replacement_assignment()`](https://github.com/yihui/formatR/blob/022da8c1be2c04c8374d19907c41bacd5d0ecfcc/R/utils.R#L1-L18) function within [`formatR`](https://cran.r-project.org/package=formatR). Thus, there is no need to copy *all* of the package, but only the necessary components. On package load, the function trick is then applied. Thus, if you were to independently load `formatR`, the content would remain exactly the same.

Why not submit a patch?
-----------------------

Unfortunately, this is more of a style guideline change and, thus, does *not* warrant a patch. Furthermore, the API for the `tidy_source` function is already quite established and adding an option to seeminly invert the authors intended functionality would likely yield numerous breakages. So, the safer course of action is to provide a way for regenades of assignment to express themselves since:

> No matter how hard you try, you can't stop us now
>
> We're the renegades of this time and age
>
> This is the time and age of renegades
>
> --- [Rage Against the Machine - Renegades of Funk](https://www.youtube.com/watch?v=K626gMvu2ds)
