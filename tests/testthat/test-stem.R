context("Stem tokenizers")

source("data-for-tests.R")

test_that("Word stem tokenizer works as expected", {
  out_l <- tokenize_word_stems(docs_l)
  out_c <- tokenize_word_stems(docs_c)
  out_1 <- tokenize_word_stems(docs_c[1], simplify = TRUE)

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

  expect_error(tokenize_word_stems(bad_list))
})

test_that("Stem tokenizer produces correct output", {
  # skip_on_os("windows")
  out_1 <- tokenize_word_stems(docs_c[1], simplify = TRUE)
  expected <- c("in", "my", "purs", "and", "noth")
  expect_identical(out_1[20:24], expected)
})
