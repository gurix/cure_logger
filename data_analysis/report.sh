# Compiles the markdown report into an html file
# run for the first time install.packages("rmarkdown")
Rscript -e 'library(rmarkdown); rmarkdown::render("report.Rmd", "html_document")'