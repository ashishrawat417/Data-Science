import org.apache.spark.sql._
import org.apache.spark.sql.types._
import org.apache.spark.sql.functions._
import org.apache.spark.sql.expressions._
import spark.implicits._


// Define case classes for input data
case class Docword(docId: Int, vocabId: Int, count: Int)
case class VocabWord(vocabId: Int, word: String)

// Read the input data
val docwords = spark.read.
  schema(Encoders.product[Docword].schema).
  option("delimiter", " ").
  csv("hdfs:///user/ashhall1616/bdc_data/assignment/t3/docword.txt").
  as[Docword]
val vocab = spark.read.
  schema(Encoders.product[VocabWord].schema).
  option("delimiter", " ").
  csv("hdfs:///user/ashhall1616/bdc_data/assignment/t3/vocab.txt").
  as[VocabWord]

// Task 3b:
// TODO: *** Put your solution here ***
val firstCharacter = spark.udf.register[String, String]("firstCharacter", _.substring(0, 1))
var doc_vocab = docwords.join(vocab, "vocabId").select($"word", $"docId", $"count", firstCharacter($"word") as "firstLetter")

doc_vocab.write.mode("overwrite").partitionBy("firstLetter").parquet("file:///home/user203439668389/t3_docword_index_part.parquet")
doc_vocab.show(10)

// Required to exit the spark-shell
sys.exit(0)
