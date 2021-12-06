# Setup 3 node zookeeper-kafka cluster in docker swarm
# Setup
Before starting the cluster you will need to install docker (docker-engine >= 0.10.0) and docker-compose. If you already have these installed, you can skip docker installation
# Install docker on all the three nodes (node1, node2 and node3)
# Setting up Docker
Ubuntu > You can install docker from here https://docs.docker.com/engine/install/ubuntu/

Centos > You can install docker from here https://docs.docker.com/engine/install/centos/

# Configure 2 node docker swarm cluster where one node will be leader and the other two are worker
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

Clone git repo  git clone https://github.com/rehanch178/zookeeper-kafka.git and switch to directory kafka-acl

    sudo docker stack deploy -c kafka.yaml zk-kafka

Once docker stack is deployed and all the services are up then verify each kafka node has joined zookeeper cluster as kakfa brokers. Login to one of the zookeeper container, run command and list kafka brokers. The output should be [1, 2, 3] where 1, 2 and 3 are kafkabroker id's.

    [root@zookeeper2 /]# ./zookeeper/bin/zkCli.sh ls /brokers/ids
    /usr/bin/java
    Connecting to localhost:2181

    WATCHER::

    WatchedEvent state:SyncConnected type:None path:null
    [1, 2, 3]
