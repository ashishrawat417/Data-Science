// Load the input data and split each line into an array of strings
val vgdataLines = sc.textFile("hdfs:///user/ashhall1616/bdc_data/assignment/t1/vgsales.csv")
val vgdata = vgdataLines.map(_.split(";"))
// Task 1c:
// TODO: *** Put your solution here ***
val processData = vgdata.map(x => ( x(3), x(5).toFloat + x(6).toFloat + x(7).toFloat )).reduceByKey(_ + _)
processData.cache.count()

val highestSale = processData.sortBy(_._2, false).first()
val lowestSale = processData.sortBy(_._2, true).first()

println(f"Highest selling Genre: [${highestSale._1}], Global Sale (in millions): [${highestSale._2}%.2f]")
println(f"Highest selling Genre: [${lowestSale._1}], Global Sale (in millions): [${lowestSale._2}%.2f]")

// Required to exit the spark-shell
sys.exit(0)
