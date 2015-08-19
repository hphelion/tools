#!/bin/bash
echo start inject redirects

grep -v "^#" ./ServerArtifacts/inter-helpset-redirects.txt > inter-helpset-redirects.tmp 
  
while read -r FROM TO; do
  echo $FROM $TO;
  REDIRECT="if (dynamicURL == '$FROM') {window.location.href = '#$TO';} else"
  echo $REDIRECT
  sed –i "s|function|function|"  ./oxygen-webhelp/resources/skins/desktop/toc_driver.js


done < inter-helpset-redirects.tmp 

echo stop inject redirects



