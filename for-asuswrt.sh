#!/bin/sh

#API Key
api_key=""
 
#Secret Key
secret_key=""
 
#Domain name
domain=""

url="https://www.cloudxns.net/api2/ddns"
time=$(date -R)
data="{\"domain\":\"${domain}\",\"ip\":\"${1}\",\"line_id\":\"1\"}"
mac_raw="$api_key$url$data$time$secret_key"
mac=$(echo -n $mac_raw | md5sum | awk '{print $1}')
header1="API-KEY:"$api_key
header2="API-REQUEST-DATE:"$time
header3="API-HMAC:"$mac
header4="API-FORMAT:json"

result=$(curl -k -X POST -H $header1 -H "$header2" -H $header3 -H $header4 -d "$data" $url)
if  [[ $(echo $result | grep "success") != "" ]] ;then
	/sbin/ddns_custom_updated 1
else
	/sbin/ddns_custom_updated 0
fi
