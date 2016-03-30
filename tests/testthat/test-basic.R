context("Basic tokenizers")

source("data-for-tests.R")

test_that("Character tokenizer", {
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
