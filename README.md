
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tokenizers

[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/tokenizers)](https://cran.r-project.org/package=tokenizers)
[![DOI](http://joss.theoj.org/papers/10.21105/joss.00655/status.svg)](https://doi.org/10.21105/joss.00655)
[![rOpenSci peer
review](https://badges.ropensci.org/33_status.svg)](https://github.com/ropensci/software-review/issues/33)
[![CRAN_Downloads](http://cranlogs.r-pkg.org/badges/grand-total/tokenizers)](https://cran.r-project.org/package=tokenizers)
[![Travis-CI Build
Status](https://travis-ci.org/ropensci/tokenizers.svg?branch=master)](https://travis-ci.org/ropensci/tokenizers)
[![Coverage
Status](https://img.shields.io/codecov/c/github/ropensci/tokenizers/master.svg)](https://codecov.io/github/ropensci/tokenizers?branch=master)

## Overview

This R package offers functions with a consistent interface to convert
natural language text into tokens. It includes tokenizers for shingled
n-grams, skip n-grams, words, word stems, sentences, paragraphs,
characters, shingled characters, lines, tweets, Penn Treebank, and
regular expressions, as well as functions for counting characters,
words, and sentences, and a function for splitting longer texts into
separate documents, each with the same number of words. The package is
built on the [stringi](http://www.gagolewski.com/software/stringi/) and
[Rcpp](https://www.rcpp.org/) packages for fast yet correct tokenization
in UTF-8.

See the “[Introduction to the tokenizers
Package](https://docs.ropensci.org/tokenizers/articles/introduction-to-tokenizers.html)”
vignette for an overview of all the functions in this package.

This package complies with the standards for input and output
recommended by the Text Interchange Formats. The TIF initiative was
created at an rOpenSci meeting in 2017, and its recommendations are
available as part of the [tif
package](https://github.com/ropenscilabs/tif). See the “[The Text
Interchange Formats and the tokenizers
Package](https://docs.ropensci.org/tokenizers/articles/tif-and-tokenizers.html)”
vignette for an explanation of how this package fits into that
ecosystem.

## Suggested citation

If you use this package for your research, we would appreciate a
citation.

``` r
citation("tokenizers")
#> 
#> To cite the tokenizers package in publications, please cite the paper
#> in the Journal of Open Source Software:
#> 
#>   Lincoln A. Mullen et al., "Fast, Consistent Tokenization of Natural
#>   Language Text," Journal of Open Source Software 3, no. 23 (2018):
#>   655, https://doi.org/10.21105/joss.00655.
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Article{,
#>     title = {Fast, Consistent Tokenization of Natural Language Text},
#>     author = {Lincoln A. Mullen and Kenneth Benoit and Os Keyes and Dmitry Selivanov and Jeffrey Arnold},
#>     journal = {Journal of Open Source Software},
#>     year = {2018},
#>     volume = {3},
#>     issue = {23},
#>     pages = {655},
#>     url = {https://doi.org/10.21105/joss.00655},
#>     doi = {10.21105/joss.00655},
#>   }
```

## Examples

The tokenizers in this package have a consistent interface. They all
take either a character vector of any length, or a list where each
element is a character vector of length one, or a data.frame that
adheres to the [tif corpus format](https://github.com/ropenscilabs/tif).
The idea is that each element (or row) comprises a text. Then each
function returns a list with the same length as the input vector, where
each element in the list contains the tokens generated by the function.
If the input character vector or list is named, then the names are
preserved, so that the names can serve as identifiers. For a
tif-formatted data.frame, the `doc_id` field is used as the element
names in the returned token list.

``` r
library(magrittr)
library(tokenizers)

james <- paste0(
  "The question thus becomes a verbal one\n",
  "again; and our knowledge of all these early stages of thought and feeling\n",
  "is in any case so conjectural and imperfect that farther discussion would\n",
  "not be worth while.\n",
  "\n",
  "Religion, therefore, as I now ask you arbitrarily to take it, shall mean\n",
  "for us _the feelings, acts, and experiences of individual men in their\n",
  "solitude, so far as they apprehend themselves to stand in relation to\n",
  "whatever they may consider the divine_. Since the relation may be either\n",
  "moral, physical, or ritual, it is evident that out of religion in the\n",
  "sense in which we take it, theologies, philosophies, and ecclesiastical\n",
  "organizations may secondarily grow.\n"
)
names(james) <- "varieties"

tokenize_characters(james)[[1]] %>% head(50)
#>  [1] "t" "h" "e" "q" "u" "e" "s" "t" "i" "o" "n" "t" "h" "u" "s" "b" "e" "c" "o"
#> [20] "m" "e" "s" "a" "v" "e" "r" "b" "a" "l" "o" "n" "e" "a" "g" "a" "i" "n" "a"
#> [39] "n" "d" "o" "u" "r" "k" "n" "o" "w" "l" "e" "d"
tokenize_character_shingles(james)[[1]] %>% head(20)
#>  [1] "the" "heq" "equ" "que" "ues" "est" "sti" "tio" "ion" "ont" "nth" "thu"
#> [13] "hus" "usb" "sbe" "bec" "eco" "com" "ome" "mes"
tokenize_words(james)[[1]] %>% head(10)
#>  [1] "the"      "question" "thus"     "becomes"  "a"        "verbal"  
#>  [7] "one"      "again"    "and"      "our"
tokenize_word_stems(james)[[1]] %>% head(10)
#>  [1] "the"      "question" "thus"     "becom"    "a"        "verbal"  
#>  [7] "one"      "again"    "and"      "our"
tokenize_sentences(james) 
#> $varieties
#> [1] "The question thus becomes a verbal one again; and our knowledge of all these early stages of thought and feeling is in any case so conjectural and imperfect that farther discussion would not be worth while."                                               
#> [2] "Religion, therefore, as I now ask you arbitrarily to take it, shall mean for us _the feelings, acts, and experiences of individual men in their solitude, so far as they apprehend themselves to stand in relation to whatever they may consider the divine_."
#> [3] "Since the relation may be either moral, physical, or ritual, it is evident that out of religion in the sense in which we take it, theologies, philosophies, and ecclesiastical organizations may secondarily grow."
tokenize_paragraphs(james)
#> $varieties
#> [1] "The question thus becomes a verbal one again; and our knowledge of all these early stages of thought and feeling is in any case so conjectural and imperfect that farther discussion would not be worth while."                                                                                                                                                                                                                                                                   
#> [2] "Religion, therefore, as I now ask you arbitrarily to take it, shall mean for us _the feelings, acts, and experiences of individual men in their solitude, so far as they apprehend themselves to stand in relation to whatever they may consider the divine_. Since the relation may be either moral, physical, or ritual, it is evident that out of religion in the sense in which we take it, theologies, philosophies, and ecclesiastical organizations may secondarily grow. "
tokenize_ngrams(james, n = 5, n_min = 2)[[1]] %>% head(10)
#>  [1] "the question"                   "the question thus"             
#>  [3] "the question thus becomes"      "the question thus becomes a"   
#>  [5] "question thus"                  "question thus becomes"         
#>  [7] "question thus becomes a"        "question thus becomes a verbal"
#>  [9] "thus becomes"                   "thus becomes a"
tokenize_skip_ngrams(james, n = 5, k = 2)[[1]] %>% head(10)
#>  [1] "the"                  "the question"         "the thus"            
#>  [4] "the becomes"          "the question thus"    "the question becomes"
#>  [7] "the question a"       "the thus becomes"     "the thus a"          
#> [10] "the thus verbal"
tokenize_ptb(james)[[1]] %>% head(10)
#>  [1] "The"      "question" "thus"     "becomes"  "a"        "verbal"  
#>  [7] "one"      "again"    ";"        "and"
tokenize_lines(james)[[1]] %>% head(5)
#> [1] "The question thus becomes a verbal one"                                   
#> [2] "again; and our knowledge of all these early stages of thought and feeling"
#> [3] "is in any case so conjectural and imperfect that farther discussion would"
#> [4] "not be worth while."                                                      
#> [5] "Religion, therefore, as I now ask you arbitrarily to take it, shall mean"
```

The package also contains functions to count words, characters, and
sentences, and these functions follow the same consistent interface.

``` r
count_words(james)
#> varieties 
#>       112
count_characters(james)
#> varieties 
#>       673
count_sentences(james)
#> varieties 
#>        13
```

The `chunk_text()` function splits a document into smaller chunks, each
with the same number of words.

## Contributing

Contributions to the package are more than welcome. One way that you can
help is by using this package in your R package for natural language
processing. If you want to contribute a tokenization function to this
package, it should follow the same conventions as the rest of the
functions whenever it makes sense to do so.

Please note that this project is released with a Contributor Code of
Conduct. By participating in this project you agree to abide by its
terms.

------------------------------------------------------------------------

[![rOpenSCi
logo](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)
