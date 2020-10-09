// Load the input data and split each line into an array of strings
val vgdataLines = sc.textFile("hdfs:///user/ashhall1616/bdc_data/assignment/t1/vgsales.csv")
val vgdata = vgdataLines.map(_.split(";"))

// Task 1d:
// TODO: *** Put your solution here ***
val totalRows = vgdata.count
vgdata.map(x => ( x(4), 1 )).
    reduceByKey(_ + _).
    map(x => (x._1, x._2, x._2 / totalRows.toFloat * 100 )).
    sortBy(_._2, false).
    take(50).
    foreach(x => println(f"${x._1}, ${x._2}, ${x._3}%.1f"))

// Required to exit the spark-shell
sys.exit(0)
