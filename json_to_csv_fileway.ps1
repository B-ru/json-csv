# $args = filename like "drillid.json"
cd C:\scripts
if("$args" -match "^([0-9a-zA-Zà-ÿÀ-ß¸¨\-_]+)\.json"){
	$drillid = $matches[1];
	$json = Get-Content "$args" | ConvertFrom-Json;
    	$data = $json.pd;
    	foreach ($jsonArrElem in $data){
        	if($jsonArrElem.id -ne $null){
            		$id = $jsonArrElem.id;
            		$data = $jsonArrElem.data;
            		foreach($dataelem in $data){
                		$dataelem = "$dataelem".Replace(" ",";")            
                		if($dataelem -match "^([0-9]+;[0-9\.]+)"){
                    			$refined_data = $matches[1];
                    			"$drillid;$id;$refined_data"
                		}
            		}
        	}
    	}
} else {
	"error! check filename argument!"
}
