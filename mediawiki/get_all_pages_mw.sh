#!/bin/bash

mkdir -p pages_mw
while read p; do
  curl -G "https://www.tradingview.com/wiki/static/index.php" --data-urlencode "title=$p" --data-urlencode "action=raw" > "pages_mw/$p.mw"
done < pages_titles.txt
