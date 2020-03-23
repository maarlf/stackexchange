# Stacklite
Get insight from Stack Overflow datasets using Hadoop, Hive, and MySQL cluster 
that running on Docker containers so you can try on your own machine.

The datasets in the `data` folder are retrieved from:

```
StackLite: A simple dataset of Stack Overflow questions and tags
```

It is available on <https://github.com/dgrtwo/StackLite>, and <https://www.kaggle.com/stackoverflow/stacklite>.

## Prerequisites
- Docker client installed.

## Preparations
First of, We need to pull necessary images for this cluster.

```
$ ./pull-image.sh
```

Hadoop and hive image that we used this time are based on Newnius,
that you can check it out in his blog

https://blog.newnius.com/setup-apache-hive-in-docker.html

Next up we can create our cluster by starting necessary containers,
and connect them with a network.

```
$ ./start-container.sh && ./run-container.sh
```

We're all set, now We can use the cluster to process data with Hive.

## How to use

On `hadoop-master` node, we need to format namenode first

```
$ bin/hadoop namenode -format
```

Then, We can start yarn and dfs nodes
```
$ sbin/start-dfs.sh && sbin/start-yarn.sh
```

Initialize hive schema on `hive` node
```
$ schematool --dbType mysql --initSchema
```

Run metastore after init
```
$ hive --service metastore
```

Put data to hadoop-master from host
```
$ docker cp data/. hadoop-master:/usr/local/hadoop
```

Put data to hfds
```
$ bin/hadoop dfs -mkdir /<folder_name>
```

```
$ bin/hadoop dfs -put <your_data>.csv /<folder_name>
```

First, We need to create table on hive node
```
Wil be added...
```

Start running some query, and export it as csv
```
$ hive -e '<query>' > <result_file>.csv
```

On host, copy query result to host
```
$ docker cp hive:/usr/local/hive/<query_result>.csv result/data/
```
