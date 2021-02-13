#!/bin/bash

docker run -d \
  --net hadoop \
  --net-alias hadoop-master  \
  --name hadoop-master \
  -h hadoop-master \
  -p 50070:50070 \
  -p 8032:8032 \
  -p 8088:8088 \
  -p 8020:8020 \
  newnius/hadoop:2.7.4
  
docker run -d \
  --net hadoop \
  --net-alias hadoop-slave1  \
  -h hadoop-slave1 \
  --name hadoop-slave1 \
  --link hadoop-master \
  newnius/hadoop:2.7.4

docker run -d \
  --net hadoop \
  --net-alias hadoop-slave2  \
  -h hadoop-slave2 \
  --name hadoop-slave2 \
  --link hadoop-master \
  newnius/hadoop:2.7.4

docker run -d \
  --net hadoop \
  --net-alias mysql  \
  -h mysql \
  --name mysql \
  --link hadoop-master \
  -e MYSQL_ROOT_PASSWORD=123456 \
  -e MYSQL_DATABASE=hive \
  mysql:5.7

docker run -d \
  --net hadoop \
  --net-alias hive  \
  -h hive \
  --name hive \
  --link hadoop-master \
  newnius/hive:2.1.1
