#!/bin/bash

source /var/uncgi/conf.ini

_CHECK() {
cat << EOF
`env | grep WWW_check | sed 's/[a-zA-Z]//g' | cut -c 2-999 | sort`
EOF
}

_RADIO() {
cat << EOF
`env | grep WWW_radio | sed 's/[a-zA-Z]//g' | cut -c 2-999 | sort`
EOF
}

_UPDATE() {
echo "$2 `rev <<< $1 | tr '#' ','` $3 $4"
}

_HOUR() {
cat << EOF
`env | grep WWW_sethour | sed 's/[a-zA-Z]//g' | cut -c 2-999 | sort`
EOF
}

_MINUTE() {
cat << EOF
`env | grep WWW_setminute | sed 's/[a-zA-Z]//g' | cut -c 2-999 | sort`
EOF
}

_DELETE() {
cat << EOF
`env | grep WWW_delete | sed 's/[a-zA-Z]//g' | cut -d'=' -f1 | cut -c 2-999 | sort`
EOF
}


#
#####################################################################################
#


paste <(_RADIO) <(_CHECK) | while read LINE; do
    read RADIO CHECK <<< $LINE
    read KEY ACT PIN <<< $(_UPDATE "`echo $CHECK | cut -d'=' -f2`" "`echo $CHECK | cut -d'=' -f1` `echo $RADIO | cut -d'=' -f2`")
    $SQLITE $DB "update time set act=$ACT,pin='$PIN' where key=$KEY;"
done

paste <(_HOUR) <(_MINUTE) | while read LINE; do
    read HOURS MINUTES <<< "$LINE"
    read KEY HOUR MINUTE <<< $(echo "`echo $HOURS | cut -d'=' -f1` `echo $HOURS | cut -d'=' -f2` `echo $MINUTES | cut -d'=' -f2`")
    $SQLITE $DB "update time set date='$HOUR:$MINUTE' where key=$KEY;"
done

read LIST <<< `_DELETE | tr '\n' ' '`

#
#####################################################################################
#

printf '\n'

if [ "$LIST" != "" ]; then
    for LINE in `echo $LIST`; do
        $SQLITE $DB "delete from time where key=$LINE;"
    done
fi

echo "<html><head><meta http-equiv=\"refresh\" content=\"1;url=scheduller.sh\"></head><body><h1>Processing...</h1></body></html>"

