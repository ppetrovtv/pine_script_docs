#!/bin/bash

mkdir -p files
while read f; do
  find ../tmp/pics -name "$f" -exec cp {} ./files/ \;
done < files_names.txt
