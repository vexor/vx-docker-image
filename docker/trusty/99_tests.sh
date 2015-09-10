#!/bin/bash

set -x
set -e

echo "Wait severs to be ready"
sleep 10

# should apt worked without update
apt-get install pdftk -qy

psql="psql --pset pager=off"

$psql -c 'select version()' -U postgres

su vexor -c "$psql -c 'select version()'"
su vexor -c "$psql -c 'CREATE EXTENSION postgis'"
su vexor -c "$psql -c 'CREATE EXTENSION postgis_topology'"
su vexor -c "$psql -c 'SELECT PostGIS_full_version()'"

mysql -u root -e "select version()"
redis-cli time

service memcached start
sleep 5
( echo version | nc 127.0.0.1 11211 ) | grep 'VERSION'

service solr start
sleep 15
curl -s --fail -XGET 'http://localhost:8983/solr/admin/cores'

service elasticsearch start
sleep 15
curl -s --fail -XGET 'http://localhost:9200/_nodes'

service mongodb start
sleep 10
echo "db.version()" | mongo

service rabbitmq-server start
sleep 5
rabbitmqctl status

searchd &
sleep 5
searchd --status

ruby --version
python --version
pip --version
gem --version
bundle --version
node --version
npm --version
ansible-playbook --version
mvn --version
qmake --version | grep '4.8.6'
javac -version
sbt -h | grep Usage
su -c 'lein -v' vexor | grep Leiningen
/usr/local/bin/zookeeper/bin/zkServer.sh status

