import org.apache.spark.sql._
import org.apache.spark.sql.types._
import org.apache.spark.sql.functions._
import org.apache.spark.sql.expressions._
import spark.implicits._

// Task 4b:
// TODO: *** Put your solution here ***
val fridgeParquetDF = spark.read.parquet("file:///home/user203439668389/t4_story_publishers.parquet")

val df1 = fridgeParquetDF.toDF("storyId1", "publisher1")
val df2 = fridgeParquetDF.toDF("storyId2", "publisher2")

val pairedPublishers = df1.join(df2, $"storyId1" === $"storyId2").
   filter($"publisher1" > $"publisher2").
   groupBy($"publisher1", $"publisher2").
   count().
   orderBy($"count" . desc)

pairedPublishers.write.mode("overwrite").csv("file:///home/user203439668389/t4_paired_publishers.csv")

// Required to exit the spark-shell
sys.exit(0)
