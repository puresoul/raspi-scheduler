#!/bin/bash

source /var/uncgi/conf.ini

_GPIO() {
if [[ "$1" != "" && "$2" != "" ]]; then
    $GPIO mode $1 out
    $GPIO write $1 $2
fi
}

_READ() {
    $GPIO read $1
}

read PIN ACT <<< `echo $WWW_button | tr ',' ' '`

_GPIO "$PIN" "$ACT"

printf '\n'

if [ "$WWW_web" == "1" ]; then
    echo '<html>'
    echo "<head><meta http-equiv=\"refresh\" content=\"0.001;url=control.sh\"></head>"
    echo '</html>'
    exit 0
fi

if [ "$WWW_read" != "" ]; then
    echo '<html>'
    read READ <<< `_READ "$WWW_read"`
    echo "<pre>$READ</pre>"
    echo '</html>'
fi

if [ "$WWW_xml" == "1" ]; then
    printf "<?xml version=\"1.0\"?>\n<PIN>\n"
    for VAR in {0..6}; do
        printf "<NUM$VAR>`gpio read $VAR;`</NUM$VAR>\n"
    done
    printf "</PIN>\n"
    exit 0
fi

if [ "$WWW_time" == "1" ]; then
    printf "<?xml version=\"1.0\"?>\n"
    $SQLITE -separator " " $DB "select date,pin,act from time;" | tr ',' '|' | tr ' ' ',' | csv2 | 2xml
    exit 0
fi

if [ "$WWW_sensor" == "1" ]; then

    _SQL() {
    $SQLITE $DB "select value from $1 order by key desc limit 0,1;"
    }

    printf "<?xml version=\"1.0\"?>\n<sensor>\n"
    for VAR in temp hum temp_new hum_new; do
        printf "<$VAR>`_SQL $VAR`</$VAR>\n"
    done
    printf "</sensor>\n"
    exit 0
fi



