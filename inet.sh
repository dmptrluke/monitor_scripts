#!/usr/local/bin/bash

PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:/root/bin

source /tmp/inet

# get current in/out octets
in=`snmpget -Ov -v 2c -c public 192.168.1.1 IF-MIB::ifInOctets.7`
out=`snmpget -Ov -v 2c -c public 192.168.1.1 IF-MIB::ifOutOctets.7`

# strip crap
in=$(echo $inetin | cut -c 12-)
out=$(echo $inetout | cut -c 12-)

#Get the difference between the old and current
diffin=$((in - oldin))
diffout=$((out - oldout))
	
#Calculate the bytes-per-second
bpsin=$((diffin / sleeptime))
bpsout=$((diffout / sleeptime))

if [[ $inbps -lt 0 || $outbps -lt 0 || $kidsinbps -lt 0 || $kidsoutbps -lt 0 ]] 
then

else
	curl -i -u monitor:43nu889Q3ypeuRJh6qT4 -XPOST 'http://localhost:8086/write?db=monitor' --data-binary "traffic,port=inet rx=${inetin}i,tx=${inetout}i"
fi


oldin=$in
oldout=$out

for var in oldin oldout; do
    declare -p $var | cut -d ' ' -f 3- >> /tmp/inet
done