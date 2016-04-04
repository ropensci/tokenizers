## Response to CRAN maintainers' feedback

CRAN maintainers pointed out that tests fail in an environment that uses the
Latin-1 environment by default. I have specified that the files which are loaded
for tests should be loaded as UTF-8. This should work for all Latin-1
environments, since tests which previously were skipped on Win-builder now pass
without being skipped.

## Test environments

* Local OS X install: R 3.2.4
* Ubuntu 14.04 (on Travis-CI): R-release, R-devel, R-oldrel
* Win-builder: R-devel and R-release

## R CMD check results

0 errors | 0 warnings | 1 note

* The 1 NOTE pertains to a new release of the package.