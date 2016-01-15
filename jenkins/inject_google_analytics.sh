#!/bin/sh


echo ===start inject_google_analytics.sh===
cd ./out/webhelp/


METRIC_CODE1="<!-- Begin Analytics Code -->"
METRIC_CODE2="<script>"
METRIC_CODE3="(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){"
METRIC_CODE4="(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),"
METRIC_CODE5=" m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)"
METRIC_CODE6=" })(window,document,'script','//www.google-analytics.com/analytics.js','ga');"
METRIC_CODE7=" ga('create', 'UA-58640491-1', 'auto');  ga('send', 'pageview'); </script>"
METRIC_CODE8="<!-- End Analytics Code -->"

for i in `find . -name "*.html"`
do
   sed -i "s%</head>% \n $METRIC_CODE1 \n $METRIC_CODE2 \n $METRIC_CODE3 \n $METRIC_CODE4 \n $METRIC_CODE5 \n $METRIC_CODE6 \n $METRIC_CODE7 \n $METRIC_CODE8 \n </head>%" $i

   done

   cd -
   
echo ===end inject_google_analytics.sh===
