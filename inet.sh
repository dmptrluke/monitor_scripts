#!/usr/local/bin/bash

PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:/root/bin

#store the start timestamp
timestamp=$(date +%s)

touch /tmp/inet
source /tmp/inet

# get current in/out octets
in=`snmpget -Ov -v 2c -c public 192.168.1.1 IF-MIB::ifInOctets.7`
out=`snmpget -Ov -v 2c -c public 192.168.1.1 IF-MIB::ifOutOctets.7`

# strip crap
in=$(echo $in | cut -c 12-)
out=$(echo $out | cut -c 12-)

# check if we have an old value. if not, we skip all this and wait for the next loop
if [ -v oldin ]
then
	#Get the difference between the old and current
	diffin=$((in - oldin))
	diffout=$((out - oldout))
		
	#Calculate the bytes-per-second
	bpsin=$((diffin / 60))
	bpsout=$((diffout / 60))

	if [[ $bpsin -lt 0 || $bpsout -lt 0 ]] 
	then
		# get current in/out octets
		in=`snmpget -Ov -v 2c -c public 192.168.1.1 IF-MIB::ifInOctets.7`
		out=`snmpget -Ov -v 2c -c public 192.168.1.1 IF-MIB::ifOutOctets.7`

		# strip crap
		in=$(echo $in | cut -c 12-)
		out=$(echo $out | cut -c 12-)
	else
		curl -i -u monitor:43nu889Q3ypeuRJh6qT4 -XPOST 'http://localhost:8086/write?db=monitor&precision=s' --data-binary "traffic,port=inet rx=${bpsin},tx=${bpsout} $timestamp"
	fi
fi

echo 'oldin="'"$in"'"' > /tmp/inet
echo 'oldout="'"$out"'"' >> /tmp/inet
