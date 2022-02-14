-- Q1. What is count for fhv vehicles data for year 2019
SELECT COUNT(*)
FROM `dtc-de-339112.trips_data_all.fhv_tripdata`
WHERE DATE(pickup_datetime) BETWEEN '2019-01-01' AND '2019-12-31';

-- Q2. How many distinct dispatching_base_num we have in fhv for 2019
SELECT COUNT(DISTINCT dispatching_base_num)
FROM `dtc-de-339112.trips_data_all.fhv_tripdata`
WHERE DATE(pickup_datetime) BETWEEN '2019-01-01' AND '2019-12-31';

-- Q3. Best strategy to optimise if query always filter by dropoff_datetime and order by dispatching_base_num
-- Creating a partitioned table from external table by dropoff_datetime column
CREATE OR REPLACE TABLE `dtc-de-339112.trips_data_all.fhv_part_dropoff_datetime`
PARTITION BY DATE(dropoff_datetime) AS
SELECT * FROM `dtc-de-339112.trips_data_all.fhv_tripdata_external_table`;

-- Creating a partitioned and clustered table
CREATE OR REPLACE TABLE `dtc-de-339112.trips_data_all.fhv_part_clust`
PARTITION BY DATE(dropoff_datetime)
CLUSTER BY dispatching_base_num AS
SELECT * FROM `dtc-de-339112.trips_data_all.fhv_tripdata_external_table`;

--Q4. What is the count, estimated and actual data processed for query which counts trip between 2019/01/01 and 2019/03/31 for dispatching_base_num B00987, B02060, B02279 *
SELECT COUNT(*) AS trips
FROM `dtc-de-339112.trips_data_all.fhv_part_clust`
WHERE DATE(dropoff_datetime) BETWEEN '2019-01-01' AND '2019-03-31'
    AND dispatching_base_num IN ('B00987', 'B02060', 'B02279');

-- Q5. What will be the best partitioning or clustering strategy when filtering on dispatching_base_num and SR_Flag
-- Creating a partitioned and clustered table
CREATE OR REPLACE TABLE `dtc-de-339112.trips_data_all.fhv_part_SR_Flag_clust_disp_base_num`
PARTITION BY RANGE_BUCKET(SR_Flag, GENERATE_ARRAY(0, 20, 1))
CLUSTER BY dispatching_base_num AS
SELECT * FROM `dtc-de-339112.trips_data_all.fhv_tripdata_external_table`;

-- Clustering over 2 columns
CREATE OR REPLACE TABLE `dtc-de-339112.trips_data_all.fhv_double_clust`
CLUSTER BY dispatching_base_num, SR_Flag AS
SELECT * FROM `dtc-de-339112.trips_data_all.fhv_tripdata_external_table`;

-- Test partitioned and clustered table (8.4 sec elapsed, 1.3 GB processed)
SELECT *
FROM `dtc-de-339112.trips_data_all.fhv_part_SR_Flag_clust_disp_base_num`
WHERE (SR_Flag IS NULL)
    AND dispatching_base_num NOT IN ('B00987', 'B02060', 'B02279');

-- Test double clustered table (8.7 sec elapsed, 1.5 GB processed)
SELECT *
FROM `dtc-de-339112.trips_data_all.fhv_double_clust`
WHERE (SR_Flag IS NULL)
    AND dispatching_base_num NOT IN ('B00987', 'B02060', 'B02279');