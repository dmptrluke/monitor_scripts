#!/usr/local/bin/bash

PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:/root/bin


while :
do
    sleep 30
	# get in/out octets
	inetin=`snmpget -Ov -v 2c -c public 192.168.1.1 IF-MIB::ifInOctets.4`
	inetout=`snmpget -Ov -v 2c -c public 192.168.1.1 IF-MIB::ifOutOctets.4`

	# strip crap
	inetin=$(echo $inetin | cut -c 12-)
	inetout=$(echo $inetout | cut -c 12-)

	curl -i -u monitor:43nu889Q3ypeuRJh6qT4 -XPOST 'http://localhost:8086/write?db=monitor' --data-binary "traffic,port=inet rx=${inetin}i,tx=${inetout}i"
done