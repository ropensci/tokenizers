context("PTB tokenizer")

test_that("PTB tokenizer works as expected", {
  out_l <- tokenize_ptb(docs_l)
  out_c <- tokenize_ptb(docs_c)
  out_1 <- tokenize_ptb(docs_c[1], simplify = TRUE)

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

  expect_error(tokenize_ptb(bad_list))
})

test_that("Word tokenizer produces correct output", {
  sents <-
    c(paste0("Good muffins cost $3.88\nin New York. ",
             "Please buy me\\ntwo of them.\\nThanks."),
      "They'll save and invest more." ,
      "hi, my name can't hello,")
  expected <-
    list(c("Good", "muffins", "cost", "$", "3.88", "in", "New", "York.",
           "Please", "buy", "me\\ntwo", "of", "them.\\nThanks", "."),
         c("They", "'ll", "save", "and", "invest", "more", "."),
         c("hi", ",", "my", "name", "ca", "n't", "hello", ","))
  expect_identical(tokenize_ptb(sents), expected)

  expect_identical(tokenize_ptb("This can't work.", lowercase = TRUE, simplify = TRUE),
                   c("this", "ca", "n't", "work", "."))
})
