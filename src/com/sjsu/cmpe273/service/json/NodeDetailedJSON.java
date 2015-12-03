package com.sjsu.cmpe273.service.json;

import java.util.List;

import com.sjsu.cmpe273.resources.RedisData;

public class NodeDetailedJSON {

	public NodeDetailedJSON() {
	}
	
	
	public NodeDetailedJSON(String ipAddress, int port, List<RedisData> data) {
		super();
		this.ipAddress = ipAddress;
		this.port = port;
		this.data = data;
	}


	public String ipAddress;

	public int port;
	
	public List<RedisData> data;

	public String getIpAddress() {
		return ipAddress;
	}


	public void setIpAddress(String ipAddress) {
		this.ipAddress = ipAddress;
	}


	public int getPort() {
		return port;
	}


	public void setPort(int port) {
		this.port = port;
	}


	public List<RedisData> getData() {
		return data;
	}


	public void setData(List<RedisData> data) {
		this.data = data;
	}
	
	
}
