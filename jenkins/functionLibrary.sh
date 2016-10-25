

#Set some global variables
JENKINS_NAME="15.184.4.11"
DOC_SITE_NAME="docs.hpcloud.com"

PRIMARY_WAN_IP="173.205.188.47"		#External IP address for docs.hpcloud.com

#PRIMARY_LAN_IP="192.168.251.121"	#Internal IP address for docs.hpcloud.com
PRIMARY_LAN_IP="173.205.188.47"	 #Internal IP address for docs.hpcloud.com

TEST_WAN_IP="15.184.4.11" 		#External IP address for docs-staging.hpcloud.com

TEST_LAN_IP="15.184.4.11" 		#Internal IP address for docs-staging.hpcloud.com

#TEST_DOC_SITE_NAME="docs-staging.hpcloud.com:9099"
#TEST_DOC_SITE_NAME="docs-staging.hpcloud.com:9099"

HUDSON_HOME="/var/lib/jenkins"


 


function get_the_tools_repo () {
echo "START ${FUNCNAME[0]} (referenced from functionLibrary.sh)"
	
	#If no argument was passed to the function, use the master branch.  Otherwise use the argument as the branch
	if [[ -z "$1"   ]];
	then 
		branch="master"
	else
		branch=$1
	fi
	echo "Cloning $branch branch of tools repo"
	
	#The tools repo should not be there already, but try to remove it--just in case
    rm -r tools || true
	
	#Do a single-branch, shallow clone of the tools repo from ${HUDSON_HOME}/canonical/
	#If anything goes wrong, stop the build.
	if !  git clone --local -b $branch --single-branch   ${HUDSON_HOME}/canonical/tools
	then
		echo >&2 Cloning git@github.com:hphelion/tools.git failed.  Stopping the build.
		exit 1
	fi
	
	cd tools
	git checkout $branch
	cd ..
	
	
	#Make sure that the scripts in the jenkins folder are executable
	chmod 755 ./tools/jenkins/*.sh
	
 echo "END ${FUNCNAME[0]}"
 }
 


function adjust_date_to_last_commit {
echo "START ${FUNCNAME[0]} (referenced from functionLibrary.sh)"
	
	#Note that this only works on a complete repo.  A shallow clone does not have all the needed info.
	
	#If no argument was passed to the function, use the repo variable branch.  Otherwise use the argument as the branch
	if [[ -z "$1"   ]];
	then 
		using $repo
	else
		repo=$1
	fi
	
	
	
	
	
	#cd into the repo
    cd $repo  
	
    #for each dita file, 
	for t in $(find . -name "*.dita");
    do
    	#echo $repo : $t
        stat --format=%y $t
		
		#get the date of the last commit of the file
    	git log -1 --date=iso --pretty=format:%ad $t | sed 's| +.*||'
        #echo""
		
		#Change the modification date of the ditafile so that it is equal to the date of the last commit
    	touch -d "`git log -1 --date=iso --pretty=format:%ad $t | sed 's| +.*||'` " $t
        stat --format=%y $t
        #echo""
	done
	
	#Return to the original directory
    cd -    
 echo "END ${FUNCNAME[0]} "
 }
 
function clone_repo {
echo "START ${FUNCNAME[0]} (referenced from functionLibrary.sh)"
	
	#Set branch and repo variables from the function's arguments
	repo=$1
	branch=$2
	echo "clone $branch branch of the $repo repo:"
	
	#Check to make sure that the branch exists
 	if [[ $(git ls-remote ${HUDSON_HOME}/canonical/${repo} ${branch} ) ]]; 
	then
		echo "Branch $branch exists"
		
		#If the branch exists, remove any old copy of the repo
		rm -r $repo || true
		
			#Clone the repo from ${HUDSON_HOME}/canonical/, notify hipchat if the pull fails
			if ! git clone --local --branch ${branch} ${HUDSON_HOME}/canonical/$repo ${repo}
			then
				echo >&2 ${HUDSON_HOME}/canonical/$repo failed.  Stopping the build.
				hipChat FAIL "Cloning the <b>$repo repo failed.</b> Stopping the build.  No published files were not changed." $HIPCHAT_ROOM
				exit 1;
			fi
	
	else
		#If the branch does not exist, notify HipChat and exit.
		echo "Branch $branch does not exist.  Stopping the build."
		hipChat FAIL "Branch <b>$branch</b> does not exist on in the $repo. Stopping the build. No published files were not changed." $HIPCHAT_ROOM
		exit 1;
	fi	
 echo "END ${FUNCNAME[0]}
 "
 }

 

function extractBranch () {
	#Extract the branch from the a string taken from $HUDSON_HOME/doc-build-resources/repos+branches.txt
	echo "$1" | sed 's|\([^ ]*\).*$|\1|'
 }


function extractRepo () {

	#Extract the repo from the a string taken from $HUDSON_HOME/doc-build-resources/repos+branches.txt
	echo "$1" | sed 's|.*of the \([^ ]*\) repo)|\1|'
 }



function hipChat () {
echo "START ${FUNCNAME[0]} (referenced from functionLibrary.sh)"

#Usage: hipChat (PASS|FAIL) "MESSAGE" ROOM
#Set the URL to the console output for this build
CONSOLE=${BUILD_URL}console

if [[ $1 == "FAIL" ]]
then
	COLOR="red"
	MESSAGE="<b>$JOB_NAME</b> started by $BUILD_USER_FIRST_NAME $2 "
 
else
	COLOR="green"
    MESSAGE="<b>$JOB_NAME</b> started by $BUILD_USER_FIRST_NAME $2 " 
fi

echo "$COLOR"
echo "$MESSAGE"
 
#Set HipChat authorization and room     
#auth="U9LoIThHLKGGL49vLtiUJWinLHXJepo9zJVXbmCc"
auth="Rvwgu6is7Hc88okkE75Uy4pJWa5oUyxrKqwXGZZI" #Doc Jenkins
echo $3
for i in `echo $3 | sed 's|,|\n|g'`
do

echo $i
done


for i in `echo $3 | sed 's|,|\n|g'`
do

echo $i
room="$i"

#amok 145
#test 845
 
  
echo $CONSOLE
 
#Send notification to hipchat
 
curl \
	--insecure \
	--header "Authorization: Bearer $auth" \
	--header "Content-Type: application/json" \
	--request 'POST' \
	--data @- \
	https://hipchat.hpcloud.net/v2/room/$room/notification <<EOP
{
	"color":"$COLOR",
	"notify":false,
	"message":"$MESSAGE",
	"message_format":"html"
}
EOP
done	
	 
 echo " END ${FUNCNAME[0]} "
 }




function insert_disclaimer () {
echo "START ${FUNCNAME[0]} (referenced from functionLibrary.sh)"

	DISCLAIMER=`cat disclaimer_snippet` || true
	for i in `find ./out/webhelp -name "*.html"`
	do
		echo "Inject disclaimer into $i"
		sed -i "s|\([^>]\)</h1>|\1</h1> $DISCLAIMER|g" $i

	done

 echo "END ${FUNCNAME[0]}"
 }

 
 
function assemble_repos () {
echo "START ${FUNCNAME[0]} (referenced from functionLibrary.sh)"


#Set the variable to whatever was passed to this script.
HIPCHAT_ROOM="$1"

#Set the variables that define the publish branch for all repos
source ./tools/jenkins/publish-config.sh
 
#write publish branch variables to stdout so we know what is going on 
echo "#################################################################

      devplat_docs_BRANCH = $devplat_docs_BRANCH
	  stackato_docs_BRANCH = $stackato_docs_BRANCH
          hos_docs_BRANCH = $hos_docs_BRANCH
          hos_docs_LEGACYBRANCH = $hos_docs_LEGACYBRANCH
carrier_grade_docs_BRANCH = $carrier_grade_docs_BRANCH
 public_cloud_docs_BRANCH = $public_cloud_docs_BRANCH
          hcf_docs_BRANCH = $hcf_docs_BRANCH


#################################################################"

# For each repo, clone it and checkout publish branch, adjust the modification
# date of the ditafiles to the date of the last commit copy files into place
# for the final build.
 
    repo="hos.docs"
	branch="$hos_docs_BRANCH"
	clone_repo $repo $branch
    adjust_date_to_last_commit
	
	mkdir media
    cp -rp ${repo}/community/ ./3.x/
    cp -rp ${repo}/commercial/ ./3.x/
    cp -rp ${repo}/helion/ ./3.x/
    cp -rp ${repo}/hos-html/ ./3.x/
	cp -rp ${repo}/media/ ./3.x/media/
    cp -rp ${repo}/media/${repo} ./3.x/media/${repo}
    cp -rp ${repo}/*.ditamap ./3.x/
	rm -r ${repo}

	


	repo="devplat.docs"
	branch="$devplat_docs_BRANCH"
	clone_repo $repo $branch
    adjust_date_to_last_commit
	
	cp -rp ${repo}/devplatform/ ./
	cp -rp ${repo}/media/${repo} ./media/${repo}
    cp -rp ${repo}/*.ditamap ./
    cp -rp ${repo}/hdp-html/ ./
 
    rm -r $repo
 
 
 
 	repo="stackato.docs"
	branch="$stackato_docs_BRANCH"
	clone_repo $repo $branch
    adjust_date_to_last_commit
	
	cp -rp ${repo}/stackato/ ./
	cp -rp ${repo}/media/${repo} ./media/${repo}
    cp -rp ${repo}/*.ditamap ./
 
 
    rm -r $repo
 


	repo="carrier.grade.docs"
	branch="$carrier_grade_docs_BRANCH"
	clone_repo $repo $branch
    adjust_date_to_last_commit
	
	cp -rp ${repo}/media/${repo} ./media/${repo}
	cp -rp ${repo}/CarrierGrade/ ./
    cp -rp ${repo}/CarrierGrade2.0/ ./
    cp -rp ${repo}/CarrierGrade2.1/ ./
    cp -rp ${repo}/*.ditamap ./

	rm -r ${repo}


	repo="hcf.docs"
	branch="$hcf_docs_BRANCH"
	clone_repo $repo $branch
    adjust_date_to_last_commit
	
	cp -rp ${repo}/media/${repo} ./media/${repo}
    cp -rp ${repo}/*.ditamap ./
	cp -rp ${repo}/hcf/ ./
    
	rm -r ${repo}


	repo="hos.docs"
	branch="$hos_docs_LEGACYBRANCH"
	clone_repo $repo $branch
    adjust_date_to_last_commit
	
	cp -rp ${repo}/community/ ./
    cp -rp ${repo}/commercial/ ./
    cp -rp ${repo}/helion/ ./
    cp -rp ${repo}/hos-html/ ./
	cp -rp ${repo}/media/* ./media/
    cp -rp ${repo}/media/${repo} ./media/${repo}
    cp -rp ${repo}/*.ditamap ./
 
	rm -r ${repo}
	

	repo="wrapper.docs"
	branch="bundle-2015-may"
	clone_repo $repo $branch
    adjust_date_to_last_commit

	cp -r ${repo}/* ./
    rm -r ${repo}
 echo "END ${FUNCNAME[0]}"
 }




function inject_date () {
echo "START ${FUNCNAME[0]} (referenced from functionLibrary.sh)"

	for i in `find  -name "*.dita" -not -path "./publiccloud/api/*"`
	do
		# echo ""
		j=`echo $i | sed 's|\.dita$|\.html|'`
		fullpath=`echo $j | sed 's|\.\/|./out/webhelp/|'`
		# echo $fullpath
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

		
		if [ "$1" == "-full" ]
		then
			EXTRA=`git log -1 --pretty=format:"%an %ae \"%s\" %H" $i`	
			PRETTYDATE=`echo "$PRETTYDATE ($EXTRA)"`
		fi
		
		

		if [ -e $fullpath ]
		then
			sed -i "s|<\/h1>|</h1><p class=\"heliondate\">Last updated: $PRETTYDATE<a href=\"\" class="xref" style=\"float:right\" onclick=\"window.print()\">Print this page</a> </p>|" $fullpath    
			# echo starting from 	
			# pwd
			# echo before time change
			stat --format=%y   $fullpath 
			touch -d "$PRETTYDATE"  $fullpath
			# echo after time change	
			stat --format=%y   $fullpath 
		else
			echo Skipping $fullpath 
		fi
	
	done

echo "END ${FUNCNAME[0]}"
 }


function inject_disclaimer () {
echo "START ${FUNCNAME[0]} (referenced from functionLibrary.sh)"

	
	DISCLAIMER=`cat disclaimer_snippet` || true

	for i in `find ./out/webhelp -name "*.html"`
	do
		echo "Inject disclaimer into $i"
		sed -i "s|\([^>]\)</h1>|\1</h1> $DISCLAIMER|g" $i
	done

 echo "END ${FUNCNAME[0]}"
 }


function inject_redirects () {
echo "START ${FUNCNAME[0]} (referenced from functionLibrary.sh)"


	grep -v "^#" ./tools/jenkins/inter-helpset-redirects.txt > inter-helpset-redirects.tmp 
  
	while read -r FROM TO; do
		REDIRECT="if (dynamicURL == '$FROM') {window.location.href = '#$TO';} else"
		sed -i "s|function loadIframe(dynamicURL) {|function loadIframe(dynamicURL) { $REDIRECT |"  ./out/webhelp/oxygen-webhelp/resources/skins/desktop/toc_driver.js
	done < inter-helpset-redirects.tmp 

 echo "END ${FUNCNAME[0]}"
 }




function license () {
echo "START ${FUNCNAME[0]} (referenced from functionLibrary.sh)"

echo "------START-LICENSE-KEY------
Registration_Name=Eucalyptus Systems
Company=Eucalyptus Systems
Category=Enterprise-Floating
Component=Scripting
Version=15
Number_of_Licenses=1
Date=11-08-2013
Maintenance=0
SGN=MCwCFDDNusJoEVUc9F8j3jbCgNofpljwAhQVGwO5WPSaMVLfmtXLIlZxFMJ99w\=\=
-------END-LICENSE-KEY-------
" > ./tools/DITA-OT/plugins/com.oxygenxml.webhelp/licensekey.txt

 echo "END ${FUNCNAME[0]}"
 }



 function oxygen-webhelp-build () {
echo "START ${FUNCNAME[0]} (referenced from functionLibrary.sh)"


#Check to see if a ditamap was passed to the function as argument 1

if [ -z "$1" ]
	then
		# If no map was passed to the function, set the ditamap variable to build to docs.hpcloud.com.ditamap
		DITAMAP_FILE=docs.hpcloud.com.ditamap
	else
		# otherwise set the ditamap variable to the 1st argument passed to the function
		DITAMAP_FILE="$1"
fi

echo "DITAMAP_FILE = $DITAMAP_FILE"

if [ -n "$2" ]
	then
		# If a second argument was passed to the function, set the ditaval path value variable.
		DITAVAL_PATH_FILE="$2"
fi

echo "DITAVAL_PATH_FILE = $DITAVAL_PATH_FILE"
 

rm -r temprm -r out

export XEP_HOME=/usr/local/RenderX/XEP

echo "Setting environment variables…"

# this assumes you've already exported XEP_HOME (if you're using XEP)

# ugly parent directory hacks to avoid breaking other build stuff:
export DITA_HOME="`pwd`/tools/DITA-OT"
export DITAC_HOME="`pwd`/tools/ditac/ditac-2_4_0"
export DOC_HOME="`pwd`"
export PRODUCT_DIR="./products"
export ANT_HOME="$DITA_HOME/tools/ant"
echo DITA_HOME IS $DITA_HOME
echo DOC_HOME is $DOC_HOME
echo PRODUCT_DIR is $PRODUCT_DIR
echo ANT_HOME is $ANT_HOME

CUR_PWD="`pwd`"

# Get the absolute path of DITAOT's home directory
cd "$DITA_HOME"
DITA_DIR="`pwd`"
echo DITA_DIR is $DITA_DIR
cd "$CUR_PWD"

# Make sure ant binary is executable
if [ -f "$DITA_DIR"/tools/ant/bin/ant ] && [ ! -x "$DITA_DIR"/tools/ant/bin/ant ]; then
# echo "*** chmoding ant binary so it's executable ***"
chmod +x "$DITA_DIR"/tools/ant/bin/ant
fi

# Setting ant environment variables 
 
free 
export ANT_OPTS="-Xmx4012m $ANT_OPTS"
export ANT_OPTS="$ANT_OPTS -Djavax.xml.transform.TransformerFactory=net.sf.saxon.TransformerFactoryImpl"
#echo "  DOC VERSION NUMBER: " $DOC_VERSION_NUMBER

#Adding project-specific version of ant to path
export PATH="$DITA_DIR"/tools/ant/bin:"$PATH"


 
NEW_CLASSPATH="$DITA_DIR/lib/dost.jar"
NEW_CLASSPATH="$DITA_DIR/lib:$NEW_CLASSPATH"
NEW_CLASSPATH="$DITA_DIR/lib/commons-codec-1.4.jar:$NEW_CLASSPATH"
NEW_CLASSPATH="$DITA_DIR/lib/resolver.jar:$NEW_CLASSPATH"
NEW_CLASSPATH="$DITA_DIR/lib/icu4j.jar:$NEW_CLASSPATH"
NEW_CLASSPATH="$DITA_DIR/lib/xercesImpl.jar:$NEW_CLASSPATH"
NEW_CLASSPATH="$DITA_DIR/lib/xml-apis.jar:$NEW_CLASSPATH"
NEW_CLASSPATH="$DITA_DIR/lib/saxon/saxon9.jar:$NEW_CLASSPATH"
NEW_CLASSPATH="$DITA_DIR/lib/saxon/saxon9-dom.jar:$NEW_CLASSPATH"
if test -n "$CLASSPATH"; then
  export CLASSPATH="$NEW_CLASSPATH":"$CLASSPATH"
else
  export CLASSPATH="$NEW_CLASSPATH"
fi


#check to see if classpath already exists - if so, append our new values
if test -n "$CLASSPATH"
then
export CLASSPATH="$NEW_CLASSPATH":"$CLASSPATH"
else
export CLASSPATH="$NEW_CLASSPATH"
fi

 


#DITA_HOME="./"

 
#echo $DITA_HOME

# Oxygen Webhelp plugin
# Copyright (c) 1998-2014 Syncro Soft SRL, Romania.  All rights reserved.
# Licensed under the terms stated in the license file EULA_Webhelp.txt 
# available in the base directory of this Oxygen Webhelp plugin.


# The path of the Java Virtual Machine install directory
# JVM_INSTALL_DIR=/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home

# The path of the DITA Open Toolkit install directory
DITA_OT_INSTALL_DIR="./tools/DITA-OT/"

#echo DITA_OT_INSTALL_DIR
#echo $DITA_OT_INSTALL_DIR



# The path of the Saxon 9.1.0.8 install directory  
SAXON_9_DIR=./tools/saxonb9-1-0-8j

# One of the following three values: 
#      webhelp
#      webhelp-feedback
#      webhelp-mobile
TRANSTYPE=webhelp

# The path of the directory of the input DITA map file
# DITA_MAP_BASE_DIR=/home/test/oxygen-webhelp/OxygenXMLEditor/samples/dita/flowers
DITA_MAP_BASE_DIR=`pwd`

#echo DITA_MAP_BASE_DIR
#echo $DITA_MAP_BASE_DIR



# The name of the DITAVAL input filter file 
#DITAVAL_FILE=my_ditaval.ditaval
#DITAVAL_FILE=CG.ditaval

# The path of the directory of the DITAVAL input filter file
#DITAVAL_DIR=/usr/local/OxygenXMLDeveloper16/samples/dita
#DITAVAL_DIR=$DITA_MAP_BASE_DIR

#Build the documentation

"java"\
 -Xmx4512m\
 -classpath\
 "$DITA_OT_INSTALL_DIR/tools/ant/lib/ant-launcher.jar"\
 "-Dant.home=$DITA_OT_INSTALL_DIR/tools/ant" org.apache.tools.ant.launch.Launcher\
 -lib "$DITA_OT_INSTALL_DIR/plugins/com.oxygenxml.webhelp/lib/xercesImpl.jar"\
 -lib "$DITA_OT_INSTALL_DIR/plugins/com.oxygenxml.webhelp/lib/xml-apis.jar"\
 -lib "$DITA_OT_INSTALL_DIR/plugins/com.oxygenxml.webhelp/lib/xml-apis-ext.jar"\
 -lib "$DITA_OT_INSTALL_DIR"\
 -lib "$DITA_OT_INSTALL_DIR/lib"\
 -lib "$SAXON_9_DIR/saxon9.jar"\
 -lib "$SAXON_9_DIR/saxon9-dom.jar"\
 -lib "$DITA_OT_INSTALL_DIR/plugins/com.oxygenxml.webhelp/lib/license.jar"\
 -lib "$DITA_OT_INSTALL_DIR/plugins/com.oxygenxml.webhelp/lib/log4j.jar"\
 -lib "$DITA_OT_INSTALL_DIR/plugins/com.oxygenxml.webhelp/lib/resolver.jar"\
 -lib "$DITA_OT_INSTALL_DIR/plugins/com.oxygenxml.webhelp/lib/ant-contrib-1.0b3.jar"\
 -lib "$DITA_OT_INSTALL_DIR/plugins/com.oxygenxml.webhelp/lib/lucene-analyzers-common-4.0.0.jar"\
 -lib "$DITA_OT_INSTALL_DIR/plugins/com.oxygenxml.webhelp/lib/lucene-core-4.0.0.jar"\
 -lib "$DITA_OT_INSTALL_DIR/plugins/com.oxygenxml.webhelp/lib/xhtml-indexer.jar"\
 -lib "$DITA_OT_INSTALL_DIR/plugins/com.oxygenxml.highlight/lib/xslthl-2.1.0.jar"\
 -lib "$DITA_OT_INSTALL_DIR/plugins/com.oxygenxml.webhelp/lib/webhelpXsltExtensions.jar"\
 -f "$DITA_OT_INSTALL_DIR/build.xml"\
 "-Dtranstype=$TRANSTYPE"\
 "-Dbasedir=$DITA_MAP_BASE_DIR"\
 "-Doutput.dir=$DITA_MAP_BASE_DIR/out/$TRANSTYPE"\
 "-Ddita.temp.dir=$DITA_MAP_BASE_DIR/temp/$TRANSTYPE"\
 "-Dargs.hide.parent.link=no"\
 "-Dargs.filter=$DITAVAL_PATH_FILE"\
 "-Ddita.input.valfile=$DITAVAL_PATH_FILE"\
 "-Ddita.dir=$DITA_OT_INSTALL_DIR"\
 "-Dargs.xhtml.classattr=yes"\
 "-Dargs.input=$DITA_MAP_BASE_DIR/$DITAMAP_FILE"\
 "-DbaseJVMArgLine=-Xmx384m"
 
 
cp ./tools/DITA-OT/plugins/com.oxygenxml.webhelp/oxygen-webhelp/resources/css/Metric* ./out/webhelp/oxygen-webhelp/resources/css/

 echo "END ${FUNCNAME[0]}"
 }


function build.on.push () {
echo "START ${FUNCNAME[0]} (referenced from functionLibrary.sh)"

DITAVAL_PATH_FILE=$1

echo "2 XXX DITAVAL = $DITAVAL_PATH_FILE"


#Set the HipChat rooms to notify in case of a pass or fail of this build
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


#Get repo name from the jenkins env variable $GIT_URL
REPO=`echo "$GIT_URL" | sed 's|.*/||g' | sed 's|\.git$||g'`

 
#Get the tools repo 
get_the_tools_repo


echo "Building HTML docs:"
 
 
 #Get some information about the push to use later, 
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
license


#Build the build.on.push ditamap

echo "XXX passing DITAVAL oxygen-webhelp-build build.on.push.ditamap $DITAVAL_PATH_FILE " 
oxygen-webhelp-build build.on.push.ditamap $DITAVAL_PATH_FILE


#Insert the  disclaimer snippet, if there is one.
insert_disclaimer


#Insert any redirects
inject_redirects


#Inject the date and time
inject_date -time

find ./out/webhelp/ -name "*.html" -exec sed -i  s'|\(<p class="footer">The OpenStack[^<]*\)</p>||' {} \;

#Write files that document the URL of this build and who pushed it (used in index.html)
echo "$BUILD_URL" >  ./out/webhelp/buildURL.txt
echo "$PUSHED_BY" | sed  's/^\(.\)/\U\1/' >  ./out/webhelp/pushedBY.txt


sudo cp /var/lib/jenkins/HPE-Helion.png ./out/webhelp/

 echo "END ${FUNCNAME[0]} "
 } 

function production_build () {
echo "START ${FUNCNAME[0]} (referenced from functionLibrary.sh)"

 	#NOTE: Call assemble-repos before running

	#remove old output files
	rm -r ./out/ || true

 
	license
 
	oxygen-webhelp-build docs.hpcloud.com.ditamap	$i
	./tools/jenkins/inject_google_analytics.sh ./out/webhelp/
	inject_redirects
	inject_date -file

	cp -r ./commercial/GA1/RollYourOwn11/  out/webhelp/commercial/GA1/RollYourOwn11/
	cp -r ./commercial/GA1/RollYourOwn10/  out/webhelp/commercial/GA1/RollYourOwn10/
	cp -r ./media/ ./out/webhelp/
	cp -r ./hdp-html/ ./out/webhelp/
	cp -r ./hcf/media ./out/webhelp/hcf/media
	cp -r ./3.x/media ./out/webhelp/3.x/media
	cp -r ./file/  out/webhelp/file/
	cp -r ./ServerArtifacts/404.html  out/webhelp/404.html
	cp -r ./ServerArtifacts/htaccess.with.rewrite.rules  out/webhelp/.htaccess

 echo "END ${FUNCNAME[0]}"
 }
 
 
 
 
 function new_production_build () {
echo "START ${FUNCNAME[0]} (referenced from functionLibrary.sh)"



 	#NOTE: Call assemble-repos before running

	#remove old output files
	rm -r ./out/ || true

	echo "DITAVAL = $1"
 
	license
 
	oxygen-webhelp-build $1	$2
	./tools/jenkins/inject_google_analytics.sh ./out/webhelp/
	inject_redirects
	inject_date -file

	cp -r ./commercial/GA1/RollYourOwn11/  out/webhelp/commercial/GA1/RollYourOwn11/
	cp -r ./commercial/GA1/RollYourOwn10/  out/webhelp/commercial/GA1/RollYourOwn10/
	cp -r ./media/ ./out/webhelp/
	cp -r ./hdp-html/ ./out/webhelp/
	cp -r ./hcf/media ./out/webhelp/hcf/media
	cp -r ./3.x/media ./out/webhelp/3.x/media
	cp -r ./file/  out/webhelp/file/
	cp -r ./ServerArtifacts/404.html  out/webhelp/404.html
	cp -r ./ServerArtifacts/htaccess.with.rewrite.rules  out/webhelp/.htaccess

 echo "END ${FUNCNAME[0]}"
 }
 
 

 function pull_repo () {
	repo=$1
 
	if [[ ! -d "$repo" ]]; then
		echo "$repo does not exist.  Cloning..."
 		git clone git@github.com:hphelion/$repo.git
	else
		echo "$repo exists."
	fi
	 
	cd $repo

	git fetch --all

	for branch in `git branch -r | sed 's|.*/||'`
	do
		git checkout $branch
		git reset --hard origin/$branch
	done
    
	cd -
	
 }

 
 function copy_to_staging () {
 echo "START ${FUNCNAME[0]} (referenced from functionLibrary.sh)" 
	 REPO=$1
	 BRANCH=$2
	 DITAVALFILE=$3
	 
	 echo "REPO=$REPO"
	 echo "BRANCH=$BRANCH"
	 echo "DITAVALFILE=$DITAVALFILE"
	 
# Check to see if a ditaval file was passed to the function 	 
if [ -z "$DITAVALFILE" ]; then 
	DITAVALFILE="" 
	echo "DITAVALFILE not found"
else 
	temp="$DITAVALFILE"
	DITAVALFILE="-${temp}" 
	echo "changed DITAVALFILE to $DITAVALFILE "

fi	 
	 

	 

	
echo "DITAVALFILE=$DITAVALFILE"
	#Create a folder on the server for this build
	sudo mkdir /var/www/html/${REPO}-${BRANCH}${DITAVALFILE}/


	#Copy the helpset to the server
    echo "5 XXX copy to /var/www/html/${REPO}-${BRANCH}${DITAVALFILE}/" 
	sudo rsync -r --partial --delete --ignore-times   ./out/webhelp/  /var/www/html/${REPO}-${BRANCH}${DITAVALFILE}/
 
 
	#Notify HipChat that the build completed (if the build fails, the job configuration notifies of failure)
	hipChat PASS "Build $BUILD_NUMBER on <b>$GIT_BRANCH</b>:  $STATUS (View the <a href='${BUILD_URL}console'>build log</a> or the <a href='http://173.205.188.46/hos.docs-${GIT_BRANCH}'>current build</a> of this branch.)"  $HIPCHAT_PASS


echo "# Saving some version properties
BUILD_TO_CHECK=/var/www/html/${REPO}-${BRANCH}${DITAVALFILE}/
" > /var/lib/jenkins/workspace/BuildVersion.properties

 
  echo "END ${FUNCNAME[0]}"
 }