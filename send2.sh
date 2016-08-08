#/bin/bash

FILE_LIST=$1
PROXY=$2
IP_LIST=$3
BASE_DIR=$4

if [ ${BASE_DIR} = "" ];then
    BASE_DIR=/var/www/
fi

SEND_TMP_FILE=send_tmp.tar.gz
SEND_TMP_DIR=/tmp/
CUR_DIR=`pwd`

echo "对文件列表压缩打包"
cd ${BASE_DIR}
cat ${CUR_DIR}/${FILE_LIST} | xargs tar -cvzf ${SEND_TMP_DIR}${SEND_TMP_FILE}
cd ${CUR_DIR}

echo "发送到中转机器临时目录"
PROXY_ADDR=`cat ${PROXY} | awk {'print $1'}`
PROXY_USER=`cat ${PROXY} | awk {'print $2'}`
PROXY_PASS=`cat ${PROXY} | awk {'print $3'}`
./send.exp ${PROXY_ADDR} ${PROXY_USER} ${PROXY_PASS} ${SEND_TMP_DIR}${SEND_TMP_FILE} ${SEND_TMP_DIR}

echo "从中转机器发送"
while read line
do
    ADDR=`echo $line | awk {'print $1'}`
    USER=`echo $line | awk {'print $2'}`
    PASS=`echo $line | awk {'print $3'}`
    ./cmd.exp ${PROXY_ADDR} ${PROXY_USER} ${PROXY_PASS} "send.exp ${ADDR} ${USER} ${PASS} ${SEND_TMP_DIR}${SEND_TMP_FILE} ${SEND_TMP_DIR};cmd.exp ${ADDR} ${USER} ${PASS} \"tar -xzf ${SEND_TMP_DIR}${SEND_TMP_FILE} -C ${BASE_DIR}\""
done < ${IP_LIST}
