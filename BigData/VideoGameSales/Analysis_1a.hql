set hivevar:studentId=20343966; --Please replace it with your student id 
DROP TABLE ${studentId}_vgsales;
DROP TABLE ${studentId}_vgdisp;

-- Create a table for the input data
CREATE TABLE ${studentId}_vgsales (
    Name STRING, Platform STRING, Year STRING, Genre STRING, Publisher STRING,
    NA_Sales DOUBLE, EU_sales DOUBLE, JP_Sales DOUBLE, Other_Sales DOUBLE)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\;';

-- Load the input data
-- LOAD DATA LOCAL INPATH 'Input_data/vgsales-small.csv' INTO TABLE ${studentId}_vgsales;
LOAD DATA LOCAL INPATH 'Input_data/vgsales.csv' INTO TABLE ${studentId}_vgsales;

-- Question 1a

-- TODO: *** Put your solution here ***

-- set mapred.reduce.tasks = 2;
-- set hive.exec.reducers.max=10;
-- set mapreduce.job.reduces=10;

CREATE TABLE ${studentId}_vgdisp AS
SELECT Name, Genre, NA_Sales
    FROM ${studentId}_vgsales
    WHERE Platform = 'X360'
    ORDER BY NA_Sales DESC
    LIMIT 3;

--Dump the output to file
INSERT OVERWRITE LOCAL DIRECTORY './Task_1a-out/'
ROW FORMAT DELIMITED
    FIELDS TERMINATED BY '\t'
    STORED AS TEXTFILE
    SELECT * FROM ${studentId}_vgdisp;
