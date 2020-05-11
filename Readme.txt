###########################################################################################
                            Instructions to run the script (run_experiments.sh)
###########################################################################################

Steps:
1. Setup the cluster with one Master Node and 3 Worker Nodes (For replicating our results, create a cluster with each instance having 4 GB RAM and 2 cores) AWS - t3.medium instances.
    - Please find below for replicating our configurations.
2. Start HDFS and configure it to distribute data over the 3 worker nodes with a replication factor of 2.
3. Upload following files to HDFS in "input" directory:
    - arealm10000.csv
    - zcta10000.csv
    - point-hotzone.csv
    - zone-hotzone.csv
    - yellow_tripdata_2009-01_point.csv
    - yellow_tripdata_2009-01_point_half.csv # Contains half of yellow_tripdata_2009-01_point.csv file
4. Configure Yarn, Spark according to the instances Memory spcifications. (Please refer to report for our memory specifications)
5. Start Yarn and Spark history server. "start-dfs.sh, start-yarn.sh, spark-history-server.sh". (In our case spark logs history on port 18080 this can be configure in spark-default.conf file)
    - start-dfs.sh
    - start-yarn.sh
    - spark-history-server.sh
6. Run "run_experiments.sh" script to run all the experiments.
7. Once the script execution is completed, check the CPU, Network In, Network Out metrics on AWS CLOUDWATCH for each instance.
8. For spark and yarn history check the following URL's:
    - YARN : master URL/8088
    - SPARK HISTORY LOG : master URL/18080


############################################################################################
                                    Configuration Files
############################################################################################
# -----------------------------------core-site.xml -----------------------------------------

<configuration>
	<property>
		<name>fs.default.name</name>
		<value>hdfs://172.31.5.191:9000</value>
	</property>
</configuration>

# -----------------------------------hdfs-site.xml -----------------------------------------
<configuration>
    <property>
            <name>dfs.namenode.name.dir</name>
            <value>/home/ubuntu/data/nameNode</value>
    </property>

    <property>
            <name>dfs.datanode.data.dir</name>
            <value>/home/ubuntu/data/dataNode</value>
    </property>

    <property>
            <name>dfs.replication</name>
            <value>2</value>
    </property>
</configuration>

# -----------------------------------yarn-site.xml -----------------------------------------
<configuration>
    <property>
            <name>yarn.acl.enable</name>
            <value>0</value>
    </property>

    <property>
            <name>yarn.resourcemanager.hostname</name>
            <value>172.31.5.191</value> # Master private IP
    </property>

    <property>
            <name>yarn.nodemanager.aux-services</name>
            <value>mapreduce_shuffle</value>
    </property>

    <property>
   	    <name>yarn.nodemanager.resource.memory-mb</name>
            <value>2560</value>
    </property>

    <property>
            <name>yarn.scheduler.maximum-allocation-mb</name>
            <value>2560</value>
    </property>

    <property>
            <name>yarn.scheduler.minimum-allocation-mb</name>
            <value>256</value>
    </property> 

    <property>
            <name>yarn.nodemanager.vmem-check-enabled</name>
            <value>false</value>
    </property>
</configuration>

# --------------------------------------- slaves -------------------------------------------------
# Private IP's of workers
172.31.6.202
172.31.5.240
172.31.1.180

# -----------------------------------spark-defaults.conf -----------------------------------------
spark.master yarn
spark.driver.memory 1024m
spark.executor.memory 1024m

spark.eventLog.enabled            true
spark.eventLog.dir                hdfs://172.31.5.191:9000/spark-logs
spark.history.provider            org.apache.spark.deploy.history.FsHistoryProvider 
spark.history.fs.logDirectory     hdfs://172.31.5.191:9000/spark-logs 
spark.history.fs.update.interval  10s 
spark.history.ui.port             18080

##################################################################################################
