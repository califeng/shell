#!/bin/bash
######### 必写内容 start #####################
date=`date  +%Y%m%d%H%M`
log="../log/$0.log"
smslog="../log/$0.sms.log"
######### 必写内容 end  #####################
wlan=`/sbin/ifconfig eth1|grep 'inet addr'|awk '{print $2}'|awk -F: '{print $2}'`
threshold=60

tmpfile="/tmp/.diskutil"
/bin/df -h >$tmpfile

result=`cat $tmpfile|head -n 1 `"\n"
while read line
do
    n=`echo $line|awk '{print $(NF-1)}'|sed 's/%//'`
    if echo $n|grep -q [a-z]; then
       continue
    fi
    if [ "${n}" -ge "${threshold}" ]; then
          result="${result}${line}\n"
    fi
done <$tmpfile

#echo -e $result >/tmp/.diskutilwc
#lineresult=`wc -l /tmp/.diskutilwc|awk '{print $1}'`
lineresult=`echo -e $result|wc -l |awk '{print $1}'`

if [ "$lineresult" -ge "3" ];then
  echo -e $result|grep -v "^$" >${log}
  echo -e "$wlan\n $result"|grep -viE "Filesystem|^$" >${smslog}
fi