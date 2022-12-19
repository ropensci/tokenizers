This is a breaking upgrade to address failing tests noted by CRAN maintainers.
The system dependency ICU has changed core functionality. As a result,
we have removed the single function and related tests affected by this change.

## Test environments

* Local OS X install: R-Release
* R-Hub: R-release, R-devel
* Win-builder: R-devel

## R CMD check results

* One NOTE pertains to non-ASCII strings in test files only, which are
  necessary to ensure the package's functionality on Windows.
* There may be a WARNING relating to compiling code with Rcpp. This is an issue
  with the Rcpp package which has been addressed but for which a fix has not yet
  made its way to CRAN.

## revdepcheck results

We checked 20 reverse dependencies (18 from CRAN + 2 from Bioconductor), comparing R CMD check results across CRAN and dev versions of this package.

 * We have communicated with the quanteda package maintainer (who is also a
   contributor to this package) and believe the fix is very simple.
 * We have communicated with the tidytext package maintainer, since that package
   wraps some functionality.
 * The remaining packages are unaffected.
