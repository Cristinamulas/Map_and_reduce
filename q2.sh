#!/bin/sh

rm ../../mapreduce-test-python/part2/cluster.txt
rm ../../mapreduce-test-python/part2/new_cluster.txt

../../start.sh
/usr/local/hadoop/bin/hdfs dfs -rm -r /part2/input/
/usr/local/hadoop/bin/hdfs dfs -rm -r /part2/output/
/usr/local/hadoop/bin/hdfs dfs -mkdir -p /part2/input/
/usr/local/hadoop/bin/hdfs dfs -copyFromLocal ../../mapreduce-test-data/shot_logs.csv /part2/input/

/usr/local/hadoop/bin/hadoop jar /usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.9.2.jar \
-file ../../mapreduce-test-python/part2/q2/initial/mapper.py -mapper ../../mapreduce-test-python/part2/q2/initial/mapper.py \
-file ../../mapreduce-test-python/part2/q2/initial/reducer.py -reducer ../../mapreduce-test-python/part2/q2/initial/reducer.py \
-input /part2/input/* -output /part2/output/
echo "The Initial Centroids: "
/usr/local/hadoop/bin/hdfs dfs -cat /part2/output/part-00000
/usr/local/hadoop/bin/hdfs dfs -copyToLocal /part2/output/part-00000 ../../mapreduce-test-python/part2/cluster.txt
/usr/local/hadoop/bin/hdfs dfs -rm -r /part2/output/

iter=0
diff=10
while [ $iter -lt 10 -a $diff -gt 0 ]
do

/usr/local/hadoop/bin/hadoop jar /usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.9.2.jar \
-file ../../mapreduce-test-python/part2/q2/kmeans/mapper.py \
-mapper ../../mapreduce-test-python/part2/q2/kmeans/mapper.py \
-file ../../mapreduce-test-python/part2/q2/kmeans/reducer.py -reducer ../../mapreduce-test-python/part2/q2/kmeans/reducer.py \
-input /part2/input/* -output /part2/output/ \
-file '../../mapreduce-test-python/part2/cluster.txt' 
/usr/local/hadoop/bin/hdfs dfs -copyToLocal /part2/output/part-00000 ../../mapreduce-test-python/part2/new_cluster.txt
/usr/local/hadoop/bin/hdfs dfs -rm -r /part2/output/

diff=$(python ../../mapreduce-test-python/part2/q2/cluster_diff.py ../../mapreduce-test-python/part2/cluster.txt ../../mapreduce-test-python/part2/new_cluster.txt)
mv ../../mapreduce-test-python/part2/new_cluster.txt ../../mapreduce-test-python/part2/cluster.txt
iter=$((iter+1))
done

echo "The Final Centroids:"
cat ../../mapreduce-test-python/part2/cluster.txt

/usr/local/hadoop/bin/hadoop jar /usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.9.2.jar \
-file ../../mapreduce-test-python/part2/q2/PlayerBestZone/mapper.py \
-mapper ../../mapreduce-test-python/part2/q2/PlayerBestZone/mapper.py \
-file ../../mapreduce-test-python/part2/q2/PlayerBestZone/reducer.py -reducer ../../mapreduce-test-python/part2/q2/PlayerBestZone/reducer.py \
-input /part2/input/* -output /part2/output/ \
-file '../../mapreduce-test-python/part2/cluster.txt' 
/usr/local/hadoop/bin/hdfs dfs -cat /part2/output/part-00000
/usr/local/hadoop/bin/hdfs dfs -rm -r /part2/input/
/usr/local/hadoop/bin/hdfs dfs -rm -r /part2/output/

../../stop.sh

rm ../../mapreduce-test-python/part2/cluster.txt
rm ../../mapreduce-test-python/part2/new_cluster.txt
