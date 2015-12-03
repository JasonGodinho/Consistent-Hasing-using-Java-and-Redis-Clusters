package com.sjsu.cmpe273.service.json;

import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class AddNodeResponseJSON {
	
	public AddNodeResponseJSON() {
	}

	@XmlElement(name="clusterName")
	public String clusterName;

	@XmlElement(name="exceptionMsg")
	public String exceptionMsg;

	@XmlElement(name="status")
	public String status;

	@XmlElement(name="noOfKeysMoved")
	public int noOfKeysMoved;

	@XmlElement(name="listOfKeysAdded")
	public List<KeyDetailsJSON> listOfKeysAdded;
}
