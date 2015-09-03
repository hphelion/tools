#!/bin/bash
#Author: Greg Larsen
#For each ditafile, get the date last comitted, improve format and inject into the converted HTML

echo ===start inject_date.sh===
for i in `find  -name "*.dita" -not -path "./publiccloud/api/*"`
do

    j=`echo $i | sed 's|\.dita$|\.html|'`
    fullpath=`echo $j | sed 's|\.\/|./out/webhelp/|'`
    #DATE=`git log -1 --date=short --pretty=format:%ad $i`
    DATE=`git log -1 --date=iso --pretty=format:%ad inject_date.sh | sed 's| +.*||'` ; echo $DATE

    if [ "$1" == "-time" ]
    then
    	PRETTYDATE=`date -d"$DATE" +'%d %b %Y (%H:%M UTC)'`	
    else
    	PRETTYDATE=`date -d"$DATE" +'%d %b %Y'`
    fi

    sed -i "s|<\/h1>|</h1><p class=\"heliondate\">Last updated: $PRETTYDATE</p>|" $fullpath    

done
echo ===end inject_date.sh===
