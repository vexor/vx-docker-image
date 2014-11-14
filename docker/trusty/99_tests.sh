#!/bin/bash

set -x
set -e

echo "Wait severs to be ready"
sleep 10

# should apt worked without update
apt-get install pdftk -qy

psql -c 'select version()' -U postgres
mysql -u root -e "select version()"
redis-cli time

service memcached start
sleep 5
( echo version | nc 127.0.0.1 11211 ) | grep 'VERSION'

service elasticsearch start
sleep 15
curl -s --fail -XGET 'http://localhost:9200/_nodes'

service mongodb start
sleep 5
echo "db.version()" | mongo

service rabbitmq-server start
sleep 5
rabbitmqctl status

searchd &
sleep 5
searchd --status

ruby --version
gem --version
bundle --version
node --version
npm --version

javac -version

sbt -h | grep Usage

su -c 'lein -v' vexor | grep Leiningen

