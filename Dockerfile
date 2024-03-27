
from rocker/shiny-verse:4.3.2

add ./ /tokenizers
run R -e "devtools::install('tokenizers', dependencies = TRUE)"
