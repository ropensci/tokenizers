context("Basic tokenizers")

source("data-for-tests.R")

test_that("Character tokenizer works as expected", {
  out_l <- tokenize_characters(docs_l)
  out_c <- tokenize_characters(docs_c)
  out_1 <- tokenize_characters(docs_c[1], simplify = TRUE)

  expect_is(out_l, "list")
  expect_is(out_l[[1]], "character")
  expect_is(out_c, "list")
  expect_is(out_c[[1]], "character")
  expect_is(out_1, "character")

  expected <- c("c", "h", "a", "p", "t")
  expect_identical(head(out_1, 5), expected)
  expect_identical(out_l, out_c)
  expect_identical(out_l[[1]], out_1)
  expect_identical(out_c[[1]], out_1)

  expect_named(out_l, names(docs_l))
  expect_named(out_c, names(docs_c))

  expect_error(tokenize_characters(bad_list))
})

test_that("Word tokenizer works as expected", {
  out_l <- tokenize_words(docs_l)
  out_c <- tokenize_words(docs_c)
  out_1 <- tokenize_words(docs_c[1], simplify = TRUE)

  expect_is(out_l, "list")
  expect_is(out_l[[1]], "character")
  expect_is(out_c, "list")
  expect_is(out_c[[1]], "character")
  expect_is(out_1, "character")

  expected <- c("chapter", "1", "loomings", "call", "me")
  expect_identical(head(out_1, 5), expected)
  expect_identical(out_l, out_c)
  expect_identical(out_l[[1]], out_1)
  expect_identical(out_c[[1]], out_1)

  expect_named(out_l, names(docs_l))
  expect_named(out_c, names(docs_c))

  expect_error(tokenize_words(bad_list))
})

test_that("Sentence tokenizer works as expected", {
  out_l <- tokenize_sentences(docs_l)
  out_c <- tokenize_sentences(docs_c)
  out_1 <- tokenize_sentences(docs_c[1], simplify = TRUE)
  out_1_lc <- tokenize_sentences(docs_c[1], lowercase = TRUE, simplify = TRUE)
  out_1_pc <- tokenize_sentences(docs_c[1], strip_punctuation = TRUE, simplify = TRUE)

  expect_is(out_l, "list")
  expect_is(out_l[[1]], "character")
  expect_is(out_c, "list")
  expect_is(out_c[[1]], "character")
  expect_is(out_1, "character")

  expected <- c("CHAPTER 1.", "Loomings.", "Call me Ishmael.")
  expected_pc <- c("CHAPTER 1", "Loomings", "Call me Ishmael")
  expect_identical(head(out_1, 3), expected)
  expect_identical(head(out_1_lc, 3), tolower(expected))
  expect_identical(head(out_1_pc, 3), expected_pc)
  expect_identical(out_l, out_c)
  expect_identical(out_l[[1]], out_1)
  expect_identical(out_c[[1]], out_1)

  expect_named(out_l, names(docs_l))
  expect_named(out_c, names(docs_c))

  expect_error(tokenize_sentences(bad_list))
})

test_that("Line tokenizer works as expected", {
  out_l <- tokenize_lines(docs_l)
  out_c <- tokenize_lines(docs_c)
  out_1 <- tokenize_lines(docs_c[1], simplify = TRUE)

  expect_is(out_l, "list")
  expect_is(out_l[[1]], "character")
  expect_is(out_c, "list")
  expect_is(out_c[[1]], "character")
  expect_is(out_1, "character")

  expected <- c("CHAPTER 1. Loomings.",
                "Call me Ishmael. Some years ago--never mind how long precisely--having")
  expect_identical(head(out_1, 2), expected)
  expect_identical(out_l, out_c)
  expect_identical(out_l[[1]], out_1)
  expect_identical(out_c[[1]], out_1)

  expect_named(out_l, names(docs_l))
  expect_named(out_c, names(docs_c))

  expect_error(tokenize_lines(bad_list))
})
