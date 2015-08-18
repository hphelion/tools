#!/bin/sh

cd ./out/webhelp/
   
for i in `find . -name "*.html"`
do


   TITLE=`grep "<title>" $i | sed 's|.*<title>\(.*\)</title>.*|\1|'`



   METRIC_CODE1="<!-- Begin Analytics Code -->"
   METRIC_CODE2="<script language='JavaScript'>"
   METRIC_CODE3="var hpmmd=window.hpmmd||{type: 'Cleansheet Wash', page:{events:[]}, product:{},user:{},legacy:{},promo:{}};"
   METRIC_CODE4="hpmmd.page.name='$TITLE';"
   METRIC_CODE5="</script>"
   METRIC_CODE6="<script language=\"JavaScript\" type=\"text/javascript\" src=\"https://ssl.www8.hp.com/h10000/cma/ng/lib/bootstrap/metrics.js\">"
   METRIC_CODE7="</script>"
   METRIC_CODE8="<!-- End Analytics Code -->"

   echo metric code $METRIC_CODE1

   sed -i "s%</head>% \n $METRIC_CODE1 \n $METRIC_CODE2 \n $METRIC_CODE3 \n $METRIC_CODE4 \n $METRIC_CODE5 \n $METRIC_CODE6 \n $METRIC_CODE7 \n $METRIC_CODE8 \n </head>%" $i

   done

   cd -
