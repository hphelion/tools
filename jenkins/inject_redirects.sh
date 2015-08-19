#!/bin/bash
echo start inject redirects

cat ./ServerArtifacts/inter-helpset-redirects.txt

for i in ./ServerArtifacts/inter-helpset-redirects.txt; do
  while read line; do
    echo $line | read FROM TO;
  done < ./ServerArtifacts/inter-helpset-redirects.txt;
  echo $FROM $TO;
done




REDIRECT="if (dynamicURL == '$FROM') {window.location.href = '#$TO';} else"

echo $EDIRECT

echo stop inject redirects
#sed –i  "s| function loadIframe(dynamicURL) {| function loadIframe(dynamicURL) { $REDIRECT|"  ./oxygen-webhelp/resources/skins/desktop/toc_driver.js




