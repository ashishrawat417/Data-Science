import org.apache.spark.sql._
import org.apache.spark.sql.types._
import org.apache.spark.sql.functions._
import org.apache.spark.sql.expressions._
import spark.implicits._

/*
scala> voc_doc.printSchema
root
 |-- word: string (nullable = true)
 |-- docId: integer (nullable = true)
 |-- count: integer (nullable = true)
 |-- firstLetter: string (nullable = true)
*/

val queryWords = scala.io.StdIn.readLine("Query words: ").split(" ")
// Task 3c:
// TODO: *** Put your solution here ***

val doc_vocab = spark.read.parquet("file:///home/user203439668389/t3_docword_index_part.parquet")
for (queryWord <- queryWords) {
    val rec = doc_vocab.filter($"word" === queryWord).
        select($"word", $"docId").
        orderBy($"count".desc).
        take(1).
        foreach(println)
}

// Required to exit the spark-shell
sys.exit(0)
