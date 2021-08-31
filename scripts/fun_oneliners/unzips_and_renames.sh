for i in *.zip; do fname="$(echo $i | sed 's/ - /-/g;s/ /_/g;s/\.zip//')"; mkdir -p $fname; mv "$i" $fname; cd $fname; unzip *; rm "$i"; cd -; done
