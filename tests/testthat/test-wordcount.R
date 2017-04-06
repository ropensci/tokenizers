context("Word counts")

test_that("Word counts work on lists and character vectors", {
  out_l <- count_sentences(docs_l)
  out_c <- count_sentences(docs_c)
  expect_identical(out_l, out_c)
  out_l <- count_words(docs_l)
  out_c <- count_words(docs_c)
  expect_identical(out_l, out_c)
  out_l <- count_characters(docs_l)
  out_c <- count_characters(docs_c)
  expect_identical(out_l, out_c)
  expect_named(out_l, names(docs_l))
  expect_named(out_c, names(docs_c))
})

test_that("Word counts give correct results", {
  input <- "This input has 10 words; doesn't it? Well---sure does."
  expect_equal(10, count_words(input))
  expect_equal(2, count_sentences(input))
  expect_equal(nchar(input), count_characters(input))
})
