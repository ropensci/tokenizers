#include <Rcpp.h>
using namespace Rcpp;

CharacterVector skip_ngrams(CharacterVector words,
                            ListOf<NumericVector>& skips,
                            std::set<std::string>& stopwords) {

  std::deque < std::string > checked_words;
  std::string str_holding;

  // Eliminate stopwords
  for(unsigned int i = 0; i < words.size(); i++){
    if(words[i] != NA_STRING){
      str_holding = as<std::string>(words[i]);
      if(stopwords.find(str_holding)  == stopwords.end()){
        checked_words.push_back(str_holding);
      }
    }
  }

  str_holding.clear();
  std::deque < std::string > holding;
  unsigned int checked_size = checked_words.size();

  for(unsigned int w = 0; w < checked_size; w++) {
    for(unsigned int i = 0; i < skips.size(); i++){
      unsigned int in_size = skips[i].size();
      if(skips[i][in_size-1] + w < checked_size){
        for(unsigned int j = 0; j < skips[i].size(); j++){
          str_holding += " " + checked_words[skips[i][j] + w];
        }
        if(str_holding.size()){
          str_holding.erase(0,1);
        }
        holding.push_back(str_holding);
        str_holding.clear();
      }
    }
  }

  if(!holding.size()){
    return CharacterVector(1,NA_STRING);
  }

  CharacterVector output(holding.size());

  for(unsigned int i = 0; i < holding.size(); i++){
    if(holding[i].size()){
      output[i] = String(holding[i], CE_UTF8);
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
    if(i % 10000 == 0){
      Rcpp::checkUserInterrupt();
    }
    output[i] = skip_ngrams(words[i], skips, checked_stopwords);
  }

  return output;
}
