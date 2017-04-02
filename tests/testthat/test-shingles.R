context("Shingle tokenizers")

test_that("Character shingle tokenizer works as expected", {
  out_l <- tokenize_character_shingles(docs_l, n = 3, n_min = 2)
  out_c <- tokenize_character_shingles(docs_c, n = 3, n_min = 2)
  out_1 <- tokenize_character_shingles(docs_c[1], n = 3, n_min = 2,
                                       simplify = TRUE)

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

  expect_error(tokenize_ngrams(bad_list))

})

test_that("Character shingle tokenizer produces correct output", {
  phrase <- c("Remember who commended thy yellow stockings",
              "And wished to see thee cross-gartered.")
  names(phrase) <- c("Malvolio 1", "Malvolio 2")

  out_d <- tokenize_character_shingles(phrase)
  out_asis <- tokenize_character_shingles(phrase, lowercase = FALSE,
                                          strip_non_alphanum = FALSE)

  expect_identical(out_d[[1]][1:12], c("rem", "eme", "mem", "emb", "mbe", "ber",
                                       "erw", "rwh", "who", "hoc", "oco", "com"))

  expect_identical(out_asis[[2]][1:15], c("And", "nd ", "d w", " wi", "wis",
                                          "ish", "she", "hed", "ed ", "d t",
                                          " to", "to ", "o s", " se", "see"))

})

test_that("Character shingle tokenizer consistently produces NAs where appropriate", {
  test <- c("This is a text", NA, "So is this")
  names(test) <- letters[1:3]
  out <- tokenize_character_shingles(test)
  expect_true(is.na(out$b))
})