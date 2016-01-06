#!/bin/bash
echo ===start inject_redirects.sh===

grep -v "^#" ./tools/jenkins/inter-helpset-redirects.txt > inter-helpset-redirects.tmp 
  
while read -r FROM TO; do
  REDIRECT="if (dynamicURL == '$FROM') {window.location.href = '#$TO';} else"
  sed -i "s|function loadIframe(dynamicURL) {|function loadIframe(dynamicURL) { $REDIRECT |"  ./out/webhelp/oxygen-webhelp/resources/skins/desktop/toc_driver.js
done < inter-helpset-redirects.tmp 

echo ===end inject_redirects.sh===



