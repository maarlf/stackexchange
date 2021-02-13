#!/bin/bash

# on hadoop-master

# format namenode
bin/hadoop namenode -format

# start yarn and dfs nodes
sbin/start-dfs.sh
sbin/start-yarn.sh

# on hive

# init hive schema
schematool --dbType mysql --initSchema

# run metastore after init
hive --service metastore

# on host

# put data to hadoop-master from host
docker cp data/. hadoop-master:/usr/local/hadoop

# on hadoop-master

# put data to hfds
bin/hadoop dfs -mkdir /stacklite
bin/hadoop dfs -put questions.csv /stacklite
bin/hadoop dfs -put question_tags.csv /stacklite

# on hive

# creating table on hive
create table questions(id int, creationdate string, closeddate string, deletiondate string, score int, owneruserid string, answercount int) row format delimited fields terminated by ',' stored as textfile;
load data inpath '/stacklite/questions.csv' overwrite into table questions;

create table questiontags(id int, tag string) row format delimited fields terminated by ',' stored as textfile;
load data inpath '/stacklite/question_tags.csv' overwrite into table questiontags;

# hive query
hive -e 'select questiontags.tag, count(*) as used from questiontags group by questiontags.tag' > all_tags_used.csv
hive -e 'select questiontags.tag, sum(questions.score) as score from questions inner join questiontags on questions.id = questiontags.id group by questiontags.tag' > all_tags_score.csv
hive -e 'select questiontags.tag, count(*) as used from questiontags group by questiontags.tag order by used desc limit 10' > top_10_used_tags.csv
hive -e 'select questiontags.tag, count(*) as used from questiontags where questiontags.tag = "angularjs" or questiontags.tag = "reactjs" or questiontags.tag = "vue.js" group by questiontags.tag' > js_frameworks_used_tags.csv
hive -e 'select questiontags.tag, count(*) as used from questiontags where questiontags.tag = "tensorflow" or questiontags.tag = "keras" or questiontags.tag = "caffe" or questiontags.tag = "pytorch" or questiontags.tag = "mxnet" group by questiontags.tag' > ml_frameworks_used_tags.csv
hive -e 'select questiontags.tag, sum(questions.score) as score from questions inner join questiontags on questions.id = questiontags.id group by questiontags.tag order by score desc limit 10' > top_10_score_tags.csv
hive -e 'select questiontags.tag, sum(questions.score) as score from questions inner join questiontags on questions.id = questiontags.id where questiontags.tag = "angularjs" or questiontags.tag = "reactjs" or questiontags.tag = "vue.js" group by questiontags.tag' > js_frameworks_score_tags.csv
hive -e 'select questiontags.tag, sum(questions.score) as score from questions inner join questiontags on questions.id = questiontags.id where questiontags.tag = "tensorflow" or questiontags.tag = "keras" or questiontags.tag = "caffe" or questiontags.tag = "pytorch" or questiontags.tag = "mxnet" group by questiontags.tag' > ml_frameworks_score_tags.csv
hive -e 'select questiontags.tag, sum(questions.score) as score from questions inner join questiontags on questions.id = questiontags.id where questiontags.tag = "linux" or questiontags.tag = "windows" group by questiontags.tag' > os_score_tags.csv

# on host

# copy data to result/data/ directory
docker cp hive:/usr/local/hive/all_tags_used.csv result/data/
docker cp hive:/usr/local/hive/all_tags_scored.csv result/data/
docker cp hive:/usr/local/hive/top_10_used_tags.csv result/data/
docker cp hive:/usr/local/hive/top_10_score_tags.csv result/data/
docker cp hive:/usr/local/hive/js_frameworks_used_tags.csv result/data/
docker cp hive:/usr/local/hive/ml_frameworks_used_tags.csv result/data/
docker cp hive:/usr/local/hive/js_frameworks_score_tags.csv result/data/
docker cp hive:/usr/local/hive/ml_frameworks_score_tags.csv result/data/
docker cp hive:/usr/local/hive/os_score_tags.csv result/data/
