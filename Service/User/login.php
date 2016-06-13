<?php
	

	require_once('../bridge_file.php');

	@$username = $_GET['username'];
	@$password = $_GET['password'];

	if(!isset($username) || !isset($password)){

		echo "Invalid Data";

	}else{

		$result = User::login($username, $password);
		if($result == FALSE) {

			$return['message'] = "FAIL";
			$return['status'] = "304";

			echo json_encode($return);
		}else{


			echo json_encode($result);
		}


	}
	

?>