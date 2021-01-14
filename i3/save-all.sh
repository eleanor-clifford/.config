set -x
for w in {1..10}; do
	i3-resurrect save -w $w
done
