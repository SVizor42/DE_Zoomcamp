## Week 6 Homework 

In this homework, we'll use the models developed during the week 4 videos and enhance the already presented dbt project using the already loaded Taxi data for fhv vehicles for year 2019 in our DWH.

We will use the data loaded for:
* Building a source table: `stg_fhv_tripdata`
* Building a fact table: `fact_fhv_trips`
* Create a dashboard 

If you don't have access to GCP, you can do this locally using the ingested data from your Postgres database
instead. If you have access to GCP, you don't need to do it for local Postgres -
only if you want to.

### Question 1. Which option allows Kafka to scale?
* consumer.group.id
* replication
* consumer.commit.auto
* **partitions**

### Question 2. Which option provide fault tolerance to kafka?
* partitions
* consumer.group.id
* **replication**
* cleanup.policy

### Question 3. What is a compact topic? 
* Topic which deletes messages after 7 days
* Topic which compact messages based on value
* **Topic which compact messages based on Key**
* All topics are compact topic

### Question 4. Role of schemas in Kafka: 
* **Making consumer producer independent of each other**
* **Provide possibility to update messages without breaking change**
* Allow control when producing messages
* Share message information with consumers

### Question 5. Which configuration should a producer set to provide guarantee that a message is never lost?
* ack=0
* ack=1
* **ack=all**

### Question 6. From where all can a consumer start consuming messages from?
* **Beginning in topic**
* **Latest in topic**
* **From a particular offset**
* From a particular timestamp

### Question 7. What key structure is seen when producing messages via 10 minutes Tumbling window in Kafka stream?
* Key
* [Key, Start Timestamp]
* [Key, Start Timestamp + 10 mins, Start Timestamp]
* **[Key, Start Timestamp, Start Timestamp + 10 mins]**

### Question 8. Benefit of Global KTable?
* Partitions get assigned to KStream
* **Efficient joins**
* Network bandwidth reduction

### Question 9. When joining KTable with KTable partitions should be?
* Different
* **Same**
* Does not matter

### Question 10. When joining KStream with Global KTable partitions should be?
* Different
* Same
* **Does not matter**