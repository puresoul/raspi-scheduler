#!/bin/bash

source /var/uncgi/conf.ini

ARG=`date +'%H:%M %F'`


_GPIO() {
if [ "$ACT" != "2" ]; then
    $GPIO mode $1 out
    $GPIO write $1 $ACT
fi
}

_TIME() {
echo $1 | sed 's/://g'
}

_DATE() {
echo $1 | sed 's/-//g'
}

#
################################################################################################################################
#


_SQLINS() {
    $SQLITE $DB "insert into $3 ($1) values ($2);"
}

_SQLSEL() {
    $SQLITE $DB "rt into temp ($1) values ($2);"
}

_DHT22() {
SWITCH=0
while [ "$SWITCH" == "0" ]; do
    read TEMP HUM <<< "`$DHT $SENSOR_TYPE $SENSOR_PIN | cut -d' ' -f4,8 | tail -n1`"

    if [ "$HUM" == "" ]; then
        sleep 1
    else
        echo "DHT-22 $TEMP $HUM"
        _SQLINS "value" "$TEMP" "temp_new"
        _SQLINS "value" "$HUM" "hum_new"
        SWITCH=1
    fi
done
}

_LOLDHT() {
    read HUM TEMP <<< "`$LOLDHT | tail -n1`"
    echo "LOLDHT-22 $TEMP $HUM"
    _SQLINS "value" "$TEMP" "temp_new"
    _SQLINS "value" "$HUM" "hum_new"
}

_DHT11() {
SWITCH=0
while [ "$SWITCH" == "0" ]; do
    read HUM TEMP <<< `$SENSOR`

    if [ "$HUM" == "ERROR" ]; then
        sleep 1
    else
        echo "DHT-11 $TEMP $HUM"
        _SQLINS "value" "`echo $TEMP | cut -d= -f2`" "temp"
        _SQLINS "value" "`echo $HUM | cut -d= -f2`" "hum"
        SWITCH=1
    fi
done
}

#
################################################################################################################################
#

_VALUES() {
read FUNCKEY MAX MIN MAXACT MINACT FUNC PIN <<< `$SQLITE -separator " " $DB "select * from func where value='$1';"`
read VALUE <<< `$SQLITE -separator " " $DB "select value from $1 order by key desc limit 0,1;"`
if [ "$VALUE" -gt "$MAX" ]; then
    echo "at $1 was $VALUE gt $MAX calling $MAXACT for $PIN"
fi
if [ "$VALUE" -lt "$MIN" ]; then
    echo "at $1 was $VALUE lt $MIN calling $MINACT for $PIN"
fi
}

#
################################################################################################################################
################################################################################################################################
################################################################################################################################
#


#
# Nacteni promenych (datum a databaze)
#

read TIME DATE <<< `date +'%H:%M %F'`

read KEY INPUT PIN ACT STATUS  <<< `$SQLITE -separator " " $DB "select * from time where act != '2' and status = '0' and date >= $(echo "'$TIME'") order by date limit 1;"`

#
# Prevod casovych udaju na porovnatelnou podobu
#

if [ "$INPUT" == "" ]; then
    read NOWTIME <<< `_TIME $TIME`
    INPTIME="N/A"
else
    read INPTIME NOWTIME <<< `_TIME $INPUT; _TIME $TIME`
fi

#
# Zpracovani udaju
#

if [ "$INPTIME" == "$NOWTIME" ]; then
    echo $PIN | tr ',' '\n' | while read XPIN; do
	_GPIO $XPIN
	echo $XPIN
    done
    $SQLITE $DB "update time set status = 1 where key = '$KEY';"
    echo "($TIME) $NOWTIME == $INPTIME ($KEY) -> $ACT"
else
    echo "($TIME) $NOWTIME != $INPTIME ($KEY)"
fi

#
################################################################################################################################
#

_DHT11

#_DHT22
_LOLDHT

_VALUES hum

_VALUES temp

/var/uncgi/control.sh -d
