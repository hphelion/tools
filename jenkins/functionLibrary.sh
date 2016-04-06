JENKINS_NAME="docs-staging.hpcloud.com"
DOC_SITE_NAME="docs.hpcloud.com"
PRIMARY_WAN_IP="173.205.188.47"
PRIMARY_LAN_IP="192.168.251.121"
TEST_WAN_IP="173.205.188.46"
TEST_LAN_IP="192.168.251.17"
TEST_DOC_SITE_NAME="docs-staging.hpcloud.com:9099"



hipChat () {  
#Usage: hipChat (PASS|FAIL) "MESSAGE" ROOM


#Set the URL to the console output for this build
CONSOLE=${BUILD_URL}console




if [[ $1 == "FAIL" ]]
then
	COLOR="red"
	MESSAGE="<b>$JOB_NAME</b> $2 "
 
else
	COLOR="green"
        MESSAGE="<b>$JOB_NAME</b> $2 " 
fi

echo $COLOR
echo $MESSAGE
 


#Set HipChat authorization and room     
auth="zKuxF5Bt5H9dpNysOSf8nRPw2GbT41f3vAS5jKSI"

for i in `echo $3 |sed 's| |\n|g' `
do


room="$i"

#amok 145
#test 845



  
echo $CONSOLE
 
#Send notification to hipchat
 
curl \
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
