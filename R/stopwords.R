#' Stopword lists
#'
#' Retrieve lists of stopwords by language.
#' @param language The two-letter code for the name of the language.
#' @references
#' The stopword lists are a subset of the stopword lists available in the \href{https://github.com/apache/lucene-solr/tree/master/solr/contrib/morphlines-core/src/test-files/solr/collection1/conf/lang}{Apache Lucene/Solr} project, available under the Apache 2.0 license.
#' @examples
#' stopwords("en")
#' stopwords("de")
#' @export
stopwords <- function(language = c("en", "da", "de", "el", "es", "fr", "it", "ru")) {
  language <- match.arg(language)
  stopword_lists[[language]]
}
