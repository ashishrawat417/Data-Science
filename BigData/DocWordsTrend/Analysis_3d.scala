import org.apache.spark.sql._
import org.apache.spark.sql.types._
import org.apache.spark.sql.functions._
import org.apache.spark.sql.expressions._
import spark.implicits._


val docIds = scala.io.StdIn.readLine("Document IDs: ").split(" ")

// Task 3d:
// TODO: *** Put your solution here ***
val doc_vocab = spark.read.parquet("file:///home/user203439668389/t3_docword_index_part.parquet")
for (docId <- docIds) {
    val rec = doc_vocab.filter($"docId" === docId).
        select($"docId", $"word", $"count").
        orderBy($"count".desc).
        take(1).
        foreach(println)
}

// Required to exit the spark-shell
sys.exit(0)