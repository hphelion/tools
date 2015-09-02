!#/bin/sh
#Send notification to hipchat

COLOR=$1 #valid values are red, green, or yellow
ROOM=$2
MESSAGE=$3
EXIT=$4 #valid values are 1 or 0

 
curl \
	--header "Authorization: Bearer zKuxF5Bt5H9dpNysOSf8nRPw2GbT41f3vAS5jKSI" \
	--header "Content-Type: application/json" \
	--request 'POST' \
	--data @- \
	https://hipchat.hpcloud.net/v2/room/${ROOM}/notification <<EOP
{
	"color":"$COLOR",
	"notify":false,
	"message":"$MESSAGE",
	"message_format":"html"
}
EOP

         exit "$EXIT"
