#!/bin/bash

mkdir -p pages_rst
ls -1 ./pages_mw > pages_mw.txt
while read f; do
  pandoc -f mediawiki -t rst -o "pages_rst/${f%%.*}.rst" "pages_mw/$f"
done < pages_mw.txt
