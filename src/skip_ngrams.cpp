#include <Rcpp.h>
using namespace Rcpp;

CharacterVector skip_ngrams(CharacterVector words,
                            ListOf<NumericVector>& skips,
                            std::set<std::string>& stopwords) {

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

  CharacterVector output(skips.size());

  for(unsigned int i = 0; i < skips.size(); i++){
    std::string holding;
    for(unsigned int j = 0; j < skips[i].size(); j++){
      if(skips[i][j] < (checked_words.size() - 1)){
        holding += " " + checked_words[skips[i][j]];
      }
    }
    if(holding.size()){
      holding.erase(0,1);
      output[i] = holding;
    } else {
      output[i] = NA_STRING;
    }
  }

  return output;
}

//[[Rcpp::export]]
ListOf<CharacterVector> skip_ngrams_vectorised(ListOf<CharacterVector> words,
                                               ListOf<NumericVector> skips,
                                               CharacterVector stopwords){

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
    output[i] = skip_ngrams(words[i], skips, checked_stopwords);
  }

  return output;
}