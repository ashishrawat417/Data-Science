import org.apache.spark.sql._
import org.apache.spark.sql.types._
import org.apache.spark.sql.functions._
import org.apache.spark.sql.expressions._
import spark.implicits._

// Define case classe for input data
case class Article(articleId: Int, title: String, url: String, publisher: String,
                   category: String, storyId: String, hostname: String, timestamp: String)
// Read the input data
val articles = spark.read.
  schema(Encoders.product[Article].schema).
  option("delimiter", ",").
  csv("hdfs:///user/ashhall1616/bdc_data/assignment/t4/news.csv").
  as[Article]

// Task 4a:
// Step 1
// TODO: *** Put your solution here ***
var unique_publisher = articles.distinct.select($"storyId", $"publisher")
unique_publisher.write.mode("overwrite").parquet("file:///home/user203439668389/t4_story_publishers.parquet")

// Step 2
// TODO: *** Put your solution here ***
unique_publisher.groupBy($"storyId").count().filter($"count" >= 5).take(10).foreach(t => println(t))

// Required to exit the spark-shell
sys.exit(0)
