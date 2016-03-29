context("Utils")

test_that("Inputs are verified correct", {
  expect_silent(check_input(letters))
  expect_silent(check_input(list(a = "a", b = "b")))
  expect_error(check_input(1:10))
  expect_error(check_input(list(a = "a", b = letters)))
  expect_error(check_input(list(a = "a", b = 2)))
})
