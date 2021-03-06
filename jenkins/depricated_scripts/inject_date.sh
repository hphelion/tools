#!/bin/bash
# Author: Greg Larsen
# For each ditafile, get the date last comitted, improve format and inject into the converted HTML
# With the -time switch, the output looks like this: Last updated: 12 Aug 2015 (13:52 UTC)
# Without -time switch, the output looks like this: Last updated: 27 Aug 2015
# Do not use the -time switch on public documents.
# If you want to get the date from the timestamp instead of the commit, use -file


get_the_tools_repo () {
	if [[ -n $1 ]]
	then 
	$1="master"
	git clone -b $1 --local /var/lib/jenkins/workspace/ADMIN--pull-all-repos/cannonical/tools
}

echo ===start inject_date.sh===
for i in `find  -name "*.dita" -not -path "./publiccloud/api/*"`
do
    echo ""
    j=`echo $i | sed 's|\.dita$|\.html|'`
    fullpath=`echo $j | sed 's|\.\/|./out/webhelp/|'`
    echo $fullpath
    #DATE=`git log -1 --date=short --pretty=format:%ad $i`

    if [ "$1" == "-file" ]
    then
    
    DATE=`stat --format=%y $i`
    else

    DATE=`git log -1 --date=iso --pretty=format:%ad $i | sed 's| +.*||'` ; echo $DATE
    fi

    if [ "$1" == "-time" ]
    then
    	PRETTYDATE=`date -d"$DATE" +'%d %b %Y (%H:%M UTC)'`	
    else
    	PRETTYDATE=`date -d"$DATE" +'%d %b %Y'`
    fi

	if [ -e $fullpath ]
	then
		sed -i "s|<\/h1>|</h1><p class=\"heliondate\">Last updated: $PRETTYDATE<a href=\"\" class="xref" style=\"float:right\" onclick=\"window.print()\">Print this page</a> </p>|" $fullpath    
		echo starting from 	
		pwd
		echo before time change
		stat --format=%y   $fullpath 
		touch -d "$PRETTYDATE"  $fullpath
		echo after time change	
		stat --format=%y   $fullpath 
	else
		echo Skipping $fullpath 
	fi
	
done
echo ===end inject_date.sh===
