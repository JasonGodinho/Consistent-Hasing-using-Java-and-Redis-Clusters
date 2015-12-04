# Consistent Hashing over a Redis cluster.

This project involves implementation of the consistent hashing to implement load balancing and almost uniform key distribution of key-value pairs over multiple Redis instances.

![alt tag](https://github.com/JasonGodinho/cmpe273_GroupProject_RedisConsistentHashing/blob/master/Consistent_Hashing_architecture.png)

Description : 

1. The implementation allows dynamic addition and deletion of Redis instances into the system.(For our tests, we had used Redis servers deployed on Amazon EC2 instances.)
2. The Jedis Java library is used as a client for communicating and performing CRUD operations on Redis instances.
3. RedisServer.java provides the implementation for consistent Hashing. 
   It offers the following functionalities : 
   a. Addition of nodes.
   b. Deletion of nodes.
   c. Insertion of data.
   d. Deletion of data by key.
   e. Checking for node availability.
   f. Getting a list of all the key-value pairs present in the cluster.
   g. Getting a list of all the key-value pairs from a single node in the cluster.
   h. Finding the node to which a key belongs to.
4. The hashing algorithm used for generating hashes is Murmur Hash. This algorithm was chosen since it resulted in unpredictable hash generation even for keys which are almost similar. Algorithms like SHA-256 and MD5 resulted in generating hashes which were almost similar for similar keys. After using murmur Hash, we were able to minimize collisions in the cluster.
5. Replication is enabled in the system. User can add a node and specify a number of replicas. A hash value is generated for each replica but the data is stored on the same node for whom replicas are created. By using replication, we can implement more uniform distribution of keys by distributing the nodes in an almost equal manner across the hash circle.
6. A REST based web service is used for communication between the user interface and the RedisServer class. The RedisWebService provides endpoints for communicating with the RedisServer class and manipulating keys and nodes in the cluster.
7. Home.jsp is the front end which communicates with RedisWebService via AJAX POST/GET calls using JQuery and HTML.
8. On the front, we can generate CSV reports to provide summary and detailed reports about nodes and data in the cluster.
9. There is an option provided on Home.jsp to add a URL as a key. If this option is selected, the value is auto-populated as the HTML content of the page at that URL. 

# UI Screens

![alt tag](https://github.com/JasonGodinho/cmpe273_GroupProject_RedisConsistentHashing/blob/master/UIScreen1.jpg)

![alt tag](https://github.com/JasonGodinho/cmpe273_GroupProject_RedisConsistentHashing/blob/master/UIScreen2.jpg)

# Deployment and testing instructions
Notes : Redis servers need to be started to be added into the cluster.

1. Run the repository as a Dynamic Web Project in Eclipse on a server.(Tomcat 7/8 should deploy successfully).

2. Navigate to http://localhost:8080/RedisCacheWebServer/Home.jsp.

3. Enter your cluster name.

4. Add nodes in the cluster by specifying IP address and ports. Also, specify the no. of replicas for each node.

5. You can add key-value pairs in the key-value panel on the right side.

6. You can also add a URL as a key. The HTML content of the page at that URL is populated as the value for the key. User needs to specify values for normal keys.

7. The drop down on the top right provides options for generating detailed and summary reports of the status of the cluster. Summary report provides a list of the no. of keys in each node. Detailed report provides a list of all the key-value pairs in each of the nodes.
8. Users can add nodes, and nodes will be added to cluster provided those nodes are up and Redis is running on them. If a connection cannot be made to the Redis instance at the address provided, an alert will be provided specifying that the node is not up.

9. On addition and deletion of nodes, keys will be migrated between the nodes depending on whether the keys belong to the node that is newly added/removed. An alert will be provided notifying the user of key movement between the nodes.

10. Users can remove nodes from the cluster. But they cannot remove the last node in the cluster. When a user removes a node from the cluster, the keys in it are migrated to the adjacent node and an alert is received by the user notifying him of the key migration.
