package com.sjsu.cmpe273.service.json;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class AddNodeRequestJSON {
	
	public AddNodeRequestJSON() {
		// TODO Auto-generated constructor stub
	}
	
	public String clusterName;
	public String ipAddress;
	public int port;
	
	public int noOfReplicas;


}
