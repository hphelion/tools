#!/bin/bash
echo start inject redirects

grep -v "^#" ./ServerArtifacts/inter-helpset-redirects.txt > inter-helpset-redirects.tmp 
  
while read -r FROM TO; do
  echo $FROM $TO;
  
  REDIRECT="if (dynamicURL == '$FROM') {window.location.href = '#$TO';} else"
  
  echo $REDIRECT
  echo blah
  pwd
  sed -i "s|function loadIframe(dynamicURL) {|function loadIframe(dynamicURL) { $REDIRECT |"  ./out/webhelp/oxygen-webhelp/resources/skins/desktop/toc_driver.js
  
 
  
echo blah

done < inter-helpset-redirects.tmp 

echo stop inject redirects



