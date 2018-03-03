#include <Rcpp.h>
using namespace Rcpp;

// Borrowed from @koheiw in the quanteda package
// [[Rcpp::export]]
CharacterVector ensureUTF8(CharacterVector x) {
  CharacterVector output(x.size());
  for (std::size_t i = 0; i < x.size(); i++) {
    if (x[i] != NA_STRING) {
      String s = x[i];
      s.set_encoding(CE_UTF8);
      output[i] = s;
    } else {
      output[i] = NA_STRING;
    }
  }
  return(output);
}

