# select operating system
FROM python:3.7-stretch

ARG SPARK_VERSION
ARG LIVY_VERSION

ENV LOCAL_DIR_WHITELIST /opt/spark/elaborations

RUN apt-get update -y && apt-get install default-jre-headless unzip wget -y && apt-get clean

# Apache Livy
RUN wget https://archive.apache.org/dist/incubator/livy/$LIVY_VERSION-incubating/apache-livy-$LIVY_VERSION-incubating-bin.zip -O /tmp/livy.zip \
  && unzip /tmp/livy.zip -d /opt/ \
  && mv /opt/apache-livy-$LIVY_VERSION-incubating-bin /opt/livy \
  && mkdir /opt/livy/logs

# Apache Spark
RUN wget https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop2.7.tgz -O /tmp/spark.tgz \
  && tar -xvzf /tmp/spark.tgz -C /opt/ \
  && mv /opt/spark-$SPARK_VERSION-bin-hadoop2.7 /opt/spark \
  && rm -r /tmp/*

COPY init /opt/docker-init
COPY conf/livy.conf /opt/livy/conf/livy.conf
COPY conf/log4j.properties /opt/spark/conf/log4j.properties
COPY dependencies/kafka-clients-2.5.1.jar /opt/spark/jars/kafka-clients-2.5.1.jar

# expose ports
EXPOSE 8998

# start from init folder
WORKDIR /opt/docker-init
ENTRYPOINT ["./entrypoint"]