bin/bash
#These are the variables needed for each ditamap 
#export_to_drupal.sh TEST DITAMAPPATH DITAMAP PACKAGEKEY PACKAGEVERSION REPO BRANCH
#TEST = yes|no

y=1
writeIndex () { 
		sudo echo "<HTML><head><style> body {font-size: 100%; font-family: Arial;} a:link {text-decoration: none;} </style></head> <body> `date` <br>" > /var/www/html/for_drupal_import/index.html


		for i in `ls /var/www/html/for_drupal_import | egrep '(txt|tgz)'`
		do

			t=`ls -l /var/www/html/for_drupal_import/$i | awk '{print $6 " " $7 " " $8}'`
            s=`ls -lah /var/www/html/for_drupal_import/$i | awk '{print $5}'`
         
           
			threshold=80000
			actualsize=$(du -k "/var/www/html/for_drupal_import/$i" | cut -f 1)
            echo "$actualsize $threshold"
            
			if (( $actualsize > $threshold )); then
    			sudo echo "<br><a href=\"$i\">$i (Caution! File is $s Max allowed is 1GB)</a>"    >> /var/www/html/for_drupal_import/index.html

			else
    			sudo echo "<br><a href=\"$i\">$i</a>"    >> /var/www/html/for_drupal_import/index.html
			fi
			 
		done

		sudo echo "</body>"  >> /var/www/html/for_drupal_import/index.html
		sudo chmod 755 -R /var/www/html/for_drupal_import
}

 


TEST=$1
DITAMAPPATH=$2
DITAMAP=$3
PACKAGEKEY=$4
PACKAGEVERSION=$5
REPO=$6
BRANCH=$7
NOTAR="0"

 
  

if [[ $TEST == "yes"   ]]
then
ERRORREPORT="/var/www/html/for_drupal_import/FAILED.test_export_of_${REPO}_${PACKAGEKEY}.txt"
else
ERRORREPORT="/var/www/html/for_drupal_import/FAILED.html-import__${PACKAGEKEY}__${PACKAGEVERSION}.txt"
fi
  
    
    echo $ERRORREPORT
    
  
 
	echo "###########################################################"
	echo "BUILDING WITH THE FOLLOWING PARAMETERS:"
	echo "DITAMAPPATH= $DITAMAPPATH"
	echo "DITAMAP= $DITAMAP"
	echo "PACKAGEKEY= $PACKAGEKEY"
	echo "PACKAGEVERSION= $PACKAGEVERSION"
	echo "REPO= $REPO"  
	echo "BRANCH = $BRANCH"
	echo "###########################################################"

	sudo chmod -R 777 /var/www/html/for_drupal_import
	
    sudo rm /var/www/html/for_drupal_import/html-import__${PACKAGEKEY}__${PACKAGEVERSION}.tgz || true
    sudo rm $ERRORREPORT || true
    
    echo "BUILDING WITH THE FOLLOWING PARAMETERS:" 	 > $ERRORREPORT
	echo "DITAMAPPATH= $DITAMAPPATH" 				>> $ERRORREPORT
	echo "DITAMAP= $DITAMAP" 						>> $ERRORREPORT
	echo "PACKAGEKEY= $PACKAGEKEY" 					>> $ERRORREPORT
	echo "PACKAGEVERSION= $PACKAGEVERSION" 			>> $ERRORREPORT
	echo "REPO= $REPO"   							>> $ERRORREPORT
	echo "BRANCH = $BRANCH" 						>> $ERRORREPORT

	sudo rm -r *

	git clone $REPO documentation --branch $BRANCH

	cp -r  ./documentation/* ./

	pwd
    
	for i in `find . -path ./content/en_us/training -prune -o -name "*.ditamap"` #START add empty otherprops to leaf nodes
	do
 		sed -i 's|/>| otherprops="null" />|g' "$i"
	done  #END add empty otherprops to leaf nodes



	## Delete the tools repo, reclone and checkout the proper branch  ##########################
	rm -r tools
	git clone git@github.com:hphelion/tools.git 
	cd tools
	git checkout drupal-export
	cd -
	chmod 777 ./tools/jenkins/*.sh


	#START Build the help
	./tools/jenkins/license.sh
	./tools/jenkins/oxygen-webhelp-build.sh $DITAMAPPATH$DITAMAP
    #END Build the help


	echo "$BUILD_URL" >  ./out/webhelp/buildURL.txt
	echo "$PUSHED_BY" | sed  's/^\(.\)/\U\1/' >  ./out/webhelp/pushedBY.txt



	## Delete some files that are not needed by the import.  ###################################
	rm -r ./out/webhelp/oxygen-webhelp
	rm -r ./out/webhelp/*.css
	rm -r ./out/webhelp/*.txt
	rm ./out/webhelp/dita.list
	rm ./out/webhelp/dita.xml.properties
	rm ./out/webhelp/index.xml
	rm ./out/webhelp/index_frames.html
	rm ./out/webhelp/toc.html
	rm ./out/webhelp/toc.orig.xml
	rm ./out/webhelp/toc.xml

	echo "$DITAMAPPATH$DITAMAP"


	cp ./out/webhelp/toc.xml ./out/webhelp/toc.orig.xml



	## Write the header of the manifest file####################################################

	echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?><html-import>
	<metadata><package-key>$PACKAGEKEY</package-key>
	<package-version>$PACKAGEVERSION</package-version>
	</metadata>" > ./out/webhelp/html-import.xml

	BIGMAP=`find ./temp/webhelp -name "$DITAMAP"`

	echo "using ditamap $BIGMAP"


	cat "$BIGMAP" |\
    grep -v "<keydef class=" |\
	sed 's|<topicref class="- map/topicref " format="pdf"[^>]*>||g' |\
	sed ':a;N;$!ba;s/\n/ /g'| sed 's|<!--[^\!]*-->||g' | tr -s ' ' | \
	sed 's|collection-type="[^"]*"||g'  |\
	sed 's|<topicmeta|\n<topicmeta|g' 	|\
	sed 's|topicmeta>|topicmeta>\n|g' 	|\
	sed 's|<topicref class|\n<topicref class|g' 	|\
	sed 's|<topicmeta.*||g' 			|\
	sed 's|type="[^>]*>|>|g' 			|\
	sed 's|class="- map/topicref "||g'	|\
	sed 's|locktitle="yes"||g'    		|\
	sed 's|linking="none"||g'     		|\
	sed 's|xtrc="[^?]*>"||g'      		|\
	sed 's|<keydef class.*||g'    		|\
	sed 's|</keydef>||g'    	  		|\
	sed 's|<title class.*||g'     		|\
	sed 's|href=|source=|g'    	  		|\
	sed 's|otherprops="null"||g'        |\
    sed 's|format="dita"||g'            |\
	grep topicref > ./out/webhelp/temp.xml

	sed -i  '0,/" *>/s//" otherprops="" >/' ./out/webhelp/temp.xml

  
	##Modify the ditamap to meet the specifications requried by the drupal import########
	cat ./out/webhelp/temp.xml | sed ':a;N;$!ba;s/\n/ /g'| sed 's|<!--[^\!]*-->||g' | tr -s ' ' | \
	sed 's|> <|>\n<|g'  | grep topicref | sed 's|topicref|topic|g' | \
	sed 's|href=|source=|g' | sed 's|locktitle="yes"||g'  | \
	sed 's|\(navtitle="[^"]*"\)\(.*\)\(source="[^"]*"\)|\3\2\1|g' >> ./out/webhelp/temp

	cat ./out/webhelp/temp | sed ':a;N;$!ba;s/\n/ /g' | sed 's|" > </topic>|" />|g' > ./out/webhelp/temp1
	mv ./out/webhelp/temp1 ./out/webhelp/temp
    
    
    if [[ $(grep  "<topichead" ./out/webhelp/temp) ]]
    then
    	echo "" >> $ERRORREPORT
		echo "Topicheads present, but not allowed"  >> $ERRORREPORT
		grep "<topichead" ./out/webhelp/temp  | sed 's|> *<|> \n<|g'  | grep "<topichead" >> $ERRORREPORT
   		NOTAR=1
	fi
 
 
	## Check the manifest file to ensure that otherprops exists where needed.  #
	if [[ $(sed 's|<topic|\n<topic|g'  ./out/webhelp/temp | grep "\"[^/]*>"   | grep -v otherprops) ]]
	then
		echo ""
    	echo "##################################################################"
		echo "otherprops missing:"
    	sed 's|<topic|\n<topic|g'  ./out/webhelp/temp | grep "\"[^/]*>"   | grep -v otherprops
        echo ""
        echo "Otherprops missing:"  															>> $ERRORREPORT
        sed 's|<topic|\n<topic|g'  ./out/webhelp/temp | grep "\"[^/]*>"   | grep -v otherprops  >> $ERRORREPORT
		NOTAR=1
	else
		echo "all ok"
	fi

 

	## Do some more modifications to the manifest file ##
	cat  ./out/webhelp/temp | sed  's|otherprops|path|g' | sed 's|\(source="[^"]*\)dita"|\1html"|g' | grep topic >> ./out/webhelp/html-import.xml



	rm ./out/webhelp/temp


	 
	top=`grep " source=" ./out/webhelp/html-import.xml | head -1 | sed 's|.*source="\([^"]*\)".*|\1|'`
	sed -i "s|\(source=\"$top\" navtitle=\"[^\"]*\"\s*\)path=\"[^\"]*\"|\1|g" ./out/webhelp/html-import.xml
	echo "</html-import>" >> ./out/webhelp/html-import.xml



	## Prepare the directory structure for the tar ball ########################################
	mkdir ./out/webhelp/$DITAMAPPATH
	mv ./out/webhelp/* ./out/webhelp/$DITAMAPPATH
	mv ./out/webhelp/$DITAMAPPATH/html-import.xml ./out/webhelp/
	echo copy media start
	pwd
	mv ./out/media ./out/webhelp/



	sed -i "s| *source=\"| source=\"$DITAMAPPATH|g"  ./out/webhelp/html-import.xml

	rm ./out/webhelp/temp


 
	mv ./out/webhelp/${DITAMAPPATH}html-import.xml ./out/webhelp/


	## Remove unneeded content from the HTML file header #######################################
	for i in `find ./out/webhelp/ -name "*.html"` #START clean HTML header for all content files
	do
		sed -i 's|<?xml version="1.0" encoding="UTF-8"?>||g' $i
		sed -i 's|<!DOCTYPE html||g' $i
		sed -i 's|  PUBLIC "-//W3C//DTD XHTML 1.0.*||g' $i
		sed -i 's|xml:lang="en-us" lang="en-us"||g' $i
		sed -i 's|<head><meta xmlns="http://www.w3.org/1999/xhtml.*||g' $i
		sed -i 's|.*var prefix =.*index.html";||g' $i
		sed -i 's|.*--></script><script xmlns="http://www.w3.org/1999/xhtml.*||g' $i
		sed -i 's|onload="highlightSearchTerm()"||g' $i

		HEADER=`grep "title topictitle1" $i | sed  's|<h1 class="title topictitle1">\(.*\)</h1>|\1|g' | sed 's|^\s*||'  `
    
    	TITLE=`echo $HEADER | sed 's|<[^>]*>||g'  | sed 's|<\/[^>]*>||g' `  
        

		sed -i 's|<h1 class="title topictitle1">.*</h1>||g' $i
		sed -i "s|<html >|<html><head><title>$TITLE</title></head>|g" $i
    	sed -i "s|<bod.*>|<body><h1 id=\"pagetitle\">$TITLE</h1>|g" $i

	done #END clean HTML header for all content files

	rm empty_topics.txt || true


	sed -i 's|>|>\n|g' ./out/webhelp/html-import.xml

	cat ./out/webhelp/html-import.xml | grep source|  sed 's|.*source="\([^"]*\).*|\1|g'

 

	for i in `cat ./out/webhelp/html-import.xml | grep source|  sed 's|.*source="\([^"]*\).*|\1|g'` # START
	do

		echo "i = $i" 
		j=`echo $i | sed 's|\.html$|\.dita|'`
		echo 777

		EMPTY=`cat $j | sed ':a;N;$!ba;s/\n/ /g'| perl -pe  's|<!--.*-->||g'| tr -s ' '|  egrep  "<body> *<p> *</p> *</body>"`

		echo "EMPTY= $EMPTY"

		if [[ $EMPTY == "" ]]
		then
			echo "content contained in $j"
		else
			echo "########################################################"
			echo "ERROR: no content in $j"
	 
            echo "" >> $ERRORREPORT
            echo "ERROR: no content in $j"  >> $ERRORREPORT
            NOTAR=1
		fi
   
   		echo 888 
  
    	TOPICID=`egrep "<(topic|concept|task|reference|glossgroup)" $j | head -1 | sed 's|.*id="\([^"]*\).*|\1|'`
        echo "TOPICID = $TOPICID"
        
		TOPICID=`head $j | sed ':a;N;$!ba;s/\n/ /g'  | sed s'| | |g' | sed 's|.*id="\([^"]*\)".*|\1|'`
		echo "TOPICID = $TOPICID"
		TOPICID=`grep id $j | head -1 | sed 's|.*id="\([^"]*\)".*|\1|'`

		echo "TOPICID = $TOPICID"
    	echo "j= $j"
		 
         
        echo "  i = $i"      
  		DFILE=`echo "$i" | sed 's|.html$|.dita|' `
        
        cd ./documentation
        
   		echo "  DFILE = $DFILE"  
    	DATERAW=`git log -1 --date=iso --pretty=format:%ad $DFILE | sed 's| +.*||'`
        
        DATE=`date --date="$DATERAW" +"%a, %d %b %Y %R:%S GMT"`

		echo "  DATE = $DATE" 
      
		cd -  
         
		pwd
		ls ./out/webhelp/$i

		sed -i "s|</head>|<meta name=\"html-import-package-key\" content=\"$PACKAGEKEY\"/> <meta name=\"html-import-package-version\" content=\"$PACKAGEVERSION\" /> <meta name=\"html-import-last-commit-date\" content=\"$DATE\" /> <meta name=\"html-import-topic-id\" content=\"$TOPICID\" /> <meta name=\"html-import-file-path\" content=\"$i\" /></head>|" ./out/webhelp/$i


		echo "Meta data missing in:"
		grep -L "meta name" ./out/webhelp/$i
		echo "Meta data missing in^^"


		echo "i = $i"
		sed -i "s|topic source=\"$i\"|topic id=\"$TOPICID\" source=\"$i\"|"  ./out/webhelp/html-import.xml
        
        
        if [[ $(grep 'meta.*content=""'  ./out/webhelp/$i) || $(grep -L "html-import-package"  ./out/webhelp/$i) ]]
		then
			echo ""
    		echo "##################################################################"
			echo "Metadata Missing:"
    		grep -l 'meta.*content=""'  ./out/webhelp/$i
        	echo ""
        	echo "Metadata Missing:"  						>> $ERRORREPORT
        	grep -l 'meta.*content=""'     ./out/webhelp/$i	>> $ERRORREPORT
			grep -L "html-import-package"  ./out/webhelp/$i	>> $ERRORREPORT
			#exit 1;
			NOTAR=1
		else
			echo "all ok"
		fi

	done #END
    
 
	sed -i 's|path="null"||g'   ./out/webhelp/html-import.xml
	sed -i 's|>|>\n|g'   ./out/webhelp/html-import.xml
	sed -i 's|<keydef[^>]*>||g' ./out/webhelp/html-import.xml
	sed -i '0,/.html"/s//.html" path=""/' ./out/webhelp/html-import.xml 
	sed -i 's|path=""\(.*\)path="[^"]*"|\1 path=""|g' ./out/webhelp/html-import.xml 
    sed -i 's|path="[^"]*"\(.*\)path=""|\1 path=""|g' ./out/webhelp/html-import.xml 
    sed -i 's|path=""\(.*\)path=""|\1 path=""|g' ./out/webhelp/html-import.xml 
 
 
	if [[ $(grep -l "path=\".*path=\""  ./out/webhelp/$i ) ]]
	then
		echo ""
    	echo "##################################################################"
		echo "Duplicate Path Attribute:"
    	grep -l  "path=\".*path=\""  ./out/webhelp/$i   
        echo ""
        echo "Duplicate Path Attribute:"  				>> $ERRORREPORT
        grep -l  "path=\".*path=\""  ./out/webhelp/$i	>> $ERRORREPORT
		#exit 1;
		NOTAR=1
	else
		echo "all ok"
	fi
    
    
    
    
    if [[ $(grep topic ./out/webhelp/html-import.xml ) ]]; #
    then
		echo alles gut
    else
    	echo something has gone terribly wrong
        echo ""  >> $ERRORREPORT
    	echo "The html-import.xml file has no content files." >> $ERRORREPORT
    	NOTAR=1
 	fi
    
    
    if [[ $(grep id ./out/webhelp/html-import.xml  | sed 's|.*topic id="\([^"]*\)".*|\1|g' | sort | uniq -d) ]]; 
    then
		NOTAR=1	 
    	echo "duplicate IDs"
        echo "" >> $ERRORREPORT
    	sudo echo "duplicate IDs (either same ID in two files or 1 file added twice to ditamap)" 			>> $ERRORREPORT
        grep id ./out/webhelp/html-import.xml  | sed 's|.*topic id="\([^"]*\)".*|\1|g' | sort | uniq -d 	>> $ERRORREPORT
    
   		# sudo grep id ./out/webhelp/html-import.xml  | sed 's|.*topic id="\([^"]*\)".*|\1|g' | sort | uniq -d >>  \
   		# /var/www/html/for_drupal_import/FAILED.html-import__${PACKAGEKEY}__${PACKAGEVERSION}.txt
   		echo aa
   		for i in `grep id ./out/webhelp/html-import.xml  | sed 's|.*topic id="\([^"]*\)".*|\1|g' | sort | uniq -d `
   		do
      		echo bb
            find .  -name "*.dita" -exec grep -l "id=\"$i\"" {} \; |  sed 's|.*/||g' | sed 's|\.dita|.html|g'  |sort | uniq -d
			pwd
			for k in `find .  -name "*.dita" -exec grep -l "id=\"$i\"" {} \; |  sed 's|.*/||g' | sed 's|\.dita|.html|g'  |sort | uniq -d`
     		do
     
   				grep $k  ./out/webhelp/html-import.xml 
   				echo "" 														>> $ERRORREPORT
   				echo "Duplicate ID $i:" 										>> $ERRORREPORT
   				grep $k  ./out/webhelp/html-import.xml | sed 's|.html$|.dita|g' >> $ERRORREPORT
   			done
		done
   
  
   		## Write an index file with links to all tar balls in case anyone wants to download them manually ##

		writeIndex

	else
    	echo "no duplicate IDs"
  		echo "check for missing IDs in html-import.xml"
   		cat ./out/webhelp/html-import.xml | grep "<topic" |  grep -v 'id="[^"]\+"'
   
    	if [[ $(cat ./out/webhelp/html-import.xml | grep "<topic" |  grep -v 'id="[^"]\+"')  ]]
    	then
    		NOTAR=1
            echo "" 																	>> $ERRORREPORT
    		echo "Some topics missing IDs:" 											>> $ERRORREPORT
    		cat ./out/webhelp/html-import.xml | grep "<topic" |  grep -v 'id="[^"]\+"'  >> $ERRORREPORT
    	fi
   
   
		if [[ $(xmllint --valid ./out/webhelp/html-import.xm | grep "parser error")  ]]
    	then
    		NOTAR=1
            echo "" >> $ERRORREPORT
    		echo "XML Error in html-import.xml" >> $ERRORREPORT
    		xmllint --valid ./out/webhelp/html-import.xm | grep "parser error"  >> $ERRORREPORT
     	fi
  

		sudo mkdir /var/www/html/for_drupal_import
		sudo chmod -R 777 /var/www/html/for_drupal_import


		## Make the tar ball on the server #########################################################
		cd ./out/webhelp/
    	rm temp
    	rm temp.xml
    

    
    	if  [  $NOTAR == "0" ]
    	then
        	 
 			rm $ERRORREPORT
    		## sudo tar zcvf /var/www/html/for_drupal_import/html-import__${PACKAGEKEY}__${PACKAGEVERSION}.tgz ./
			## echo "/var/www/html/for_drupal_import/html-import__${PACKAGEKEY}__${PACKAGEVERSION}.tgz"
    	 
        fi
		cd -

		## Write an index file with links to all tar balls in case anyone wants to download them manually ##

		 writeIndex
    
	fi
    
   
	sudo chmod 755 -R /var/www/html/for_drupal_import
    
 
## Copy the tar ball to the drupal server ##################################################
