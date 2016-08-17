#!/bin/bash
source <(curl -s https://raw.githubusercontent.com/hphelion/tools/master/jenkins/functionLibrary.sh)

HIPCHAT_PASS="1232"
HIPCHAT_FAIL="1232,1295"
#docs 1295
#test 845


#Notify hipChat that build has started
hipChat PASS " #$BUILD_NUMBER started (<a href='$BUILD_URL'>Open</a>)"  $HIPCHAT_PASS


#Check to make sure that the build.on.push ditamap exists. else quit.
if [ ! -f build.on.push.ditamap ]; then
    echo "build.on.push.ditamap not found. Nothing to build."
    exit 0;
fi


#Get repo name
REPO=`echo "$GIT_URL" | sed 's|.*/||g' | sed 's|\.git$||g'`

 
#Get the tools repo 
get_the_tools_repo


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


#There should not be any old output files...but just in case 
rm -r ./out/ || true /dev/null 2>&1


#Write the oXygen license file
./tools/jenkins/license.sh


#Build the build.on.push ditamap
./tools/jenkins/oxygen-webhelp-build.sh build.on.push.ditamap


#Insert the  disclaimer snippet, if there is one.
./tools/jenkins/insert_disclaimer.sh


#Insert any redirects
./tools/jenkins/inject_redirects.sh


#Inject the date and time
./tools/jenkins/inject_date.sh -time

find ./out/webhelp/ -name "*.html" -exec sed -i  s'|\(<p class="footer">The OpenStack[^<]*\)</p>||' {} \;


echo "$BUILD_URL" >  ./out/webhelp/buildURL.txt
echo "$PUSHED_BY" | sed  's/^\(.\)/\U\1/' >  ./out/webhelp/pushedBY.txt


sudo cp /var/lib/jenkins/HPE-Helion.png ./out/webhelp/


