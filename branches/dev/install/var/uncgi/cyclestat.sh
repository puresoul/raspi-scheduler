#!/bin/bash

source /var/uncgi/conf.ini


_BODY() {
cat << EOF
<head>
<link href="/style/scheduller.css" rel="stylesheet" type="text/css" />
</head>
<body>
<form action=/cgi-bin/uncgi/cyclestat-send.sh method=post>
<div id="scheduleTabs">
  <div id="day">
    <table class="widget widget now-playing-list">
      <colgroup>
      <col width="75">
      <col width="75">
      <col width="75">
      <col width="75">
      <col width="75">
      <col width="75">
      </colgroup>
      <thead>
        <tr>
          <td>Max</td>
          <td>Min</td>
          <td>Maxact</td>
          <td>Minact</td>
          <td>Value</td>
          <td>Pin</td>
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
<div id="dialerdiv1" style="float: left; width: 80px;"><button>Process</button></form></div> <div id="dialerdiv2" style="float: left; width: 10px;"></div>
</body>
</html>
EOF
}

#
#################################################################
#
_LOGIC() {

    echo "<select name=\"$2\">"
    while read -d' ' NODE; do
        if [ "$NODE" == "$1" ]; then
            echo "<option value=\"$NODE\" selected>$NODE</option>"
        else
            echo "<option value=\"$NODE\">$NODE</option>"
        fi
    done <<< `seq $3 $4`
    echo "</select>"
}


_TABLE() {
cat << EOF
        <tr>
          <td>`_LOGIC $1 "max$7" 1 100`</td>
            <td>`_LOGIC $2 "min$7" 1 100`</td>
            <td>`_LOGIC $3 "maact$7" 0 2`</td>
            <td>`_LOGIC $4 "miact$7" 0 2`</td>
            <td>$5</td>
          <td>`_LOGIC $6 "pin$7" 1 7`</td>
        </tr>
EOF
}

#
##################################################################################################################
#

printf '\n'

_BODY

$SQLITE -separator " " $DB "select * from func;" | while read VAR; do
    read KEY MAX MIN MAXACT MINACT VALUE PIN <<< $VAR
    let NUM++
    _TABLE "$MAX" "$MIN" "$MAXACT" "$MINACT" "$VALUE" "$PIN" "$KEY"
done

_FOOT
