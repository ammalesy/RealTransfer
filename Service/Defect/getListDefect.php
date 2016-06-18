<?php
	
	require_once('../bridge_file.php');

	@$df_room_id = $_GET['df_room_id'];
	@$db_name = $_GET['db_name'];


	if(!isset($df_room_id)){

		$return['message'] = "Invalid data";
		$return['status'] = "304";
	}else{

		$result = Defect::getDefects($df_room_id, $db_name);
		if(count($result) == 0) {

			$return['message'] = "Empty";
			$return['status'] = "999";
		}else{

			
			$return['message'] = "SUCCESS";
			$return['status'] = "200";	
			$return['defectList'] = $result;
		}
	}
	echo json_encode($return);
	

?>