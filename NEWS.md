# tokenizers (development)

- Add a function `chunk_text()` to split long documents into pieces.
- Add the `tokenize_ptb()` function for Penn Tree Bank tokenizations (@jrnold).
- C++98 has replaced the C++11 code used for ngram generation, widening the range of compilers `tokenizers` supports (#26)
- If tokenisers fail to generate tokens for a particular entry, they return NA consistently (#33)

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