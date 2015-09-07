#!/bin/bash

source /var/uncgi/conf.ini

TEMP=`$SQLITE $DB "select value from temp order by key desc limit 0,1;"`
HUM=`$SQLITE $DB "select value from hum order by key desc limit 0,1;"`

TEMPNEW=`$SQLITE $DB "select value from temp_new order by key desc limit 0,1;"`
HUMNEW=`$SQLITE $DB "select value from hum_new order by key desc limit 0,1;"`

CEL='°C'

PRO='%'

printf '\n'

cat << EOF
<html>
<head><meta http-equiv="refresh" content="15"></head>
<body>
<center>
<p><strong>TMP11 - </strong>$TEMP $CEL / $HUM $PRO <strong>TMP22 - </strong>$TEMPNEW $CEL / $HUMNEW $PRO</p>
<p><pre>`top -n1 -b | head -n5`</pre></p>
</center>

<center>

<p>
	<img src="/munin/localdomain/localhost.localdomain/all-day.png" 
	 alt="daily graph">
	<img src="/munin/localdomain/localhost.localdomain/all-week.png" 
	 alt="weekly graph"
	 class="i">
	<img src="/munin/localdomain/localhost.localdomain/all-month.png" 
	 alt="monthly graph" 
	 class="i">
</p>
<p>
	<img src="/munin/localdomain/localhost.localdomain/temp-day.png" 
	 alt="daily graph">
	<img src="/munin/localdomain/localhost.localdomain/temp-week.png" 
	 alt="weekly graph"
	 class="i">
	<img src="/munin/localdomain/localhost.localdomain/temp-month.png" 
	 alt="monthly graph" 
	 class="i">
</p>
<p>
	<img src="/munin/localdomain/localhost.localdomain/temp_new-day.png" 
	 alt="daily graph">
	<img src="/munin/localdomain/localhost.localdomain/temp_new-week.png" 
	 alt="weekly graph"
	 class="i">
	<img src="/munin/localdomain/localhost.localdomain/temp_new-month.png" 
	 alt="monthly graph" 
	 class="i">
</p>

</center>





</html>
EOF
