package com.sjsu.cmpe273.service.json;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class InsertDataRequestJSON {
	
	public InsertDataRequestJSON() {
	}
	public String clusterName;
	
	public String key;
	
	public String value;
	
	public boolean isURL;

	
}
