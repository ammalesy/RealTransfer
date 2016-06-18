<?php
	

	require_once('../bridge_file.php');

	@$db_name = $_GET['db_name'];


	if(!isset($db_name)){

		echo "Invalid Data";

	}else{

		$result = Project::buildings($db_name);
		if(count($result) == 0) {

			$return['message'] = "Empty";
			$return['status'] = "999";

			echo json_encode($return);
		}else{

			$return['message'] = "SUCCESS";
			$return['status'] = "200";
			$return['buildingList'] = $result;
			echo json_encode($return);
		}


	}
	

?>