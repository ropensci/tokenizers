#' Stopword lists
#'
#' Retrieve lists of stopwords by language. The
#' @param source The name of the source of the stopwords.
#' @param language The two-letter code for the name of the language.
#' @references The Lucene stopword lists are a subset of the stopword lists
#'   available in the
#'   \href{https://github.com/apache/lucene-solr/tree/master/solr/contrib/morphlines-core/src/test-files/solr/collection1/conf/lang}{Apache
#'    Lucene/Solr} project, available under the Apache 2.0 license.
#'
#'   The Jockers stopword list is available from Matthew L. Jockers, "Expanded
#'   Stopwords List",
#'   \url{http://www.matthewjockers.net/macroanalysisbook/expanded-stopwords-list/}.
#'   According to Jockers, "The list includes the usual high frequency words
#'   ('the,' 'of,' 'an,' etc) but also several thousand personal names."
#' @examples
#' stopwords(language = "en")
#' stopwords(language = "de")
#' head(stopwords(source = "jockers"), 20)
#' @export
stopwords <- function(source = c("lucene", "jockers"),
                      language = c("en", "da", "de", "el", "es", "fr", "it", "ru")) {
  source <- match.arg(source)
  language <- match.arg(language)
  if (source == "jockers" && language != "en") {
    stop("The Jockers stopwords are only available in English.")
  }
  if (source == "jockers") {
    stopwords_jockers
  } else {
    stopwords_lucene[[language]]
  }
}
