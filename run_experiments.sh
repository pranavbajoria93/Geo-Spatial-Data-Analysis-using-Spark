#!/bin/bash

# Script to run spatial and Geo-spatial experiments on various configurations of worker and data nodes.

# Before running this file, follow the steps mentioned in Readme.txt

# Spatial Experiments
# Workers: 1, Data: Full Data
./spark-2.3.4-bin-hadoop2.7/bin/spark-submit --deploy-mode client --num-executors=1 --executor-cores 2 ~/project/CSE512-Phase1-assembly-0.1.0.jar hdfs://172.31.5.191:9000/output_P1_E1 rangequery hdfs://172.31.5.191:9000/input/arealm10000.csv -93.63173,33.0183,-93.359203,33.219456 rangejoinquery hdfs://172.31.5.191:9000/input/arealm10000.csv hdfs://172.31.5.191:9000/input/zcta10000.csv distancequery hdfs://172.31.5.191:9000/input/arealm10000.csv -88.331492,32.324142 1 distancejoinquery hdfs://172.31.5.191:9000/input/arealm10000.csv hdfs://172.31.5.191:9000/input/arealm10000.csv 0.1
# Workers: 2, Data: Full Data
./spark-2.3.4-bin-hadoop2.7/bin/spark-submit --deploy-mode client --num-executors=2 --executor-cores 2 ~/project/CSE512-Phase1-assembly-0.1.0.jar hdfs://172.31.5.191:9000/output_P1_E2 rangequery hdfs://172.31.5.191:9000/input/arealm10000.csv -93.63173,33.0183,-93.359203,33.219456 rangejoinquery hdfs://172.31.5.191:9000/input/arealm10000.csv hdfs://172.31.5.191:9000/input/zcta10000.csv distancequery hdfs://172.31.5.191:9000/input/arealm10000.csv -88.331492,32.324142 1 distancejoinquery hdfs://172.31.5.191:9000/input/arealm10000.csv hdfs://172.31.5.191:9000/input/arealm10000.csv 0.1
# Workers: 3, Data: Full Data
./spark-2.3.4-bin-hadoop2.7/bin/spark-submit --deploy-mode client --num-executors=3 --executor-cores 2 ~/project/CSE512-Phase1-assembly-0.1.0.jar hdfs://172.31.5.191:9000/output_P1_E3 rangequery hdfs://172.31.5.191:9000/input/arealm10000.csv -93.63173,33.0183,-93.359203,33.219456 rangejoinquery hdfs://172.31.5.191:9000/input/arealm10000.csv hdfs://172.31.5.191:9000/input/zcta10000.csv distancequery hdfs://172.31.5.191:9000/input/arealm10000.csv -88.331492,32.324142 1 distancejoinquery hdfs://172.31.5.191:9000/input/arealm10000.csv hdfs://172.31.5.191:9000/input/arealm10000.csv 0.1

# Geo-Spatial Experiments
# Workers: 1, Data: Half Data
./spark-2.3.4-bin-hadoop2.7/bin/spark-submit --deploy-mode client --num-executors=1 --executor-cores 2 --class cse512.Entrance ~/project/CSE512-Hotspot-Analysis-Template-assembly-0.1.0.jar hdfs://172.31.5.191:9000/output_P2_H_E1 hotzoneanalysis hdfs://172.31.5.191:9000/input/point-hotzone.csv hdfs://172.31.5.191:9000/input/zone-hotzone.csv hotcellanalysis hdfs://172.31.5.191:9000/input/yellow_tripdata_2009-01_point_half.csv
# Workers: 2, Data: Half Data
./spark-2.3.4-bin-hadoop2.7/bin/spark-submit --deploy-mode client --num-executors=2 --executor-cores 2 --class cse512.Entrance ~/project/CSE512-Hotspot-Analysis-Template-assembly-0.1.0.jar hdfs://172.31.5.191:9000/output_P2_H_E2 hotzoneanalysis hdfs://172.31.5.191:9000/input/point-hotzone.csv hdfs://172.31.5.191:9000/input/zone-hotzone.csv hotcellanalysis hdfs://172.31.5.191:9000/input/yellow_tripdata_2009-01_point_half.csv
# Workers: 3, Data: Half Data
./spark-2.3.4-bin-hadoop2.7/bin/spark-submit --deploy-mode client --num-executors=3 --executor-cores 2 --class cse512.Entrance ~/project/CSE512-Hotspot-Analysis-Template-assembly-0.1.0.jar hdfs://172.31.5.191:9000/output_P2_H_E3 hotzoneanalysis hdfs://172.31.5.191:9000/input/point-hotzone.csv hdfs://172.31.5.191:9000/input/zone-hotzone.csv hotcellanalysis hdfs://172.31.5.191:9000/input/yellow_tripdata_2009-01_point_half.csv

# Workers: 1, Data: Full Data
./spark-2.3.4-bin-hadoop2.7/bin/spark-submit --deploy-mode client --num-executors=1 --executor-cores 2 --class cse512.Entrance ~/project/CSE512-Hotspot-Analysis-Template-assembly-0.1.0.jar hdfs://172.31.5.191:9000/output_P2_F_E1 hotzoneanalysis hdfs://172.31.5.191:9000/input/point-hotzone.csv hdfs://172.31.5.191:9000/input/zone-hotzone.csv hotcellanalysis hdfs://172.31.5.191:9000/input/yellow_tripdata_2009-01_point.csv
# Workers: 2, Data: Full Data
./spark-2.3.4-bin-hadoop2.7/bin/spark-submit --deploy-mode client --num-executors=2 --executor-cores 2 --class cse512.Entrance ~/project/CSE512-Hotspot-Analysis-Template-assembly-0.1.0.jar hdfs://172.31.5.191:9000/output_P2_F_E2 hotzoneanalysis hdfs://172.31.5.191:9000/input/point-hotzone.csv hdfs://172.31.5.191:9000/input/zone-hotzone.csv hotcellanalysis hdfs://172.31.5.191:9000/input/yellow_tripdata_2009-01_point.csv
# Workers: 3, Data: Full Data
./spark-2.3.4-bin-hadoop2.7/bin/spark-submit --deploy-mode client --num-executors=3 --executor-cores 2 --class cse512.Entrance ~/project/CSE512-Hotspot-Analysis-Template-assembly-0.1.0.jar hdfs://172.31.5.191:9000/output_P2_F_E3 hotzoneanalysis hdfs://172.31.5.191:9000/input/point-hotzone.csv hdfs://172.31.5.191:9000/input/zone-hotzone.csv hotcellanalysis hdfs://172.31.5.191:9000/input/yellow_tripdata_2009-01_point.csv

# Now follow the steps mentioned in readme.txt to collect the experiment results from AWS CLoudwatch, Spark history, Yarn history.