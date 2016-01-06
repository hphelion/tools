#!/bin/sh


echo ===start inject_disclaimer===
DISCLAIMER=`cat disclaimer_snippet` || true
for i in `find ./out/webhelp -name "*.html"`
do
   echo "inject disclaimer into $i"
   sed -i "s|\([^>]\)</h1>|\1</h1> $DISCLAIMER|g" $i

done

echo ===stop inject_disclaimer===
