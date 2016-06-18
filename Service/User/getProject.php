<?php
	

	require_once('../bridge_file.php');

	@$user_id = $_GET['user_id'];


	if(!isset($user_id)){

		echo "Invalid Data";

	}else{

		$result = User::projects($user_id);
		if($result == FALSE) {

			$return['message'] = "FAIL";
			$return['status'] = "304";

			echo json_encode($return);
		}else{

			$return['message'] = "SUCCESS";
			$return['status'] = "200";
			$return['projectList'] = $result;
			echo json_encode($return);
		}


	}
	

?>