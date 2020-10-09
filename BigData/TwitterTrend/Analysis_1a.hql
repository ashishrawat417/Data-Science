set hive.cli.print.header= true;
set hivevar:studentId=20343966; --Please replace it with your student id

DROP TABLE ${studentId}_twitterdata;
DROP TABLE ${studentId}_toptweetmonths;

-- Create a table for the input data
CREATE TABLE ${studentId}_twitterdata (
    tokenType STRING, month STRING, count BIGINT, hashtagName STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';

-- Load the input data
LOAD DATA LOCAL INPATH 'Input_data/twitter.tsv' INTO TABLE ${studentId}_twitterdata;

-- Question 2a
-- TODO: *** Put your solution here ***
CREATE TABLE ${studentId}_toptweetmonths AS
    SELECT month, SUM(count) AS numtweets
        FROM ${studentId}_twitterdata
        GROUP BY month
        ORDER BY numtweets DESC
        LIMIT 5;

--Dump the output to file
INSERT OVERWRITE LOCAL DIRECTORY './Task_2a-out/'
ROW FORMAT DELIMITED 
    FIELDS TERMINATED BY '\t'
    STORED AS TEXTFILE
    SELECT * FROM ${studentId}_toptweetmonths;
