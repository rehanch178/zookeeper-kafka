#!/bin/bash
set -x
data=/var/lib/kafka/data
log=/var/log/kafka

mkdir -p $data
mkdir -p $log

serverConfigFile=kafka/config/server.properties
producerConfigFile=kafka/config/producer.properties

if [ ! -f "/var/lib/kafka/id" ]; then
{
    echo "${BROKER_ID}" > "/var/lib/kafka/id"
}
else
{
	BROKER_ID=$(cat /var/lib/kafka/id)
}
fi

sed -i "s|broker.id=.*|broker.id=$BROKER_ID|" "$serverConfigFile"  
sed -i "s|@@HOSTNAME@@|${HOSTNAME}|g" "$producerConfigFile"
sed -i "s|@@KAFKA_BROKERS@@|${KAFKA_BROKERS}|g" "$producerConfigFile"  
sed -i "s|@@HOSTNAME@@|${HOSTNAME}|g" "$serverConfigFile" 
sed -i "s|@@ZOOKEEPER_SERVERS@@|${ZOOKEEPER_SERVERS}|g" "$serverConfigFile" 


chown -R runuser:runuser $data
chown -R runuser:runuser $log
chown -R runuser:runuser kafka

touch kafka.log
sudo -E -u runuser JMX_PORT=9999 kafka/bin/kafka-server-start.sh kafka/config/server.properties
tail -f kafka.log