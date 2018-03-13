context("Document chunking")

test_that("Document chunking work on lists and character vectors", {
  chunk_size <- 10
  out_l <- chunk_text(docs_l, chunk_size = chunk_size)
  out_c <- chunk_text(docs_c, chunk_size = chunk_size)

  expect_is(out_l, "list")
  expect_is(out_l[[1]], "character")
  expect_is(out_c, "list")
  expect_is(out_c[[1]], "character")

  expect_identical(out_l, out_c)
  expect_identical(out_l[[1]], out_c[[1]])
  expect_identical(out_c[[1]], out_c[[1]])

  expect_named(out_l, names(out_c))
  expect_named(out_c, names(out_l))

  expect_error(chunk_text(bad_list))
})

test_that("Document chunking splits documents apart correctly", {
  test_doc <- "This is a sentence with exactly eight words. Here's two. And now here are ten words in a great sentence. And five or six left over."
  out <- chunk_text(test_doc, chunk_size = 10, doc_id = "test")
  out_wc <- count_words(out)
  test_wc <- c(10L, 10L, 6L)
  names(test_wc) <- c("test-1", "test-2", "test-3")
  expect_named(out, names(test_wc))
  expect_identical(out_wc, test_wc)

  out_short <- chunk_text("This is a short text")
  expect_equal(count_words(out_short[[1]]), 5)
  expect_named(out_short, NULL)
})
