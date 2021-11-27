#Centos
FROM rehanchy/centos:centos-1.8.0.272.b10
	
RUN wget https://archive.apache.org/dist/zookeeper/zookeeper-3.6.2/apache-zookeeper-3.6.2-bin.tar.gz && \
	tar xzf apache-zookeeper-3.6.2-bin.tar.gz --no-same-owner && \
	rm -f apache-zookeeper-3.6.2-bin.tar.gz && \
	mv apache-zookeeper-3.6.2-bin zookeeper && \
	cp zookeeper/conf/zoo_sample.cfg zookeeper/conf/zoo.cfg

EXPOSE 2181 2888 3888

COPY conf/java zookeeper/conf/java.env
COPY conf/zoo.cfg zookeeper/conf/zoo.cfg

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]