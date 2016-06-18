<?php

require_once('../bridge_file.php');
@$version = $_GET['version'];

$json = json_decode(file_get_contents("category.json"), true);
if($json['Version'] != $version){
	$json['status'] = "200";
	echo json_encode($json);	
}else{
	$data['status'] = "304";
	echo json_encode($data);
}

?>