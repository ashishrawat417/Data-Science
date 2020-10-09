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


// Task 3a:
// TODO: *** Put your solution here ***
var doc_vocab = docwords.join(vocab, "vocabId").groupBy($"word").sum("count").orderBy($"sum(count)". desc)
doc_vocab.write.mode("overwrite").csv("file:///home/user203439668389/Task_3a-out")

doc_vocab.show(10)
// Required to exit the spark-shell
sys.exit(0)
