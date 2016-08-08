#/bin/bash

IP_LIST=$1
COMMAND=$2
while read line
do
	ADDR=`echo $line | awk {'print $1'}`
	USER=`echo $line | awk {'print $2'}`
	PASS=`echo $line | awk {'print $3'}`
	./cmd.exp ${ADDR} ${USER} ${PASS} "${COMMAND}"  
done < ${IP_LIST} 

wait
