context("Encodings")

test_that("Encodings work on Windows", {
  input <- "César Moreira Nuñez"
  reference <- c("césar", "moreira", "nuñez")
  reference_enc <- c("UTF-8", "unknown", "UTF-8")
  output_n1 <- tokenize_ngrams(input, n = 1, simplify = TRUE)
  output_words <- tokenize_words(input, simplify = TRUE)
  output_skip <- tokenize_skip_ngrams(input, n = 1, k = 0, simplify = TRUE)
  expect_equal(output_n1, reference)
  expect_equal(output_words, reference)
  expect_equal(output_skip, reference)
  expect_equal(Encoding(output_n1), reference_enc)
  expect_equal(Encoding(output_words), reference_enc)
  expect_equal(Encoding(output_skip), reference_enc)
})