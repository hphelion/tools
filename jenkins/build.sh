#!/bin/bash

 #Call assemble-repos.sh before running
 

echo "Building HTML docs:"
 
if [ -z "$BRANCH_TO_BUILD" ]
then
	PUSHED_BY=`git log -1 | grep Author | sed 's|.*: \([^<]*\)<.*|\1|' | sed 's| .*||'`
    BRANCH=`echo $GIT_BRANCH | sed 's|.*\/||'`
    
else
    GIT_BRANCH=$BRANCH_TO_BUILD
    BRANCH=`echo $GIT_BRANCH | sed 's|.*\/||'`
    git checkout $BRANCH
    git pull
    PUSHED_BY=$BUILD_USER_FIRST_NAME
    
fi


 


echo "###"
 
echo $GIT_BRANCH
echo $BRANCH


#Don't build these branches:
if [ "$BRANCH" = "hos2.0ga" ] || [ "$BRANCH" = "ditaval-test" ]|| [ "$BRANCH" = "pdf_test" ]|| [ "$BRANCH" = "doc-split-test" ]
then
	exit 0
fi

echo "###"


#remove old output files
rm -r ./out/ || true

 
chmod -R 777 ./tools/jenkins/

./tools/jenkins/license.sh






./tools/jenkins/oxygen-webhelp-build.sh docs.hpcloud.com.ditamap	
#./tools/jenkins/inject_tableau_code.sh
./tools/jenkins/inject_google_analytics.sh ./out/webhelp/
#./tools/jenkins/insert_disclaimer.sh
./tools/jenkins/inject_redirects.sh





./tools/jenkins/inject_date.sh -file


 
 
#echo "copy start"
#sudo rm -r /var/www/html/dita-test-build/*
#sudo cp -r /var/lib/jenkins/workspace/helion-dita-build/out/webhelp/* /var/www/html/dita-test-build/
#sudo chmod -R 755 /var/www/html/dita-test-build/


cp -r ./commercial/GA1/RollYourOwn11/  out/webhelp/commercial/GA1/RollYourOwn11/
cp -r ./commercial/GA1/RollYourOwn10/  out/webhelp/commercial/GA1/RollYourOwn10/
cp -r ./media/ ./out/webhelp/
cp -r ./hdp-html/ ./out/webhelp/
cp -r ./hcf/media ./out/webhelp/hcf/media
cp -r ./3.x/media ./out/webhelp/3.x/media
cp -r ./file/  out/webhelp/file/
cp -r ./ServerArtifacts/404.html  out/webhelp/404.html
cp -r ./ServerArtifacts/htaccess.with.rewrite.rules  out/webhelp/.htaccess
