# Stacklite
Get insight from Stackoverflow datasets using Hadoop, Hive, and MySQL cluster running on Docker Containers.

## On hadoop-master

### Format namenode
`bin/hadoop namenode -format`

### Start yarn and dfs nodes
`sbin/start-dfs.sh`
<br>
`sbin/start-yarn.sh`

## On hive

### Init hive schema
`schematool --dbType mysql --initSchema`

### Run metastore after init
`hive --service metastore`

## On host

### Put data to hadoop-master from host
`docker cp data/. hadoop-master:/usr/local/hadoop`

## On hadoop-master

### Put data to hfds
`bin/hadoop dfs -mkdir /<folder_name>`
<br>
`bin/hadoop dfs -put <your_data>.csv /<folder_name>`
<br>
`bin/hadoop dfs -put <your_data>.csv /<folder_name>`
<br>

## On hive

### Create table on hive
`Wil be added...`

### Start doing some query, and export it as csv
`hive -e '<query>' > <result_file>.csv`

## On host
### Copy query result to host
`docker cp hive:/usr/local/hive/<query_result>.csv result/data/`  

