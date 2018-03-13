context("N-gram tokenizers")

test_that("Shingled n-gram tokenizer works as expected", {
  stopwords <- c("chapter", "me")
  out_l <- tokenize_ngrams(docs_l, n = 3, n_min = 2, stopwords = stopwords)
  out_c <- tokenize_ngrams(docs_c, n = 3, n_min = 2, stopwords = stopwords)
  out_1 <- tokenize_ngrams(docs_c[1], n = 3, n_min = 2, stopwords = stopwords,
                           simplify = TRUE)

  expect_is(out_l, "list")
  expect_is(out_l[[1]], "character")
  expect_is(out_c, "list")
  expect_is(out_c[[1]], "character")
  expect_is(out_1, "character")

  expect_identical(out_l, out_c)
  expect_identical(out_l[[1]], out_1)
  expect_identical(out_c[[1]], out_1)

  # test for https://github.com/lmullen/tokenizers/issues/14
  expect_identical(tokenize_ngrams("one two three", n = 3, n_min = 2),
                   tokenize_ngrams("one two three", n = 5, n_min = 2))

  expect_named(out_l, names(docs_l))
  expect_named(out_c, names(docs_c))

  expect_error(tokenize_ngrams(bad_list))
})

test_that("Shingled n-gram tokenizer produces correct output", {
  # skip_on_os("windows")
  stopwords <- c("chapter", "me")
  out_1 <- tokenize_ngrams(docs_c[1], n = 3, n_min = 2, stopwords = stopwords,
                           simplify = TRUE)
  expected <- c("1 loomings", "1 loomings call", "loomings call",
                "loomings call ishmael", "call ishmael", "call ishmael some")
  expect_identical(head(out_1, 6), expected)

})

test_that("Shingled n-gram tokenizer consistently produces NAs where appropriate", {
  test <- c("This is a text", NA, "So is this")
  names(test) <- letters[1:3]
  out <- tokenize_ngrams(test)
  expect_true(is.na(out$b))
})

test_that("Skip n-gram tokenizer consistently produces NAs where appropriate", {
  test <- c("This is a text", NA, "So is this")
  names(test) <- letters[1:3]
  out <- tokenize_skip_ngrams(test)
  expect_true(is.na(out$b))
})

test_that("Skip n-gram tokenizer can use stopwords", {
  test <- c("This is a text", "So is this")
  names(test) <- letters[1:2]
  out <- tokenize_skip_ngrams(test, stopwords = "is", n = 2, n_min = 2)
  expect_equal(length(out$a), 3)
  expect_identical(out$a[1], "this a")
})

test_that("Skips with values greater than k are refused", {
  expect_false(check_width(c(0, 4, 5), k = 2))
  expect_true(check_width(c(0, 3, 5), k = 2))
  expect_false(check_width(c(0, 1, 3), k = 0))
  expect_true(check_width(c(0, 1, 2), k = 0))
  expect_false(check_width(c(0, 10, 11, 12), k = 5))
  expect_true(check_width(c(0, 6, 11, 16, 18), k = 5))
})

test_that("Combinations for skip grams are correct", {
  skip_pos <- get_valid_skips(2, 2)
  expect_is(skip_pos, "list")
  expect_length(skip_pos, 3)
  expect_identical(skip_pos, list(c(0, 1), c(0, 2), c(0, 3)))

  skip_pos2 <- get_valid_skips(3, 2)
  expect_identical(skip_pos2, list(
    c(0, 1, 2),
    c(0, 1, 3),
    c(0, 1, 4),
    c(0, 2, 3),
    c(0, 2, 4),
    c(0, 2, 5),
    c(0, 3, 4),
    c(0, 3, 5),
    c(0, 3, 6)))
})

test_that("Skip n-gram tokenizer works as expected", {
  stopwords <- c("chapter", "me")
  out_l <- tokenize_skip_ngrams(docs_l, n = 3, k = 2)
  out_c <- tokenize_skip_ngrams(docs_c, n = 3, k = 2)
  out_1 <- tokenize_skip_ngrams(docs_c[1], n = 3, k = 2, simplify = TRUE)

  expect_is(out_l, "list")
  expect_is(out_l[[1]], "character")
  expect_is(out_c, "list")
  expect_is(out_c[[1]], "character")
  expect_is(out_1, "character")


  expect_identical(out_l, out_c)
  expect_identical(out_l[[1]], out_1)
  expect_identical(out_c[[1]], out_1)

  expect_named(out_l, names(docs_l))
  expect_named(out_c, names(docs_c))

  expect_error(tokenize_skip_ngrams(bad_list))
})

test_that("Skip n-gram tokenizer produces correct output", {
  out_n2_k2 <- tokenize_skip_ngrams(input, n = 2, n_min = 2, k = 2, simplify = TRUE)
  expect_equal(sort(skip2_bigrams), sort(out_n2_k2))
  out_n3_k2 <- tokenize_skip_ngrams(input, n = 3, n_min = 3, k = 2, simplify = TRUE)
  expect_equal(sort(skip2_trigrams), sort(out_n3_k2))
})

test_that("Skip n-gram tokenizers respects stopwords", {
  out_1 <- tokenize_skip_ngrams("This is a sentence that is for the test.",
                                n = 3, k = 2, stopwords = c("a", "the"),
                                simplify = TRUE)
  expect_equal(length(grep("the", out_1)), 0)
})

test_that("Skip n-gram tokenizer warns about large combinations", {
  expect_warning(get_valid_skips(n = 7, k = 2), "Input n and k will")
})
