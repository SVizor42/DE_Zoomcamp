## Week 6 Homework

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