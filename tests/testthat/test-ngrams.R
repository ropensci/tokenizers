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
  # skip_on_os("windows")
  out_1 <- tokenize_skip_ngrams(docs_c[1], n = 3, k = 2, simplify = TRUE)
  expected <- c("chapter", "chapter 1", "chapter loomings",
                "chapter call", "chapter 1 loomings", "chapter 1 call")
  expect_identical(head(out_1, 6), expected)
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
  out <- tokenize_skip_ngrams(test, stopwords = "is", n = 2)
  expect_equal(length(out$a), 3)
  expect_identical(out$a[2], "this a")
})