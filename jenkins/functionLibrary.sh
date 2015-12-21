hipChat () {  
#Usage: hipChat (PASS|FAIL) "MESSAGE"


#Set the URL to the console output for this build
CONSOLE=${BUILD_URL}console




if [[ $1 == "FAIL" ]]
then
	COLOR="red"
	MESSAGE="<b>$JOB_NAME</b> $2 See the <a href=\\\"$CONSOLE\\\">console output</a> for details."
 
else
	COLOR="green"
	MESSAGE="$2"
 
fi

echo $COLOR
echo $MESSAGE
 


#Set HipChat authorization and room     
auth="zKuxF5Bt5H9dpNysOSf8nRPw2GbT41f3vAS5jKSI"
room="845"  

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
		 
}
