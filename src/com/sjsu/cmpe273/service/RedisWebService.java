package com.sjsu.cmpe273.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.json.JSONArray;
import org.json.JSONObject;

import com.sjsu.cmpe273.resources.Node;
import com.sjsu.cmpe273.resources.RedisData;
import com.sjsu.cmpe273.server.RedisServer;
import com.sjsu.cmpe273.service.json.AddNodeRequestJSON;
import com.sjsu.cmpe273.service.json.DeleteNodeRequestJSON;
import com.sjsu.cmpe273.service.json.InsertDataRequestJSON;
import com.sjsu.cmpe273.service.json.KeyDetailsJSON;
import com.sjsu.cmpe273.service.json.NodeDetailedJSON;
import com.sjsu.cmpe273.service.json.NodeSummaryJSON;

@Path("/redisService")
public class RedisWebService {

	private static Map<String, RedisServer> servers = new HashMap<String, RedisServer>();
	private static int counter =0;

	// This method is called if TEXT_PLAIN is request
	@Path("/createCluster/{clusterName}")
	@POST
	@Produces(MediaType.TEXT_PLAIN)
	public Response createCluster(@PathParam("clusterName") String clusterName) {
		counter++;
		JSONObject addClusterRespJSON = new JSONObject();
		if(servers.containsKey(clusterName)){
			addClusterRespJSON.put("status", "Cluster already present");
			return Response.status(200).entity(addClusterRespJSON.toString()).build();
		}
		servers.put(clusterName, new RedisServer());
		addClusterRespJSON.put("status", "Cluster created");
		addClusterRespJSON.put("counter", counter);
		return Response.status(201).entity(addClusterRespJSON.toString()).build();
	}

	@Path("/addNode/")
	@POST
	@Produces("application/json")
	@Consumes("application/json")
	public Response addNode(AddNodeRequestJSON requestJSON) {
		JSONObject jsonObject = new JSONObject();
		//Parse the request
		RedisServer redisServer = servers.get(requestJSON.clusterName);
		if(redisServer == null){
			jsonObject.put("clusterName", requestJSON.clusterName);
			jsonObject.put("status", "failure");
			jsonObject.put("exceptionMsg", "Cluster not found");
			return Response.status(200).entity(jsonObject.toString()).build();
		}
		try {
			//Add node to cluster
			jsonObject.put("clusterName", requestJSON.clusterName);
			List<KeyDetailsJSON> movedKeys = redisServer.addNodeToCluster(requestJSON.ipAddress, requestJSON.port, requestJSON.noOfReplicas);
			//Prepare the response
			jsonObject.put("status", "success");
			jsonObject.put("exceptionMsg","");
			jsonObject.put("noOfKeysMoved",movedKeys.size());
			jsonObject.put("listOfKeysAdded",movedKeys);
			return Response.status(201).entity(jsonObject.toString()).build();
		} catch (Exception e) {			
			jsonObject.put("status", "failure");
			jsonObject.put("exceptionMsg", e.getMessage());			
			e.printStackTrace();
			return Response.status(201).entity(jsonObject.toString()).build();
		}		
	}


	//TODO Change the method type to POST in case DELETE doesn't work
	@Path("/deleteNode/")
	@POST
	@Produces("application/json")
	@Consumes("application/json")
	public Response deleteNode(DeleteNodeRequestJSON requestJSON) {
		JSONObject jsonObject = new JSONObject();
		//Parse the request
		RedisServer redisServer = servers.get(requestJSON.clusterName);
		if(redisServer == null){
			jsonObject.put("clusterName", requestJSON.clusterName);
			jsonObject.put("status", "failure");
			jsonObject.put("exceptionMsg", "Cluster not found");
			return Response.status(200).entity(jsonObject.toString()).build();
		}
		try {
			//Add node to cluster
			jsonObject.put("clusterName", requestJSON.clusterName);
			List<KeyDetailsJSON> movedKeys = redisServer.removeFromCluster(requestJSON.ipAddress, requestJSON.port);

			//Prepare the response
			jsonObject.put("status", "success");
			jsonObject.put("exceptionMsg","");
			jsonObject.put("noOfKeysMoved",movedKeys.size());
			jsonObject.put("listOfKeysRemoved",movedKeys);
			return Response.status(201).entity(jsonObject.toString()).build();
		} catch (Exception e) {			
			jsonObject.put("status", "failure");
			jsonObject.put("exceptionMsg", e.getMessage());			
			e.printStackTrace();
			return Response.status(201).entity(jsonObject.toString()).build();
		}		
	}


	@Path("/insertData/")
	@POST
	@Produces("application/json")
	@Consumes("application/json")
	public Response insertData(InsertDataRequestJSON requestJSON) {
		JSONObject jsonObject = new JSONObject();
		//Parse the request
		RedisServer redisServer = servers.get(requestJSON.clusterName);
		if(redisServer == null){
			jsonObject.put("clusterName", requestJSON.clusterName);
			jsonObject.put("status", "failure");
			jsonObject.put("exceptionMsg", "Cluster not found");
			return Response.status(200).entity(jsonObject.toString()).build();
		}
		try {
			//Add node to cluster
			jsonObject.put("clusterName", requestJSON.clusterName);
			
			//Handle data for URL
			if(requestJSON.isURL){
				URL oracle = new URL(requestJSON.key);
		        BufferedReader in = new BufferedReader(
		        new InputStreamReader(oracle.openStream()));

		        StringBuffer inputLine = new StringBuffer();
		        String currentLine="";
		        while ((currentLine = in.readLine()) != null){
		        	inputLine.append(currentLine);
		        }		            
		        in.close();
		        requestJSON.value = inputLine.toString();
			}
			
			Node assignedNode = redisServer.insertData(new RedisData(requestJSON.key, requestJSON.value));

			//Prepare the response
			if(assignedNode!= null){
				jsonObject.put("status", "success");
				jsonObject.put("exceptionMsg","");
				jsonObject.put("destIPAddress",assignedNode.getIpAddress());
				jsonObject.put("port",assignedNode.getPort());
				return Response.status(201).entity(jsonObject.toString()).build();
			}else throw new Exception("There are no nodes in the cluster to enter data into ");

		} catch (Exception e) {			
			jsonObject.put("status", "failure");
			jsonObject.put("exceptionMsg", e.getMessage());			
			e.printStackTrace();
			return Response.status(201).entity(jsonObject.toString()).build();
		}		
	}

	@Path("/clusterSummary/{clusterName}")
	@GET
	@Produces("application/json")
	public Response getSummaryReport(@PathParam("clusterName")String clusterName) {
		JSONObject jsonObject = new JSONObject();
		Node currentNode  = null;
		List<RedisData> currentData =  null;
		List<NodeSummaryJSON> summaryJSONs = null;
		//Parse the request
		RedisServer redisServer = servers.get(clusterName);
		if(redisServer == null){
			jsonObject.put("clusterName", clusterName);
			jsonObject.put("status", "failure");
			jsonObject.put("exceptionMsg", "Cluster not found");
			return Response.status(200).entity(jsonObject.toString()).build();
		}
		try {
			//Add node to cluster
			jsonObject.put("clusterName", clusterName);
			Map<Node,List<RedisData>> dataMap= redisServer.getAllData();

			//Prepare the response
			if(dataMap!= null){
				jsonObject.put("status", "success");
				jsonObject.put("exceptionMsg","");
				summaryJSONs = new ArrayList<NodeSummaryJSON>();
				for(Entry<Node, List<RedisData>> entry : dataMap.entrySet()){
					currentNode = entry.getKey();
					currentData = entry.getValue();
					summaryJSONs.add(new NodeSummaryJSON(currentNode.getIpAddress(), currentNode.getPort(), currentData.size()));
				}
				jsonObject.put("keyDistribution", summaryJSONs);

				return Response.status(201).entity(jsonObject.toString()).build();
			}else throw new Exception("There are no nodes in the cluster ");

		} catch (Exception e) {			
			jsonObject.put("status", "failure");
			jsonObject.put("exceptionMsg", e.getMessage());			
			e.printStackTrace();
			return Response.status(201).entity(jsonObject.toString()).build();
		}		
	}


	@Path("/clusterDetailed/{clusterName}")
	@GET
	@Produces("application/json")
	public Response getDetailedReport(@PathParam("clusterName")String clusterName) {
		JSONObject jsonObject = new JSONObject();
		Node currentNode  = null;
		List<RedisData> currentData =  null;
		List<NodeDetailedJSON> detailedJSONs = null;
		//Parse the request
		RedisServer redisServer = servers.get(clusterName);
		if(redisServer == null){
			jsonObject.put("clusterName", clusterName);
			jsonObject.put("status", "failure");
			jsonObject.put("exceptionMsg", "Cluster not found");
			return Response.status(200).entity(jsonObject.toString()).build();
		}
		try {
			//Add node to cluster
			jsonObject.put("clusterName", clusterName);
			Map<Node,List<RedisData>> dataMap= redisServer.getAllData();

			//Prepare the response
			if(dataMap!= null){
				jsonObject.put("status", "success");
				jsonObject.put("exceptionMsg","");
				detailedJSONs = new ArrayList<NodeDetailedJSON>();
				for(Entry<Node, List<RedisData>> entry : dataMap.entrySet()){
					currentNode = entry.getKey();
					currentData = entry.getValue();
					detailedJSONs.add(new NodeDetailedJSON(currentNode.getIpAddress(), currentNode.getPort(), currentData));
				}
				jsonObject.put("keyDistribution", detailedJSONs);

				return Response.status(201).entity(jsonObject.toString()).build();
			}else throw new Exception("There are no nodes in the cluster ");

		} catch (Exception e) {			
			jsonObject.put("status", "failure");
			jsonObject.put("exceptionMsg", e.getMessage());			
			e.printStackTrace();
			return Response.status(201).entity(jsonObject.toString()).build();
		}		
	}

	@Path("/flush/{clusterName}")
	@GET
	@Produces("application/json")
	public Response flushServer(@PathParam("clusterName")String clusterName) {
		JSONObject jsonObject = new JSONObject();
		//Parse the request
		RedisServer redisServer = servers.get(clusterName);
		if(redisServer == null){
			jsonObject.put("clusterName", clusterName);
			jsonObject.put("status", "failure");
			jsonObject.put("exceptionMsg", "Cluster not found");
			return Response.status(200).entity(jsonObject.toString()).build();
		}
		try {
			//Add node to cluster
			jsonObject.put("clusterName", clusterName);
			redisServer.flush();
			servers.remove(clusterName);
			//Prepare the response
			jsonObject.put("status", "success");
			jsonObject.put("exceptionMsg","");
			return Response.status(201).entity(jsonObject.toString()).build();

		} catch (Exception e) {			
			jsonObject.put("status", "failure");
			jsonObject.put("exceptionMsg", e.getMessage());			
			e.printStackTrace();
			return Response.status(201).entity(jsonObject.toString()).build();
		}		
	}
	
	@Path("/test/")
	@GET
	@Produces("application/json")
	public Response test() {
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("sampleKey", "Value");
		JSONArray array = new JSONArray();
		List<String> users = new ArrayList<String>();
		users.add("jason");
		users.add("savio");
		List<RedisData> datas = new ArrayList<RedisData>();
		List<NodeSummaryJSON> summaries = new ArrayList<NodeSummaryJSON>();
		datas.add(new RedisData("datakey1", "dataval1"));
		datas.add(new RedisData("datakey2", "dataval2"));
		datas.add(new RedisData("datakey3", "dataval3"));
		summaries.add(new NodeSummaryJSON("127.0.0.1", 3333, 4));
		summaries.add(new NodeSummaryJSON("127.0.0.1", 4444, 4));
		summaries.add(new NodeSummaryJSON("127.0.0.1", 1111, 4));		
		JSONArray array2 = new JSONArray();
		JSONArray array3 = new JSONArray();
		array.put(users);
		array2.put(datas);
		array3.put(summaries);
		jsonObject.put("users", array);
		jsonObject.put("datas", array2);
		jsonObject.put("summaries", array3);
		jsonObject.put("summaries2", summaries);
			return Response.status(201).entity(jsonObject.toString()).build();
				
	}
	
	@Path("/deleteData/{clusterName}/{key}")
	@GET
	@Produces("application/json")
	public Response deleteData(@PathParam("clusterName")String clusterName, @PathParam("key")String key ) {
		
		JSONObject jsonObject = new JSONObject();
		
		//Parse the request
		RedisServer redisServer = servers.get(clusterName);
		if(redisServer == null){
			jsonObject.put("clusterName", clusterName);
			jsonObject.put("status", "failure");
			jsonObject.put("exceptionMsg", "Cluster not found");
			return Response.status(200).entity(jsonObject.toString()).build();
		}
		try {
			redisServer.deleteData(key);
			jsonObject.put("status", "success");
			return Response.status(200).entity(jsonObject.toString()).build();
		} catch (Exception e) {
			jsonObject.put("status", "failure");
			jsonObject.put("exceptionMsg", e.getMessage());	
			return Response.status(201).entity(jsonObject.toString()).build();
			
		}
				
	}
	
	
	




}
