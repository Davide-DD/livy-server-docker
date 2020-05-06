# select operating system
FROM amazoncorretto:8

RUN yum update -y && yum install -y \
    gzip \
    unzip \
    procps \
    wget \
    tar \
  && yum clean all \
  && rm -rf /var/cache/yum

RUN mkdir /opt/apache-livy /var/apache-spark-binaries

ENV SPARK_VERSION 2.4.4
ENV LIVY_VERSION 0.6.0
ENV SPARK_HOME /opt/spark-$SPARK_VERSION-bin-hadoop2.7

# binaries
# apache livy
RUN wget https://archive.apache.org/dist/incubator/livy/$LIVY_VERSION-incubating/apache-livy-$LIVY_VERSION-incubating-bin.zip -O /tmp/livy.zip
RUN unzip /tmp/livy.zip -d /opt/
# Logging dir
RUN mkdir /opt/apache-livy-$LIVY_VERSION-incubating-bin/logs

# apache spark
RUN wget https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop2.7.tgz -O /tmp/spark.tgz
RUN tar -xvzf /tmp/spark.tgz -C /opt/

COPY init /opt/docker-init
COPY conf/livy.conf /opt/apache-livy-$LIVY_VERSION-incubating-bin/conf/livy.conf

# expose ports
EXPOSE 8998

# start from init folder
WORKDIR /opt/docker-init
ENTRYPOINT ["./entrypoint"]

