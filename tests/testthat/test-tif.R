context("Text Interchange Format")

test_that("Can detect a TIF compliant data.frame", {
  expect_true(is_corpus_df(docs_df))
  bad_df <- docs_df
  bad_df$doc_id <- NULL
  expect_error(is_corpus_df(bad_df))
})

test_that("Can coerce a TIF compliant data.frame to a character vector", {
  output <- docs_df$text
  names(output) <- docs_df$doc_id
  expect_identical(corpus_df_as_corpus_vector(docs_df), output)
})

test_that("Different methods produce identical output", {
  expect_identical(tokenize_words(docs_c), tokenize_words(docs_df))
  expect_identical(tokenize_words(docs_l), tokenize_words(docs_df))

  expect_identical(tokenize_characters(docs_c), tokenize_characters(docs_df))
  expect_identical(tokenize_characters(docs_l), tokenize_characters(docs_df))

  expect_identical(tokenize_sentences(docs_c), tokenize_sentences(docs_df))
  expect_identical(tokenize_sentences(docs_l), tokenize_sentences(docs_df))

  expect_identical(tokenize_lines(docs_c), tokenize_lines(docs_df))
  expect_identical(tokenize_lines(docs_l), tokenize_lines(docs_df))

  expect_identical(tokenize_paragraphs(docs_c), tokenize_paragraphs(docs_df))
  expect_identical(tokenize_paragraphs(docs_l), tokenize_paragraphs(docs_df))

  expect_identical(tokenize_regex(docs_c), tokenize_regex(docs_df))
  expect_identical(tokenize_regex(docs_l), tokenize_regex(docs_df))

  expect_identical(tokenize_tweets(docs_c), tokenize_tweets(docs_df))
  expect_identical(tokenize_tweets(docs_l), tokenize_tweets(docs_df))

  expect_identical(tokenize_ngrams(docs_c), tokenize_ngrams(docs_df))
  expect_identical(tokenize_ngrams(docs_l), tokenize_ngrams(docs_df))

  expect_identical(tokenize_skip_ngrams(docs_c), tokenize_skip_ngrams(docs_df))
  expect_identical(tokenize_skip_ngrams(docs_l), tokenize_skip_ngrams(docs_df))

  expect_identical(tokenize_ptb(docs_c), tokenize_ptb(docs_df))
  expect_identical(tokenize_ptb(docs_l), tokenize_ptb(docs_df))

  expect_identical(tokenize_character_shingles(docs_c),
                   tokenize_character_shingles(docs_df))
  expect_identical(tokenize_character_shingles(docs_l),
                   tokenize_character_shingles(docs_df))

  expect_identical(tokenize_word_stems(docs_c), tokenize_word_stems(docs_df))
  expect_identical(tokenize_word_stems(docs_l), tokenize_word_stems(docs_df))
})
