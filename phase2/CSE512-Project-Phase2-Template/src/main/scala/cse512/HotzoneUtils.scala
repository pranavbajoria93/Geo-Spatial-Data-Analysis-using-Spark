package cse512

object HotzoneUtils {

  // CHeck if the point is within the rectangle
  def ST_Contains(queryRectangle: String, pointString: String ): Boolean = {
    var rectanglePoints = queryRectangle.split(",").map(s => s.toDouble)
    var point = pointString.split(",").map(s => s.toDouble)
    if( Math.min(rectanglePoints(0),rectanglePoints(2)) <=
      point(0) && point(0) <= Math.max(rectanglePoints(0),rectanglePoints(2))){
      if( Math.min(rectanglePoints(1),rectanglePoints(3))<=
        point(1) && point(1) <= Math.max(rectanglePoints(1),rectanglePoints(3))){
        return true
      }
    }
    return false
  }
}
