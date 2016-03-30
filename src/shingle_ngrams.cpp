#include <Rcpp.h>
using namespace std;
using namespace Rcpp;

// calculates size of the ngram vector
inline  size_t get_ngram_seq_len(uint32_t input_len, uint32_t ngram_min, uint32_t ngram_max) {

  uint32_t out_ngram_len_adjust = 0;
  for (size_t i = ngram_min - 1; i < ngram_max; i++)
    out_ngram_len_adjust += i;

  if(input_len < ngram_min)
    return 0;
  else
    return input_len * (ngram_max - ngram_min + 1) - out_ngram_len_adjust;
}

CharacterVector generate_ngrams_internal(const CharacterVector terms_raw,
                                const uint32_t ngram_min,
                                const uint32_t ngram_max,
                                RCPP_UNORDERED_SET<string> &stopwords,
                                // pass buffer by reference to avoid memory allocation
                                // on each iteration
                                vector<string> &terms_filtered_buffer,
                                const string ngram_delim) {
  // clear buffer from previous iteration result
  terms_filtered_buffer.clear();
  string term;
  // filter out stopwords
  for (auto it: terms_raw) {
    term  = as<string>(it);
    if(stopwords.find(term) == stopwords.end())
      terms_filtered_buffer.push_back(term);
  }

  uint32_t len = terms_filtered_buffer.size();
  size_t ngram_out_len = get_ngram_seq_len(len, ngram_min, ngram_max);
  CharacterVector result(ngram_out_len);

  string k_gram;
  size_t k, i = 0, j_max_observed;
  // iterates through input vector by window of size = n_max and build n-grams
  // for terms ["a", "b", "c", "d"] and n_min = 1, n_max = 2
  // will build 1:3-grams in following order
  //"a"     "a_b"   "a_b_c" "b"     "b_c"   "b_c_d" "c"     "c_d"   "d"
  for(size_t j = 0; j < len; j ++ ) {
    k = 1;
    j_max_observed = j;
    while (k <= ngram_max && j_max_observed < len) {

      if( k == 1) {
        k_gram = terms_filtered_buffer[j_max_observed];
      } else
        k_gram = k_gram + ngram_delim + terms_filtered_buffer[j_max_observed];

      if(k >= ngram_min) {
        result[i] = k_gram;
        i++;
      }
      j_max_observed = j + k;
      k = k + 1;
    }
  }
  return result;
}

// [[Rcpp::export]]
ListOf<CharacterVector> generate_ngrams_batch(const ListOf<const CharacterVector> documents_list,
                                              const uint32_t ngram_min,
                                              const uint32_t ngram_max,
                                              const CharacterVector stopwords = CharacterVector(),
                                              const String ngram_delim = " ") {

  vector<string> terms_filtered_buffer;
  const string std_string_delim = ngram_delim.get_cstring();
  size_t n_docs = documents_list.size();
  List result(n_docs);
  CharacterVector terms;

  RCPP_UNORDERED_SET<string> stopwords_set;
  for(auto it:stopwords)
    stopwords_set.insert(as<string>(it));

  size_t current_doc_ngram_len = 0;
  for (size_t i_document = 0; i_document < n_docs; i_document++) {
    terms = documents_list[i_document];
    result[i_document] = generate_ngrams_internal(documents_list[i_document],
                                                  ngram_min, ngram_max,
                                                  stopwords_set,
                                                  terms_filtered_buffer,
                                                  std_string_delim);
  }
  return result;
}
