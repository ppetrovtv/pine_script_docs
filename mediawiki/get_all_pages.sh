#!/bin/bash

mkdir -p pages
while read p; do
  curl -G "https://www.tradingview.com/wiki/static/index.php" --data-urlencode "title=$p" --data-urlencode "action=raw" > "pages/$p.mw"
done <pages.txt
