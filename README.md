<!-- README.md is generated from README.Rmd. Please edit that file -->
tokenizers
----------

An R package that collects functions with a consistent interface to convert natural language text into tokens.

**Author:** [Lincoln Mullen](http://lincolnmullen.com)<br> **License:** [MIT](http://opensource.org/licenses/MIT)<br> **Status:** In development

[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/tokenizers)](http://cran.r-project.org/package=tokenizers) [![Travis-CI Build Status](https://travis-ci.org/lmullen/tokenizers.svg?branch=master)](https://travis-ci.org/lmullen/tokenizers)

### Installation

To get the development version from GitHub, use [devtools](https://github.com/hadley/devtools).

``` r
# install.packages("devtools")
devtools::install_github("lmullen/tokenizers")
```

### Examples

``` r
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

tokenize_chars(james)[[1]] %>% head(50)
#>  [1] "t" "h" "e" "q" "u" "e" "s" "t" "i" "o" "n" "t" "h" "u" "s" "b" "e"
#> [18] "c" "o" "m" "e" "s" "a" "v" "e" "r" "b" "a" "l" "o" "n" "e" "a" "g"
#> [35] "a" "i" "n" "a" "n" "d" "o" "u" "r" "k" "n" "o" "w" "l" "e" "d"
tokenize_words(james)[[1]] %>% head(10)
#>  [1] "the"      "question" "thus"     "becomes"  "a"        "verbal"  
#>  [7] "one"      "again"    "and"      "our"
tokenize_word_stems(james)[[1]] %>% head(10)
#>  [1] "the"      "question" "thus"     "becom"    "a"        "verbal"  
#>  [7] "one"      "again"    "and"      "our"
tokenize_sentences(james) 
#> [[1]]
#> [1] "The question thus becomes a verbal one again; and our knowledge of all these early stages of thought and feeling is in any case so conjectural and imperfect that farther discussion would not be worth while."                                               
#> [2] "Religion, therefore, as I now ask you arbitrarily to take it, shall mean for us _the feelings, acts, and experiences of individual men in their solitude, so far as they apprehend themselves to stand in relation to whatever they may consider the divine_."
#> [3] "Since the relation may be either moral, physical, or ritual, it is evident that out of religion in the sense in which we take it, theologies, philosophies, and ecclesiastical organizations may secondarily grow."
tokenize_paragraphs(james)
#> [[1]]
#> [1] "The question thus becomes a verbal one again; and our knowledge of all these early stages of thought and feeling is in any case so conjectural and imperfect that farther discussion would not be worth while."                                                                                                                                                                                                                                                                   
#> [2] "Religion, therefore, as I now ask you arbitrarily to take it, shall mean for us _the feelings, acts, and experiences of individual men in their solitude, so far as they apprehend themselves to stand in relation to whatever they may consider the divine_. Since the relation may be either moral, physical, or ritual, it is evident that out of religion in the sense in which we take it, theologies, philosophies, and ecclesiastical organizations may secondarily grow. "
tokenize_ngrams(james, n = 5)[[1]] %>% head(5)
#> [1] "the question thus becomes a"    "question thus becomes a verbal"
#> [3] "thus becomes a verbal one"      "becomes a verbal one again"    
#> [5] "a verbal one again and"
tokenize_skip_ngrams(james, n = 5, k = 2)[[1]] %>% head(5)
#> [1] "the becomes one our all"          "question a again knowledge these"
#> [3] "thus verbal and of early"         "becomes one our all stages"      
#> [5] "a again knowledge these of"
tokenize_range_ngrams(james, n = 8, n_min = 1)[[1]] %>% head(5)
#> [1] "the question thus becomes a verbal one again"
#> [2] "question thus becomes a verbal one again and"
#> [3] "thus becomes a verbal one again and our"     
#> [4] "becomes a verbal one again and our knowledge"
#> [5] "a verbal one again and our knowledge of"
tokenize_range_ngrams(james, n = 8, n_min = 1)[[1]] %>% tail(5)
#> [1] "ecclesiastical" "organizations"  "may"            "secondarily"   
#> [5] "grow"
tokenize_lines(james)
#> [[1]]
#>  [1] "The question thus becomes a verbal one"                                   
#>  [2] "again; and our knowledge of all these early stages of thought and feeling"
#>  [3] "is in any case so conjectural and imperfect that farther discussion would"
#>  [4] "not be worth while."                                                      
#>  [5] "Religion, therefore, as I now ask you arbitrarily to take it, shall mean" 
#>  [6] "for us _the feelings, acts, and experiences of individual men in their"   
#>  [7] "solitude, so far as they apprehend themselves to stand in relation to"    
#>  [8] "whatever they may consider the divine_. Since the relation may be either" 
#>  [9] "moral, physical, or ritual, it is evident that out of religion in the"    
#> [10] "sense in which we take it, theologies, philosophies, and ecclesiastical"  
#> [11] "organizations may secondarily grow."
```

Tokenizers can also be piped into one another.

``` r
james %>% tokenize_sentences() %>% tokenize_words() 
#> [[1]]
#>  [1] "the"         "question"    "thus"        "becomes"     "a"          
#>  [6] "verbal"      "one"         "again"       "and"         "our"        
#> [11] "knowledge"   "of"          "all"         "these"       "early"      
#> [16] "stages"      "of"          "thought"     "and"         "feeling"    
#> [21] "is"          "in"          "any"         "case"        "so"         
#> [26] "conjectural" "and"         "imperfect"   "that"        "farther"    
#> [31] "discussion"  "would"       "not"         "be"          "worth"      
#> [36] "while"      
#> 
#> [[2]]
#>  [1] "religion"    "therefore"   "as"          "i"           "now"        
#>  [6] "ask"         "you"         "arbitrarily" "to"          "take"       
#> [11] "it"          "shall"       "mean"        "for"         "us"         
#> [16] "_the"        "feelings"    "acts"        "and"         "experiences"
#> [21] "of"          "individual"  "men"         "in"          "their"      
#> [26] "solitude"    "so"          "far"         "as"          "they"       
#> [31] "apprehend"   "themselves"  "to"          "stand"       "in"         
#> [36] "relation"    "to"          "whatever"    "they"        "may"        
#> [41] "consider"    "the"         "divine_"    
#> 
#> [[3]]
#>  [1] "since"          "the"            "relation"       "may"           
#>  [5] "be"             "either"         "moral"          "physical"      
#>  [9] "or"             "ritual"         "it"             "is"            
#> [13] "evident"        "that"           "out"            "of"            
#> [17] "religion"       "in"             "the"            "sense"         
#> [21] "in"             "which"          "we"             "take"          
#> [25] "it"             "theologies"     "philosophies"   "and"           
#> [29] "ecclesiastical" "organizations"  "may"            "secondarily"   
#> [33] "grow"
```

### Contributing

Contributions to the package are more than welcome. One way that you can help is by using this package in your R package for natural language processing. If you want to contribute a tokenization function to this package, it should follow the same conventions as the rest of the functions whenever it makes sense to do so.

1.  It should have a function name that begins with `tokenize_*` and which ends with a plural of whatever kind of tokens are going to be generated. For instance, `tokenize_words()` or `tokenize_ngrams()`.
2.  The function should take as its first argument (named `x`) the texts that are to be tokenized. The input should be either a character vector of any length, where each element in the vector is a text to be tokenized, or it should be a list of character vectors where the each character vector in the list is a text to be tokenized with a length of 1.
3.  The output a list of character vectors of tokens, with one character vector in the list for each element in the input character vector or list. The function can have a `simplify` parameter, but the default should be `FALSE`. This ensures that all functions return a consistent output.

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
