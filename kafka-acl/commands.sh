#!/bin/bash
set -x
operationName=$1
cluster=$2
topicName=$3
groupId=$4

sourceBrokers="kafka1:9093,kafka2:9093,kafka3:9093"
destBrokers="kafka4:9093,kafka5:9093,kafka6:9093"

if [ "${cluster}" == "source" ];then
{
    setBrokers=$sourceBrokers
}
else
{
    setBrokers=$destBrokers
}
fi

if [ "${operationName}" == "createTopic" ];then
{
    ./kafka/bin/kafka-topics.sh --bootstrap-server $setBrokers --create --topic $topicName --partitions 3 --replication-factor 3 --config retention.ms=96400000 --command-config admin.properties
}
elif [ "${operationName}" == "listTopic" ];then
{
    ./kafka/bin/kafka-topics.sh --bootstrap-server $setBrokers --list --command-config admin.properties
}

elif [ "${operationName}" == "describeTopic" ];then
{
    ./kafka/bin/kafka-topics.sh --describe --bootstrap-server $setBrokers --topic $topicName --command-config admin.properties
}

elif [ "${operationName}" == "deleteTopic" ];then
{
    ./kafka/bin/kafka-topics.sh --bootstrap-server $setBrokers --topic $topicName --delete --command-config admin.properties
}

elif [ "${operationName}" == "produceTopic" ];then
{
    for x in {100..200}; do echo "message $x"; done | ./kafka/bin/kafka-console-producer.sh --bootstrap-server $setBrokers --topic $topicName --producer.config admin.properties
}

elif [ "${operationName}" == "consumeTopicWithCommit" ];then
{
    if [ -z "${groupId}" ];then
    {
        echo "Please input consumergroup id as 4th parameter"
        exit
    }
    else
    {
        ./kafka/bin/kafka-console-consumer.sh --bootstrap-server $setBrokers --topic $topicName --max-messages 10 --consumer-property enable.auto.commit=true --consumer-property group.id=$groupId --from-beginning --consumer.config admin.properties
    }
    fi
}

elif [ "${operationName}" == "consumeTopicWitoutCommit" ];then
{
    if [ -z "${groupId}" ];then
    {
        echo "Please input consumergroup id as 4th parameter"
        exit
    }
    else
    {
        ./kafka/bin/kafka-console-consumer.sh --bootstrap-server $setBrokers --topic $topicName --max-messages 10 --consumer-property enable.auto.commit=false --consumer-property group.id=$groupId --from-beginning --command-config admin.properties
    }
    fi
}

# New topic partitions getting replicated
elif [ "${operationName}" == "addTopicPartition" ];then
{
    ./kafka/bin/kafka-topics.sh --bootstrap-server $setBrokers --alter --topic $topicName --partitions 4 --command-config admin.properties
}

# Configs like retention.ms and delete.retention.ms is nor replicatiog
elif [ "${operationName}" == "addTopicRetention" ];then
{
    ./kafka/bin/kafka-configs.sh --bootstrap-server $setBrokers --entity-type topics --entity-name $topicName --alter --add-config delete.retention.ms=96400000 --command-config admin.properties
}

elif [ "${operationName}" == "compactTopic" ];then
{
    ./kafka/bin/kafka-topics.sh --bootstrap-server $setBrokers --create --topic $topicName --partitions 2 --replication-factor 2 --config cleanup.policy=compact --command-config admin.properties
     # Add compaction delay time 
     #/kafka/bin/kafka-configs.sh --bootstrap-server $setBrokers --entity-type topics --entity-name $topicName --alter --add-config log.cleaner.min.compaction.lag.ms=180000 
}

# Desribe consumer group
elif [ "${operationName}" == "describeConsumerGroup" ];then
{
    ./kafka/bin/kafka-consumer-groups.sh --bootstrap-server $setBrokers --all-groups --describe --command-config admin.properties
}

# elif [ "${operationName}" == "createCompactTopic" ];then
# {
#     ./kafka/bin/kafka-consumer-groups.sh --bootstrap-server $setBrokers --topic $topicName --config
# }

elif [ "${operationName}" == "produceCompactTopic" ];then
{
    ./kafka/bin/kafka-consumer-groups.sh --bootstrap-server $setBrokers --topic $topicName --property parse.key=true --property key.separator=: --command-config admin.properties
}

elif [ "${operationName}" == "produceCompactTopic" ];then
{
    ./kafka/bin/kafka-consumer-groups.sh --bootstrap-server $setBrokers --topic $topicName --property parse.key=true --property key.separator=: --command-config admin.properties
}

elif [ "${operationName}" == "produceProtobufTopic" ];then
{
    for x in {100..200}; do protokaf produce HelloRequest --broker kafka1:9093,kafka2:9093,kafka3:9093 --proto example.proto --topic $topicName --kafka-auth-dsn PLAIN:admin:admin-secret --data '{"name": "'$x'", "age": '$x'}'; done 
}

elif [ "${operationName}" == "addAclTopic" ];then
{
    ./kafka/bin/kafka-acls.sh --bootstrap-server kafka1:9093,kafka2:9093,kafka2:9093 --command-config admin.properties --topic first_topic --allow-principal User:consumer --consumer --add --group "*"
}
elif [ "${operationName}" == "listAclSourceTopic" ];then
{
    ./kafka/bin/kafka-acls.sh --bootstrap-server kafka1:9093,kafka2:9093,kafka2:9093 --command-config admin.properties --list
}
elif [ "${operationName}" == "listAclDestTopic" ];then
{
    ./kafka/bin/kafka-acls.sh --bootstrap-server kafka4:9093,kafka5:9093,kafka6:9093 --command-config admin.properties --list
}
fi



# Cosume protobuf message and just check the offsets by desribing the consumer groups
