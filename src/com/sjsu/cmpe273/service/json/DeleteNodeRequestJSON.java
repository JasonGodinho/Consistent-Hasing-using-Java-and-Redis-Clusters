package com.sjsu.cmpe273.service.json;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class DeleteNodeRequestJSON {
	
	public DeleteNodeRequestJSON() {
	}

	public String clusterName;
	
	public String ipAddress;
	
	public int port;

	
	
	
}
