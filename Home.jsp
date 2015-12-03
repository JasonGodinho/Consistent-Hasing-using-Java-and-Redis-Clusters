<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<h1 style="color:white;" align="center"> Redis Consistent Hashing </h1>
<title>Redis - CMPE 273</title>
</head>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.3/jquery.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/raphael/2.1.4/raphael-min.js"></script>
<script src = "http://code.jquery.com/jquery-1.10.2.js"></script>
<script src = "http://code.jquery.com/ui/1.10.4/jquery-ui.js"></script>
	
<style media="screen" type="text/css">
.myClass {
	background-color: lightgreen;
}


.h1 {
    height:50px;
    background:#F0F0F0;
    border:1px solid #CCC;
    width:960px;
    margin:0px auto;
    color: red;
}

#createCluster {

 top: 50%;
    left: 50%;
    width:30em;
    height:7em;
    margin-top: -9em; /*set to a negative number 1/2 of your height*/
    margin-left: -15em; /*set to a negative number 1/2 of your width*/
    border: 1px solid #ccc;
    background-color: #f3f3f3;
    position:fixed;


	font-weight: bold;
	background: linear-gradient(#f1f1f1, #e2e2e2);
	padding: 5px 10px;
	color: #444;
	
	border: 1px solid #d4d4d4;
	
	border-right: 0;
	border-bottom-left-radius: 5px;
	border-top-left-radius: 5px;
	border-top-right-radius:5px;
	border-bottom-right-radius:5px;
	
	line-height: 1.5em;
	width: 30%;
	
	
	float: left;
	
	text-align: center;
	cursor: pointer;
}

.custom-dropdown {
display:none;
  -webkit-appearance: none;
  margin-left: 190px;
  -moz-appearance: none;
  border: 0 !important;
  -webkit-border-radius: 5px;
  border-radius: 5px;
  font-size: 14px;
  padding: 10px;
  width: 35%;
  cursor: pointer;
  background-size: 40px 37px;
  color: black;
  /*
color: #fff;
background: #0d98e8 url('http://www.kevinfremon.com/wp-content/uploads/2013/11/drop-down-arrow.png') no-repeat right center;
*/
  background: #e2e2e2 url('https://www.novell.com/documentation/novell-filr-1-2/filr-1-2_user/graphics/whatsnew_dropdown_n.png') no-repeat right center;
}


#showclusterdata{
	font-weight: bold;
	
	background: linear-gradient(#f1f1f1, #e2e2e2);
	
	
	color: #444;
	
	border: 1px solid #d4d4d4;
	
	border-right: 0;
	border-bottom-left-radius: 5px;
	border-top-left-radius: 5px;
	border-top-right-radius:5px;
	border-bottom-right-radius:5px;
	
	line-height: 1em;
	width: 24%;
	
	padding-top:1px;
	float: left;
	
	text-align: center;
	cursor: pointer;

}

 input[type="submit"]{
    padding: 9px 30px 6px 30px;
    margin: 4px 2px;
    color: #444444;
    font-family: 'Yanone Kaffeesatz';
    font-size: 14px;
    cursor: pointer;
    text-transform: uppercase;
    font-weight: bold;
    background-color: #F0F0F0;

    background-image: -webkit-gradient(linear, left top, left bottom, color-stop(0%, #F0F0F0), color-stop(100%, #F5F5F5));
    background-image: -webkit-linear-gradient(bottom, #F0F0F0 0%, #F5F5F5 100%);
    background-image: -moz-linear-gradient(bottom, #F0F0F0 0%, #F5F5F5 100%);
    background-image: -o-linear-gradient(bottom, #F0F0F0 0%, #F5F5F5 100%);
    background-image: -ms-linear-gradient(bottom, #F0F0F0 0%, #F5F5F5 100%);
    background-image: linear-gradient(bottom, #F0F0F0 0%, #F5F5F5 100%);

    -webkit-border-radius: 3px;
    -moz-border-radius: 3px;
    border-radius: 3px;
    border: 1px solid #dcdcdc;
    text-shadow: 0px 1px 0px white;
}

 input[type="submit"]:hover {
    background-color: #E8E8E8;

    background-image: -webkit-gradient(linear, left top, left bottom, color-stop(0%, #E8E8E8), color-stop(100%, #F5F5F5));
    background-image: -webkit-linear-gradient(bottom, #E8E8E8 0%, #F5F5F5 100%);
    background-image: -moz-linear-gradient(bottom, #E8E8E8 0%, #F5F5F5 100%);
    background-image: -o-linear-gradient(bottom, #E8E8E8 0%, #F5F5F5 100%);
    background-image: -ms-linear-gradient(bottom, #E8E8E8 0%, #F5F5F5 100%);
    background-image: linear-gradient(bottom, #E8E8E8 0%, #F5F5F5 100%);

    -webkit-box-shadow: 0px 1px 1px rgba(0,0,0,.3);
    -moz-box-shadow: 0px 1px 1px rgba(0,0,0,.3);
    box-shadow: 0px 1px 1px rgba(0,0,0,.3);
    border: 1px solid #cecece;
}


input[type="button"] {
    padding: 1px 15px 0px px;
    margin: 4px 2px;
    color: #444444;
    font-family: 'Yanone Kaffeesatz';
    font-size: 14px;
    cursor: pointer;
    font-weight: bold;
    background-color: #F0F0F0;

    background-image: -webkit-gradient(linear, left top, left bottom, color-stop(0%, #F0F0F0), color-stop(100%, #F5F5F5));
    background-image: -webkit-linear-gradient(bottom, #F0F0F0 0%, #F5F5F5 100%);
    background-image: -moz-linear-gradient(bottom, #F0F0F0 0%, #F5F5F5 100%);
    background-image: -o-linear-gradient(bottom, #F0F0F0 0%, #F5F5F5 100%);
    background-image: -ms-linear-gradient(bottom, #F0F0F0 0%, #F5F5F5 100%);
    background-image: linear-gradient(bottom, #F0F0F0 0%, #F5F5F5 100%);

    -webkit-border-radius: 3px;
    -moz-border-radius: 3px;
    border-radius: 3px;
    border: 1px solid #dcdcdc;
}

 input[type="button"]:hover {
    background-color: #E8E8E8;

    background-image: -webkit-gradient(linear, left top, left bottom, color-stop(0%, #E8E8E8), color-stop(100%, #F5F5F5));
    background-image: -webkit-linear-gradient(bottom, #E8E8E8 0%, #F5F5F5 100%);
    background-image: -moz-linear-gradient(bottom, #E8E8E8 0%, #F5F5F5 100%);
    background-image: -o-linear-gradient(bottom, #E8E8E8 0%, #F5F5F5 100%);
    background-image: -ms-linear-gradient(bottom, #E8E8E8 0%, #F5F5F5 100%);
    background-image: linear-gradient(bottom, #E8E8E8 0%, #F5F5F5 100%);

    -webkit-box-shadow: 0px 1px 1px rgba(0,0,0,.3);
    -moz-box-shadow: 0px 1px 1px rgba(0,0,0,.3);
    box-shadow: 0px 1px 1px rgba(0,0,0,.3);
    border: 1px solid #cecece;
}



html { 
/*
background: url(http://static.tumblr.com/ge74hdk/G3flw5yrs/wood_pattern.png) no-repeat center center fixed;  
*/
background: url(http://7-themes.com/data_images/out/45/6924028-3d-backgrounds-images.jpg) no-repeat center center fixed; 
  -webkit-background-size: cover;
  -moz-background-size: cover;
  -o-background-size: cover;
  background-size: cover;
}

 input[type="text"],input[type="number"] {
 text-align:center;
 border-radius: 6px;
    padding: 8px 12px;
    width: 122px;
    color: #444444;
    font-size: 12px;
    margin: 5px 2px;
    background-color: #fdfdfd;
    border: 1px solid #c2c2c2;
}

input[type="text"]:hover{
    border: 1px solid #a2a2a2;
    outline: none;

    box-shadow: -1px 1px 2px rgba(0,0,0,.1) inset;
    -moz-box-shadow: -1px 1px 2px rgba(0,0,0,.1) inset;
    -webkit-box-shadow: -1px 1px 2px rgba(0,0,0,.1) inset;
}


</style>
</head>
<body>

<br></br>

<select id= "dropdownlist" class="custom-dropdown">
<option>Custom Key</option>
<option>Key as web URL</option>
<option>Download Report</option>
<option>Download Detailed Report</option>

</select>

<input type="submit" class="dowloadreport" id="dowloadreport" value="Download Report" style ="display:none;" />
<div id="createCluster" class="cluster-name" name="createCluster">Name your cluster: 
<input type="text" name="clustername" id="clustername" required>
	<input type="submit" class="create-cluster" id="button1" value="Create Cluster" class="searchButton" />
</div>

<div id="showclusterdata" class="showclusterdata" style="display: none;margin-left: 100px; padding-top:10px; padding-bottom:10px; padding-left:10px; padding-right:10px;">
<input type="text" style="text-align: center;" name="clusterdefault"
	width="100px" value="Cluster Name :" height="100px" readonly>
&nbsp; <input type="text" name="clusterlabelname" id="clusterlabelname"
	width="100px" height="100px" value="xxxxxxx" style="text-align: center;" readonly> &nbsp;</div>

<br></br><br></br>
<div id="id1" name="id1" style="display: none; "><p style="padding-left:190px;color:white;"><b><u>Add a node:</u></b></p>
<input type="text" name="ipaddress" id="ipaddress" placeholder="Enter Node IP"> 
<input type="text" name="port" id="port" placeholder="Enter Node Port">
<input type="number" min="1" step="1 name="noOfReplicas" id="noOfReplicas" placeholder="No. of Replicas">
<input type="button" value="Add" name="addnodebutton" id="addnodebutton"/>
<br><br><b><span id="ipspan" style="padding-left: 55px; display: none;color:white;"><u>IP</u></span></b><b><span id="portspan"style="padding-left: 145px; display: none;color:white;"><u>Port</u></span></b><b><span id="replicaspan" style="padding-left: 105px;display: none;color:white;"><u>Replica #</u></span></b></br>
</div>


<div id="id2" name="id2" style="display: none;"><input type="text" name="ipaddress1" id="ipaddress1"> 
<input type="text" name="port1" id="port1"></div>
<div id="adddata" name="adddata" style="display: none; float: right; position: absolute; top: 30px; right: 100px; left: 700px; max-height: 90px;">
<br></br><br></br><br>

<p style="padding-left:140px; padding-top:88px;color:white;"><b><u>Data:</u></b></p>
<input type="text" name="key" id="key" placeholder ="Enter the key">
 <input type="text" name="value" id="value" placeholder ="Enter the value">
<input type="button" value="Add" name="adddatabutton" style="position: relative;" id="adddatabutton"/>
<br><br><b><span id ="keyspan" style="padding-left: 140px;display: none;color:white;"><u>Key</u></span></b>
</div>
<div id="datacontainer" style="float: right; position:relative ; margin: 0px auto 0px auto;padding: 0px 0px 0px 0px; clear:both;right: 305px;"></div>




<div id="container"></div>
<script>
var isURL = false;
$('#dropdownlist').change(function () {
    var selection = this.value; //grab the value selected
    if (selection == "Custom Key"){
    	alert("Selected is:" +selection)
    	$('#adddata').show();  
    	$("#value").toggle();
    	isURL = false;
    }
    else if(selection=="Key as web URL"){
    	alert("Selected is:" +selection)
    	$('#adddata').show();  
    	$("#value").toggle();
    	isURL = true;
    } else if(selection=="Download Detailed Report"){
        alert("hi");
		alert("check");
		//var url3 = "http://192.168.56.1:8080/RedisCacheWebServer/redis/redisService/clusterSummary/cluster1";
		var url3 = "http://localhost:8080/RedisCacheWebServer/redis/redisService/clusterDetailed/" + clusterName;
		alert(url3);

		$.get(url3, function(data, status){
//		    alert(data);
		   // var obj = jQuery.parseJSON(data);
		    if(data.status == "failure"){
		    	alert(data.exceptionMsg);	
		    } else{
		    	var requiredjson = ' [';
		    	var text = "";
		    	var requiredtext = "";
		    	for (i = 0; i < data.keyDistribution.length; i++) {
//		    	    text += 'Node '+i+':{ "' +'"IpAddress:"'+ data.keyDistribution[i].ipAddress + '". Port: "' + data.keyDistribution[i].port + ". noOfKeys:" +data.keyDistribution[i].noOfKeys +". }";
		    	    requiredjson+= '{' +'"IpAddress":"'+ data.keyDistribution[i].ipAddress    +  '", "port":'+ data.keyDistribution[i].port    +  ', ';
		    	    for(j = 0; j < data.keyDistribution[i].data.length; j++){   
//		    	    	text += "Key "+j+": " + data.keyDistribution[0][i].data[j].key +  ". Value "+j+": " + data.keyDistribution[0][i].data[j].value ;
		//    	    	requiredjson += "Key: " + data.keyDistribution[0][i].data[j].key +  ". Value: " + data.keyDistribution[0][i].data[j].value + ". -->" ;
//		    	    	requiredjson += '"Key'+j+'": "' + data.keyDistribution[i].data[j].key +  '", "Value'+j+'": "' + data.keyDistribution[i].data[j].value + '",' ;
	
				requiredtext += ''+data.keyDistribution[i].data[j].key +  ': ' + data.keyDistribution[i].data[j].value + '||' ;
		    	    	console.log(requiredjson);
			    		 }
		    	    
		//remove this
		//requiredtext = requiredtext.replace(/,\s*$/, "");
			    	
		    	   // requiredjson += '"Key:Value":"' + data.keyDistribution[i].data[j].key +  ': ' + data.keyDistribution[i].data[j].value + '",' ;
		    	    requiredjson += '"Key:Value":"' + requiredtext+'"';
		    	    requiredtext = "";
			//remove this    	    
		    	    requiredjson = requiredjson.replace(/,\s*$/, "");
			    	
		    	    requiredjson += "},";
		    	}
		    	//jason1
		    	requiredjson = requiredjson.replace(/,\s*$/, "");
		    	requiredjson += '] ';

		    	var array = JSON.parse("[" + requiredjson + "]");

		    	alert(requiredjson);
		    	var csvContent = "data:text/csv;charset=utf-8,";

		    	// Iterating through 0th index element as it contains all the objects
		    	array[0].forEach(function (infoArray, index) {

		    	  // Fetching all keys of a single object
		    	  var _keys = Object.keys(infoArray);
		    	  var dataString = [];

		    	  if(index==0){
		    	     [].forEach.call(_keys, function(inst, i){
		    	        dataString.push(inst);
		    	     });
		    	     dataString = dataString.join(",");
		    	     csvContent += index < array[0].length ? dataString + "\n" : dataString;
		    	     dataString = [];
		    	  }

		    	  [].forEach.call(_keys, function(inst, i){
		    	    dataString.push(infoArray[inst]);
		    	  });

		    	  // From here the code is same.
		    	  dataString = dataString.join(",");
		    	  csvContent += index < array[0].length ? dataString + "\n" : dataString;

		    	});
		    	var encodedUri = encodeURI(csvContent);
		    	window.open(encodedUri);
		    	var encodedUri = encodeURI(csvContent);
		    	var link = document.createElement("a");
		    	link.setAttribute("href", encodedUri);
		    	link.setAttribute("download", "RedisReport.csv");

		    	link.click();
		    	

		    	
		    	
		    	console.log(text);
		    }	    
		});

        //end
    } else if(selection=="Download Report"){
    	
    	//jason1
    		alert("check");
	//var url3 = "http://192.168.56.1:8080/RedisCacheWebServer/redis/redisService/clusterSummary/cluster1";
	var url3 = "http://localhost:8080/RedisCacheWebServer/redis/redisService/clusterSummary/" + clusterName;
	alert(url3);

	$.get(url3, function(data, status){
//	    alert(data);
	   // var obj = jQuery.parseJSON(data);
	    if(data.status == "failure"){
	    	alert(data.exceptionMsg);	
	    } else{
	    	var requiredjson = ' [';
	    	var text = "";
	    	for (i = 0; i < data.keyDistribution.length; i++) {
//	    	    text += 'Node '+i+':{ "' +'"IpAddress:"'+ data.keyDistribution[i].ipAddress + '". Port: "' + data.keyDistribution[i].port + ". noOfKeys:" +data.keyDistribution[i].noOfKeys +". }";
	    	    requiredjson+= '{' +'"IpAddress":"'+ data.keyDistribution[i].ipAddress    +  '", "port":'+ data.keyDistribution[i].port    +  ', "noOfKeys":"'+ data.keyDistribution[i].noOfKeys    +  '"}, ';
	    	}
	    	requiredjson = requiredjson.replace(/,\s*$/, "");
	    	requiredjson += '] ';

	    	var array = JSON.parse("[" + requiredjson + "]");
var dataarray = JSON.parse("[" + requiredjson + "]");
	    	alert(requiredjson);
	    	var csvContent = "data:text/csv;charset=utf-8,";

	    	// Iterating through 0th index element as it contains all the objects
	    	array[0].forEach(function (infoArray, index) {

	    	  // Fetching all keys of a single object
	    	  var _keys = Object.keys(infoArray);
	    	  var dataString = [];

	    	  if(index==0){
	    	     [].forEach.call(_keys, function(inst, i){
	    	        dataString.push(inst);
	    	     });
	    	     dataString = dataString.join(",");
	    	     csvContent += index < array[0].length ? dataString + "\n" : dataString;
	    	     dataString = [];
	    	  }

	    	  [].forEach.call(_keys, function(inst, i){
	    	    dataString.push(infoArray[inst]);
	    	  });

	    	  // From here the code is same.
	    	  dataString = dataString.join(",");
	    	  csvContent += index < array[0].length ? dataString + "\n" : dataString;

	    	});
	    	var encodedUri = encodeURI(csvContent);
	    	window.open(encodedUri);
	    	var encodedUri = encodeURI(csvContent);
	    	var link = document.createElement("a");
	    	link.setAttribute("href", encodedUri);
	    	link.setAttribute("download", "RedisReport.csv");

	    	link.click();
	    	

	    	
	    	
	    	console.log(text);
	    }
	});


    	//jason1
    	//$('#adddata').hide();
    	// Put comments here
    	var keyDistribution =  [
    	                        [
    	                         {
    	                           "port": 4444,
    	                           "ipAddress": "52.35.15.121",
    	                           "data": [
    	                                    {
    	                                      "value": "klzkjvljxvc",
    	                                      "key": "skdjfsldfjl"
    	                                    }
    	                                  ],
    	                           "noOfKeys": 1
    	                         },
    	                         {
    	                           "port": 2222,
    	                           "ipAddress": "52.35.15.121",
    	                           "noOfKeys": 1
    	                         },
    	                         {
    	                           "port": 3333,
    	                           "ipAddress": "52.35.15.121",
    	                           "data": [
    	                                    {
    	                                      "value": "klzkjvljxvc",
    	                                      "key": "skdjfsldfjl"
    	                                    }
    	                                  ],
    	                           "noOfKeys": 0
    	                         }
    	                       ]
    	                     ];
    	//var data = [["name1", "city1", "some other info"], ["name2", "city2", "more info"]];
    	var csvContent = "data:text/csv;charset=utf-8,";

    	// Iterating through 0th index element as it contains all the objects
    	keyDistribution[0].forEach(function (infoArray, index) {

    	  // Fetching all keys of a single object
    	  var _keys = Object.keys(infoArray);
    	  var dataString = [];

    	  if(index==0){
    	     [].forEach.call(_keys, function(inst, i){
    	        dataString.push(inst);
    	     });
    	     dataString = dataString.join(",");
    	     csvContent += index < keyDistribution[0].length ? dataString + "\n" : dataString;
    	     dataString = [];
    	  }

    	  [].forEach.call(_keys, function(inst, i){
    	    dataString.push(infoArray[inst]);
    	  });

    	  // From here the code is same.
    	  dataString = dataString.join(",");
    	  csvContent += index < keyDistribution[0].length ? dataString + "\n" : dataString;

    	});
    	var encodedUri = encodeURI(csvContent);
    	window.open(encodedUri);
    	var encodedUri = encodeURI(csvContent);
    	var link = document.createElement("a");
    	link.setAttribute("href", encodedUri);
    	link.setAttribute("download", "RedisReport.csv");

    	link.click();
    	//Put comments here
    }
});

var i=0;
var ipaddressreadonly ="ipaddressreadonly";
var portaddressreadonly ="portaddressreadonly";
var removebuttonreadonly ="removebuttonreadonly";
var noOfReplicasReadOnly ="noOfReplicasReadOnly";
var circle = null;
$("#addnodebutton").click(function(){

	/*
	$('#ipspan').show();
	$('#portspan').show();
	$('#replicaspan').show();
*/	
var ipaddress = $('#ipaddress').val();
	var port = $('#port').val();
var noOfReplicas =$('#noOfReplicas').val();
	var s = '{"ipaddress":"jason", "port":"jason@hotmail.com"}';
	//var s2 = '{"clusterName": "'+clusterName+'", "ipAddress":"52.35.15.121", "port":1111, "noOfReplicas":2}';
	var s2 = '{"clusterName": "'+clusterName+'", "ipAddress":"'+ipaddress+'", "port":'+port+', "noOfReplicas":'+noOfReplicas+'}';
alert(s2);
	//$('#container').append("<div id ='"+i+"'> <input type='text' name='"+ipaddressreadonly+i+"' id='"+ipaddressreadonly+i+"' value ='"+$('#ipaddress').val()+"' readonly='readonly'> <input type='text' name='"+portaddressreadonly+i+"' id='"+portaddressreadonly+i+"' value ='"+$('#port').val()+"' readonly='readonly'><button name='removebuttonreadonly' style= 'padding-left:10px;'id='removebuttonreadonly' style='position: absolute;' onclick='myFunction("+i+")'>-</button><br></div>");
	
$.ajax({
	    url: 'http://localhost:8080/RedisCacheWebServer/redis/redisService/addNode/',
	    dataType: 'text',
	    //dataType: 'text',
	    type: 'post',
	    //contentType: 'application/x-www-form-urlencoded',
	  //  contentType: 'application/json',
	    contentType: 'application/json',
//	    data: JSON.stringify({ "clustername": "clusterJson", "ipAddress":"127.0.0.1", "port":54 }),
	    data: s2,
	    success: function( data, textStatus, jQxhr ){
	    alert(data);
	    
	    var obj = jQuery.parseJSON(data);
	    //alert(obj.status);
	    //alert(obj.status== "failure");
	    if(obj.status == "failure"){
	    	alert(obj.exceptionMsg);	
	    } else{
	    	alert("Number of keys moved: " + obj.noOfKeysMoved);
	    	console.log(data);
	    	console.log(obj.listOfKeysAdded);
	    	$('#ipspan').show();
	    	$('#portspan').show();
	    	$('#replicaspan').show();

	    	$('#container').append("<div id ='"+i+"'> <input type='text'  name='"+ipaddressreadonly+i+"' id='"+ipaddressreadonly+i+"' value ='"+$('#ipaddress').val()+"' readonly='readonly'> <input type='text' name='"+portaddressreadonly+i+"' id='"+portaddressreadonly+i+"' value ='"+$('#port').val()+"' readonly='readonly'> <input type='text' name='"+noOfReplicasReadOnly+i+"' id='"+noOfReplicasReadOnly+i+"' value ='"+$('#noOfReplicas').val()+"' readonly='readonly'><input type='button' value='Delete' name='removebuttonreadonly' style= 'padding-left:10px;'id='"+removebuttonreadonly+i+"' style='position: absolute;' onclick='myFunction("+i+")'/><br></div>");
			$("#container").append(" ");
			$("#container").append(" ");
			$("#container").append(" ");
			i++;
			
	    	$.each(obj.listOfKeysAdded, function (value2, key) {
	            alert("value : "+ value2 + " Key: " + key);
	        });
	    	
	    }
	   	
	    var str = '{"ipaddress": "20.10.10.10", "port": "7080", "replica": "3","keylist":[{"name":"savio","value":"value1" },{"name":"jason","value":"Smith" },{"name":"Peter","value":"Jones" }]}';

	    

	//   	var obj = jQuery.parseJSON(str);
	  // 	alert(obj);
	   	
	    //start here
	/*	$('#container').append("<div id ='"+i+"'> <input type='text'  name='"+ipaddressreadonly+i+"' id='"+ipaddressreadonly+i+"' value ='"+$('#ipaddress').val()+"' readonly='readonly'> <input type='text' name='"+portaddressreadonly+i+"' id='"+portaddressreadonly+i+"' value ='"+$('#port').val()+"' readonly='readonly'> <input type='text' name='"+noOfReplicasReadOnly+i+"' id='"+noOfReplicasReadOnly+i+"' value ='"+$('#noOfReplicas').val()+"' readonly='readonly'><input type='button' value='Delete' name='removebuttonreadonly' style= 'padding-left:10px;'id='"+removebuttonreadonly+i+"' style='position: absolute;' onclick='myFunction("+i+")'/><br></div>");
		$("#container").append(" ");
		$("#container").append(" ");
		$("#container").append(" ");
		i++;
*/		
//end here
	    
	    },
	    error: function( jqXhr, textStatus, errorThrown ){
	    	alert("An error occurred: "+errorThrown +"<"+  textStatus +""+ jqXhr);
	    }
	});


});
//end


var keyreadonly ="ipaddressreadonly";

var j =100;
var keyreadonly ="keyreadonly";
var valuereadonly ="valuereadonly";
var removebuttonreadonly ="removebuttonreadonly";
//var val1;
$("#adddatabutton").click(function(){
	alert("Plus selected");
	$('#keyspan').show();
	var key1 = $('#key').val();
	 val1 = $('#value').val();
	alert("IS URL" + isURL);
//start of jax jason1
//var s2 = {"clusterName":"cluster1","key":"hello", "value":"world"}
var s2 = '{"clusterName": "'+clusterName+'", "key":"'+key1+'", "value":"'+val1+'","isURL":"'+isURL+'"}';
alert(s2);
$.ajax({
	    url: 'http://localhost:8080/RedisCacheWebServer/redis/redisService/insertData/',
	    dataType: 'text',
	    //dataType: 'text',
	    type: 'post',
	    //contentType: 'application/x-www-form-urlencoded',
	  //  contentType: 'application/json',
	    contentType: 'application/json',
	    //data: JSON.stringify({ "clustername": "Cluster1", "ipAddress":"127.0.0.1", "port":"1234", "noOfReplicas":"3" }),
	    data: s2,
	    success: function( data, textStatus, jQxhr ){
	    alert(data);
	    
	    var obj = jQuery.parseJSON(data);
	    if(obj.status == "failure"){
	    	alert(obj.exceptionMsg);	
	    } else{
	    	alert("Data added successfully to IP Address: " + obj.destIPAddress + " Port: "+obj.port);

	    	$('#datacontainer').append("<div id ='"+j+"' style='float: right; position:relative ; margin: 0px auto 0px auto;padding: 0px 0px 0px 0px; clear:both;'> <input type='text' style='width:270px;' name='"+keyreadonly+j+"' id='"+keyreadonly+j+"' value ='"+$('#key').val()+"' readonly='readonly'> <input type='button' value='Delete' name='removedatabuttonreadonly' id='removedatabuttonreadonly' style='position: relative;' onclick='mydataremovefunction("+j+")'/><br></div>");
			$("#datacontainer").append(" ");
			$("#datacontainer").append(" ");
			$("#datacontainer").append(" ");
			j--;

		    }
	    },
	    error: function( jqXhr, textStatus, errorThrown ){
	    	alert("An error occurred during deletion of data: "+errorThrown +"<"+  textStatus +""+ jqXhr);
	    }
	});



//end of jax
delete val1;
});

function myFunction(buttonid) {
	//alert("Remove clicked");
	alert(buttonid);
	var elementipChosen = "#ipaddressreadonly"+buttonid+"";
	alert(elementipChosen);
	var elementportChosen = "#portaddressreadonly"+buttonid+"";
	alert(elementportChosen);
	var ipvalue = $(elementipChosen).val();
	var portvalue = $(elementportChosen).val();
	//var ipvalue = $('#' +elementChosen+'').val();
	 
		alert(ipvalue);

	alert(portvalue);


	var s2 = '{"clusterName": "'+clusterName+'", "ipAddress":"'+ipvalue+'", "port":'+portvalue+'}';
	alert("s2"+s2);
	//var s2 = '{"clusterName": "'+clusterName+'", "ipAddress":"52.35.15.121", "port":3333}';
//start
$.ajax({
	    url: 'http://localhost:8080/RedisCacheWebServer/redis/redisService/deleteNode/',
	    dataType: 'text',
	    //dataType: 'text',
	    type: 'post',
	    //contentType: 'application/x-www-form-urlencoded',
	  //  contentType: 'application/json',
	    contentType: 'application/json',
//	    data: JSON.stringify({ "clustername": "clusterJson", "ipAddress":"127.0.0.1", "port":54 }),
	    data: s2,
	    success: function( data, textStatus, jQxhr ){
	    alert(data);
	    
	    var obj = jQuery.parseJSON(data);
	    //alert(obj.status);
	    //alert(obj.status== "failure");
	    if(obj.status == "failure"){
	    	alert(obj.exceptionMsg);	
	    } else{
	    	alert("Node deleted successfully");
	    	alert("List of keys moved: " + obj.noOfKeysMoved);
	    	document.getElementById(buttonid).style.display = 'none';

	    }

	    },
	    error: function( jqXhr, textStatus, errorThrown ){
	    	alert("An error occurred: "+errorThrown +"<"+  textStatus +""+ jqXhr);
	    }
	});
//end
}


function mydataremovefunction(buttonid) {
	var keyChosen = "#keyreadonly"+buttonid+"";
	var elementportChosen = "#portaddressreadonly"+buttonid+"";
	var ipvalue = $(keyChosen).val();
	var portvalue = $(elementportChosen).val();
	var s2 = '{"clusterName": "'+clusterName+'", "ipAddress":"'+ipaddress+'", "port":"'+port+'", "noOfReplicas":3}';
	
//start
var keysample = "hello";
var url2 = "http://localhost:8080/RedisCacheWebServer/redis/redisService/deleteData/" + clusterName + "/" + ipvalue;
alert(url2);
$.get(url2, function(data, status){
		        alert(data);
		       // var obj = jQuery.parseJSON(data);
			    if(data.status == "failure"){
			    	alert(data.exceptionMsg);	
			    } else{
			    	alert(data.status);
			    }
});
//end

	//document.getElementById('span#' + buttonid).style.display = 'none';
	document.getElementById(buttonid).style.display = 'none';
}

/*$('#container').click(function(){
alert($(this));

}); */

$('#summarybutton').click(function(){
	alert("check");
	//var url3 = "http://192.168.56.1:8080/RedisCacheWebServer/redis/redisService/clusterSummary/cluster1";
	var url3 = "http://localhost:8080/RedisCacheWebServer/redis/redisService/clusterSummary/" + clusterName;
	alert(url3);

	$.get(url3, function(data, status){
//	    alert(data);
	   // var obj = jQuery.parseJSON(data);
	    if(data.status == "failure"){
	    	alert(data.exceptionMsg);	
	    } else{
	    	var text = "";
	    	for (i = 0; i < data.keyDistribution[0].length; i++) {
	    	    text += "Node "+i+":{ " +"IpAddress:"+ data.keyDistribution[0][i].ipAddress + ". Port: " + data.keyDistribution[0][i].port + ". noOfKeys:" +data.keyDistribution[0][i].noOfKeys +". }";
	    	}
	    	alert(text);
	    	console.log(text);
	    }
	});

	});

$('#detailedreportbutton').click(function(){
	alert("check");
	//var url3 = "http://192.168.56.1:8080/RedisCacheWebServer/redis/redisService/clusterSummary/cluster1";
	var url3 = "http://localhost:8080/RedisCacheWebServer/redis/redisService/clusterDetailed/" + clusterName;
	alert(url3);

	$.get(url3, function(data, status){
//	    alert(data);
	   // var obj = jQuery.parseJSON(data);
	    if(data.status == "failure"){
	    	alert(data.exceptionMsg);	
	    } else{
	    	var text = "";
	    	for (i = 0; i < data.keyDistribution[0].length; i++) {
	    	    text += "Node "+i+":{ " +"IpAddress:"+ data.keyDistribution[0][i].ipAddress + ". Port: " + data.keyDistribution[0][i].port + ". [";
	    		 for(j = 0; j < data.keyDistribution[0][i].data.length; j++){   
//		    	    	text += "Key "+j+": " + data.keyDistribution[0][i].data[j].key +  ". Value "+j+": " + data.keyDistribution[0][i].data[j].value ;
		    	    	text += "Key: " + data.keyDistribution[0][i].data[j].key +  ". Value: " + data.keyDistribution[0][i].data[j].value + ". -->" ;
	    		 }
	    	 text += "]";
	    	}
	    	alert(text);
	    }
	});

	});



var clusterName = "";
$(button1).click(function(){
    //alert("The button was clicked.");
    //alert($('#clustername').val());
    clusterName = $('#clustername').val();
    //jason
    var urlforcreatecluster = "http://localhost:8080/RedisCacheWebServer/redis/redisService/createCluster/"+clusterName;
    $.ajax({
	    url: urlforcreatecluster,
	    dataType: 'text',
	    //dataType: 'text',
	    type: 'post',
	    //contentType: 'application/x-www-form-urlencoded',
	  //  contentType: 'application/json',
	    contentType: 'text/plain',
//	    data: JSON.stringify({ "clustername": "clusterJson", "ipAddress":"127.0.0.1", "port":54 }),
	    data: "",
	    success: function( data, textStatus, jQxhr ){
	    alert(data);
	    var obj = jQuery.parseJSON(data);
	    if(obj.status == "failure"){
	    	alert(obj.exceptionMsg);	
	    } else{
	    	//alert("Success");
	    	$('#clusterlabelname').val(clusterName);
	        $('#clusterlabelname').attr('readonly','readonly');
	        $('#dropdownlist').show();
	        $('#createCluster').hide();
	    	$('#id1').show();
	    	$('#showclusterdata').show();
	    	$('#adddata').show();

	    }
	   	
	  	    },
	    error: function( jqXhr, textStatus, errorThrown ){
	    	alert("An error occurred: "+errorThrown +"<"+  textStatus +""+ jqXhr);
	    }
	});
	
});

</script>

</body>
</html>
