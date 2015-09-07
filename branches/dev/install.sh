#!/bin/bash

sqlite3 test.db "create table time (key INTEGER PRIMARY KEY, date TEXT, pin TEXT, act INTEGER, status INTEGER, done INTEGER);"

sqlite3 test.db "create table hum (key INTEGER PRIMARY KEY, value INTEGER);"
sqlite3 test.db "create table temp (key INTEGER PRIMARY KEY, value INTEGER);"

sqlite3 test.db "create table func (key INTEGER PRIMARY KEY, max INTEGER, min INTEGER, maxact INTEGER, minact INTEGER, value TEXT);"

sqlite3 test.db "create table start (key INTEGER PRIMARY KEY, pin INTEGER, act INTEGER );"

mkdir /var/tmpfs

cd uncgi-src

make

mv uncgi /usr/lib/cgi-bin/

cd ..

cp -rf uncgi /var/

chown -R www-data:www-data /var/uncgi

cp -rf www /var/

chown -R www-data:www-data /var/www

cp scheduler /etc/apache2/conf.d

ln -s /etc/apache2/mods-avibile/proxy.conf  /etc/apache2/mods-enabled/proxy.conf
ln -s /etc/apache2/mods-avibile/proxy_connect.load /etc/apache2/mods-enabled/proxy_connect.load
ln -s /etc/apache2/mods-avibile/proxy_http.load /etc/apache2/mods-enabled/proxy_http.load
ln -s /etc/apache2/mods-avibile/proxy.load /etc/apache2/mods-enabled/proxy.load

service apache2 restart

printf 'tmpfs           /var/tmpfs      tmpfs   size=32M\n' >> /etc/fstab

mount /var/tmpfs

mv test.db /var/tmpfs/

printf '* * * * * /usr/local/bin/backend.sh >> /var/uncgi/backend.log; if [ -f /var/tmpfs/test.db ]; then cat /var/tmpfs/test.db > /root/test.db; fi\n' >> /var/spool/root/crontab

echo "DONE!"

