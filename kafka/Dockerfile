FROM rehanchy/centos:centos-1.8.0.272.b10

RUN wget --no-check-certificate https://archive.apache.org/dist/kafka/2.6.1/kafka_2.13-2.6.1.tgz && \
	tar xzf kafka_2.13-2.6.1.tgz && \
	rm -f kafka_2.13-2.6.1.tgz && \
	mv kafka_2.13-2.6.1 kafka

EXPOSE 9092 9999 9093

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY config/producer.properties kafka/config/producer.properties
COPY config/server.properties kafka/config/server.properties

ENTRYPOINT ["/entrypoint.sh"]
