#! /bin/bash

docker ps -a | awk '{ print $1,$2 }' | grep newnius/hadoop:2.7.4 | awk '{print $1 }' | xargs -I {} docker rm {}
docker ps -a | awk '{ print $1,$2 }' | grep newnius/hive:2.1.1 | awk '{print $1 }' | xargs -I {} docker rm {}
