#!/bin/bash

source /var/uncgi/conf.ini

printf '\n'

_BUTTON() {
if [ "$1" == "1" ]; then
    echo "Pin: $2 <p><a href=\"/cgi-bin/uncgi/control-send.sh?web=1&button=$2,0\"><img src=\"/images/on.png\" height=50 width=50></a></p>"
else
    echo "Pin: $2 <p><a href=\"/cgi-bin/uncgi/control-send.sh?web=1&button=$2,1\"><img src=\"/images/off.png\" height=50 width=50></a></p>"
fi
}

if [ "$1" == "-d" ]; then
    for VAR in {0..5}; do
        read STATE <<< `$GPIO read $VAR`
        $SQLITE $DB "update start set act=$STATE where pin=$VAR;"
    done
    exit 0
fi

cat << EOF
<body>
<center>
EOF

for VAR in {0..5}; do
    read STATE <<< `$GPIO read $VAR`
    _BUTTON "$STATE" "$VAR"
done

cat << EOF
</center></body>
EOF