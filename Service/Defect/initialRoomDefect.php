<?php
	

	require_once('../bridge_file.php');
	// $data_back = json_decode(file_get_contents('php://input'));
	
	
	@$un_id = $_POST['un_id'];
	@$user_id = $_POST['user_id'];
	@$user_id_cs = $_POST['user_id_cs'];
	@$db_name = $_POST['db_name'];
	@$df_check_date = $_POST['df_check_date'];


	if(!isset($un_id) || !isset($user_id) || !isset($db_name)){

		$return['message'] = "Invalid data";
		$return['status'] = "304";
	}else{

		$result = UnitDefect::add($un_id,$user_id,$db_name,$user_id_cs,$df_check_date);
		if($result == FALSE) {

			$return['message'] = "Add Fail";
			$return['status'] = "304";
		}else{

			$return['message'] = "SUCCESS";
			$return['status'] = "200";	
			$return['data'] = $result;
		}
	}
	echo json_encode($return);
	

?>