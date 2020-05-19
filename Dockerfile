# select operating system
FROM ubuntu:20.10

ARG SPARK_VERSION
ARG LIVY_VERSION
ARG APACHE

ENV LOCAL_DIR_WHITELIST /tmp/

RUN apt-get update -y && apt-get install -y \
    default-jre-headless \
    unzip \
    wget \
  && apt-get clean \
  # Apache Livy 
  && wget https://archive.apache.org/dist/incubator/livy/$LIVY_VERSION-incubating/${APACHE}livy-$LIVY_VERSION-incubating-bin.zip -O /tmp/livy.zip \
  && unzip /tmp/livy.zip -d /opt/ \
  && mv /opt/${APACHE}livy-$LIVY_VERSION-incubating-bin /opt/livy \
  && mkdir /opt/livy/logs \
  # Apache Spark
  && wget https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop2.7.tgz -O /tmp/spark.tgz \
  && tar -xvzf /tmp/spark.tgz -C /opt/ \
  && mv /opt/spark-$SPARK_VERSION-bin-hadoop2.7 /opt/spark \
  && rm -r /tmp/*

COPY init /opt/docker-init
COPY conf/livy.conf /opt/livy/conf/livy.conf

# expose ports
EXPOSE 8998

# start from init folder
WORKDIR /opt/docker-init
ENTRYPOINT ["./entrypoint"]

