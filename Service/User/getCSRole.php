<?php
	
	header('Content-Type: application/json; charset=utf-8');
	
	require_once('../bridge_file.php');

	$result = User::getUserByRole("Admin");
	if(count($result) == 0) {

		$return['message'] = "Empty";
		$return['status'] = "999";

			echo json_encode($return);
	}else{

		$return['message'] = "SUCCESS";
		$return['status'] = "200";
		$return['userList'] = $result;
		echo json_encode($return);
	}
	

?>