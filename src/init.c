#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* .Call calls */
extern SEXP tokenizers_generate_ngrams_batch(SEXP, SEXP, SEXP, SEXP, SEXP);
extern SEXP tokenizers_skip_ngrams_vectorised(SEXP, SEXP, SEXP);

static const R_CallMethodDef CallEntries[] = {
    {"tokenizers_generate_ngrams_batch",  (DL_FUNC) &tokenizers_generate_ngrams_batch, 5},
    {"tokenizers_skip_ngrams_vectorised", (DL_FUNC) &tokenizers_skip_ngrams_vectorised,3},
    {NULL, NULL, 0}
};

void R_init_tokenizers(DllInfo *dll)
{
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}