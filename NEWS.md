# tokenizers (development)

- Add a function `chunk_text()` to split long documents into pieces.
- Add the `tokenize_ptb()` function for Penn Tree Bank tokenizations (@jrnold).
- C++98 has replaced the C++11 code used for ngram generation, widening the range of compilers `tokenizers` supports (#26)
- If tokenisers fail to generate tokens for a particular entry, they return NA consistently (#33)
- `tokenize_skip_ngrams` now supports stopwords (#31)
- `tokenize_skip_ngrams` has been improved to generate unigrams and bigrams, according to the skip definition (#24)
- Keyboard interrupt checks have been added to Rcpp-backed functions to enable users to terminate them before completion (#37)
- New functions to count words, characters, and sentences without tokenization (#36).
- New function `tokenize_tweets()` preserves usernames, hashtags, and URLS (@kbenoit) (#44)
- `tokenize_words()` gains arguments to preserve or strip punctuation and numbers (#48)
- `tokenize_skip_ngrams()` and `tokenize_ngrams()` to return properly marked UTF8 strings on Windows (@patperry) (#58).

# tokenizers 0.1.4

- Add the `tokenize_character_shingles()` tokenizer. 
- Improvements to documentation.

# tokenizers 0.1.3

- Add vignette.
- Improvements to n-gram tokenizers.

# tokenizers 0.1.2

- Add stopwords for several languages.
- New stopword options to `tokenize_words()` and `tokenize_word_stems()`.

# tokenizers 0.1.1

- Fix failing test in non-UTF-8 locales.

# tokenizers 0.1.0

- Initial release with tokenizers for characters, words, word stems, sentences
  paragraphs, n-grams, skip n-grams, lines, and regular expressions.
