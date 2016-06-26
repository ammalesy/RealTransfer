<?php

	header('Content-Type: application/json; charset=utf-8');

	require_once('../bridge_file.php');
	@$un_id = $_GET['un_id'];
	@$db_name = $_GET['db_name'];


	if(!isset($un_id)){

		$return['message'] = "Invalid data";
		$return['status'] = "304";

	}else{
		$result = User::getUserByUnitID($un_id,$db_name);
		if($result == FALSE) {
			$return['message'] = "Empty";
			$return['status'] = "999";
		}else{

			$return['message'] = "SUCCESS";
			$return['status'] = "200";
			$return['user'] = $result;
		}
	}

	echo json_encode($return);




?>
