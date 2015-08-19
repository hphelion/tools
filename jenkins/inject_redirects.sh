#!/bin/bash
echo start inject redirects

grep -v "^#" ./ServerArtifacts/inter-helpset-redirects.txt > inter-helpset-redirects.tmp 
  
while read -r FROM TO; do
  echo $FROM $TO;
  REDIRECT="if (dynamicURL == '$FROM') {window.location.href = '#$TO';} else"
  echo $REDIRECT
done < inter-helpset-redirects.tmp 

sed –i  "s|function loadIframe(dynamicURL) {| function loadIframe(dynamicURL) { $REDIRECT|"  ./oxygen-webhelp/resources/skins/desktop/toc_driver.js

echo stop inject redirects



