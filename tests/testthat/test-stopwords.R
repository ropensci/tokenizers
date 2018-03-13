context("Stopwords")

test_that("Jockers stop ords work", {
  expect_true(all(c("bobette", "clarice", "andre") %in% stopwords("jockers")))
  expect_error(stopwords(source = "jockers", language = "de"))
})

test_that("Lucene stopwords work", {
  expect_true(all(c("will", "such", "their") %in% stopwords()))
  expect_true(all(c("würde", "solcher", "etwas") %in% stopwords(language = "de")))
  expect_true(all(c("тебе", "между", "вдруг") %in% stopwords(language = "ru")))
})
