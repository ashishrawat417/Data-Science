// Load the input data and split each line into an array of strings
val twitterLines = sc.textFile("hdfs:///user/ashhall1616/bdc_data/assignment/t2/twitter.tsv")
val twitterdata = twitterLines.map(_.split("\t"))

// Task 2b:
// TODO: *** Put your solution here ***
twitterdata.map(x => (x(1).substring(0, 4), x(2).toInt )).reduceByKey(_ + _).sortBy(_._2, false).take(1).foreach(x => println(f"${x._1} ${x._2}"))

// Required to exit the spark-shell
sys.exit(0)
