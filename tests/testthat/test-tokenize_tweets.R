context("Tweet tokenizer")

test_that("tweet tokenizer works correctly with case", {
  txt <- c(t1 = "Try this: tokenizers at @rOpenSci https://twitter.com/search?q=ropensci&src=typd",
           t2 = "#rstats awesome Package! @rOpenSci",
           t3 = "one two three Four #FIVE")

  out_tw1 <- tokenize_tweets(txt, lowercase = TRUE)
  expect_identical(out_tw1$t2, c("#rstats", "awesome", "package", "@rOpenSci"))
  expect_identical(out_tw1$t3, c("one", "two", "three", "four", "#FIVE"))

  out_tw2 <- tokenize_tweets(txt, lowercase = FALSE)
  expect_identical(out_tw2$t2, c("#rstats", "awesome", "Package", "@rOpenSci"))
  expect_identical(out_tw2$t3, c("one", "two", "three", "Four", "#FIVE"))
})

test_that("tweet tokenizer works correctly with strip_punctuation", {
  txt <- c(t1 = "Try this: tokenizers at @rOpenSci https://twitter.com/search?q=ropensci&src=typd",
           t2 = "#rstats awesome Package! @rOpenSci",
           t3 = "one two three Four #FIVE")

  out_tw1 <- tokenize_tweets(txt, strip_punct = TRUE, lowercase = TRUE)
  expect_identical(out_tw1$t2, c("#rstats", "awesome", "package", "@rOpenSci"))
  expect_identical(out_tw1$t3, c("one", "two", "three", "four", "#FIVE"))

  out_tw2 <- tokenize_tweets(txt, strip_punct = FALSE, lowercase = TRUE)
  expect_identical(
    out_tw2$t1,
    c("try", "this", ":", "tokenizers", "at", "@rOpenSci", "https://twitter.com/search?q=ropensci&src=typd")
  )
})

test_that("tweet tokenizer works correctly with strip_url", {
  txt <- c(t1 = "Tokenizers at @rOpenSci https://twitter.com/search?q=ropensci&src=typd")

  out_tw1 <- tokenize_tweets(txt, strip_punct = TRUE, strip_url = FALSE)
  expect_identical(
    out_tw1$t1,
    c("tokenizers", "at", "@rOpenSci", "https://twitter.com/search?q=ropensci&src=typd")
  )
  out_tw2 <- tokenize_tweets(txt, strip_punct = TRUE, strip_url = TRUE)
  expect_identical(
    out_tw2$t1,
    c("tokenizers", "at", "@rOpenSci")
  )
})

test_that("names are preserved with tweet tokenizer", {
  expect_equal(
    names(tokenize_tweets(c(t1 = "Larry, moe, and curly", t2 = "@ropensci #rstats"))),
    c("t1", "t2")
  )
  expect_equal(
    names(tokenize_tweets(c("Larry, moe, and curly", "@ropensci #rstats"))),
    NULL
  )
})

test_that("punctuation as part of tweets can preserved", {
  txt <- c(t1 = "We love #rstats!",
           t2 = "@rOpenSci: See you at UseR!")

  expect_equal(
    tokenize_tweets(txt, strip_punct = FALSE, lowercase = FALSE),
    list(t1 = c("We", "love", "#rstats", "!"),
         t2 = c("@rOpenSci", ":", "See", "you", "at", "UseR", "!"))
  )

  expect_equal(
    tokenize_tweets(txt, strip_punct = TRUE, lowercase = FALSE),
    list(t1 = c("We", "love", "#rstats"),
         t2 = c("@rOpenSci", "See", "you", "at", "UseR"))
  )
})
