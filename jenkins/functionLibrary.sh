

#Set some global variables
JENKINS_NAME="docs-staging.hpcloud.com"
DOC_SITE_NAME="docs.hpcloud.com"
PRIMARY_WAN_IP="173.205.188.47"		#External IP address for docs.hpcloud.com
PRIMARY_LAN_IP="192.168.251.121"	#Internal IP address for docs.hpcloud.com
TEST_WAN_IP="173.205.188.46" 		#External IP address for docs-staging.hpcloud.com
TEST_LAN_IP="192.168.251.17" 		#Internal IP address for docs-staging.hpcloud.com
#TEST_DOC_SITE_NAME="docs-staging.hpcloud.com:9099"
#TEST_DOC_SITE_NAME="docs-staging.hpcloud.com:9099"


 


get_the_tools_repo () {
    echo ">>> Start function \"get_the_tools_repo\""
	
	#If no argument was passed to the function, use the master branch.  Otherwise use the argument as the branch
	if [[ -z "$1"   ]];
	then 
		branch="master"
	else
		branch=$1
	fi
	echo ">>> Cloning $branch branch of tools repo"
	
	#The tools repo should not be there already, but try to remove it--just in case
    rm -r tools || true
	
	#Do a single-branch, shallow clone of the tools repo from /var/lib/jenkins/workspace/ADMIN--pull-all-repos/canonical/tools
	#If anything goes wrong, stop the build.
	if !  git clone --local -b $branch --single-branch --depth 1 /var/lib/jenkins/workspace/ADMIN--pull-all-repos/canonical/tools
	then
		echo >&2 Cloning git@github.com:hphelion/tools.git failed.  Stopping the build.
		exit 1
	fi
	
	#Make sure that the scripts in the jenkins folder are executable
	chmod 755 ./tools/jenkins/*.sh
	
	echo ">>> Finish function \"get_the_tools_repo\""
}
 


function adjust_date_to_last_commit {
    echo ">>> Start function \"adjust_date_to_last_commit\""
	#Note that this only works on a complete repo.  A shallow clone does not have all the needed info.
	
	#cd into the repo
    cd $repo  
	
    #for each dita file, 
	for t in $(find . -name "*.dita");
    do
    	echo $repo : $t
        stat --format=%y $t
		
		#get the date of the last commit of the file
    	git log -1 --date=iso --pretty=format:%ad $t | sed 's| +.*||'
        echo""
		
		#Change the modification date of the ditafile so that it is equal to the date of the last commit
    	touch -d "`git log -1 --date=iso --pretty=format:%ad $t | sed 's| +.*||'` " $t
        stat --format=%y $t
        echo""
	done
	
	#Return to the original directory
    cd -    
	    echo ">>> Finish function \"adjust_date_to_last_commit\""
}
 
 function clone_repo {
    echo ">>> Start function \"clone_repo\""
	#Set branch and repo variables from the function's arguments
	repo=$1
	branch=$2
	echo "clone $repo"
	
	#Check to make sure that the branch exists
 	if [[ $(git ls-remote /var/lib/jenkins/workspace/ADMIN--pull-all-repos/canonical/${repo} ${branch} ) ]]; 
	then
		echo "Branch $branch exists"
		
		#If the branch exists, remove any old copy of the repo
		rm -r $repo || true
		
			#Clone the repo from /var/lib/jenkins/workspace/ADMIN--pull-all-repos/canonical/, notify hipchat if the pull fails
			if ! git clone --local --branch ${branch} /var/lib/jenkins/workspace/ADMIN--pull-all-repos/canonical/$repo ${repo}
			then
				echo >&2 Cloning /var/lib/jenkins/workspace/ADMIN--pull-all-repos/canonical/$repo failed.  Stopping the build.
				hipChat FAIL "Cloning the <b>$repo repo failed.</b> Stopping the build.  No published files were not changed." $HIPCHAT_ROOM
				exit 1;
			fi
	
	else
		#If the branch does not exist, notify HipChat and exit.
		echo "Branch $branch does not exist.  Stopping the build."
		hipChat FAIL "Branch <b>$branch</b> does not exist on in the $repo. Stopping the build. No published files were not changed." $HIPCHAT_ROOM
		exit 1;
	fi	
	 echo ">>> Finish function \"clone_repo\""
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

echo $COLOR
echo $MESSAGE
 
#Set HipChat authorization and room     
auth="U9LoIThHLKGGL49vLtiUJWinLHXJepo9zJVXbmCc"
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
}



function build.on.push () {
echo ">>> Start function \"build.on.push\""

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
./tools/jenkins/license.sh


#Build the build.on.push ditamap
./tools/jenkins/oxygen-webhelp-build.sh build.on.push.ditamap


#Insert the  disclaimer snippet, if there is one.
./tools/jenkins/insert_disclaimer.sh


#Insert any redirects
./tools/jenkins/inject_redirects.sh


#Inject the date and time
inject_date -time

find ./out/webhelp/ -name "*.html" -exec sed -i  s'|\(<p class="footer">The OpenStack[^<]*\)</p>||' {} \;

#Write files that document the URL of this build and who pushed it (used in index.html)
echo "$BUILD_URL" >  ./out/webhelp/buildURL.txt
echo "$PUSHED_BY" | sed  's/^\(.\)/\U\1/' >  ./out/webhelp/pushedBY.txt


sudo cp /var/lib/jenkins/HPE-Helion.png ./out/webhelp/

echo ">>> Finish function \"build.on.push\""

}



 


assemble_repos () {
 

#Set the variable to whatever was passed to this script.
HIPCHAT_ROOM="$1"

#Set the variables that define the publish branch for all repos
source ./tools/jenkins/publish-config.sh
 
#write publish branch variables to stdout so we know what is going on 
echo "

#################################################################

      devplat_docs_BRANCH = $devplat_docs_BRANCH
          hos_docs_BRANCH = $hos_docs_BRANCH
          hos_docs_LEGACYBRANCH = $hos_docs_LEGACYBRANCH
carrier_grade_docs_BRANCH = $carrier_grade_docs_BRANCH
 public_cloud_docs_BRANCH = $public_cloud_docs_BRANCH
          hcf_docs_BRANCH = $hcf_docs_BRANCH

#################################################################
"

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

}




function production_build () {
	#NOTE: Call assemble-repos.sh before running
 
	echo "Building HTML docs:"
 

	#remove old output files
	rm -r ./out/ || true

 
	./tools/jenkins/license.sh
 
	./tools/jenkins/oxygen-webhelp-build.sh docs.hpcloud.com.ditamap	
	./tools/jenkins/inject_google_analytics.sh ./out/webhelp/
	./tools/jenkins/inject_redirects.sh
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


}

function inject_date () {
	echo ===start inject_date===
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
	echo ===end inject_date===


}


function inject_disclaimer () {

	echo ===start inject_disclaimer===
	DISCLAIMER=`cat disclaimer_snippet` || true

	for i in `find ./out/webhelp -name "*.html"`
	do
		echo "inject disclaimer into $i"
		sed -i "s|\([^>]\)</h1>|\1</h1> $DISCLAIMER|g" $i
	done

echo ===stop inject_disclaimer===

}


function inject_redirects () {
	echo ===start inject_redirects===

	grep -v "^#" ./tools/jenkins/inter-helpset-redirects.txt > inter-helpset-redirects.tmp 
  
	while read -r FROM TO; do
		REDIRECT="if (dynamicURL == '$FROM') {window.location.href = '#$TO';} else"
		sed -i "s|function loadIframe(dynamicURL) {|function loadIframe(dynamicURL) { $REDIRECT |"  ./out/webhelp/oxygen-webhelp/resources/skins/desktop/toc_driver.js
	done < inter-helpset-redirects.tmp 

	echo ===end inject_redirects===
}




function license () {
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
}