#!/bin/bash
set -x
log=/var/log/zookeeper
data=/var/lib/zookeeper

mkdir -p $log
mkdir -p $data
mkdir $data/version-2

config="zookeeper/conf/zoo.cfg"

echo "ZOO_LOG_DIR=/var/log/zookeeper" >> zookeeper/bin/zkEnv.sh

sed -i "s|@@JAVA_MEM@@|${JAVA_MEM}|g" zookeeper/conf/java.env
sed -i "s|@@ZOOKEEPER_SERVER@@|${ZOOKEEPER_SERVER}|g" zookeeper/conf/zoo.cfg

if [ ! -f "$data/myid" ]; then
{
    echo "${ZOOKEEPER_SERVER_ID}" > $data/myid
}
fi

chown -R runuser:runuser $data
chown -R runuser:runuser $log
chown -R runuser:runuser zookeeper

touch zoo.out
sudo -u runuser bash zookeeper/bin/zkServer.sh start
tail -f zoo.out