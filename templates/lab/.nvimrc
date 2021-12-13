let g:pandoc_defaults_file = '~/.config/pandoc/lab.yaml'
"let g:pandoc_headers = ['~/.config/pandoc/headers/commonheader.tex']
let g:pandoc_options = '-F pandoc-crossref --citeproc --bibliography ' . expand('%:h') . '/*.bib --csl ' . expand('%:h') . '/*.csl'
