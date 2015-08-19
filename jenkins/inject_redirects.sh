#!/bin/bash
echo start inject redirects

  
while read -r FROM TO; do
  echo $FROM $TO;
  REDIRECT="if (dynamicURL == '$FROM') {window.location.href = '#$TO';} else"
  echo $EDIRECT
done < `grep -v "#" ./ServerArtifacts/inter-helpset-redirects.txt;`

echo stop inject redirects
#sed –i  "s| function loadIframe(dynamicURL) {| function loadIframe(dynamicURL) { $REDIRECT|"  ./oxygen-webhelp/resources/skins/desktop/toc_driver.js




