# Create Topic
./commands.sh "createTopic" "source" "mirrormakertopic"
./commands.sh "createTopic" "dest" "<topicName>"

# List Topic 
./commands.sh "listTopic" "source"
./commands.sh "listTopic" "dest"

# Describe Topic
./commands.sh "describeTopic" "source" "mirrormakertopic"
./commands.sh "describeTopic" "dest" "mirrormakertopic"

# Add topic partitions
# Topic Partitions are replicated runtime
./commands.sh "addTopicPartition" "source" "mirrormakertopic"

# Add retention
# mm2 restart is required
./commands.sh "addTopicRetention" "source" "mirrormakertopic"

# Produce data to topic at the source
./commands.sh "produceTopic" "source" "mirrormakertopic"

# Consume wihout commiting offsets
./commands.sh "consumeTopicWithCommit" "source" "mirrormakertopic"
./commands.sh "consumeTopicWitoutCommit" "source" "mirrormakertopic"

# Describe groups to check the offsets of the group for the topic
./commands.sh "describeConsumerGroup" "source"
./commands.sh "describeConsumerGroup" "dest"

# Produce protobuf messages
./commands.sh "produceProtobufTopic" "source"

# Compact a topic
./commands.sh "compactTopic" "source" "<topicname>"

# Add Acl at the source and check in the destination
./commands.sh "addAclTopic"

# List Acls
./commands.sh "listAclSourceTopic"
./commands.sh "listAclDestTopic"

