#!/bin/bash

source /var/uncgi/conf.ini

_GPIO() {
    $GPIO mode $1 out
    $GPIO write $1 $2
}

$SQLITE -separator " " $DB "select * from start;" | while read LINE; do
    read PIN ACT <<< "$LINE"
    if [ "$PIN" == "7" ]; then
        exit 0
    fi
    _GPIO $PIN $ACT
done
