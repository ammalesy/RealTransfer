<?php
	

	require_once('../bridge_file.php');

	@$building_id = $_GET['building_id'];
	@$db_name = $_GET['db_name'];


	if(!isset($building_id) || !isset($db_name)){

		echo "Invalid Data";

	}else{

		$result = Project::rooms($building_id,$db_name);
		if(count($result) == 0) {

			$return['message'] = "Empty";
			$return['status'] = "999";

			echo json_encode($return);
		}else{

			$return['message'] = "SUCCESS";
			$return['status'] = "200";
			$return['roomList'] = $result;
			echo json_encode($return);
		}


	}
	

?>