#!/bin/bash

source /var/uncgi/conf.ini

DATE=`date +'%H:%M'`

$SQLITE $DB "insert into time (date,pin,act,status) values ('$DATE','0',2,0);"

printf '\n'

echo "<html><head><meta http-equiv=\"refresh\" content=\"1;url=scheduller.sh\"></head><body><h1>Inserting...</h1></body></html>"