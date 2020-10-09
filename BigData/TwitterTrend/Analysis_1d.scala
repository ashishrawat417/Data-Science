import org.apache.spark.sql._
import org.apache.spark.sql.types._
import org.apache.spark.sql.functions._
import org.apache.spark.sql.expressions._
import spark.implicits._

// Define case classe for input data
case class Hashtag(tokenType: String, month: String, count: Int, hashtagName: String)
// Read the input data
val hashtags = spark.read.
  schema(Encoders.product[Hashtag].schema).
  option("delimiter", "\t").
  csv("hdfs:///user/ash/dataset/twitter.tsv").
  as[Hashtag]

// Bonus task:
// TODO: *** Put your solution here ***
val df1 = hashtags.as("df1")
val df2 = hashtags.as("df2")

val dateToMonths = spark.udf.register[Int, String]("dateToMonths", x => x.substring(0, 4).toInt * 12 + x.substring(4).toInt)

df1.join(df2, $"df1.hashtagName" === $"df2.hashtagName" and $"df1.month" < $"df2.month" and $"df1.count" < $"df2.count").
   filter(dateToMonths($"df2.month") - dateToMonths($"df1.month") === 1).
   orderBy($"df2.count".desc).
   select($"df1.hashtagName", $"df1.month" as "monthpre", $"df2.month" as "monthnext", $"df1.count" as "count1", $"df2.count" as "count2").
   take(1).
   foreach(t => println("Hashtag name: mycoolwife: " + t(0) + "\nCount of month " + t(1) + ": " + t(3) + "\nCount of month " + t(2) + ": " + t(4)))

// NOTE: You only need to complete either the SQL *OR* RDD task to get the bonus marks

// Required to exit the spark-shell
sys.exit(0)