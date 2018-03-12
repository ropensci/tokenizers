#include <Rcpp.h>
using namespace Rcpp;

// calculates size of the ngram vector
inline size_t get_ngram_seq_len(int input_len, int ngram_min, int ngram_max) {

  int out_ngram_len_adjust = 0;
  for (size_t i = ngram_min - 1; i < ngram_max; i++)
    out_ngram_len_adjust += i;
  if(input_len < ngram_min)
    return 0;
  else
    return input_len * (ngram_max - ngram_min + 1) - out_ngram_len_adjust;
}

CharacterVector generate_ngrams_internal(const CharacterVector terms_raw,
                                const int ngram_min,
                                const int ngram_max,
                                std::set<std::string> &stopwords,
                                // pass buffer by reference to avoid memory allocation
                                // on each iteration
                                std::deque<std::string> &terms_filtered_buffer,
                                const std::string ngram_delim) {
  // clear buffer from previous iteration result
  terms_filtered_buffer.clear();
  std::string term;
  // filter out stopwords
  for (size_t i = 0; i < terms_raw.size(); i++) {
    term  = as<std::string>(terms_raw[i]);
    if(stopwords.find(term) == stopwords.end())
      terms_filtered_buffer.push_back(term);
  }

  int len = terms_filtered_buffer.size();
  size_t ngram_out_len = get_ngram_seq_len(len, ngram_min, std::min(ngram_max, len));

  CharacterVector result(ngram_out_len);

  std::string k_gram;
  size_t k, i = 0, j_max_observed;
  // iterates through input vector by window of size = n_max and build n-grams
  // for terms ["a", "b", "c", "d"] and n_min = 1, n_max = 3
  // will build 1:3-grams in following order
  //"a"     "a_b"   "a_b_c" "b"     "b_c"   "b_c_d" "c"     "c_d"   "d"
  for(size_t j = 0; j < len; j++ ) {
    k = 1;
    j_max_observed = j;
    while (k <= ngram_max && j_max_observed < len) {

      if( k == 1) {
        k_gram = terms_filtered_buffer[j_max_observed];
      } else {
        k_gram = k_gram + ngram_delim + terms_filtered_buffer[j_max_observed];
      }

      if(k >= ngram_min) {
        result[i] = String(k_gram, CE_UTF8);
        i++;
      }
      j_max_observed = j + k;
      k = k + 1;
    }
  }

  if(!result.size()){
    result.push_back(NA_STRING);
  }
  return result;
}

// [[Rcpp::export]]
ListOf<CharacterVector> generate_ngrams_batch(const ListOf<const CharacterVector> documents_list,
                                              const int ngram_min,
                                              const int ngram_max,
                                              CharacterVector stopwords = CharacterVector(),
                                              const String ngram_delim = " ") {

  std::deque<std::string> terms_filtered_buffer;
  const std::string std_string_delim = ngram_delim.get_cstring();
  size_t n_docs = documents_list.size();
  List result(n_docs);
  CharacterVector terms;

  std::set<std::string> stopwords_set;
  for(size_t i = 0; i < stopwords.size(); i++){
    if(stopwords[i] != NA_STRING){
      stopwords_set.insert(as<std::string>(stopwords[i]));
    }
  }

  for (size_t i_document = 0; i_document < n_docs; i_document++) {
    if(i_document % 10000 == 0){
      Rcpp::checkUserInterrupt();
    }
    terms = documents_list[i_document];
    result[i_document] = generate_ngrams_internal(documents_list[i_document],
                                                  ngram_min, ngram_max,
                                                  stopwords_set,
                                                  terms_filtered_buffer,
                                                  std_string_delim);
  }
  return result;
}
