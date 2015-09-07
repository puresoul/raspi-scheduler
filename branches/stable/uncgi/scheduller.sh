#!/bin/bash

source /var/uncgi/conf.ini

#<li><a href="/www">Webcontrol</a></li>
#  <ul>  </ul>




_BODY() {
cat << EOF
<head>
<link href="/style/scheduller.css" rel="stylesheet" type="text/css" />
</head>
<body>
<form action=/cgi-bin/uncgi/scheduller-send.sh method=post>
<div id="scheduleTabs">
  <div id="day">
    <table class="widget widget now-playing-list">
      <colgroup>
      <col width="400">
      <col width="400">
      <col width="800">
      <col width="200">
      <col width="200">
      </colgroup>
      <thead>
        <tr>
          <td>State</td>
          <td>Time</td>
          <td>Pins</td>
          <td>Delete</td>
          <td>Status</td>
        </tr>
      </thead>
      <tfoot>
        <tr>
          <td></td>
        </tr>
      </tfoot>
      <tbody>
EOF
}

_FOOT() {
cat << EOF
        </li></ul></td>
        </tr>
      </tbody>
    </table>
  </div>
<div id="dialerdiv1" style="float: left; width: 80px;"><button>Process</button></form></div> <div id="dialerdiv2" style="float: left; width: 10px;"> <form action=/cgi-bin/uncgi/scheduller-insert.sh method=post><button type="submit">Newline</button></form></div>
</body>
EOF
}

#
#################################################################
#

# $1 - echo "`echo $INPUT | cut -d'|' -f1`" | cut -d':' -f1
# $2 - "$NUM"
_HOUR() {
    echo "<select name=\"sethour$2\">"
    for NODE in {00..23}; do
        if [ "$NODE" == "$1" ]; then
            echo "<option value=\"$NODE\" selected>$NODE</option>"
        else
            echo "<option value=\"$NODE\">$NODE</option>"
        fi
    done
    echo "</select>"
}

# $1 - echo "`echo $INPUT | cut -d'|' -f1`" | cut -d':' -f2
# $2 - "$NUM"
_MINUTE() {
    echo "<select name=\"setminute$2\">"
    for NODE in {00..59}; do
        if [ "$NODE" == "$1" ]; then
            echo "<option value=\"$NODE\" selected>$NODE</option>"
        else
            echo "<option value=\"$NODE\">$NODE</option>"
        fi
    done
    echo "</select>"
}

# $1 - "$ACT"
# $2 - "$NUM"
_RADIOBOX() {
    for NODE in 0 1 2; do
        if [ "$NODE" == "$1" ]; then
            echo "<input type=\"radio\" id=\"radio\" name=\"radio$2\" value=\"$NODE\" checked=\"checked\" /><label for=\"radio$NODE\">$NODE</label>"
        else
            echo "<input type=\"radio\" id=\"radio\" name=\"radio$2\" value=\"$NODE\" /><label for=\"radio$NODE\">$NODE</label>"
        fi
    done
}

# $1 - "$PIN"
# $2 - "$NUM"
_CHECKBOX() {
    LOCK=1
    for NODE in 0 1 2 3 4 5 6; do
        if [ "$NODE" == "`echo $1 | cut -d ',' -f$LOCK`" ]; then
            let LOCK++
            echo "<input type=\"checkbox\" id=\"check$2\" name=\"checkbox$2\" value=\"$NODE\" checked=\"checked\" /><label for=\"check\">$NODE</label></input>"
        else
            echo "<input type=\"checkbox\" id=\"check$2\" name=\"checkbox$2\" value=\"$NODE\" /><label for=\"check\">$NODE</label></input>"
        fi
    done
}

_STATUS() {
    if [ "$1" == "0" ]; then
        printf "Pending"
    else
        printf "Done"
    fi
}

# $1 - "$NUM"
# $2 - "$PIN"
# $3 - "`echo $INPUT | cut -d'|' -f1`"
# $4 - "$ACT"
# $5 - $STATUS
_TABLE() {
cat << EOF
        <tr>
          <td>`_RADIOBOX "$5" "$1"`</td>
            <td>`_HOUR "$3" "$1"` : `_MINUTE "$4" "$1"`</td>
            <td>`_CHECKBOX "$2" "$1"`</td>
            <td><input type="checkbox" id="delete" name="deletebox$1" value="1" /><label for="check">$1</label></td>
        <td>`_STATUS "$6"`</td>
        </tr>
EOF
}

#
##################################################################################################################
#

printf '\n'

_BODY

$SQLITE -separator " " $DB "select * from time;" | while read VAR; do
    read KEY INPUT PIN ACT STATUS <<< $VAR
    _TABLE "$KEY" "$PIN" "`echo $INPUT | cut -d: -f1`" "`echo $INPUT | cut -d: -f2`" "$ACT" "$STATUS"
done

_FOOT
