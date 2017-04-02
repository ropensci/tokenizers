#include <Rcpp.h>
using namespace Rcpp;

CharacterVector subset_words(std::deque<std::string>& words, NumericVector indices){
  CharacterVector output(indices.size());

  for(unsigned int i = 0; i < indices.size(); i++){
    output[i] = words[indices[i]];
  }

  return output;
}

CharacterVector skip_ngrams(CharacterVector words, std::set<std::string>& stopwords, int n, int k) {

  std::deque < std::string > checked_words;
  std::string holding;

  for(unsigned int i = 0; i < words.size(); i++){
    if(words[i] != NA_STRING){
      holding = as<std::string>(words[i]);
      if(stopwords.find(holding)  == stopwords.end()){
        checked_words.push_back(holding);
      }
    }
  }
  int w = checked_words.size(); // w = number of words
  int g = 0; // g = number of n-grams
  for(int i = k; i >= 0; i--) { // i = current iteration of k
    int window = n + n * i - i; // width of n-grams plus skips
    if(window > w) continue;
    g += w - window + 1;
  }
  if(!g){
    return CharacterVector(1, NA_STRING);
  }
  CharacterVector ngrams(g);

  int position = 0; // position = place to store current ngram
  while(k >= 0) { // loop over k in descending order

    int window = n + n * k - k;
    for(int i = 0; i < w - window + 1; i++) { // loop over the words
      NumericVector subset(n); // the subset we are going to make of words
      for(int j = 0; j < n; j++) { // loop over number of n in ngrams
        subset[j] = i + j + j * k;
        // Rcpp::Rcout << "j = " << j << std::endl;
        // Rcpp::Rcout << "j + j * k = " << j + j * k << std::endl;
      }

      CharacterVector words_subset = subset_words(checked_words, subset);

      // turn the vector of words into a string
      std::string ngram;
      for(int l = 0; l < n; l++) {
        ngram += words_subset[l];
        if(l != n - 1) ngram += " ";
      }
      // store the current ngram and iterate
      ngrams[position] = ngram;
      position++;

    }
    k--; // iterate k
  }

  return ngrams;
}

//[[Rcpp::export]]
ListOf<CharacterVector> skip_ngrams_vectorised(ListOf<CharacterVector> words,
                                               CharacterVector stopwords,
                                               int n,
                                               int k){

  // Create output object and set up for further work
  unsigned int input_size = words.size();
  List output(input_size);

  // Create stopwords set
  std::set < std::string > checked_stopwords;
  for(unsigned int i = 0; i < stopwords.size(); i++){
    if(stopwords[i] != NA_STRING){
      checked_stopwords.insert(as<std::string>(stopwords[i]));
    }
  }

  for(unsigned int i = 0; i < input_size; i++){
    output[i] = skip_ngrams(words[i], checked_stopwords, n, k);
  }

  return output;
}