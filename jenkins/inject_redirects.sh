#!/bin/bash
echo start inject redirects



for i in `grep -v "#" ./ServerArtifacts/inter-helpset-redirects.txt` do
  while read line; do
    echo $line | read FROM TO;
  done < `grep -v "#" ./ServerArtifacts/inter-helpset-redirects.txt`
  echo $FROM $TO;





REDIRECT="if (dynamicURL == '$FROM') {window.location.href = '#$TO';} else"

echo $EDIRECT


done

#sed –i  "s| function loadIframe(dynamicURL) {| function loadIframe(dynamicURL) { $REDIRECT|"  ./oxygen-webhelp/resources/skins/desktop/toc_driver.js

echo stop inject redirects



