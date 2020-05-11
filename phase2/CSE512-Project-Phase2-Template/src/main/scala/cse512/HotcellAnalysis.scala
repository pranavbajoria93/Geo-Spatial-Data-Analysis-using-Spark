package cse512

import org.apache.log4j.{Level, Logger}
import org.apache.spark.sql.{DataFrame, SparkSession}
import org.apache.spark.sql.functions.udf
import org.apache.spark.sql.functions._

object HotcellAnalysis {
  Logger.getLogger("org.spark_project").setLevel(Level.WARN)
  Logger.getLogger("org.apache").setLevel(Level.WARN)
  Logger.getLogger("akka").setLevel(Level.WARN)
  Logger.getLogger("com").setLevel(Level.WARN)

def runHotcellAnalysis(spark: SparkSession, pointPath: String): DataFrame =
{
  // Load the original data from a data source
  var pickupInfo = spark.read.format("com.databricks.spark.csv").option("delimiter",";").option("header","false").load(pointPath);
  pickupInfo.createOrReplaceTempView("nyctaxitrips")
  pickupInfo.show()

  // Assign cell coordinates based on pickup points
  spark.udf.register("CalculateX",(pickupPoint: String)=>((
    HotcellUtils.CalculateCoordinate(pickupPoint, 0)
    )))
  spark.udf.register("CalculateY",(pickupPoint: String)=>((
    HotcellUtils.CalculateCoordinate(pickupPoint, 1)
    )))
  spark.udf.register("CalculateZ",(pickupTime: String)=>((
    HotcellUtils.CalculateCoordinate(pickupTime, 2)
    )))
  pickupInfo = spark.sql("select CalculateX(nyctaxitrips._c5),CalculateY(nyctaxitrips._c5), CalculateZ(nyctaxitrips._c1) from nyctaxitrips")
  var newCoordinateName = Seq("x", "y", "z")
  pickupInfo = pickupInfo.toDF(newCoordinateName:_*)
  pickupInfo.show()

  // Define the min and max of x, y, z
  val minX = -74.50/HotcellUtils.coordinateStep
  val maxX = -73.70/HotcellUtils.coordinateStep
  val minY = 40.50/HotcellUtils.coordinateStep
  val maxY = 40.90/HotcellUtils.coordinateStep
  val minZ = 1
  val maxZ = 31
  val numCells = (maxX - minX + 1)*(maxY - minY + 1)*(maxZ - minZ + 1)

  // calculate attribute value "x" i.e. Number of points in each cell,
  pickupInfo = pickupInfo.groupBy("x", "y", "z").count()
    .withColumnRenamed("count", "pointsCount")
  pickupInfo.createOrReplaceTempView("pickupInfo")

  // Mean number of points in each cell - xMean
  val xMean = pickupInfo.agg(sum("pointsCount")).first().getLong(0).toDouble / numCells.toDouble

  // Standard Deviation of number of points in each cell
  val stdDeviation = Math.sqrt((pickupInfo.select(pow("pointsCount",2) as "pointsCountSquared")
    .agg(sum("pointsCountSquared")).first().getDouble(0) / numCells.toDouble) - Math.pow(xMean, 2))

  // Calculate total number of points in all the neighbors
  pickupInfo = spark.sql("select PI1.x, PI1.y, PI1.z, sum(PI2.pointsCount) as sumNeighborsPointCount " +
    "from pickupInfo as PI1, pickupInfo as PI2 " +
    "where PI2.x between PI1.x-1 and PI1.x+1 " +
    "and PI2.y between PI1.y-1 and PI1.y+1 " +
    "and PI2.z between PI1.z-1 and PI1.z+1 " +
    "group by PI1.x, PI1.y, PI1.z ")
  pickupInfo.createOrReplaceTempView("pickupInfo")
  // pickupInfo.show()

  // Calculate number of neighbours for each cell in pickupInfo
  spark.udf.register("numNeighborsCalculator", (x: Int, y: Int, z:Int,
                                                xMin: Int, yMin: Int, zMin: Int,
                                                xMax: Int, yMax: Int, zMax: Int)=>
    (HotcellUtils.numNeighborsCalculator( x, y, z, xMin, yMin, zMin, xMax, yMax, zMax)))

  pickupInfo = spark.sql("select x, y, z, numNeighborsCalculator(x, y, z, " + minX + "," + minY + "," +
    minZ + "," + maxX + "," + maxY + "," + maxY + ") as numNeighbors, sumNeighborsPointCount from pickupInfo")
  pickupInfo.createOrReplaceTempView("pickupInfo")
  // pickupInfo.show()

  // Calculate z-score for each cell in pickupInfo
  spark.udf.register("zScoreCalculator", (sumNeighborsPointCount: Int, xMean: Double, numNeighbors: Int,
                                          stdDeviation: Double, numCells: Int)=>(HotcellUtils.zScoreCalculator(
    sumNeighborsPointCount, xMean, numNeighbors, stdDeviation, numCells)))

  pickupInfo = spark.sql("select x, y, z, zScoreCalculator(pickupInfo.sumNeighborsPointCount, " +
    xMean + ", pickupInfo.numNeighbors, " + stdDeviation + ", " + numCells + ") as zscore " +
    "from pickupInfo").orderBy(desc("zscore")).select("x", "y", "z").limit(50)
  pickupInfo.show(50)

//  pickupInfo = spark.sql("select x, y, z, zScoreCalculator(pickupInfo.sumNeighborsPointCount, " +
//    xMean + ", pickupInfo.numNeighbors, " + stdDeviation + ", " + numCells.toInt + ") as zscore " +
//    "from pickupInfo").orderBy(desc("zscore")).select("x", "y", "z", "zscore").limit(50)
//  pickupInfo.show(50)

  return pickupInfo
}
}