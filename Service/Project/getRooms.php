<?php
	

	require_once('../bridge_file.php');

	@$building_id = $_GET['building_id'];
	@$db_name = $_GET['db_name'];


	if(!isset($building_id) || !isset($db_name)){

		echo "Invalid Data";

	}else{

		$result = Project::rooms($building_id,$db_name);
		if($result == FALSE) {

			$return['message'] = "FAIL";
			$return['status'] = "304";

			echo json_encode($return);
		}else{


			echo json_encode($result);
		}


	}
	

?>