JENKINS_NAME="docs-staging.hpcloud.com"
DOC_SITE_NAME="docs.hpcloud.com"
PRIMARY_WAN_IP="173.205.188.47"
PRIMARY_LAN_IP="192.168.251.121"
TEST_WAN_IP="173.205.188.46"
TEST_LAN_IP="192.168.251.17"
TEST_DOC_SITE_NAME="docs-staging.hpcloud.com:9099"





extractBranch ($REPO_BRANCH_VARIABLE) {

BRANCH=`echo "$REPO_BRANCH_VARIABLE" | sed 's| .*||g' | grep -v $REPO`
return $BRANCH

}


extractRepo ($REPO_BRANCH_VARIABLE) {

REPO=`echo "$REPO_BRANCH_VARIABLE" | sed 's|.*of the \([^ ]*\) repo)|\1|g'`
return $REPO

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
