

#Set some global variables
JENKINS_NAME="docs-staging.hpcloud.com"
DOC_SITE_NAME="docs.hpcloud.com"
PRIMARY_WAN_IP="173.205.188.47"		#External IP address for docs.hpcloud.com
PRIMARY_LAN_IP="192.168.251.121"	#Internal IP address for docs.hpcloud.com
TEST_WAN_IP="173.205.188.46" 		#External IP address for docs-staging.hpcloud.com
TEST_LAN_IP="192.168.251.17" 		#Internal IP address for docs-staging.hpcloud.com
#TEST_DOC_SITE_NAME="docs-staging.hpcloud.com:9099"


 


get_the_tools_repo () {
	if [[ -z "$1"   ]];
	then 
		branch="master"
	else
		branch=$1
	fi
	echo ">>> Cloning $branch branch of tools repo"
    rm -r tools
	if ! git clone -b $1   --depth 1  --local   /var/lib/jenkins/workspace/ADMIN--pull-all-repos/cannonical/tools
	then
		echo >&2 Cloning git@github.com:hphelion/tools.git failed.  Stopping the build.
		exit 1
	fi
	chmod 755 ./tools/jenkins/*.sh
}
 


function adjust_date_to_last_commit {
    cd $repo  
    for t in $(find . -name "*.dita");
    do
    	echo $repo : $t
        stat --format=%y $t
    	git log -1 --date=iso --pretty=format:%ad $t | sed 's| +.*||'
        echo""
    	touch -d "`git log -1 --date=iso --pretty=format:%ad $t | sed 's| +.*||'` " $t
        stat --format=%y $t
        echo""
	done
    cd -    
}
 
 function clone_repo {
	#Clone the repo from the cannonical copy and set the branch
	repo=$1
	branch=$2
	echo "clone $repo"
 	if [[ $(git ls-remote /var/lib/jenkins/workspace/ADMIN--pull-all-repos/cannonical/${repo} ${branch} ) ]]; 
	then
		echo "Branch $branch exists on github"
	
		rm -r $repo
			if ! git clone --local --branch ${branch} /var/lib/jenkins/workspace/ADMIN--pull-all-repos/cannonical/$repo ${repo}
			then
				echo >&2 Cloning /var/lib/jenkins/workspace/ADMIN--pull-all-repos/cannonical/$repo failed.  Stopping the build.
				hipChat FAIL "Cloning the <b>$repo repo failed.</b> Stopping the build.  No published files were not changed." $HIPCHAT_ROOM
				exit 1;
			fi
	
	else
		echo "Branch $branch does not exist on github.  Stopping the build."
		hipChat FAIL "Branch <b>$branch</b> does not exist on in the $repo on github. Stopping the build. No published files were not changed." $HIPCHAT_ROOM
		exit 1;
	fi	
}

 

extractBranch () {
	#Extract the branch from the a string taken from $HUDSON_HOME/doc-build-resources/repos+branches.txt
	echo "$1" | sed 's|\([^ ]*\).*$|\1|'
}


extractRepo () {
	#Extract the repo from the a string taken from $HUDSON_HOME/doc-build-resources/repos+branches.txt
	echo "$1" | sed 's|.*of the \([^ ]*\) repo)|\1|'
}



hipChat () {  
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
