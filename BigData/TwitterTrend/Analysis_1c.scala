// Load the input data and split each line into an array of strings
val twitterLines = sc.textFile("hdfs:///user/ashhall1616/bdc_data/assignment/t2/twitter.tsv")
val twitterdata = twitterLines.map(_.split("\t"))

// Task 2c:
// TODO: *** Put your solution here ***
// Remember that each month is a string formatted as YYYYMM
val x = scala.io.StdIn.readLine("x month: ")
val y = scala.io.StdIn.readLine("y month: ")

val twitterDataX = twitterdata.filter(c => c(1) == x && c(2) != 0).map(c => (c(3), c(2).toInt))
val twitterDataY = twitterdata.filter(c => c(1) == y && c(2) != 0).map(c => (c(3), c(2).toInt))

println("\nInput x =" + x + ", Input y =" + y)
twitterDataX.join(twitterDataY).
    filter(x => x._2._1 < x._2._2).
    sortBy(_._2._2, false).
    take(1).
    foreach(x => println("hashtagName: " + x._1 + ", countX: " + x._2._1 + ", countY: " + x._2._2))

// Required to exit the spark-shell
sys.exit(0)
