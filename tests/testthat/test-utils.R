context("Utils")

source("data-for-tests.R")

test_that("Inputs are verified correct", {
  expect_silent(check_input(letters))
  expect_silent(check_input(list(a = "a", b = "b")))
  expect_error(check_input(1:10))
  expect_error(check_input(list(a = "a", b = letters)))
  expect_error(check_input(list(a = "a", b = 2)))
})

test_that("Stopwords are removed", {
  expect_equal(remove_stopwords(letters[1:5], stopwords = c("d", "e")),
               letters[1:3])
})