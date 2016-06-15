<?php
	

	require_once('../bridge_file.php');

	$result = User::getUserByRole("CS");
	if($result == FALSE) {

			$return['message'] = "Empty";
			$return['status'] = "999";

			echo json_encode($return);
	}else{


			echo json_encode($result);
	}
	

?>