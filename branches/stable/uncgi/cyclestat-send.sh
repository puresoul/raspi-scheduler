#!/bin/bash

source /var/uncgi/conf.ini

_ACT() {
echo `env | grep $1 | sed 's/[a-zA-Z]//g' | cut -c 2-999 | sort`
}

ARRKEY=`_ACT "WWW" | tr ' ' '\n' | cut -d= -f1 | tail -n1`

KEY=`echo $(( $ARRKEY - 1 ))`

MAX=(`_ACT "WWW_max"`)
MIN=(`_ACT "WWW_min"`)

MAXACT=(`_ACT "WWW_maact"`)
MINACT=(`_ACT "WWW_miact"`)

PIN=(`_ACT "WWW_pin"`)


printf '\n'

echo "<body><h1>Processing...</h1>"

for VAL in `seq 0 $KEY`; do
    read MA MI MAACT MIACT PI <<< `printf "${MAX[$VAL]}\n${MIN[$VAL]}\n${MAXACT[$VAL]}\n${MINACT[$VAL]}\n${PIN[$VAL]\n}" | cut -d= -f2`
#    echo "$MA $MI $MAACT $MIACT ."
    $SQLITE $DB "update func set max = $MA,min = $MI,maxact = $MAACT,minact = $MIACT,pin = $PI where key = `echo $(( $VAL + 1))`;"
done


echo "<head><meta http-equiv=\"refresh\" content=\"1;url=cyclestat.sh\"></head>"


echo "</body>"
