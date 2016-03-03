#!/bin/bash

find  . -name "*.png" -o -name "*.jpg" -o -name "*.bmp" -o -name "*.gif" | sed 's|.*/||g' > temp.txt

cat temp.txt | sort | uniq > files.on.disk.txt

for i in `find . -name "*.dita"`; 
do 
  egrep '(png|jpg|bmp|gif)' $i | sed 's|.* href=".*/\([^"]*\)".*|\1|g' | sed 's|.*src=".*/\([^"]*\)".*|\1|g' |\
  grep -v "<" ;  
done > temp.txt

cat temp.txt | sort | uniq > files.in.dita.txt

echo "Graphics files on disk that are not referenced by any ditafile in this branch and repo"
diff files.in.dita.txt files.on.disk.txt  | grep ">"

