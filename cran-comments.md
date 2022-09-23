This is a minor update to fix bugs.

## Test environments

* Local OS X install: R-Release
* Ubuntu (on Travis-CI): R-release, R-devel, R-oldrel
* R-Hub: R-release, R-devel
* Win-builder: R-devel

## R CMD check results

* One NOTE pertains to non-ASCII strings in test files only, which are
  necessary to ensure the package's functionality on Windows.

## revdepcheck results

We checked 20 reverse dependencies (18 from CRAN + 2 from Bioconductor), comparing R CMD check results across CRAN and dev versions of this package.

 * We saw 0 new problems
