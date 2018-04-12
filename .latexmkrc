# vim: syn=perl
# -*- mode: perl -*-

$bibtex_use = 2;

# always compile to PDF
$pdf_mode = 1;

# make latexmk -c/C more thorough
$clean_ext = '%R.run.xml %R.synctex.gz';

# use bibtex and synctex by default
$pdflatex = 'pdflatex -bibtex -synctex %0 %S';
