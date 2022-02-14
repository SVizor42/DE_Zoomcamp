## Week 3 Homework

### Question 1: 
**What is count for fhv vehicles data for year 2019**  
Can load the data for cloud storage and run a count(*)
```sql
SELECT COUNT(*)
FROM `dtc-de-339112.trips_data_all.fhv_tripdata`
WHERE DATE(pickup_datetime) BETWEEN '2019-01-01' AND '2019-12-31';
```
> 42084899
### Question 2: 
**How many distinct dispatching_base_num we have in fhv for 2019**  
Can run a distinct query on the table from question 1
```sql
SELECT COUNT(DISTINCT dispatching_base_num)
FROM `dtc-de-339112.trips_data_all.fhv_tripdata`
WHERE DATE(pickup_datetime) BETWEEN '2019-01-01' AND '2019-12-31';
```
> 792

### Question 3: 
**Best strategy to optimise if query always filter by dropoff_datetime and order by dispatching_base_num**  
Review partitioning and clustering video.   
We need to think what will be the most optimal strategy to improve query 
performance and reduce cost.
> We can't use partitioning over dispatching_base_num column, since it has a STRING type. But we can use this column for clustering. 
> Therefore, the answer should be - Partition by dropoff_date time and cluster by dispatching_base_num

### Question 4: 
**What is the count, estimated and actual data processed for query which counts trip between 2019/01/01 and 2019/03/31 for dispatching_base_num B00987, B02060, B02279**  
Create a table with optimized clustering and partitioning, and run a 
count(*). Estimated data processed can be found in top right corner and
actual data processed can be found after the query is executed.
```sql
CREATE OR REPLACE TABLE `dtc-de-339112.trips_data_all.fhv_part_clust`
PARTITION BY DATE(dropoff_datetime)
CLUSTER BY dispatching_base_num AS
SELECT * FROM `dtc-de-339112.trips_data_all.fhv_tripdata_external_table`;

SELECT COUNT(*) AS trips
FROM `dtc-de-339112.trips_data_all.fhv_part_clust`
WHERE DATE(dropoff_datetime) BETWEEN '2019-01-01' AND '2019-03-31'
    AND dispatching_base_num IN ('B00987', 'B02060', 'B02279');
```
> The closest one is Count: 26558, Estimated data processed: 400 MB, Actual data processed: 155 MB

### Question 5: 
**What will be the best partitioning or clustering strategy when filtering on dispatching_base_num and SR_Flag**  
Review partitioning and clustering video. 
Partitioning cannot be created on all data types.
```sql
CREATE OR REPLACE TABLE `dtc-de-339112.trips_data_all.fhv_part_SR_Flag_clust_disp_base_num`
PARTITION BY RANGE_BUCKET(SR_Flag, GENERATE_ARRAY(0, 20, 1))
CLUSTER BY dispatching_base_num AS
SELECT * FROM `dtc-de-339112.trips_data_all.fhv_tripdata_external_table`;

SELECT *
FROM `dtc-de-339112.trips_data_all.fhv_part_SR_Flag_clust_disp_base_num`
WHERE (SR_Flag IS NULL)
    AND dispatching_base_num NOT IN ('B00987', 'B02060', 'B02279');
```
> Partition by SR_Flag and cluster by dispatching_base_num showed the best performance.

### Question 6: 
**What improvements can be seen by partitioning and clustering for data size less than 1 GB**  
Partitioning and clustering also creates extra metadata.  
Before query execution this metadata needs to be processed.
> * No improvements
> * Can be worse due to metadata

### Question 7: 
**In which format does BigQuery save data**  
Review big query internals video.
> Columnar
