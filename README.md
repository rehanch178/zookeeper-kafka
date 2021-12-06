# Setup 3 node zookeeper-kafka cluster in docker swarm
# Setup
Before starting the cluster you will need to install docker (docker-engine >= 0.10.0) and docker-compose. If you already have these installed, you can skip docker installation
# Install docker on all the three nodes (node1, node2 and node3)
# Setting up Docker
Ubuntu > You can install docker from here https://docs.docker.com/engine/install/ubuntu/

Centos > You can install docker from here https://docs.docker.com/engine/install/centos/

# Configure 3 node docker swarm cluster where one node will be leader and the other two are worker
Run command on node1 to initialize docker swarm cluster and save the token appers on the console. This token will be required to configure worker nodes

    sudo docker swarm init

Execute the docker swarm join command on the other two nodes ( node2 and node3). After successful join to swarm leader node, run command to verify the cluster

    sudo docker node ls

    ID                            HOSTNAME     STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
    4w7axt8g69fu625s9bwmdu99p     node2        Ready     Active                          20.10.7
    kebjh0g9wtzh7yvghnrglvh8r *   node1        Ready     Active         Leader           20.10.7

Add docker labels on the nodes. Labels will be rquired by the compose files to deploy zookeeper and kafka containers on each node.
Run docker label commands from the leader node. Here leader node is node1, docker swarn commands should be run from the leader node only.
    
    sudo docker node update --label-add  node=src <NODE_ID> (Get node ID from docker node ls output and pass) 
    sudo docker node update --label-add  node=dest <NODE_ID> (Get node ID from docker node ls output and pass)
    
Create overlay network which is required for internal communication of the containers inside docker swarm cluster

    docker network create -d overlay --attachable vnetwork

Install docker-compose on the leader node.

    sudo curl -L "https://github.com/docker/compose/releases/download/v2.1.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
    sudo docker-compose --version

Get zookeeper docker-compose file from here https://github.com/rehanch178/zookeeper-kafka/blob/main/zookeeper/zk.yaml , save it in a file name zookeeper-docker-compose.yaml and run command to setup 3 node zookeeper cluster.

    sudo docker stack deploy -c zookeeper-docker-compose.yaml zk

Once docker stack is deployed and all the services are up then verify zookeeper cluster has form the Quorum where one zookeeper node will be leader and the other two are follower. Login to each node's zookeeper container, run command and verify Mode of the command output.

    [root@zookeeper2 /]# echo stat | nc localhost 2181
    Zookeeper version: 3.6.2--803c7f1a12f85978cb049af5e4ef23bd8b688715, built on 09/04/2020 12:44 GMT
    Clients:
      /127.0.0.1:49066[0](queued=0,recved=1,sent=0)

    Latency min/avg/max: 0/0.0/0
    Received: 2
    Sent: 1
    Connections: 1
    Outstanding: 0
    Zxid: 0x1800000000
    Mode: leader
    Node count: 25
    Proposal sizes last/min/max: -1/-1/-
    
The other node's mode should be Mode: follower

Now setup Kafka cluster.Get kafka docker-compose file from here https://github.com/rehanch178/kafka/blob/main/kafka-docker-compose.yaml, save it in a file name kafka-docker-compose.yaml and run command to setup 3 node kafka cluster.

    sudo docker stack deploy -c kafka-docker-compose.yaml kafka
    
Once docker stack is deployed and all the services are up then verify each kafka node has joined zookeeper cluster as kakfa brokers. Login to one of the zookeeper container, run command and list kafka brokers. The output should be [1, 2, 3] where 1, 2 and 3 are kafkabroker id's.

    [root@zookeeper2 /]# ./zookeeper/bin/zkCli.sh ls /brokers/ids
    /usr/bin/java
    Connecting to localhost:2181

    WATCHER::

    WatchedEvent state:SyncConnected type:None path:null
    [1, 2, 3]
