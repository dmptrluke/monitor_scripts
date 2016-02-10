#!/usr/local/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:/root/bin

host="8.8.8.8"
number="10"
wait="1"

#Lets ping the host!
results=$(ping -c $number -i $wait -q $host)

#We need to get ONLY lines 4 and 5 from the results
#The rest isn't needed for ourpurposes
counter=0
while read -r line; do
		((counter++))
		if [ $counter = 4 ]
		then
				line4="$line"
		fi
		if [ $counter = 5 ]
		then
				line5="$line"
		fi
done <<< "$results"

echo "$line4"
echo "$line5"

#Parse out the 2 lines
#First we need to get the packet loss
IFS=',' read -ra arrline4 <<< "$line4" #Split the line based on a ,
loss=${arrline4[2]} #Get just the 3rd element containing the loss
IFS='%' read -ra lossnumber <<< "$loss" #Split the thrid element based on a %
lossnumber=$(echo $lossnumber | xargs) #Remove the leading whitespace

#Now lets get the min/avg/max/mdev
IFS=' = ' read -ra arrline5 <<< "$line5" #Split the lines based on a =
numbers=${arrline5[2]} #Get the right side containing the actual numbers
IFS='/' read -ra numbersarray <<< "$numbers" #Break out all the numbers based on a /
#Get the individual values from the array
min=${numbersarray[0]}
avg=${numbersarray[1]}
max=${numbersarray[2]}
mdev=${numbersarray[3]}

#Write the data to the database
curl -i -u monitor:43nu889Q3ypeuRJh6qT4 -XPOST 'http://localhost:8086/write?db=monitor' --data-binary "ping,host=8.8.8.8,measurement=loss value=$lossnumber ping,host=8.8.8.8,measurement=min value=$min ping,host=8.8.8.8,measurement=avg value=$avg ping,host=8.8.8.8,measurement=max value=$max"