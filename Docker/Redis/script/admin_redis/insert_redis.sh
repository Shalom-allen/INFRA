#!/bin/bash
# --------------------------------------------------------------
#       Docker & Redis Control
#                                        Ver. 1.0
#
#                                        Date 2021-11-09
#                                Create by Yoo Min Sang
#
#
#
# --------------------------------------------------------------

StartTime=`date +"%Y-%m-%d %H:%M:%S"`

for i in {1..2975} ;
do
        echo "set $i $i" >> result.txt
done

EndTime=`date +"%Y-%m-%d %H:%M:%S"`

echo "StartTime : ${StartTime}" >> time.log
echo "EndTime : ${EndTime}" >> time.log
