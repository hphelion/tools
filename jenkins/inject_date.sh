#!/bin/bash
#Author: Greg Larsen
#For each ditafile, get the date last comitted, improve format and inject into the converted HTML

for i in `find . -name "*.dita"`
do

    j=`echo $i | sed 's|\.dita$|\.html|'`

    fullpath=`echo $j | sed 's|\.\/|./out/webhelp/|'`

    DATE=`git log -1 --date=short --pretty=format:%ad $i`

    PRETTYDATE=`date -d$DATE +'%d %b %Y'`

    sed -i "s|<\/h1>|</h1>Last updated: $PRETTYDATE|" $fullpath    
 done
