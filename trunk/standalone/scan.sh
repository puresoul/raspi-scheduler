#!/bin/bash

TYPE=22
PIN=4

PROC() {
dht $TYPE $PIN | cut -d' ' -f $1 | tail -n1
}

while true; do

    read DATA TEMP HUM <<< `PROC 1,3,7`

    if [ "$DATA" == "Data" ]; then
        sleep 1
    else
        echo "Teplota: $TEMP Vlhkost: $HUM"
        exit 1
    fi

done