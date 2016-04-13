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

  expect_identical(out_l, out_c)
  expect_identical(out_l[[1]], out_1)
  expect_identical(out_c[[1]], out_1)

  expect_named(out_l, names(docs_l))
  expect_named(out_c, names(docs_c))

  expect_error(tokenize_characters(bad_list))
})

test_that("Character tokenizer produces correct output", {
  # skip_on_os("windows")
  out_1 <- tokenize_characters(docs_c[1], simplify = TRUE)
  expected <- c("c", "h", "a", "p", "t")
  expect_identical(head(out_1, 5), expected)
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

  expect_identical(out_l, out_c)
  expect_identical(out_l[[1]], out_1)
  expect_identical(out_c[[1]], out_1)

  expect_named(out_l, names(docs_l))
  expect_named(out_c, names(docs_c))

  expect_error(tokenize_words(bad_list))
})

test_that("Word tokenizer produces correct output", {
  # skip_on_os("windows")
  out_1 <- tokenize_words(docs_c[1], simplify = TRUE)
  expected <- c("chapter", "1", "loomings", "call", "me")
  expect_identical(head(out_1, 5), expected)
})

test_that("Word tokenizer removes stop words", {
  test <- "Now is the time for every good person"
  test_l <- list(test, test)
  stopwords <- c("is", "the", "for")
  expected <- c("now", "time", "every", "good", "person")
  expected_l <- list(expected, expected)
  expect_equal(tokenize_words(test, simplify = TRUE, stopwords = stopwords),
               expected)
  expect_equal(tokenize_words(test_l, stopwords = stopwords), expected_l)
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

  expect_identical(out_l, out_c)
  expect_identical(out_l[[1]], out_1)
  expect_identical(out_c[[1]], out_1)

  expect_named(out_l, names(docs_l))
  expect_named(out_c, names(docs_c))

  expect_error(tokenize_sentences(bad_list))
})

test_that("Sentence tokenizer produces correct output", {
  # skip_on_os("windows")
  out_1 <- tokenize_sentences(docs_c[1], simplify = TRUE)
  out_1_lc <- tokenize_sentences(docs_c[1], lowercase = TRUE, simplify = TRUE)
  out_1_pc <- tokenize_sentences(docs_c[1], strip_punctuation = TRUE, simplify = TRUE)
  expected <- c("CHAPTER 1.", "Loomings.", "Call me Ishmael.")
  expected_pc <- c("CHAPTER 1", "Loomings", "Call me Ishmael")
  expect_identical(head(out_1, 3), expected)
  expect_identical(head(out_1_lc, 3), tolower(expected))
  expect_identical(head(out_1_pc, 3), expected_pc)
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

  expect_identical(out_l, out_c)
  expect_identical(out_l[[1]], out_1)
  expect_identical(out_c[[1]], out_1)

  expect_named(out_l, names(docs_l))
  expect_named(out_c, names(docs_c))

  expect_error(tokenize_lines(bad_list))
})

test_that("Sentence tokenizer produces correct output", {
  # skip_on_os("windows")
  out_1 <- tokenize_lines(docs_c[1], simplify = TRUE)
  expected <- c("CHAPTER 1. Loomings.",
                "Call me Ishmael. Some years ago--never mind how long precisely--having")
  expect_identical(head(out_1, 2), expected)
})


test_that("Paragraph tokenizer works as expected", {
  out_l <- tokenize_paragraphs(docs_l)
  out_c <- tokenize_paragraphs(docs_c)
  out_1 <- tokenize_paragraphs(docs_c[1], simplify = TRUE)

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

  expect_error(tokenize_paragraphs(bad_list))
})

test_that("Paragraph tokenizer produces correct output", {
  # skip_on_os("windows")
  out_1 <- tokenize_paragraphs(docs_c[1], simplify = TRUE)
  expected <- c("There now is your insular city of the Manhattoes")
  expect_true(grepl(expected, out_1[3]))
})

test_that("Regex tokenizer works as expected", {
  out_l <- tokenize_regex(docs_l, pattern = "[[:punct:]\n]")
  out_c <- tokenize_regex(docs_c, pattern = "[[:punct:]\n]")
  out_1 <- tokenize_regex(docs_c[1], pattern = "[[:punct:]\n]", simplify = TRUE)

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

  expect_error(tokenize_paragraphs(bad_list))
})

test_that("Regex tokenizer produces correct output", {
  # skip_on_os("windows")
  out_1 <- tokenize_regex(docs_c[1], pattern = "[[:punct:]\n]", simplify = TRUE)
  expected <- c("CHAPTER 1", " Loomings", "Call me Ishmael", " Some years ago",
                "never mind how long precisely")
  expect_identical(head(out_1, 5), expected)
})