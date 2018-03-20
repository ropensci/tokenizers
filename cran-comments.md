This update adds new functionality and bug fixes to the tokenizers package as
detailed in the NEWS.md file.

As requested by CRAN maintainers, I have changed the URL to Project Gutenberg to
its base URL. CRAN automated tests likely receive a 403 error because the site
prevents scraping.

## Test environments

* Local OS X install: R-Release
* Ubuntu (on Travis-CI): R-release, R-devel, R-oldrel
* Local Ubuntu 16.04 nstall: R-release
* Win-builder: R-devel and R-release

## R CMD check results

* One NOTE pertains to a new release of the package. 
* One NOTE pertains to non-ASCII strings in test files only, which are
  necessary to ensure the package's functionality on Windows.
