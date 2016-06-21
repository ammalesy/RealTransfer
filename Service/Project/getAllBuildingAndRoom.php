<?php
	

	require_once('../bridge_file.php');

	@$db_name = $_GET['db_name'];
	$returnArray = array();

	if(!isset($db_name)){

		echo "Invalid Data";

	}else{

		$result = Project::buildings($db_name);
		if(count($result) == 0) {

			$return['message'] = "Empty";
			$return['status'] = "999";

			echo json_encode($return);
		}else{

			foreach ($result as $building) {
				
				$resultRoom = Project::rooms($building['building_id'],$db_name);
				$building['rooms'] = $resultRoom;

				array_push($returnArray, $building);
			}

			$return['message'] = "SUCCESS";
			$return['status'] = "200";
			$return['buildingList'] = $returnArray;
			echo json_encode($return);
		}


	}
	

?>