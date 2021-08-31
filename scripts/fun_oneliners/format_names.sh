for i in find .; do
	perl-rename -nv 's/ - /-/g;s/ /_/g;s/([[:lower:]])([[:upper:]])/\1_\2/g' $i
done
