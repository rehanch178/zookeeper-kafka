FROM rehanchy/centos:centos-1.8.0.272.b10

RUN wget --no-check-certificate https://archive.apache.org/dist/kafka/2.6.1/kafka_2.13-2.6.1.tgz && \
	tar xzf kafka_2.13-2.6.1.tgz && \
	rm -f kafka_2.13-2.6.1.tgz && \
	mv kafka_2.13-2.6.1 kafka

RUN yum install git -y

RUN wget https://golang.org/dl/go1.16.10.linux-amd64.tar.gz && \
	tar -zxvf go1.16.10.linux-amd64.tar.gz -C /usr/local/

ENV GOROOT=/usr/local/go
ENV GOPATH=/root
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH

RUN git clone https://github.com/SberMarket-Tech/protokaf.git

WORKDIR protokaf

RUN go install github.com/SberMarket-Tech/protokaf@latest
#RUN protokaf

WORKDIR /

EXPOSE 9092 9999 9093

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY config/producer.properties kafka/config/producer.properties
COPY config/server.properties kafka/config/server.properties 
COPY example.proto /
COPY kafka_server_jaas.conf /kafka_server_jaas.conf
COPY admin.properties /admin.properties

ENTRYPOINT ["/entrypoint.sh"]
