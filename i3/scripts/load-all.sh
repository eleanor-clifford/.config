#!/bin/bash
for w in {1..10}; do
        i3-resurrect restore -w $w
done
